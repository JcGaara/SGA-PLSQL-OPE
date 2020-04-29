CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_PROMO3PLAY is

procedure p_asigna_pomo3playcliente(ls_numslc in vtatabslcfac.numslc%type) is

ln_estado   NUMBER;
ls_codsolot solot.codsolot%type;

begin
select codsolot
into ls_codsolot
from solot where numslc=ls_numslc;

ln_estado:=1;  -- estado de la promocion para ese usuario y servicio

  for c_prom in (select b.numslc,
                        b.CODCLI,
                        e.idproducto,
                        d.codsrv,
                        d.codsrvprom,
                        d.limiteaplic,
                        add_months(sysdate, d.limiteaplic) fecfin --REQ-79614 LRG
                   from vtacndcompspcli a,
                        vtatabpspcli_v  b,
                        vtatabcndcom    c,
                        sales.promxsrvcnd     d,
                        vtadetptoenl    e
                  where a.numpsp = b.numpsp
                    and a.idopc = b.idopc
                    and a.idcndcom = c.idcndcom
                    and c.idcndcom = d.idcndcom
                    and e.numslc = b.numslc
                    and e.idproducto = d.idproducto
                    and e.codsrv = d.codsrv
                    and c.idtipo_cndcom = 2
                    and d.estado = 1
                    and b.numslc = ls_numslc
                    and e.numslc = ls_numslc) loop

    insert into promoplayxcliente
      (codsolot, codcli, numslc, codsrv, codsrv_prom, id_producto, fecfin, flgestado, usureg, fecreg)
    values
      (ls_codsolot,
       c_prom.codcli,
       c_prom.numslc,
       c_prom.codsrv,
       c_prom.codsrvprom,
       c_prom.idproducto,
       c_prom.fecfin,    --REQ-79614 LRG
       ln_estado,
       user,
       sysdate);
  end loop;

end;


/**
Procedimiento que actualiza el idproducto y pid_sga del
usuario con promocion

*/
PROCEDURE  P_PROMO3PLAY_INSERTAPRODUCTO(ls_codsolot in solot.codsolot%type,
                                        ls_codcli in solot.codcli%type ,
                                        ls_codsrv in tystabsrv.codsrv%type,
                                        ln_idproducto  in solot.idproducto%type,
                                        ln_pid_sga  in  promoplayxcliente.pid_sga%type,
                                        as_mensaje out varchar2,
                                        al_error out number) IS

ln_cantidad     INTEGER;
v_error       INTEGER;
v_mensaje     varchar2(3000);

BEGIN

    v_error := 0;
    v_mensaje := '';

    SELECT COUNT(*) INTO ln_cantidad
    FROM PROMOPLAYXCLIENTE
    WHERE codsolot = ls_codsolot and
          codcli =  ls_codcli and
          codsrv = ls_codsrv  and
          flgestado =1;

    IF ln_cantidad = 1 THEN

          BEGIN
              UPDATE PROMOPLAYXCLIENTE
                 SET ID_PRODUCTO = ln_idproducto, PID_SGA = ln_pid_sga, fecini=sysdate,  usumod = USER, fecmod = SYSDATE
               WHERE codsolot = ls_codsolot
                 and codcli = ls_codcli
                 and codsrv = ls_codsrv
                 and flgestado = 1;

               COMMIT;

           EXCEPTION
                    WHEN OTHERS THEN
                    ROLLBACK;
                    v_error := SQLCODE;
                    v_mensaje := 'Ocurrió error al actualizar PROMOPLAYXCLIENTE para la SOT : '|| ls_codsolot||' Error:'|| SQLERRM;
           END;

    END IF;

    as_mensaje := v_mensaje;
    al_error   := v_error;

EXCEPTION
      WHEN OTHERS THEN
            v_error := SQLCODE;
            v_mensaje := 'Ocurrió error al actualizar PROMOPLAYXCLIENTE para la SOT : '|| ls_codsolot||' Error:'|| SQLERRM;
            as_mensaje := v_mensaje;
            al_error   := v_error;
        --        GOTO FIN;
    --<<FIN>>
   -- as_mensaje := as_mensaje;
   -- al_proceso := al_proceso;

END;


/**

Fucion que retorna el codigo del servicio asignado por promocion

*/
FUNCTION F_PROMO3PLAY_SRVPROM(ls_codsolot in solot.codsolot%type,
                                ls_codcli in solot.codcli%type ,
                                ls_codsrv in tystabsrv.codsrv%type ,
                                ll_proceso  number --<2.0>
                                ) RETURN VARCHAR2

IS

--ls_codsrvprom  tystabsrv.codsrv%type;
ls_codigo_ext TYSTABSRV.CODIGO_EXT%TYPE;
ls_cod_ext TYSTABSRV.CODIGO_EXT%TYPE;
l_tiposervicio configuracion_itw.tiposervicioitw%type;--<2.0>

BEGIN
--<2.0
/*    SELECT T.CODIGO_EXT --CODSRV_PROM
    into ls_cod_ext
    --into ls_codigo_ext
    FROM PROMOPLAYXCLIENTE P, TYSTABSRV T
    WHERE P.CODSOLOT=  ls_codsolot AND
          P.CODCLI  = ls_codcli AND
          --P.CODSRV  = ls_codsrv AND
          P.FLGESTADO =1 AND
          P.CODSRV_PROM = T.CODSRV AND
          P.CODSRV = ls_codsrv; -- AND
        --  P.fecini = SYSDATE AND
        --  P.FECREG = SYSDATE AND
        --  P.USUREG = USER      ;

  if ls_cod_ext is null then

          SELECT T.CODIGO_EXT
          INTO ls_codigo_ext
          FROM TYSTABSRV T
          WHERE T.CODSRV = ls_codsrv;
  else
          ls_codigo_ext :=ls_cod_ext;
  end if;


RETURN ls_codigo_ext; --ls_codsrvprom ;

   EXCEPTION
      WHEN OTHERS THEN
          SELECT T.CODIGO_EXT
          INTO ls_codigo_ext
          FROM TYSTABSRV T
          WHERE T.CODSRV = ls_codsrv;
      RETURN ls_codigo_ext;*/
  select t.tiposervicioitw, t.codigo_ext into
  l_tiposervicio ,ls_cod_ext
  from configuracion_itw t, configxservicio_itw c, configxproceso_itw p
 where codsrv =ls_codsrv
   and c.idconfigitw = c.idconfigitw
   and p.idconfigitw = c.idconfigitw
   and t.idconfigitw = c.idconfigitw
   and p.proceso = ll_proceso;

 IF l_tiposervicio=1 THEN
   BEGIN
      select   n.codigo_ext
        into ls_codigo_ext
        from configuracion_itw   c,
             configxproceso_itw  p,
             ncosxdepartamento   n,
             configxservicio_itw s,
             solotpto            t,
             v_ubicaciones       v
       where c.idconfigitw = p.idconfigitw
         and p.proceso = ll_proceso
         and c.idconfigitw = s.idconfigitw
         and s.codsrv =ls_codsrv
         and s.codsrv=t.codsrvnue
         and c.idncos = n.idncos
         and t.codubi = v.codubi
         and t.codsolot =ls_codsolot
         and v.codest = trim(n.codest);

   EXCEPTION
      WHEN OTHERS THEN
        ls_codigo_ext:=ls_cod_ext;
    END;
 ELSE
      ls_codigo_ext:=ls_cod_ext ;
 END IF;
     RETURN ls_codigo_ext;
 /*   SELECT T.CODIGO_EXT --CODSRV_PROM
    into ls_cod_ext
    --into ls_codigo_ext
    FROM PROMOPLAYXCLIENTE P, TYSTABSRV T
    WHERE P.CODSOLOT=  ls_codsolot AND
          P.CODCLI  = ls_codcli AND
          --P.CODSRV  = ls_codsrv AND
          P.FLGESTADO =1 AND
          P.CODSRV_PROM = T.CODSRV AND
          P.CODSRV = ls_codsrv; -- AND
        --  P.fecini = SYSDATE AND
        --  P.FECREG = SYSDATE AND
        --  P.USUREG = USER      ;
*/
--RETURN ls_codigo_ext; --ls_codsrvprom ;
   EXCEPTION
      WHEN OTHERS THEN
          SELECT T.CODIGO_EXT
          INTO ls_codigo_ext
          FROM TYSTABSRV T
          WHERE T.CODSRV = ls_codsrv;
      RETURN ls_codigo_ext;
--2.0>
END;

/**
Procedimiento que sera ejecutado como un  JOB al final de cada dia
para actualizar el codigo de servicio del cliente a la configuracion
inicial(una vez terminado el periodo de promocion)
*/

 PROCEDURE P_ACTUALIZA_PROMOPLAYXCLIENTE(as_mensaje out varchar2,
                                        al_proceso out number) IS

 ls_resultado    VARCHAR(200);

 p_resultado    VARCHAR(200);
 p_mensaje      VARCHAR(200);
 p_error        VARCHAR(200);
 p_proceso      VARCHAR(200);


 CURSOR C1 IS

     SELECT P.CODSOLOT, I.ID_INTERFASE, I.ID_CLIENTE, I.ID_PRODUCTO, I.ID_PRODUCTO_PADRE, I.PID_SGA,
            I.ID_ACTIVACION,
            --<2.0
            OPERACION.PQ_PROMO3PLAY.F_PROMO3PLAY_SRVPROM(i.codsolot,p.codcli,t.codsrv,al_proceso) codigo_ext
            --T.CODIGO_EXT
            --2.0>
            , p.codsrv, i.nroendpoint, i.numero, P.FECFIN, I.MODELO, i.codinssrv
     FROM PROMOPLAYXCLIENTE P, INT_SERVICIO_INTRAWAY I, TYSTABSRV T
     WHERE FLGESTADO =1
     AND p.codsolot = i.codsolot
     AND P.CODSRV = T.CODSRV
     AND p.id_producto = i.id_producto
     AND p.codcli = i.id_cliente
     AND T.TIPSRV = DECODE ( I.ID_INTERFASE, '620', '0006', '824', '0004', '2020', '0062') ;

 BEGIN
BEGIN
 FOR  REG IN C1 LOOP

     IF (TRUNC(SYSDATE) - TRUNC(REG.FECFIN) = 1) THEN

          IF reg.id_interfase = '620' THEN
          --74836 JR 07/01/2009 Inicio
         /*    INTRAWAY.PQ_INTRAWAY.P_CM_CREA_ESPACIO(2, reg.ID_CLIENTE, REG.id_producto, reg.pid_sga,
             reg.ID_ACTIVACION, reg.codigo_ext,2,3,reg.codsolot, reg.codinssrv, p_resultado, p_mensaje, p_error );*/
             INTRAWAY.PQ_INTRAWAY.P_CM_CREA_ESPACIO(2, reg.ID_CLIENTE, REG.id_producto, reg.pid_sga,
             reg.ID_ACTIVACION, reg.codigo_ext,2,3,reg.codsolot, reg.codinssrv, p_resultado, p_mensaje, p_error, reg.modelo, reg.numero );
          --74836 JR 07/01/2009 Fin

          ELSIF reg.id_interfase = '824' THEN
             INTRAWAY.PQ_INTRAWAY.P_MTA_EP_ADMINISTRACION ( 2,  reg.ID_CLIENTE, REG.id_producto, reg.pid_sga,
             reg.id_producto_padre, reg.nroendpoint, reg.numero, reg.codigo_ext, 3,reg.codsolot, reg.codinssrv, p_resultado, p_mensaje, p_error);

          ELSIF reg.id_interfase = '2020' THEN
             PQ_INTRAWAY.P_STB_CREA_ESPACIO(2, reg.ID_CLIENTE, reg.id_producto, reg.pid_sga, reg.ID_ACTIVACION,
             reg.codigo_ext,'BASICO', reg.modelo,'TRUE', 3,reg.codsolot, reg.codinssrv, p_resultado, p_mensaje, p_error );

          END IF;

          IF p_error = 0 THEN

              BEGIN
                 -- Actualiza el estado en la intraway
                  UPDATE PROMOPLAYXCLIENTE P
                  SET    FLGESTADO=0, USUMOD= USER, FECMOD= SYSDATE, FECFIN = SYSDATE
                  WHERE  P.CODSOLOT =  reg.codsolot
                    AND  p.codcli = reg.id_cliente
                    AND  p.codsrv = reg.codsrv
                    AND  p.id_producto = reg.id_producto
                    AND  p.flgestado = 1;

                   COMMIT;

               EXCEPTION
                  WHEN OTHERS THEN
                    ROLLBACK;
                    P_mensaje := 'Error al Actualizar la tabla PROMOPLAYXCLIENTE, al anular la promoción, codsolot:' ||reg.codsolot||' error:'|| sqlerrm;
                    p_error := SQLCODE;
               END;
         END IF;
    END IF;

 END LOOP;
  p_error := 0;
  P_mensaje:='Se actualizaron los registros en la tabla PROMOPLAYXCLIENTE ';

END;

  as_mensaje := P_mensaje;
  al_proceso := p_error;

exception
      when others then
        as_mensaje := sqlerrm;
        al_proceso := SQLCODE;

END;
END;
/


