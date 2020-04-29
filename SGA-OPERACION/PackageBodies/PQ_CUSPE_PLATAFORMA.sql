CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CUSPE_PLATAFORMA AS
  /************************************************************
  NOMBRE:     PQ_CUSPE_PLATAFORMA
  PROPOSITO:  Manejo de las customizaciones de Operaciones.
              Tercer paquete de customizaciones.
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version   Fecha        Autor                   Descripcisn
  --------- ----------  ---------------        ------------------------
  1.0    18/08/2009  LPatiño
                      P_PRE_ANULA_RI : Genera solicitud de anulacion ala plataforma
                      P_ALTA_SRV_CDMA : Activacion de servicio CDMA
                      P_BAJA_SRV_CDMA : Baja de servicio CDMA
                      P_JOB_SOT_CAMBIO_ESTADO:Cambio de estado de las SOT que no se cierran en un determinado tiempo
                      P_CHG_VAL_RESERVA:Validacion si se realizo la reserva de terminal y numero telefonico
                      P_SUSPENSION_SRV_CMD:suspension de servicio CDMA
                      P_RECONEXION_SRV_CMD:Reconexion de servicio CDMA
                      P_PRE_CARGA_EQUIPO_BAJA: carga de equipos.
                      P_ASIGNACION_NUMERO:Asignacion de numero telefonico
                      P_PRE_CONF_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_CONF_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_CONF_SERVICIO_HLR:Genera registros en int_servicio_plataforma para la HLR
                      P_CHG_CONF_SERVICIO_HLR:Genera registros en int_servicio_plataforma para la HLR
                      P_PRE_VAL_DATOS_CDMA:VAlida si se realizo la reserva de numero tlefonico y terminal en la venta
                      P_POST_CARGA_INFO_EQU_CDMA_GSM: Carga de equipos
                      P_PRE_BAJA_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_BAJA_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_CAMBIO_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_CHG_CAMBIO_SERVICIO_RI:Genera registros en int_servicio_plataforma para la red inteligente
                      P_PRE_BAJA_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_BAJA_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_PRE_SUSPENSION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_SUSPENSION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_PRE_RECONEXION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_CHG_RECONEXION_SERVICIO_HLR:Genera registros en int_servicio_plataforma para HLR
                      P_GENERA_SOLIC_INTERFAZ:Genera comando para la plataforma
                      P_ACT_ESTADO_TAREA:actualiza el estado de la tarea de acuerdo al estado de la ejecucion en la plataforma
  1.0    18/08/2009  MIsidro  P_PRE_ACTIVACION_CS2K: Para la ejecución automatica
                     de CS2K, generacion de lotes int_servicio_plataforma.
                     P_GEN_INTERFAZ_ANTENA: Genera registros en int_servicio_plataforma
                     para la configuracion de Breezemax, se tienen diferentes operaciones.
                     P_GEN_INTERFAZ_SOFTSWITCH: Crea registros en int_servicio_plataforma.
                     P_ENV_INTERFAZ_TAREA: Llama a procedimiento Interfaz que devuelve
                     idlote para cada operacion registradas x tarea en int_servicio_plataforma
                     P_CHG_PROVIS_TN: Valida flujo de estados de algunas tareas como Beeezemax
                     P_PRE_GEN_FICHA: Creacion de Ficha Tecnica por tarea.
                     P_RSRV_NUMTEL_TN: Reserva y Asignación automatica de números teléfonicos
                     F_GET_NUMTEL_ZONA: Obtiene numeros disponibles
                     segun el Tipo de numero, la Zona y el plan configurados.
                     P_ASIG_NUMERO_TN: Asignación números reservados a instancias de servicios.
                     P_ASIG_PORT_TN: Asigfnacion automática de puertos.
                     P_ASIG_IP_TN: Reserva de IP para Telefonia, Internet
                     e IPs Publicas segun los servicios contratados.
                     P_ACT_FICHA_TN: Actualiza Datos del Suscriber en la Ficha
                     P_ACT_DOC_PROV: Guarda informacion de Ficha Tecnica como Anotación.
                     P_ACT_FQDN: Genera el parametro FQDN y lo actualiza en la FichaTécnica.
                     F_VAL_CODPVC: Valida la ubicacion (VTATABEST) de la SOLOT con el parametro codest.
                     F_GET_CANT_LINEAS: Cuenta Total Lineas Telefónicas en la SOLOT
                     F_GET_CANT_BANDALARGA: Cuenta si la SOLOT tiene Internet.
         22/10/2009  MIsidro  F_GET_CANT_CONTROL: Cuenta si la SOLOT tiene lineas control.
                     F_GET_TXT_PLATAFORMA: Obtiene Valores para la Plataforma en base a eqtiquetas
  2.0    06/01/2010  Luis Patiño Proyecto CDMA P_PRE_CAMBIO_SERVICIO_RI se agrego validacion de numero telefonico
  3.0    12/01/2010  Luis Patiño Proyecto CDMA P_PRE_CAMBIO_SERVICIO_RI se altero query validacion de numero telefonico
  4.0    20/01/2010  Luis Patiño Proyecto CDMA P_ACT_ESTADO_TAREA.
  5.0    25/01/2010  LPatiño Proyecto CDMA P_ACT_ESTADO_TAREA.
  6.0    25/01/2010  LPatiño Proyecto CDMA P_BAJA_SRV_CDMA.
  7.0    16/02/2010  MEchevarria Req. 114163: se agregó exceptions al registro de tareawfseg en p_pre_conf_servicio¿s
  8.0    23/03/2010  APEREZ Req.121575 : se agrego condicion para cerrar tareas con duplicidad
  9.0    24/03/2010  APEREZ  Req.121389 : se modifico logica para despacho de equipos
  10.0   25/03/2010  MIsidro
                    1.- Proyecto CDMA/Telmex Negocio Cambio en Lógica en procedimientos TELLIN para inlciur la logica de TN
                     P_PRE_CONF_SERVICIO_RI          P_PRE_BAJA_SERVICIO_RI
              2.- Para Telmex Negocio, se revisa toda la logica de los procedimientos e interfaces.
              P_CHG_BAJA_SERVICIO_CS2K,       P_PRE_BAJA_SERVICIO_CS2K,  P_CHG_BAJA_SERVICIO_BREEZEMAX,
              P_PRE_BAJA_SERVICIO_BREEZEMAX,  P_POS_LIBERA_PROV_TN,      P_PRE_SUSREC_BREEZEMAX,
              P_CHG_SUSREC_BREEZEMAX,         P_PRE_SUSPENSION_CS2K,     P_CHG_SUS_CS2K,
              P_CHG_REC_CS2K,                 P_PRE_SUS_LIMCRE_CS2K,     P_PRE_SUS_RETPAG_CS2K,
              P_PRE_RECONEXION_CS2K,          P_PRE_REC_LIMCRE_CS2K,     P_PRE_REC_RETPAG_CS2K,
              P_PRE_ACTIVACION_CS2K,          P_GEN_INTERFAZ_BREEZEMAX,  P_GEN_INTERFAZ_CS2K,
              P_ENV_INTERFAZ_TAREA,           P_CHG_ATV_CS2K,            P_CHG_PROVIS_TN,
              P_CHG_VAL_CONTRATA,             P_PRE_GEN_FICHA,           P_ANULA_FICHA,
              P_ANULA_PLATAFORMA,             P_RSRV_NUMTEL_TN,          F_GET_SERIETEL,
              F_GET_NUMTEL_ZONA,              P_ASIG_NUMERO_TN,          P_ASIG_PORT_TN,
              P_ASIG_IP_TN,                   P_ACT_FICHA_TN,            P_ACT_DOC_PROV,
              P_ACT_DOC_PROV2,                P_ACT_FQDN,                P_SINC_TAREA_WEB,
              F_GET_DOC_SOLICITUD,            F_GET_ERROR_PLATAFORMA,    F_UTIL_LIMPIAR_MSG,
              F_VAL_CODPVC,                   F_VAL_PUERTOS,             F_VAL_MACADDRESS,
              F_VAL_SOLOT,                    F_VAL_PARAMHIBRIDO,        F_GET_CODZONA,
              F_GET_CANT_LINEAS,              F_GET_CANT_LINEAS_2,       F_GET_CANT_BANDALARGA,
              F_GET_CANT_CONTROL,             F_GET_CANT_GRUPOIP,        F_GET_CANT_CENTREX,
              F_GET_SUSCRIBER_PROY,           F_GET_SUSCRIBER,           F_GET_IDDEFOPE,
              F_GET_IDDEFOPE_PROY,            F_GET_TXT_PLATAFORMA,      F_GET_SOT_INS_SID,
              F_GET_SOT_INS_PROY,             F_GET_TAREA_FICHA_TECNICA, F_GET_PORT,
              F_GET_VALOR_TXT_INS,            F_GET_PLATAFORMA_TXT_INS,  P_PRE_ANULA_PLATAFORMA,
              P_CHG_ANULA_PLATAFORMA
  11.0   09/04/2010  MIsidro     Mejora en las excepciones y generacion de lotes de Breezemax
  12.0   08/06/2010     Antonio Lagos          Bundle 119999, se modifica baja en OCS y HLR para que lea de tabla soloptoequ de instalacion
                                                porque en el caso de bundle no se cargara previamente la tabla solotptoequ
  Ver    Fecha        Autor              Solicitado por        Descripcion
  -----  ----------   ----------------   -------------------   ------------------------------------
  13.0   20/10/2010   Edson Caqui        Luis Rojas            Req. 146679.
  14.0   06/10/2010                                            REQ.139588 Cambio de Marca
  15.0   23/02/2011   Antonio Lagos      Zulma Quispe          REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  16.0   30/04/2011   Alexander Yong     Zulma Quispe          REQ-159020: Requerimiento nuevo WF
  17.0   05/05/2011   Antonio Lagos      Zulma Quispe          REQ-140967: corregir error al generar comando de alta en cambio de plan
  18.0   19/10/2011   Alex Alamo         Guillermo Salcedo     REQ-161133: Bolsa de Minutos Fijo - Móvil - HFC
  19.0   13/12/2011   Hector Huaman      Hector Huaman         Incidencia: 1109092 Tarea de Activacion en Plataforma RI-Tellian
  20.0   15/12/2011   Hector Huaman      Hector Huaman         Paquete SGA-00013: descomentar envio plataforma, procedimiento P_PRE_CONF_SERVICIO_RI
  21.0   12/12/2011   Carolina Rojas     Edilberto Astulle     Incidencia: SD-339309 corregir el error  de envio Plataforma en tarea RI-tellin
  22.0   05/02/2013   Roy Concepcion     Hector Huaman         REQ-163763 Invocacion de los servicios de la Pltaforma BSCS
  23.0   05/03/2013   Roy Concepcion     Hector Huaman         PROY-7207 IDEA-8992 Asignación de  Nro telefonico TPI
  24.0   08/03/2013   Roy Concepcion     Hector Huaman         PROY-7329
  25.0   30/07/2013   Edilberto Astulle                        SD_697392
  26.0   30/07/2013   Hector Huaman                            SD_796653
  27.0   16/01/2014   Hector Huaman                            PQT-177169- TSK-40145
  28.0   11/07/2014   Eustaquio Gibaja   Christian Riquelme    Restringir Tarea Tellin
  ***********************************************************/
  PROCEDURE P_PRE_ANULA_RI(a_codsolot  IN NUMBER,
                           a_resultado IN OUT VARCHAR2,
                           a_mensaje   IN OUT VARCHAR2) IS

    ln_idplataforma int_plataforma.idplataforma%type;
    ln_cont         number;
    r_plataforma    int_servicio_plataforma%rowtype;
    exception_status exception;
    ln_existe   number;
    ln_idwf     number;
    a_idtareawf number;
    ln_tiptra number;

    cursor cur_plataforma is
      select ip.idseq,
             ip.codinssrv,
             ip.pid,
             ip.codnumtel,
             ip.imsi,
             ip.esn,
             ot.iddefope_anula,
             ip.numslc
        from int_servicio_plataforma  ip,
             tareawf                  t,
             int_operacion_tareadef   ot,
             int_definicion_operacion op
       where ip.codsolot = a_codsolot
         and t.idtareawf = ip.idtareawf
         and ot.tareadef = t.tareadef
         and ip.iddefope = ot.iddefope
         and op.iddefope = ot.iddefope
         and op.idplataforma = ln_idplataforma
         and idlote is not null;
  BEGIN

    ln_existe   := 0;
       
    select count(1)
    into ln_tiptra
    from solot t
   where t.estsol in (select d.codigon
                      from tipopedd c, opedd d
                     where c.tipopedd = d.tipopedd
                       and d.abreviacion = 'ESTADO_ANU_SOT'
                       and c.abrev = 'ESTADO_ANU_SOT'
                       and d.codigon_aux = 1)
   and t.tiptra in (select d.codigon
                      from tipopedd c, opedd d
                     where c.tipopedd = d.tipopedd
                       and d.abreviacion = 'TIPTRA_ANU_SOT'
                       and c.abrev = 'TIPTRA_ANU_SOT'
                       and d.codigon_aux = 1)
   and t.codsolot = a_codsolot;
      
            
      IF ln_tiptra = 1 THEN
         a_resultado := 'OK'; 
      ELSE

    --Ini 14.0
    begin
    Select idwf
      into ln_idwf
      from wf
     where codsolot = a_codsolot
       and valido = 1;
    exception
      when no_data_found then
        ln_idwf := null;
    end;
    --Fin 14.0
    begin
      select idtareawf
        into a_idtareawf
        from tareawf
       where idwf = ln_idwf
         and tareadef = 760;
    exception
      when no_data_found then
        a_idtareawf := null;
    end;

    Begin
      select op.idplataforma
        into ln_idplataforma
        from tareawf                  t,
             int_operacion_tareadef   ot,
             int_definicion_operacion op
       where t.idtareawf = a_idtareawf
         and ot.tareadef = t.tareadef
         and op.iddefope = ot.iddefope
       group by op.idplataforma;
    Exception
      when no_data_found then
        ln_idplataforma := null;
      when too_many_rows then
        a_mensaje := 'Se encontro mas de un codigo de plataforma.';
        raise exception_status;
    End;

    For c1 in cur_plataforma loop

      if c1.iddefope_anula is null then
        a_resultado := 'ERROR';
        a_mensaje   := 'No se ha configurado la operación para la plataforma.';
        raise exception_status;
      End If;

      r_plataforma.codsolot    := a_codsolot;
      r_plataforma.idtareawf   := a_idtareawf;
      r_plataforma.codinssrv   := c1.codinssrv;
      r_plataforma.pid         := c1.pid;
      r_plataforma.codnumtel   := c1.codnumtel;
      r_plataforma.iddefope    := c1.iddefope_anula;
      r_plataforma.estado      := 0;
      r_plataforma.observacion := 'Generado por Anulación de Registro: ' ||
                                  to_char(c1.idseq);
      r_plataforma.numslc      := c1.numslc;

      select count(*)
        INTO ln_cont
        from int_servicio_plataforma
       where codsolot = r_plataforma.codsolot
         and idtareawf = r_plataforma.idtareawf
         and decode(codinssrv, null, -1) =
             decode(r_plataforma.codinssrv, null, -1)
         and decode(pid, null, -1) = decode(r_plataforma.pid, null, -1)
         and decode(codnumtel, null, -1) =
             decode(r_plataforma.codnumtel, null, -1)
         and decode(imsi, null, -1) = decode(r_plataforma.imsi, null, -1)
         and decode(esn, null, -1) = decode(r_plataforma.esn, null, -1)
         and iddefope = r_plataforma.iddefope;

      If ln_cont = 0 Then
        Begin
          insert into int_servicio_plataforma
            (codsolot,
             idtareawf,
             codinssrv,
             pid,
             codnumtel,
             imsi,
             esn,
             iddefope,
             estado,
             observacion,
             numslc)
          values
            (r_plataforma.codsolot,
             r_plataforma.idtareawf,
             r_plataforma.codinssrv,
             r_plataforma.pid,
             r_plataforma.codnumtel,
             r_plataforma.imsi,
             r_plataforma.esn,
             r_plataforma.iddefope,
             r_plataforma.estado,
             r_plataforma.observacion,
             r_plataforma.numslc);
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Problema al generar información para las plataformas.';
            raise exception_status;
        End;
      End if;
      commit;
      ln_existe := 1;
    End loop;

    If ln_existe = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf, 0, a_resultado, a_mensaje);
        If a_resultado = 'ERROR' Then
          raise exception_status;
        End If;
      exception
        when others then
          a_mensaje := 'Error al enviar a interfaz.';
          raise exception_status;
      End;

    End If;
END IF;
  Exception
    when exception_status then
      rollback;
      a_resultado := 'ERROR';
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      commit; --se graba la anotacion

  END;

  PROCEDURE P_ALTA_SRV_CDMA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) IS

    ln_codsolot  solotpto.codsolot%type;
    ls_numero    numtel.numero%type;
    ld_fecha     solot.feccom%type;
    ln_codinssrv inssrv.codinssrv%type;
    ls_mensaje   varchar2(500);

  BEGIN

    select codsolot into ln_codsolot from wf where idwf = a_idwf;
    ld_fecha := sysdate;

    FOR C1 IN (select codinssrv
                 from solotpto
                where codsolot = ln_codsolot
                group by codinssrv) LOOP

      Update inssrv
         set estinssrv = 1, fecini = ld_fecha
       where codinssrv = C1.codinssrv;

      update insprd
         set estinsprd = 1, fecini = ld_fecha
       where codinssrv = C1.codinssrv;

      Update solotpto
         set fecinisrv = ld_fecha
       where codinssrv = C1.codinssrv;

    END LOOP;

  exception
    when others then
      raise_application_error(-20500, 'Error al activar el servicio.');

  END P_ALTA_SRV_CDMA;

  PROCEDURE P_BAJA_SRV_CDMA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) IS

    l_codsolot   solotpto.codsolot%type;
    l_numero     numtel.numero%type;
    ld_fecha     solot.feccom%type;
    l_codinssrv  inssrv.codinssrv%type;
    v_mensaje    varchar2(500);
    ls_numserie  solotptoequ.numserie%type;
    ls_mac       solotptoequ.mac%type;
    ln_imsi      solotptoequ.imsi%type;
    ln_accesorio accesorio.idaccesorio%type;
    ln_idtrrs    trsequi_sim.idtrrs%type;
    ln_codnumtel numtel.codnumtel%type; --6.0

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;
    ld_fecha := sysdate;

    FOR C1 IN (select codinssrv
                 from solotpto
                where codsolot = l_codsolot
                group by codinssrv) LOOP

      --6.0
      begin
        select b.codnumtel
          into ln_codnumtel
          from inssrv a, numtel b
         where a.tipinssrv = 3
           and a.codinssrv = C1.codinssrv
           and a.codinssrv = b.codinssrv;
      exception
        when no_data_found then
          --RAISE_APPLICATION_ERROR(-20500,'No se encuentra el numero telefonico asignado.');
          ln_codnumtel := null; --<8.0>
      end;
      --6.0

      Update inssrv
         set estinssrv = 3, fecfin = ld_fecha
       where codinssrv = C1.codinssrv;

      Update insprd
         set estinsprd = 3, fecfin = ld_fecha
       where codinssrv = C1.codinssrv
         and estinsprd in (1, 2);

      Update solotpto
         set fecinisrv = ld_fecha
       where codinssrv = C1.codinssrv;

      Update acceso
         set estado = 0
       where CID IN
             (select distinct CID from solotpto where codsolot = l_codsolot);
      --6.0 incio
      begin
        select a.idaccesorio, a.idtrrs
          into ln_accesorio, ln_idtrrs
          from trsequi_sim a, accesorio b, simcar c
         where c.codnumtel = ln_codnumtel
           and a.imsi = c.imsi
           and a.idaccesorio = b.idaccesorio
           and a.estado = 2
           and b.estado = 2
           and c.estado = 5;
      exception
        when others then
          null;
      end;

      /* begin
        select trim(numserie),trim(mac),trim(imsi)
        into ls_numserie,ls_mac,ln_imsi
        from solotptoequ
        where codsolot=l_codsolot
        group by numserie,mac,imsi;
      exception
          when others then
              null;
      end;*/

      --if ls_numserie is not null and ls_mac is not null and ln_imsi is not null then

      --6.0 fin

      if ln_idtrrs is not null then

        --6.0 incio
        /*select idaccesorio into ln_accesorio
        from accesorio
        where numeroserie=ls_numserie
        and IMEI_ESN=ls_mac;*/
        --6.0 fin

        update sales.accesorio
           set estado = 3
         where idaccesorio = ln_accesorio;

        --6.0 incio
        /*delete trsequi_sim
        where imsi=ln_imsi
        and idaccesorio=ln_accesorio;*/
        --6.0 fin

        update sales.trsequi_sim set estado = 4 where idtrrs = ln_idtrrs;

      end if;

      Update numtel
         set codinssrv = null, estnumtel = 6
       where codinssrv = C1.codinssrv;
      commit;
    END LOOP;

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20500, 'No se pudo liberar los recursos.');

  END;

  PROCEDURE P_JOB_SOT_CAMBIO_ESTADO IS
    ln_num          NUMBER;
    ln_tipestsol    tipestsol.tipestsol%type;
    ln_valida       NUMBER;
    ln_codsolotbaja NUMBER;
  BEGIN

    FOR C1 IN (SELECT a.idseq,
                      a.tipsrv,
                      a.ndias_pend ndias_pend,
                      a.tipo_ndias,
                      nvl(a.flg_agenda, 0) Flg_Agenda,
                      a.estsol_new,
                      a.codmotot_new,
                      a.observacion,
                      a.tiptra
                 FROM ope_sot_cambio_est a, ope_sot_cambio_det_estsol b
                WHERE a.estado = 1
                  AND (a.ndias_pend is not null and a.ndias_pend > 0)
                  AND a.tipsrv is not null
                  AND a.tiptra is not null
                  AND a.tipo_ndias is not null
                  AND a.estsol_new is not null
                  AND a.idseq = b.idseq
                  AND b.estsol is not null
                GROUP BY a.idseq,
                         a.tipsrv,
                         a.ndias_pend,
                         a.tipo_ndias,
                         a.flg_agenda,
                         a.estsol_new,
                         a.codmotot_new,
                         a.observacion,
                         a.tiptra) LOOP

      IF C1.Tipo_Ndias = 1 or C1.Tipo_Ndias = 2 THEN

        --LISTA DE ESTADOS

        FOR C2 IN (select a.codsolot, a.estsol, a.observacion
                     from solot a, ope_sot_cambio_det_estsol b
                    where a.tiptra = C1.tiptra
                      and a.tipsrv = C1.tipsrv
                      and b.idseq = C1.idseq
                      and a.estsol = b.estsol
                      and decode(C1.Tipo_Ndias,
                                 1,
                                 (sysdate - a.fecusu),
                                 (sysdate - a.feccom)) > C1.ndias_pend
                    GROUP BY a.codsolot, a.estsol, a.observacion) LOOP

          ln_num          := 0;
          ln_tipestsol    := NULL;
          ln_valida       := 0;
          ln_codsolotbaja := null;

          select count(a.solot)
            into ln_num
            from agenda_tareas a, solot b
           where b.codsolot = C2.codsolot
             and a.solot = b.codsolot;

          IF ((C1.Flg_Agenda = 1 and ln_num > 0) or (C1.Flg_Agenda = 0)) THEN

            SELECT tipestsol
              INTO ln_tipestsol
              FROM estsol
             WHERE estsol = C1.estsol_new;

            IF ln_tipestsol = 7 or
               (ln_tipestsol = 5 and C1.tipsrv = '0064') THEN
              select count(*)
                into ln_valida
                from operacion.generabajas
               where tiptra = C1.tiptra
                 and tipsrv = C1.tipsrv;
            END IF;

            IF ln_valida = 1 THEN
              BEGIN
                OPERACION.P_BAJA_SOT_X_ANULA_N(C2.CODSOLOT,
                                               C1.CODMOTOT_NEW,
                                               C1.OBSERVACION,
                                               1,
                                               C1.ESTSOL_NEW);

                begin
                  select codsolot_anula
                    into ln_codsolotbaja
                    from operacion.solot_anula
                   where codsolot = C2.CODSOLOT;
                  update solot
                     Set areasol  = (select areasol
                                       from solot
                                      where codsolot = C2.CODSOLOT),
                         codmotot = C1.codmotot_new
                   where codsolot = ln_codsolotbaja;
                exception
                  when no_data_found then
                    ln_codsolotbaja := null;
                end;
                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;

            ELSE
              BEGIN
                PQ_SOLOT.P_CHG_ESTADO_SOLOT(C2.CODSOLOT,
                                            C1.ESTSOL_NEW,
                                            C2.ESTSOL,
                                            C1.OBSERVACION);

                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;
            END IF;
          END IF;
        END LOOP;

      ELSIF C1.Tipo_Ndias = 3 THEN
        --UN ESTADO EN ESPECIFICO

        FOR C3 IN (select s.estsol, s.codsolot, s.observacion
                     from solotchgest               se,
                          solot                     s,
                          OPE_SOT_CAMBIO_DET_ESTSOL b
                    where s.tipsrv = C1.tipsrv
                      and s.tiptra = C1.TIPTRA
                      and se.codsolot = s.codsolot
                      and b.idseq = C1.IDSEQ
                      and s.estsol = b.estsol
                      and se.estado = b.estsol
                      and (sysdate - se.fecha) > C1.NDIAS_PEND
                    group by s.estsol, s.codsolot, s.observacion) LOOP

          ln_num          := 0;
          ln_tipestsol    := NULL;
          ln_valida       := 0;
          ln_codsolotbaja := null;

          select count(a.solot)
            into ln_num
            from agenda_tareas a, solot b
           where b.codsolot = C3.codsolot
             and a.solot = b.codsolot;

          IF ((C1.Flg_Agenda = 1 and ln_num > 0) or (C1.Flg_Agenda = 0)) THEN

            SELECT tipestsol
              INTO ln_tipestsol
              FROM estsol
             WHERE estsol = C1.estsol_new;

            IF ln_tipestsol = 7 or
               (ln_tipestsol = 5 and C1.tipsrv = '0064') THEN
              select count(*)
                into ln_valida
                from operacion.generabajas
               where tiptra = C1.tiptra
                 and tipsrv = C1.tipsrv;
            END IF;

            IF ln_valida = 1 THEN
              BEGIN
                OPERACION.P_BAJA_SOT_X_ANULA_N(C3.CODSOLOT,
                                               C1.CODMOTOT_NEW,
                                               C1.OBSERVACION,
                                               1,
                                               C1.ESTSOL_NEW);

                begin
                  select codsolot_anula
                    into ln_codsolotbaja
                    from operacion.solot_anula
                   where codsolot = C3.CODSOLOT;
                  update solot
                     Set areasol  = (select areasol
                                       from solot
                                      where codsolot = C3.CODSOLOT),
                         codmotot = C1.codmotot_new
                   where codsolot = ln_codsolotbaja;
                exception
                  when no_data_found then
                    ln_codsolotbaja := null;
                end;
                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;

            ELSE
              BEGIN
                PQ_SOLOT.P_CHG_ESTADO_SOLOT(C3.CODSOLOT,
                                            C1.ESTSOL_NEW,
                                            C3.ESTSOL,
                                            C1.OBSERVACION);

                COMMIT;
              EXCEPTION
                WHEN OTHERS THEN
                  ROLLBACK;
              END;
            END IF;

          END IF;

        END LOOP;

      END IF;

    END LOOP;

  END;

  PROCEDURE P_CHG_VAL_RESERVA(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number,
                              a_tipesttar in number,
                              a_esttarea  in number,
                              a_mottarchg in number,
                              a_fecini    in date,
                              a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;
    ln_numslc       vtatabslcfac.numslc%type;
    ln_num          number;

  BEGIN

    if (a_esttarea = 4) then
      --<8.0>
      select b.numslc
        into ln_numslc
        from wf a, solot b
       where a.idwf = a_idwf
         and a.valido = 1
         and a.codsolot = b.codsolot;

      begin
        select count(*)
          into ln_num
          from sales.reginfcdma
         where numslc = ln_numslc;
      EXCEPTION
        WHEN OTHERS Then
          ln_num := 0;
      End;
      --ejecuta el proceso si cambia de un estado error plataforma a generado.
      IF ln_num = 0 THEN
        raise_application_error(-20500,
                                'Debe realizar la reserva del Numero telefonico y del terminal.');
      end if;
    end if; --<8.0>
  END;

  PROCEDURE P_SUSPENSION_SRV_CMD(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS

    ln_codsolot  solotpto.codsolot%type;
    ls_numero    numtel.numero%type;
    ld_feccom    solot.feccom%type;
    ln_codinssrv inssrv.codinssrv%type;
    ls_mensaje   varchar2(500);

  BEGIN

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    FOR C1 IN (select codinssrv
                 from solotpto
                where codsolot = ln_codsolot
                group by codinssrv) LOOP

      select numero
        into ls_numero
        from inssrv
       where tipinssrv = 3
         and codinssrv = C1.codinssrv;

      Update inssrv set estinssrv = 2 where codinssrv = C1.codinssrv;

      update insprd
         set estinsprd = 2
       where codinssrv = C1.codinssrv
         and estinsprd in (1, 2);

      Update solotpto
         set fecinisrv = sysdate
       where codinssrv = C1.codinssrv;

    END LOOP;

  exception
    when others then
      raise_application_error(-20500, 'Error al suspender el servicio.');

  END;

  PROCEDURE P_RECONEXION_SRV_CMD(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS

    ln_codsolot  solotpto.codsolot%type;
    ls_numero    numtel.numero%type;
    ld_feccom    solot.feccom%type;
    ln_codinssrv inssrv.codinssrv%type;
    ls_mensaje   varchar2(500);

  BEGIN

    select codsolot into ln_codsolot from wf where idwf = a_idwf;

    FOR C1 IN (select codinssrv
                 from solotpto
                where codsolot = ln_codsolot
                group by codinssrv) LOOP

      select numero
        into ls_numero
        from inssrv
       where tipinssrv = 3
         and codinssrv = C1.codinssrv;

      Update inssrv set estinssrv = 1 where codinssrv = C1.codinssrv;

      update insprd
         set estinsprd = 1
       where codinssrv = C1.codinssrv
         and estinsprd = 2;

      Update solotpto
         set fecinisrv = sysdate
       where codinssrv = C1.codinssrv;

    END LOOP;

  exception
    when others then
      raise_application_error(-20500, 'Error al activar el servicio.');

  END P_RECONEXION_SRV_CMD;

  PROCEDURE P_PRE_CARGA_EQUIPO_BAJA(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) IS

    l_codsolot      solot.codsolot%type;
    r_solot         solot%rowtype;
    ln_codsolot_act solot.codsolot%type;
    ln_codinssrv    inssrv.codinssrv%type;

    cursor cur_equ(an_codsolot in number, an_codinssrv in number) is
      SELECT b.codsolot,
             c.punto,
             a.orden,
             a.tipequ,
             a.estado,
             a.cantidad,
             null codequcom,
             a.orden ordenpad,
             c.codinssrv,
             a.tipprp,
             a.numserie,
             a.mac,
             a.imsi
        FROM solotptoequ a, solot b, solotpto c, tipequ d, insprd e
       WHERE b.codsolot = an_codsolot
         and b.codsolot = c.codsolot
         and c.codinssrv = an_codinssrv
         and c.codsolot = a.codsolot
         and c.punto = a.punto
         and a.tipequ = d.tipequ
         and c.codinssrv = e.codinssrv
         and e.flgprinc = 1
         and a.imsi is not null;

    ls_obs  varchar2(100) := 'Este detalle fue ingresado automaticamente en base al inventario';
    ln_cont number(3);

  BEGIN

    -- Solo vale para tareas retiro de Equipos baja o anulacion
    select count(a.idtareawf)
      into ln_cont
      from tareawf a, tareadef b
     where a.idtareawf = a_idtareawf
       and a.tareadef = b.tareadef
       and (upper(b.descripcion) like '%RETIRO%EQUIPO%');

    IF ln_cont > 0 THEN

      FOR C1 IN (select b.codsolot, b.punto, b.codinssrv
                   from wf a, solotpto b, insprd c
                  where a.idwf = a_idwf
                    and a.codsolot = b.codsolot
                    and b.codinssrv = c.codinssrv
                    and c.flgprinc = 1
                    and decode(b.pid, null, 1, b.pid) =
                        decode(b.pid, null, 1, c.pid)
                    and c.fecfin is null) LOOP

        ln_codsolot_act := F_GET_SOT_INS_SID(C1.CODINSSRV);

        FOR C2 IN cur_equ(ln_codsolot_act, C1.CODINSSRV) LOOP

          insert into solotptoequ
            (codsolot,
             punto,
             orden,
             tipequ,
             cantidad,
             codequcom,
             numserie,
             mac,
             imsi,
             tipprp,
             observacion,
             flg_recuperacion)
          values
            (C1.codsolot,
             C1.punto,
             C2.orden,
             C2.tipequ,
             C2.cantidad,
             C2.codequcom,
             C2.numserie,
             C2.mac,
             C2.imsi,
             C2.tipprp,
             ls_obs,
             1);

        END LOOP;
      END LOOP;
    END IF;
  END P_PRE_CARGA_EQUIPO_BAJA;

  PROCEDURE P_ASIGNACION_NUMERO(a_idtareawf IN NUMBER,
                                a_idwf      IN NUMBER,
                                a_tarea     IN NUMBER,
                                a_tareadef  IN NUMBER) IS

    ln_codsolot  solot.codsolot%type;
    ln_codnumtel numtel.codnumtel%type;
    ln_codcab    number;
    ln_estinssrv inssrv.estinssrv%type;

    CURSOR c_numero IS
      SELECT r.numtel, p.codinssrv, s.numslc
        FROM sales.reginfcdma r, solot s, solotpto p, numtel f
       WHERE s.codsolot = ln_codsolot
         and r.numslc = s.numslc
         and s.codsolot = p.codsolot
         and r.numtel = f.numero
         and r.flg_reserva <> 1
         and r.imsi is not null
       GROUP BY r.numtel, p.codinssrv, s.numslc;

  BEGIN

    SELECT codsolot INTO ln_codsolot FROM wf where idwf = a_idwf;

    FOR C1 IN c_numero LOOP

      UPDATE inssrv
         set numero = C1.numtel, fecini = sysdate
       WHERE codinssrv = C1.codinssrv;
      UPDATE numtel
         set estnumtel = 2,
             fecasg    = sysdate,
             codinssrv = C1.codinssrv,
             codusuasg = user
       WHERE numero = C1.numtel;
      UPDATE sales.reginfcdma set flg_reserva = 1 WHERE numslc = C1.numslc; -- Adicional para identIficar que el numero fue asignado

      UPDATE solotpto SET fecinisrv = sysdate WHERE codsolot = ln_codsolot; -- Se asigna la fecha de inicio del servicio

      SELECT estinssrv
        INTO ln_estinssrv
        FROM inssrv
       WHERE codinssrv = C1.codinssrv;

      UPDATE inssrv SET estinssrv = 4 WHERE codinssrv = C1.codinssrv;

      SELECT codnumtel
        INTO ln_codnumtel
        FROM numtel
       WHERE numero = C1.numtel;

      telefonia.pq_telefonia.p_crear_hunting(ln_codnumtel, ln_codcab);

      UPDATE inssrv
         SET estinssrv = ln_estinssrv
       WHERE codinssrv = C1.codinssrv;

    END LOOP;

  EXCEPTION
    WHEN OTHERS Then
      RAISE_APPLICATION_ERROR(-20500,
                              'No se proceso asignacion de numero telefonico. ' ||
                              SQLERRM);
  END P_ASIGNACION_NUMERO;

  PROCEDURE P_PRE_CONF_SERVICIO_RI(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
    --ini 15.0
    --SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel
      --SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel, h.idplan
        SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel, h.idplan,c.codsrv,e.codcli,e.numero,e.numslc -- 22.0
      --fin 15.0
        FROM solotpto    a,
             insprd      b,
             tystabsrv   c,
             wf          d,
             inssrv      e,
             numtel      f,
             solot       g,
             plan_redint h
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and e.tipinssrv = 3
         and c.idplan = h.idplan
         and h.idtipo in (2, 3) --control,prepago
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and e.codinssrv = f.codinssrv
         and a.codsolot = g.codsolot;
    -- 10.0 Se crea Cursor para paquetes pymes wimax y se adicionan variables
    CURSOR cur_codinssrv_pymes IS
    --ini 15.0
    --select a.codsolot, e.codinssrv, f.codnumtel
      --select a.codsolot, e.codinssrv, f.codnumtel, b.pid
      select a.codsolot, e.codinssrv, f.codnumtel, b.pid, c.idplan,c.codsrv,e.codcli,e.numslc,e.numero -- 22.0
      --fin 15.0
        from solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
       where d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and e.codinssrv = a.codinssrv
         and e.tipinssrv = 3
         and b.codinssrv = e.codinssrv
         and b.flgprinc = 1
         and c.codsrv = b.codsrv
         and a.pid = b.pid
         and e.cid is not null
         and f.codinssrv = e.codinssrv;

    ln_definicion_operacion int_servicio_plataforma.iddefope%TYPE;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar   esttarea.tipesttar%TYPE;
    ls_resultado   varchar2(400);
    a_tipoproc     NUMBER;
    ln_reser_telef NUMBER;
    ls_tipsrv      solot.tipsrv%type;
    ln_control     number;
    p_pid          insprd.pid%type;
    a_cant_tel     number;
    a_cant_bl      number;
    ln_codsolot    solot.codsolot%type;
    --ini 15.0
    ln_idplan            number;
    ln_num_lineas        number;
    ln_subplan           number;
    flg_subplan_n_lineas number;
    ls_descplan          plan_redint.descripcion%type;
    --fin 15.0
     -- ini 22.0
    vn_salida  number;
    vv_tipdide vtatabcli.tipdide%type;
    vv_ntdide  vtatabcli.ntdide%type;
    vv_apepatcli varchar2(140);
    vv_apematcli vtatabcli.apematcli%type;
    vv_nomclires vtatabcli.nomclires%type;
    vv_ruc       vtatabcli.ntdide%type;
    vv_razon     vtatabcli.nomcli%type;
    vv_telefono1 vtatabcli.telefono1%type;
    vv_telefono2 vtatabcli.telefono2%type;
    vv_dirsuc    vtasuccli.dirsuc%type;
    vv_referencia vtasuccli.referencia%type;
    vv_nomdst  v_ubicaciones.nomdst%type;
    vv_nompvc  v_ubicaciones.nompvc%type;
    vv_nomest  v_ubicaciones.nomest%type;
    vv_nomemail marketing.vtaafilrecemail.nomemail%type;
    vn_plan     plan_redint.plan%type;
    vn_plan_opcional plan_redint.plan_opcional%type;
    vv_imsi          varchar2(15);
    vv_ciclo         varchar2(2);
    vn_plan_old  plan_redint.plan%type;
    vn_plan_opcional_old plan_redint.plan_opcional%type;
    vv_numero_old   inssrv.numero%type;
    vv_imsi_old     varchar2(15);
    vv_trama        varchar2(1500);
    vv_action       varchar2(1);
    vn_result       number(1);
    vn_cicfac       number;
    vn_dia          number;
    vn_idtrans      number;
    vv_resultado    varchar2(2);
    vv_message      varchar2(50);
    vv_fecini_cicfac varchar2(4);
    ve_hcon varchar2(8);
    ve_hccd varchar2(8);
    ve_hctr varchar2(8);
    ve_imsi varchar2(8);
    vs_hcon varchar2(8);
    vs_hccd varchar2(8);
    vs_hctr varchar2(8);
    vs_imsi varchar2(8);
    -- fin 22.0
  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    begin
      -- 10.0 variable
      select b.tipsrv, a.codsolot
        into ls_tipsrv, ln_codsolot
        from wf a, solot b
       where a.idwf = a_idwf
         and a.codsolot = b.codsolot
         and a.valido = 1; --16.0
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el tipo de servicio.';
        raise exception_actv;
      when too_many_rows then
        --ls_mensaje := 'Se encontro mas de un tipo de servicio.';
        ls_mensaje := 'Se encontraron varias SOTs.'; --16.0
        raise exception_actv;
    end;

    -- 10.0 Funciones TN
    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot);
    a_cant_bl  := F_GET_CANT_BANDALARGA(ln_codsolot);

    --ini 15.0
    select count(1)
      into flg_subplan_n_lineas
      from tipopedd a, opedd b
     where a.tipopedd = b.tipopedd
       and a.abrev = 'FAM_SUBPLAN_N_LINEAS_RI'
       and b.codigoc = ls_tipsrv;

    --If not (ls_tipsrv not in ('0058', '0059') or
    If not (flg_subplan_n_lineas = 0 or
        --fin 15.0
        (a_cant_tel = 0 and a_cant_bl = 0)) Then
      -- 10.0 Inicio Se incluye Validacion IF para aplicar Lógica nueva en caso de Paquetes TN
      Begin
        select count(a.codinssrv)
          into ln_reser_telef
          from inssrv a, solotpto b, wf e, numtel f
         where e.idwf = a_idwf
           and b.codsolot = e.codsolot
           and a.codinssrv = b.codinssrv
           and a.codinssrv = f.codinssrv(+)
           and a.numero is null;
      Exception
        when no_data_found then
          --16.0
          Null;
          /*ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
          raise exception_actv;*/
      End;

      If ln_reser_telef > 0 then
        ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
        raise exception_actv;
      End if;

      select F_GET_CANT_CONTROL(wf.codsolot)
        into ln_control
        from wf
       where wf.idwf = a_idwf;

      If ln_control > 0 then
        Begin
          --ini 15.0
          --Select b.pid
          --  into p_pid
          select distinct h.idplan, h.descripcion
            into ln_idplan, ls_descplan
          --fin 15.0
            from solotpto    a,
                 insprd      b,
                 tystabsrv   c,
                 wf          d,
                 inssrv      e,
                 plan_redint h
           where d.idwf = a_idwf
             and a.codsolot = d.codsolot
             and e.codinssrv = a.codinssrv
             and e.tipinssrv = 3
             and b.codinssrv = e.codinssrv
             and c.codsrv = b.codsrv
             and h.idtipo in (2, 3) --control,prepago
             and h.idplan = c.idplan
             and a.pid=b.pid;--21.0
        Exception
          when others then
            ls_mensaje := 'Error al obtener Servicio de las Líneas Control.';
            raise exception_actv;
        End;
        --ini 15.0
        begin
          select subplan
            into ln_subplan
            from plan_redint
           where idplan = ln_idplan;
        exception
          when others then
            ls_mensaje := 'Error al obtener Plan de red inteligente.';
            raise exception_actv;
        end;

        select count(e.codinssrv)
          into ln_num_lineas
          from solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
         where d.idwf = a_idwf
           and a.codsolot = d.codsolot
           and e.codinssrv = a.codinssrv
           and e.tipinssrv = 3
           and b.codinssrv = e.codinssrv
           and b.flgprinc = 1
           and c.codsrv = b.codsrv
           and a.pid = b.pid
           and e.cid is not null
           and f.codinssrv = e.codinssrv;

        if ln_num_lineas > 1 then
          if ln_subplan = 1 then
            begin
              select plan_fraccionado
                into ln_idplan
                from telefonia.tys_subplanesxplan
               where num_lineas = ln_num_lineas
                 and idplan = ln_idplan;
            exception
              when others then
                ls_mensaje := 'Falta configurar el subplan de ' ||
                              to_char(ln_num_lineas) ||
                              ' lineas para el plan: ' || ls_descplan;
                raise exception_actv;
            end;
          else
            ls_mensaje := 'Falta configurar los subplanes para el plan: ' ||
                          ls_descplan;
            raise exception_actv;
          end if;
        end if;
        --fin 15.0

        FOR C1 IN cur_codinssrv_pymes LOOP
          -- ini 22.0
        -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida);
          if vn_salida > 0 then
             --select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
             select vc.tipdide,vc.ntdide,replace(vc.nomclires,'|',' ')|| ' ' || replace(vc.apepatcli,'|',' '),
                    replace(vc.nomclires,'|',' ')nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    replace(vc.nomcli,'|',' ')nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select replace(vsuc.dirsuc,'|',' ')dirsuc ,replace(vsuc.referencia,'|',' ')referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;

             begin
               select  z.nomemail
               into vv_nomemail
               from
               (SELECT v.nomemail
               FROM marketing.vtaafilrecemail v
               where v.codcli = C1.codcli
               order by v.fecusu desc) z
               where rownum = 1;
             --<26.0
             exception
               when others then
                 vv_nomemail := '';
             end;
             --26.0>
             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;
             --<27.0
             begin
              select to_number(to_char(trunc(min(fectrs)), 'dd'))
                into vn_dia
                from trssolot
               where numslc = C1.numslc
                 and tiptrs = 1
                 and esttrs = 2;
              exception
                when others then
                   vn_dia := null;
               end;

             --vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             --27.0>
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

             begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             ve_hcon := 'P_HCON';
             ve_hccd := 'P_HCCD';
             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hcon,vs_hcon);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hccd,vs_hccd);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '1';
             vv_trama := vs_hcon || C1.codcli || '|' || vs_hccd || C1.codcli || '|' ||  vv_ruc || '|' ||  vv_nomclires || '|' ||  vv_apepatcli || '|' ||
             vv_tipdide || '|' ||  vv_ntdide || '|' ||  vv_razon || '|' ||  vv_telefono1 || '|' ||  vv_telefono2 || '|' ||  vv_nomemail || '|' || vv_dirsuc || '|' ||  vv_referencia || '|' ||  vv_nomdst || '|' ||
             vv_nompvc || '|' ||  vv_nomest || '|' ||  vs_hctr || to_char(C1.codinssrv) || '|' ||  C1.numero || '|' || vs_imsi || vv_imsi || '|' ||  vv_ciclo || '|' || to_char(vn_plan)|| '|' ||  to_char(vn_plan_opcional);

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vs_hcon || C1.codcli,vs_hccd || C1.codcli,vv_ruc,
                                                                             vv_nomclires,vv_apepatcli,vv_tipdide,
                                                                             vv_ntdide,vv_razon,vv_telefono1,
                                                                             vv_telefono2,vv_nomemail,vv_dirsuc,
                                                                             vv_referencia,vv_nomdst, vv_nompvc,
                                                                             vv_nomest,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_ciclo, 1,
                                                                             vv_trama,vn_plan, vn_plan_opcional,
                                                                             vn_plan_old,vn_plan_opcional_old,vv_numero_old,
                                                                             vv_imsi_old,vn_result,vn_idtrans);
             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS(vn_idtrans,
                 tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--23.0
                                                                   vv_action,
                                                                   vv_trama,
                                                                   vv_resultado,
                                                                   vv_message);
              --<24.0
              BEGIN
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (a_idtareawf, vv_message);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --24.0>
             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

             vn_salida := -1;
          else       --  fin 22.0
            select count(*)
              INTO ln_num
              from int_servicio_plataforma
             where codsolot = C1.codsolot
               and idtareawf = a_idtareawf
               and codinssrv = C1.codinssrv
                  --ini 15.0
                  --and pid = p_pid
               and pid = C1.pid
                  --fin 15.0
               and codnumtel = C1.codnumtel
               and iddefope = ln_definicion_operacion
               and estado not in (4);

          If ln_num = 0 Then
            BEGIN
              INSERT INTO int_servicio_plataforma
              --ini 15.0
              --(codsolot, idtareawf, codinssrv, pid, codnumtel, iddefope)
                (codsolot,
                 idtareawf,
                 codinssrv,
                 pid,
                 idplan,
                 codnumtel,
                 iddefope)
              --fin 15.0
              VALUES
                (C1.codsolot,
                 a_idtareawf,
                 C1.codinssrv,
                 --ini 15.0
                 --p_pid,
                 C1.pid,
                 ln_idplan,
                 --fin 15.0
                 C1.codnumtel,
                 ln_definicion_operacion);
            EXCEPTION
              WHEN OTHERS Then
                ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                              SQLERRM;
                raise exception_actv;
            End;
          End If;
          end if; -- 22.0
          commit;
          ln_ri := 1;
        END LOOP;
      End If; -- 10.0 Fin
    ELSE
      begin
        select count(a.codinssrv)
          into ln_reser_telef
          from inssrv      a,
               solotpto    b,
               tystabsrv   c,
               plan_redint d,
               wf          e,
               numtel      f
         where e.idwf = a_idwf
           and b.codsolot = e.codsolot
           and a.codinssrv = b.codinssrv
           and b.codsrvnue = c.codsrv
           and c.idplan = d.idplan
           and d.idtipo in (2, 3)
           and a.codinssrv = f.codinssrv(+)
           and f.numero is null;
      exception
        when no_data_found then
          --16.0
          Null;
          /*ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
          raise exception_actv;*/
      end;

      if ln_reser_telef > 0 then
        ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
        raise exception_actv;
      end if;

      FOR C1 IN cur_codinssrv LOOP

         -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- ini 22.0
          if vn_salida > 0 then -- 22.0
             --select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
             select vc.tipdide,vc.ntdide,replace(vc.apepatcli,'|',' ')|| ' ' || replace(vc.apematcli,'|',' '),
                    replace(vc.nomclires,'|',' ')nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    replace(vc.nomcli,'|',' ')nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select replace(vsuc.dirsuc,'|',' ')dirsuc ,replace(vsuc.referencia,'|',' ')referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;
             begin
               select  z.nomemail
               into vv_nomemail
               from
               (SELECT v.nomemail
               FROM marketing.vtaafilrecemail v
               where v.codcli = C1.codcli
               order by v.fecusu desc) z
               where rownum = 1;
             --<26.0
             exception
               when others then
                 vv_nomemail := '';
             end;
             --26.0>
             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             --<27.0
             begin
              select to_number(to_char(trunc(min(fectrs)), 'dd'))
                into vn_dia
                from trssolot
               where numslc = C1.numslc
                 and tiptrs = 1
                 and esttrs = 2;
              exception
                when others then
                   vn_dia := null;
               end;

             --vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             --27.0>
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

             begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             ve_hcon := 'P_HCON';
             ve_hccd := 'P_HCCD';
             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hcon,vs_hcon);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hccd,vs_hccd);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '1';
             vv_trama := vs_hcon || C1.codcli || '|' || vs_hccd || C1.codcli || '|' ||  vv_ruc || '|' ||  vv_nomclires || '|' ||  vv_apepatcli || '|' ||
             vv_tipdide || '|' ||  vv_ntdide || '|' ||  vv_razon || '|' ||  vv_telefono1 || '|' ||  vv_telefono2 || '|' ||  vv_nomemail || '|' || vv_dirsuc || '|' ||  vv_referencia || '|' ||  vv_nomdst || '|' ||
             vv_nompvc || '|' ||  vv_nomest || '|' ||  vs_hctr || to_char(C1.codinssrv) || '|' ||  C1.numero || '|' || vs_imsi || vv_imsi || '|' ||  vv_ciclo || '|'  ||  to_char(vn_plan)|| '|' ||  to_char(vn_plan_opcional);


              operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vs_hcon || C1.codcli,vs_hccd || C1.codcli,vv_ruc,
                                                                             vv_nomclires,vv_apepatcli,vv_tipdide,
                                                                             vv_ntdide,vv_razon,vv_telefono1,
                                                                             vv_telefono2,vv_nomemail,vv_dirsuc,
                                                                             vv_referencia,vv_nomdst, vv_nompvc,
                                                                             vv_nomest,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_ciclo, 1,
                                                                             vv_trama,vn_plan, vn_plan_opcional,
                                                                             vn_plan_old,vn_plan_opcional_old,vv_numero_old,
                                                                             vv_imsi_old,vn_result,vn_idtrans);
             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS(vn_idtrans,
             tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--23.0
                                                                   vv_action,
                                                                   vv_trama,
                                                                   vv_resultado,
                                                                   vv_message);
              --<24.0
              BEGIN
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (a_idtareawf, vv_message);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --24.0>
             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

             vn_salida := -1; --  fin 22.0
        ELSE --24.0
         select count(*)
          INTO ln_num
          from int_servicio_plataforma
         where codsolot = C1.codsolot
           and idtareawf = a_idtareawf
           and codinssrv = C1.codinssrv
           and pid = C1.pid
           and codnumtel = C1.codnumtel
           and iddefope = ln_definicion_operacion
           and estado not in (4);

        If ln_num = 0 Then
          BEGIN
            INSERT INTO int_servicio_plataforma
            --ini 15.0
            --(codsolot, idtareawf, codinssrv, pid, codnumtel, iddefope)
              (codsolot,
               idtareawf,
               codinssrv,
               pid,
               idplan,
               codnumtel,
               iddefope)
            --fin 15.0
            VALUES
              (C1.codsolot,
               a_idtareawf,
               C1.codinssrv,
               C1.pid,
               --ini 15.0
               C1.idplan,
               --fin 15.0
               C1.codnumtel,
               ln_definicion_operacion);
          EXCEPTION
            WHEN OTHERS Then
              ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                            SQLERRM;
              raise exception_actv;
          End;
        End If;
       end if;-- 22.0
        commit;
        ln_ri := 1;
      End LOOP;
    End If;

    If ln_ri = 0 Then

      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    ELSIf ln_ri = 1 Then
    ---PARA PRUEBAS
    if vn_salida = 0 then -- 22.0
    --20.0 Inicio
       P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              ls_resultado,
                              ls_mensaje);
    --20.0 Fin
     If ls_resultado = 'ERROR' Then
        raise exception_actv;
      End If;
      end if; -- 22.0
    End If;
  EXCEPTION
    when exception_actv then
      BEGIN
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, ls_mensaje);
        --<7.0> se coloca excepcion para evitar error de insert
      EXCEPTION
        WHEN OTHERS THEN
          -- intentamos denuevo
          BEGIN
            insert into OPEWF.tareawfseg
              (idtareawf, observacion)
            values
              (a_idtareawf, ls_mensaje);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
      --</7.0>
      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_CONF_SERVICIO_RI;

  PROCEDURE P_CHG_CONF_SERVICIO_RI(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_CONF_SERVICIO_RI(a_idtareawf,
                             a_idwf, /*a_tarea*/
                             null,
                             a_tareadef);
    end if;
  END;

  PROCEDURE P_PRE_CONF_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      SELECT a.codsolot,
             e.codinssrv,
             b.pid,
             f.codnumtel,
             h.numserie,
             h.imsi,
             h.mac esn
        FROM solotpto a,
             insprd b,
             tystabsrv c,
             wf d,
             inssrv e,
             numtel f,
             solot g,
             (select a.codinssrv, b.numserie, b.imsi, b.mac
                from solotpto a, solotptoequ b
               where a.codsolot = b.codsolot
                 and a.punto = b.punto) h
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.pid = b.pid
         and b.flgprinc = 1
         and e.tipinssrv = 3
         and e.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and e.codinssrv = f.codinssrv
         and a.codsolot = g.codsolot
         and a.codinssrv = h.codinssrv;

    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar esttarea.tipesttar%TYPE;
    ls_resultado varchar2(400);
    a_tipoproc   NUMBER;

  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    FOR C1 IN cur_codinssrv LOOP

      SELECT count(*)
        INTO ln_num
        FROM int_servicio_plataforma
       WHERE codsolot = C1.codsolot
         and idtareawf = a_idtareawf
         and codinssrv = C1.codinssrv
         and pid = C1.pid
         and codnumtel = C1.codnumtel
         and iddefope = ln_definicion_operacion
         and imsi = C1.Imsi
         and esn = C1.Esn;

      If ln_num = 0 Then
        BEGIN
          INSERT INTO int_servicio_plataforma
            (codsolot,
             idtareawf,
             codinssrv,
             pid,
             codnumtel,
             iddefope,
             imsi,
             esn)
          VALUES
            (C1.codsolot,
             a_idtareawf,
             C1.codinssrv,
             C1.pid,
             C1.codnumtel,
             ln_definicion_operacion,
             C1.Imsi,
             C1.Esn);
        EXCEPTION
          WHEN OTHERS Then
            ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                          SQLERRM;
            raise exception_actv;
        End;
      End If;
      commit;
      ln_ri := 1;
    End LOOP;

    If ln_ri = 0 Then
      ls_mensaje := 'No se encontro registros para enviar a la plataforma HRL.';
      raise exception_actv;

    ELSIf ln_ri = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;

    End If;
  EXCEPTION
    when exception_actv then
      BEGIN
        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, ls_mensaje);
        --<7.0> se coloca excepcion para evitar error de insert
      EXCEPTION
        WHEN OTHERS THEN
          -- intentamos denuevo
          BEGIN
            insert into OPEWF.tareawfseg
              (idtareawf, observacion)
            values
              (a_idtareawf, ls_mensaje);
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
      END;
      --</7.0>

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_CONF_SERVICIO_HLR;

  PROCEDURE P_CHG_CONF_SERVICIO_HLR(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number,
                                    a_tipesttar in number,
                                    a_esttarea  in number,
                                    a_mottarchg in number,
                                    a_fecini    in date,
                                    a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_CONF_SERVICIO_HLR(a_idtareawf,
                              a_idwf, /*a_tarea*/
                              null,
                              a_tareadef);
    end if;
  END;

  PROCEDURE P_PRE_VAL_DATOS_CDMA(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER) IS

    r_ot_atv                     solot%ROWTYPE;
    ln_tarea_datos_comp_gsm_cdma NUMBER;
    ln_idtareawf                 tareawfcpy.idtareawf%TYPE;
    ll_datos_completos           NUMBER;

  BEGIN
    -- ln_tarea_datos_comp_gsm_cdma  :=801;

    BEGIN
      SELECT wf.codsolot, solot.numslc, solot.tiptra
        INTO r_ot_atv.codsolot, r_ot_atv.numslc, r_ot_atv.tiptra
        FROM wf, tareawf, solot
       WHERE wf.idwf = tareawf.idwf
         and tareawf.idtareawf = a_idtareawf
         and solot.codsolot = wf.codsolot;
    EXCEPTION
      WHEN OTHERS Then
        RAISE_APPLICATION_ERROR(-20500,
                                'El WF no tiene asociado una SOLOT.');
    End;

    BEGIN
      SELECT count(*)
        INTO ll_datos_completos
        FROM sales.reginfcdma a,
             (select *
                from opedd
               where tipopedd = 201
                 and abreviacion = 'CDMA') b,
             maestro_Series_Equ c,
             almtabmat d,
             tipequ e
       WHERE a.numslc = r_ot_atv.numslc
         and b.codigoc = c.cod_sap
         and c.nroserie = trim(a.numserie)
         and c.cod_sap = trim(d.cod_sap)
         and d.codmat = e.codtipequ
         and a.numtel is not null;
    EXCEPTION
      WHEN OTHERS Then
        ll_datos_completos := 0;
    End;

    BEGIN

      SELECT idtareawf
        INTO ln_idtareawf
        FROM tareawfcpy
       WHERE tareadef = a_tareadef --Ingreso de datos complementarios CDMA/GSM
         and idwf = a_idwf;
    EXCEPTION
      WHEN OTHERS Then
        ln_idtareawf := NULL;
    End;

    If ll_datos_completos > 0 and ln_idtareawf is not null Then

      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    End If;

  END P_PRE_VAL_DATOS_CDMA;

  PROCEDURE P_POST_CARGA_INFO_EQU_CDMA_GSM(a_idtareawf IN NUMBER,
                                           a_idwf      IN NUMBER,
                                           a_tarea     IN NUMBER,
                                           a_tareadef  IN NUMBER) IS
    l_codsolot     NUMBER;
    v_serie        varchar2(100);
    v_numslc       varchar2(100);
    l_orden        NUMBER;
    l_punto        NUMBER;
    l_punto_ori    NUMBER;
    l_punto_des    NUMBER;
    l_codeta       NUMBER;
    l_cont_equipos NUMBER;
    n_codfor       number; --<9.0>
    v_cod_sap      varchar2(20); --<9.0>
    n_tiptra       number; --<9.0>
    CURSOR c_equ IS
      SELECT TRIM(A.NUMSERIE) serie1,
             g.tipequ,
             g.costo,
             TRIM(A.NUMNSE) esn,
             A.NUMSLC,
             E.COD_SAP,
             E.NROSERIE,
             a.fecusu fecha_creacion,
             a.imsi,
             a.nro_pin,
             trim(f.codmat) codmat
        FROM SALES.REGINFCDMA A,
             /*(SELECT *
                                                          FROM opedd
                                                         WHERE tipopedd = 201
                                                           and abreviacion = 'CDMA') D,*/ --<9.0>
             Maestro_Series_Equ e,
             almtabmat          f,
             tipequ             g
       WHERE a.numslc = v_numslc
            --and D.CODIGOC = E.COD_SAP --<9.0>
         and e.NROSERIE = TRIM(a.NUMSERIE)
         and e.cod_sap = TRIM(f.cod_sap)
         and f.codmat = g.codtipequ;

  BEGIN

    --SELECT codsolot INTO l_codsolot FROM wf WHERE idwf = a_idwf;--<9.0>

    --SELECT numslc INTO v_numslc FROM solot WHERE codsolot = l_codsolot;--<9.0>

    --<9.0>
    SELECT a.codsolot, b.numslc, b.tiptra
      INTO l_codsolot, v_numslc, n_tiptra
      FROM wf a, solot b
     WHERE idwf = a_idwf
       and a.codsolot = b.codsolot;
    --Inicio 25.0
    select codfor into n_codfor
    from TIPTRABAJOXFOR a, solot b
    where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv
    and codsolot = l_codsolot ;
    --Fin 25.0

    FOR c_s IN c_equ LOOP

      v_serie := null;

      operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,
                                        l_punto,
                                        l_punto_ori,
                                        l_punto_des);

      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        FROM solotptoequ
       WHERE codsolot = l_codsolot
         and punto = l_punto;

      --<9.0>
      --Seleccionar la Etapa respectiva en base a la configuracion de la formula
      begin
        select codeta
          into l_codeta
          from matetapaxfor
         where codfor = n_codfor
           and trim(codmat) = trim(c_s.codmat)
           and tipo = 2;
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Falta configurar para el Equipo ' ||
                                  v_cod_sap ||
                                  ' la Etapa correcta. Revise la formular : ' ||
                                  to_char(n_codfor));
      end;
      --</9.0>
      --<9.0>
      /*SELECT codigon
       INTO l_codeta
       FROM opedd
      WHERE tipopedd = 197
        and TRIM(codigoc) = TRIM(c_S.cod_sap);*/ --</9.0>

      SELECT COUNT(1) --<9.0>
        INTO l_cont_equipos
        FROM solotptoequ
       WHERE codsolot = l_codsolot
         and TRIM(numserie) = TRIM(c_s.nroserie); --<9.0>

      If l_cont_equipos = 0 Then
        --No esta registrado el Equipo en la SOT

        INSERT INTO operacion.solotptoequ
          (codsolot,
           punto,
           orden,
           tipequ,
           cantidad,
           tipprp,
           costo,
           numserie,
           flgsol,
           flgreq,
           codeta,
           tran_solmat,
           observacion,
           fecfdis,
           imsi,
           mac,
           nro_pin)
        VALUES
          (l_codsolot,
           l_punto,
           l_orden,
           c_s.tipequ,
           1,
           0,
           nvl(c_s.costo, 0),
           c_s.NroSerie,
           1,
           0,
           l_codeta,
           null,
           null,
           c_s.fecha_creacion,
           c_s.imsi,
           c_s.esn,
           c_s.nro_pin);
      End If;

    End LOOP;

  END P_POST_CARGA_INFO_EQU_CDMA_GSM;

  PROCEDURE P_PRE_BAJA_SERVICIO_RI(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      --SELECT a.codsolot, f.codinssrv, f.pid, c.codnumtel
      SELECT a.codsolot, f.codinssrv, f.pid, c.codnumtel, b.idplan, b.codsrv, ins.codcli, ins.numslc, ins.numero--22.0
        FROM wf a,
             tystabsrv b,
             numtel c,
             plan_redint d,
             (select a.codsolot, b.codinssrv, max(c.pid) pid
                from solotpto a, inssrv b, insprd c
               where a.codinssrv = b.codinssrv
                 and b.tipinssrv = 3
                 and b.codinssrv = c.codinssrv
                 and c.flgprinc = 1
                 and c.estinsprd <> 4
                 and c.fecini is not null
               group by a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE a.idwf = a_idwf
         AND a.codsolot = e.codsolot
         AND f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codinssrv = c.codinssrv
         AND f.codsrv = b.codsrv
         AND b.idplan = d.idplan
         AND d.idtipo in (2, 3)
         and e.codinssrv = ins.codinssrv--22.0
         AND d.idplataforma = 3; --28.0 Plataforma Tellin
    -- 10.0 Se modifica Cursor para paquetes pymes wimax y se adicionan variables
    CURSOR cur_codinssrv_pymes IS --paquetes pymes wimax
      --SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel
      SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel, c.idplan, c.codsrv, e.codcli, e.numslc, e.numero
        FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and e.codinssrv = a.codinssrv
         and e.codinssrv = f.codinssrv
         and e.codinssrv = b.codinssrv
         and b.codsrv = c.codsrv
         and b.estinsprd != 4
         and b.flgprinc = 1
         and b.fecfin is null
         and e.cid is not null
         and e.tipinssrv = 3;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar   esttarea.tipesttar%TYPE;
    ls_resultado   varchar2(400);
    a_tipoproc     NUMBER;
    ls_tipsrv      solot.tipsrv%type;
    ln_reser_telef NUMBER;
    ln_control     number;
    ln_codsolot    solot.codsolot%type;
    ls_numslc      inssrv.numslc%type;
    ls_val_solot   varchar2(200);
    p_pid          insprd.pid%type;
    -- ini 22.0
    vn_salida  number;
    vv_tipdide vtatabcli.tipdide%type;
    vv_ntdide  vtatabcli.ntdide%type;
    vv_apepatcli varchar2(140);
    vv_apematcli vtatabcli.apematcli%type;
    vv_nomclires vtatabcli.nomclires%type;
    vv_ruc       vtatabcli.ntdide%type;
    vv_razon     vtatabcli.nomcli%type;
    vv_telefono1 vtatabcli.telefono1%type;
    vv_telefono2 vtatabcli.telefono2%type;
    vv_dirsuc    vtasuccli.dirsuc%type;
    vv_referencia vtasuccli.referencia%type;
    vv_nomdst  v_ubicaciones.nomdst%type;
    vv_nompvc  v_ubicaciones.nompvc%type;
    vv_nomest  v_ubicaciones.nomest%type;
    vv_nomemail marketing.vtaafilrecemail.nomemail%type;
    vn_plan     plan_redint.plan%type;
    vn_plan_opcional plan_redint.plan_opcional%type;
    vv_imsi          varchar2(15);
    vv_ciclo         varchar2(2);
    vn_plan_old  plan_redint.plan%type;
    vn_plan_opcional_old plan_redint.plan_opcional%type;
    vv_numero_old   inssrv.numero%type;
    vv_imsi_old     varchar2(15);
    vv_trama        varchar2(1500);
    vv_action       varchar2(1);
    vn_result       number(1);
    vn_cicfac       number;
    vn_dia          number;
    vn_idtrans      number;
    vv_resultado    varchar2(2);
    vv_message      varchar2(50);
    vv_fecini_cicfac   varchar2(2);
    vv_envio           varchar2(2);
    ve_hctr            varchar2(8);
    ve_imsi            varchar2(8);
    vs_hctr            varchar2(8);
    vs_imsi            varchar2(8);
    -- fin 22.0
  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    begin
      -- 10.0 Se agrega variables
      select b.tipsrv, b.codsolot, i.numslc
        into ls_tipsrv, ln_codsolot, ls_numslc
        from wf a, solot b, solotpto p, inssrv i
       where a.idwf = a_idwf
         and a.codsolot = b.codsolot
         and p.codsolot = b.codsolot
         and i.codinssrv = p.codinssrv
       group by b.tipsrv, b.codsolot, i.numslc;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el tipo de servicio.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un tipo de servicio.';
        raise exception_actv;
    end;

    IF ls_tipsrv = '0058' THEN
      -- 10.0 Inicio Se modifica toda la Lógica en caso de Paquetes TN
      select f_val_solot(ln_codsolot, ls_numslc)
        into ls_val_solot
        from dummy_ope;

      If ls_val_solot <> 'OK' then
        ls_mensaje := ls_val_solot;
        raise exception_actv;
      End If;

      Begin
        select count(a.codinssrv)
          into ln_reser_telef
          from inssrv a, solotpto b, wf e, numtel f
         where e.idwf = a_idwf
           and b.codsolot = e.codsolot
           and a.codinssrv = b.codinssrv
           and a.codinssrv = f.codinssrv(+)
           and a.numero is null;
      Exception
        when no_data_found then
          ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
          raise exception_actv;
      End;

      If ln_reser_telef > 0 then
        ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
        raise exception_actv;
      End if;

      select F_GET_CANT_CONTROL(wf.codsolot)
        into ln_control
        from wf
       where wf.idwf = a_idwf;

      If ln_control > 0 then
        Begin
          Select b.pid
            into p_pid
            from solotpto    a,
                 insprd      b,
                 tystabsrv   c,
                 wf          d,
                 inssrv      e,
                 plan_redint h
           where d.idwf = a_idwf
             and a.codsolot = d.codsolot
             and e.codinssrv = a.codinssrv
             and e.tipinssrv = 3
             and b.codinssrv = e.codinssrv
             and c.codsrv = b.codsrv
             and h.idtipo in (2, 3) --control,prepago
             and h.idplan = c.idplan
           group by b.pid;
        Exception
          when others then
            ls_mensaje := 'Error al obtener Servicio de las Líneas Control.';
            raise exception_actv;
        End;

        FOR C1 IN cur_codinssrv_pymes LOOP
            --ini 22.0
          -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- ini 22.0
          if vn_salida > 0 then -- 22.0
             --select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
             select vc.tipdide,vc.ntdide,replace(vc.nomclires,'|',' ')|| ' ' || replace(vc.apepatcli,'|',' '),
                    replace(vc.nomclires,'|',' ')nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    replace(vc.nomcli,'|',' ')nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select replace(vsuc.dirsuc,'|',' ')dirsuc ,replace(vsuc.referencia,'|',' ')referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;
             Begin
               select  z.nomemail
               into vv_nomemail
               from
               (SELECT v.nomemail
               FROM marketing.vtaafilrecemail v
               where v.codcli = C1.codcli
               order by v.fecusu desc) z
               where rownum = 1;
             --<26.0
             exception
               when others then
                 vv_nomemail := '';
             end;
             --26.0>
             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             --<27.0
             begin
              select to_number(to_char(trunc(min(fectrs)), 'dd'))
                into vn_dia
                from trssolot
               where numslc = C1.numslc
                 and tiptrs = 1
                 and esttrs = 2;
              exception
                when others then
                   vn_dia := null;
               end;

             --vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             --27.0>
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

             begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '2';
             vv_trama := C1.numero || '|' || vs_imsi || vv_imsi || '|' || vs_hctr || to_char(C1.codinssrv);
             vv_envio := '';

             /*operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(C1.codcli,C1.codcli,vv_ruc,
                                                                             vv_nomclires,vv_apepatcli,vv_tipdide,
                                                                             vv_ntdide,vv_razon,vv_telefono1,
                                                                             vv_telefono2,vv_nomemail,vv_dirsuc,
                                                                             vv_referencia,vv_nomdst, vv_nompvc,
                                                                             vv_nomest,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_ciclo, 2,
                                                                             vv_trama,vn_plan, vn_plan_opcional,
                                                                             vn_plan_old,vn_plan_opcional_old,vv_numero_old,
                                                                             vv_imsi_old,vn_result,vn_idtrans);*/

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio, vv_envio,
                                                                             vv_envio,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_envio, 2,
                                                                             vv_trama,vv_envio, vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vn_result,vn_idtrans);

             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS(vn_idtrans,
                tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--23.0
                                                                         2,
                                                                  vv_trama,
                                                                  vv_resultado,
                                                                  vv_message);

              --<24.0
              BEGIN
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (a_idtareawf, vv_message);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --24.0>
             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

             vn_salida := -1; -- fin 22.0
          else
            -- fin 22.0
          SELECT count(*)
            INTO ln_num
            FROM int_servicio_plataforma
           WHERE codsolot = C1.codsolot
             and idtareawf = a_idtareawf
             and codinssrv = C1.codinssrv
             and pid = C1.pid
             and codnumtel = C1.codnumtel
             and iddefope = ln_definicion_operacion;

          If ln_num = 0 Then
            BEGIN
              INSERT INTO int_servicio_plataforma
                (codsolot, idtareawf, codinssrv, pid, codnumtel, iddefope)
              VALUES
                (C1.codsolot,
                 a_idtareawf,
                 C1.codinssrv,
                 p_pid,
                 C1.codnumtel,
                 ln_definicion_operacion);
            EXCEPTION
              WHEN OTHERS Then
                ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                              SQLERRM;
                raise exception_actv;
            End;
          End If;
          end if;
          commit;
          ln_ri := 1;
        End LOOP;
      End If;
      -- 10.0 Fin
    ELSE

      FOR C1 IN cur_codinssrv LOOP
        --ini 22.0
          -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- ini 22.0
          if vn_salida > 0 then -- 22.0
             --select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
             select vc.tipdide,vc.ntdide,replace(vc.nomclires,'|',' ')|| ' ' || replace(vc.apepatcli,'|',' '),
                    replace(vc.nomclires,'|',' ')nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    replace(vc.nomcli,'|',' ')nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select replace(vsuc.dirsuc,'|',' ')dirsuc ,replace(vsuc.referencia,'|',' ')referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;
             Begin
               select  z.nomemail
               into vv_nomemail
               from
               (SELECT v.nomemail
               FROM marketing.vtaafilrecemail v
               where v.codcli = C1.codcli
               order by v.fecusu desc) z
               where rownum = 1;
             --<26.0
             exception
               when others then
                 vv_nomemail := '';
             end;
             --26.0>
             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             --<27.0
             begin
              select to_number(to_char(trunc(min(fectrs)), 'dd'))
                into vn_dia
                from trssolot
               where numslc = C1.numslc
                 and tiptrs = 1
                 and esttrs = 2;
              exception
                when others then
                   vn_dia := null;
               end;

             --vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             --27.0>
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

             begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             ve_hctr := 'P_HCTR';
             ve_imsi := 'P_IMSI';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '2';
             vv_trama := C1.numero || '|' || vs_imsi || vv_imsi || '|' || vs_hctr || to_char(C1.codinssrv);
             vv_envio := '';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio, vv_envio,
                                                                             vv_envio,vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_envio, 2,
                                                                             vv_trama,vv_envio, vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vn_result,vn_idtrans);

             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS(vn_idtrans,
                tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--23.0
                                                                   vv_action,
                                                                   vv_trama,
                                                                   vv_resultado,
                                                                   vv_message);

              --<24.0
              BEGIN
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (a_idtareawf, vv_message);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --24.0>
             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

             vn_salida := -1; -- fin 22.0
         else
        SELECT count(*)
          INTO ln_num
          FROM int_servicio_plataforma
         WHERE codsolot = C1.codsolot
           and idtareawf = a_idtareawf
           and codinssrv = C1.codinssrv
           and pid = C1.pid
           and codnumtel = C1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_num = 0 Then
          BEGIN
            INSERT INTO int_servicio_plataforma
              (codsolot, idtareawf, codinssrv, pid, codnumtel, iddefope)
            VALUES
              (C1.codsolot,
               a_idtareawf,
               C1.codinssrv,
               C1.pid,
               C1.codnumtel,
               ln_definicion_operacion);
          EXCEPTION
            WHEN OTHERS Then
              ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                            SQLERRM;
              raise exception_actv;
          End;
        End If;
        end if;
        commit;
        ln_ri := 1;
      End LOOP;
    END IF;

    If ln_ri = 0 Then

      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    ELSIf ln_ri = 1 Then
      if vn_salida = 0 then -- 22.0
      BEGIN
      ---ini 18.0 comentados por pruebas
      ---ini 19.0 Descomentado
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
      ---fin 19.0 Descomentado
      ---fin 18.0
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;
      end if;
    End If;
  EXCEPTION
    when exception_actv then

      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_BAJA_SERVICIO_RI;

  PROCEDURE P_CHG_BAJA_SERVICIO_RI(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_BAJA_SERVICIO_RI(a_idtareawf,
                             a_idwf, /*a_tarea*/
                             null,
                             a_tareadef);
    end if;
  END P_CHG_BAJA_SERVICIO_RI;

  PROCEDURE P_PRE_CAMBIO_SERVICIO_RI(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      --SELECT a.codsolot, e.codinssrv, b.pid, a.pid_old, f.codnumtel
        SELECT a.codsolot, e.codinssrv, b.pid, a.pid_old, f.codnumtel ,c.idplan , b.codsrv, e.codcli, e.numslc, e.numero
        FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
       WHERE d.idwf = a_idwf
         AND a.codsolot = d.codsolot
         AND a.pid = b.pid
         AND e.codinssrv = b.codinssrv
         AND e.codinssrv = f.codinssrv
         AND e.tipinssrv = 3
         AND b.codsrv = c.codsrv
         AND c.tipsrv = '0004'
         AND b.flgprinc = 1;

    ln_definicion_operacion int_servicio_plataforma.iddefope%TYPE;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_codsrv_nue           tystabsrv.codsrv%TYPE;
    ls_codsrv_ant           tystabsrv.codsrv%TYPE;
    ln_tipo                 NUMBER;
    ln_pid                  insprd.pid%TYPE;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar   esttarea.tipesttar%TYPE;
    ls_resultado   varchar2(400);
    a_tipoproc     NUMBER;
    ln_reser_telef NUMBER; --2.0
    --ini 17.0
    ln_idplan      number;
    ln_idplan_nue  number;
    ln_idplan_ant  number;
    --fin 17.0
    -- ini 22.0
    vn_salida  number;
    vv_tipdide vtatabcli.tipdide%type;
    vv_ntdide  vtatabcli.ntdide%type;
    vv_apepatcli varchar2(140);
    vv_apematcli vtatabcli.apematcli%type;
    vv_nomclires vtatabcli.nomclires%type;
    vv_ruc       vtatabcli.ntdide%type;
    vv_razon     vtatabcli.nomcli%type;
    vv_telefono1 vtatabcli.telefono1%type;
    vv_telefono2 vtatabcli.telefono2%type;
    vv_dirsuc    vtasuccli.dirsuc%type;
    vv_referencia vtasuccli.referencia%type;
    vv_nomdst  v_ubicaciones.nomdst%type;
    vv_nompvc  v_ubicaciones.nompvc%type;
    vv_nomest  v_ubicaciones.nomest%type;
    vv_nomemail marketing.vtaafilrecemail.nomemail%type;
    vn_plan     plan_redint.plan%type;
    vn_plan_opcional plan_redint.plan_opcional%type;
    vv_imsi          varchar2(15);
    vv_ciclo         varchar2(2);
    vn_plan_old  plan_redint.plan%type;
    vn_plan_opcional_old plan_redint.plan_opcional%type;
    vv_numero_old   inssrv.numero%type;
    vv_imsi_old     varchar2(15);
    vv_trama        varchar2(1500);
    vv_action       varchar2(2);
    vn_result       number(1);
    vn_cicfac       number;
    vn_dia          number;
    vn_idtrans      number;
    vv_resultado    varchar2(2);
    vv_message      varchar2(50);
    vv_fecini_cicfac varchar2(2);
    vs_imsi         varchar2(8);
    ve_imsi         varchar2(8);
    vs_hctr         varchar2(8);
    ve_hctr         varchar2(8);
    vv_envio           varchar2(2);
    -- fin 22.0
  BEGIN

    ln_ri          := 0;
    ln_reser_telef := 0; --2.0

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    /*LPATINO Validacion de numero telefonico 2.0*/
    select count(d.codinssrv)
      into ln_reser_telef
      from wf          a,
           solotpto    b,
           insprd      c,
           inssrv      d,
           numtel      e,
           tystabsrv   f,
           plan_redint g
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot
       and b.pid = c.pid
       and c.flgprinc = 1
       and c.codinssrv = d.codinssrv
       and d.tipinssrv = 3
       and c.codsrv = f.codsrv
       and f.idplan = g.idplan
       and g.idtipo in (2, 3)
       and d.codinssrv = e.codinssrv(+)
       and d.numero is null;

    if ln_reser_telef > 0 then
      ls_mensaje := 'Existe servicios que no tienen asignado numero telefonico, realizar asignacion y luego cambiar la tarea a estado Generada.';
      raise exception_actv;
    end if;
    /*LPATINO Validacion de numero telefonico*/

    FOR C1 IN cur_codinssrv LOOP

      ln_pid        := NULL;
      ln_tipo       := NULL;
      ls_codsrv_nue := NULL;
      ls_codsrv_ant := NULL;

      BEGIN
        --ini 17.0
        --SELECT a.codsrv
        --  INTO ls_codsrv_nue
        SELECT a.codsrv,b.idplan
          INTO ls_codsrv_nue,ln_idplan_nue
        --fin 17.0
          FROM insprd a, tystabsrv b, plan_redint c
         WHERE a.pid = C1.pid
           AND a.codsrv = b.codsrv
           AND b.idplan = c.idplan
           AND c.idtipo in (2, 3); --control,prepago
      EXCEPTION
        WHEN no_data_found THEN
          ls_codsrv_nue := NULL;
      END;

      BEGIN
        --ini 17.0
        --SELECT a.codsrv
        --  INTO ls_codsrv_ant
        SELECT a.codsrv,b.idplan
          INTO ls_codsrv_ant,ln_idplan_ant
        --fin 17.0
          FROM insprd a, tystabsrv b, plan_redint c
         WHERE a.pid = C1.pid_old
           AND a.codsrv = b.codsrv
           AND b.idplan = c.idplan
           AND c.idtipo in (2, 3); --control,prepago
      EXCEPTION
        WHEN no_data_found THEN
          ls_codsrv_ant := NULL;
      END;

      IF ls_codsrv_nue IS NOT NULL AND ls_codsrv_ant IS NOT NULL THEN
        IF ls_codsrv_nue <> ls_codsrv_ant THEN
          ln_tipo := 3;
          ln_pid  := C1.pid;
          ln_idplan := ln_idplan_nue; --17.0
        ELSE
          ln_tipo := NULL;
        END IF;
      ELSIF ls_codsrv_nue IS NOT NULL AND ls_codsrv_ant IS NULL THEN
        ln_tipo := 1;
        ln_pid  := C1.pid;
        ln_idplan := ln_idplan_nue; --17.0
      ELSIF ls_codsrv_nue IS NULL AND ls_codsrv_ant IS NOT NULL THEN
        ln_tipo := 2;
        ln_pid  := C1.pid_old;
        ln_idplan := ln_idplan_ant; --17.0
      END IF;

      IF ln_tipo IS NOT NULL THEN
        --ini 22.0
         -- Validar si el producto tiene configurado para el asignamiento de la plataforma RSCS
          P_VALIDA_ASIG_PLATAF_BSCS(C1.idplan, C1.codsrv, vn_salida); -- Ini 22.0
          if vn_salida > 0 then -- 22.0
             --select vc.tipdide,vc.ntdide,vc.nomclires || ' ' || vc.apepatcli,  --vc.apepatcli || ' ' || vc.apematcli,
             select vc.tipdide,vc.ntdide,replace(vc.nomclires,'|',' ')|| ' ' || replace(vc.apepatcli,'|',' '),
                    replace(vc.nomclires,'|',' ')nomclires,decode(vc.tipdide,'001',vc.ntdide,null),
                    --decode(vc.tipdide,'001',vc.nomcli,vc.apepatcli || ' ' || vc.apematcli || ' ' || vc.nomclires),
                    replace(vc.nomcli,'|',' ')nomcli,
                    vc.telefono1,vc.telefono2
             into  vv_tipdide,vv_ntdide,vv_apepatcli,
                   vv_nomclires,vv_ruc,
                   vv_razon,
                   vv_telefono1,vv_telefono2
             from vtatabcli vc
             where vc.codcli = C1.codcli;

             begin
                 select replace(vsuc.dirsuc,'|',' ')dirsuc ,replace(vsuc.referencia,'|',' ')referencia,vu.nomdst,vu.nompvc,vu.nomest
                 into vv_dirsuc, vv_referencia, vv_nomdst, vv_nompvc, vv_nomest
                 from vtasuccli vsuc,
                      (select distinct codsuc
                       from vtadetptoenl vdet
                       where vdet.numslc = C1.numslc) vv,
                      v_ubicaciones vu
                 where vsuc.codsuc = vv.codsuc and
                       vsuc.ubisuc = vu.codubi (+);
             exception
               when others then
                 vv_dirsuc := '';
                 vv_referencia := '';
                 vv_nomdst := '';
                 vv_nompvc := '';
                 vv_nomest := '';
             end;
             Begin
               select  z.nomemail
               into vv_nomemail
               from
               (SELECT v.nomemail
               FROM marketing.vtaafilrecemail v
               where v.codcli = C1.codcli
               order by v.fecusu desc) z
               where rownum = 1;
             --<26.0
             exception
               when others then
                 vv_nomemail := '';
             end;
             --26.0>
             select pr.plan, pr.plan_opcional
             into vn_plan, vn_plan_opcional
             from PLAN_REDINT pr
             where pr.idplan = C1.idplan;

             vn_dia    := billcolper.pq_transfer_billing.f_get_dia_inicio(C1.numslc);
             vn_cicfac := billcolper.pq_transfer_billing.f_obtiene_ciclo(6 ,vn_dia);

             begin
                 select distinct(TO_CHAR(fecini, 'DD'))
                 into   vv_fecini_cicfac
                 from BILLCOLPER.FECHAXCICLO where cicfac = vn_cicfac;
             exception
             when others then
                vv_fecini_cicfac := '01';
             end;

             vv_imsi := C1.numero;
             vv_ciclo := vv_fecini_cicfac;
             vn_plan_old := '';
             vn_plan_opcional_old := '';
             vv_numero_old := '';
             vv_imsi_old := '';
             vv_action := '16';

             begin
                 select t.plan_old,t.plan_opcional_old
                 into vn_plan_old, vn_plan_opcional_old
                 from
                 (select intplat.plan_old,intplat.plan_opcional_old
                 from operacion.int_plataforma_bscs intplat
                 where intplat.codigo_cliente = C1.Codcli and
                 intplat.co_id = C1.CODINSSRV
                 order by intplat.fecusu desc) t
                 where rownum = 1;
             exception
             when others then
              vn_plan_old := '';
              vn_plan_opcional_old := '';
              P_PRE_CONF_SERVICIO_RI(a_idtareawf,a_idwf,a_tarea,a_tareadef);--26.0
             end;

             if vn_plan_old is not null or vn_plan_opcional_old is not null then

             ve_imsi := 'P_IMSI';
             ve_hctr := 'P_HCTR';

             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_imsi,vs_imsi);
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.P_CONFIG_PARAMETRO_JANUS(ve_hctr,vs_hctr);

             --vv_trama := C1.numero|| '|' ||  vs_imsi || to_char(C1.codinssrv) || '|' || vn_plan || '|' ||  vn_plan_opcional|| '|' || vn_plan_old || '|' ||  vn_plan_opcional_old;
             vv_trama := C1.numero|| '|' || vs_hctr || to_char(C1.codinssrv) || '|' || vn_plan || '|' ||  vn_plan_opcional|| '|' || vn_plan_old || '|' ||  vn_plan_opcional_old;

             vv_envio := '';
             /*operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(C1.codcli,C1.codcli,vv_ruc,
                                                                             vv_nomclires,vv_apepatcli,vv_tipdide,
                                                                             vv_ntdide,vv_razon,vv_telefono1,
                                                                             vv_telefono2,vv_nomemail,vv_dirsuc,
                                                                             vv_referencia,vv_nomdst, vv_nompvc,
                                                                             vv_nomest,to_char(C1.codinssrv),C1.numero,
                                                                             vs_imsi || vv_imsi, vv_ciclo, 16,
                                                                             vv_trama,vn_plan, vn_plan_opcional,
                                                                             vn_plan_old,vn_plan_opcional_old,vv_numero_old,
                                                                             vv_imsi_old,vn_result,vn_idtrans);
                                                                             */
             operacion.PQ_OPE_ASIG_PLATAF_JANUS.p_insert_int_plataforma_bscs(vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio,vv_envio,
                                                                             vv_envio,vv_envio, vv_envio,
                                                                             vv_envio, vs_hctr || to_char(C1.codinssrv),C1.numero,
                                                                             vv_envio, vv_envio, 16,
                                                                             vv_trama,vn_plan, vn_plan_opcional,
                                                                             vn_plan_old,vn_plan_opcional_old,vv_numero_old,
                                                                             vv_imsi_old,vn_result,vn_idtrans);

             -- Invocacion del servicio de la plataforma BSCS para la Alta del servicio.
             --tim.pp001_pkg_prov_janus_ctrl.sp_reg_prov@DBL_BSCS(vn_idtrans,
                tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(vn_idtrans,--23.0
                                                                   vv_action,
                                                                   vv_trama,
                                                                   vv_resultado,
                                                                   vv_message);
              --<24.0
              BEGIN
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (a_idtareawf, vv_message);
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              --24.0>
             UPDATE operacion.int_plataforma_bscs SET RESULTADO = vv_resultado, message_resul = vv_message
             WHERE idtrans = vn_idtrans;

             vn_salida := -1; -- 22.0

             end if;
         else
         --fin 22.0
        BEGIN
          SELECT a.iddefope
            INTO ln_definicion_operacion
            FROM int_operacion_tareadef a
           WHERE a.tareadef = a_tareadef
             AND tipo = ln_tipo;
        exception
          when no_data_found then
            ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
            raise exception_actv;
          when too_many_rows then
            ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
            raise exception_actv;
        end;

        SELECT count(*)
          INTO ln_num
          FROM int_servicio_plataforma
         WHERE codsolot = C1.codsolot
           and idtareawf = a_idtareawf
           and codinssrv = C1.codinssrv
           and pid = ln_pid
           and codnumtel = C1.codnumtel
           and iddefope = ln_definicion_operacion;

        IF ln_num = 0 Then
          BEGIN
            INSERT INTO int_servicio_plataforma
              --ini 17.0
              --(codsolot, idtareawf, codinssrv, pid, codnumtel, iddefope)
              (codsolot, idtareawf, codinssrv, pid, idplan, codnumtel, iddefope)
              --fin 17.0
            VALUES
              (C1.codsolot,
               a_idtareawf,
               C1.codinssrv,
               ln_pid,
               ln_idplan,--17.0
               C1.codnumtel,
               ln_definicion_operacion);
          EXCEPTION
            WHEN OTHERS Then
              ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                            SQLERRM;
              raise exception_actv;
          End;
        END IF;
        end if;
        ln_ri := 1;
      END IF;
      commit;
    END LOOP;

    If ln_ri = 0 Then

      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    ELSIf ln_ri = 1 Then
      if vn_salida = 0 then -- 22.0
      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;
      End If;
    End If;
  EXCEPTION
    when exception_actv then

      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_CAMBIO_SERVICIO_RI;

  PROCEDURE P_CHG_CAMBIO_SERVICIO_RI(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number,
                                     a_tipesttar in number,
                                     a_esttarea  in number,
                                     a_mottarchg in number,
                                     a_fecini    in date,
                                     a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_CAMBIO_SERVICIO_RI(a_idtareawf,
                               a_idwf, /*a_tarea*/
                               null,
                               a_tareadef);
    end if;
  END P_CHG_CAMBIO_SERVICIO_RI;

  PROCEDURE P_PRE_BAJA_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                    a_idwf      IN NUMBER,
                                    a_tarea     IN NUMBER,
                                    a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      SELECT a.codsolot,
             e.codinssrv,
             b.pid,
             f.codnumtel,
             h.numserie,
             h.imsi,
             h.mac esn
        FROM solotpto    a,
             insprd      b,
             tystabsrv   c,
             wf          d,
             inssrv      e,
             numtel      f,
             solot       g,
             simcar      i,
             solotptoequ h, --12.0 equipos de SOT instalacion
             solotpto    j --12.0 puntos de SOT instalacion
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and a.codinssrv = e.codinssrv
         and e.codinssrv = b.codinssrv
         and b.flgprinc = 1
         and e.tipinssrv = 3
         and e.codsrv = c.codsrv
         and e.codinssrv = f.codinssrv
         --<12.0
         --and a.codsolot = h.codsolot
         and j.codsolot = (pq_cuspe_plataforma.F_GET_SOT_INS_SID(e.codinssrv))
         and e.codinssrv = j.codinssrv
         and j.codsolot = h.codsolot
         and j.punto = h.punto
         and (b.fecfin is null or b.fecfin >= trunc(sysdate)) --valida que el pid este activo
         --12.0>
         and h.imsi = i.imsi
         and i.akey IS NOT NULL;

    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar esttarea.tipesttar%TYPE;
    ls_resultado varchar2(400);
    a_tipoproc   NUMBER;

  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    FOR C1 IN cur_codinssrv LOOP

      SELECT count(*)
        INTO ln_num
        FROM int_servicio_plataforma
       WHERE codsolot = C1.codsolot
         and idtareawf = a_idtareawf
         and codinssrv = C1.codinssrv
         and pid = C1.pid
         and codnumtel = C1.codnumtel
         and iddefope = ln_definicion_operacion
         and imsi = C1.Imsi;

      If ln_num = 0 Then

        BEGIN
          INSERT INTO int_servicio_plataforma
            (codsolot,
             idtareawf,
             codinssrv,
             pid,
             codnumtel,
             iddefope,
             imsi)
          VALUES
            (C1.codsolot,
             a_idtareawf,
             C1.codinssrv,
             C1.pid,
             C1.codnumtel,
             ln_definicion_operacion,
             C1.Imsi);
        EXCEPTION
          WHEN OTHERS Then
            ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                          SQLERRM;
            raise exception_actv;
        End;
      End If;
      commit;
      ln_ri := 1;
    End LOOP;

    If ln_ri = 0 Then

      ls_mensaje := 'No se encontro registros para enviar a la plataforma HRL.';
      raise exception_actv;

    ELSIf ln_ri = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;

    End If;
  EXCEPTION
    when exception_actv then

      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_BAJA_SERVICIO_HLR;

  PROCEDURE P_CHG_BAJA_SERVICIO_HLR(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number,
                                    a_tipesttar in number,
                                    a_esttarea  in number,
                                    a_mottarchg in number,
                                    a_fecini    in date,
                                    a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_BAJA_SERVICIO_HLR(a_idtareawf,
                              a_idwf, /*a_tarea*/
                              null,
                              a_tareadef);
    end if;
  END P_CHG_BAJA_SERVICIO_HLR;

  PROCEDURE P_PRE_SUSPENSION_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      SELECT a.codsolot,
             e.codinssrv,
             b.pid,
             f.codnumtel,
             h.numserie,
             h.imsi,
             h.mac esn
        FROM solotpto a,
             insprd b,
             tystabsrv c,
             wf d,
             inssrv e,
             numtel f,
             solot g,
             (select a.codsolot, a.codinssrv, b.numserie, b.imsi, b.mac
                from solotpto a, solotptoequ b
               where a.codsolot = b.codsolot
                 and a.punto = b.punto) h,
             simcar i
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and a.codinssrv = e.codinssrv
         and e.codinssrv = b.codinssrv
         and b.flgprinc = 1
         and e.tipinssrv = 3
         and e.codsrv = c.codsrv
         and e.codinssrv = f.codinssrv
         and a.codinssrv = h.codinssrv
         and h.imsi = i.imsi
         and i.akey IS NOT NULL;

    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar esttarea.tipesttar%TYPE;
    ls_resultado varchar2(400);
    a_tipoproc   NUMBER;

  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    FOR C1 IN cur_codinssrv LOOP

      SELECT count(*)
        INTO ln_num
        FROM int_servicio_plataforma
       WHERE codsolot = C1.codsolot
         and idtareawf = a_idtareawf
         and codinssrv = C1.codinssrv
         and pid = C1.pid
         and codnumtel = C1.codnumtel
         and iddefope = ln_definicion_operacion
         and imsi = C1.Imsi;

      If ln_num = 0 Then
        BEGIN
          INSERT INTO int_servicio_plataforma
            (codsolot,
             idtareawf,
             codinssrv,
             pid,
             codnumtel,
             iddefope,
             imsi)
          VALUES
            (C1.codsolot,
             a_idtareawf,
             C1.codinssrv,
             C1.pid,
             C1.codnumtel,
             ln_definicion_operacion,
             C1.Imsi);
        EXCEPTION
          WHEN OTHERS Then
            ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                          SQLERRM;
            raise exception_actv;
        End;
      End If;
      commit;
      ln_ri := 1;
    End LOOP;

    If ln_ri = 0 Then
      ls_mensaje := 'No se encontro registros para enviar a la plataforma HRL.';
      raise exception_actv;

    ELSIf ln_ri = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;

    End If;
  EXCEPTION
    when exception_actv then

      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_SUSPENSION_SERVICIO_HLR;

  PROCEDURE P_CHG_SUSPENSION_SERVICIO_HLR(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_SUSPENSION_SERVICIO_HLR(a_idtareawf,
                                    a_idwf, /*a_tarea*/
                                    null,
                                    a_tareadef);
    end if;
  END P_CHG_SUSPENSION_SERVICIO_HLR;

  PROCEDURE P_PRE_RECONEXION_SERVICIO_HLR(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      SELECT a.codsolot,
             e.codinssrv,
             b.pid,
             f.codnumtel,
             h.numserie,
             h.imsi,
             h.mac esn
        FROM solotpto a,
             insprd b,
             tystabsrv c,
             wf d,
             inssrv e,
             numtel f,
             solot g,
             (select a.codsolot, a.codinssrv, b.numserie, b.imsi, b.mac
                from solotpto a, solotptoequ b
               where a.codsolot = b.codsolot
                 and a.punto = b.punto) h,
             simcar i
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and a.codinssrv = e.codinssrv
         and e.codinssrv = b.codinssrv
         and b.flgprinc = 1
         and e.tipinssrv = 3
         and e.codsrv = c.codsrv
         and e.codinssrv = f.codinssrv
         and a.codinssrv = h.codinssrv
         and h.imsi = i.imsi
         and i.akey IS NOT NULL;

    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_ri                   NUMBER;
    ln_num                  NUMBER;
    ls_mensaje              varchar2(4000);
    exception_actv exception;
    ls_tipesttar esttarea.tipesttar%TYPE;
    ls_resultado varchar2(400);
    a_tipoproc   NUMBER;

  BEGIN

    ln_ri := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    begin
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef;
    exception
      when no_data_found then
        ls_mensaje := 'No se encontro el codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un codigo de la operacion de la interfaz asociada a la tarea.';
        raise exception_actv;
    end;

    --No se encuentra la operacion de la plataforma HLR para la tarea:
    FOR C1 IN cur_codinssrv LOOP

      SELECT count(*)
        INTO ln_num
        FROM int_servicio_plataforma
       WHERE codsolot = C1.codsolot
         and idtareawf = a_idtareawf
         and codinssrv = C1.codinssrv
         and pid = C1.pid
         and codnumtel = C1.codnumtel
         and iddefope = ln_definicion_operacion
         and imsi = C1.Imsi;

      If ln_num = 0 Then

        BEGIN
          INSERT INTO int_servicio_plataforma
            (codsolot,
             idtareawf,
             codinssrv,
             pid,
             codnumtel,
             iddefope,
             imsi)
          VALUES
            (C1.codsolot,
             a_idtareawf,
             C1.codinssrv,
             C1.pid,
             C1.codnumtel,
             ln_definicion_operacion,
             C1.Imsi);
        EXCEPTION
          WHEN OTHERS Then
            ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                          SQLERRM;
            raise exception_actv;
        End;
      End If;
      commit;
      ln_ri := 1;
    End LOOP;

    If ln_ri = 0 Then
      ls_mensaje := 'No se encontro registros para enviar a la plataforma HRL.';
      raise exception_actv;

    ELSIf ln_ri = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_actv;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_actv;
      End;

    End If;
  EXCEPTION
    when exception_actv then

      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;

  END P_PRE_RECONEXION_SERVICIO_HLR;

  PROCEDURE P_CHG_RECONEXION_SERVICIO_HLR(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_RECONEXION_SERVICIO_HLR(a_idtareawf,
                                    a_idwf, /*a_tarea*/
                                    null,
                                    a_tareadef);
    end if;
  END P_CHG_RECONEXION_SERVICIO_HLR;

  PROCEDURE P_GENERA_SOLIC_INTERFAZ(a_idtareawf IN NUMBER,
                                    a_tipo      IN NUMBER,
                                    a_resultado IN OUT VARCHAR2,
                                    a_mensaje   IN OUT VARCHAR2) IS

    CURSOR cur_servicio IS
      SELECT a.idseq,
             to_char(a.idseq) valor_parametro,
             to_char(a.iddefope) definicion_operacion
        FROM int_servicio_plataforma a
       WHERE a.idtareawf = a_idtareawf
         and a.idlote is null;

    ls_tipo_parametro VARCHAR2(4000);
    ls_resultado      VARCHAR2(4000);
    ls_mensaje_rs     VARCHAR2(4000);
    ls_mensaje        VARCHAR2(4000);
    ls_resultado_ok   VARCHAR2(4000);
    ln_error          NUMBER(1);
    ln_num            NUMBER;
    ls_tipesttar      esttarea.tipesttar%TYPE;
    exception_interfaz exception;

  BEGIN

    a_resultado     := 'OK';
    ls_resultado_ok := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_EXITO;

    BEGIN
      SELECT to_char(codigon)
        into ls_tipo_parametro
        FROM int_definicion_parametro
       WHERE UPPER(codigoc) = UPPER('IDSEQ');
    exception
      when no_data_found then
        a_mensaje := 'No se encontro la definicion_parametro "IDSEQ".';
        raise exception_interfaz;
      when too_many_rows then
        a_mensaje := 'Se encontro mas de un definicion_parametro "IDSEQ".';
        raise exception_interfaz;
    end;

    FOR C1 IN cur_servicio LOOP

      ln_error      := 0;
      ls_mensaje_rs := '';
      ls_mensaje    := '';

      BEGIN
        pq_int_comando_plataforma.p_generar_lote_comando(C1.definicion_operacion,
                                                         ls_tipo_parametro,
                                                         C1.valor_parametro,
                                                         ls_resultado,
                                                         ls_mensaje_rs);

      EXCEPTION
        WHEN OTHERS Then
          ln_error := 1;
      End;

      If ln_error = 1 OR (TRIM(ls_resultado_ok) <> TRIM(ls_resultado)) Then

        ls_mensaje := 'No se pudo generar solicitud a la plataforma error: ' ||
                      ls_mensaje_rs;

        UPDATE int_servicio_plataforma
           SET estado = 3 --error
         WHERE idseq = C1.idseq;

        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, ls_mensaje);

      Else
        UPDATE int_servicio_plataforma
           SET idlote = to_number(ls_mensaje_rs), estado = 1 --enviado
         WHERE idseq = C1.idseq;

        ls_mensaje := 'Se genero IDLOTE: ' || ls_mensaje_rs;
        -- 2.0 inicio
        begin
          insert into OPEWF.tareawfseg
            (idtareawf, observacion)
          values
            (a_idtareawf, ls_mensaje);
        exception
          when others then
            begin
              insert into OPEWF.tareawfseg
                (idtareawf, observacion)
              values
                (a_idtareawf, ls_mensaje);
            exception
              when others then
                NULL;
            end;
        end;
        -- 2.0 fin inicio
      End If;
      COMMIT;
    End LOOP;

    SELECT count(*)
      INTO ln_num
      FROM int_servicio_plataforma
     WHERE idtareawf = a_idtareawf
       and idlote is null;

    IF ln_num > 0 THEN

      IF a_tipo = 1 THEN

        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        If ln_num > 0 Then
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                           ls_tipesttar,
                                           cn_esttarea_error,
                                           0,
                                           SYSDATE,
                                           SYSDATE);
        End If;
      ELSE
        a_mensaje := 'Error al generar solicitud a la plataforma.';
        raise exception_interfaz;
      END IF;

    END IF;
  EXCEPTION
    WHEN exception_interfaz Then
      a_resultado := 'ERROR';
    WHEN OTHERS Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error al generar solicitud para interfaz zzz:' ||
                     SQLERRM;

  END P_GENERA_SOLIC_INTERFAZ;

  PROCEDURE P_ACT_ESTADO_TAREA(a_idlote    int_servicio_plataforma.idlote%type,
                               a_resultado VARCHAR2,
                               a_mensaje   VARCHAR2) IS

    --5.0 pragma autonomous_transaction;--4.0

    ln_estado_ok    CONSTANT NUMBER(1) := 2;
    ln_estado_error CONSTANT NUMBER(1) := 3;
    ln_idtareawf     tareawf.idtareawf%TYPE;
    ln_tareadef      tareawf.tareadef%TYPE;
    ln_esttarea      tareawf.esttarea%type;
    ln_esttarea_fin  tareawf.esttarea%type;
    ls_tarea         tareadef.descripcion%type;
    ln_tipesttar_fin esttarea.tipesttar%type;
    ln_codsolot      int_servicio_plataforma.codsolot%type;
    ln_num           NUMBER;
    ln_num_proc      NUMBER;
    ls_mensaje       opewf.tareawfseg.observacion%TYPE;
    ls_error         opewf.tareawfseg.observacion%TYPE;
    ln_exist_estarea NUMBER;
    ln_tipesttar     NUMBER; --4.0
  BEGIN
    SELECT a.idtareawf, a.codsolot
      INTO ln_idtareawf, ln_codsolot
      FROM int_servicio_plataforma a
     WHERE a.idlote = a_idlote;

    Begin
      select t.tareadef, t.esttarea, d.descripcion, t.tipesttar --4.0
        into ln_tareadef, ln_esttarea, ls_tarea, ln_tipesttar --4.0
        from tareawf t, tareadef d
       where t.idtareawf = ln_idtareawf
         and t.tareadef = d.tareadef;
    Exception
      when others then
        ls_error := 'Error al obtener datos de la Tarea';
        raise;
    End;

    IF ln_tipesttar <> 4 THEN
      --4.0

      select count(*)
        into ln_exist_estarea
        from esttarea
       where esttarea in (6, 4, 5)
         and esttarea = ln_esttarea;

      IF ln_exist_estarea = 0 THEN
        Begin
          select esttarea_fin
            into ln_esttarea_fin
            from int_operacion_tareadef
           where tareadef = ln_tareadef
             and esttarea_ini = ln_esttarea
           group by esttarea_fin;
        Exception
          when others then
            ls_error := 'Error al obtener estado final de la Tarea';
            raise;
        End;

        select e.tipesttar
          into ln_tipesttar_fin
          from esttarea e
         where esttarea = ln_esttarea_fin;

      END IF;

      If a_resultado = PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_EXITO Then

        UPDATE int_servicio_plataforma
           SET estado = ln_estado_ok
         WHERE idlote = a_idlote;

        SELECT count(*)
          INTO ln_num
          FROM int_servicio_plataforma a
         WHERE a.idtareawf = ln_idtareawf
           and a.estado not in (4); -- Anulados

        SELECT count(*)
          INTO ln_num_proc
          FROM int_servicio_plataforma a
         WHERE a.idtareawf = ln_idtareawf
           and a.estado = ln_estado_ok;

        If ln_num = ln_num_proc Then

          IF ln_esttarea_fin IS NOT NULL THEN

            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(ln_idtareawf,
                                             ln_tipesttar_fin,
                                             ln_esttarea_fin,
                                             NULL,
                                             SYSDATE,
                                             SYSDATE);
          END IF;

          ls_mensaje := 'Ejecución completada en la plataforma.';

          -- 2.0 inicio
          begin
            insert into OPEWF.tareawfseg
              (idtareawf, observacion)
            values
              (ln_idtareawf, ls_mensaje);
          exception
            when others then
              begin
                insert into OPEWF.tareawfseg
                  (idtareawf, observacion)
                values
                  (ln_idtareawf, ls_mensaje);
              exception
                when others then
                  NULL;
              end;
          end;
          -- 2.0 fin
        End If;

      Else

        UPDATE int_servicio_plataforma
           SET estado = ln_estado_error
         WHERE idlote = a_idlote;

        ls_error := 'IDLOTE: ' || to_char(a_idlote) || '. ' || a_mensaje; --se concatena el lote en el mensaje de error

        --inicio 4.0
        begin
          insert into OPEWF.tareawfseg
            (idtareawf, observacion)
          values
            (ln_idtareawf, ls_error);
        exception
          when others then
            begin
              insert into OPEWF.tareawfseg
                (idtareawf, observacion)
              values
                (ln_idtareawf, ls_error);
            exception
              when others then
                NULL;
            end;
        end;
        --fin 4.0
      End If;

      P_SINC_TAREA_WEB(ln_idtareawf);

    END IF; --fin 4.0

    --5.0 Commit;--4.0

  EXCEPTION
    when others then
      rollback; --4.0
      opewf.pq_send_mail_job.p_send_mail('Revisar Actualizacion estado tarea - Plataforma',
                                         'DL-PE-ITSoportealNegocio@claro.com.pe',--14.0
                                         ls_error);

      RAISE_APPLICATION_ERROR(-20500,
                              'Error al actualizar lote: ' ||
                              to_char(a_idlote) || ',error:' || SQLERRM);
  END;

  PROCEDURE P_CHG_BAJA_SERVICIO_CS2K(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number,
                                     a_tipesttar in number,
                                     a_esttarea  in number,
                                     a_mottarchg in number,
                                     a_fecini    in date,
                                     a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_BAJA_SERVICIO_CS2K(a_idtareawf,
                               a_idwf, /*a_tarea*/
                               null,
                               a_tareadef);
    end if;
  END;

  PROCEDURE P_PRE_BAJA_SERVICIO_CS2K(a_idtareawf IN NUMBER,
                                     a_idwf      IN NUMBER,
                                     a_tarea     IN NUMBER,
                                     a_tareadef  IN NUMBER) IS

    CURSOR cur_codinssrv IS
      SELECT a.codsolot, e.codinssrv, b.pid, f.codnumtel, e.numslc
        FROM solotpto  a,
             insprd    b,
             tystabsrv c,
             wf        d,
             inssrv    e,
             numtel    f,
             solot     g
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and e.codinssrv = a.codinssrv
         and e.codinssrv = f.codinssrv(+)
         and e.codinssrv = b.codinssrv
         and e.codsrv = c.codsrv
         and b.flgprinc = 1
         and e.tipinssrv = 3
         and e.cid is not null; --10.0 Se agrega validación de CID

    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_uso                  NUMBER;
    ln_num                  NUMBER;
    ls_resultado            varchar2(4000);
    ls_mensaje              varchar2(4000);
    ln_idseq                OPEWF.tareawfseg.IDSEQ%TYPE;
    exception_baja exception;
    ls_fqdn      varchar(100);
    ln_port      reservatel.codnumtel%type;
    ls_numslc    vtatabslcfac.numslc%type;
    ln_codsolot  solot.codsolot%type;
    ls_tipesttar esttarea.tipesttar%TYPE;
    a_tipoproc   NUMBER;
    a_cant_tel   NUMBER; --10.0 Para validación de Lineas Telefonicas

  BEGIN

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    Select PQ_CUSPE_PLATAFORMA.F_GET_CANT_LINEAS_2(wf.codsolot)
      into a_cant_tel
      from wf
     where idwf = a_idwf;

    If a_cant_tel = -1 then
      ls_mensaje := 'Error al validar la cantidad de líneas telefónicas.';
      raise exception_baja;
    End If;

    IF a_cant_tel > 0 THEN
      --10.0 Validación de Lineas Telefonicas

      --se valida que exista un unico proyecto para los servicios del detalle de SOT
      begin
        SELECT distinct e.numslc
          into ls_numslc
          FROM solotpto  a,
               insprd    b,
               tystabsrv c,
               wf        d,
               inssrv    e,
               numtel    f,
               solot     g
         WHERE d.idwf = a_idwf
           and a.codsolot = d.codsolot
           and a.codsolot = g.codsolot
           and e.codinssrv = a.codinssrv
           and e.codinssrv = f.codinssrv(+)
           and e.codinssrv = b.codinssrv
           and e.codsrv = c.codsrv
           and b.flgprinc = 1
           and e.tipinssrv = 3;

      exception
        when no_data_found then
          ls_mensaje := 'No se encontro un proyecto asociado a los servicios.';
          raise exception_baja;
        when too_many_rows then
          ls_mensaje := 'Se encontro mas de un proyecto asociado a los servicios.';
          raise exception_baja;
      end;

      if ls_numslc is not null then
        --se valida que exista el FQDN
        select F_GET_PLATAFORMA_TXT_INS(ls_numslc, 'FQDN')
          into ls_fqdn
          from dummy_ope;
        if ls_fqdn is null then
          ls_mensaje := 'No se encontro FQDN.';
          raise exception_baja;
        end if;

      else
        ls_mensaje := 'No se encontro un proyecto.';
        raise exception_baja;
      end if;
      --
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef
         and tipo = 1;

      --se da de baja cada numero
      FOR C1 IN cur_codinssrv LOOP
        --se valida que exista numero telefonico
        if C1.codnumtel is null then
          ls_mensaje := 'No se encontro numero telefonico.';
          raise exception_baja;
        end if;

        --se valida si existe PORT
        select F_GET_PORT(C1.codnumtel, C1.codinssrv)
          into ln_port
          from dummy_ope;

        if ln_port is null then
          --10.0 Modificación del mensaje
          ls_mensaje := 'No se encontro PORT, instancia de servicio: ' ||
                        to_char(C1.codinssrv);
          raise exception_baja;
        end if;

        SELECT count(*)
          INTO ln_num
          FROM int_servicio_plataforma
         WHERE codsolot = C1.codsolot
           and idtareawf = a_idtareawf
           and codinssrv = C1.codinssrv
           and pid = C1.pid
           and codnumtel = C1.codnumtel
           and numslc = C1.numslc
           and iddefope = ln_definicion_operacion;

        If ln_num = 0 Then
          BEGIN
            INSERT INTO int_servicio_plataforma
              (codsolot,
               idtareawf,
               codinssrv,
               pid,
               codnumtel,
               numslc,
               iddefope)
            VALUES
              (C1.codsolot,
               a_idtareawf,
               C1.codinssrv,
               C1.pid,
               C1.codnumtel,
               C1.numslc,
               ln_definicion_operacion);
          EXCEPTION
            WHEN OTHERS Then
              ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                            SQLERRM;
              raise exception_baja;
          End;
        End If;

        COMMIT;
        ln_uso := 1;
      End LOOP;

      --se da de baja al Gateway, uno para todo la tarea

      --se obtiene el codigo de SOT
      select codsolot into ln_codsolot from wf where idwf = a_idwf;

      --se verifica que no exista el registro por reproceso
      --10.0 Se corrige el orden para obtener la operacion de tipo 0
      SELECT a.iddefope
        INTO ln_definicion_operacion
        FROM int_operacion_tareadef a
       WHERE a.tareadef = a_tareadef
         and tipo = 0;

      SELECT count(*)
        INTO ln_num
        FROM int_servicio_plataforma
       WHERE codsolot = ln_codsolot
         and idtareawf = a_idtareawf
         and numslc = ls_numslc
         and iddefope = ln_definicion_operacion;

      If ln_num = 0 Then
        begin

          INSERT INTO int_servicio_plataforma
            (codsolot, idtareawf, numslc, iddefope)
          VALUES
            (ln_codsolot, a_idtareawf, ls_numslc, ln_definicion_operacion);
          COMMIT;
          ln_uso := 1;
        EXCEPTION
          WHEN OTHERS Then
            ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                          SQLERRM;
            raise exception_baja;
        end;
      End If;

      If ln_uso = 0 Then

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         4,
                                         8,
                                         0,
                                         SYSDATE,
                                         SYSDATE);

      ELSIf ln_uso = 1 Then

        BEGIN
          P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                  a_tipoproc,
                                  ls_resultado,
                                  ls_mensaje);
          If ls_resultado = 'ERROR' Then
            raise exception_baja;
          End If;
        exception
          when others then
            ls_mensaje := 'Error al enviar a interfaz.';
            raise exception_baja;
        End;

      End If;

    ELSE
      --10.0 En caso no existan lineas telefónicas
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    END IF;

  EXCEPTION
    when exception_baja then

      select OPEWF.F_GET_ID_TAREAWFSEG() into ln_idseq from dummy_ope;
      insert into tareawfseg
        (idseq, idtareawf, observacion)
      values
        (ln_idseq, a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;
      return;
  END P_PRE_BAJA_SERVICIO_CS2K;

  PROCEDURE P_CHG_BAJA_SERVICIO_BREEZEMAX(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number,
                                          a_tipesttar in number,
                                          a_esttarea  in number,
                                          a_mottarchg in number,
                                          a_fecini    in date,
                                          a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_BAJA_SERVICIO_BREEZEMAX(a_idtareawf,
                                    a_idwf, /*a_tarea*/
                                    null,
                                    a_tareadef);
    end if;
  END;

  PROCEDURE P_PRE_BAJA_SERVICIO_BREEZEMAX(a_idtareawf IN NUMBER,
                                          a_idwf      IN NUMBER,
                                          a_tarea     IN NUMBER,
                                          a_tareadef  IN NUMBER) IS

    CURSOR cur_proyecto IS
      SELECT distinct g.codsolot,
                      e.numslc,
                      PQ_CUSPE_PLATAFORMA.F_GET_SOT_INS_PROY(e.numslc) sotins --codsolot de instalacion
        FROM solotpto a, wf d, inssrv e, solot g
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and e.codinssrv = a.codinssrv;
    --10.0 Revisión de las variables que no son utilizadas
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    ln_uso                  NUMBER;
    ln_num                  NUMBER;
    ls_suscriber            varchar2(100);
    ln_tipo                 number(1);
    ln_num_sus              NUMBER;
    ls_resultado            varchar2(4000);
    ls_mensaje              varchar2(4000);
    ln_idseq                OPEWF.tareawfseg.IDSEQ%TYPE;
    exception_baja exception;
    ls_tipesttar esttarea.tipesttar%TYPE;
    ln_numslc    vtatabslcfac.numslc%type;
    ln_codsolot  solot.codsolot%type; --10.0 Nuevo
    a_tipoproc   NUMBER;
    ls_val_solot varchar2(200); --10.0 Nuevo

  BEGIN

    ln_uso := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    BEGIN
      --10.0 Modificación por variables
      SELECT distinct e.numslc, d.codsolot
        into ln_numslc, ln_codsolot
        FROM solotpto a, wf d, inssrv e, solot g
       WHERE d.idwf = a_idwf
         and a.codsolot = d.codsolot
         and a.codsolot = g.codsolot
         and e.codinssrv = a.codinssrv
         and d.valido = 1;
    EXCEPTION
      when no_data_found then
        ls_mensaje := 'No se encontro un proyecto asociado a los servicios.';
        raise exception_baja;
      when too_many_rows then
        ls_mensaje := 'Se encontro mas de un proyecto asociado a los servicios.';
        raise exception_baja;
    END;

    --10.0 Se agrega validacion de la solicitud
    select f_val_solot(ln_codsolot, ln_numslc)
      into ls_val_solot
      from dummy_ope;

    If ls_val_solot <> 'OK' then
      ls_mensaje := ls_val_solot;
      raise exception_baja;
    End If;

    FOR C1 IN cur_proyecto LOOP

      BEGIN
        --10.0 Modificación de lógica de generación de lotes para la interfaz
        /*begin
           select PQ_CUSPE_PLATAFORMA.F_GET_VALOR_TXT_INS(C1.numslc,
                                                          'SERVICE - INTERNET')
             into lc_internet
             from dummy_ope;
        exception
           when others then
              ls_mensaje := 'Error en obtencion de internet';
              raise exception_baja;
        end;
        if lc_internet is null or lc_internet = '0' then
           ln_cant_bl := 0;
        else
           ln_cant_bl := 1;
        end if;

        begin
           select PQ_CUSPE_PLATAFORMA.F_GET_VALOR_TXT_INS(C1.numslc,
                                                          'SERVICE - TELEPHONE')
             into lc_telefono
             from dummy_ope;
        exception
           when others then
              ls_mensaje := 'Error en obtencion de telefono';
              raise exception_baja;
        end;

        if lc_telefono is null or lc_telefono = '0' then
           ln_cant_tel := 0;
        else
           ln_cant_tel := 1;
        end if;

        begin
           select distinct g.susname
             into ls_suscriber
             from inssrv           i,
                  paquete_venta    paq,
                  grupoip_servicio g,
                  solotpto         p
            where i.numslc = c1.numslc
              and paq.idpaq = i.idpaq
              and g.idgrupo = paq.idgrupo
              and p.codinssrv = i.codinssrv
              and p.codsolot = c1.sotins;
        exception
           when no_data_found then
              ls_mensaje := 'No se encontro registro de suscriber.';
              raise exception_baja;
           when too_many_rows then
              ls_mensaje := 'Se encontro mas de un registro de suscriber.';
              raise exception_baja;
        end;

        If ls_suscriber is null then
           -- Con Suscriber
           If ln_cant_tel <> 0 and ln_cant_bl <> 0 then
              -- baja Con suscriber, Telefonia e Internet
              ln_tipo := 0;
           elsif ln_cant_tel <> 0 and ln_cant_bl = 0 then
              -- baja Solo con suscriber y Telefonia
              ln_tipo := 1;
           elsif ln_cant_tel = 0 and ln_cant_bl <> 0 then
              -- baja Solo suscriber e Internet
              ln_tipo := 2;
           elsif ln_cant_tel = 0 and ln_cant_bl = 0 then
              --no tiene telefono ni internet
              ls_mensaje := 'Operacion con suscriber, no se encontro telefono ni internet';
              raise exception_baja;
           End if;
        Else
           -- Sin Suscriber
           If ln_cant_tel <> 0 and ln_cant_bl <> 0 then
              -- baja Con Telefonia e Internet
              ln_tipo := 3;
           elsif ln_cant_tel <> 0 and ln_cant_bl = 0 then
              -- baja Solo Telefonia
              ln_tipo := 4;
           elsif ln_cant_tel = 0 and ln_cant_bl <> 0 then
              -- baja Solo Internet
              ln_tipo := 5;
           elsif ln_cant_tel = 0 and ln_cant_bl = 0 then
              --no tiene telefono ni internet
              ls_mensaje := 'Operacion sin suscriber, no se encontro telefono ni internet';
              raise exception_baja;
           End if;
        End If;*/

        begin
          /*SELECT a.iddefope
           INTO ln_definicion_operacion
           FROM int_operacion_tareadef a
          WHERE a.tareadef = a_tareadef
            and tipo = ln_tipo;*/

          Select F_GET_IDDEFOPE_PROY(a_idtareawf, ln_numslc)
            into ln_definicion_operacion
            from dummy_ope;
        exception
          when no_data_found then
            ls_mensaje := 'No se encontro operacion configurada';
            raise exception_baja;
          when too_many_rows then
            ls_mensaje := 'Se encontro mas de una operacion configurada';
            raise exception_baja;
        end;

        If ln_definicion_operacion = '-1' then
          ls_mensaje := 'No se encontró operación configurada para la tarea ' ||
                        to_char(a_idtareawf);
          raise exception_baja;
        End If;
        -- 10.0 Fin modificación lógica
        SELECT count(*)
          INTO ln_num
          FROM int_servicio_plataforma
         WHERE codsolot = C1.codsolot
           and idtareawf = a_idtareawf
           and numslc = C1.numslc
           and iddefope = ln_definicion_operacion;

        If ln_num = 0 Then
          begin
            INSERT INTO int_servicio_plataforma
              (codsolot, idtareawf, numslc, iddefope)
            VALUES
              (C1.codsolot,
               a_idtareawf,
               C1.numslc,
               ln_definicion_operacion);
          EXCEPTION
            WHEN OTHERS Then
              ls_mensaje := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma. ' ||
                            SQLERRM;
              raise exception_baja;
          end;
        End If;
      End;
      COMMIT;
      ln_uso := 1;
    End LOOP;

    If ln_uso = 0 Then
      begin
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         4,
                                         8,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      exception
        when others then
          ls_mensaje := 'Error en cambio de estado de tarea.';
          raise exception_baja;
      end;
    ELSIf ln_uso = 1 Then

      BEGIN
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                ls_resultado,
                                ls_mensaje);
        If ls_resultado = 'ERROR' Then
          raise exception_baja;
        End If;
      exception
        when others then
          ls_mensaje := 'Error al enviar a interfaz.';
          raise exception_baja;
      End;

    End If;
  EXCEPTION
    WHEN exception_baja THEN

      select OPEWF.F_GET_ID_TAREAWFSEG() into ln_idseq from dummy_ope;
      insert into tareawfseg
        (idseq, idtareawf, observacion)
      values
        (ln_idseq, a_idtareawf, ls_mensaje);

      if a_tarea is not null then
        SELECT tipesttar
          INTO ls_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ls_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      end if;
      return;
  END P_PRE_BAJA_SERVICIO_BREEZEMAX;

  PROCEDURE P_POS_LIBERA_PROV_TN(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS
    p_ide       number;
    p_codsolot  number;
    p_idtareawf number;
    ln_tipo     number;
    ls_numslc   solot.numslc%type;
    ls_ide      varchar2(30);
    ls_mensaje  varchar2(400);
    exception_lib_prov exception;
  BEGIN
    Begin
      Select i.numslc
        into ls_numslc
        from inssrv i, solotpto p, solot s, wf
       where wf.idwf = a_idwf
         and s.codsolot = wf.codsolot
         and p.codsolot = s.codsolot
         and i.codinssrv = p.codinssrv
       group by i.numslc;
    Exception
      when no_data_found then
        ls_mensaje := 'No se encontró un proyecto asociado a los servicios.';
        raise exception_lib_prov;
      when too_many_rows then
        ls_mensaje := 'Se encontro más de un proyecto asociado a los servicios.';
        raise exception_lib_prov;
    End;

    If ls_numslc is not null Then
      --se valida que exista el IDE
      select trim(F_GET_PLATAFORMA_TXT_INS(ls_numslc, 'IDE'))
        into ls_ide
        from dummy_ope;

      If ls_ide is null then
        ls_mensaje := 'Error en obtención de IDE.';
        raise exception_lib_prov;
      End if;
    Else
      ls_mensaje := 'No se encontró proyecto.';
      raise exception_lib_prov;
    End if;

    p_ide := to_number(ls_ide);

    For c1 in (select ide, cid from cidxide where ide = p_ide) Loop
      Update ipxclasec
         set idrango = null, tipo = null
       where idrango in (select idrango from rangosip where cid = c1.cid);

      delete from rangosip where cid = c1.cid;

      delete from cidxide
       where cid = c1.cid
         and ide = c1.ide;
    End Loop;

    update puertoxequipo
       set estado      = 0,
           descripcion = null,
           puerto      = '01:',
           ide         = null,
           coordenadas = ''
     where ide = p_ide;

    if a_tarea is null then
      ln_tipo := 1; -- DEBE ANULAR RESERVA
    else
      ln_tipo := 2; --CANCELAR COMERCIAL
    end if;

    For c2 in (select i.codinssrv
                 from inssrv i, numtel n, solotpto p, wf
                where wf.idwf = a_idwf
                  and p.codsolot = wf.codsolot
                  and i.codinssrv = p.codinssrv
                  and n.numero = i.numero
                group by i.codinssrv) Loop
      If ln_tipo = 2 then
        p_desasignacionxinssrv(c2.codinssrv, ln_tipo);
      End If;
    End Loop;

    ls_mensaje := 'Proceso de liberación de recursos aprovisionados SGA: Finalizado.';

    insert into tareawfseg
      (idtareawf, observacion, flag)
    values
      (a_idtareawf, ls_mensaje, 1);

  EXCEPTION
    When exception_lib_prov then

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, ls_mensaje, 1);

      commit;
      raise_application_error(-20500,
                              'Error al cierre de Tarea: ' || ls_mensaje);
  END;

  PROCEDURE P_PRE_SUSREC_BREEZEMAX(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ls_numslc               solot.numslc%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    a_cant_bl               number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    Begin
      Select i.numslc
        into ls_numslc
        from inssrv i, solotpto p, solot s, wf
       where wf.idwf = a_idwf
         and s.codsolot = wf.codsolot
         and p.codsolot = s.codsolot
         and i.codinssrv = p.codinssrv
       group by i.numslc;
    Exception
      when no_data_found then
        a_resultado := 'ERROR';
        a_mensaje   := 'No se encontró un proyecto asociado a los servicios.';
        raise exception_interfaz;
      when too_many_rows then
        a_resultado := 'ERROR';
        a_mensaje   := 'Se encontro más de un proyecto asociado a los servicios.';
        raise exception_interfaz;
    End;
    /*   --10.0 Se Modifica lógica de generación de lotes de interfaz
    a_cant_tel := F_GET_CANT_LINEAS(ln_codsolot);
    a_cant_bl  := F_GET_CANT_BANDALARGA(ln_codsolot);

    If a_cant_tel <> 0 and a_cant_bl <> 0 then
       -- Telefonia e Internet
       a_tipo := 0;
    elsif a_cant_tel <> 0 and a_cant_bl = 0 then
       -- Solo Telefonia
       a_tipo := 1;
    elsif a_cant_tel = 0 and a_cant_bl <> 0 then
       -- Solo Internet
       a_tipo := 2;
    else
       a_resultado := 'ERROR';
       a_mensaje   := 'Error al identificar el Tipo de Operación configurado.';
       raise exception_interfaz;
    End if;

    Begin
       Select a.iddefope
         into ln_definicion_operacion
         from int_operacion_tareadef a
        where a.tareadef = a_tareadef
          and a.tipo = a_tipo;
    Exception
       when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'No se configuró correctamente la Operación de Envío a la Plataforma.';
          raise exception_interfaz;
    End;*/

    begin
      Select F_GET_IDDEFOPE_PROY(a_idtareawf, ls_numslc)
        into ln_definicion_operacion
        from dummy_ope;
    exception
      when no_data_found then
        a_mensaje := 'No se encontro operacion configurada';
        raise exception_interfaz;
      when too_many_rows then
        a_mensaje := 'Se encontro mas de una operacion configurada';
        raise exception_interfaz;
    end;

    If ln_definicion_operacion = '-1' then
      a_mensaje := 'No se encontró operación configurada para la tarea ' ||
                   to_char(a_idtareawf);
      raise exception_interfaz;
    End If;

    Select count(*)
      into ln_aux
      from int_servicio_plataforma
     where codsolot = ln_codsolot
       and idtareawf = a_idtareawf
       and iddefope = ln_definicion_operacion;

    If ln_aux = 0 Then
      Begin
        Insert into int_servicio_plataforma
          (codsolot, idtareawf, iddefope, numslc)
        values
          (ln_codsolot, a_idtareawf, ln_definicion_operacion, ls_numslc);
      Exception
        when others then
          rollback;
          a_mensaje   := 'No se proceso correctamente la inserción en la tabla int_servicio_plataforma. ' ||
                         Sqlerrm;
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;
      commit; --*

    End If;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    exception
      when others then
        a_mensaje := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_CHG_SUSREC_BREEZEMAX(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;
  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    exception
      when others then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    If ls_esttarea_old is not null and ls_esttarea_old = cn_esttarea_error and
       a_esttarea = cn_esttarea_new then
      P_PRE_SUSREC_BREEZEMAX(a_idtareawf,
                             a_idwf, /*a_tarea*/
                             null,
                             a_tareadef);
    End if;
  END;

  PROCEDURE P_CHG_SUS_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;
  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    exception
      when others then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    If ls_esttarea_old is not null and ls_esttarea_old = cn_esttarea_error and
       a_esttarea = cn_esttarea_new then
      P_PRE_SUSPENSION_CS2K(a_idtareawf,
                            a_idwf, /*a_tarea*/
                            null,
                            a_tareadef);
    End if;
  END;

  PROCEDURE P_PRE_SUSPENSION_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operación de envío a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la inserción en la tabla int_servicio_plataforma. ' ||
                             Sqlerrm;
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          COMMIT;
        End If;
      End Loop;
      --10.0 Se ordena llamado a la función y cambio de estado de la tarea
      Begin
        P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                a_tipoproc,
                                a_resultado,
                                a_mensaje);
        If a_resultado = 'ERROR' Then
          raise exception_interfaz;
        End If;
      exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Error al enviar a interfaz.';
          raise exception_interfaz;
      End;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if; -- 10.0 fin ordenamiento

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_SUS_LIMCRE_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operación de envío a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la inserción en la tabla int_servicio_plataforma. ' ||
                             Sqlerrm;
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          COMMIT;
        End If;
      End Loop;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_SUS_RETPAG_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operación de envío a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la inserción en la tabla int_servicio_plataforma. ' ||
                             Sqlerrm;
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          COMMIT;
        End If;
      End Loop;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_RECONEXION_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    a_cant_bl               number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operacion de envio a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma.';
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          commit;
        End If;
      End Loop;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_REC_LIMCRE_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    a_cant_bl               number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operacion de envio a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma.';
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          commit;
        End If;
      End Loop;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_REC_RETPAG_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_codsolot             solot.codsolot%type;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    a_tipo                  number;
    a_tipoproc              number;
    a_cant_tel              number;
    a_cant_bl               number;
    ln_aux                  number;
    a_resultado             varchar2(400);
    a_mensaje               varchar2(400);
    exception_interfaz exception;
    cursor cur_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             i.codinssrv,
             i.numslc
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = ln_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and c.idproducto <>
             (select to_number(valor)
                from constante
               where constante = 'TN_PROD_FAX')
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                i.codinssrv,
                i.numslc
       order by r.codnumtel;
  BEGIN
    select codsolot into ln_codsolot from wf where wf.idwf = a_idwf;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    a_cant_tel := F_GET_CANT_LINEAS_2(ln_codsolot); --10.0 Cambio de función

    If a_cant_tel = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_interfaz;
    End If;

    If a_cant_tel > 0 then
      a_tipo := 0; --

      Begin
        Select a.iddefope
          into ln_definicion_operacion
          from int_operacion_tareadef a
         where a.tareadef = a_tareadef
           and a.tipo = a_tipo;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la operacion de envio a las plataformas.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      For c1 in cur_numeros Loop

        Select count(*)
          into ln_aux
          from int_servicio_plataforma
         where idtareawf = a_idtareawf
           and codsolot = ln_codsolot
           and codnumtel = c1.codnumtel
           and iddefope = ln_definicion_operacion;

        If ln_aux = 0 Then
          Begin
            Insert into int_servicio_plataforma
              (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
            values
              (ln_codsolot,
               a_idtareawf,
               ln_definicion_operacion,
               c1.codnumtel,
               c1.codinssrv,
               c1.numslc);
          Exception
            when others then
              a_mensaje   := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma.';
              a_resultado := 'ERROR';
              raise exception_interfaz;
          End;
          commit;
        End If;
      End Loop;

    Else
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    End if;

    Begin
      P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                              a_tipoproc,
                              a_resultado,
                              a_mensaje);
      If a_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al enviar a interfaz.';
        raise exception_interfaz;
    End;

  EXCEPTION
    when exception_interfaz then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_PRE_ACTIVACION_CS2K(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_tot       number;
    ln_tipesttar number;
    a_idficha    number;
    a_resultado  varchar2(400);
    a_mensaje    varchar2(400);
    exception_tarea exception;
  BEGIN
    select F_GET_CANT_LINEAS_2(s.codsolot) --10.0 Cambio de función
      into ln_tot
      from solot s, wf
     where wf.idwf = a_idwf
       and s.codsolot = wf.codsolot;

    If ln_tot = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exception_tarea;
    End If;

    If ln_tot = 0 then
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    Else
      Select F_GET_TAREA_FICHA_TECNICA(wf.codsolot)
        into a_idficha
        from wf
       where idwf = a_idwf;

      Begin
        PQ_FICHATECNICA.P_VALIDAR_INSTDOCUMENTO(a_idficha);
      Exception
        when others then
          a_mensaje := 'Validación de Ficha Técnica: ' || sqlerrm;
          raise exception_tarea;
      End;

      P_GEN_INTERFAZ_CS2K(a_idtareawf, a_resultado, a_mensaje);

      If a_resultado = 'ERROR' then
        raise exception_tarea;
      End If;

      P_ENV_INTERFAZ_TAREA(a_idtareawf, a_resultado, a_mensaje);

      If a_resultado = 'ERROR' then
        a_mensaje := 'Error Envío a la Plataforma: ' || a_mensaje;
        raise exception_tarea;
      End If;
    End If;

    P_SINC_TAREA_WEB(a_idtareawf);

  EXCEPTION
    when exception_tarea then
      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      if a_tarea is not null then
        SELECT tipesttar
          INTO ln_tipesttar
          FROM esttarea
         WHERE esttarea = cn_esttarea_error;

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         ln_tipesttar,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);

        P_SINC_TAREA_WEB(a_idtareawf);
      else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500, a_mensaje);
      end if;

  END;

  PROCEDURE P_GEN_INTERFAZ_BREEZEMAX(a_idtareawf in number,
                                     a_resultado in out varchar2,
                                     a_mensaje   in out varchar2) is
    exception_interfaz exception;
    ln_aux                  number;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    cursor cur_antena is
      select s.codsolot, s.numslc, t.tareadef
        from tareawf t, wf, solot s
       where t.idtareawf = a_idtareawf
         and wf.idwf = t.idwf
         and s.codsolot = wf.codsolot;
  BEGIN
    --10.0 Se rehace el procedimiento
    a_mensaje := 'OK';

    For c1 in cur_antena Loop
      /*         Begin
         select g.susname
           into a_suscriber
           from inssrv           i,
                paquete_venta    paq,
                grupoip_servicio g,
                solotpto         p
          where i.numslc = c1.numslc
            and paq.idpaq = i.idpaq
            and g.idgrupo = paq.idgrupo
            and p.codinssrv = i.codinssrv
            and p.codsolot = c1.codsolot
          group by g.susname;
      Exception
         when others then
            a_mensaje   := 'Error al obtener el Suscriber asociado a Breezemax.';
            a_resultado := 'ERROR';
            raise exception_interfaz;
      End;

      a_cant_tel := F_GET_CANT_LINEAS(c1.codsolot);

      If a_cant_tel = -1 then
         a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
         a_resultado := 'ERROR';
         raise exception_interfaz;
      End If;

      a_cant_bl := F_GET_CANT_BANDALARGA(c1.codsolot);

      If a_suscriber is not null and length(a_suscriber) > 0 Then
         -- Activacion Sin crear Suscriber
         If a_cant_tel <> 0 and a_cant_bl <> 0 then
            -- Activacion Telefonia e Internet
            a_tipo := 1;
         elsif a_cant_tel <> 0 and a_cant_bl = 0 then
            -- Activacion Solo Telefonia
            a_tipo := 2;
         elsif a_cant_tel = 0 and a_cant_bl <> 0 then
            -- Activacion Solo Internet
            a_tipo := 3;
         End if;
      Else
         -- Activacion Con creacion de Suscriber
         If a_cant_tel <> 0 and a_cant_bl <> 0 then
            -- Activacion Suscriber, Telefonia e Internet
            a_tipo := 0;
         elsif a_cant_tel <> 0 and a_cant_bl = 0 then
            -- Activacion Suscriber y Telefonia
            a_tipo := 4;
         elsif a_cant_tel = 0 and a_cant_bl <> 0 then
            -- Activacion Suscriber e Internet
            a_tipo := 5;
         End if;
      End If;*/

      Begin
        /*Select a.iddefope
         into ln_definicion_operacion
         from int_operacion_tareadef a
        where a.tareadef = c1.tareadef
          and a.tipo = a_tipo
          and a.esttarea_ini = 2;*/
        Select F_GET_IDDEFOPE(a_idtareawf)
          into ln_definicion_operacion
          from dummy_ope;
      Exception
        when others then
          a_mensaje   := 'No se configuró correctamente la Operación de Envío a la Plataforma.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;

      If ln_definicion_operacion < 1 then
        a_mensaje   := 'No se configuró correctamente la Operación de Envío a la Plataforma.';
        a_resultado := 'ERROR';
        raise exception_interfaz;
      End If;

      Select count(*)
        into ln_aux
        from int_servicio_plataforma
       where codsolot = c1.codsolot
         and idtareawf = a_idtareawf
         and iddefope = ln_definicion_operacion
         and estado <> 4;

      If ln_aux = 0 Then
        -- v.11.0 09/04/2010 Actualizar otras operaciones de la misma tarea solo caso Breezemax
        update int_servicio_plataforma
           set estado = 4
         where idtareawf = a_idtareawf
           and iddefope <> ln_definicion_operacion;
        -- fin 09/04/2010
        Begin
          Insert into int_servicio_plataforma
            (codsolot, idtareawf, iddefope, numslc)
          values
            (c1.codsolot, a_idtareawf, ln_definicion_operacion, c1.numslc);
        Exception
          when others then
            a_mensaje   := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma.';
            a_resultado := 'ERROR';
            raise exception_interfaz;
        End;
        commit; --*
      End If;

    End Loop;

  EXCEPTION
    WHEN exception_interfaz THEN
      return;
  END;

  PROCEDURE P_GEN_INTERFAZ_CS2K(a_idtareawf in number,
                                a_resultado in out varchar2,
                                a_mensaje   in out varchar2) IS
    p_tipo     number;
    ln_aux     number;
    a_numslc   vtatabslcfac.numslc%type;
    a_codsolot solot.codsolot%type;
    a_tareadef tareadef.tareadef%type;
    exception_interfaz exception;
    ln_definicion_operacion int_servicio_plataforma.iddefope%type;
    cursor cur_codinssrv is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             r.orden,
             n.codinssrv
        from reservatel r,
             numtel     n,
             inssrv     i,
             solotpto   p,
             insprd     ip,
             tystabsrv  t,
             producto   c
       where r.codnumtel = n.codnumtel
         and p.codsolot = a_codsolot
         and i.codinssrv = p.codinssrv
         and i.numero = n.numero
         and i.numslc = r.numslc
         and r.valido = 1
         and n.tipnumtel = 1
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and i.cid is not null --10.0 Validación de Lineas Telefónicas
       group by r.idseq,
                r.codnumtel,
                r.numpto,
                n.numero,
                r.publicar,
                r.orden,
                n.codinssrv
       order by r.codnumtel;

  BEGIN
    select s.codsolot, s.numslc, t.tareadef
      into a_codsolot, a_numslc, a_tareadef
      from tareawf t, wf, solot s
     where t.idtareawf = a_idtareawf
       and wf.idwf = t.idwf
       and s.codsolot = wf.codsolot;

    p_tipo := 0;

    Begin
      Select a.iddefope
        into ln_definicion_operacion
        from int_operacion_tareadef a
       where a.tareadef = a_tareadef
         and a.tipo = p_tipo;
    Exception
      when others then
        a_mensaje   := 'No se configuró correctamente la operacion de envio a las plataformas.';
        a_resultado := 'ERROR';
        raise exception_interfaz;
    End;

    Select count(*)
      into ln_aux
      from int_servicio_plataforma
     where codsolot = a_codsolot
       and idtareawf = a_idtareawf
       and iddefope = ln_definicion_operacion
       and codnumtel is null
       and codinssrv is null;

    If ln_aux = 0 Then
      Begin
        Insert into int_servicio_plataforma
          (codsolot, idtareawf, iddefope, numslc)
        values
          (a_codsolot, a_idtareawf, ln_definicion_operacion, a_numslc);
      Exception
        when others then
          a_mensaje   := 'No se proceso correctamente la inserción en la tabla int_servicio_plataforma.';
          a_resultado := 'ERROR';
          raise exception_interfaz;
      End;
    End If;

    p_tipo := 1;

    Begin
      Select a.iddefope
        into ln_definicion_operacion
        from int_operacion_tareadef a
       where a.tareadef = a_tareadef
         and a.tipo = p_tipo;
    Exception
      when others then
        a_mensaje   := 'No se configuró correctamente la operacion de envio a las plataformas.';
        a_resultado := 'ERROR';
        raise exception_interfaz;
    End;

    For c1 in cur_codinssrv Loop
      Select count(*)
        into ln_aux
        from int_servicio_plataforma
       where idtareawf = a_idtareawf
         and codsolot = a_codsolot
         and codnumtel = c1.codnumtel
         and iddefope = ln_definicion_operacion;

      If ln_aux = 0 Then
        Begin
          Insert into int_servicio_plataforma
            (codsolot, idtareawf, iddefope, codnumtel, codinssrv, numslc)
          values
            (a_codsolot,
             a_idtareawf,
             ln_definicion_operacion,
             c1.codnumtel,
             c1.codinssrv,
             a_numslc);
        Exception
          when others then
            a_mensaje   := 'No se proceso correctamente la insercion en la tabla int_servicio_plataforma.';
            a_resultado := 'ERROR';
            raise exception_interfaz;
        End;
        commit;
      End If;

    End Loop;
  EXCEPTION
    when exception_interfaz then
      return;
  END;

  PROCEDURE P_ENV_INTERFAZ_TAREA(a_idtareawf IN NUMBER,
                                 a_resultado IN OUT VARCHAR2,
                                 a_mensaje   IN OUT VARCHAR2) IS
    ls_tipo_parametro varchar2(4000);
    ls_resultado      varchar2(4000);
    ls_mensaje        varchar2(4000);
    ls_resultado_ok   varchar2(4000);
    ln_error          number(1);
    ln_num            number;
    ls_esttarea       esttarea.esttarea%TYPE; -- 10.0 Revisión de variables
    exception_interfaz exception;
    cursor cur_servicio is
      select a.idseq,
             to_char(a.idseq) valor_parametro,
             to_char(a.iddefope) definicion_operacion
        from int_servicio_plataforma a
       where a.idtareawf = a_idtareawf
         and (a.estado = 0 or a.estado = 3)
         and a.idlote is null;
  BEGIN

    ls_resultado_ok := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_EXITO;

    select to_char(codigon)
      into ls_tipo_parametro
      from int_definicion_parametro
     where UPPER(codigoc) = UPPER('IDSEQ');

    Begin
      SELECT to_char(codigon)
        into ls_tipo_parametro
        FROM int_definicion_parametro
       WHERE UPPER(codigoc) = UPPER('IDSEQ');
    Exception
      when no_data_found then
        a_mensaje := 'No se encontro definicion_parametro "IDSEQ".';
        raise exception_interfaz;
      when too_many_rows then
        a_mensaje := 'Se encontro más de un definicion_parametro "IDSEQ".';
        raise exception_interfaz;
    end;

    For c1 IN cur_servicio Loop
      ln_error := 0;

      Begin
        pq_int_comando_plataforma.p_generar_lote_comando(c1.definicion_operacion,
                                                         ls_tipo_parametro,
                                                         c1.valor_parametro,
                                                         ls_resultado,
                                                         ls_mensaje);
      Exception
        when others then
          ln_error   := 1;
          ls_mensaje := nvl(ls_mensaje, ' ') || sqlerrm;
      End;

      If ln_error = 1 OR (TRIM(ls_resultado_ok) <> TRIM(ls_resultado)) Then
        ls_mensaje := 'Error: No se pudo generar solicitud a la plataforma.' ||
                      ls_mensaje;

        update int_servicio_plataforma
           set estado = 3 -- Error
         where idseq = C1.idseq;

        insert into TAREAWFSEG
          (IDTAREAWF, OBSERVACION, FLAG)
        values
          (a_idtareawf, ls_mensaje || ' IDSEQ: ' || C1.valor_parametro, 1);

      Else
        update int_servicio_plataforma
           set idlote = to_number(ls_mensaje), estado = 1 -- Generado
         where idseq = C1.idseq;

        ls_mensaje := 'Se generó la solicitud con IDLOTE: ' || ls_mensaje;

        insert into tareawfseg
          (idtareawf, observacion, flag)
        values
          (a_idtareawf, ls_mensaje, 1);
      End If;
      commit;
    End Loop;

    select count(*)
      into ln_num
      from int_servicio_plataforma
     where idtareawf = a_idtareawf
       and estado = 1 -- v.11.0 Control en generacion de lotes de Breezemax
       and idlote is null;

    If ln_num > 0 Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error Plataforma: (' || to_char(ln_num) ||
                     ') solictudes no fueron generadas.';
      raise exception_interfaz;
    End If;

  EXCEPTION
    when exception_interfaz then
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Error en el envío a la plataforma.' || sqlerrm;
      return;
  END;

  PROCEDURE P_CHG_REC_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;
  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    exception
      when others then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    If ls_esttarea_old is not null and ls_esttarea_old = cn_esttarea_error and
       a_esttarea = cn_esttarea_new then
      P_PRE_RECONEXION_CS2K(a_idtareawf,
                            a_idwf, /*a_tarea*/
                            null,
                            a_tareadef);
    End if;
  END;

  PROCEDURE P_CHG_ATV_CS2K(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_tipesttar in number,
                           a_esttarea  in number,
                           a_mottarchg in number,
                           a_fecini    in date,
                           a_fecfin    in date) IS
    ls_esttarea_old tareawf.esttarea%type;
    ln_reenvio      number;
    p_resultado     varchar2(400);
    p_mensaje       varchar2(400);
    exception_prov exception;
  BEGIN
    --10.0 Se rehace procedimiento
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    exception
      when others then
        ls_esttarea_old := null;
    End;

    select count(*)
      into ln_reenvio
      from int_servicio_plataforma a
     where a.idtareawf = a_idtareawf
       and a.estado = 3
       and a.idlote is not null;

    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    If ls_esttarea_old is not null and ls_esttarea_old = cn_esttarea_error and
       a_esttarea = cn_esttarea_new then
      P_PRE_ACTIVACION_CS2K(a_idtareawf,
                            a_idwf, /*a_tarea*/
                            null,
                            a_tareadef);

    Elsif ls_esttarea_old = 1 and ln_reenvio > 0 then
      P_PRE_ACTIVACION_CS2K(a_idtareawf,
                            a_idwf, /*a_tarea*/
                            null,
                            a_tareadef);
    Elsif a_tipesttar = 4 Then
      P_ACT_DOC_PROV(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;
    End If;
  Exception
    when exception_prov then
      rollback;
      p_mensaje := F_UTIL_LIMPIAR_MSG(p_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, p_mensaje, 1);
      commit;
      raise_application_error(-20500, p_mensaje);
  END;

  PROCEDURE P_CHG_PROVIS_TN(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number,
                            a_tipesttar in number,
                            a_esttarea  in number,
                            a_mottarchg in number,
                            a_fecini    in date,
                            a_fecfin    in date) IS
    ln_esttarea_old tareawf.idtareawf%type;
    a_idficha       ft_instdocumento.idficha%type;
    a_codsolot      solot.codsolot%type;
    p_resultado     varchar2(400);
    p_mensaje       varchar2(400);
    exception_prov exception;
    exception_flujo exception;
  BEGIN
    --10.0 Se rehace procedimiento
    select esttarea
      into ln_esttarea_old
      from tareawf
     where idtareawf = a_idtareawf;

    select codsolot into a_codsolot from wf where idwf = a_idwf;

    If ln_esttarea_old = 1 and a_esttarea = 16 and a_tipesttar = 2 Then
      -- Asignar Recursos y generar Registros para la Plataforma
      Begin
        Select idficha
          into a_idficha
          from ft_instdocumento
         where codigo1 = F_GET_TAREA_FICHA_TECNICA(a_codsolot)
           and codigo2 = a_codsolot
         group by idficha;
      Exception
        when others then
          p_mensaje := 'Error al obtener ID de la Ficha Técnica. ' ||
                       sqlerrm;
          raise exception_prov;
      End;

      If a_idficha is null then
        p_mensaje := 'Error al obtener el Id de la Ficha Técnica.';
        raise exception_prov;
      End If;

      Begin
        PQ_FICHATECNICA.P_VALIDAR_INSTDOCUMENTO_REGLA(a_idficha,
                                                      ln_esttarea_old);
      Exception
        when others then
          p_mensaje := 'Validación de Ficha Técnica: ' || sqlerrm;
          raise exception_prov;
      End;

      P_RSRV_NUMTEL_TN(a_idtareawf,
                       a_idwf,
                       a_tarea,
                       a_tareadef,
                       p_resultado,
                       p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ASIG_PORT_TN(a_idtareawf,
                     a_idwf,
                     a_tarea,
                     a_tareadef,
                     p_resultado,
                     p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ASIG_IP_TN(a_idtareawf,
                   a_idwf,
                   a_tarea,
                   a_tareadef,
                   p_resultado,
                   p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ACT_FICHA_TN(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ACT_FQDN(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      Begin
        PQ_FICHATECNICA.P_VALIDAR_INSTDOCUMENTO_REGLA(a_idficha,
                                                      a_esttarea);
      Exception
        when others then
          p_mensaje := 'Validación de Ficha Técnica: ' || sqlerrm;
          raise exception_prov;
      End;

      -- Configuracion de Plataforma BreezeMax
      P_GEN_INTERFAZ_BREEZEMAX(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        raise exception_prov;
      Else
        p_mensaje := 'Aprovisionamiento Automático de recursos completado en el SGA. Información lista para envío a las Plataformas.';

        insert into tareawfseg
          (idtareawf, observacion, flag)
        values
          (a_idtareawf, p_mensaje, 1);

      End If;

    Elsif (ln_esttarea_old = 16 or ln_esttarea_old = 15) and a_esttarea = 2 and
          a_tipesttar = 2 Then

      P_ENV_INTERFAZ_TAREA(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        p_mensaje := 'Error Envío a Plataforma: ' || nvl(p_mensaje, '') ||
                     sqlerrm;
        raise exception_prov;
      End If;

    Elsif ln_esttarea_old = 17 and a_esttarea = 18 and a_tipesttar = 2 Then
      P_ANULA_PLATAFORMA(a_idtareawf, a_esttarea, p_resultado, p_mensaje);
      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ENV_INTERFAZ_TAREA(a_idtareawf, p_resultado, p_mensaje);

      If p_resultado = 'ERROR' Then
        p_mensaje := 'Error Envío a Plataforma: ' || nvl(p_mensaje, '') ||
                     sqlerrm;
        raise exception_prov;
      End If;

    Elsif ln_esttarea_old = 18 and a_esttarea = 1 and a_tipesttar = 1 Then
      Begin
        P_POS_LIBERA_PROV_TN(a_idtareawf,
                             a_idwf,
                             null /*a_tarea*/,
                             a_tareadef);
      Exception
        when others then
          p_mensaje := 'Error en la Liberación de recursos: ' || sqlerrm;
          raise exception_prov;
      End;

      P_ANULA_PLATAFORMA(a_idtareawf,
                         null /*a_esttarea*/,
                         p_resultado,
                         p_mensaje);
      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

      P_ANULA_FICHA(a_idtareawf, p_resultado, p_mensaje);
      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

    Elsif ln_esttarea_old = 16 and a_esttarea = 1 and a_tipesttar = 1 Then
      Begin
        P_POS_LIBERA_PROV_TN(a_idtareawf,
                             a_idwf,
                             null /*a_tarea*/,
                             a_tareadef);
      Exception
        when others then
          p_mensaje := 'Error en la Liberación de recursos: ' || sqlerrm;
          raise exception_prov;
      End;

      P_ANULA_FICHA(a_idtareawf, p_resultado, p_mensaje);
      If p_resultado = 'ERROR' Then
        raise exception_prov;
      End If;

    Elsif ln_esttarea_old = 2 and a_esttarea = 17 and a_tipesttar = 2 Then
      null;
    Elsif (ln_esttarea_old = 17 or ln_esttarea_old = 1) and a_esttarea = 4 and
          a_tipesttar = 4 Then
      null;
    Elsif ln_esttarea_old = cn_esttarea_error and a_esttarea = 1 and
          a_tipesttar = 1 Then
      null; --P_SINC_TAREA_WEB(a_idtareawf);
    Elsif ln_esttarea_old = 1 and a_esttarea = cn_esttarea_error and
          a_tipesttar = 2 Then
      null; --P_SINC_TAREA_WEB(a_idtareawf);
    Else
      raise exception_flujo;
    End If;

    Select 'Cambio estado de: ''' || descripcion || ''' - a: '
      into p_mensaje
      from esttarea
     where esttarea = ln_esttarea_old;

    Select p_mensaje || '''' || descripcion || ''''
      into p_mensaje
      from esttarea
     where esttarea = a_esttarea;

    insert into tareawfseg
      (idtareawf, observacion, flag)
    values
      (a_idtareawf, p_mensaje, 1);
    commit;

    P_SINC_TAREA_WEB(a_idtareawf);
  Exception
    -- v.11.0
    when exception_prov then
      rollback;
      p_mensaje := F_UTIL_LIMPIAR_MSG(p_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, p_mensaje, 1);
      commit;
      raise_application_error(-20500, p_mensaje); -- v.11.0 Mejora en mensaje

    when exception_flujo then
      -- v.11.0 Mejora en manejo de la excepción
      p_mensaje := 'Cambio de Estado no permitido. De: ' ||
                   to_char(ln_esttarea_old) || ' A: ' ||
                   to_char(a_esttarea);
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, p_mensaje, p_mensaje);
      commit;
      raise_application_error(-20500, p_mensaje);
      -- v.11.0
    when others then
      rollback;
      p_mensaje := 'Error durante cambio de estado: ' || sqlerrm;
      p_mensaje := F_UTIL_LIMPIAR_MSG(p_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, p_mensaje, 1);
      commit;
      raise_application_error(-20500, p_mensaje); -- v.11.0 Mejora en mensaje
  END;

  PROCEDURE P_CHG_VAL_CONTRATA(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date) IS
    ln_codsolot solot.codsolot%type;
    ln_codcon   solotpto_id.codcon%type;
    ls_tipsrv   solot.tipsrv%type;
  BEGIN
    BEGIN
      SELECT solot.codsolot, solot.tipsrv
        INTO ln_codsolot, ls_tipsrv
        FROM wf, tareawf, solot
       WHERE wf.idwf = tareawf.idwf
         AND tareawf.idtareawf = a_idtareawf
         AND solot.codsolot = wf.codsolot;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'El WF no tiene asociado una SOLOT.');
    END;

    IF (ls_tipsrv = '0058' or ls_tipsrv = '0059') and a_tipesttar = 4 AND
       a_esttarea = 4 THEN
      BEGIN
        SELECT nvl(codcon, 0)
          INTO ln_codcon
          FROM solotpto_id
         WHERE codsolot = ln_codsolot
         GROUP BY codcon;
      EXCEPTION
        WHEN OTHERS THEN
          ln_codcon := 0; --10.0 Corrección de variable
      END;
      IF ln_codcon = 0 THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'No es posible realizar este cambio de estado. No se ha asignado el contratista.');
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'Error en la Validación de Contratista.');
  END;

  PROCEDURE P_PRE_GEN_FICHA(a_idtareawf IN NUMBER,
                            a_idwf      IN NUMBER,
                            a_tarea     IN NUMBER,
                            a_tareadef  IN NUMBER) IS
    ln_codsolot  solot.codsolot%type;
    ls_tipsrv    solot.tipsrv%type;
    a_cant_tel   number;
    a_cant_bl    number;
    ls_mensaje   varchar2(400);
    ls_resultado varchar2(400);
    exception_interfaz exception;
  BEGIN
    --10.0 Se rehace procedimiento
    -- Capturo el codigo de la solot
    select s.codsolot, s.tipsrv
      into ln_codsolot, ls_tipsrv
      from wf, solot s
     where wf.idwf = a_idwf
       and s.codsolot = wf.codsolot;

    a_cant_tel := F_GET_CANT_LINEAS(ln_codsolot);
    a_cant_bl  := F_GET_CANT_BANDALARGA(ln_codsolot);

    If ls_tipsrv not in ('0058', '0059') or
       (a_cant_tel = 0 and a_cant_bl = 0) Then
      -- Aplica para Instalacion de Paquetes
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

    Else
      Begin
        PQ_FICHATECNICA.P_CREAR_INSTDOCUMENTO('TAREAWF',
                                              a_idtareawf,
                                              ln_codsolot);
      Exception
        when others then
          ls_mensaje := 'Error en la generacion de la Ficha Técnica. Tarea:' ||
                        a_idtareawf || ' - Codsolot: ' || ln_codsolot;
          raise exception_interfaz;
      End;

      P_ACT_DOC_PROV2(a_idtareawf, ls_resultado, ls_mensaje);

      If ls_resultado = 'ERROR' Then
        raise exception_interfaz;
      End If;

    End If;

    P_SINC_TAREA_WEB(a_idtareawf);

  EXCEPTION
    when exception_interfaz then
      ls_mensaje := F_UTIL_LIMPIAR_MSG(ls_mensaje, 'ORA-[0-9]*: ');
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, ls_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
        P_SINC_TAREA_WEB(a_idtareawf);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo re-generar solicitud a la Ficha Técnica.');
      End if;

  END;

  PROCEDURE P_ANULA_FICHA(a_idtareawf in number,
                          a_resultado in out varchar2,
                          a_mensaje   in out varchar2) is
    exception_anular exception;
    cursor cur_ficha is
      select * from ft_instdocumento where codigo1 = a_idtareawf;
  BEGIN
    --10.0 Se rehace procedimiento
    For c1 in cur_ficha loop
      Begin
        update ft_instdocumento ft
           set ft.valornum = null,
               ft.valortxt = null,
               ft.valorfec = null,
               ft.idint    = null,
               ft.idintp   = null
         where codigo1 = a_idtareawf
           and idficha = c1.idficha
           and orden = c1.orden
           and idcomponente <> 1;
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Error al actualizar parámetro de la ficha técnica ' ||
                         trim(c1.etiqueta);
          raise exception_anular;
      End;
    End Loop;
  EXCEPTION
    when exception_anular Then
      return;
  END;

  PROCEDURE P_ANULA_PLATAFORMA(a_idtareawf in number,
                               a_esttarea  in number,
                               a_resultado in out varchar2,
                               a_mensaje   in out varchar2) is
    ln_cont  number;
    ln_cont2 number;
    exception_anular exception;
  BEGIN
    ln_cont  := 0;
    ln_cont2 := 0;

    If a_esttarea is null then
      Begin
        update int_servicio_plataforma
           set estado = 4 -- Anulado
         where idtareawf = a_idtareawf
           and estado = 2;
      Exception
        when others then
          a_mensaje := 'Error al actualizar estado de registros antiguos.';
          raise exception_anular;
      End;
      return;
    End if;

    select count(*)
      into ln_cont
      from int_servicio_plataforma i
     where i.idtareawf = a_idtareawf
       and i.idlote is not null
       and i.estado = 2; -- OK

    If ln_cont = 0 then
      a_mensaje := 'No es necesario generar registros de anulación en la plataforma. Idtarea: ' ||
                   to_char(a_idtareawf);

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      return;
    End if;

    For c1 in (select o2.iddefope,
                      i.idseq,
                      i.codsolot,
                      i.idtareawf,
                      i.codinssrv,
                      i.pid,
                      i.codnumtel,
                      i.imsi,
                      i.esn,
                      i.numslc
                 from int_servicio_plataforma i,
                      tareawf                 t,
                      int_operacion_tareadef  o1,
                      int_operacion_tareadef  o2
                where t.idtareawf = a_idtareawf --4299181
                  and i.estado = 2 -- OK
                  and i.idtareawf = t.idtareawf
                  and o1.iddefope = i.iddefope
                  and o1.tareadef = t.tareadef
                  and o2.tipo = o1.tipo
                  and o2.esttarea_ini = a_esttarea --18
                  and o2.iddefope_anula is null
                  and o2.tareadef = t.tareadef
                  and o2.iddefope = o1.iddefope_anula) Loop
      --10.0 Corrección de operacion de anulación

      Begin
        update int_servicio_plataforma
           set estado = 4 -- Anulado
         where idtareawf = a_idtareawf
           and idseq = c1.idseq;
      Exception
        when others then
          a_mensaje := 'Error al actualizar estado de registros antiguos.';
          raise exception_anular;
      End;

      Begin
        insert into int_servicio_plataforma
          (codsolot,
           idtareawf,
           codinssrv,
           pid,
           codnumtel,
           iddefope,
           imsi,
           esn,
           numslc)
        values
          (c1.codsolot,
           c1.idtareawf,
           c1.codinssrv,
           c1.pid,
           c1.codnumtel,
           c1.iddefope,
           c1.imsi,
           c1.esn,
           c1.numslc);
      Exception
        when others then
          a_mensaje := 'Error al ingresar registros para anulación en la Plataforma.';
          raise exception_anular;
      End;

      commit; --10.0 Confirmar el registro de lotes

      ln_cont2 := ln_cont2 + 1;

    End loop;

    If ln_cont <> ln_cont2 then
      a_mensaje := 'No se están configurados correctamente las operaciones de anulación para la tarea.';
      raise exception_anular;
    End if;

    a_mensaje := 'Generación de registros para la anulación en Plataforma: Finalizado.';

    insert into tareawfseg
      (idtareawf, observacion, flag)
    values
      (a_idtareawf, a_mensaje, 1);

  EXCEPTION
    when exception_anular Then
      a_resultado := 'ERROR';
      return;
  END;

  PROCEDURE P_RSRV_NUMTEL_TN(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number,
                             a_resultado in out varchar2,
                             a_mensaje   in out varchar2) IS
    --10.0 Se rehace procedimiento
    ln_codnumtel   numtel.codnumtel%type;
    ln_orden       number;
    ln_cantvta     number;
    ln_cantrsv     number;
    ln_val_rsvtl   number;
    ln_codzonadif  zonatel.codzona%type;
    ln_idcustgroup zonatel_auto.idcustgroup%type;
    ls_tipsrv      solot.tipsrv%type;
    a_numslc       solot.numslc%type;
    a_codsolot     solot.codsolot%type;
    a_codubi       vtasuccli.ubisuc%type;
    ls_numeroini   numtel.numero%type;
    ln_codzona     number;
    a_cant         number;
    i              number;
    j              number;
    exceptioninventario exception;
    a_msj   varchar2(200);
    a_error varchar2(200);
    cursor c_zonasprinc is
      select za.codzona, (count(i.codinssrv) - count(i.numero)) cantxrsv
        from inssrv i,
             insprd pr,
             (select codinssrv
                from solotpto
               where codsolot = a_codsolot
               group by codinssrv) p,
             tystabsrv t,
             producto c,
             zonatelxserv_auto z,
             zonatel_auto za
       where i.codinssrv = p.codinssrv
         and pr.codinssrv = i.codinssrv
         and t.codsrv = pr.codsrv
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and pr.flgprinc = 1
         and z.codsrv = pr.codsrv
         and za.codzona = z.codzona
       group by za.codzona;
    cursor c_reservar is
      select pr.codinssrv,
             i.numero,
             i.numpto,
             t.codsrv,
             za.idcustgroup,
             za.codzona,
             (select count(1) from insprd w where w.codinssrv = pr.codinssrv)
        from inssrv i,
             insprd pr,
             (select codinssrv
                from solotpto
               where codsolot = a_codsolot
               group by codinssrv) p,
             tystabsrv t,
             producto c,
             zonatelxserv_auto z,
             zonatel_auto za
       where i.codinssrv = p.codinssrv
         and pr.codinssrv = i.codinssrv
         and t.codsrv = pr.codsrv
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and pr.flgprinc = 1
         and z.codsrv = pr.codsrv
         and za.codzona = ln_codzona
         and za.codzona = z.codzona
       group by pr.codinssrv,
                i.numero,
                i.numpto,
                t.codsrv,
                za.idcustgroup,
                za.codzona
       order by 7 desc;
  BEGIN
    -- Capturo el codigo de la solot
    select s.numslc, s.codsolot, s.tipsrv
      into a_numslc, a_codsolot, ls_tipsrv
      from wf, solot s
     where wf.codsolot = s.codsolot
       and wf.idwf = a_idwf;

    /*Valida Reservados sin Asignar mostrar mensaje de error
    select count(*)
    from reservatel r, numtel n
    where r.numslc = '0000463860'
    and n.codnumtel = r.codnumtel
    and n.codinssrv is null   */

    --Cantidad de Reservados
    select count(1)
      into ln_cantrsv
      from reservatel r, numtel n
     where r.numslc = a_numslc
       and r.codnumtel = n.codnumtel
       and r.estnumtel in (3, 5);

    Begin
      select s.ubisuc
        into a_codubi
        from inssrv i, vtasuccli s
       where i.numslc = a_numslc
         and s.codsuc = i.codsuc
       group by s.ubisuc;
    Exception
      when others then
        a_mensaje   := 'Error al obtener la ubicación de los servicios proyecto x sucursal.';
        a_resultado := 'ERROR';
        raise exceptioninventario;
    End;

    select F_GET_CANT_LINEAS(a_codsolot) into ln_cantvta from dummy_ope;

    If ln_cantvta = -1 then
      a_mensaje   := 'Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exceptioninventario;
    End If;

    ls_numeroini := null;
    select F_GET_CODZONA(a_codsolot) into ln_codzonadif from dummy_ope;
    -- Reservados vs. Total Venta
    If ln_cantvta <> ln_cantrsv Then

      For c1 in c_zonasprinc Loop
        ln_codzona := c1.codzona;
        a_cant     := c1.cantxrsv;

        Select a.idcustgroup
          into ln_idcustgroup
          from zonatel_auto a
         where codzona = ln_codzona;

        If ln_idcustgroup > 0 and ln_codzonadif > 0 then
          --ln_codzona := ln_codzonadif;
          select F_GET_SERIETEL(ln_codzonadif, a_cant, a_codubi)
            into ls_numeroini
            from dummy_ope;
        Else
          select F_GET_SERIETEL(ln_codzona, a_cant, a_codubi)
            into ls_numeroini
            from dummy_ope;
        End if;

        If a_cant > 0 and (ls_numeroini = '0' or ls_numeroini is null) Then
          a_resultado := 'ERROR';
          a_mensaje   := 'No se ha obtenido números disponibles en la zona telefónica.' ||
                         ln_codzona;
          raise exceptioninventario;
        End If;

        i := 0;
        j := 0;
        For c2 in c_reservar Loop
          ln_codnumtel := null;

          IF c2.numero is not null THEN

            Begin
              Select codnumtel
                into ln_codnumtel
                from numtel
               where numero = c2.numero
                 and codinssrv = c2.codinssrv
                 and estnumtel = 2;

              If ln_idcustgroup > 0 then
                ln_orden := j + 1;
                j        := ln_orden;
              End if;
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Error al comprobar número telefónico asignado: ' ||
                               c2.numero || ' en el servicio: ' ||
                               c2.codinssrv;
                raise exceptioninventario;
            End;
            Begin
              Select count(*)
                into ln_val_rsvtl
                from reservatel
               where numslc = a_numslc
                 and numpto = c2.numpto
                 and codnumtel = ln_codnumtel
                 and estnumtel in (3, 5);

              If ln_val_rsvtl = 0 Then
                insert into reservatel
                  (codnumtel,
                   numslc,
                   numpto,
                   valido,
                   estnumtel,
                   publicar,
                   orden)
                values
                  (ln_codnumtel, a_numslc, c2.numpto, 1, 5, 0, ln_orden);
              End If;
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Error al comprobar número telefónico asignado: ' ||
                               c2.numero || ' en el servicio: ' ||
                               c2.codinssrv;
                raise exceptioninventario;
            End;
          ELSE
            Begin
              select codnumtel
                into ln_codnumtel
                from numtel
               where numero = (to_number(ls_numeroini) + i)
                 and numero < (to_number(ls_numeroini) + a_cant)
                 and estnumtel = 1;
            Exception
              when others then
                ln_codnumtel := 0;
            End;

            If ln_codnumtel > 0 Then
              i := i + 1;

              If ln_idcustgroup > 0 then
                ln_orden := j + 1;
                j        := ln_orden;
              End if;

              update numtel
                 set estnumtel = 5
               where codnumtel = ln_codnumtel;

              insert into reservatel
                (codnumtel,
                 numslc,
                 numpto,
                 valido,
                 estnumtel,
                 publicar,
                 orden)
              values
                (ln_codnumtel, a_numslc, c2.numpto, 1, 5, 0, ln_orden);
            Else
              a_resultado := 'ERROR';
              a_mensaje   := 'Uno de los números telefónicos disponibles ha cambiado de estado.';
              raise exceptioninventario;
            End If;
          END IF;
        End Loop;
      End Loop;

      P_ASIG_NUMERO_TN(a_numslc, a_msj, a_error);

      If a_error = 'OK' Then
        a_resultado := a_error;
        a_mensaje   := a_msj;
      Else
        a_resultado := 'ERROR';
        a_mensaje   := 'Error en la Asignación de numeros a las instancias de Servicios. ' ||
                       a_msj;
        raise exceptioninventario;
      End If;

    End If;

  Exception
    when exceptioninventario then
      return;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Reserva Telefónica: ' || sqlerrm;
      return;
  END;

  FUNCTION F_GET_SERIETEL(a_codzona number, a_cant number, a_codubi char)
    RETURN VARCHAR2 IS
    --10.0 se rehace procedimiento
    p_serieini    numtel.numero%type;
    p_seriefin    numtel.numero%type;
    p_numini      numtel.numero%type;
    p_numfin      numtel.numero%type;
    ls_retorno    numtel.numero%type;
    ln_encontrado number;
    ln_cant_disp  number;
    cursor cur_seriexzonaubi is
      select s.codserie, s.numini, s.numfin
        from serietel s
       where s.codzona = a_codzona
         and s.codubi = a_codubi
         and s.estado = 1
       order by s.numini;

    cursor cur_numtel_disp is
      select n.codnumtel, n.numero
        from numtel n
       where n.estnumtel = 1
         and n.numero between p_serieini and p_seriefin
       order by n.numero;

  BEGIN
    ln_encontrado := 0;

    For c_serie in cur_seriexzonaubi loop
      p_serieini := c_serie.numini;
      p_seriefin := c_serie.numfin;

      If ln_encontrado = 0 then
        For c_disp in cur_numtel_disp loop
          p_numini := c_disp.numero;
          p_numfin := p_numini + a_cant - 1;

          select count(*)
            into ln_cant_disp
            from numtel
           where estnumtel = 1
             and (numero between p_numini and p_numfin)
             and (numero between p_serieini and p_seriefin);

          If ln_cant_disp = a_cant Then
            ln_encontrado := 1;
            ls_retorno    := trim(p_numini);
            exit;
          End if;
        End Loop;
      Else
        exit;
      End If;
    End loop;

    If ln_encontrado = 0 Then
      ls_retorno := '0';
    End If;

    return ls_retorno;
  Exception
    when others then
      return '0';
  END;
  FUNCTION F_GET_NUMTEL_ZONA(a_codzona in number,
                             a_codubi  in char,
                             a_tipo    in number) RETURN varchar2 IS
    --10.0 se rehace procedimiento
    ln_contnumtel numtel.codnumtel%type;
    ls_retorno    numtel.numero%type;
    ln_numini     number;
    ln_numfin     number;
    cursor c1 is
      select numini, numfin
        from serietel
       where codzona = a_codzona
         and codubi = a_codubi;
  BEGIN
    ls_retorno := '0';
    for c1det in c1 loop
      ln_numini := to_number(trim(c1det.numini));
      ln_numfin := to_number(trim(c1det.numfin));
      /*for ln_i in ln_numini .. ln_numfin loop
        ls_numero := trim(to_char(ln_i));
        select count(*)
          into ln_contnumtel
          from numtel
         where trim(numero) = ls_numero
           and tipnumtel = a_tipo
           and estnumtel = 1;
        If ln_contnumtel > 0 Then
          ls_retorno := ls_numero;
          ln_salida  := 1;
          exit;
        End If;
      End loop;
      If ln_salida = 1 Then
        exit;
      End If;*/
      select min(numero)
        into ln_contnumtel
        from numtel
       where estnumtel = 1
         and numero between ln_numini and ln_numfin
         and tipnumtel <> 2;

      ls_retorno := to_char(ln_contnumtel);

      If ls_retorno is not null Then
        exit;
      End If;
    End loop;

    return ls_retorno;
  Exception
    when others then
      return '0';
  END;

  PROCEDURE P_ASIG_NUMERO_TN(a_numslc  in varchar2,
                             a_mensaje in out varchar2,
                             a_error   in out varchar2) IS
    --10.0 se rehace procedimiento
    ln_cabecera    number;
    ln_numero_cab  numtel.numero%type;
    ln_cant_reser  number;
    ln_cant_inssrv number;
    ln_codinssrv   number;
    ln_aux         number;
    ls_numpto      inssrv.numpto%type;
    p_codcab       number;
    p_codgrupo     number;
    p_orden        number;
    ln_cont_cab    number;
    ln_cont_num    number;
    a_msj          varchar2(200);
    a_err          varchar2(200);
    a_tipo         number;
    -- Atributos de Reservatel para actualizar Numtel.
    cursor c_numeros is
      select r.idseq,
             r.codnumtel,
             r.numslc,
             r.numpto,
             d.codsrv,
             n.numero,
             r.publicar,
             c.idproducto
        from reservatel   r,
             numtel       n,
             vtadetptoenl d,
             tystabsrv    b,
             producto     c
       where r.codnumtel = n.codnumtel
         and r.numslc = a_numslc
         and r.valido = 1
         and r.estnumtel in (3, 5)
         and d.numslc = r.numslc
         and d.numpto = r.numpto
         and d.codsrv = b.codsrv
         and d.flgsrv_pri = 1
         and b.idproducto = c.idproducto
         and c.idtipinstserv = 3
         and decode(c.idproducto, 702, 2, 1) = a_tipo
       order by n.numero;
  BEGIN
    -- # Numeros Reservados
    select count(*)
      into ln_cant_reser
      from reservatel
     where trim(numslc) = trim(a_numslc)
       and estnumtel in (3, 5)
       and valido = 1;

    If ln_cant_reser > 0 Then
      -- # Instancias de Servicio
      select count(i.codinssrv)
        into ln_cant_inssrv
        from inssrv i, tystabsrv b, producto c
       where i.codsrv = b.codsrv
         and b.idproducto = c.idproducto
         and i.numslc = a_numslc
         and c.idtipinstserv = 3
         and i.tipinssrv = 3;

      If ln_cant_reser <> ln_cant_inssrv Then
        a_err := 'ERROR';
        a_msj := 'No coincide cantidad de números reservados vs los servicios creados';
      Else
        -- Fin de validación.
        For i in 1 .. 2 loop
          a_tipo := i; -- 1: Numeros Normales y 2: Fax
          ln_aux := 1; -- Escoger el servicio que más se repite

          For c1 in (select i.numpto,
                            i.codinssrv,
                            i.numero,
                            count(p.codinssrv)
                       from inssrv i, insprd p, tystabsrv b, producto c
                      where i.tipinssrv = 3
                        and i.numslc = a_numslc
                        and p.codsrv = b.codsrv
                        and p.codinssrv = i.codinssrv
                        and b.idproducto = c.idproducto
                        and decode(c.idproducto, 702, 2, 1) = a_tipo
                      group by i.numpto, i.codinssrv, i.numero
                      order by 4 desc) loop
            If ln_aux = 1 then
              ls_numpto := c1.numpto;

              select r.codnumtel, n.numero
                into ln_cabecera, ln_numero_cab
                from reservatel r, numtel n
               where numslc = a_numslc
                 and r.codnumtel = n.codnumtel
                 and r.numpto = ls_numpto
                 and r.valido = 1;

              update telefonia.numtel
                 set codinssrv = c1.codinssrv, estnumtel = 2
               where codnumtel = ln_cabecera;

              update inssrv
                 set numero = ln_numero_cab
               where codinssrv = c1.codinssrv;

              If c1.numero is null then
                pq_telefonia.p_crear_hunting(ln_cabecera, p_codcab);
              Else
                Select count(*)
                  into ln_cont_cab
                  from hunting
                 where codnumtel = ln_cabecera;

                If ln_cont_cab = 0 then
                  pq_telefonia.p_crear_hunting(ln_cabecera, p_codcab);
                End If;
              End If;

              If a_tipo = 1 then

                For cur_in in c_numeros loop
                  select min(codinssrv)
                    into ln_codinssrv
                    from inssrv
                   where tipinssrv = 3
                     and numslc = a_numslc
                     and numpto = cur_in.numpto;

                  -- Se actualiza Numtel: estado, inssrv, etc..
                  If ln_cabecera = cur_in.codnumtel Then
                    update telefonia.numtel
                       set publicar = cur_in.publicar
                     where codnumtel = ln_cabecera; -- Se movio la creación del hunting
                    --pq_telefonia.p_crear_hunting(cur_in.codnumtel, p_codcab);
                  Else
                    ln_cont_num := 0;

                    Select count(*)
                      into ln_cont_num
                      from numtel
                     where codnumtel = cur_in.codnumtel
                       and codinssrv = ln_codinssrv;

                    IF ln_cont_num = 0 Then
                      update telefonia.numtel
                         set codinssrv = ln_codinssrv,
                             estnumtel = 2,
                             publicar  = cur_in.publicar
                       where codnumtel = cur_in.codnumtel;

                      update inssrv
                         set numero = cur_in.numero
                       where codinssrv = ln_codinssrv;
                      --  buscar el grupo creado y registrarlo en el numxgrupotel
                    End If;

                    select codcab, codgrupo
                      into p_codcab, p_codgrupo
                      from grupotel
                     where codnumtel = ln_cabecera;

                    ln_cont_num := 0;

                    Select count(*)
                      into ln_cont_num
                      from numxgrupotel ng
                     where ng.codnumtel = cur_in.codnumtel;

                    IF ln_cont_num = 0 Then
                      pq_telefonia.p_crear_numxgrupotel(cur_in.codnumtel,
                                                        p_codcab,
                                                        p_codgrupo,
                                                        p_orden);
                    End If;
                  End If;

                  update reservatel
                     set valido = 1
                   where idseq = cur_in.idseq;

                End loop;
              End If;

              ln_aux := ln_aux + 1;
            Else
              exit;
            End If;
          End loop;

        End loop;

        a_err := 'OK';
        a_msj := 'Se asignaron automáticamente los números telefónicos.';

      End If;
    End If;

    a_error   := a_err;
    a_mensaje := a_msj;

  END;

  PROCEDURE P_ASIG_PORT_TN(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number,
                           a_resultado in out varchar2,
                           a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    a_eb          equipored.codequipo%type;
    a_sector      tarjetaxequipo.codtarjeta%type;
    a_macaddress  varchar2(30);
    a_coordenadas varchar2(30);
    ln_ide        puertoxequipo.ide%type;
    ls_sw_file    varchar2(15);
    ln_codprd     puertoxequipo.codprd%type;
    ls_numslc     solot.numslc%type;
    ln_codsolot   solot.codsolot%type;
    ls_nomcli     vtatabcli.nomcli%type;
    valida        number;
    valida_cid    number;
    exception_asigport exception;
    cursor cur_accesoxinssrv is
      select a.descripcion,
             i.numero,
             a.codinssrv,
             i.numslc,
             i.bw,
             a.codcli,
             a.direccion,
             a.cid
        from acceso a, inssrv i, solotpto p
       where i.codcli = a.codcli
         and i.codinssrv = a.codinssrv
         and i.codinssrv = p.codinssrv
         and p.codsolot = ln_codsolot
       group by a.descripcion,
                i.numero,
                a.codinssrv,
                i.numslc,
                i.bw,
                a.codcli,
                a.direccion,
                a.cid;

    cursor cur_puertos_disponibles is
      select distinct puertoxequipo.codpuerto,
                      puertoxequipo.IDE,
                      equipored.descripcion equipo,
                      tarjetaxequipo.descripcion tarjeta,
                      puertoxequipo.descripcion puerto_descripcion,
                      estado.descripcion estado_puerto,
                      puertoxequipo.fecasig,
                      puertoxequipo.fecinst,
                      puertoxequipo.puerto,
                      puertoxequipo.servicio,
                      productocorp.descripcion,
                      productocorp.tipoproducto,
                      tarjetaxequipo.slot,
                      tarjetaxequipo.flgsubtarj,
                      tarjetaxequipo.codtiptarj,
                      puertoxequipo.codprd,
                      puertoxequipo.estado,
                      puertoxequipo.tipo,
                      puertoxequipo.codequipo,
                      puertoxequipo.codtarjeta,
                      V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
                      PUERTOXEQUIPO.PROVENLACE,
                      PUERTOXEQUIPO.INTERFACE,
                      ambientered.descripcion ambiente,
                      rackred.descripcion rack,
                      puertoxequipo.mediotx,
                      V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION,
                      CIDXIDE.NSR,
                      puertoxequipo.coordenadas,
                      puertoxequipo.FECUSUMOD,
                      puertoxequipo.CODUSUMOD
        FROM puertoxequipo,
             equipored,
             tarjetaxequipo,
             productocorp,
             tipequipored,
             ubired,
             ambientered,
             rackred,
             (select codigon, descripcion from opedd where tipopedd = 151) v_provenl,
             (select codigon, descripcion from opedd where tipopedd = 22) estado,
             (select codigon, descripcion from opedd where tipopedd = 169) v_mediotx,
             CIDXIDE,
             ACCESO,
             (select distinct (codinssrv) codinssrv, numslc
                from vtadetptoenl
               where codinssrv is not null) detproy,
             vtatabslcfac
       where (equipored.codequipo(+) = puertoxequipo.codequipo)
         and (tarjetaxequipo.codtarjeta(+) = puertoxequipo.codtarjeta)
         and (productocorp.codprd(+) = puertoxequipo.codprd)
         and (puertoxequipo.estado = estado.codigon)
         and equipored.tipo = tipequipored.codtipo(+)
         and equipored.codubired = ubired.codubired(+)
         and equipored.codambiente = ambientered.codambiente(+)
         and equipored.codrack = rackred.codrack(+)
         and PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+)
         and PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+)
         and CIDXIDE.CID(+) = PUERTOXEQUIPO.CID
         and CIDXIDE.IDE(+) = PUERTOXEQUIPO.IDE
         and puertoxequipo.cid = acceso.cid(+)
         and acceso.codinssrv = detproy.codinssrv(+)
         and detproy.numslc = vtatabslcfac.numslc(+)
         and equipored.tipo = 114
         and equipored.codequipo = tarjetaxequipo.codequipo
         and tarjetaxequipo.codtiptarj = 305
         and tarjetaxequipo.slot IN ('01', '02', '03', '04', '07', '08')
         and ((puertoxequipo.puerto = '01:') or
             (length(puertoxequipo.puerto) = 5 and
             puertoxequipo.puerto like '01:%'))
         and puertoxequipo.ide is null
         and estado.codigon = 0
         and equipored.codequipo = a_eb
         and tarjetaxequipo.codtarjeta = a_sector;
  BEGIN
    /*Obtener EB y Sector de la Ficha Tecnica*/
    select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, 'BTS')
      into a_eb
      from dummy_ope;
    select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, 'SECTOR')
      into a_sector
      from dummy_ope;
    select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, 'MAC_ADDRESS')
      into a_macaddress
      from dummy_ope;
    select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, 'COORDENADA_CTE')
      into a_coordenadas
      from dummy_ope;

    If a_eb is null or a_sector is null or (a_sector * a_eb = 0) Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de puertos: Valor de la Antena o Sector inválido.';
      raise exception_asigport;
    End If;

    If a_macaddress is null Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de puertos: Valor del MacAddress inválido.';
      raise exception_asigport;
    End If;

    If a_coordenadas is null Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de puertos: Valor de Coordenadas del cliente inválido.';
      raise exception_asigport;
    End If;

    select b.numslc, b.codsolot
      into ls_numslc, ln_codsolot
      from wf a, solot b
     where a.codsolot = b.codsolot
       and a.idwf = a_idwf;

    Begin
      select c.nomcli, nvl(g.codprd, 0)
        into ls_nomcli, ln_codprd
        from vtatabcli        c,
             inssrv           i,
             solotpto         p,
             paquete_venta    paq,
             grupoip_servicio g
       where i.numslc = ls_numslc
         and p.codsolot = ln_codsolot
         and p.codinssrv = i.codinssrv
         and i.codcli = c.codcli
         and paq.idpaq = i.idpaq
         and g.idgrupo(+) = paq.idgrupo
       group by c.nomcli, g.codprd;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Asignación de Puerto: Error en la configuración de Producto x Paquete.';
        raise exception_asigport;
    End;

    If ln_codprd = 0 Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de Puerto: No está configurado el Producto que se asignará al Puerto.';
      raise exception_asigport;
    End If;

    -- Liberar Datos Antiguos
    For c1 in (select c.ide
                 from cidxide c, acceso a, inssrv i, solotpto p
                where c.cid = a.cid
                  and i.codcli = a.codcli
                  and i.codinssrv = a.codinssrv
                  and i.codinssrv = p.codinssrv
                  and p.codsolot = ln_codsolot
                group by c.ide) loop

      Begin
        delete cidxide where ide = c1.ide;

        update puertoxequipo
           set estado      = 0,
               descripcion = null,
               puerto      = '01:',
               ide         = null,
               coordenadas = ''
         where ide = c1.ide;
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Error al liberar datos antiguos. ' || sqlerrm;
          raise exception_asigport;
      End;

    End loop;

    -- Asignar Puerto y Asociar Servicios (Automático)
    valida := 0;
    for c_port in cur_puertos_disponibles loop
      If valida = 0 Then
        select metasolv.SQ_PUERTOXEQUIPO_IDE.NEXTVAL
          into ln_ide
          from dummy_ope;

        Begin
          update puertoxequipo
             set estado      = 2,
                 descripcion = 'IDE ' || to_char(ln_ide) || ' ' ||
                               trim(substr(ls_nomcli,
                                           1,
                                           200 -
                                           length('IDE ' || to_char(ln_ide) || ' '))),
                 puerto      = '01:' || a_macaddress,
                 ide         = ln_ide,
                 coordenadas = a_coordenadas,
                 fecasig     = sysdate,
                 mediotx     = 6,
                 codprd      = ln_codprd
           where codpuerto = c_port.codpuerto;
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Error al actualizar Puerto asignado. ' ||
                           sqlerrm;
            raise exception_asigport;
        End;

        valida_cid := 0;

        For c2 in cur_accesoxinssrv loop

          select count(*) into valida_cid from cidxide where cid = c2.cid;

          If valida_cid = 1 Then
            update cidxide
               set ide = ln_ide, estado = '0'
             where cid = c2.cid;

          Else
            insert into cidxide
              (cid, ide, estado)
            values
              (c2.cid, ln_ide, '0');
          End If;

          Begin
            Update acceso
               set estbw         = 'CN',
                   estprod       = 'CN',
                   bw            = c2.bw,
                   bwoperaciones = c2.bw,
                   codprd        = ln_codprd,
                   descripcion   = F_GET_ACCESO_DESC_PUERTO(c2.cid)
             where cid = c2.cid;
          Exception
            when others then
              a_resultado := 'ERROR';
              a_mensaje   := 'Error al actualizar Subinterfaces del asociadas al Puerto. ' ||
                             sqlerrm;
              raise exception_asigport;
          End;

          valida_cid := 0;

        End loop;

        /* Actualizar Ficha Tecnica - SW File Name */
        Begin
          select descripcion
            into ls_sw_file
            from swfilelist sw, opedd o
           where o.tipopedd =
                 (select tipopedd
                    from tipopedd
                   where descripcion = 'INT-SWFile Name')
             and o.codigon = idswfile
             and sw.codequipo = a_eb
             and sw.codtarjeta = a_sector
             and estado = 1;
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Ficha Técnica: Error en la configuración de parametro SWFileName.';
            raise exception_asigport;
        End;

        Begin
          PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                            'SW FILE',
                                            ls_sw_file);
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Ficha Técnica: Error en la actualización de parametro SWFileName. ' ||
                           sqlerrm;
            a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
            raise exception_asigport;
        End;

        /* Actualizar Ficha Tecnica - Telefonia Service Name */
        Begin
          PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                            'SERVICE - TELEPHONE',
                                            'IDE ' || to_char(ln_ide) ||
                                            ' TELEFONIA_FIJA');
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro SERVICE - TELEPHONE. ' ||
                           sqlerrm;
            a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
            raise exception_asigport;
        End;

        /* Actualizar Ficha Tecnica - Telefonia Service Name */
        Begin
          PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                            'IDE',
                                            to_char(ln_ide));
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IDE. ' ||
                           sqlerrm;
            a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
            raise exception_asigport;
        End;

        valida := 1;

      Else
        exit;
      End If;
    End loop;

    If valida = 0 Then
      -- Tarea Error No se ha obtenido puertos disponibles
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de puertos: No se ha obtenido Puertos disponibles.';
      raise exception_asigport;
    Elsif valida = 1 Then
      a_resultado := 'OK';
      a_mensaje   := 'Ficha Técnica: Proceso Finalizado.';
    End If;

  EXCEPTION
    when exception_asigport Then
      return;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de Puertos: ' || sqlerrm;
      return;
  END;

  PROCEDURE P_ASIG_IP_TN(a_idtareawf in number,
                         a_idwf      in number,
                         a_tarea     in number,
                         a_tareadef  in number,
                         a_resultado in out varchar2,
                         a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    p_numslc          solot.numslc%type;
    p_codsolot        solot.codsolot%type;
    ls_nomcli         vtatabcli.nomcli%type;
    p_idpaq           vtadetptoenl.idpaq%type;
    p_eb              clasec.codequipo%type;
    ps_eb             varchar2(100);
    ps_sector         varchar2(100);
    p_banwid          tystabsrv.banwid%type;
    p_cid_bl          inssrv.cid%type;
    p_cid_tel         inssrv.cid%type;
    p_cid_serv        inssrv.cid%type;
    a_cant_tel        number;
    a_cant_bl         number;
    p_profile_tel     profilelist.nomprofile%type;
    p_profile_bl      profilelist.nomprofile%type;
    p_profile_serv    profilelist.nomprofile%type;
    vn_ips_publicas   number;
    p_idgrupo_bl      grupoip_servicio.idgrupo%type;
    p_idgrupo_ips     grupoip_servicio.idgrupo%type;
    p_idgrupo_tel     grupoip_servicio.idgrupo%type;
    p_idgrupo         grupoip_servicio.idgrupo%type;
    p_flg_ip_lan      number;
    p_flg_equipo      number;
    p_flg_equipo_serv number;
    p_cant_ips        number;
    p_clasec          clasec.clasec%type;
    r_rangosip        rangosip%rowtype;
    exception_ips exception;
    ln_aux        number;
    valida        number;
    valida_iplan  number;
    valida_ipserv number;
    i             number;
    j             number;
    p_numini4     number;
    p_numfin4     number;
    p_numero4     number;
    p_iplan_mask constant rangosip.iplan_mask%type := '255.255.255.';
    p_ipwan_mask constant rangosip.ipwan_mask%type := '255.255.255.';
    p_ip     rangosip.iplan%type;
    p_maskdg rangoclasec.maskdg%type;
    cursor cur_ips_disponibles is
      select ip.numero,
             ip.numero4,
             cla.clasec,
             ra.idrango,
             ra.estado,
             ra.maskdg,
             ra.flg_equipo,
             ra.vlan
        from clasec cla, rangoclasec ra, rangoxgrupoprod rg, ipxclasec ip
       where cla.codequipo = p_eb
         and cla.clasec = ra.clasec
         and ra.idrango = rg.idrango
         and rg.idgrupo = p_idgrupo
         and ra.flg_equipo = p_flg_equipo_serv
         and ip.clasec = cla.clasec
         and ip.numero4 between ra.rangini and ra.rangfin
         and ip.idrango is null
       order by cla.clasec, ip.numero4;

    cursor cur_ips_disponibles_clase is
      select ip.numero,
             ip.numero4,
             cla.clasec,
             ra.idrango,
             ip.idrango val_rango,
             ra.estado,
             ra.maskdg,
             ra.vlan
        from clasec cla, rangoclasec ra, rangoxgrupoprod rg, ipxclasec ip
       where cla.codequipo = p_eb
         and cla.clasec = ra.clasec
         and ra.idrango = rg.idrango
         and rg.idgrupo = p_idgrupo
         and cla.clasec = p_clasec
         and ip.numero4 >= p_numero4
         and ip.clasec = cla.clasec
         and ip.numero4 between ra.rangini and ra.rangfin
         and ip.idrango is null
       order by cla.clasec, ip.numero4;
  BEGIN
    /* Datos Generales*/
    select s.numslc, s.codsolot
      into p_numslc, p_codsolot
      from wf, solot s
     where wf.codsolot = s.codsolot
       and wf.idwf = a_idwf;

    select nomcli
      into ls_nomcli
      from vtatabcli c, vtatabslcfac v
     where v.codcli = c.codcli
       and v.numslc = p_numslc;

    /*Obtener EB de la Ficha Tecnica*/
    select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, 'BTS')
      into p_eb
      from dummy_ope;

    select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, 'BTS')
      into ps_eb
      from dummy_ope;

    select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, 'SECTOR')
      into ps_sector
      from dummy_ope;

    select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, 'FLAG_EQUIPO_WEB')
      into p_flg_equipo
      from dummy_ope;

    If p_flg_equipo is null Then
      a_resultado := 'ERROR';
      a_mensaje   := 'El valor del Flag de Equipo Web no es válido: ' ||
                     to_char(nvl(null, 'NULO'));
      raise exception_ips;
    End If;
    /*IP Telefonia*/
    a_cant_tel := F_GET_CANT_LINEAS_2(p_codsolot);

    If a_cant_tel = -1 Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Lineas Telefonicas: Error al obtener cantidad de Lineas Telefónicas';
      raise exception_ips;
    End If;

    If a_cant_tel > 0 Then

      select nvl(min(i.cid), 0)
        into p_cid_tel
        from solotpto p, inssrv i, insprd ip, tystabsrv t, producto c
       where p.codsolot = p_codsolot
         and i.codinssrv = p.codinssrv
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3;

      Begin
        select gs.idgrupo, gs.cant_ip
          into p_idgrupo_tel, p_cant_ips
          from solotpto          p,
               inssrv            i,
               insprd            ip,
               tystabsrv         t,
               producto          c,
               grupoipxserv_auto gs
         where p.codsolot = p_codsolot
           and i.cid = p_cid_tel
           and i.codinssrv = p.codinssrv
           and ip.codinssrv = i.codinssrv
           and ip.codsrv = t.codsrv
           and ip.flgprinc = 1
           and c.idproducto = t.idproducto
           and c.idtipinstserv = 3
           and gs.codsrv = i.codsrv
         group by gs.idgrupo, gs.cant_ip;
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Lineas Telefonicas: Error al obtener grupo de IPs de Lineas Telefónicas';
          raise exception_ips;
      End;

      ln_aux                := 0; -- para validar Rangos e Ips
      p_idgrupo             := p_idgrupo_tel;
      r_rangosip.ipwan_mask := p_ipwan_mask || to_char(256 - p_cant_ips);

      select count(*) into ln_aux from rangosip where cid = p_cid_tel;

      If ln_aux = 0 Then
        /* Insertar en rangosip para Telefonia*/
        select F_GET_RANGOSIP_ID() into r_rangosip.idrango from dummy_ope;

        r_rangosip.rango  := 'CID ' || to_char(p_cid_tel) || ' ';
        r_rangosip.rango  := r_rangosip.rango ||
                             trim(substr(ls_nomcli,
                                         1,
                                         30 - length(r_rangosip.rango)));
        r_rangosip.estado := '1';
        r_rangosip.tipo   := 'C';

        insert into rangosip
          (idrango, rango, estado, tipo, cid, ipwan_mask)
        values
          (r_rangosip.idrango,
           r_rangosip.rango,
           r_rangosip.estado,
           r_rangosip.tipo,
           p_cid_tel,
           r_rangosip.ipwan_mask);

      Else
        -- Ver si tiene ips asociadas al rango, sino asociar
        Begin
          select idrango
            into r_rangosip.idrango
            from rangosip
           where cid = p_cid_tel;

        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Asignación de IPs: Error al obtener el RangoIP para Cid telefonía: ' ||
                           to_char(p_cid_tel);
            raise exception_ips;
        End;

        select count(*)
          into ln_aux
          from ipxclasec
         where idrango = r_rangosip.idrango;
        -- Si existen IPs se conservan
        /*update rangosip
          set observacion = null, ipwan = null, ipwan_mask = null
        where idrango = r_rangosip.idrango;*/
      End If;

      If r_rangosip.idrango > 0 and ln_aux = 0 Then
        -- Primero limpiar todas las IPs asociadas al rango encontrado
        update ipxclasec
           set idrango = null, tipo = null
         where idrango = r_rangosip.idrango;

        valida            := 0;
        p_ip              := null;
        p_maskdg          := null;
        p_flg_equipo_serv := 0;

        for c_iptel in cur_ips_disponibles loop
          If valida = 0 Then
            update ipxclasec
               set idrango = r_rangosip.idrango, tipo = 'W'
             where numero = c_iptel.numero
               and numero4 = c_iptel.numero4
               and clasec = c_iptel.clasec;

            p_ip     := substr(c_iptel.clasec,
                               1,
                               instr(c_iptel.clasec, '.', 1, 3)) ||
                        c_iptel.numero4;
            p_maskdg := c_iptel.maskdg;

            update rangosip
               set ipwan       = p_ip,
                   ipwan_mask  = r_rangosip.ipwan_mask,
                   observacion = 'EB y SECTOR:' || trim(ps_eb) || ' ' ||
                                 trim(ps_sector) || 'MASK/DG:' || p_maskdg
             where idrango = r_rangosip.idrango;

            /*  Actualizar Ficha Tecnica - Profiles Name : Telefonia */
            Begin
              select pf.nomprofile
                into p_profile_tel
                from profilelist pf
               where pf.vlan = c_iptel.vlan
                 and pf.totlinea = a_cant_tel
                 and pf.codequipo = p_eb
                 and pf.tipo = 2; -- Telefonia
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error al Obtener de parámetro PROFILE - TELEPHONE. VLAN/#Lineas Telef.: ' ||
                               to_char(c_iptel.vlan) || '/' ||
                               to_char(a_cant_tel);
                raise exception_ips;
            End;
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'PROFILE - TELEPHONE',
                                                p_profile_tel);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro PROFILE - TELEPHONE. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            -- PROFILE - TELEPHONE
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'IP - TELEPHONE',
                                                p_ip);
            exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP - TELEPHONE. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            -- IP - TELEPHONE
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'MASK/DG IP_TELEPHONE',
                                                p_maskdg);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_TELEPHONE. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            --MASK/DG IP_TELEPHONE
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'CID - TELEPHONE',
                                                p_cid_tel);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro CID - TELEPHONE. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            --CID TELEPHONE
            valida   := 1;
            p_ip     := null;
            p_maskdg := null;
          Else
            exit;
          End If;
        End loop;
        -- Tarea Error No se ha obtenido IP para el CID
        If valida = 0 Then

          a_resultado := 'ERROR';
          a_mensaje   := 'Asignación de IPs: Error al obtener el IP para CID Telefonía: ' ||
                         to_char(p_cid_tel);
          raise exception_ips;
        End If;
      End If;

    Else
      Begin
        PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                          'IP - TELEPHONE',
                                          '0');
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP - TELEPHONE. ' ||
                         sqlerrm;
          a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
          raise exception_ips;
      End;
      --IP TELEPHONE
      Begin
        PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                          'MASK/DG IP_TELEPHONE',
                                          '0');
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_TELEPHONE. ' ||
                         sqlerrm;
          a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
          raise exception_ips;
      End;
      -- MASK/DG TELEPHONE
      valida := 1;
    End If;

    /*IPs Banda Larga y otros servicios*/
    a_cant_bl := F_GET_CANT_BANDALARGA(p_codsolot);

    If a_cant_bl = -1 Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Internet: Error al obtener cantidad de Banda Larga.';
      raise exception_ips;
    End If;

    /*IPs Otros Servicios: Para el caso IPs-LAN Se valida flg_lan en grupoipxserv_auto */
    select count(*)
      into vn_ips_publicas
      from solotpto          sp,
           insprd            ip,
           inssrv            i,
           tystabsrv         b,
           producto          c,
           grupoipxserv_auto gs,
           grupoip_servicio  g
     where sp.codsolot = p_codsolot
       and i.codinssrv = sp.codinssrv
       and ip.codinssrv = i.codinssrv
       and ip.pid = sp.pid
       and b.codsrv = ip.codsrv
       and c.idproducto = b.idproducto
       and nvl(c.idtipinstserv, 0) <> 3
       and gs.codsrv = b.codsrv
       and g.idgrupo = gs.idgrupo;

    /* Caso Otros Servicios Tipo Internet */
    For c_serv_ip in (select i.cid,
                             gs.idgrupo,
                             gs.cant_ip,
                             gs.flg_lan,
                             g.etiqueta
                        from solotpto          sp,
                             insprd            ip,
                             inssrv            i,
                             tystabsrv         b,
                             producto          c,
                             grupoipxserv_auto gs,
                             grupoip_servicio  g
                       where sp.codsolot = p_codsolot
                         and i.codinssrv = sp.codinssrv
                         and ip.codinssrv = i.codinssrv
                         and ip.pid = sp.pid
                         and b.codsrv = ip.codsrv
                         and c.idproducto = b.idproducto
                         and nvl(c.idtipinstserv, 0) <> 3
                         and gs.codsrv = b.codsrv
                         and gs.flg_lan = 0
                         and g.etiqueta is not null
                         and gs.flg_equipo = p_flg_equipo
                         and g.idgrupo = gs.idgrupo
                       group by i.cid,
                                gs.idgrupo,
                                gs.cant_ip,
                                gs.flg_lan,
                                g.etiqueta) Loop
      p_idgrupo_ips := c_serv_ip.idgrupo;
      p_cid_serv    := c_serv_ip.cid;
      p_cant_ips    := c_serv_ip.cant_ip;
      p_flg_ip_lan  := c_serv_ip.flg_lan;
      valida_ipserv := 1; --**

      valida                := 0;
      p_ip                  := null;
      p_maskdg              := null;
      p_numini4             := 0;
      p_numfin4             := 0;
      p_idgrupo             := p_idgrupo_ips;
      p_flg_equipo_serv     := p_flg_equipo;
      r_rangosip.ipwan_mask := p_ipwan_mask || to_char(256 - p_cant_ips);

      select count(*) into ln_aux from rangosip where cid = p_cid_serv;

      If ln_aux = 0 Then
        /* Insertar en rangosip para cada Servicio Nuevo*/
        select F_GET_RANGOSIP_ID() into r_rangosip.idrango from dummy_ope;

        r_rangosip.rango  := 'CID ' || to_char(p_cid_serv) || ' ';
        r_rangosip.rango  := r_rangosip.rango ||
                             trim(substr(ls_nomcli,
                                         1,
                                         30 - length(r_rangosip.rango)));
        r_rangosip.estado := '1';
        r_rangosip.tipo   := 'C';

        insert into rangosip
          (idrango, rango, estado, tipo, cid)
        values
          (r_rangosip.idrango,
           r_rangosip.rango,
           r_rangosip.estado,
           r_rangosip.tipo,
           p_cid_serv);

      Else
        -- Ver si tiene ips asociadas al rango, sino asociar
        Begin
          select idrango
            into r_rangosip.idrango
            from rangosip
           where cid = p_cid_serv;
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Asignación de IPs: Error al obtener el RangoIP para Cid telefonía: ' ||
                           to_char(p_cid_serv);
            raise exception_ips;
        End;

        select count(*)
          into ln_aux
          from ipxclasec
         where idrango = r_rangosip.idrango;
        -- Si existen IPs se conservan
      End if;

      If r_rangosip.idrango > 0 and ln_aux < p_cant_ips Then
        -- Primero limpiar todas las IPs asociadas al rango encontrado
        update ipxclasec
           set idrango = null, tipo = null
         where idrango = r_rangosip.idrango;

        valida     := 0;
        p_ip       := null;
        p_maskdg   := null;
        p_cant_ips := p_cant_ips - nvl(ln_aux, 0);

        -- Obtiene los IPs segun la cantidad
        for c_ipserv_dis in cur_ips_disponibles loop
          p_clasec  := c_ipserv_dis.clasec;
          p_numero4 := c_ipserv_dis.numero4;
          i         := 0;

          for c_ipserv_clas in cur_ips_disponibles_clase loop
            If i = 0 Then
              p_numini4 := c_ipserv_clas.numero4;
            End If;
            If c_ipserv_clas.val_rango is null Then
              i := i + 1;
            End If;
            If i = p_cant_ips Then
              p_numfin4 := c_ipserv_clas.numero4;

              If p_numfin4 - p_numini4 + 1 = p_cant_ips Then
                valida   := 1;
                p_maskdg := c_ipserv_clas.maskdg;
                exit;
              Else
                i         := 0;
                p_numini4 := 0;
                p_numfin4 := 0;
              End If;
            End If;

          End loop;

          If valida = 1 Then

            p_ip := substr(p_clasec, 1, instr(p_clasec, '.', 1, 3)) ||
                    p_numini4;

            update rangosip
               set ipwan = p_ip, ipwan_mask = r_rangosip.ipwan_mask /*,
                                                                               ipwanfin   = substr(p_clasec, 1, instr(p_clasec, '.', 1, 3)) || p_numfin4*/
             where idrango = r_rangosip.idrango;

            for j in p_numini4 .. p_numfin4 loop
              update ipxclasec
                 set idrango = r_rangosip.idrango, tipo = 'W'
               where numero4 = j
                 and clasec = p_clasec;
            End loop;

            If p_flg_equipo_serv = 0 then
              -- Inicio Registro de Datos de la Ficha
              Begin
                select pf.nomprofile
                  into p_profile_serv
                  from profilelist pf
                 where pf.vlan = c_ipserv_dis.vlan
                   and pf.idgrupo = p_idgrupo
                   and pf.codequipo = p_eb
                   and pf.tipo = 1; -- Banda Larga
              Exception
                when others then
                  a_resultado := 'ERROR';
                  a_mensaje   := 'Ficha Técnica: Error al obtener de parámetro PROFILE - ' ||
                                 c_serv_ip.etiqueta || '. VLAN: ' ||
                                 TO_CHAR(c_ipserv_dis.vlan) ||
                                 '. GRUPOIP: ' || TO_CHAR(p_idgrupo);
                  raise exception_ips;
              End;
            Else
              p_profile_serv := '';
            End If;

            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'PROFILE - ' ||
                                                c_serv_ip.etiqueta,
                                                p_profile_serv);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en al actualizar parámetro PROFILE - ' ||
                               c_serv_ip.etiqueta || sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;

            End;
            -- PROFILE - XXXXXX
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'IP - ' ||
                                                c_serv_ip.etiqueta,
                                                p_ip);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP - ' ||
                               c_serv_ip.etiqueta || '. ' || sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            --IP - XXXXXX
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'MASK/DG ' ||
                                                c_serv_ip.etiqueta,
                                                p_maskdg);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG ' ||
                               c_serv_ip.etiqueta || '. ' || sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            --MASK/DG XXXXXX
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'CID - ' ||
                                                c_serv_ip.etiqueta,
                                                to_char(p_cid_serv));
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro CID - ' ||
                               c_serv_ip.etiqueta || '. ' || sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;

            End;
            -- CID - XXXXXX
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'SERVICE - ' ||
                                                c_serv_ip.etiqueta,
                                                'CID ' ||
                                                to_char(p_cid_serv) || ' ' ||
                                                c_serv_ip.etiqueta);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro SERVICE - INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            -- SERVICE - XXXXXXX
            p_ip     := null;
            p_maskdg := null;
            exit;
            --Error de la tarea: No se encontraron IPs disponibles
          Else
            a_resultado := 'ERROR';
            a_mensaje   := 'Asignación de IPs: Error al obtener el IPs ' ||
                           c_serv_ip.etiqueta || ': ' ||
                           to_char(p_cid_serv);
            raise exception_ips;
          End if;
        End Loop;

      End if;

      -- Tarea Error No se ha obtenido IP para el CID
      If valida = 0 Then
        a_resultado := 'ERROR';
        a_mensaje   := 'Asignación de IPs: Error al obtener el IP para CID ' ||
                       c_serv_ip.etiqueta || ': ' || to_char(p_cid_serv);
        raise exception_ips;
      End If;
    End Loop;

    If a_cant_bl > 0 Then

      select i.idpaq, b.banwid, p.idgrupo, i.cid
        into p_idpaq, p_banwid, p_idgrupo_bl, p_cid_bl
        from solotpto      sp,
             insprd        ip,
             inssrv        i,
             tystabsrv     b,
             producto      c,
             paquete_venta p
       where sp.codsolot = p_codsolot
         and i.codinssrv = sp.codinssrv
         and ip.codinssrv = i.codinssrv
         and ip.pid = sp.pid
         and ip.flgprinc = 1
         and i.tipinssrv = 1
         and c.tipsrv = '0006'
         and b.codsrv = ip.codsrv
         and p.idpaq = i.idpaq
         and b.idproducto = c.idproducto;

      ln_aux := 0; -- para validar rangos de Internet

      select count(*) into ln_aux from rangosip where cid = p_cid_bl;

      If ln_aux = 0 Then
        /* Insertar en rangosip para Banda Larga*/
        select F_GET_RANGOSIP_ID() into r_rangosip.idrango from dummy_ope;

        r_rangosip.rango  := 'CID ' || to_char(p_cid_bl) || ' ';
        r_rangosip.rango  := r_rangosip.rango ||
                             trim(substr(ls_nomcli,
                                         1,
                                         30 - length(r_rangosip.rango)));
        r_rangosip.estado := '1';
        r_rangosip.tipo   := 'C';

        insert into rangosip
          (idrango, rango, estado, tipo, cid)
        values
          (r_rangosip.idrango,
           r_rangosip.rango,
           r_rangosip.estado,
           r_rangosip.tipo,
           p_cid_bl);

      Else
        -- Ver si tiene ips asociadas al rango, sino asociar
        Begin
          select idrango
            into r_rangosip.idrango
            from rangosip
           where cid = p_cid_bl;
        Exception
          when others then
            a_resultado := 'ERROR';
            a_mensaje   := 'Asignación de IPs: Error al obtener el RangoIP para CID Internet: ' ||
                           to_char(p_cid_bl);
            raise exception_ips;
        End;
        -- Limpiar datos antiguos (?? o Actualizar Fichas??)
        select count(*)
          into ln_aux
          from ipxclasec
         where idrango = r_rangosip.idrango;
        /*Begin
           update rangosip set observacion = null, ipwan = null, iplan = null, ipwan_mask = null, iplan_mask = null
            where idrango = r_rangosip.idrango;
        Exception when others then
              a_resultado := 'ERROR';
              a_mensaje   := 'Asignación de IPs: Error al actualizar el RangoIP para CID Internet: ' || to_char(p_cid_bl);
              raise exception_ips;
        End;*/
      End If;

      r_rangosip.ipwan_mask := p_ipwan_mask;

      If r_rangosip.idrango > 0 and ln_aux = 0 Then
        -- Primero limpiar todas las IPs asociadas al rango encontrado
        update ipxclasec
           set idrango = null, tipo = null
         where idrango = r_rangosip.idrango;

        If vn_ips_publicas > 0 Then
          /* Caso IPS LAN*/
          valida_iplan := 0; -- Para actualizar Parametros de la Ficha si no existen

          For c_serv_ip in (select gs.idgrupo, gs.cant_ip, gs.flg_lan
                              from solotpto          sp,
                                   insprd            ip,
                                   inssrv            i,
                                   tystabsrv         b,
                                   producto          c,
                                   grupoipxserv_auto gs,
                                   grupoip_servicio  g
                             where sp.codsolot = p_codsolot
                               and i.codinssrv = sp.codinssrv
                               and ip.codinssrv = i.codinssrv
                               and ip.pid = sp.pid
                               and b.codsrv = ip.codsrv
                               and c.idproducto = b.idproducto
                               and nvl(c.idtipinstserv, 0) <> 3
                               and gs.codsrv = b.codsrv
                               and gs.flg_lan = 1
                               and g.idgrupo = gs.idgrupo
                             group by gs.idgrupo, gs.cant_ip, gs.flg_lan) Loop

            p_idgrupo_ips := c_serv_ip.idgrupo;
            p_cant_ips    := c_serv_ip.cant_ip;
            p_flg_ip_lan  := c_serv_ip.flg_lan;
            valida_iplan  := 1;

            valida            := 0;
            p_ip              := null;
            p_maskdg          := null;
            p_numini4         := 0;
            p_numfin4         := 0;
            p_idgrupo         := p_idgrupo_ips;
            p_flg_equipo_serv := 0;

            If p_flg_ip_lan = 1 Then
              r_rangosip.iplan_mask := p_iplan_mask ||
                                       to_char(256 - p_cant_ips);
            Else
              r_rangosip.iplan_mask := null;
            End If;

            -- Obtiene los IPs segun la cantidad
            for c_ippub_dis in cur_ips_disponibles loop
              p_clasec  := c_ippub_dis.clasec;
              p_numero4 := c_ippub_dis.numero4;
              i         := 0;

              for c_ippub_clas in cur_ips_disponibles_clase loop
                If i = 0 Then
                  p_numini4 := c_ippub_clas.numero4;
                End If;
                If c_ippub_clas.val_rango is null Then
                  i := i + 1;
                End If;
                If i = p_cant_ips Then
                  p_numfin4 := c_ippub_clas.numero4;

                  If p_numfin4 - p_numini4 + 1 = p_cant_ips Then
                    valida   := 1;
                    p_maskdg := c_ippub_clas.maskdg;
                    exit;
                  Else
                    i         := 0;
                    p_numini4 := 0;
                    p_numfin4 := 0;
                  End If;
                End If;

              End loop;

              If valida = 1 Then

                p_ip := substr(p_clasec, 1, instr(p_clasec, '.', 1, 3)) ||
                        p_numini4;

                update rangosip
                   set iplan      = p_ip,
                       iplan_mask = r_rangosip.iplan_mask,
                       iplanfin   = substr(p_clasec,
                                           1,
                                           instr(p_clasec, '.', 1, 3)) ||
                                    p_numfin4
                 where idrango = r_rangosip.idrango;

                for j in p_numini4 .. p_numfin4 loop
                  update ipxclasec
                     set idrango = r_rangosip.idrango, tipo = 'L'
                   where numero4 = j
                     and clasec = p_clasec;
                End loop;

                Begin
                  PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                    'IP_LAN',
                                                    p_ip);
                Exception
                  when others then
                    a_resultado := 'ERROR';
                    a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP_LAN. ' ||
                                   sqlerrm;
                    a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje,
                                                      'ORA-[0-9]*: ');
                    raise exception_ips;
                End;
                --IP_LAN
                Begin
                  PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                    'MASK/DG IP_LAN',
                                                    p_maskdg);
                Exception
                  when others then
                    a_resultado := 'ERROR';
                    a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_LAN. ' ||
                                   sqlerrm;
                    a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje,
                                                      'ORA-[0-9]*: ');
                    raise exception_ips;
                End;
                --MASK/DG IP_LAN
                p_ip     := null;
                p_maskdg := null;
                exit;
                --Error de la tarea: No se encontraron IPs disponibles
              Else
                a_resultado := 'ERROR';
                a_mensaje   := 'Asignación de IPs: Error al obtener el IPs Públicas.';
                raise exception_ips;
              End If;

            End loop;

          End Loop;

          IF valida_iplan = 0 then
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf, 'IP_LAN', '0');
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP_LAN. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'MASK/DG IP_LAN',
                                                '0');
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_LAN. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;
          End If;

        End If;

        valida            := 0;
        p_ip              := null;
        p_maskdg          := null;
        p_idgrupo         := p_idgrupo_bl;
        p_cant_ips        := 1;
        p_flg_equipo_serv := 0;

        for c_ipbl in cur_ips_disponibles loop
          If valida = 0 Then
            update ipxclasec
               set idrango = r_rangosip.idrango, tipo = 'W'
             where numero = c_ipbl.numero
               and numero4 = c_ipbl.numero4
               and clasec = c_ipbl.clasec;

            p_ip     := substr(c_ipbl.clasec,
                               1,
                               instr(c_ipbl.clasec, '.', 1, 3)) ||
                        c_ipbl.numero4;
            p_maskdg := c_ipbl.maskdg;

            update rangosip
               set ipwan       = p_ip,
                   ipwan_mask  = r_rangosip.ipwan_mask ||
                                 to_char(256 - p_cant_ips),
                   observacion = 'EB y SECTOR' || trim(ps_eb) || ' ' ||
                                 trim(ps_sector) || 'MASK/DG:' || p_maskdg
             where idrango = r_rangosip.idrango;

            /* Actualizar Ficha Tecnica - Profiles : Banda Larga */
            Begin
              select pf.nomprofile
                into p_profile_bl
                from profilelist pf
               where pf.vlan = c_ipbl.vlan
                 and pf.idgrupo = p_idgrupo_bl
                 and pf.codequipo = p_eb
                 and pf.tipo = 1; -- Banda Larga
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error al Obtener de parámetro PROFILE - INTERNET.';
                raise exception_ips;
            End;

            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'PROFILE - INTERNET',
                                                p_profile_bl);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en al actualizar parámetro PROFILE - INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;

            /* Actualizar Ficha Tecnica - Internet Service Name */
            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'SERVICE - INTERNET',
                                                'CID ' || to_char(p_cid_bl));
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro SERVICE - INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;

            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'IP - INTERNET',
                                                p_ip);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP - INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;

            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'MASK/DG IP_INTERNET',
                                                p_maskdg);
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;

            p_ip     := null;
            p_maskdg := null;

            Begin
              PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                                'CID - INTERNET',
                                                to_char(p_cid_bl));
            Exception
              when others then
                a_resultado := 'ERROR';
                a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro CID - INTERNET. ' ||
                               sqlerrm;
                a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
                raise exception_ips;
            End;

            valida := 1;
          Else
            exit;
          End If;
        End loop;
        If valida = 0 Then
          a_resultado := 'ERROR';
          a_mensaje   := 'Asignación de IPs: Error al obtener el IP para el Cid Internet: ' ||
                         to_char(p_cid_bl);
          raise exception_ips;
        End If;
      End If;

    Else
      Begin
        PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                          'IP - INTERNET',
                                          '0');
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro IP - INTERNET. ' ||
                         sqlerrm;
          a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
          raise exception_ips;
      End;
      Begin
        PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_idtareawf,
                                          'MASK/DG IP_INTERNET',
                                          '0');
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro MASK/DG IP_INTERNET. ' ||
                         sqlerrm;
          a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
          raise exception_ips;
      End;
    End If;

    If valida = 1 Then
      a_resultado := 'OK';
      a_mensaje   := 'Asignación de IPs: Proceso Finalizado.';
    End If;

  EXCEPTION
    when exception_ips Then
      return;
    when others Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Asignación de IPs: ' || sqlerrm;
      return;
  END;

  PROCEDURE P_ACT_FICHA_TN(a_codigo1   in number,
                           a_resultado in out varchar2,
                           a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    as_text      vtatabcli.nomcli%type;
    ls_numslc    solot.numslc%type;
    ln_codsolot  solot.codsolot%type;
    r_cliente    vtatabcli%rowtype;
    an_len       number;
    a_ide        varchar2(30);
    a_first_name varchar2(50);
    a_last_name  varchar2(50);
    a_desc_name  varchar2(100);
    a_suscriber  varchar2(200);
    exception_swfile exception;
    exception_suscriber exception;
  BEGIN
    select s.numslc, s.codsolot
      into ls_numslc, ln_codsolot
      from tareawf t, wf, solot s
     where t.idtareawf = a_codigo1
       and wf.idwf = t.idwf
       and s.codsolot = wf.codsolot;

    select vtatabcli.*
      into r_cliente
      from vtatabcli, vtatabslcfac
     where vtatabslcfac.numslc = ls_numslc
       and vtatabcli.codcli = vtatabslcfac.codcli;

    /* Suscriber */
    Begin
      a_suscriber := F_GET_SUSCRIBER_PROY(ls_numslc);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Configuración de Producto: Error al obtener parametro Suscriber.';
        raise exception_suscriber;
    End;

    If a_suscriber = '-1' Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Configuración de Producto: Error al obtener parametro Suscriber';
      raise exception_suscriber;
    End If;

    select F_GET_TXT_PLATAFORMA(a_codigo1, 'IDE')
      into a_ide
      from dummy_ope;
    If a_ide is null Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Ficha Técnica: Error al obtener IDE.';
      raise exception_suscriber;
    End If;
    /* Names */
    If a_suscriber is null Then
      as_text := trim(r_cliente.nomcli);
      an_len  := length(r_cliente.nomcli);

      If an_len > 14 and nvl(instr(as_text, ' ', 15, 1), 0) <> 0 Then
        as_text := substr(as_text, 1, instr(as_text, ' ', 15, 1) - 1);
        an_len  := length(as_text);
      End If;

      If mod(an_len, 2) = 0 Then
        a_first_name := substr(as_text, 1, an_len / 2);
        a_last_name  := substr(as_text, an_len / 2 + 1, an_len);
      Else
        a_first_name := substr(as_text, 1, an_len + 1 / 2);
        a_last_name  := substr(as_text, (an_len + 1 / 2) + 1, an_len);
      End If;

      a_first_name := replace(a_first_name, ' ', '_');
      a_last_name  := replace(a_last_name, ' ', '_');

      a_desc_name := nvl(a_first_name || a_last_name, '.');
      a_suscriber := to_char(a_ide) || '_' || a_desc_name;
    End If;

    a_desc_name  := nvl(a_first_name || a_last_name, '.');
    a_last_name  := nvl(a_last_name, '.');
    a_first_name := nvl(a_first_name, '.');

    If a_suscriber is null Then
      a_resultado := 'ERROR';
      a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro Suscriber .';
      raise exception_suscriber;
    End If;

    Begin
      PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_codigo1,
                                        'FIRST NAME',
                                        a_first_name);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Ficha Técnica: Error en la actualización de parametro First Name. ' ||
                       sqlerrm;
        a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
        raise exception_suscriber;
    End;

    Begin
      PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_codigo1,
                                        'LAST NAME',
                                        a_last_name);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Ficha Técnica: Error en la actualización de parametro Last Name. ' ||
                       sqlerrm;
        a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
        raise exception_suscriber;
    End;

    Begin
      PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_codigo1,
                                        'DESC NAME',
                                        a_desc_name);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Ficha Técnica: Error en la actualización de parametro Desc Name. ' ||
                       sqlerrm;
        a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
        raise exception_suscriber;
    End;

    Begin
      PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_codigo1,
                                        'SUSCRIBER',
                                        a_suscriber);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Ficha Técnica: Error en la actualización de parametro SUSCRIBER. ' ||
                       sqlerrm;
        a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
        raise exception_suscriber;
    End;

  EXCEPTION
    when exception_suscriber Then
      return;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Actualización de Suscriber: ' || sqlerrm;
      return;
  END;

  PROCEDURE P_ACT_DOC_PROV(a_idtareawf in number,
                           a_resultado in out varchar2,
                           a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    ls_numslc     solot.numslc%type;
    ln_codsolot   solot.codsolot%type;
    ls_nomcli     vtatabcli.nomcli%type;
    ls_paquete    paquete_venta.observacion%type;
    ln_idtareawf  number;
    ln_aux        number;
    ls_anotacion  tareawfseg.observacion%type;
    ls_cids       varchar2(500);
    ls_aux2       varchar2(100);
    a_ide         varchar2(30);
    a_ip_tel      varchar2(30);
    a_mask_tel    varchar2(30);
    a_ip_bl       varchar2(30);
    a_mask_bl     varchar2(30);
    a_ip_lan      varchar2(30);
    a_mask_lan    varchar2(30);
    a_fqdn        varchar2(30);
    a_eb          varchar2(30);
    a_sector      varchar2(30);
    a_macaddress  varchar2(30);
    a_coordenadas varchar2(30);
    c_prod_fax    number;
    c_prod_bl     number;
    exception_doc exception;
    cursor cur_cid_telefonia is
      select i.cid, i.numero
        from solotpto p,
             inssrv i,
             insprd ip,
             tystabsrv t,
             producto c,
             wf,
             tareawf tw
       where tw.idtareawf = a_idtareawf
         and wf.idwf = tw.idwf
         and p.codsolot = wf.codsolot
         and i.codinssrv = p.codinssrv
         and ip.codinssrv = i.codinssrv
         and ip.codsrv = t.codsrv
         and ip.flgprinc = 1
         and c.idproducto = t.idproducto
         and c.idtipinstserv = 3
         and i.cid is not null
       group by i.cid, i.numero
       order by i.cid;
    cursor cur_cid_bl is
      select i.cid
        from solotpto sp, tystabsrv t, wf, tareawf tw, inssrv i, insprd ip
       where tw.idtareawf = a_idtareawf
         and wf.idwf = tw.idwf
         and sp.codsolot = wf.codsolot
         and i.codinssrv = sp.codinssrv
         and ip.codinssrv = i.codinssrv
         and ip.pid = sp.pid
         and i.tipinssrv = 1
         and ip.flgprinc = 1
         and t.codsrv = i.codsrv
         and t.idproducto = c_prod_bl;

    cursor cur_cid_otros is
      select i.cid
        from solotpto sp, tystabsrv t, wf, tareawf tw, inssrv i, insprd ip
       where tw.idtareawf = a_idtareawf
         and wf.idwf = tw.idwf
         and sp.codsolot = wf.codsolot
         and i.codinssrv = sp.codinssrv
         and ip.codinssrv = i.codinssrv
         and ip.pid = sp.pid
         and i.tipinssrv = 1
         and ip.flgprinc = 1
         and t.codsrv = i.codsrv
         and t.idproducto <> c_prod_bl;
  BEGIN
    Begin
      select i.numslc, wf.codsolot, c.nomcli, paq.observacion
        into ls_numslc, ln_codsolot, ls_nomcli, ls_paquete
        from tareawf t,
             wf,
             vtatabcli c,
             solotpto p,
             inssrv i,
             paquete_venta paq
       where t.idtareawf = a_idtareawf
         and wf.idwf = t.idwf
         and p.codsolot = wf.codsolot
         and i.codinssrv = p.codinssrv
         and c.codcli = i.codcli
         and paq.idpaq = i.idpaq
       group by i.numslc, wf.codsolot, c.nomcli, paq.observacion;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener la información del proyecto, cliente y paquete';
        raise exception_doc;
    End;

    Begin
      select to_number(valor)
        into c_prod_fax
        from constante
       where constante = 'TN_PROD_FAX';
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener constante de validación: Producto FAX.';
        raise exception_doc;
    End;

    Begin
      select to_number(valor)
        into c_prod_bl
        from constante
       where constante = 'TN_PROD_BL';
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener constante de validación: Producto Internet.';
        raise exception_doc;
    End;

    Begin
      select F_GET_TAREA_FICHA_TECNICA(ln_codsolot)
        into ln_idtareawf
        from dummy_ope;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener Tarea de Activación Breezemax en este flujo.';
        raise exception_doc;
    End;

    If ln_idtareawf is null then
      a_resultado := 'ERROR';
      a_mensaje   := 'El identificador de la Tarea de Activación Breezemax en este flujo es nulo.';
      raise exception_doc;
    End If;

    Begin
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'BTS')
        into a_eb
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'SECTOR')
        into a_sector
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'MAC_ADDRESS')
        into a_macaddress
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'COORDENADA_CTE')
        into a_coordenadas
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'IDE')
        into a_ide
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'IP - TELEPHONE')
        into a_ip_tel
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf,
                                             'MASK/DG IP_TELEPHONE')
        into a_mask_tel
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'IP - INTERNET')
        into a_ip_bl
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf,
                                             'MASK/DG IP_INTERNET')
        into a_mask_bl
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'IP_LAN')
        into a_ip_lan
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'MASK/DG IP_LAN')
        into a_mask_lan
        from dummy_ope;
      select PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf, 'FQDN')
        into a_fqdn
        from dummy_ope;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener valores para la documentación del Aprovisionamiento.';
        raise exception_doc;
    End;

    ls_anotacion := 'PY ' || ls_numslc || ' ' || substr(ls_nomcli, 1, 36) ||
                    Chr(13);
    ls_anotacion := ls_anotacion || ls_paquete || Chr(13);
    ls_anotacion := ls_anotacion || 'MAC: ' || a_macaddress || Chr(13);
    ls_anotacion := ls_anotacion || 'COORD: ' || a_coordenadas || Chr(13);
    ls_anotacion := ls_anotacion || 'EB_Sec: ' || a_eb || ' - ' || a_sector ||
                    Chr(13);
    ls_anotacion := ls_anotacion || 'IDE: ' || a_ide || Chr(13);

    For c2 in cur_cid_bl Loop
      ls_anotacion := ls_anotacion || 'INTERNET' || Chr(13);
      ls_anotacion := ls_anotacion || 'CID: ' || to_char(c2.cid) || Chr(13);
      ls_anotacion := ls_anotacion || 'IP WAN: ' || a_ip_bl || ' MASK/DG: ' ||
                      a_mask_bl || Chr(13);
      If a_ip_lan <> '0' then
        ls_anotacion := ls_anotacion || 'IP LAN: ' || a_ip_lan ||
                        ' MASK/DG: ' || a_mask_lan || Chr(13);
      End If;
    End Loop;

    ln_aux := 1;
    For c1 in cur_cid_telefonia Loop
      If ln_aux = 1 Then
        ls_anotacion := ls_anotacion || 'TELEFONIA' || Chr(13);
        ls_anotacion := ls_anotacion || 'CID: ' || to_char(c1.cid) ||
                        Chr(13);
        ls_anotacion := ls_anotacion || 'IP IAD: ' || a_ip_tel ||
                        ' MASK/DG: ' || a_mask_tel || Chr(13);
        ls_cids      := 'CID: ' || to_char(c1.cid) || '   ' ||
                        to_char(c1.numero) || Chr(13);
        ln_aux       := ln_aux + 1;
      End If;
      ls_cids := ls_cids || 'CID: ' || to_char(c1.cid) || '   ' ||
                 to_char(c1.numero) || Chr(13);
    End Loop;

    If ls_cids is not null Then
      ls_anotacion := ls_anotacion || 'PRECONFIGURADO' || Chr(13);
      ls_anotacion := ls_anotacion || ls_cids;
    End If;

    ls_anotacion := ls_anotacion || a_fqdn || Chr(13);

    For c3 in cur_cid_otros Loop
      ls_aux2 := null;
      Begin
        select f.etiqueta || ' : ' || f.valortxt
          into ls_aux2
          from ft_instdocumento f, ft_instdocumento f1
         where (f.etiqueta like 'CID -%')
           and f.idcomponente = f1.idcomponente
           and f.idficha = f1.idficha
           and f1.etiqueta like 'CID%'
           and f1.valortxt = to_char(c3.cid);
      Exception
        when others then
          ls_aux2 := null;
      End;

      If ls_aux2 is not null Then
        ls_anotacion := ls_anotacion || ls_aux2 || Chr(13);
        ls_aux2      := null;
        Begin
          select f.etiqueta || ' : ' || f.valortxt
            into ls_aux2
            from ft_instdocumento f, ft_instdocumento f1
           where (f.etiqueta like 'IP -%')
             and f.idcomponente = f1.idcomponente
             and f.idficha = f1.idficha
             and f1.etiqueta like 'CID%'
             and f1.valortxt = to_char(c3.cid);
        Exception
          when others then
            ls_aux2 := null;
        End;

        If ls_aux2 is not null and length(ls_aux2) > 1 Then
          ls_anotacion := ls_anotacion || ls_aux2;
          ls_aux2      := null;
          Begin
            select f.valortxt
              into ls_aux2
              from ft_instdocumento f, ft_instdocumento f1
             where (f.etiqueta like 'MASK/DG%')
               and f.idcomponente = f1.idcomponente
               and f.idficha = f1.idficha
               and f1.etiqueta like 'CID%'
               and f1.valortxt = to_char(c3.cid);
          Exception
            when others then
              ls_aux2 := null;
          End;
          If ls_aux2 is not null then
            ls_anotacion := ls_anotacion || ' ' || ls_aux2 || Chr(13);
          End If;
        End if;

      End if;
    End Loop;

    Begin
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, ls_anotacion, 1);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al registrar la Documentación de Aprovisionamiento. IdTarea: ' ||
                       to_char(a_idtareawf);
        raise exception_doc;
    End;

    Begin
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (ln_idtareawf, ls_anotacion, 1);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al registrar la Documentación de Aprovisionamiento. IdTarea: ' ||
                       to_char(a_idtareawf);
        raise exception_doc;
    End;

  EXCEPTION
    when exception_doc Then
      return;
  END;

  PROCEDURE P_ACT_DOC_PROV2(a_idtareawf in number,
                            a_resultado in out varchar2,
                            a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    ls_numslc    solot.numslc%type;
    ln_codsolot  solot.codsolot%type;
    ls_nomcli    vtatabcli.nomcli%type;
    ls_dirsuc    vtasuccli.dirsuc%type;
    ls_paquete   paquete_venta.observacion%type;
    ls_anotacion tareawfseg.observacion%type;
    exception_doc exception;
  BEGIN
    Begin
      select i.numslc, wf.codsolot, c.nomcli, paq.observacion, s.dirsuc
        into ls_numslc, ln_codsolot, ls_nomcli, ls_paquete, ls_dirsuc
        from tareawf t,
             wf,
             vtatabcli c,
             solotpto p,
             inssrv i,
             paquete_venta paq,
             vtasuccli s
       where t.idtareawf = a_idtareawf
         and wf.idwf = t.idwf
         and p.codsolot = wf.codsolot
         and i.codinssrv = p.codinssrv
         and c.codcli = i.codcli
         and paq.idpaq = i.idpaq
         and i.codsuc = s.codsuc
       group by i.numslc, wf.codsolot, c.nomcli, paq.observacion, s.dirsuc;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al obtener la información del proyecto, cliente y paquete';
        raise exception_doc;
    End;

    ls_anotacion := 'PY ' || ls_numslc || ' ' || substr(ls_nomcli, 1, 36) ||
                    Chr(13);
    ls_anotacion := ls_anotacion || ls_paquete || Chr(13);
    ls_anotacion := ls_anotacion || ls_dirsuc || Chr(13);

    Begin
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, ls_anotacion, 1);
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Error al registrar la Documentación de Aprovisionamiento.';
        raise exception_doc;
    End;

  EXCEPTION
    when exception_doc Then
      return;
  END;

  PROCEDURE P_ACT_FQDN(a_codigo1   in number,
                       a_resultado in out varchar2,
                       a_mensaje   in out varchar2) IS
    --10.0 se rehace procedimiento
    a_codsolot       solot.codsolot%type;
    a_numslc         vtatabslcfac.numslc%type;
    a_codsuc         vtasuccli.codsuc%type;
    a_abrint         vtatabpvc.abrint%type;
    a_tec            opedd.codigoc%type;
    a_cant           int;
    ln_val_protocolo number;
    ln_tot           number;
    a_fqdn           varchar2(100);
    p_tiptec         tipequ.tiptec%type;
    p_codprot        tipequ.idprotocolo%type;
    ls_abrevprot     protocolo.abrev%type;
    exceptionfqdn exception;
  BEGIN
    Begin
      select wf.codsolot, s.numslc
        into a_codsolot, a_numslc
        from tareawfcpy t, wf, solot s
       where t.idtareawf = a_codigo1
         and t.idwf = wf.idwf
         and s.codsolot = wf.codsolot;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Generación de parámetro FQDN: Error al obtener la Solot.';
        raise exceptionfqdn;
    End;

    select F_GET_CANT_LINEAS_2(a_codsolot) into ln_tot from dummy_ope;

    If ln_tot = -1 then
      a_mensaje   := 'Validación del parámetro FQDN: Error al validar la cantidad de líneas telefónicas.';
      a_resultado := 'ERROR';
      raise exceptionfqdn;
    End If;

    If ln_tot = 0 then
      a_fqdn := '';
    Else

      /* 1.- Ciudad*/
      select i.codsuc
        into a_codsuc
        from solotpto p, inssrv i
       where p.codsolot = a_codsolot
         and i.codinssrv = p.codinssrv
       group by i.codsuc;

      select p.abrint
        into a_abrint
        from vtasuccli s, v_ubicaciones u, vtatabpvc p
       where s.codsuc = a_codsuc
         and u.codubi = s.ubisuc
         and trim(p.codpai) = trim(u.codpai)
         and trim(p.codest) = trim(u.codest)
         and trim(p.codpvc) = trim(u.codpvc);

      If a_abrint is null Then
        a_resultado := 'ERROR';
        a_mensaje   := 'Generación de parámetro FQDN: Error al obtener la ciudad.';
        raise exceptionfqdn;
      End If;

      /* 2.- Tecnología */
      Begin
        select te.tiptec, te.idprotocolo, to_char(nvl(te.numport, 0))
          into p_tiptec, p_codprot, a_cant
          from inssrv i, insprd pr, equcomxope ec, tipequ te, solotpto p
         where i.numslc = a_numslc
           and p.codsolot = a_codsolot
           and i.codinssrv = p.codinssrv
           and pr.codinssrv = i.codinssrv
           and ec.codequcom = pr.codequcom
           and te.tipequ = ec.tipequ
           and te.idprotocolo is not null
         group by te.tiptec, te.idprotocolo, to_char(nvl(te.numport, 0));
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Generación de parámetro FQDN: Error al obtener la Tecnología y/o Protocolo.';
          raise exceptionfqdn;
      End;

      Begin
        select upper(codigoc)
          into a_tec
          from opedd
         where codigon = p_tiptec
           and tipopedd =
               (select tipopedd
                  from tipopedd
                 where descripcion = 'INT-Tecnología');
      Exception
        when others then
          a_resultado := 'ERROR';
          a_mensaje   := 'Generación de parámetro FQDN: Error al obtener la Tecnología.';
          raise exceptionfqdn;
      End;

      /* 3.- Protocolo */
      select count(*)
        into ln_val_protocolo
        from protocolo
       where idprotocolo = p_codprot;

      If ln_val_protocolo = 0 then
        a_resultado := 'ERROR';
        a_mensaje   := 'Generación de parámetro FQDN: Error al obtener el Protocolo.';
        raise exceptionfqdn;
      else
        select p.abrev
          into ls_abrevprot
          from protocolo p
         where p.idprotocolo = p_codprot;
      End If;

      /* 4.- Cantidad de Puertos a Configurar */
      --a_cant := F_GET_CANT_LINEAS(a_codsolot);

      /* 5.- Armar el FQDN */
      If a_cant = 0 then
        a_fqdn := '0';
      Else
        a_fqdn := trim(a_abrint) || trim(a_tec) ||
                  substr(lpad(to_char(a_cant), 2, '0'), 1, 2) ||
                  ls_abrevprot || to_char(a_codsolot);
      End If;
    End If;
    -- Actualizar en la Ficha Tecnica
    begin
      PQ_FICHATECNICA.P_UPD_FT_ETIQUETA(a_codigo1, 'FQDN', a_fqdn);
    exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Ficha Técnica: Error en la actualización de parámetro FQDN. ' ||
                       sqlerrm;
        a_mensaje   := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');
        raise exceptionfqdn;
    End;
  EXCEPTION
    when exceptionfqdn then
      return;
    when others then
      a_resultado := 'ERROR';
      a_mensaje   := 'Actualización de FQDN: ' || sqlerrm;
      return;
  END;

  PROCEDURE P_SINC_TAREA_WEB(a_idtareawf in number) is
    --10.0 se rehace procedimiento
    --ln_tareadef     tareawf.tareadef%type;
    ln_codsolot    solot.codsolot%type;
    ln_flg_web     tareadef.flg_web%type;
    ls_tipsrv      solot.tipsrv%type;
    a_cant_tel     number;
    a_cant_bl      number;
    a_mensaje      varchar2(4000);
    --lr_siscortarea portal.siscortarea@PEWEBPRD.WORLD%rowtype;--compilar
  BEGIN
    -- Capturo datos de la solot
    select s.codsolot, s.tipsrv, flg_web
      into ln_codsolot, ls_tipsrv, ln_flg_web
      from wf, solot s, tareawf t, tareadef td
     where t.idtareawf = a_idtareawf
       and wf.idwf = t.idwf
       and t.tareadef = td.tareadef
       and s.codsolot = wf.codsolot;

    a_cant_tel := F_GET_CANT_LINEAS(ln_codsolot);
    a_cant_bl  := F_GET_CANT_BANDALARGA(ln_codsolot);

    If ls_tipsrv in ('0058', '0059') and
       (a_cant_tel <> 0 or a_cant_bl <> 0) and ln_flg_web = 1 Then
      --If ln_tareadef = c_atvtar_breeze then
      --PQ_SINCRONIZA_CDMA.P_SINCRONIZA_TAREA(a_idtareawf, 0, lr_siscortarea);--compilar
      null;--compilar
      --End If;
    End If;
  EXCEPTION
    when others then
      rollback;
      a_mensaje := 'Error en la sincronización Web. Tarea:' || a_idtareawf ||
                   Chr(13) || 'Mensaje: ' || Sqlerrm;

      a_mensaje := F_UTIL_LIMPIAR_MSG(a_mensaje, 'ORA-[0-9]*: ');

      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);
      commit;

      raise;
  END;

  FUNCTION F_GET_DOC_SOLICITUD(a_codsolot in number) return varchar2 is
    --10.0 Nueva función
    ls_numslc    solot.numslc%type;
    ls_tiptra    tiptrabajo.descripcion%type;
    ls_nomcli    vtatabcli.nomcli%type;
    ls_dirsuc    vtasuccli.dirsuc%type;
    ls_paquete   paquete_venta.observacion%type;
    ls_anotacion varchar2(4000);
    exception_doc exception;
  BEGIN
    Begin
      select i.numslc, c.nomcli, paq.observacion, s.dirsuc, tra.descripcion
        into ls_numslc, ls_nomcli, ls_paquete, ls_dirsuc, ls_tiptra
        from solot         so,
             tiptrabajo    tra,
             vtatabcli     c,
             solotpto      p,
             inssrv        i,
             paquete_venta paq,
             vtasuccli     s
       where so.codsolot = a_codsolot
         and tra.tiptra = so.tiptra
         and p.codsolot = so.codsolot
         and i.codinssrv = p.codinssrv
         and c.codcli = i.codcli
         and paq.idpaq = i.idpaq
         and i.codsuc = s.codsuc
       group by i.numslc,
                c.nomcli,
                paq.observacion,
                s.dirsuc,
                tra.descripcion;
    Exception
      when others then
        ls_anotacion := 'Error al obtener la información del proyecto, cliente y paquete';
        return ls_anotacion;
    End;

    ls_anotacion := 'Proyecto: ' || ls_numslc || Chr(13);
    ls_anotacion := ls_anotacion || 'Tipo Trabajo Solic: ' || ls_tiptra || ' ' ||
                    Chr(13);
    ls_anotacion := ls_anotacion || 'Paquete Contratado: ' || ls_paquete ||
                    Chr(13);
    ls_anotacion := ls_anotacion || 'Sucursal: ' || ls_dirsuc || Chr(13);

    return ls_anotacion;
  END;

  FUNCTION F_GET_ERROR_PLATAFORMA(a_idtareawf in number) return varchar2 is
    --10.0 Nueva función
    a_mensaje   varchar2(4000);
    ln_aux      number;
    ln_codsolot solot.codsolot%type;
    ls_tipsrv   solot.tipsrv%type;
    a_cant_tel  number;
    a_cant_bl   number;
    cursor cur_errores is
      select ic.idlote,
             i.idtareawf,
             ic.plataforma,
             ic.orden,
             ic.tipocomando,
             ic.operacion,
             ic.fase,
             iic.estado,
             iic.mensaje,
             iic.resultado,
             iic.idinscom
        from int_instancia_comando        ic,
             int_instruccion_inst_comando iic,
             int_servicio_plataforma      i
       where ic.estado = 'ERROR'
         and iic.estado = 'ERROR'
         and ic.idinscom = iic.idinscom
         and ic.idlote = i.idlote
         and i.idtareawf = a_idtareawf --4299218
       order by ic.idlote, ic.orden;
  BEGIN
    ln_aux    := 0;
    a_mensaje := '';

    -- Capturo datos de la solot
    select s.codsolot, s.tipsrv
      into ln_codsolot, ls_tipsrv
      from wf, solot s, tareawf t
     where t.idtareawf = a_idtareawf
       and wf.idwf = t.idwf
       and s.codsolot = wf.codsolot;

    a_cant_tel := F_GET_CANT_LINEAS(ln_codsolot);
    a_cant_bl  := F_GET_CANT_BANDALARGA(ln_codsolot);

    If ls_tipsrv in ('0058', '0059') and
       (a_cant_tel <> 0 or a_cant_bl <> 0) Then
      For c1 in cur_errores loop
        If ln_aux = 0 then
          a_mensaje := 'IDLOTE: ' || to_char(c1.idlote) || Chr(13);
          a_mensaje := a_mensaje || 'PLATAFORMA: ' || trim(c1.plataforma) ||
                       Chr(13);
          a_mensaje := a_mensaje || 'OPERACION: ' || trim(c1.operacion) ||
                       Chr(13);
          a_mensaje := a_mensaje || 'FASE: ' || trim(c1.fase) || Chr(13);
          a_mensaje := a_mensaje || 'ESTADO: ' || trim(c1.estado) ||
                       Chr(13);
          a_mensaje := a_mensaje || 'MENSAJE: ' || trim(c1.mensaje) ||
                       Chr(13);
          a_mensaje := a_mensaje || 'RESULTADO: ' || trim(c1.resultado);

          a_mensaje := substr(trim(a_mensaje), 1, 4000);
          ln_aux    := ln_aux + 1;
        End If;
      End loop;
    End If;

    return a_mensaje;
  END;

  FUNCTION F_UTIL_LIMPIAR_MSG(p_original  varchar2,
                              p_buscar    varchar2,
                              p_reemplaza varchar2 default null)
    return varchar2 as
  BEGIN
    return REGEXP_REPLACE(p_original, p_buscar, p_reemplaza);
  END;

  FUNCTION F_VAL_CODPVC(a_codsolot in number, a_codubi in varchar2)
    return number is
    ls_codubi vtasuccli.ubisuc%type;
    ls_codsuc vtasuccli.codsuc%type;

  BEGIN

    begin
      select i.codsuc
        into ls_codsuc
        from inssrv i, solotpto p
       where p.codsolot = a_codsolot
         and i.codinssrv = p.codinssrv
       group by i.codsuc;
    Exception
      when others then
        return 0;
    End;

    Begin
      select ubisuc into ls_codubi from vtasuccli where codsuc = ls_codsuc;
    Exception
      when others then
        return 0;
    End;

    If trim(ls_codubi) = trim(a_codubi) Then
      return 1;
    Else
      return 0;
    End If;
  END;

  FUNCTION F_VAL_PUERTOS(a_eb in number, a_sector in number) return number is
    ln_aux number;
  BEGIN
    -- 10.0 Nueva función
    select count(tarjetaxequipo.codtarjeta)
      into ln_aux
      FROM puertoxequipo,
           equipored,
           tarjetaxequipo,
           productocorp,
           tipequipored,
           ubired,
           ambientered,
           rackred,
           (select codigon, descripcion from opedd where tipopedd = 151) v_provenl,
           (select codigon, descripcion from opedd where tipopedd = 22) estado,
           (select codigon, descripcion from opedd where tipopedd = 169) v_mediotx,
           CIDXIDE,
           ACCESO,
           (select distinct (codinssrv) codinssrv, numslc
              from vtadetptoenl
             where codinssrv is not null) detproy,
           vtatabslcfac
     where (equipored.codequipo(+) = puertoxequipo.codequipo)
       and (tarjetaxequipo.codtarjeta(+) = puertoxequipo.codtarjeta)
       and (productocorp.codprd(+) = puertoxequipo.codprd)
       and (puertoxequipo.estado = estado.codigon)
       and equipored.tipo = tipequipored.codtipo(+)
       and equipored.codubired = ubired.codubired(+)
       and equipored.codambiente = ambientered.codambiente(+)
       and equipored.codrack = rackred.codrack(+)
       and PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+)
       and PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+)
       and CIDXIDE.CID(+) = PUERTOXEQUIPO.CID
       and CIDXIDE.IDE(+) = PUERTOXEQUIPO.IDE
       and puertoxequipo.cid = acceso.cid(+)
       and acceso.codinssrv = detproy.codinssrv(+)
       and detproy.numslc = vtatabslcfac.numslc(+)
       and equipored.tipo = 114
       and equipored.codequipo = tarjetaxequipo.codequipo
       and tarjetaxequipo.codtiptarj = 305
       and tarjetaxequipo.slot in ('01', '02', '03', '04', '07', '08')
       and ((puertoxequipo.puerto = '01:') or
           (length(puertoxequipo.puerto) = 5 and
           puertoxequipo.puerto like '01:%'))
       and puertoxequipo.ide is null
       and estado.codigon = 0
       and equipored.codequipo = a_eb --4932
       and tarjetaxequipo.codtarjeta = a_sector --86653
     group by tarjetaxequipo.codtarjeta;

    return ln_aux;

  END;

  FUNCTION F_VAL_MACADDRESS(a_idtareawf tareawf.idtareawf%type,
                            a_mac       varchar2) return varchar2 is
    ls_res varchar2(100);
    ln_aux number;
    ls_aux varchar2(1);
  BEGIN
    --10.0 Nueva función
    -- correcto = 0
    If instr(a_mac, '_') > 0 then
      ls_res := 'Se ha encontrado dígito incorrecto en la MacAddress: ' ||
                a_mac;
      return ls_res;
    End IF;
    -- correcto = 12
    If length(trim(replace(a_mac, '-'))) <> 12 then
      ls_res := 'MacAddress incorrecto, no está completo: ' || a_mac;
      return ls_res;
    End IF;

    For i in 1 .. 12 loop
      ls_aux := upper(substr(replace(a_mac, '-'), i, 1));
      if instr('1234567890ABCDEF', ls_aux) = 0 then
        ls_res := 'Se ha encontrado un digito incorrecto en la MacAddress: ' ||
                  a_mac;
        return ls_res;
        exit;
      End If;
    end Loop;

    select count(*)
      into ln_aux
      from puertoxequipo p
     where length(p.puerto) > 5
       and upper(p.puerto) like '%' || upper(a_mac) || '%'
       and p.estado in (1, 2);

    If ln_aux > 0 then
      ls_res := 'Se ha encontrado un Puerto con el MacAddress: ' || a_mac;
      return ls_res;
    End IF;

    select count(*)
      into ln_aux
      from ft_instdocumento f, tareawf t
     where f.etiqueta like 'MAC_ADD%'
       and f.codigo1 = t.idtareawf
       and t.idtareawf <> a_idtareawf
       and t.esttarea = 1
       and f.valortxt is not null --00-11-25-f5-26-13
       and upper(f.valortxt) like '%' || upper(a_mac) || '%';

    If ln_aux > 0 then
      ls_res := 'Se ha encontrado una tarea pendiente de reserva con el MacAddress: ' ||
                a_mac;
      return ls_res;
    End IF;

    return 'OK';

  END;

  FUNCTION F_VAL_SOLOT(a_codsolot in number, a_numslc in varchar2)
    return varchar2 is
    ls_res varchar2(200);
    ln_aux number;
  BEGIN
    --10.0 Nueva función
    ln_aux := null;

    select count(*)
      into ln_aux
      from (select distinct i.codinssrv
              from inssrv i, insprd pr
             where i.numslc = a_numslc
               and pr.flgprinc = 1
               and i.codinssrv = pr.codinssrv
               and i.codinssrv not in
                   (select i1.codinssrv
                      from solotpto p1, inssrv i1, insprd pr1
                     where p1.codsolot = a_codsolot
                       and i1.codinssrv = p1.codinssrv
                       and pr1.flgprinc = 1
                       and pr1.codinssrv = p1.codinssrv
                       and i1.codinssrv = i.codinssrv));

    If ln_aux = 0 then
      ls_res := 'OK';
    else
      ls_res := 'Los servicios de la solicitud no coinciden con los servicios instalados.';
    End If;

    return ls_res;
  END;

  FUNCTION F_VAL_PARAMHIBRIDO(a_codsolot in number, a_numslc in varchar2)
    return number is
    ls_res  varchar2(200);
    ln_aux  number;
    ln_aux1 number;
  BEGIN
    ls_res := 0;

    ln_aux := pq_cuspe_plataforma.F_GET_CANT_LINEAS_2(a_codsolot);

    If ln_aux > 0 then
      -- Valida Lineas Telefonicas
      ls_res := 0;
    else
      ln_aux1 := PQ_CUSPE_PLATAFORMA.F_GET_VALOR_TXT_INS(a_numslc,
                                                         'FLAG_EQUIPO_WEB');
      If ln_aux1 = 1 Then
        ls_res := 1; -- Aplica Modo Hibrido a los Parámetros
      Else
        ls_res := 0;
      End If;
    End If;
    return ls_res;
  Exception
    When Others Then
      return ls_res;
  END;

  FUNCTION F_GET_CODZONA(a_codsolot in number) return number is
    c_codzona number;
    ln_aux    number;
  BEGIN
    --10.0 Nueva Función
    select count(*)
      into ln_aux
      from (select codinssrv
              from solotpto
             where codsolot = a_codsolot
             group by codinssrv) p,
           inssrv i,
           insprd pr,
           tystabsrv t,
           producto c,
           zonatelxserv_auto z,
           zonatel_auto y
     where i.codinssrv = p.codinssrv
       and pr.codinssrv = i.codinssrv
       and t.codsrv = pr.codsrv
       and c.idproducto = t.idproducto
       and pr.flgprinc <> 1
       and z.codsrv = pr.codsrv
       and y.codzona = z.codzona;

    if ln_aux = 1 then
      select y.codzona
        into c_codzona
        from (select codinssrv
                from solotpto
               where codsolot = a_codsolot
               group by codinssrv) p,
             inssrv i,
             insprd pr,
             tystabsrv t,
             producto c,
             zonatelxserv_auto z,
             zonatel_auto y
       where i.codinssrv = p.codinssrv
         and pr.codinssrv = i.codinssrv
         and t.codsrv = pr.codsrv
         and c.idproducto = t.idproducto
         and pr.flgprinc <> 1
         and z.codsrv = pr.codsrv
         and y.codzona = z.codzona;
    else
      c_codzona := 0;
    end if;

    return c_codzona;
  END;

  FUNCTION F_GET_CANT_LINEAS(a_codsolot in number) return number is
    c_prod_fax number;
    a_cant_tel number;
  BEGIN
    a_cant_tel := 0;

    select to_number(valor)
      into c_prod_fax
      from constante
     where constante = 'TN_PROD_FAX';

    select count(distinct i.codinssrv)
      into a_cant_tel
      from solotpto p, tystabsrv t, inssrv i
     where p.codsolot = a_codsolot
       and p.codinssrv = i.codinssrv
       and i.tipinssrv = 3
       and i.codsrv = t.codsrv
    /*and i.codsrv not in
                                   (select codsrv from tystabsrv where idproducto = c_prod_fax)*/
    ;

    return a_cant_tel;

  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_CANT_LINEAS_2(a_codsolot in number) return number is
    c_prod_fax number;
    a_cant_tel number;
  BEGIN
    --10.0 Nueva función
    a_cant_tel := 0;

    select to_number(valor)
      into c_prod_fax
      from constante
     where constante = 'TN_PROD_FAX';

    select count(distinct i.codinssrv)
      into a_cant_tel
      from solotpto p, tystabsrv t, inssrv i
     where p.codsolot = a_codsolot
       and p.codinssrv = i.codinssrv
       and i.tipinssrv = 3
       and i.codsrv = t.codsrv
       and i.codsrv not in
           (select codsrv from tystabsrv where idproducto = c_prod_fax);

    return a_cant_tel;

  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_CANT_BANDALARGA(a_codsolot in number) return number is
    a_cant_bl number;
  BEGIN
    --10.0 Modificación de toda la función
    a_cant_bl := 0;

    select count(distinct i.codinssrv)
      into a_cant_bl
      from solotpto sp, tystabsrv t, inssrv i, insprd ip, producto c
     where sp.codsolot = a_codsolot
       and i.codinssrv = sp.codinssrv
       and ip.codinssrv = i.codinssrv
       and t.codsrv = i.codsrv
       and c.idproducto = t.idproducto
       and i.tipinssrv = 1
       and ip.flgprinc = 1
       and c.tipsrv = '0006';
    /*and i.codinssrv = sp.codinssrv
    and ip.codinssrv = i.codinssrv
    --and ip.pid = sp.pid
    and i.tipinssrv = 1
    and ip.flgprinc = 1
    and t.codsrv = i.codsrv
    and t.idproducto = c_prod_bl;*/

    return a_cant_bl;

  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_CANT_CONTROL(a_codsolot in number) RETURN number IS
    a_cant_control number;
  BEGIN
    --10.0 Modificación de la función
    select count(*)
      into a_cant_control
      from solotpto a, insprd b, tystabsrv c, inssrv e, plan_redint h
     where a.codsolot = a_codsolot
       and e.codinssrv = a.codinssrv
       and e.tipinssrv = 3
       and b.codinssrv = e.codinssrv
       and c.codsrv = b.codsrv
       and h.idtipo in (2, 3) --control,prepago
       and h.idplan = c.idplan
       and a.pid = b.pid--21.0
       AND h.idplataforma = 3; --28.0 Plataforma Tellin

    IF a_cant_control > 0 Then
      a_cant_control := 1;
    End If;

    return a_cant_control;

  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_CANT_GRUPOIP(a_codsolot in number, a_idgrupo in number)
    RETURN number IS
    a_cant_grupoip number;
  BEGIN
    --10.0 Nueva función
    select count(*)
      into a_cant_grupoip
      from (select gs.idgrupo, gs.cant_ip, gs.flg_lan
              from solotpto          sp,
                   insprd            ip,
                   inssrv            i,
                   tystabsrv         b,
                   producto          c,
                   grupoipxserv_auto gs,
                   grupoip_servicio  g
             where sp.codsolot = a_codsolot
               and g.idgrupo = a_idgrupo
               and i.codinssrv = sp.codinssrv
               and ip.codinssrv = i.codinssrv
               and ip.pid = sp.pid
               and b.codsrv = ip.codsrv
               and c.idproducto = b.idproducto
               and nvl(c.idtipinstserv, 0) <> 3
               and gs.codsrv = b.codsrv
               and g.idgrupo = gs.idgrupo
             group by gs.idgrupo, gs.cant_ip, gs.flg_lan);

    return a_cant_grupoip;

  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_CANT_CENTREX(a_codsolot in number) RETURN number IS
    a_cant_centrex number;
    a_codzona      number;
  BEGIN
    --10.0 Nueva función
    a_codzona := F_GET_CODZONA(a_codsolot);

    If a_codzona > 0 then
      Select nvl(za.idcustgroup, 0)
        into a_cant_centrex
        from zonatel_auto za
       where za.codzona = a_codzona;
    Else
      Begin
        select nvl(za.idcustgroup, 0)
          into a_cant_centrex
          from inssrv i,
               insprd pr,
               (select codinssrv
                  from solotpto
                 where codsolot = a_codsolot
                 group by codinssrv) p,
               tystabsrv t,
               producto c,
               zonatelxserv_auto z,
               zonatel_auto za
         where i.codinssrv = p.codinssrv
           and pr.codinssrv = i.codinssrv
           and t.codsrv = pr.codsrv
           and c.idproducto = t.idproducto
           and c.idtipinstserv = 3
           and pr.flgprinc = 1
           and z.codsrv = pr.codsrv
           and za.codzona = z.codzona
           and za.idcustgroup is not null
         group by za.idcustgroup;
      Exception
        when others then
          a_cant_centrex := 0;
      End;
    End if;

    return a_cant_centrex;
  EXCEPTION
    when others then
      return - 1;
  END;

  FUNCTION F_GET_SUSCRIBER_PROY(a_numslc in varchar2) RETURN varchar2 IS
    a_suscriber varchar2(200);
  BEGIN
    --10.0 Nueva función
    Begin
      select g.susname
        into a_suscriber
        from inssrv i, paquete_venta p, grupoip_servicio g
       where i.numslc = a_numslc
         and p.idpaq = i.idpaq
         and g.idgrupo = p.idgrupo
       group by g.susname;
    Exception
      when others then
        a_suscriber := '-1';
    End;

    return a_suscriber;
  END;

  FUNCTION F_GET_SUSCRIBER(a_codsolot in number) RETURN varchar2 IS
    a_suscriber varchar2(200);
  BEGIN
    --10.0 Nueva función
    Begin
      select g.susname
        into a_suscriber
        from inssrv i, paquete_venta p, grupoip_servicio g, solotpto p
       where p.codsolot = a_codsolot
         and i.codinssrv = p.codinssrv
         and p.idpaq = i.idpaq
         and g.idgrupo = p.idgrupo
       group by g.susname;
    Exception
      when others then
        a_suscriber := '-1';
    End;

    return a_suscriber;
  END;

  FUNCTION F_GET_IDDEFOPE(a_idtareawf in number) RETURN number IS
    ls_query    varchar2(4000);
    ls_res      varchar2(30);
    ln_existe   number;
    ln_iddefope number;
  BEGIN
    --10.0 Nueva función
    ln_existe   := -1;
    ln_iddefope := null;

    select sql_val
      into ls_query
      from tareadef d, tareawf t
     where t.idtareawf = a_idtareawf
       and d.tareadef = t.tareadef;

    If ls_query is null then
      return ln_existe;
    End If;

    ls_query := replace(ls_query, 'a_idtareawf', to_char(a_idtareawf));

    If ls_query is not null then
      execute immediate ls_query
        into ls_res;

      ls_res := trim(ls_res);

      If ls_res is null then
        return ln_existe;
      End if;

      select o.iddefope
        into ln_iddefope
        from int_operacion_tareadef     o,
             tareawf                    t,
             int_operacion_tareadef_opc opc
       where t.idtareawf = a_idtareawf
         and o.tareadef = t.tareadef
         and o.iddefope_anula is not null
         and opc.tareadef = o.tareadef
         and opc.iddefope = o.iddefope
         and opc.sql_res = ls_res;

      If ln_iddefope > 0 then
        ln_existe := ln_iddefope;
      else
        return ln_existe;
      End if;

    End if;

    return ln_existe;

  Exception
    when others then
      return - 1;
  END;

  FUNCTION F_GET_IDDEFOPE_PROY(a_idtareawf in number, a_numslc in varchar2)
    RETURN number IS
    ls_query    varchar2(4000);
    ls_res      varchar2(30);
    ln_existe   number;
    ln_iddefope number;
  BEGIN
    --10.0 Nueva función
    ln_existe   := -1;
    ln_iddefope := null;

    select sql_val
      into ls_query
      from tareadef d, tareawf t
     where t.idtareawf = a_idtareawf
       and d.tareadef = t.tareadef;

    If ls_query is null then
      return ln_existe;
    End If;

    ls_query := replace(ls_query, 'a_numslc', a_numslc);

    If ls_query is not null then
      execute immediate ls_query
        into ls_res;

      ls_res := trim(ls_res);

      If ls_res is null then
        return ln_existe;
      End if;

      select o.iddefope
        into ln_iddefope
        from int_operacion_tareadef     o,
             tareawf                    t,
             int_operacion_tareadef_opc opc
       where t.idtareawf = a_idtareawf
         and o.tareadef = t.tareadef
         and opc.tareadef = o.tareadef
         and opc.iddefope = o.iddefope
         and opc.sql_res = ls_res;

      If ln_iddefope > 0 then
        ln_existe := ln_iddefope;
      else
        return ln_existe;
      End if;

    End if;

    return ln_existe;

  Exception
    when others then
      return - 1;
  END;

  FUNCTION F_GET_TXT_PLATAFORMA(a_idtareawf number, a_etiqueta IN VARCHAR2)
    RETURN VARCHAR2 IS
    a_valor       varchar2(100);
    a_cant        number;
    a_numslc      vtatabslcfac.numslc%type;
    a_codsolot    solot.codsolot%type;
    a_codzona     number;
    p_eb          equipored.codequipo%type;
    r_protoc      protocolo%rowtype;
    r_opedd       opedd%rowtype;
    p_codest      vtatabest.codest%type;
    p_codubi      vtasuccli.ubisuc%type;
    vn_tipcentrex number;
    ln_opedd      number;
    --10.0 Modificación de toda la función
  BEGIN
    a_valor := null;

    Begin
      select wf.codsolot, s.numslc
        into a_codsolot, a_numslc
        from tareawfcpy t, wf, solot s
       where t.idtareawf = a_idtareawf
         and t.idwf = wf.idwf
         and s.codsolot = wf.codsolot;
    Exception
      when others then
        RAISE_APPLICATION_ERROR(-20500, 'Error al obtener la Solot.');
    End;

    Begin
      select prot.*
        into r_protoc
        from inssrv     i,
             insprd     pr,
             equcomxope ec,
             tipequ     te,
             solotpto   p,
             protocolo  prot
       where i.numslc = a_numslc
         and p.codsolot = a_codsolot
         and i.codinssrv = p.codinssrv
         and pr.codinssrv = i.codinssrv
         and ec.codequcom = pr.codequcom
         and te.tipequ = ec.tipequ
         and prot.idprotocolo = te.idprotocolo
         and te.idprotocolo is not null
         and rownum = 1;
    Exception
      when others then
        r_protoc := null;
    End;

    a_cant := F_GET_CANT_LINEAS_2(a_codsolot);

    Case
      when a_etiqueta = 'FQDN' Then
        select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, a_etiqueta)
          into a_valor
          from dummy_ope;
      when a_etiqueta = 'IDE' Then
        select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf, a_etiqueta)
          into a_valor
          from dummy_ope;
      when a_etiqueta = 'GW_PROFILE' and a_cant > 0 Then

        select *
          into r_opedd
          from opedd
         where tipopedd =
               (select tipopedd
                  from tipopedd
                 where descripcion like 'TN-GW_PROFILE')
           and a_cant between to_number(codigoc) and codigon;

        a_valor := r_opedd.descripcion;

      when a_etiqueta = 'GW_IP' Then
        If a_cant > 0 Then
          select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf,
                                                 'IP - TELEPHONE')
            into a_valor
            from dummy_ope;
        Else
          select PQ_FICHATECNICA.F_OBT_VALOR_TXT(a_idtareawf,
                                                 'IP - INTERNET')
            into a_valor
            from dummy_ope;
        End If;

      when a_etiqueta = 'GW_PROTOCOL_TYPE' Then
        a_valor := to_char(r_protoc.idprotocolo);

      when a_etiqueta = 'GW_PROTOCOL_VERSION' Then
        a_valor := to_char(r_protoc.version);

      when a_etiqueta = 'GW_PROTOCOL_PORT' Then
        a_valor := to_char(r_protoc.puerto);

      when a_etiqueta = 'GW_SITE_NAME' and a_cant > 0 Then

        select *
          into r_opedd
          from opedd
         where tipopedd =
               (select tipopedd
                  from tipopedd
                 where descripcion like 'INT-GW_SITE_NAME')
           and a_cant between to_number(codigoc) and codigon;

        a_valor := r_opedd.descripcion;

      when a_etiqueta = 'GW_GWC_NAME' Then
        Begin
          select descripcion
            into a_valor
            from opedd
           where tipopedd =
                 (select tipopedd
                    from tipopedd
                   where descripcion like 'TN-GW_GWC_NAME')
             and codigon = 1;
        Exception
          when others then
            a_valor := '';
        End;

      when a_etiqueta = 'GW_RESERVED_TERMINATION' Then
        a_valor := a_cant;

      when a_etiqueta = 'EB_PASWD' Then

        select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, 'BTS')
          into p_eb
          from dummy_ope;

        select e.paswd
          into a_valor
          from equipored e
         where e.codequipo = p_eb;

      when a_etiqueta = 'EB_IP' Then

        select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, 'BTS')
          into p_eb
          from dummy_ope;

        select e.ip into a_valor from equipored e where e.codequipo = p_eb;

      when a_etiqueta = 'EB_IP_POSVTA' Then
        select PQ_CUSPE_PLATAFORMA.F_GET_TXT_PLATAFORMA(PQ_CUSPE_PLATAFORMA.F_GET_TAREA_FICHA_TECNICA(PQ_CUSPE_PLATAFORMA.F_GET_SOT_INS_PROY(i.numslc)),
                                                        'EB_IP')
          into a_valor
          from int_servicio_plataforma a, solotpto p, inssrv i
         where a.idtareawf = a_idtareawf
           and p.codinssrv = i.codinssrv
           and p.codsolot = a.codsolot
         group by i.numslc;

      when a_etiqueta = 'CUST_GROUP' Then
        vn_tipcentrex := 0;

        a_codzona := F_GET_CODZONA(a_codsolot);

        If a_codzona > 0 then
          Select nvl(za.idcustgroup, 0)
            into vn_tipcentrex
            from zonatel_auto za
           where za.codzona = a_codzona;
        Else
          Begin
            select nvl(za.idcustgroup, 0)
              into vn_tipcentrex
              from inssrv i,
                   insprd pr,
                   (select codinssrv
                      from solotpto
                     where codsolot = a_codsolot
                     group by codinssrv) p,
                   tystabsrv t,
                   producto c,
                   zonatelxserv_auto z,
                   zonatel_auto za
             where i.codinssrv = p.codinssrv
               and pr.codinssrv = i.codinssrv
               and t.codsrv = pr.codsrv
               and c.idproducto = t.idproducto
               and c.idtipinstserv = 3
               and pr.flgprinc = 1
               and z.codsrv = pr.codsrv
               and za.codzona = z.codzona
               and za.idcustgroup is not null
             group by za.idcustgroup;
          Exception
            when others then
              vn_tipcentrex := 0;
          End;
        End if;

        /*select trim(valor)
          into c_srvcentrex
          from constante
         where constante = 'TN_SRVCENTREX';

        select count(1)
          into vn_tipcentrex
          from vtadetptoenl a, tystabsrv b
         where a.codsrv = b.codsrv
           and a.numslc = a_numslc
           and b.codsrv = c_srvcentrex;*/

        select s.ubisuc
          into p_codubi
          from inssrv i, solotpto p, vtasuccli s
         where p.codsolot = a_codsolot
           and i.codinssrv = p.codinssrv
           and s.codsuc = i.codsuc
         group by s.ubisuc;

        select trim(codest)
          into p_codest
          from v_ubicaciones
         where codubi = p_codubi;

        If vn_tipcentrex > 0 Then
          select descripcion
            into a_valor
            from opedd
           where tipopedd = vn_tipcentrex
             and codigoc = trim(p_codest);
        Else
          a_valor := '0';
        End If;

      when a_etiqueta = 'NCOS' Then
        select PQ_FICHATECNICA.F_OBT_VALOR_ID(a_idtareawf, a_etiqueta)
          into a_valor
          from dummy_ope;

      when a_etiqueta = 'CODSUP' Then
        vn_tipcentrex := F_GET_CANT_CENTREX(a_codsolot);

        select count(*)
          into ln_opedd
          from opedd
         where tipopedd =
               (select tipopedd
                  from tipopedd
                 where descripcion like 'TN-SERV_SUPLEMENTARIO')
           and codigoc =
               (select trim(tipsrv) from solot where codsolot = a_codsolot)
           and codigon = vn_tipcentrex;

        If ln_opedd = 1 then
          select descripcion
            into a_valor
            from opedd
           where tipopedd =
                 (select tipopedd
                    from tipopedd
                   where descripcion like 'TN-SERV_SUPLEMENTARIO')
             and codigoc =
                 (select trim(tipsrv) from solot where codsolot = a_codsolot)
             and codigon = vn_tipcentrex;
        Else
          a_valor := null;
        End If;

    End Case;

    return a_valor;
  END;

  FUNCTION F_GET_SOT_INS_SID(a_codinssrv IN NUMBER) RETURN NUMBER IS

    ln_numsotins number(3);
    ln_codsolot  solot.codsolot%type;

  BEGIN

    select (select count(distinct sot.codsolot)
              from solot sot, solotpto pto
             where numslc = inssrv.numslc
               and --sot.estsol = 12 and
                   sot.tipcon not in ('D', 'DE')
               and sot.tiptra in
                   (select tiptra
                      from tiptrabajo
                     where UPPER(descripcion) like '%INSTALACION%')
               and pto.codsolot = sot.codsolot
               and pto.codinssrv = inssrv.codinssrv) numsotinst
      into ln_numsotins
      from inssrv
     where codinssrv = a_codinssrv; --not in (10724,10040)

    If ln_numsotins = 1 Then
      select (select distinct sot.codsolot
                from solot sot, solotpto pto
               where numslc = inssrv.numslc
                 and
                    --sot.estsol = 12 and
                     sot.tipcon not in ('D', 'DE')
                 and sot.tiptra in
                     (select tiptra
                        from tiptrabajo
                       where UPPER(descripcion) like '%INSTALACION%')
                 and pto.codsolot = sot.codsolot
                 and pto.codinssrv = inssrv.codinssrv) numsotinst
        into ln_codsolot
        from inssrv
       where codinssrv = a_codinssrv;

      return ln_codsolot;
    Else
      return null;
    End If;

  END;

  FUNCTION F_GET_SOT_INS_PROY(a_numslc IN vtatabslcfac.numslc%type)
    RETURN NUMBER IS

    ln_numsotins number(3);
    ln_codsolot  solot.codsolot%type;

  BEGIN

    select count(distinct sot.codsolot)
      into ln_numsotins
      from solot sot
     where numslc = a_numslc
       and
          --sot.estsol = 12 and
           sot.tipcon not in ('D', 'DE')
       and sot.tiptra in
           (select tiptra
              from tiptrabajo
             where UPPER(descripcion) like '%INSTALACION%');

    If ln_numsotins = 1 Then
      select sot.codsolot
        into ln_codsolot
        from solot sot, solotpto pto
       where numslc = a_numslc
         and sot.codsolot = pto.codsolot
            --sot.estsol = 12 and
         and sot.tipcon not in ('D', 'DE')
         and sot.tiptra in
             (select tiptra
                from tiptrabajo
               where UPPER(descripcion) like '%INSTALACION%')
       group by sot.codsolot;

      return ln_codsolot;
    Else
      return null;
    End If;

  END;

  --obtiene la tarea configurada para ficha tecnica de una solot
  FUNCTION F_GET_TAREA_FICHA_TECNICA(a_codsolot IN NUMBER) RETURN NUMBER IS

    ln_idwf      wf.idwf%type;
    ln_wfdef     wf.wfdef%type;
    ln_tarea     tareawfdef.tarea%type;
    ln_idtareawf tareawf.idtareawf%type;

  BEGIN

    select idwf, wfdef
      into ln_idwf, ln_wfdef
      from wf
     where codsolot = a_codsolot
       and wf.valido = 1;

    select a.tarea
      into ln_tarea
      from tareawfdef a, tareadef b
     where a.tareadef = b.tareadef
       and a.wfdef = ln_wfdef
       and b.flg_ft = 1;

    select idtareawf
      into ln_idtareawf
      from tareawf
     where idwf = ln_idwf
       and tarea = ln_tarea;

    return ln_idtareawf;

  Exception
    when others then
      return null;
  END;

  FUNCTION F_GET_PORT(a_codnumtel IN NUMBER, a_codinssrv IN NUMBER)
    RETURN NUMBER IS

    ln_port   reservatel.codnumtel%type;
    ls_numslc vtatabslcfac.numslc%type;

  BEGIN
    select numslc into ls_numslc from inssrv where codinssrv = a_codinssrv;

    select orden
      into ln_port
      from reservatel
     where codnumtel = a_codnumtel
       and numslc = ls_numslc;

    return ln_port;

  Exception
    when others then
      return null;
  END;

  --obtiene valor de ficha tecnica asociada a la tarea de la solot de instalacion
  FUNCTION F_GET_PLATAFORMA_TXT_INS(a_numslc   vtatabslcfac.numslc%type,
                                    a_etiqueta IN VARCHAR2) RETURN VARCHAR IS

    ln_codsolot_ins solot.codsolot%type;
    ln_idtareawf    tareawf.idtareawf%type;
    ls_valor        varchar(100);

  BEGIN
    select F_GET_SOT_INS_PROY(a_numslc)
      into ln_codsolot_ins
      from dummy_ope;

    If ln_codsolot_ins is not null Then

      select F_GET_TAREA_FICHA_TECNICA(ln_codsolot_ins)
        into ln_idtareawf
        from dummy_ope;

      If ln_idtareawf is not null Then
        select trim(F_GET_TXT_PLATAFORMA(ln_idtareawf, a_etiqueta))
          into ls_valor
          from dummy_ope;

        return ls_valor;
      Else
        return null;
      End If;
    Else
      return null;
    End If;

  Exception
    when others then
      return null;
  END;

  --obtiene valor de ficha tecnica asociada a la tarea de la solot de instalacion
  FUNCTION F_GET_VALOR_TXT_INS(a_numslc   vtatabslcfac.numslc%type,
                               a_etiqueta IN VARCHAR2) RETURN VARCHAR IS

    ln_codsolot_ins solot.codsolot%type;
    ln_idtareawf    tareawf.idtareawf%type;
    ls_valor        varchar(100);

  BEGIN
    select F_GET_SOT_INS_PROY(a_numslc)
      into ln_codsolot_ins
      from dummy_ope;

    If ln_codsolot_ins is not null Then

      select F_GET_TAREA_FICHA_TECNICA(ln_codsolot_ins)
        into ln_idtareawf
        from dummy_ope;

      If ln_idtareawf is not null Then
        select trim(PQ_FICHATECNICA.F_OBT_VALOR_TXT(ln_idtareawf,
                                                    a_etiqueta))
          into ls_valor
          from dummy_ope;

        return ls_valor;
      Else
        return null;
      End If;
    Else
      return null;
    End If;

  Exception
    when others then
      return null;
  END;

  PROCEDURE P_PRE_ANULA_PLATAFORMA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) IS

    --10.0 Revisión de todo el procedimiento
    ln_codsolot     solot.codsolot%type;
    ln_idplataforma int_plataforma.idplataforma%type;
    ln_cont         number;
    a_tipoproc      number;
    r_plataforma    int_servicio_plataforma%rowtype;
    a_resultado     varchar2(400);
    a_mensaje       varchar2(400);
    exception_status exception;
    ln_existe         number;
    ln_codsolot_nueva solot.codsolot%type;

    cursor cur_plataforma is
      select ip.idseq,
             ip.codinssrv,
             ip.pid,
             ip.codnumtel,
             ip.imsi,
             ip.esn,
             ot.iddefope_anula,
             ip.numslc
        from int_servicio_plataforma  ip,
             tareawf                  t,
             int_operacion_tareadef   ot,
             int_definicion_operacion op
       where ip.codsolot = ln_codsolot
         and t.idtareawf = ip.idtareawf
         and ot.tareadef = t.tareadef
         and ip.iddefope = ot.iddefope
         and op.iddefope = ot.iddefope
         and op.idplataforma = ln_idplataforma
         and idlote is not null;
  BEGIN

    ln_existe := 0;

    If a_tarea is not null then
      a_tipoproc := 1;
    Else
      a_tipoproc := 0;
    End If;

    Begin
      select sa.codsolot, sa.codsolot_anula
        into ln_codsolot, ln_codsolot_nueva
        from solot_anula sa, wf, tareawf t
       where t.idtareawf = a_idtareawf
         and wf.idwf = t.idwf
         and sa.codsolot_anula = wf.codsolot;
    Exception
      when others then
        a_resultado := 'ERROR';
        a_mensaje   := 'Problema al buscar la solicitud de OT origen (anulada).';
        raise exception_status;
    End;

    If ln_codsolot is null then
      a_resultado := 'ERROR';
      a_mensaje   := 'Problema al buscar la solicitud origen (anulada).';
      raise exception_status;
    else
      Begin
        select op.idplataforma
          into ln_idplataforma
          from tareawf                  t,
               int_operacion_tareadef   ot,
               int_definicion_operacion op
         where t.idtareawf = a_idtareawf
           and ot.tareadef = t.tareadef
           and op.iddefope = ot.iddefope
         group by op.idplataforma;
      Exception
        when no_data_found then
          ln_idplataforma := null;
        when too_many_rows then
          a_mensaje := 'Se encontro mas de un codigo de plataforma.';
          raise exception_status;
      End;

      For c1 in cur_plataforma loop

        if c1.iddefope_anula is null then
          a_resultado := 'ERROR';
          a_mensaje   := 'No se ha configurado la operación para la plataforma.';
          raise exception_status;
        End If;

        r_plataforma.codsolot    := ln_codsolot_nueva;
        r_plataforma.idtareawf   := a_idtareawf;
        r_plataforma.codinssrv   := c1.codinssrv;
        r_plataforma.pid         := c1.pid;
        r_plataforma.codnumtel   := c1.codnumtel;
        r_plataforma.imsi        := c1.imsi;
        r_plataforma.esn         := c1.esn;
        r_plataforma.iddefope    := c1.iddefope_anula;
        r_plataforma.estado      := 0;
        r_plataforma.observacion := 'Generado por Anulación de Registro: ' ||
                                    to_char(c1.idseq);
        r_plataforma.numslc      := c1.numslc;

        select count(*)
          INTO ln_cont
          from int_servicio_plataforma
         where codsolot = r_plataforma.codsolot
           and idtareawf = r_plataforma.idtareawf
           and decode(codinssrv, null, -1) =
               decode(r_plataforma.codinssrv, null, -1)
           and decode(pid, null, -1) = decode(r_plataforma.pid, null, -1)
           and decode(codnumtel, null, -1) =
               decode(r_plataforma.codnumtel, null, -1)
           and decode(imsi, null, -1) = decode(r_plataforma.imsi, null, -1)
           and decode(esn, null, -1) = decode(r_plataforma.esn, null, -1)
           and iddefope = r_plataforma.iddefope;

        If ln_cont = 0 Then
          Begin
            insert into int_servicio_plataforma
              (codsolot,
               idtareawf,
               codinssrv,
               pid,
               codnumtel,
               imsi,
               esn,
               iddefope,
               estado,
               observacion,
               numslc)
            values
              (r_plataforma.codsolot,
               r_plataforma.idtareawf,
               r_plataforma.codinssrv,
               r_plataforma.pid,
               r_plataforma.codnumtel,
               r_plataforma.imsi,
               r_plataforma.esn,
               r_plataforma.iddefope,
               r_plataforma.estado,
               r_plataforma.observacion,
               r_plataforma.numslc);
          Exception
            when others then
              a_resultado := 'ERROR';
              a_mensaje   := 'Problema al generar información para las plataformas.';
              raise exception_status;
          End;
        End if;
        commit;
        ln_existe := 1;
      End loop;

      If ln_existe = 0 and a_tarea is not null Then

        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         4,
                                         8,
                                         0,
                                         SYSDATE,
                                         SYSDATE);

      ELSIf ln_existe = 1 Then

        BEGIN
          P_GENERA_SOLIC_INTERFAZ(a_idtareawf,
                                  a_tipoproc,
                                  a_resultado,
                                  a_mensaje);
          If a_resultado = 'ERROR' Then
            raise exception_status;
          End If;
        exception
          when others then
            a_mensaje := 'Error al enviar a interfaz.';
            raise exception_status;
        End;

      End If;

    End if;

  Exception
    when exception_status then
      insert into tareawfseg
        (idtareawf, observacion, flag)
      values
        (a_idtareawf, a_mensaje, 1);

      If a_tarea is not null then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      Else
        commit; --se graba la anotacion
        RAISE_APPLICATION_ERROR(-20500,
                                'No se pudo generar solicitud a la plataforma.');
      End if;
  END;

  PROCEDURE P_CHG_ANULA_PLATAFORMA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS

    ls_esttarea_old tareawf.esttarea%type;

  BEGIN
    begin
      select esttarea
        into ls_esttarea_old
        from tareawf
       where idtareawf = a_idtareawf;
    EXCEPTION
      WHEN OTHERS Then
        ls_esttarea_old := null;
    End;
    --ejecuta el proceso si cambia de un estado error plataforma a generado.
    IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
       a_esttarea = cn_esttarea_new THEN
      --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
      P_PRE_ANULA_PLATAFORMA(a_idtareawf,
                             a_idwf, /*a_tarea*/
                             null,
                             a_tareadef);
    end if;
  END;
  -- ini 18.0
  PROCEDURE P_PRE_TELF_PIN_RI(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) IS


    ls_numslc  vtatabslcfac.numslc%type;
    ls_numero  numtel.numero%type;
    ln_count number;
    ln_count_srv_pri number;
    ln_count_srv_adi number;
    ln_count_bols number;
    ls_mensaje       varchar2(400);
    exception_status exception;

  BEGIN
   ls_mensaje:='';

    --Si existe dentro de una Venta Normal
    SELECT count(1)
      INTO ln_count_srv_pri
      FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e
     WHERE d.idwf = a_idwf
       AND a.codsolot = d.codsolot
       AND e.codinssrv = a.codinssrv
       AND b.codinssrv = e.codinssrv
       AND b.flgprinc = 1
       AND c.codsrv = b.codsrv
       AND a.pid = b.pid
       AND c.FLAG_LC = 1;

    --Si existe dentro de una Venta Complementaria
       SELECT count(1)
      INTO ln_count_srv_adi
      FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e
     WHERE d.idwf = a_idwf
       AND a.codsolot = d.codsolot
       AND e.codinssrv = a.codinssrv
       AND b.codinssrv = e.codinssrv
       AND c.codsrv = b.codsrv
       AND a.pid = b.pid;

    -- Si es existe una Bolsa de minutos
      SELECT count(1)
      INTO ln_count_bols
      FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e
     WHERE d.idwf = a_idwf
       AND a.codsolot = d.codsolot
       AND e.codinssrv = a.codinssrv
       AND b.codinssrv = e.codinssrv
       AND c.codsrv = b.codsrv
       AND a.pid = b.pid
       AND b.codsrv IN (SELECT c.codigon
                                FROM tipcrmdd t, crmdd c
                               WHERE t.tipcrmdd = c.tipcrmdd
                                 AND t.abrev = 'BOLSAMOVIL');

    IF (ln_count_bols = 1 and ln_count_srv_pri = 1) OR (ln_count_bols = 1 and ln_count_srv_adi = 1) THEN
        BEGIN
          SELECT b.numslc
            INTO ls_numslc
            FROM wf a, solot b
           WHERE a.idwf = a_idwf
             AND a.codsolot = b.codsolot
             AND a.valido = 1;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
            ls_mensaje := 'No se encontro el tipo de servicio.';
            raise exception_status;
          WHEN too_many_rows THEN
            NULL;
            ls_mensaje := 'Se encontraron varias SOTs.';
            raise exception_status;
        END;

        BEGIN
          SELECT f.numero
            INTO ls_numero
            FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
           WHERE d.idwf = a_idwf
             AND a.codsolot = d.codsolot
             AND e.codinssrv = a.codinssrv
             AND e.tipinssrv = 3
             AND b.codinssrv = e.codinssrv
             AND b.flgprinc = 0
             AND c.codsrv = b.codsrv
             AND a.pid = b.pid
             AND e.cid is not null
             AND f.codinssrv = e.codinssrv
             AND b.codsrv IN (SELECT c.codigon
                                FROM tipcrmdd t, crmdd c
                               WHERE t.tipcrmdd = c.tipcrmdd
                                 AND t.abrev = 'BOLSAMOVIL');
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
            ls_mensaje := 'No se encontro Servicio con Bolsa de Minutos.';
            raise exception_status;
        END;

        BEGIN
          SELECT COUNT(1)
            INTO ln_count
            FROM sales.trsequi_pin_trs t
           WHERE t.numslc = ls_numslc
             AND t.estado = 1;
        EXCEPTION
          WHEN others THEN
            Null;
            raise exception_status;
        END;
        IF ln_count = 1 THEN
          BEGIN
            UPDATE sales.trsequi_pin_trs T
               SET T.NUMERO = ls_numero, T.ESTADO = 2
             WHERE t.numslc = ls_numslc
               AND t.estado = 1;
          EXCEPTION
            WHEN OTHERS THEN
              ls_mensaje := 'No se proceso correctamente la actualizacion en la tabla trsequi_pin_trs. ' ||
                            SQLERRM;
              raise exception_status;
          END;
          COMMIT;
        ELSIF ln_count = 0 THEN
          ls_mensaje := 'No se proceso correctamente la actualizacion en la tabla trsequi_pin_trs. ';
          raise exception_status;

        END IF;
    ELSE
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    END IF;

  EXCEPTION
    WHEN exception_status THEN
      INSERT INTO tareawfseg
        (idtareawf, observacion, flag)
      VALUES
        (a_idtareawf, ls_mensaje, 1);

      IF a_tarea is not null THEN
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);

      ELSE
        commit;
        RAISE_APPLICATION_ERROR(-20500,
                               'No se proceso correctamente la actualizacion en la tabla trsequi_pin_trs. ');
      END IF;
  END P_PRE_TELF_PIN_RI;

  PROCEDURE P_CHG_TELF_PIN_RI(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number,
                                     a_tipesttar in number,
                                     a_esttarea  in number,
                                     a_mottarchg in number,
                                     a_fecini    in date,
                                     a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

    BEGIN
      begin
        select esttarea
          into ls_esttarea_old
          from tareawf
         where idtareawf = a_idtareawf;
      EXCEPTION
        WHEN OTHERS Then
          ls_esttarea_old := null;
      End;
      --ejecuta el proceso si cambia de un estado error plataforma a generado.
      IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
        --se coloca el a_tarea en null para identificar que proviene de un cambio de estado
           P_PRE_TELF_PIN_RI(a_idtareawf,
                             a_idwf, /*a_tarea*/
                             null,
                             a_tareadef);
      end if;
    END;

PROCEDURE P_PRE_TELF_PIN_RI_BAJA(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS
    ls_numslc  vtatabslcfac.numslc%type;
    ls_numero  numtel.numero%type;
    ln_count number;
    ln_count_srv_pri number;
    ln_count_srv_adi number;
    ls_mensaje       varchar2(400);
    ln_codsolot      operacion.solot.codsolot%type;
    exception_status exception;

  BEGIN

   select codsolot into ln_codsolot from wf where idwf = a_idwf;

   ls_mensaje:='';


   --Validamos si se esta dando de baja al servicio de bolsa de minutos fijo movil
    select count(1)
      into ln_count
      from sales.trsequi_pin_trs t
     where t.numslc in
           (select s.numslc
              from solot s
             where s.codsolot in
                   (select a.codsolot
                      from solotpto a
                     where a.codinssrv in
                           (select sp.codinssrv
                              from solotpto sp, inssrv i, tystabsrv t
                             where sp.codinssrv = i.codinssrv
                               and sp.codsolot = ln_codsolot
                               and i.tipinssrv = 3
                               and sp.codsrvnue = t.codsrv
                               and t.tipsrv =
                                   (select valor
                                      from constante
                                     where constante = 'FAM_TELEF'))));

    IF ln_count > 0 THEN
        BEGIN
           update sales.trsequi_pin_trs t
              set t.estado = 3
            where t.numslc in
                  (select t.numslc
                     from sales.trsequi_pin_trs t
                    where t.numslc in
                          (select s.numslc
                             from solot s
                            where s.codsolot in
                                  (select a.codsolot
                                     from solotpto a
                                    where a.codinssrv in
                                          (select sp.codinssrv
                                             from solotpto  sp,
                                                  inssrv    i,
                                                  tystabsrv t
                                            where sp.codinssrv = i.codinssrv
                                              and sp.codsolot = ln_codsolot
                                              and i.tipinssrv = 3
                                              and sp.codsrvnue = t.codsrv
                                              and t.tipsrv =
                                                  (select valor
                                                     from constante
                                                    where constante =
                                                          'FAM_TELEF')))));
        EXCEPTION
          WHEN OTHERS THEN
            ls_mensaje := 'No se proceso correctamente la actualizacion en la tabla trsequi_pin_trs. ' ||
                          SQLERRM;
            raise exception_status;
        END;

        BEGIN
          OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       4,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
        EXCEPTION
          WHEN OTHERS THEN
            ls_mensaje := 'No se pudo cerrar la tarea. ' ||
                          SQLERRM;
            raise exception_status;
        END;

        COMMIT;

    ELSE
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    END IF;

  EXCEPTION
    WHEN exception_status THEN
      INSERT INTO tareawfseg
        (idtareawf, observacion, flag)
      VALUES
        (a_idtareawf, ls_mensaje, 1);

      IF a_tarea is not null THEN
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                         2,
                                         cn_esttarea_error,
                                         0,
                                         SYSDATE,
                                         SYSDATE);

      ELSE
        commit;
        RAISE_APPLICATION_ERROR(-20500,
                               'No se proceso correctamente la actualizacion en la tabla trsequi_pin_trs. ');
      END IF;
  END P_PRE_TELF_PIN_RI_BAJA;

  PROCEDURE P_CHG_TELF_PIN_RI_BAJA(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

    BEGIN
      begin
        select esttarea
          into ls_esttarea_old
          from tareawf
         where idtareawf = a_idtareawf;
      EXCEPTION
        WHEN OTHERS Then
          ls_esttarea_old := null;
      End;
      --Ejecuta el proceso si cambia de un estado error plataforma a generado.
      IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
         --Se coloca el a_tarea en null para identificar que proviene de un cambio de estado
           P_PRE_TELF_PIN_RI_BAJA( a_idtareawf,
                                   a_idwf,
                                   null,
                                   a_tareadef);
      end if;
  END P_CHG_TELF_PIN_RI_BAJA;

  PROCEDURE P_PRE_VAL_MSJ_INTW(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
     ln_codsolot solot.codsolot%type;
     ln_cmd_itw  number;
  BEGIN

     SELECT codsolot INTO ln_codsolot FROM wf WHERE idwf = a_idwf;
     SELECT count(1)
       INTO ln_cmd_itw
       FROM int_mensaje_intraway
      WHERE codsolot = ln_codsolot;

     IF ln_cmd_itw = 0 THEN
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                        4,
                                        8,
                                        0,
                                        SYSDATE,
                                        SYSDATE);
     END IF;
   END;

  PROCEDURE P_CHG_VAL_MSJ_INTW(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number,
                                   a_tipesttar in number,
                                   a_esttarea  in number,
                                   a_mottarchg in number,
                                   a_fecini    in date,
                                   a_fecfin    in date) IS

      ls_esttarea_old tareawf.esttarea%type;

    BEGIN
      begin
        select esttarea
          into ls_esttarea_old
          from tareawf
         where idtareawf = a_idtareawf;
      EXCEPTION
        WHEN OTHERS Then
          ls_esttarea_old := null;
      End;
      --Ejecuta el proceso si cambia de un estado error plataforma a generado.
      IF ls_esttarea_old is not null AND ls_esttarea_old = cn_esttarea_error AND
         a_esttarea = cn_esttarea_new THEN
         --Se coloca el a_tarea en null para identificar que proviene de un cambio de estado
            P_PRE_VAL_MSJ_INTW( a_idtareawf,
                                   a_idwf,
                                   null,
                                   a_tareadef);
      end if;
  END P_CHG_VAL_MSJ_INTW;

 --Fin 18.0
 --ini 22.0
  PROCEDURE P_VALIDA_ASIG_PLATAF_BSCS(a_idplan in    NUMBER,
                                 a_codsrv    in      varchar2,
                                 A_RESPUESTA out NUMBER) IS

  CURSOR c_valida(vv_idplan number) IS
  select pp.idproducto
  from PLAN_REDINT p, planxproducto pp
  where p.idplan = pp.idplan and
  p.idplan = vv_idplan and
  p.idplataforma = 6;
  vv_valida number(1);
  vv_count  number(1);
  BEGIN
         vv_valida := 0;
         for c in c_valida(a_idplan) loop
             select count(*)
             into vv_count
             from tystabsrv t
             where t.codsrv = a_codsrv and
             t.idproducto = c.idproducto and
             t.flag_lc = 1;

             if vv_count > 0 then
                vv_valida := 1;
                exit;
             end if;
         end loop;

         A_RESPUESTA := vv_valida;

  END;
  -- fin 22.0
END;
/