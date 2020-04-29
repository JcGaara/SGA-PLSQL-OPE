CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_BAM AS
   /******************************************************************************
  Version     Fecha       Autor            Solicitado por  Descripción.
  ---------  ----------  ---------------   --------------  ---------------------------------
  1.0        23/07/2010  Edilberto Astulle PROY-4316 Banda Ancha Movil
  2.0        03/08/2012  Edilberto Astulle PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
  3.0        28/11/2012  Fernando Canaval  PROY-5780 IDEA-7056 Asociación de líneas BSCS y proyectos SGA.
  4.0        05/11/2012  Fernando Canaval  REQ.163439 Soluciones Post Venta BAM-BAF
  5.0        13/02/2014  Dorian Sucasaca   REQ.164834 IDEA-15650 Proceso de Activaciones HFC y BAM (automatizar)
  6.0        20/05/2014  R Crisostomo      SD 1088607: Corregir problema de visualizacion de Saldos a Favor en SGA ATC
  7.0        22/09/2014  Edson Caqui       SD-57231
  8.0        20/11/2014  R Crisostomo      SD-136375 Alineamiento de suspensiones y reconexiones del servicio BAM entre SGA y BSCS
******************************************************************************/
PROCEDURE p_asig_numtel_movil
  (a_codinssrv number,
   a_numero varchar2)
IS
l_cont number;
l_existe number;
v_imei inssrv.imei%type;
v_simcard inssrv.simcard%type;

BEGIN
   select count(1) into l_existe from  numtel
   where numero =a_numero;
   if l_existe = 0 then
     raise_application_error(-20001,'El número no existe.');
   end if;
   select count(1) into l_cont from  numtel
   where estnumtel = 1 and numero =a_numero;
   if l_cont = 0 then
     raise_application_error(-20001,'El número no esta disponible.');
   end if;
   select imei, simcard into v_imei, v_simcard
   from numtel  where numero = a_numero;
   update inssrv set numero = a_numero , imei = v_imei, simcard =v_simcard
   where codinssrv= a_codinssrv;

   update numtel set estnumtel = 2, fecasg    = sysdate,
   codinssrv = a_codinssrv, codusuasg = user
   where numero = a_numero and tipnumtel = 4;
END;

PROCEDURE p_act_numtelmovil
  (a_numero number,
   a_imei varchar2,
   a_simcard varchar2)
IS
ln_cont number;

BEGIN
--Si el numero no existe se registra en la BD
  select count(1) into ln_cont from numtel where numero = a_numero;
  if ln_cont = 0 then
    insert into numtel(estnumtel,tipnumtel,numero,imei,simcard)
    values(1,4,a_numero,a_imei,a_simcard);
  else
    update numtel set imei = a_imei, simcard = a_simcard
    where numero = a_numero and tipnumtel = 4;
  end if;
END;

--Inicio 2.0
PROCEDURE p_envio_rown
  (n_row number,
   i_mensaje out number,
   o_mensaje out gc_salida)
IS
 l_cont number;
 l_seq_lote_bam number;

 cursor cur_int is
  select t.codsolot, t.idbam
    from operacion.trsbambaf t,
         operacion.inssrv i,
         operacion.tipaccionpv ta
   where t.codinssrv = i.codinssrv
     and t.tipactpv  = ta.idaccpv
     and t.est_envio = C_PENDIENTE
     and ta.origen   = C_COBZA
     and i.customer_id is not null
     and t.idtrancorte is not null --- 5.0
     and t.tipactpv    is not null --- 5.0
     and rownum     <= n_row
   order by t.codsolot;

BEGIN
    select operacion.seq_lote_bam.nextval
      into l_seq_lote_bam from dual;

    select count(1)
      into l_cont
      from operacion.trsbambaf t,
           operacion.inssrv i,
           operacion.tipaccionpv ta
     where t.codinssrv = i.codinssrv
       and t.tipactpv  = ta.idaccpv
       and t.est_envio = C_PENDIENTE
       and ta.origen   = C_COBZA
       and i.customer_id is not null
       and t.idtrancorte is not null --- 5.0
       and t.tipactpv    is not null --- 5.0
       and rownum     <= n_row
    order by t.codsolot;

    IF l_cont > 0 THEN
       FOR c_int in cur_int LOOP
          BEGIN
             update operacion.trsbambaf t
             set    t.est_envio    = C_EJECUCION,
                    t.seq_lote_bam = l_seq_lote_bam,
                    t.fecact       = sysdate
             where  t.codsolot     = c_int.codsolot
             and    t.idbam        = c_int.idbam;
          EXCEPTION
             when others then
                null;
          END;
          commit;
        END LOOP;
        i_mensaje := 1;
    ELSE
        i_mensaje := 0;
    END IF;

    IF i_mensaje = 1 THEN
      OPEN o_mensaje FOR
      select t.idbam,
             i.numero,
             t.codinssrv,
             t.idtrancorte,
             t.feceje,
             t.fecprog,
             t.est_envio,
             t.id_mensaje,
             t.observ,
             t.tiptra,
             l_seq_lote_bam,
             t.codsolot,
             i.co_id,
             i.customer_id,
             i.cust_code,
             i.billcycle,
             i.tipcli,
             t.codusu,
             nvl(t.n_reintentos,0) n_reintentos /*INI 4.0*/,
             t.tipactpv,
             c.ntdide,
             t.nrodias /* FIN 4.0*/
      from   operacion.trsbambaf t,
             operacion.inssrv i,
             operacion.tipaccionpv ta /*INI 4.0*/,
             vtatabcli             c /*FIN 4.0*/
      where  t.codinssrv = i.codinssrv
        and  t.tipactpv  = ta.idaccpv
        and  t.est_envio = C_EJECUCION
        and  ta.origen   = C_COBZA
        and  i.customer_id is not null
        and  i.codcli = c.codcli -- <4.0>
        and  t.seq_lote_bam = l_seq_lote_bam
      order by t.codsolot;
    ELSE
      OPEN o_mensaje FOR
      select null idbam,
             null numero,
             null codinssrv,
             null idtrancorte,
             null feceje,
             null fecprog,
             null est_envio,
             null id_mensaje,
             null observ,
             null tiptra,
             null,
             null codsolot,
             null co_id,
             null customer_id,
             null cust_code,
             null billcycle,
             null tipcli,
             null codusu,
             null n_reintentos /*INI 4.0*/,
             null tipactpv,
             null ntdide,
             null nrodias /*FIN 4.0*/
      from   dual
      where  0=1;

      i_mensaje := 0;
    END IF;

EXCEPTION
   when others then
      OPEN o_mensaje FOR
      select null idbam,
             null numero,
             null codinssrv,
             null idtrancorte,
             null feceje,
             null fecprog,
             null est_envio,
             null id_mensaje,
             null observ,
             null tiptra,
             null,
             null codsolot,
             null co_id,
             null customer_id,
             null cust_code,
             null billcycle,
             null tipcli,
             null codusu,
             null n_reintentos /*INI 4.0*/,
             null tipactpv,
             null ntdide,
             null nrodias /*FIN 4.0*/
      from   dual
      where  0=1;

      i_mensaje := 0;
      rollback;
END;

PROCEDURE p_act_rown
  (l_idbam     number,
   l_error     number,
   l_mensaje   varchar2,
   l_conexion  varchar2,
   o_iderror   out number,
   o_idmensaje out varchar2)
IS

 l_cont           number;
 l_cont1          number;
 n_estado         number;
 n_max_reintentos number;
 n_intentos       number;
 n_idtrancorte    number;
 BEGIN
   n_estado := 0;
   select count(1) into l_cont from operacion.trsbambaf where idbam = l_idbam;
   IF l_cont > 0 THEN
      select count(1) into l_cont1 from operacion.trsbambaf where idbam = l_idbam;
      IF l_cont1 > 0 THEN
          BEGIN
            IF l_error = 1 THEN -- Codigo de Error que retorna el WS
              select nvl(C.IDTRANCORTE, 0)
                into n_idtrancorte
                from operacion.trsbambaf c
               where c.idbam = l_idbam;
            if n_idtrancorte<>0 then
                select a.codigon, nvl(c.n_reintentos,0)
                into   n_max_reintentos, n_intentos
                from   operacion.opedd a, operacion.tipopedd b, operacion.trsbambaf c
                where  b.tipopedd = a.tipopedd
                and    a.codigon_aux = decode(c.idtrancorte,C_RECNX_SUSP,C_SUSP,C_RECNX_CORTE,C_CORTE,c.idtrancorte)
                and    a.abreviacion = C_REINTENTOS
                and    c.idbam = l_idbam;
              else
                select a.codigon, nvl(c.n_reintentos,0)
                into   n_max_reintentos, n_intentos
                from   operacion.opedd a, operacion.tipopedd b, operacion.trsbambaf c
                where  b.tipopedd = a.tipopedd
                and    a.codigon_aux = C_REINTENTOS_PV
                and    a.abreviacion = C_REINTENTOS
                and    c.idbam = l_idbam;
              end if;
              IF n_max_reintentos > n_intentos THEN --Seguir enviando
                 n_estado := C_PENDIENTE;
                 n_intentos := n_intentos + 1;
              ELSE
                 n_estado := C_ERROR;
              END IF;
            ELSIF l_error = 0 THEN -- Codigo de Exito que retorna el WS
               n_estado := C_OK;
            END IF;

          /*INI 4.0*/
          IF l_error = 2 THEN
            n_estado := C_OK_SIN_INTERACC;
          END IF;
          /*FIN 4.0*/

            update operacion.trsbambaf
            set    id_conexion  = l_conexion,
                   id_error     = l_error,
                   id_mensaje   = l_mensaje,
                   fecact       = sysdate,
                   feceje       = sysdate,
                   est_envio    = n_estado,
                   n_reintentos = n_intentos
            where  idbam = l_idbam;

            o_iderror := 1;
            o_idmensaje := 'OK';
            commit;
         EXCEPTION
            when others then
               o_iderror := 0;
               o_idmensaje := 'Error al actualizar :' ||SQLERRM;
         END;
      ELSE
          o_iderror := 0;
          o_idmensaje := 'El comando no fue enviado a BSCS';
      END IF;

   ELSE
      o_iderror := 0;
      o_idmensaje := 'No existen datos a actualizar';
   END IF;

  EXCEPTION
      when others then
          o_iderror := 0;
          o_idmensaje := 'Error :' ||SQLERRM;

  END;

--Inicio 2.0
PROCEDURE p_carga_info_int_bam
  (a_codsolot number)
IS

  l_cont number;
  l_valida number;
  cursor cur_msg_bam is
  select d.codinssrv,e.tiptrs, e.tiptra, trunc(s.feccom) feccom,f.idtrancorte, g.idaccpv
  from   solotpto i, solot s, inssrv d, tiptrabajo e, cxc_instransaccioncorte f, operacion.TIPACCIONPV g
  where i.codsolot = s.codsolot and i.codinssrv=d.codinssrv and f.idtrancorte= g.idtrancorte(+)
  and   s.tiptra = e.tiptra and s.codsolot =a_codsolot
  and   d.tipsrv = C_TIPSRVMOVIL and s.codsolot=f.codsolot(+)  ;

BEGIN
  l_valida :=0;
  for cc_msg in cur_msg_bam loop
     l_valida :=1;
     insert into operacion.trsbambaf(codinssrv,tiptrs,tiptra,codsolot,fecprog, idtrancorte,tipactpv)
     values(cc_msg.codinssrv,cc_msg.tiptrs,cc_msg.tiptra,a_codsolot, cc_msg.feccom,cc_msg.idtrancorte,cc_msg.idaccpv);
  end loop;

 if l_valida = 1 then
    select count(1) into l_Cont from inssrv a, solotpto b
    where a.codinssrv = b.codinssrv
    and a.tipinssrv= 4 and b.codsolot = a_codsolot;
    if l_Cont = 0  then
      --No se tiene INSSRV valido
      null;
    elsif l_cont > 0 then
      null;
    end if;
    commit;
  end if;
EXCEPTION
   when others then
      null;
END;

--INI 7.0
PROCEDURE P_CARGA_INFO_INT_BAM_WF(A_IDTAREAWF IN NUMBER,
                                  A_IDWF      IN NUMBER,
                                  A_TAREA     IN NUMBER,
                                  A_TAREADEF  IN NUMBER) IS
  L_CONT     NUMBER;
  L_VALIDA   NUMBER;
  L_CODSOLOT NUMBER;
  CURSOR CUR_MSG_BAM IS
    SELECT D.CODINSSRV,
           E.TIPTRS,
           E.TIPTRA,
           TRUNC(S.FECCOM) FECCOM,
           IDT.CODIGON_AUX IDTRANCORTE,
           IDA.CODIGON_AUX IDACCPV,
           d.numero
      FROM SOLOTPTO I,
           SOLOT S,
           INSSRV D,
           TIPTRABAJO E,
           (SELECT CODIGON_AUX, CODIGON
              FROM OPEDD
             WHERE ABREVIACION = 'CONF_CORTE'
               AND CODIGOC = 'ACTIVO') IDT,
           (SELECT CODIGON_AUX, CODIGON
              FROM OPEDD
             WHERE ABREVIACION = 'CONF_TIPACT'
               AND CODIGOC = 'ACTIVO') IDA
     WHERE I.CODSOLOT = S.CODSOLOT
       AND I.CODINSSRV = D.CODINSSRV
       AND S.TIPTRA = E.TIPTRA
       AND S.CODSOLOT = L_CODSOLOT
       AND D.TIPSRV = C_TIPSRVMOVIL
       AND S.RECOSI IS NULL
       AND D.TIPINSSRV = 5
       AND E.TIPTRS = IDT.CODIGON
       AND E.TIPTRS = IDA.CODIGON
    UNION ALL
    SELECT D.CODINSSRV,
           E.TIPTRS,
           E.TIPTRA,
           TRUNC(S.FECCOM) FECCOM,
           NULL IDTRANCORTE,
           G.IDACCPV,
           d.numero
      FROM SOLOTPTO                 I,
           SOLOT                    S,
           INSSRV                   D,
           TIPTRABAJO               E,
           ATCCORP.CASEXTIPACCIONPV F,
           OPERACION.TIPACCIONPV    G,
           INCIDENCE                K
     WHERE I.CODSOLOT = S.CODSOLOT
       AND I.CODINSSRV = D.CODINSSRV
       AND F.IDACCPV = G.IDACCPV
       AND S.TIPTRA = E.TIPTRA
       AND S.CODSOLOT = L_CODSOLOT
       AND K.CODINCIDENCE = S.RECOSI
       AND D.TIPSRV = C_TIPSRVMOVIL
       AND F.CODCASE = K.CODCASE
       AND D.TIPINSSRV = 5;
  N_VALIDA  NUMBER;
  V_IDACCPV NUMBER;
BEGIN
  --OBTENER LA CODSOLOT
  SELECT CODSOLOT INTO L_CODSOLOT FROM WF WHERE IDWF = A_IDWF;
  L_VALIDA := 0;
  --LECTURA DE SERVICIOS BAM DE LA SOT
  FOR CC_MSG IN CUR_MSG_BAM LOOP
    L_VALIDA := 1;
    --IDACCPV SI ORIGEN ES ATC
    SELECT COUNT(1)
      INTO N_VALIDA
      FROM ATCCORP.TRANSACCIONES_PV
     WHERE CODSOLOT = L_CODSOLOT;
    IF N_VALIDA <> 0 THEN
      SELECT PV.IDACCPV
        INTO V_IDACCPV
        FROM ATCCORP.TRANSACCIONES_PV PV
       WHERE CODSOLOT = L_CODSOLOT;
      CC_MSG.IDACCPV := V_IDACCPV;
    END IF;
    --INSERTAR REGISTRO DE INTERFAZ A BSCS
    INSERT INTO OPERACION.TRSBAMBAF
      (CODINSSRV,
       TIPTRS,
       TIPTRA,
       CODSOLOT,
       FECPROG,
       IDTRANCORTE,
       TIPACTPV,
       numero)
    VALUES
      (CC_MSG.CODINSSRV,
       CC_MSG.TIPTRS,
       CC_MSG.TIPTRA,
       L_CODSOLOT,
       CC_MSG.FECCOM,
       CC_MSG.IDTRANCORTE,
       CC_MSG.IDACCPV,
       CC_MSG.NUMERO);
  END LOOP;
  IF L_VALIDA = 1 THEN
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
--FIN 7.0

PROCEDURE p_obtener_parametros
  (n_tiptracorte number,
   n_cantreg out number,
   o_paramreg out varchar2)
IS

 cursor c_param(a_desctipo varchar2) is
 select a.abreviacion,nvl(a.codigoc,a.codigon) codigo
 from   opedd a, tipopedd b
 where  b.tipopedd = a.tipopedd
 and    b.abrev = a_desctipo
 order by a.abreviacion;
 ls_desctrs varchar2(30);

BEGIN
  case
    when (n_tiptracorte=C_SUSP or n_tiptracorte=C_RECNX_SUSP) then
        ls_desctrs := C_PARAM_BLOQ;
    when (n_tiptracorte=C_CORTE or n_tiptracorte=C_RECNX_CORTE) then
        ls_desctrs := C_PARAM_SUSP;
    when (n_tiptracorte=C_DESACT) then
        ls_desctrs := C_PARAM_DESAC;
    else
        n_cantreg  := 0;
        o_paramreg := '';
        return;
  end case;

  n_cantreg  := 0;
  o_paramreg := '';
  for r_param in c_param(ls_desctrs) loop
    if n_cantreg = 0 then
      o_paramreg := r_param.abreviacion ||'='|| r_param.codigo;
    else
      o_paramreg := o_paramreg ||'|'|| r_param.abreviacion ||'='|| r_param.codigo;
    end if;
    n_cantreg  := n_cantreg + 1;
  end loop;
END;

PROCEDURE p_datos_linea(a_codinssrv number, a_numero varchar2)
IS
v_CO_ID varchar2(300);
v_CUSTOMER_ID varchar2(300);
v_CUST_CODE varchar2(300);
v_BILLCYCLE varchar2(300);
v_TIPCLI varchar2(300);
v_null varchar2(300);
n_error number;
v_error varchar2(400);
BEGIN
  begin
  tim.TIM110_DATOS_CLIENTE_LINEA@DBL_BSCS_BF  --6.0
    (a_numero,v_CO_ID,v_CUSTOMER_ID,v_CUST_CODE,v_null,v_null,v_BILLCYCLE,v_TIPCLI,
    n_error,v_error);

    if n_error = -1 then
       raise_application_error(-20001,'Error al obtener informacion BSCS : '|| v_error);
    end if;
  exception
  when no_data_found  then
     raise_application_error(-20001,'Problemas en obtener informacion BSCS.'|| sqlerrm );
  end;
  update inssrv set TIPCLI = v_TIPCLI, CO_ID = v_CO_ID,CUSTOMER_ID= v_CUSTOMER_ID,
  CUST_CODE= v_CUST_CODE,BILLCYCLE=v_BILLCYCLE
  where codinssrv = a_codinssrv;
END;
--Fin 2.0

 --ini 3.0
  procedure p_sincroniza_bambscs(an_coid   number,
                                 av_numslc varchar2,
                                 an_resul  out number,
                                 av_msg    out varchar2) is

    ln_resul number;
    lv_msg   varchar2(400);

  begin
    TIM.sp_act_proyecto_sga@DBL_BSCS_BF(an_coid, --6.0
                                       av_numslc,
                                       ln_resul,
                                       lv_msg);

    if ln_resul = 1 then
      lv_msg := 'Error al obtener informacion BSCS: ' || lv_msg;
    elsif ln_resul = -1 then
      lv_msg := 'Error de oracle: ' || sqlerrm;
    elsif ln_resul = 0 then
      lv_msg := 'Exito';
    end if;

    an_resul := ln_resul;
    av_msg   := lv_msg;

  end;
  --fin 3.0

  /*INI 4.0*/
  PROCEDURE p_obtener_parametros_atc(n_tipaccpv number,
                                     n_cantreg  out number,
                                     o_paramreg out varchar2) IS

    cursor c_param(a_desctipo varchar2) is
      select a.abreviacion, nvl(a.codigoc, a.codigon) codigo
        from opedd a, tipopedd b
       where b.tipopedd = a.tipopedd
         and b.abrev = a_desctipo
       order by a.abreviacion;
    ls_desctrs varchar2(30);
    ln_existe  number;

  BEGIN

    select count(1)
      into ln_existe
      from operacion.tipaccionpv a
     where a.idaccpv = n_tipaccpv;

    if ln_existe > 0 then
      select t.abrev
        into ls_desctrs
        from tipopedd t, operacion.tipaccionpv p
       where t.tipopedd = p.tipopedd
         and p.idaccpv = n_tipaccpv;
    else
      n_cantreg  := 0;
      o_paramreg := '';
      return;
    end if;

    n_cantreg  := 0;
    o_paramreg := '';
    for r_param in c_param(ls_desctrs) loop
      if n_cantreg = 0 then
        o_paramreg := r_param.abreviacion || '=' || r_param.codigo;
      else
        o_paramreg := o_paramreg || '|' || r_param.abreviacion || '=' ||
                      r_param.codigo;
      end if;
      n_cantreg := n_cantreg + 1;
    end loop;
  END;

  PROCEDURE p_envio_rown_atc(n_row     number,
                             i_mensaje out number,
                             o_mensaje out gc_salida) IS
    l_cont         number;
    l_seq_lote_bam number;
    cursor cur_int is
      select t.codsolot, t.idbam
        from operacion.trsbambaf   t,
             operacion.inssrv      i,
             operacion.tipaccionpv ta
       where t.codinssrv = i.codinssrv
         and t.tipactpv = ta.idaccpv
         and t.est_envio = C_PENDIENTE
         and ta.origen = C_ATC
         and i.customer_id is not null
         and rownum <= n_row
       order by t.codsolot;

BEGIN
    select operacion.seq_lote_bam.nextval into l_seq_lote_bam from dual;
    select count(1)
      into l_cont
      from operacion.trsbambaf   t,
           operacion.inssrv      i,
           operacion.tipaccionpv ta
     where t.codinssrv = i.codinssrv
       and t.tipactpv = ta.idaccpv
       and t.est_envio = C_PENDIENTE
       and ta.origen = C_ATC
       and i.customer_id is not null
       and rownum <= n_row
     order by t.codsolot;

    IF l_cont > 0 THEN
      FOR c_int in cur_int LOOP
        BEGIN
          update operacion.trsbambaf t
             set t.est_envio    = C_EJECUCION,
                 t.seq_lote_bam = l_seq_lote_bam,
                 t.fecact       = sysdate,
                 t.feceje      = sysdate
           where t.codsolot = c_int.codsolot
             and t.idbam = c_int.idbam;
        EXCEPTION
          when others then
            null;
        END;
        commit;
      END LOOP;
      i_mensaje := 1;
    ELSE
      i_mensaje := 0;
    END IF;

    IF i_mensaje = 1 THEN
      OPEN o_mensaje FOR
        select t.idbam,
               i.numero,
               t.codinssrv,
               t.idtrancorte,
               t.feceje,
               t.fecprog,
               t.est_envio,
               t.id_mensaje,
               t.observ,
               t.tiptra,
               l_seq_lote_bam,
               t.codsolot,
               i.co_id,
               i.customer_id,
               i.cust_code,
               i.billcycle,
               i.tipcli,
               t.codusu,
               nvl(t.n_reintentos, 0) n_reintentos,
               t.tipactpv,
               c.ntdide,
               t.nrodias
          from operacion.trsbambaf   t,
               operacion.inssrv      i,
               operacion.tipaccionpv ta,
               vtatabcli             c
         where t.codinssrv = i.codinssrv
           and t.tipactpv = ta.idaccpv
           and t.est_envio = C_EJECUCION
           and ta.origen = C_ATC
           and i.customer_id is not null
           and i.codcli = c.codcli
           and t.seq_lote_bam = l_seq_lote_bam
         order by t.codsolot;
    ELSE
      OPEN o_mensaje FOR
        select null idbam,
               null numero,
               null codinssrv,
               null idtrancorte,
               null feceje,
               null fecprog,
               null est_envio,
               null id_mensaje,
               null observ,
               null tiptra,
               null,
               null codsolot,
               null co_id,
               null customer_id,
               null cust_code,
               null billcycle,
               null tipcli,
               null codusu,
               null n_reintentos,
               null tipactpv,
               null ntdide,
               null nrodias
          from dual
         where 0 = 1;

      i_mensaje := 0;
    END IF;

  EXCEPTION
    when others then
      OPEN o_mensaje FOR
        select null idbam,
               null numero,
               null codinssrv,
               null idtrancorte,
               null feceje,
               null fecprog,
               null est_envio,
               null id_mensaje,
               null observ,
               null tiptra,
               null,
               null codsolot,
               null co_id,
               null customer_id,
               null cust_code,
               null billcycle,
               null tipcli,
               null codusu,
               null n_reintentos,
               null tipactpv,
               null ntdide,
               null nrodias
          from dual
         where 0 = 1;

      i_mensaje := 0;
      rollback;
  END;
  /*FIN 4.0*/
  /*INI 5.0*/
  procedure p_valida_cierre_bam_act( a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number)
                                 is

  ln_codsolot    solot.codsolot%type;
  cnt_sot        number;
  cnt_tel        number;
  cnt_oac        number;
  cnt_lng        number;
  pto_tiptrs     operacion.tiptrs.tiptrs%type;
  ins_codinssrv  operacion.inssrv.codinssrv%type;
  ins_numero     operacion.inssrv.numero%type;
  ins_imei       operacion.inssrv.imei%type;
  ins_simcard    operacion.inssrv.simcard%type;
  tel_numero     telefonia.numtel.numero%type;
  tel_imei       telefonia.numtel.imei%type;
  tel_simcard    telefonia.numtel.simcard%type;
  ls_msj_err     varchar2(500);
  err_cierre     exception;

  Begin

    select codsolot
      into ln_codsolot
      from wf
     where idwf = a_idwf;

   /* Consultamos si es un proyecto BAM- BAF*/
   select count(*)
    into cnt_sot
     from solot      a,
          solotpto   b,
          inssrv     c,
          tiptrabajo d
    where a.codsolot  = b.codsolot
      and b.codinssrv = c.codinssrv
      and b.codsrvnue = c.codsrv
      and a.tiptra    = d.tiptra
      and c.tipinssrv = 5
      and d.tiptrs    = 1
      and a.codsolot  = ln_codsolot;

    if cnt_sot >= 1 then

      /* Consulta de datos de numero inssrv */
      select d.tiptrs,
             c.codinssrv,
             c.numero,
             c.imei,
             c.simcard
        into pto_tiptrs,
             ins_codinssrv,
             ins_numero,
             ins_imei,
             ins_simcard
        from solot      a,
             solotpto   b,
             inssrv     c,
             tiptrabajo d
       where a.codsolot  = b.codsolot
         and b.codinssrv = c.codinssrv
         and b.codsrvnue = c.codsrv
         and a.tiptra    = d.tiptra
         and c.tipinssrv = 5
         and d.tiptrs    = 1
         and a.codsolot  = ln_codsolot;


      /* Validacion solo para los tipos de activacion */
      if pto_tiptrs = 1 then

        /* consulta a numtel*/
        select count(*)
          into cnt_tel
          from numtel
         where codinssrv = ins_codinssrv
           and estnumtel = 2;

         /* si no existe en la numtel no puede cerrar la SOT*/
        if cnt_tel = 0 then
           ls_msj_err := 'El Numero Movil no se encuentra Asignado en la Tabla Numtel...';
           raise err_cierre;
         end if;

         /* consulta a numtel */
        select numero,
                imei,
                simcard
           into tel_numero,
                tel_imei,
                tel_simcard
           from numtel
          where codinssrv = ins_codinssrv
            and estnumtel = 2;

        /* Validamos el numero de caracteres y si es de tipo Numerico*/
        begin
            select length(to_number(ins_numero))
              into cnt_lng
              from dual;
          exception
            when others then
              ls_msj_err :='El Formato del Numero Movil en la Tabla Numtel no es Correcto...' ;
              raise err_cierre;
          end;

         /* Validacion OAC */
        Select count(*)
           into cnt_oac
           From tim.pp_datos_contrato@DBL_BSCS_BF --6.0
          Where dn_num    = ins_numero
            and ch_status = 'a';

        if cnt_oac = 0 then
           ls_msj_err := 'El Numero Movil Asignado en el SGA no se Encuentra Activo en el BSCS...' ;
           raise err_cierre;
         end if;


         /*Validacion de asignacion de numero en la inssrv, imei, simcard y longitud de numero */
        if ( tel_numero <> ins_numero ) then
           ls_msj_err := 'El Numero Movil Asignado en la Instancia de Servicio es Diferente al Numero Asignado en la NUMTEL' ;
           raise err_cierre;
         end if ;

         if (  tel_imei <> ins_imei ) then
           ls_msj_err := 'El Campo IMEI Asignado en la Instancia de Servicio es Diferente al Campo IMEI Asignado en la NUMTEL' ;
           raise err_cierre;
         end if ;

         if ( tel_simcard <> ins_simcard ) then
           ls_msj_err := 'El Campo SIMCARD Asignado en la Instancia de Servicio es Diferente al Numero SIMCARD Asignado en la NUMTEL' ;
           raise err_cierre;
         end if ;
      end if;
    end if;
  exception
    when err_cierre then
        raise_application_error(-20500, 'Validaciones de Cierre de SOT: ' || ls_msj_err);
  End;
  procedure p_valida_cierre_bam_des( a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number)
  is
    ln_codsolot    solot.codsolot%type;
    cnt_sot        number;
    cnt_baj        number;
    ins_numero     operacion.inssrv.numero%type;
  Begin
    select codsolot
      into ln_codsolot
      from wf
     where idwf = a_idwf;

   /* Consultamos si es un proyecto BAM- BAF*/
   select count(*)
    into cnt_sot
     from solot      a,
          solotpto   b,
          inssrv     c,
          tiptrabajo d
    where a.codsolot  = b.codsolot
      and b.codinssrv = c.codinssrv
      and b.codsrvnue = c.codsrv
      and a.tiptra    = d.tiptra
      and c.tipinssrv = 5
      and d.tiptrs    = 5
      and a.codsolot  = ln_codsolot;

    if cnt_sot > 0 then

            /* Consulta de datos de numero inssrv */
      select c.numero
        into ins_numero
        from solot      a,
             solotpto   b,
             inssrv     c,
             tiptrabajo d
       where a.codsolot  = b.codsolot
         and b.codinssrv = c.codinssrv
         and b.codsrvnue = c.codsrv
         and a.tiptra    = d.tiptra
         and c.tipinssrv = 5
         and d.tiptrs    = 5
         and a.codsolot  = ln_codsolot;

      Select count(*)
         into cnt_baj
         From tim.pp_datos_contrato@DBL_BSCS_BF ----6.0
        Where dn_num    = ins_numero
          and ch_status = 'a';

        if cnt_baj =  0 then
          -- cerrar la tarea
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                           4,
                                           4,
                                           null,
                                           sysdate,
                                           sysdate);
        end if;
    else
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       4,
                                       4,
                                       null,
                                       sysdate,
                                       sysdate);
    end if;

  End;
  /*FIN 5.0*/
  /*INI 8.0*/
  PROCEDURE P_REGISTRA_TRSBAMBAF_BSCS_TMP(AN_FLG NUMBER) IS
  BEGIN
    IF AN_FLG = 1 THEN
      INSERT INTO TIM.TRSBAMBAF@DBL_BSCS_BF
        SELECT T.*
          FROM OPERACION.TRSBAMBAF T, OPERACION.TIPACCIONPV TA
         WHERE T.TIPACTPV = TA.IDACCPV
           AND T.IDBAM <= (SELECT MAX(IDBAM)
                             FROM OPERACION.TRSBAMBAF
                            WHERE FECUSU < TRUNC(SYSDATE))
           AND T.EST_ENVIO = 0
           AND TA.ORIGEN = 1
           AND T.IDTRANCORTE IS NOT NULL
           AND T.TIPACTPV IS NOT NULL;
      UPDATE OPERACION.TRSBAMBAF
         SET EST_ENVIO = 3
       WHERE IDBAM IN
             (SELECT T.IDBAM
                FROM OPERACION.TRSBAMBAF T, OPERACION.TIPACCIONPV TA
               WHERE T.TIPACTPV = TA.IDACCPV
                 AND T.IDBAM <= (SELECT MAX(IDBAM)
                                   FROM OPERACION.TRSBAMBAF
                                  WHERE FECUSU < TRUNC(SYSDATE))
                 AND T.EST_ENVIO = 0
                 AND TA.ORIGEN = 1
                 AND T.IDTRANCORTE IS NOT NULL
                 AND T.TIPACTPV IS NOT NULL);
    ELSIF AN_FLG = 2 THEN
      INSERT INTO TIM.TRSBAMBAF@DBL_BSCS_BF
        SELECT T.*
          FROM OPERACION.TRSBAMBAF T, OPERACION.TIPACCIONPV TA
         WHERE T.TIPACTPV = TA.IDACCPV
           AND T.EST_ENVIO = 0
           AND TA.ORIGEN = 1
           AND T.IDTRANCORTE IS NOT NULL
           AND T.TIPACTPV IS NOT NULL;
      UPDATE OPERACION.TRSBAMBAF
         SET EST_ENVIO = 3
       WHERE IDBAM IN
             (SELECT T.IDBAM
                FROM OPERACION.TRSBAMBAF T, OPERACION.TIPACCIONPV TA
               WHERE T.TIPACTPV = TA.IDACCPV
                 AND T.EST_ENVIO = 0
                 AND TA.ORIGEN = 1
                 AND T.IDTRANCORTE IS NOT NULL
                 AND T.TIPACTPV IS NOT NULL);
    END IF;
    COMMIT;
  END;
  /*fin 8.0*/
END PQ_BAM;
/