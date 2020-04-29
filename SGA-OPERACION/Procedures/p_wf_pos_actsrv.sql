create or replace procedure operacion.p_wf_pos_actsrv(a_idtareawf in number,
                                                      a_idwf      in number,
                                                      a_tarea     in number,
                                                      a_tareadef  in number) is
  /************************************************************
  NOMBRE:     PQ_INTERFACE_COLLECTIONS_GL_2
  PROPOSITO:  Activacion de servicio; ejecuta la generacion de SOT de cancelacion por traslado.Cambia el estado de la SOT a Atendida
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        07/07/2009  Hector Huaman M  REQ-97131:Se comento el llamado al procedmiento para que no actualice el estado en solotpto_id
  2.0        25/01/2010  MEchevarria      REQ-116634: Se deshabilito el cierre automatico para tarea Atendido PIN
  3.0        21/07/2010  Giovanni Vasquez  Req 71946: Devoluciones por bajas y cambio de plan - Aplicación
  4.0        26/04/2011  Edilberto Astulle Se cambia de estado las Agendas de la SOT a "Ejecutado Servicio" y se cierra la tarea de Operaciones Gestion Programacion
  5.0        28/04/2011  Alexander Yong    REQ-158962: Agregar validación al proceso que generar NC por una SOT de Baja
  6.0        01/04/2012  Fernando Canaval  Req 162221 Generación de NC Automático
  7.0        07/05/2012  Miguel Londoña    Ampliación de caracteres del número de serie
  8.0        14/08/2012  Juan Pablo Ramos  Proy. Claro Club: Solicitado por Elver Ramirez
  9.0        25/10/2012  Juan Pablo Ramos  REQ-162701 Claro Club en HFC
  10.0       15/01/2013  Edilberto Astulle SD-432921 NO PERMITE EMITIR NC
  11.0       28/01/2013  Alfonso Perez/Edilberto Astulle  REQ 163839 CIERRE FACTURACION
  12.0       21/06/2013  Edilberto Astulle  SD_651069  -  Registro de Equipos desde IW en SOTs de baja
  13.0
  14.0       21/08/2013  Miriam Mandujano   Agregar la actualizacion de los proyectos demos
  15.0       18/11/2013  Edson Caqui      Luis Rojas        Mejoras.
  16.0       01/09/2014  Angel Condori    Manuel Gallegos  PROY-12688:Ventas Convergentes
  17.0       24/11/2016  Jose Varillas       Alertas Transfer Billing
  18.0       31/03/2016  Luis Polo        SGA-SD-742716: Envio de OCC a BSCS para SOTs de PostVenta
  19.0       17/02/2017  Solucion de Fallas        SGA INC000000648417
  20.0       26/04/2018  Solucion de Fallas        SGA INC000001112318
  21.0       04/04/2019  PROY-140228 - FUNCIONALIDADES SOBRE SERVICIOS FIJA CORPORATIVA EN SGA
  22.0       10/09/2018  Edwin Vasquez            PROY-29215_IDEA-30265 Costo de Instalación para LTE en SISACT
  ***********************************************************/

  l_codsolot        solot.codsolot%type;
  l_cad             varchar2(10);
  l_numregistro     varchar2(20);
  l_numslc          vtatabslcfac.numslc%type;
  l_tiptra          tiptrabajo.tiptra%type;
  l_codsolot_cambio varchar2(20);
  ls_descripcion    tiptrabajo.descripcion%type;
  l_cont            number(6);
  ln_count          number;
  ln_flgeneranc     number;
  l_fecrec          solot.fecrec%type;
  l_codcli          vtatabcli.codcli%type;
  ls_titulo_mail    varchar2(300);
  ls_cuerpo_mail    varchar2(4000);
  ls_destino        varchar2(60);
  lc_codcli         char(8);
  ls_nomcli         varchar2(200);
  ls_sersut         cxctabfac.sersut%type;--7.0 char(3);
  ls_numsut         cxctabfac.numsut%type;--7.0 char(8);
  ln_monto_aplicado number;
  ln_monto_efectivo number;
  ln_genera_nc      number;
  ln_flgvalidar    number;--<4.0>
  n_idagenda agendamiento.idagenda%type; --4.0
  n_cont_tar_gest number;--4.0
  n_idtareawf tareawfcpy.idtareawf%type;--4.0
  d_fecha_ini_srv date;--4.0
  n_tiptra number;--4.0
  n_cont_tiptra number;--4.0
  v_resultado number; --<8.0>
  v_mensaje varchar2(3000); --<8.0>
  lc_flg_tiptra     varchar2(3); --<12.0>
  l_conttiptra     number; --<9.0>
  --<ini 11.0>
  ln_estado        number;
  ln_continua      number;
  ln_codsolot      number;
  an_idtrans       number;
  ac_resultado     varchar2(100);
  ac_mensaje       varchar2(100);
  ld_feccom        date;
  l_cont_numregistro number;--<11.0>
  --<Fin 11.0>
  lv_subject    varchar2(250);--12.0
  lv_mail_to    varchar2(250);--12.0
  lv_mensaje    varchar2(4000);--12.0

  --Ini 14.0
  lv_tipsrv     char(4);
  lv_proydemo   char(1);
  ll_contador   number;
  ln_tiptra     number;
  lc_estadopen  char(1);
  lc_estadopro  char(1);
  --Fin 14.0

  --INI 15.0
  V_RESULTADO1   NUMBER;
  V_MENSAJE1     VARCHAR2(3000);
  LS_ERROR       VARCHAR2(2000);
  --FIN 15.0
  -- Ini 16.0
  lv_flg_vc      number;
  ln_resp_cierre number;
  lc_mensaje_cierre varchar2(500);
  ln_val            NUMBER;
  l_sotbajtrs       solot.codsolot%TYPE;
  ls_msjtras        VARCHAR2(3000);
  -- Fin 16.0
  -- Ini 18.0
  ln_estado_sot      NUMBER;
  ln_cargo           NUMBER;
  lv_codigo_occ_bscs VARCHAR2(20);
  ln_customerid      NUMBER;
  av_trama           CLOB;
  cnt_lte            NUMBER;
  -- Fin 18.0
  cursor cur_det_ip is
    select numslc, codsrv, codinssrv_orig, idpaq
      from regdetptoenlcambio
     where flgsrv_pri = 1
       and numslc = l_numslc;

  cursor cur_ncxsolot(a_codsolot solot.codsolot%type) is
    select c.idfac
      from cxctabfac c, cxc_plantilla cp
     where cp.idplantilla = c.idplantilla
       and cp.codsolot = a_codsolot;

  cursor cur_ncxsolottras(ac_codsolot solot.codsolot%type) is
    select numdoc
      from COLLECTIONS.CXCINTERFASE
     where ID_SOLOT = ac_codsolot
       and TIPDOCORI = 'N/C';
  -- 20.0 ini
  ln_estado_contrato   number;
  ln_cod_contrato      number;
  ln_codigo_tarea_dth  number;
  -- 20.0 fin

  --INI 21.0
  ln_resultado number;
  --FIN 21.0
  -- Ini 22.0
   l_cod_id       VARCHAR2(50);
   l_customer_id  VARCHAR2(50);
   ln_resp_cci    NUMBER;
   lc_mensaje_cci  VARCHAR2(3000);
   ln_activa_cci  NUMBER;
  -- fin 22.0
begin
  select codsolot into l_codsolot from wf where idwf = a_idwf;

  -- 20.0 ini
  begin
    select tiptra into l_tiptra from solot where codsolot = l_codsolot;
    ln_codigo_tarea_dth := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CODIGOTAREA_DTH');
    if l_tiptra = ln_codigo_tarea_dth then   -- si es DTH
       ln_cod_contrato := operacion.pkg_cambio_ciclo_fact.f_otiene_cod_id (l_codsolot) ;
       if (ln_cod_contrato > 0 and ln_cod_contrato is not null) then
           ln_estado_contrato := operacion.pq_sga_iw.f_val_status_contrato(ln_cod_contrato) ;
       begin
         SELECT opedd.DESCRIPCION
         INTO lv_mensaje
         FROM operacion.tipopedd, operacion.opedd
        WHERE tipopedd.TIPOPEDD = opedd.TIPOPEDD
          AND tipopedd.abrev = 'SGA_VAL_ESTADO_CONTRATO'
          AND opedd.CODIGON = (    SELECT opedd.CODIGON
                       FROM operacion.tipopedd, operacion.opedd
                      WHERE tipopedd.TIPOPEDD = opedd.TIPOPEDD
                        AND tipopedd.abrev = 'SGA_VAL_ESTADO_CONTRATO'
                        AND opedd.CODIGON = ln_estado_contrato ) ;
       exception
        when others then
             lv_mensaje := '';
       end;
           IF LENGTH(lv_mensaje) > 0 and lv_mensaje is not null THEN
              raise_application_error(-20001,lv_mensaje);
           END IF;
       end if;
    end if;
  end;

  -- 20.0 fin

  l_cad := pq_constantes.f_get_cfg;
  if l_cad in ('PER') then
    pq_solot.p_chg_estado_solot(l_codsolot, 29);



    --4.0 inicio
    select tiptra into n_tiptra from solot where codsolot = l_codsolot;
    select count(1)
      into n_cont_tiptra
      from opedd
     where tipopedd = 402
       and n_tiptra =codigon;
    if n_cont_tiptra = 1 then
      select max(idagenda)
        into n_idagenda
        from agendamiento
       where codsolot = l_codsolot;
      if n_idagenda is not null then
        --Se cambia de estado la agenda Ejecutado Servicio
        select min(nvl(fecinisrv,sysdate))
          into d_fecha_ini_srv
          from solotpto
         where codsolot = l_codsolot;
        operacion.pq_agendamiento.p_chg_est_agendamiento(n_idagenda,
                                                         20,
                                                         null,
                                                         'Agenda con Servicio Ejecutado.',
                                                         null,
                                                         d_fecha_ini_srv);
      end if;
      select count(1)
        into n_cont_tar_gest
        from tareawf
       where idwf = a_idwf
         and tareadef = 1009; --Gestion Programacion
      if n_cont_tar_gest = 1 then
        select idtareawf
          into n_idtareawf
          from tareawf
         where idwf = a_idwf
           and tareadef = 1009;
        --Cierra tarea de Gestion Programacion
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(n_idtareawf,
                                         4,
                                         4,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      end if;
   end if;

    --4.0 fin
    --<Ini 8.0> --13.0
    begin
      --<Ini 9.0>
      lc_flg_tiptra := atccorp.pq_canje_premio.f_obt_tipo_trabajo(n_tiptra);
      if lc_flg_tiptra is not null then
        --<Fin 9.0>
        atccorp.pq_canje_premio.p_genera_codigo_claroclub(l_codsolot,
                                                          v_resultado,
                                                          v_mensaje);

      end if; --<9.0> --13.0
    exception
      when others then
        v_resultado := -1;
        v_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
        --<Ini 13.0>
        select value,  description into lv_subject, lv_mail_to
        from atccorp.atcparameter
        where codparameter = 'MAILCLAROCLUB';
        opewf.pq_send_mail_job.p_send_mail(lv_subject||' - '||l_codsolot,
                     lv_mail_to,v_mensaje,'SGA');
        --<Fin 13.0>
    end;
    --<Fin 8.0>
    --<1.0 PQ_CUSPE_OPE.P_POS_TAREAWF_CERRAR_PUNTOS(a_idtareawf, a_idwf, a_tarea, a_tareadef); 1.0>
  end if;
  --INI INC 0000000648417
  --SELECT COUNT(1)
  --  INTO ln_val
  --  FROM OPEDD O, TIPOPEDD T
  -- WHERE O.TIPOPEDD = T.TIPOPEDD
  --   AND T.ABREV = 'TRANS_BILL'
  --   AND O.ABREVIACION = 'P_GEN_SOLOT_TRASLADO_F'
  --   AND O.CODIGOC = '1';
   --IF ln_val > 0 THEN
   --FIN INC 0000000648417

    operacion.p_gen_solot_traslado_f(l_codsolot, l_sotbajtrs);
  --INI INC 0000000648417
  --ELSE
    --operacion.p_gen_solot_traslado(l_codsolot);
--  END IF;
--FIN INC 0000000648417
  --Genera Sot de Baja ( Cambio de Plan) --HAHM
  -- ini 14.0
   select tiptra, nvl(numslc, null), codcli, nvl(fecrec, null),tipsrv
   into   l_tiptra, l_numslc, l_codcli, l_fecrec,lv_tipsrv
   from   solot
   where  codsolot = l_codsolot;

   SELECT VALOR
   INTO   lc_estadopro
   FROM   OPERACION.CONSTANTE
   WHERE  CONSTANTE='ESTPROCDEMO';

   SELECT VALOR
   INTO   lc_estadopen
   FROM   OPERACION.CONSTANTE
   WHERE  CONSTANTE='ESTNOPRODEMO';

   SELECT to_number(VALOR)
   INTO   ln_tiptra
   FROM   OPERACION.CONSTANTE
   WHERE  CONSTANTE='TIPTRA';

   --VARIABLE DE PROYECTO DEMO

  select count(1)
   into   ll_contador
   from   sales.VTAT_DEMOCONT a
   where  to_char(a.DEMV_FECHAFINDEMO,'dd/mm/yyyy') >= to_char(sysdate,'dd/mm/yyyy')
   and    a.DEMV_NUMSLC       = l_numslc;

   if ll_contador > 0 then

       lv_proydemo:=lc_estadopro;

   else
       lv_proydemo:=lc_estadopen;

   end if;
  -- fin 14.0

--Inicio 10.0
  select count(1) into l_conttiptra from opedd a, tipopedd b
  where a.tipopedd=b.tipopedd
  and b.abrev='CAMPLANFIJA' and a.codigon=l_tiptra;

--  if l_tiptra in (391, 458, 427, 439) then
  if l_conttiptra = 1 then
--Fin 10.0
    ---REQ.74864
    for c in cur_det_ip loop
      update inssrv
         set idpaq = c.idpaq, numslc = c.numslc, codsrv = c.codsrv
       where codinssrv = c.codinssrv_orig;
    end loop;
    ---REQ.74864

    select descripcion
      into ls_descripcion
      from tiptrabajo
     where tiptra = l_tiptra;

    l_codsolot_cambio := l_codsolot;

    select count(1) into l_cont_numregistro from regvtamentab where numslc = l_numslc;--<11.0>
    if l_cont_numregistro>0 then --<11.0>
    select numregistro
      into l_numregistro
      from regvtamentab
     where numslc = l_numslc;

    select count(1)
      into ln_count
      from reginsprdbaja
     where numregistro = l_numregistro
       and estado = 0;

      --<ini 11.0>
      begin
       select idestado
         into ln_estado
         from ATCCORP.ATC_TRS_BAJA_X_CP
        where numregistro = l_numregistro;
      exception
        when others then
           ln_estado := null;
      end;

      if ln_estado is null then
         ln_continua := 1; --No tiene que ver con el nuevo flujo, sigue con el flujo normal
      else
         select feccom
           into ld_feccom
           from ATCCORP.ATC_TRS_BAJA_X_CP
          where numregistro = l_numregistro;

         if ld_feccom >= trunc(sysdate) and ln_estado = 0 then
            select codsolot_cp
              into ln_codsolot
              from ATCCORP.ATC_TRS_BAJA_X_CP
             where numregistro = l_numregistro;

            atccorp.PQ_TRS_CP_ATC.p_anula_baja_cp(ln_codsolot,an_idtrans,ac_resultado,ac_mensaje);
            ln_continua := 1;

         end if;

         /*if ln_estado = 1 then
            select codsolot_cp
              into ln_codsolot
              from ATCCORP.ATC_TRS_BAJA_X_CP
             where numregistro = l_numregistro;

            atccorp.PQ_TRS_CP_ATC.p_anula_baja_cp(ln_codsolot,an_idtrans,ac_resultado,ac_mensaje);

         elsif ln_estado = 0 then
               ln_continua := 1 ;
         end if;*/

      end if;

      if ln_count > 0 and ln_continua = 1 then
      sales.p_autogenerar_solot_baja(l_numregistro,
                                     l_codsolot,
                                     l_tiptra,
                                     l_codsolot_cambio);
      operacion.pq_solot.p_ejecutar_solot(l_codsolot_cambio);
    end if;
    end if;--<11.0>
    update solot
       set observacion = observacion || ' .Se genero la SOT: ' ||
                         l_codsolot_cambio || ' ==> Asociado a la sot ' ||
                         l_codsolot || ' de tipo ' || ls_descripcion
     where codsolot = l_codsolot_cambio;
  --ini 14.0
  elsif (l_tiptra =ln_tiptra and l_fecrec is not null) or (lv_proydemo=lc_estadopro) then

      if  lv_proydemo=lc_estadopro then

          insert into operacion.reconexion_apc
           (codsolot, codcli, fecrec,tipsrv,tipodemo)
          select l_codsolot, l_codcli,a.DEMV_FECHAFINDEMO,lv_tipsrv,lc_estadopro
          from   sales.VTAT_DEMOCONT a
          where  to_char(a.DEMV_FECHAFINDEMO,'dd/mm/yyyy') >= to_char(sysdate,'dd/mm/yyyy')
          and    a.DEMV_NUMSLC       = l_numslc
          and    (select count(1) from   operacion.reconexion_apc
                  where  codsolot = l_codsolot and tipodemo =lc_estadopro)=0;

           UPDATE sales.VTAT_DEMOCONT a
           SET    DEMV_PROCESADO = lc_estadopen
           WHERE  a.DEMV_NUMSLC  = l_numslc;

      else

          insert into operacion.reconexion_apc
           (codsolot, codcli, fecrec,tipsrv,tipodemo)
          values
          (l_codsolot, l_codcli, l_fecrec,null,lc_estadopen);

      end if;
      --fin 14.0

  end if;
  -- FIN Genera Sot de Baja ( Cambio de Plan) --HAHM
  pq_corteservicio.p_actestadofac(l_codsolot);

  -- INI <3.0> BUSCAR GENERA NOTA CREDITO
  begin
  --Ini 5.0
     select count(1)
       into ln_flgvalidar
       from fac_solotxnotacred_rel
      where codsolot = l_codsolot;

    If ln_flgvalidar = 0 then
    --Fin 5.0
    select c.flg_genera_nc
      into ln_flgeneranc
      from solot a, tiptrabajo b, motinssrv c
     where a.codsolot = l_codsolot
       and a.tiptra = b.tiptra
       and b.codmotinssrv = c.codmotinssrv;
    --Ini 5.0
     else
     ln_flgeneranc := 0;
     End If;
     --Fin 5.0
  exception
    when others then
      ln_flgeneranc := 0;
  end;

  if ln_flgeneranc = 1 then
    --INI 15.0
    -- PROCESO REGISTRO DE CARGOS PARA DEVOLUCION POR NOTA DE CREDITO
    BEGIN
      COLLECTIONS.PQ_CXC_NOTACREDITO.P_REG_CARGO_DEV_NC_POR_BAJA(L_CODSOLOT);
    EXCEPTION
      WHEN OTHERS THEN
        LS_ERROR := SUBSTR(SQLERRM,1,2000);
        NULL;
    END;
    --FIN 15.0
    --ini 6.0
    select count(1)
      into ln_flgvalidar
      from fac_solotxnotacred_rel
     where codsolot = l_codsolot;
    if ln_flgvalidar = 0 then
      insert into billcolper.fac_bajatot_nc_cab
        (codsolot, flg_devol)
      values
        (l_codsolot, 0);
    end if;
    if ln_flgvalidar > 0 then
      --INI 15.0
      -- PROCESO DE NOTA DE CREDITO POR BAJAS TOTALES
      COLLECTIONS.PQ_CXC_NOTACREDITO.P_NC_MAIN(2,--TIPO
                                               6,--SUBTIPO
                                               NULL,--INCIDENCIA
                                               L_CODSOLOT,--SOLOT
                                               NULL,--OTRO
                                               NULL,--SERIE
                                               V_RESULTADO1,
                                               v_MENSAJE1);
      --FIN 15.0
    end if;
    --fin 6.0

  end if;
  -- FIN <3.0>
  commit;
  -- Identificar Traslado
  SELECT COUNT(1)
    INTO ln_val
    FROM OPEDD O, TIPOPEDD T
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND T.ABREV = 'TRANS_BILL'
     AND O.ABREVIACION = 'P_WF_POS_ACTSRV'
     AND O.CODIGOC = '1';
  IF ln_val > 0 THEN
    select count(*)
      into l_cont
      from solotpto
     where codsolot = l_codsolot
       and codinssrv_tra is not null;
    if l_cont > 0 then
      select count(*)
        into l_cont
        from tipopedd tp, opedd od
       where TP.ABREV = 'TRASLADO_EXTERNO'
         and TP.TIPOPEDD = od.TIPOPEDD
         and od.codigoN =
             (select tiptra from solot where codsolot = l_codsolot);
      if l_cont > 0 then
        if l_sotbajtrs <> 0 then
          ls_msjtras := 'Se creo la Sot de Baja : ' || l_sotbajtrs || chr(13);
        else
          ls_msjtras := 'No se genero Baja para la Sot de Traslado' ||
                        chr(13);
        end if;
        select count(1)
          into l_cont
          from COLLECTIONS.CXCINTERFASE
         where ID_SOLOT = l_codsolot
           and TIPDOCORI = 'N/C';
        if l_cont > 0 Then
          for lcur_ncxsolottras in cur_ncxsolottras(l_codsolot) LOOP

            ls_msjtras := ls_msjtras || 'Se creo la N/C N°' ||
                          lcur_ncxsolottras.numdoc || chr(13);
          end loop;
        else
          ls_msjtras := ls_msjtras ||
                        'No se genero N/C para la Sot de Traslado' || chr(13);
        end if;

        insert into tareawfseg
          (idtareawf, observacion)
        values
          (a_idtareawf, ls_msjtras);
        commit;

      end if;
    end if;
  END IF;
  -- EMELENDEZ: 11/06/2008
  -- Cierra tarea Atendido - PIN (No para Xplora, TPI, DTH)
  --<2.0> se desactiva el cierre automatico de  la tarea Atendido PIN
  /*
  BEGIN
  Select tareawf.idtareawf into a_idtareawfPint from tareawf, wf, solot
     Where tareawf.idwf = wf.idwf
     And wf.codsolot = solot.codsolot
     And tareadef = 548 -- Atendido PIN
     And solot.tipsrv Not In (58,59,61) -- Solo para SOT que no sean de Xplora, TPI, Paquetes Masivos (DTH)
     And wf.codsolot = l_codsolot;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
        a_idtareawfPint := NULL;
   END;
  If a_idtareawfPint is not null and a_idtareawfPint > 0 then
        PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawfPint, 4, 4, null,sysdate, sysdate);
  End If;
  */
  --</2.0>
  -- Fin EMELENDEZ

  -- Ini 18.0 ***
  select count(*)
   into cnt_lte
   from sales.siac_postventa_lte spl
  where spl.codsolot = l_codsolot;

  if cnt_lte > 0 then
    SELECT s.estsol, s.cargo, s.customer_id
      INTO ln_estado_sot, ln_cargo, ln_customerid
      FROM solot s
     WHERE s.codsolot = l_codsolot;
    IF ln_estado_sot = 29 THEN
      IF ln_cargo IS NOT NULL THEN
        IF ln_cargo > 0 THEN
          -- Consultar el Codigo de OCC de BSCS
          SELECT spl.codigo_occ
            INTO lv_codigo_occ_bscs
            FROM sales.siac_postventa_lte spl
           WHERE spl.codsolot = l_codsolot;
          sales.pq_siac_postventa_lte.p_insert_occ(ln_customerid,
                                                   l_codsolot,
                                                   lv_codigo_occ_bscs,
                                                   '1',
                                                   ln_cargo,
                                                   av_trama,
                                                   v_resultado,
                                                   v_mensaje);
        END IF;
      END IF;
    END IF;
  end if;
  -- Fin 18.0 ***
  -- Ini 22.0
    select t.codigon
      into ln_activa_cci
      from opedd t
     where t.tipopedd = (select t.tipopedd
                           from tipopedd t
                          where t.abrev = 'PAR_VAL_CCI')
       and t.abreviacion = 'FLAG_CCI'
       AND t.codigon_aux = 1;

    if ln_activa_cci = 1 then
      BEGIN

        SALES.PKG_VALIDACION_CCI.SGASP_VALIDACCION_CCI(l_codsolot,
                                                       ln_resp_cci,
                                                       lc_mensaje_cci);

        if lc_mensaje_cci is not null then
          ln_resp_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                               'codRespuesta'));

          lc_mensaje_cci := TRIM(SALES.PKG_VALIDACION_CCI.SGAFUN_ATRIBUTO_XML(lc_mensaje_cci,
                                                                                  'msjRespuesta'));
          if ln_resp_cci <> 0 then
              l_cod_id := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(l_codsolot,'CODID');
              l_customer_id := SALES.PKG_VALIDACION_CCI.SGAFUN_GET_DATOS_SOT(l_codsolot,'CUSTOMERID');

              lc_mensaje_cci:= 'VALIDACION_CCI, ERROR : '||lc_mensaje_cci;
              
              insert into HISTORICO.SGAT_REGVALCCI(codsolot, codid, customerid, observacion, reintentos )
              values(l_codsolot, l_cod_id, l_customer_id, lc_mensaje_cci, 1);
              commit;
              
          end if;

        end if;
      EXCEPTION
        WHEN OTHERS THEN
          lc_mensaje_cci := 'VALIDACION_CCI, ERROR : ' || sqlcode || ' ' || sqlerrm;

           insert into HISTORICO.SGAT_REGVALCCI(codsolot, observacion, reintentos )
           values(l_codsolot, lc_mensaje_cci, 1);
           
           commit;         

      END;
    end if;
  -- Fin 22.0
  -- REQ.65285 HHAM
  -- Se valida que no existan tareas abiertas y se cierra el WF
  select count(1)
    into l_cont
    from tareawfcpy, tareawf
   where tareawfcpy.idtareawf = tareawf.idtareawf(+)
     and tareawfcpy.idwf = a_idwf
     and nvl(tareawf.tipesttar, 1) in (1, 2, 3);
  if l_cont = 0 then
    pq_solot.p_chg_estado_solot(l_codsolot, 12);
  end if;
  -- REQ.65285 HHAM  FIN
  -- Ini 16.0
  select decode(s.resumen,'VC',1,0) into lv_flg_vc
    from operacion.solot s
   where s.codsolot=l_codsolot;

  if lv_flg_vc=1 then
     operacion.pkg_sisact.p_informar_cierre(l_codsolot,
                                            ln_resp_cierre,
                                            lc_mensaje_cierre);
  end if;
  -- Fin 16.0

  -- INI 21.0
  metasolv.pkg_asignacion_pex_unico.sgass_libera_hilo_alta(l_codsolot,ln_resultado);
  -- FIN 21.0

end;
/