CREATE OR REPLACE PACKAGE BODy OPERACION.pq_anulacion_bscs IS
/******************************************************************************
   REVISIONES:
     Version  Fecha       Autor                     Solicitado por      Descripcion
     -------  -----       -----                     --------------      -----------
     1.0      06/07/2015  Eduardo Villafuerte       Rodolfo Ayala       PROY-17824 - Anulación de SOT y asignación de número telefónico
     2.0      15/10/2015  Juan Gonzales             Joel Franco         SD-507517  - Regularizacion Anulación de SOT                  
/* ***************************************************************************/

 PROCEDURE p_execute_main (p_tipo int,
                           p_solot  solot.codsolot%TYPE,
                           p_resultado  OUT PLS_INTEGER,
                           p_msg      OUT VARCHAR2) IS
  BEGIN
    
  IF p_tipo = 2 or p_tipo = 1 THEN
     p_anula_hfc_sga(p_solot,p_tipo,p_resultado,p_msg);
  ELSIF p_tipo = 3 THEN 
     p_anula_hfc_sisact(p_solot,p_resultado,p_msg);
  else 
    p_resultado:=1;
  END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise;
  END;
------------------------------------------------------------------------------------------
PROCEDURE p_anula_hfc_sisact (p_solot  solot.codsolot%TYPE,
                              p_resultado  OUT PLS_INTEGER,
                              p_msg      OUT VARCHAR2) IS

   ln_codcli  solot.codcli%TYPE;
   ln_customer_id number;
   ln_resultado_bscs int;
   ln_resultado_iw int;
   ln_msg_bscs VARCHAR(1000);
   ln_msg_iw VARCHAR(1000);
   ln_msg_log VARCHAR(1000);
   ln_err_bscs INT;
   ln_err_iw INT;
   ln_err_log INT;
   ln_tip_lib NUMBER;
   ln_cod_id solot.cod_id%type;
   ln_resultado_janus int;
   ln_msg_janus VARCHAR(1000);
   ln_err_janus INT;

  BEGIN

   ln_err_bscs:= 0;
   ln_err_iw:= 0;
   ln_err_janus:= 0;

   ln_tip_lib := f_config_bscs('ANUL_SOT');

    select s.customer_id, s.codcli, s.cod_id
        INTO ln_customer_id, ln_codcli, ln_cod_id
        from solot s
       where s.codsolot = p_solot;
             
    p_anula_iw(p_solot,ln_resultado_iw,ln_msg_iw);
    IF ln_resultado_iw <> 1 THEN -- error en IW 2.0
       p_registra_log(0,ln_cod_id,p_solot,'B',ln_msg_iw,ln_customer_id,sysdate,ln_msg_log,ln_err_log);
       ln_err_iw:= ln_err_iw+1;
       p_resultado := ln_resultado_iw;
       p_msg := ln_msg_iw;
    ELSE 
       -- p_anula_janus(p_solot,ln_customer_id,ln_cod_id,ln_resultado_janus,ln_msg_janus); 
       operacion.pq_sga_iw.p_ejecutar_baja_janus(p_solot,ln_resultado_janus, ln_msg_janus); --2.0
        IF ln_resultado_janus <> 1 THEN --error en janus 2.0
           p_registra_log(0,ln_cod_id,p_solot,'D',ln_msg_janus,ln_customer_id,sysdate,ln_msg_log,ln_err_log);
           ln_err_janus:= ln_err_janus+1;
           p_resultado := ln_resultado_janus;
           p_msg := ln_msg_janus; 
        ELSE
          p_anula_bscs(ln_cod_id,ln_tip_lib,ln_resultado_bscs,ln_msg_bscs);
          IF ln_resultado_bscs <> 1 THEN --error en bscs
             p_registra_log(0,ln_cod_id,p_solot,'A',ln_msg_bscs,ln_customer_id,sysdate,ln_msg_log,ln_err_log);
             ln_err_bscs:= ln_err_bscs+1;
             p_resultado := ln_resultado_bscs;
             p_msg := ln_msg_bscs;
          END IF;
        END IF;
    END IF;
    IF ln_err_bscs = 0 and ln_err_iw = 0 and ln_err_janus= 0 THEN
        p_resultado:=1;
    END IF;
    exception
    WHEN OTHERS THEN
      p_resultado := -1;
      p_msg   := SQLERRM;
  END;
------------------------------------------------------------------------------------------
PROCEDURE p_anula_hfc_sga(p_solot  solot.codsolot%TYPE,
                          p_tipo  number,
                          p_resultado  OUT PLS_INTEGER,
                          p_msg      OUT VARCHAR2) IS
   ln_codcli  solot.codcli%TYPE;
   ln_resultado_iw int;
   lv_msg_iw VARCHAR(1000);
   ln_msg_log VARCHAR(1000);
   ln_err INT;
   ln_err_log INT;
   ln_alinea_janus INT;
   ln_msg_janus VARCHAR(1000);
   ln_cliente_janus INT;
                              
  BEGIN
   
   ln_err:= 0; 
   
   SELECT s.codcli into ln_codcli FROM solot s WHERE s.codsolot = p_solot;

   if f_sga_srv_activo(p_solot)<>0 then --servicio activo
      p_registra_log(0,null,p_solot,'C','Servicio Activo, cliente :' || ln_codcli ,null,sysdate,ln_msg_log,ln_err_log);
      raise_application_error(-20001,'Servicio se encuentra activo');
   end if;
   
    p_anula_iw(p_solot,ln_resultado_iw,lv_msg_iw);

    IF ln_resultado_iw <> 1 THEN -- error en iw 2.0
       p_registra_log(0,null,p_solot,'B',lv_msg_iw,null,sysdate,ln_msg_log,ln_err_log);
       ln_err := ln_err+1;
       p_resultado := ln_resultado_iw;
       p_msg := lv_msg_iw;
    
    ELSE
      if p_tipo = 1 then -- HFC CE
        operacion.pq_cont_regularizacion.p_ejecutar_baja_janus_ce(p_solot,ln_alinea_janus,ln_msg_janus); --2.0
        --p_bajanumero_janus_sga_ce(p_solot,ln_alinea_janus,ln_msg_janus);--baja numero en janus
      elsif p_tipo = 2 then -- HFC SGA
         operacion.pq_sga_iw.p_ejecutar_baja_janus(p_solot,ln_alinea_janus, ln_msg_janus); --2.0
         --p_bajanumero_janus_sga(p_solot,ln_alinea_janus,ln_msg_janus);--baja numero en janus        
      end if;
      
      IF ln_alinea_janus <>1 THEN --error en JANUS 2.0
          p_registra_log(0,null,p_solot,'D',ln_msg_janus,null,sysdate,ln_msg_log,ln_err_log);
          ln_err:= ln_err+1;
          p_resultado := ln_cliente_janus;
          p_msg := ln_msg_janus;
      END IF;
    END IF;
    
    IF ln_err = 0 THEN
        p_resultado:=1;
    END IF;
    
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise;
  END;
----------------------------------------------------------------------
PROCEDURE p_anula_bscs (p_cod_id solot.cod_id%TYPE,
                        p_tipo_liberacion integer,
                        p_resultado  OUT PLS_INTEGER,
                        p_msg      OUT VARCHAR2) IS
                        
  ln_pendiente_bscs number;


  BEGIN

   ln_pendiente_bscs := f_valida_bscs(p_cod_id);

   IF ln_pendiente_bscs <> -1 THEN
      tim.tim111_pkg_acciones.sp_anula_contrato_bscs@DBL_BSCS70(p_cod_id,
                                                                p_tipo_liberacion,
                                                                p_resultado,
                                                                p_msg);
       IF p_resultado = 0 THEN
          p_resultado:= 1;
       END IF;      
                                                                                                                                                                                                                                        
   ELSE
      p_resultado := -1;
      p_msg       := 'El contrato : '|| p_cod_id ||' esta activo en BSCS';
   END IF;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado:=-1;
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              'Error Procedimiento OPERACION.PQ_ANULACION_BSCS.P_ANULA_BSCS ' || --2.0
                              SQLERRM);
  END;
----------------------------------------------------------------------
PROCEDURE p_anula_iw (p_codsolot  solot.codsolot%TYPE,
                      p_resultado  OUT PLS_INTEGER,
                      p_msg      OUT VARCHAR2) IS
   v_cant1 number; --2.0
                    
   BEGIN
      --INTRAWAY.P_INT_BAJA_TOTAL(p_codsolot,1,p_msg,p_resultado);
     --<ini 2.0>
     select count(1) into v_cant1 from int_transaccionesxsolot where codsolot=p_codsolot;
     
     if (v_cant1>0) then
       update int_transaccionesxsolot r set r.estado=3 where  r.codsolot=p_codsolot;
       update int_solot_itw r1 set r1.estado=3 , r1.flagproc=0 where r1.codsolot=p_codsolot;
       commit;
     end if;

    INTRAWAY.PQ_PROVISION_ITW.P_INT_EJECBAJA(p_codsolot,p_resultado, p_msg,0);

    INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO(p_codsolot,4, p_resultado,p_msg);
    --<Fin 2.0>
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              'Error Procedimiento OPERACION.PQ_ANULACION_BSCS.P_ANULA_IW' || --2.0
                              SQLERRM);
  END;
------------------------------------------------------------------------------------------
  PROCEDURE p_anula_bajas_masivo(p_resultado OUT PLS_INTEGER,
                                 p_msg       OUT VARCHAR2)
  IS
   ln_codsolot solot.codsolot%type;
   ln_codcli solot.codcli%TYPE;
   ln_customer_id NUMBER;
   ln_reg int;
   n_cant_error NUMBER; --2.0
   ln_tip_lib NUMBER;
   ln_cod_id solot.cod_id%type;
   l_fecini  varchar2(30);
   l_fecfin  varchar2(30);
   l_fecant  varchar2(30);
   ln_servicio number;
   ln_libera   number;


   CURSOR c_baja IS
     SELECT DISTINCT p.codsolot, s.customer_id, s.codcli, s.cod_id
      --<INI 2.0>
         FROM solot s, solotpto p, tystabsrv c, producto pr
       WHERE s.codsolot = p.codsolot
         AND p.codsrvnue = c.codsrv
      --<FIN 2.0>
         AND c.idproducto = pr.idproducto
         AND exists
       (SELECT 1
                FROM estsol h
               WHERE h.estsol = s.estsol
                 AND h.tipestsol = 5) --estado anulada
         AND s.numslc IS NOT NULL
         AND not exists (SELECT 1 FROM historico.solot_alineacion_log k where k.codsolot = s.codsolot)
         AND pr.idproducto =
             (SELECT o.codigon
                FROM tipopedd t, opedd o
               WHERE t.tipopedd = o.tipopedd
                 AND T.ABREV = 'IDPRODUCTOCONTINGENCIA'
                 AND o.codigon = pr.idproducto)
         and s.tiptra in (select o.codigon
                            from tipopedd t, opedd o
                           where t.tipopedd = o.tipopedd
                             and t.abrev = 'TIP_TRABAJO')
      --<INI 2.0>
         AND (((trunc(s.fecultest) BETWEEN to_date(l_fecini) AND
            to_date(l_fecfin)) AND l_fecant is null) OR
            (trunc(s.fecultest) = trunc(SYSDATE) - 1 AND l_fecant is not null));
      --<FIN 2.0> 

  BEGIN

  n_cant_error :=0; --2.0

  ln_tip_lib := f_config_bscs('BAJA_MAS');

   SELECT (SELECT o.codigoc
             FROM opedd o
            WHERE o.tipopedd = t.tipopedd
              AND o.abreviacion = 'DIA_INI'AND o.codigon=1),
          (SELECT o.codigoc
             FROM opedd o
            WHERE o.tipopedd = t.tipopedd
              AND o.abreviacion = 'DIA_FIN' AND o.codigon=1),
          (SELECT o.codigoc
             FROM opedd o
            WHERE o.tipopedd = t.tipopedd
              AND o.abreviacion = 'DIA_ANT' AND o.codigon=1)
     INTO l_fecini, l_fecfin, l_fecant
     FROM tipopedd t
    WHERE t.abrev = 'DIA_MASIVO';

  FOR c_lineas IN c_baja LOOP

    ln_codsolot := c_lineas.codsolot;
    ln_customer_id := c_lineas.customer_id;
    ln_codcli := c_lineas.codcli;
    ln_cod_id := c_lineas.cod_id;
    
    p_val_tipo_serv_sot(ln_codsolot,ln_servicio,ln_libera);
    
    IF  ln_servicio = 2 or ln_servicio = 1 THEN 
        p_baja_hfc_sga_masivo(ln_codsolot,ln_servicio,ln_reg);
    elsif ln_servicio = 3 THEN 
        p_baja_hfc_sisact_masivo(ln_codsolot,ln_customer_id,ln_cod_id,ln_tip_lib,ln_reg);
    END IF;
    
    n_cant_error := n_cant_error +ln_reg; --2.0

    if ln_reg > 0 then
      rollback;
    else
      commit;
    end if;
    
  END LOOP;

  IF n_cant_error > 0 THEN --2.0
    p_resultado := -1;
    p_msg := 'Se termino de ejecutar el Proceso con errores. Revisar Tabla HISTORICO.SOLOT_ALINEACION_LOG en la fecha ' || trunc(sysdate) ;
  ELSE
    p_resultado := 1;
    p_msg := 'Se termino de ejecutar el Proceso';
  END IF;

 END;
 ----------------------------------------------------------------------------------------
 PROCEDURE p_baja_hfc_sga_masivo(p_codsolot solot.codsolot%type,
                                 p_tipo number,
                                 p_reg out number)    IS
  
   ln_resultado_iw int;
   ln_msg_iw VARCHAR(1000);
   ln_msg_log VARCHAR(1000);
   ln_err_log number;
   ln_alinea_janus INT;
   ln_msg_janus VARCHAR(1000);
    
  begin
  
    p_reg:= 0; 

    p_anula_iw(p_codsolot,ln_resultado_iw,ln_msg_iw);
    
    IF ln_resultado_iw <> 1 THEN --error en iw 2.0
       p_registra_log(0,null,p_codsolot,'B',ln_msg_iw,null,sysdate,ln_msg_log,ln_err_log);
       p_reg:= p_reg+1;
    ELSE
      if p_tipo = 1 then -- HFC CE
         operacion.pq_cont_regularizacion.p_ejecutar_baja_janus_ce(p_codsolot,ln_alinea_janus,ln_msg_janus); --2.0
        --p_bajanumero_janus_sga_ce(p_codsolot,ln_alinea_janus,ln_msg_janus);--baja numero en janus
      elsif p_tipo = 2 then -- HFC SGA
         operacion.pq_sga_iw.p_ejecutar_baja_janus(p_codsolot,ln_alinea_janus,ln_msg_janus); --2.0
         --p_bajanumero_janus_sga(p_codsolot,ln_alinea_janus,ln_msg_janus);--baja numero en janus        
      end if;
      
      IF ln_alinea_janus <> 1 THEN --Error en JANUS 2.0
          p_registra_log(0,null,p_codsolot,'D',ln_msg_janus,null,sysdate,ln_msg_log,ln_err_log);
          p_reg:= p_reg+1;
      END IF;
    END IF;
    
END;
-------------------------------------------------------------------------------------------
PROCEDURE p_baja_hfc_sisact_masivo(p_codsolot solot.codsolot%type,
                                   p_customer_id solot.customer_id%type,
                                   p_cod_id solot.cod_id%type,
                                   p_tip_lib number,
                                   p_reg out number)  IS
  
   ln_resultado_bscs int;
   ln_resultado_iw int;
   ln_resultado_log int;
   ln_msg_log VARCHAR(1000);
   ln_msg_bscs VARCHAR(1000);
   ln_msg_iw VARCHAR(1000);
   ln_resultado_janus int;
   ln_msg_janus VARCHAR(1000);

  begin
    
    p_reg:=0;
    
    p_anula_iw(p_codsolot,ln_resultado_iw,ln_msg_iw);
    
    IF ln_resultado_iw <> 1 THEN -- error en IW 2.0
       p_reg:=p_reg+1;
       p_registra_log(0,p_cod_id,p_codsolot,'B',ln_msg_iw,p_customer_id,sysdate,ln_msg_log,ln_resultado_log);
    ELSE
      operacion.pq_sga_iw.p_ejecutar_baja_janus(p_codsolot,ln_resultado_janus, ln_msg_janus); --2.0 
      IF ln_resultado_janus <> 1 THEN --2.0
          p_reg:=p_reg+1;
          p_registra_log(0,p_cod_id,p_codsolot,'D',ln_msg_janus,p_customer_id,sysdate,ln_msg_log,ln_resultado_log);
       ELSE 
         p_anula_bscs(p_cod_id,p_tip_lib,ln_resultado_bscs,ln_msg_bscs);
         IF ln_resultado_bscs <> 1 THEN --error en bsc
            p_reg:=p_reg+1;
            p_registra_log(0,p_cod_id,p_codsolot,'A',ln_msg_bscs,p_customer_id,sysdate,ln_msg_log,ln_resultado_log);
         END IF; 
      END IF;
    END IF;
END;
-------------------------------------------------------------------------------------------
 PROCEDURE p_registra_log(p_estado      IN historico.solot_alineacion_log.estado%TYPE,
                          p_cod_id      IN historico.solot_alineacion_log.cod_id%TYPE,
                          p_codsolot    IN solot.codsolot%TYPE,
                          p_tipo        IN historico.solot_alineacion_log.tipo%TYPE,
                          p_descrip     IN historico.solot_alineacion_log.descripcion%TYPE,
                          p_customerid  IN historico.solot_alineacion_log.customer_id%TYPE,
                          p_fec         IN historico.solot_alineacion_log.fecmod%TYPE,
                          p_mensaje     OUT VARCHAR2,
                          p_error       OUT NUMBER) IS

    PRAGMA AUTONOMOUS_TRANSACTION;
    l_solot_alineacion   historico.solot_alineacion_log%ROWTYPE;
    l_idlog              historico.solot_alineacion_log.id_log%TYPE;
    l_codcli  solot.codcli%TYPE;
    l_numslc  solot.numslc%TYPE;


  BEGIN
    --- Se obtiene valores

     SELECT historico.sq_solot_anular_log.nextval into l_idlog from dual;

     --- Se asigna valores

     SELECT codcli, numslc
       INTO l_codcli, l_numslc
       FROM solot
      WHERE codsolot = p_codsolot;

     l_solot_alineacion.id_log         := l_idlog;
     l_solot_alineacion.cod_id         := p_cod_id;
     l_solot_alineacion.codsolot       := p_codsolot;
     l_solot_alineacion.codcli         := l_codcli;
     l_solot_alineacion.numslc         := l_numslc;
     l_solot_alineacion.tipo           := p_tipo;
     l_solot_alineacion.descripcion    := p_descrip;
     l_solot_alineacion.codusu         := USER;
     l_solot_alineacion.fecusu         := SYSDATE;
     l_solot_alineacion.estado         := p_estado;
     l_solot_alineacion.customer_id    := p_customerid;
     l_solot_alineacion.fecmod         := p_fec;
     --- Se registra Log
     BEGIN
       INSERT INTO historico.solot_alineacion_log VALUES l_solot_alineacion;
       p_error := 0;
       p_mensaje := 'Log OK';
     EXCEPTION
       WHEN OTHERS THEN
         p_error := -1;
         p_mensaje := sqlerrm;
     END;
     commit;
  END;
-------------------------------------------------------------------------------------------
FUNCTION f_sga_srv_activo(p_codsolot solot.codsolot%TYPE) RETURN INTEGER IS

    l_existe PLS_INTEGER;
    l_return INTEGER;

  BEGIN
    SELECT COUNT(1)
      INTO l_existe
      FROM solot sol, inssrv ins, insprd inp
     WHERE sol.numslc = ins.numslc
       AND ins.codinssrv = inp.codinssrv
       AND inp.flgprinc = 1
       AND ins.estinssrv = 1
       AND sol.codsolot = p_codsolot;

     IF l_existe <> 0 THEN
       l_return := 1;
     ELSE
       l_return := 0;
     END IF;

    RETURN l_return;
  END;
------------------------------------------------------------------------------------------
FUNCTION f_valida_bscs(p_cod_id solot.cod_id%TYPE) RETURN NUMBER IS

    l_ch_status  varchar2(1);
    l_ch_pending varchar2(1);
    l_return NUMBER;

BEGIN

  l_return :=0;

  SELECT C.CH_STATUS,C.CH_PENDING
    INTO L_CH_STATUS,L_CH_PENDING
    FROM CONTRACT_HISTORY@DBL_BSCS70 C
   WHERE C.CO_ID = P_COD_ID
     AND C.CH_SEQNO = (SELECT MAX(B.CH_SEQNO)
                         FROM CONTRACT_HISTORY@DBL_BSCS70 B
                        WHERE B.CO_ID = C.CO_ID);

     IF L_CH_STATUS = 'o' THEN --estado on hold
        l_return := 1;

     ELSIF L_CH_STATUS = 'a' AND L_CH_PENDING = 'X' THEN --activo con pendiente
           l_return := 2;

     ELSIF L_CH_STATUS='a' AND L_CH_PENDING is null THEN -- activo
       l_return := -1;
     END IF;

    RETURN l_return;

   EXCEPTION WHEN OTHERS THEN
     RETURN 0;
  END;
-------------------------------------------------------------------------------------------
PROCEDURE p_valida_libera_numero(p_codsolot solot.codsolot%type) IS

    CURSOR c_linea IS
    SELECT d.numero , s.customer_id, s.cod_id
              FROM SOLOTPTO A, INSPRD P, TYSTABSRV C, NUMTEL D, PRODUCTO R , SOLOT S
             WHERE a.codsolot = p_codsolot
               AND a.codsolot = s.codsolot
               AND a.codinssrv = d.codinssrv
               AND a.codsrvnue = c.codsrv
               AND a.pid = p.pid
               AND c.tipsrv = '0004'
               AND p.flgprinc = 1
               AND c.idproducto = r.idproducto
               AND r.idtipinstserv = 3
               AND a.pid_old IS NULL;

    l_res_alinea      number;
    l_msg_alinea      varchar2(100);

BEGIN

    for lc_linea in c_linea loop
         p_registra_log(0,lc_linea.cod_id,p_codsolot,'C','El número ' || lc_linea.numero ||' no se pudo Liberar en SGA',lc_linea.customer_id,sysdate,l_msg_alinea,l_res_alinea);
    end loop;

END;
-------------------------------------------------------------------------------------------
FUNCTION f_valida_anulacion RETURN NUMBER IS

    l_cant   NUMBER;
    l_return NUMBER;

BEGIN
    SELECT COUNT(1)
      INTO l_cant
      FROM TIPOPEDD T, OPEDD O
     WHERE T.TIPOPEDD = O.TIPOPEDD
       AND T.ABREV = 'CONFI_ALINEA'
       AND O.CODIGON = 1;

     IF  L_CANT = 1 THEN
         l_return:=1;
     ELSE
        l_return:=0;
     END IF;
    RETURN l_return;

  END;
-------------------------------------------------------------------------------------------
PROCEDURE p_val_tipo_serv_sot(p_codsolot  IN solot.codsolot%type,
                              p_tipo_serv OUT NUMBER,
                              p_resultado OUT NUMBER) IS

begin
  p_resultado := 0;
  
  select distinct xx.codigon_aux
    into p_tipo_serv
    from solot s, 
         solotpto pto,
         tystabsrv ser,
         producto p,
         (select o.codigon, o.codigon_aux
            from tipopedd t, opedd o
           where t.tipopedd = o.tipopedd
             and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx
   where s.codsolot = pto.codsolot 
     and pto.codsrvnue = ser.codsrv
     and ser.idproducto = p.idproducto
     and p.idproducto = xx.codigon
     and pto.codsolot = p_codsolot
     and s.tiptra in (select o.codigon 
                      from tipopedd t, opedd o 
                      where t.tipopedd = o.tipopedd 
                      and t.abrev ='TIP_TRABAJO') ;

exception
  when others then
    p_tipo_serv := 0;
    p_resultado := 1;
END;
-------------------------------------------------------------------------------------------
FUNCTION f_config_bscs(p_tipo varchar2) RETURN NUMBER IS

    ln_tip_lib NUMBER;

BEGIN
    SELECT o.codigon
     INTO ln_tip_lib
     FROM tipopedd t, opedd o
    WHERE t.tipopedd = o.tipopedd
      AND t.abrev = 'RAZON_BSCS_BAJAS'
      AND o.abreviacion = p_tipo;
      
    return ln_tip_lib;
   
END;
-------------------------------------------------------------------------------------------
END pq_anulacion_bscs;
/