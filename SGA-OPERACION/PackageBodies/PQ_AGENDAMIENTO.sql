CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_AGENDAMIENTO is
  /***********************************************************************************************
     NOMBRE:     OPERACION.Pq_Agendamiento
     PROPOSITO:  Realizar toda la funcionalidad de Agendamiento Peru
     PROGRAMADO EN JOB:  NO
  
     REVISIONES:
     Version      Fecha        Autor             Solicitado Por        Descripcion
     ---------  ----------  -----------------    --------------        ------------------------
     1.0        08/03/2010  Marcos Echevarria    Edilberto Astulle     REQ-107706: Se crea el paquete agendamiento
     2.0        25/05/2010  Marcos Echevarria    Edilberto Astulle     REQ-130663: Se inserta codsuc y codcase en agendamiento, optimizacion de interface incidencia, creacion
                                                                       de nuevo procedimiento asigan contrata Telmex
     3.0        22/06/2010  Antonio Lagos        Juan Gallegos         REQ-119999: Bundle, carga masiva de agenda
     4.0        30/07/2010  Mariela Aguirre      Rolando Martinez      REQ-135892: Asignacion de contrata y Tipo Trabajo en DISTRITOXCONTRATA
     5.0        05/10/2010  Esdon Caqui          Marco de la Cruz      Req.144627. Considerar prioridad en contrata para distrito y tipo de trabajo.
     6.0        08/11/2010  Alexander Yong       Marco de la Cruz      REQ-148249: Error en el flujo de la atencion de  incidencias
     7.0        21/12/2010  Antonio Lagos        Edilberto Astulle     REQ-134845: Se agrega campo area a la agenda
     8.0        04/02/2011  Alexander Yong       Zulma Quispe          REQ-148648: Requerimiento para Instalar mas de 01 linea telefonica por equipo eMTA
     9.0        28/04/2011  Alexander Yong       Zulma Quispe          REQ-159020: Adecuaciones al Nuevo WF de Instalaciones
     10.0       05/05/2011  Antonio Lagos        Zulma Quispe          REQ-159162: puerta a puerta TN
     11.0       06/05/2011  Antonio Lagos        Zulma Quispe          REQ-140967: cancelar agenda al cancelar y volver a asignar el workflow
     12.0       01/07/2011  Tommy Arakaki        Edilberto Astulle     REQ 159541 - Mejoras en el Modulo de Agendamiento de HFC
     13.0       11/08/2011  Alexander Yong       Edilberto Astulle     REQ-160185: SOTs Baja 3Play
     14.0       21/06/2011  Alfonso Perez        Elver Ramirez         REQ-159092: PS Tablero de Control
     15.0       12/01/2012  Edilberto Astulle    Edilberto Astulle     PROY-1332 Motivos de SOT por Tipo de Trabajo
     16.0       23/02/2012  Edilberto Astulle    Edilberto Astulle     PROY-1875 Mejorar el proceso de Bajas HFC a nivel de Intraway
     17.0       23/03/2012  Edilberto Astulle    Edilberto Astulle     PROY-2769_Generacion de Nuevo grupo de corte CE en HFC
     18.0       09/04/2012  Edilberto Astulle    Edilberto Astulle     PROY-2787_Modificacion modulo de control de tareas SGA Operaciones
     19.0       29/04/2012  Edilberto Astulle    Edilberto Astulle     PROY-1483_Agendamiento para Mantenimiento e Instalaciones de proveedores
     20.0       31/05/2012  Alex Alamo           Hector Huaman         PROY-0642- DTH Postpago
     21.0       31/05/2012  Edilberto Astulle                          IDEA-4694  Gestion Instalacion/PostVenta IM DTH
     22.0       30/06/2012  Edilberto Astulle                          PQT-121129-TSK-10791
     23.0       30/06/2012  Edilberto Astulle                          PROY-2307_Cambio IW DTA Adicional
     24.0       20/07/2012  Edilberto Astulle                          PROY-4191_Cambio Work Flow CE HFC
     25.0       26/07/2012  Edilberto Astulle                          PROY-4316 Banda Ancha Movil
     26.0       30/07/2012  Edilberto Astulle                          PROY_3433_AgendamientoenLineaOperaciones
     27.0       30/09/2012  Edilberto Astulle                          PROY-4854_Modificacion de work flow de Wimax y HFC Claro Empresas
     28.0       30/09/2012  Alex Alamo                                 PROY-4886_IDEA-6033 Requerimiento programacion de instalaciones DTH, solicitud Osiptel
     29.0       05/10/2012  Hector Huaman                              SD-257329 Requerimiento programacion de instalaciones DTH, solicitud Osiptel
     30.0       10/10/2012  Edilberto Astulle                          PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
     31.0       20/10/2012  Edilberto Astulle                          PROY-3968_Optimizacion de Interface Intraway - SGA para la carga de equipos
     32.0       30/10/2012  Edilberto Astulle                          PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
     33.0       30/11/2012  Edilberto Astulle                          SD-381939
     34.0       30/12/2012  Edilberto Astulle                          SD_363631
     35.0       23/02/2013  Edilberto Astulle     PQT-143459-TSK-22535
     36.0       03/04/2013  Edilberto Astulle     PQT-136449-TSK-18852
     37.0       23/05/2013  Edilberto Astulle     PQT-155613-TSK-28885
     38.0       02/0/2013   Edilberto Astulle     PROY-9381 IDEA-11686  Seleccion Multiple
     39.0       22/08/2013  Mauro Zegarra         Guillermo Salcedo     REQ-164606: Error al generar sot de instalacion de deco adicional
     40.0       22/09/2013  Edilberto Astulle     PROY-7101 Implementar Mejoras Cambio de Plan HFC
     41.0       25/09/2013  Edilberto Astulle     PROY-4429 - Evaluacion y venta unificada - Facturacion centralizada Operaciones
     42.0       25/09/2013  Edilberto Astulle     PROY-4429 - Evaluacion y venta unificada - Facturacion centralizada Operaciones v2
     43.0       14/03/2014  Edilberto Astulle     SD-973402
     44.0       04/03/2014  Edilberto Astulle     SD_978729
     45.0       14/04/2014  Edilberto Astulle     PQT-186237-TSK-44916
     46.0       02/06/2014  Edilberto Astulle     SD_1126603
     47.0       31/07/2014  Edilberto Astulle     SD-1172651 - equipos baja sin equipos
     48.0       06/08/2014  Edilberto Astulle     SD_ 7956
     49.0       06/11/2014  Edilberto Astulle     SD_120302 Problemas en actualizacion masiva Agenda workflow SGA - Sot de baja HFC
     50.0       23/01/2015  Hector Huaman         SD_199141
     51.0       16/02/2015  Edilberto Astulle     SD-231042
     52.0       14/05/2015  Edilberto Astulle     SD-298764
     53.0       24/05/2015  Edilberto Astulle     SD-327335
     54.0       01/10/2015  Jose Varillas         Giovanni Vasquez        SD_426907
     55.0       10/09/2015  Angel Condori         Eustaquio Gibaja     Proyecto 3Play Inalambrico
     56.0       28/11/2015  Angel Condori         Eustaquio Gibaja     Proyecto 3Play Inalambrico-Pase Urgente
     57.0       23/11/2015  Dorian Sucasaca       PQT-247649-TSK-76965
     58.0       10/06/2015  Jorge Rivas/Angel Condori                  PROY-17652 Adm Manejo de Cuadrillas
     59.0       24/02/2016  Edilberto Astulle     SD_652049
     60.0       28/04/2016                                             SD-642508-1 Cambio de Plan Fase II
     61.0       04/05/2016  HITSS                                      PQT-249355-TSK-77844
     62.0       10/08/2016  Justiniano Condori    Lizbeth Portella     PROY-22818-IDEA-28605 Administración y manejo de cuadrillas  - TOA
     63.0       06/02/2017  HITSS                                      Mejoras Siac reclamos
     64.0       10/04/2017  Edwin Vasquez         Lizbeth Portella     PROY-25148 IDEA-32224 - Mejoras en los SIACs para TOA y Reclamos
     65.0       20/06/2017  Luis Guzman           Tito Huerta          PROY-27792 IDEA-34954 - Proyecto LTE
     66.0       27/10/2017                        Alfredo Yi           PROY-27792 IDEA-34954 - Proyecto LTE
     67.0       06/06/2017  Juan Olivares         Henry Huamani        PROY-26477-IDEA-33647 Mejoras en SIAC Reclamos, generación y cierre automático de SOTs
     68.0       12/09/2017  Luigi Sipion          Nalda Arotico        PROY-40032-IDEA-40030 Adap. SGA Gestor de Agendamiento/Liquidaciones para integrar con FullStack
     69.0       05/10/20018 Jeny Valencia         Jose Varillas        Portabilidad
     70.0       20/02/2019  Abel Ojeda                                 PROY-32581-Agendamiento-HFC
     71.0       19/03/2019  Roberto Quispe        Jose Varillas        PROY-32581-Cambio de Plan con Visita IC
     72.0       02/04/2019  Cesar Najarro         Cesar Najarro        SD-INC000001471706 Mantender pod idprooducto de incognito para TE
     73.0       04/04/2019                                             PROY-140228 - FUNCIONALIDADES SOBRE SERVICIOS FIJA CORPORATIVA EN SGA
  **********************************************************************************************/

  /*********************************************************************************************************************/
  --Procedimiento que crea el Agendamiento

  /*********************************************************************************************************************/
  --PROCEDURE P_crea_agendamiento(a_codsolot in number,a_fecha VARCHAR2,a_hora VARCHAR2, --3.0
  procedure p_crea_agendamiento(a_codsolot    in number,
                                a_codcon      in number,
                                a_instalador  in varchar2,
                                a_fecha       varchar2,
                                a_hora        varchar2, --3.0
                                a_observacion varchar2,
                                a_referencia  varchar2,
                                a_idtareawf   in number default null,
                                --ini 7.0
                                a_area in number default null,
                                --fin 7.0
                                a_idagenda in out number) is
    v_nomcli       varchar2(200);
    v_dirsuc       varchar2(480);
    v_codcli       varchar2(10);
    v_codubi       varchar2(10);
    v_numslc       varchar2(10);
    n_idagenda     number;
    n_estage       number;
    n_codincidence number;
    ln_codsuc      varchar2(10); --2.0
    ln_codcase     number; --2.0
    v_idplano      varchar2(10); --12.0
    n_idpaquete    number(10); --12.0
  
  begin
    begin
      select distinct a.codcli,
                      b.nomcli,
                      c.codubi,
                      nvl(e.dirsuc, d.direccion),
                      a.numslc,
                      a.recosi,
                      --ini 12.0
                      --d.codsuc --2.0 codsuc,
                      d.codsuc,
                      e.idplano,
                      d.idpaq
      --fin 12.0
        into v_codcli,
             v_nomcli,
             v_codubi,
             v_dirsuc,
             v_numslc,
             n_codincidence,
             --ini 12.0
             --ln_codsuc --2.0 ln_codsuc
             ln_codsuc,
             v_idplano,
             n_idpaquete
      --fin 12.0
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = a_codsolot
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+);
    exception
      when no_data_found then
        --NO SE OBTIENE RESULTADOS CON EL SELECT
        raise_application_error(-20001,
                                'No se encuentra informacion para la SOT a Agendar.');
    end;
    --ini 2.0 obtenemos codigo de case de incidencia
    begin
      select y.codcase
        into ln_codcase
        from incidence y
       where y.codincidence = n_codincidence;
    exception
      when no_data_found then
        ln_codcase := null;
    end;
    --fin 2.0
  
    n_estage := 1; --Generado
    --Se genera Agenda
    select sq_agendamiento.nextval into n_idagenda from dummy_ope;
    --INSERT INTO AGENDAMIENTO(CODCLI,CODSOLOT,DIRECCION,NUMSLC,codubi, codincidence, --3.0
    insert into agendamiento
      (codcli,
       codsolot,
       codcon,
       instalador,
       direccion,
       numslc,
       codubi,
       codincidence, --3.0
       fecha_instalacion,
       fecagenda,
       observacion,
       referencia,
       estage,
       idtareawf,
       idagenda,
       codsuc,
       --ini 7.0
       area,
       --fin 7.0
       --ini 12.0
       --codcase) --2.0 codsuc, codcase
       codcase,
       idplano,
       idpaq)
    --fin 12.0
    
    --VALUES (v_codcli, a_codsolot, v_dirsuc,v_numslc, v_codubi, n_codincidence, --3.0
    values
      (v_codcli,
       a_codsolot,
       a_codcon,
       a_instalador,
       v_dirsuc,
       v_numslc,
       v_codubi,
       n_codincidence, --3.0
       --ini 14.0
       --to_date(a_fecha || ' ' || a_hora, 'dd/mm/yyyy hh24:mi'),
       null,
       --fin 14.0
       to_date(a_fecha || ' ' || a_hora, 'dd/mm/yyyy hh24:mi'),
       a_observacion,
       a_referencia,
       n_estage,
       a_idtareawf,
       n_idagenda,
       ln_codsuc,
       --ini 7.0
       a_area,
       --fin 7.0
       --ini 12.0
       --ln_codcase); --2.0 ln_codsuc, ln_codcase
       ln_codcase,
       v_idplano,
       n_idpaquete);
    --fin 12.0
    --Se genera Anotacion En tarea
    if a_idtareawf is not null then
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, 'Se genero la Agenda : ' || to_char(n_idagenda));
    end if;
  
    --Genera trs de cambio de estado de agendamiento
    if n_estage <> 1 then
      pq_agendamiento.p_chg_est_agendamiento(n_idagenda, n_estage);
    end if;
    a_idagenda := n_idagenda;
  
  end p_crea_agendamiento;

  /*********************************************************************************************************************/
  --Procedimiento que cambia de estado del Agendamiento

  /*********************************************************************************************************************/
  procedure p_chg_est_agendamiento(a_idagenda       in number,
                                   a_estagenda      in number,
                                   a_estagenda_old  in number default null,
                                   a_observacion    in varchar2 default null,
                                   a_mot_solucion   in number default null,
                                   a_fecha          in date default sysdate,
                                   a_cadena_mots    in varchar2 default null,
                                   an_estado_adc    in number default null, --58.0
                                   av_ticket_remedy in varchar2 default null --68.0
                                   ) is
    --<12.0>
  
    ln_estsol_act    number;
    l_tipo           number;
    ln_tipoagenda    number;
    l_proc           number;
    l_sql            varchar2(500);
    d_fecactual      date;
    ln_codincidence  number; --6.0
    ln_valida        number; --37.0
    ln_flgliquidamo  number; --37.0
    ln_ticket_remedy varchar2(20); --68.0
  
    n_idtareawf tareawf.idtareawf%type; --9.0
  
    /*ini 58.0*/
    ln_idestado_adc number;
    ln_origen       number;
    ln_tipo_orden   operacion.tipo_orden_adc.id_tipo_orden%type;
    ln_flag_aplica  number;
    an_error        number;
    av_error        varchar2(500);
    /*fin 58.0*/
  
    --Inicio 32.0
    n_tiptra        number;
    n_codsolot      number;
    n_idtareawf_chg number;
  
    an_tipo         number; --61.0
    an_iderror      NUMERIC; --61.0
    as_mensajeerror VARCHAR2(200); --61.0
    l_observacion   agendamientochgest.observacion%type; --64.0
  
    cursor cur_tar is
      select b.tareadef, b.esttarea, c.tipesttar
        from secuencia_estados_agenda      a,
             OPERACION.CIERRE_TAREA_AGENDA b,
             esttarea                      c
       where estagendafin = a_estagenda
         and estagendaini = ln_estsol_act
         and tiptra = n_tiptra
         and a.idseq = b.idseq
         and b.esttarea = c.esttarea;
    cursor cur_act is
      select TIPTRA, CODMOT_SOLUCION, cantidad, codeta, codact
        from OPERACION.MOT_SOLUCIONXTIPTRA_ACT
      --    WHERE tiptra=  n_tiptra AND CODMOT_SOLUCION=a_mot_solucion;
       WHERE tiptra = n_tiptra
         AND CODMOT_SOLUCION in
             (select codmot_solucion
                from agendamientochgest
               where idagenda = a_idagenda); --37.0
  
    cursor cur_mat is
      select tiptra, codmot_solucion, cantidad, codeta, codmat
        from OPERACION.MOT_SOLUCIONXTIPTRA_mat
       WHERE tiptra = n_tiptra
         AND CODMOT_SOLUCION = a_mot_solucion;
    --Fin 32.0
    --Inicio 33.0
    n_total            number;
    ln_codmot_solucion number;
    n_codfor           number;
    cursor cur_motsol is
      select a.codfor, sum(a.codmot_solucion) motsol_tot
        from operacion.mot_solucionxfor a, formula b
       where a.codfor = b.codfor
         and b.flg_motsol = 1
         and a.tiptra = n_tiptra
       group by a.codfor;
    cursor cur_actmotsol is
      SELECT codact FROM actetapaxfor WHERE codfor = n_codfor;
    --Fin 33.0
  
    --53.0
    n_val_estage_area number;
    n_idagenda_cambio number;
    n_estadocambio    number;
    n_area            number;
    cursor c_estage_area is
      select tiptra,
             areaini,
             areafin,
             estagendaini,
             estagendafin,
             aplica_bitacora
        from OPERACION.ESTAGENDAAREAHFC
       where tiptra = n_tiptra
         and areaini = n_area
         and estagendaini = a_estagenda;
  
    --INI 58.0
    excep_adc EXCEPTION;
    PRAGMA EXCEPTION_INIT(excep_adc, -20099);
    --FIN 58.0
	
    --INI 73.0
    ln_resultado   number;
    --FIN 73.0	
  begin
    --raise_application_error(-20001,a_observacion );
    --Validando la observacion.
    l_observacion := a_observacion; --64.0
    if l_observacion is null or l_observacion = '' then
      --64.0
      raise_application_error(-20500,
                              'Debe ingresar un comentario para poder cambiar de estado.');
    end if;
  
    select a.codincidence,
           a.idtareawf,
           a.estage,
           a.tipo_agenda,
           b.tiptra,
           b.codsolot,
           a.area --53.0
      into ln_codincidence,
           n_idtareawf,
           ln_estsol_act,
           ln_tipoagenda,
           n_tiptra,
           n_codsolot,
           n_area --53.0
      from agendamiento a, solot b
     where a.idagenda = a_idagenda
       and a.codsolot = b.codsolot;
  
    if ln_estsol_act <> nvl(a_estagenda_old, ln_estsol_act) then
      raise_application_error(-20500,
                              'Error - El estado no coincide con el valor actual en la Base de Datos.');
    end if;
  
    select tipestage, FLG_LIQUIDAMO
      into l_tipo, ln_flgliquidamo --37.0
      from estagenda
     where estage = a_estagenda;
    d_fecactual := sysdate;
  
    --ini 12.0
    if a_estagenda in (2, 4) and
       (a_cadena_mots = 'N,N,N,N,N,N,N,N' or a_mot_solucion = 0) then
      --32.0
      raise_application_error(-20500,
                              'Error - Seleccione un motivo de Solucion.');
    end if;
    --fin 12.0
    if l_tipo = 1 then
      --Generada
      p_ejecucion_agendamiento(a_idagenda,
                               a_estagenda,
                               l_tipo,
                               l_observacion, --64.0
                               a_mot_solucion,
                               a_fecha);
    elsif l_tipo = 2 then
      -- En ejecucion
      p_ejecucion_agendamiento(a_idagenda,
                               a_estagenda,
                               l_tipo,
                               l_observacion, --64.0
                               a_mot_solucion,
                               a_fecha);
    elsif l_tipo = 3 then
      -- Cerrada
      p_cerrar_agendamiento(a_idagenda,
                            a_estagenda,
                            l_tipo,
                            l_observacion, --64.0
                            a_mot_solucion,
                            a_fecha,
                            a_cadena_mots); --<12.0>
    elsif l_tipo = 4 then
      -- Cancelada
      BEGIN
        -- 58.0
        p_cancelar_agendamiento(a_idagenda,
                                a_estagenda,
                                l_tipo,
                                l_observacion, --64.0
                                a_mot_solucion,
                                a_fecha);
        --INI 58.0
      EXCEPTION
        WHEN excep_adc THEN
          raise_application_error(-20099, SQLERRM);
      END;
      --FIN 58.0
    else
      --
      update agendamiento
         set estage = a_estagenda
       where idagenda = a_idagenda;
    end if;
  
    /*ini 58.0*/
  
    ln_flag_aplica := operacion.pq_adm_cuadrilla.f_obtiene_flag_orden_adc(a_idagenda);
    IF ln_flag_aplica = 1 THEN
      ln_idestado_adc := an_estado_adc;
      if a_estagenda = 22 then
        --reagenda
        --otiene tipo de trabajo  --
        --<61.0>
        -- Evaluar SOT
        OPERACION.pq_adm_cuadrilla.p_tipo_x_tiposerv(n_codsolot,
                                                     an_tipo,
                                                     an_iderror,
                                                     as_mensajeerror);
      
        if an_tipo = 0 then
          raise_application_error(-20001,
                                  'OPERACION.pq_agendamiento.p_chg_est_agendamiento - ' ||
                                  to_char(an_iderror) || '-' ||
                                  as_mensajeerror);
        end if;
      
        if an_tipo = 2 then
          --ce
          begin
            select t.id_tipo_orden_ce
              into ln_tipo_orden
              from operacion.agendamiento a,
                   operacion.solot        s,
                   operacion.tiptrabajo   t
             where a.idagenda = a_idagenda
               and a.codsolot = s.codsolot
               and s.tiptra = t.tiptra;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ln_tipo_orden := NULL;
            when others then
              ln_tipo_orden := NULL;
          end;
        end if;
      
        if an_tipo = 1 then
          --masivo
          begin
            select t.id_tipo_orden
              into ln_tipo_orden
              from operacion.agendamiento a,
                   operacion.solot        s,
                   operacion.tiptrabajo   t
             where a.idagenda = a_idagenda
               and a.codsolot = s.codsolot
               and s.tiptra = t.tiptra;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ln_tipo_orden := NULL;
            when others then
              ln_tipo_orden := NULL;
          end;
        end if;
        --</61.0>
        if ln_tipo_orden is null then
          an_error := -1;
          av_error := '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] Tipo de Trabajo de la Agenda ' ||
                      a_idagenda || ' No tiene asociado un Tipo de Orden.';
        
        end if;
      
        ln_idestado_adc := operacion.pq_adm_cuadrilla.f_retorna_estado_ETA_SGA('SGA',
                                                                               ln_tipo_orden,
                                                                               a_estagenda,
                                                                               null,
                                                                               ln_origen);
        l_observacion   := SGAFUN_OBT_OBS_REAGEN(l_observacion, a_fecha); --64.0
      end if;
    else
      ln_idestado_adc := null;
    end if;
    /*fin 58.0*/
    insert into agendamientochgest
      (idagenda,
       tipo,
       estado,
       fecreg,
       observacion,
       FECHAEJECUTADO,
       codmot_solucion --33.0
      ,
       idestado_adc --58.0
      ,
       ticket_remedy) --68.0
    values
      (a_idagenda,
       1,
       a_estagenda,
       d_fecactual,
       l_observacion, --64.0
       a_fecha,
       a_mot_solucion --33.0
      ,
       ln_idestado_adc --58.0
      ,
       av_ticket_remedy); --68.0
  
    --9.0 Inicio
    if n_idtareawf is not null then
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (n_idtareawf, a_observacion);
    end if;
    --9.0 fin
  
    --Ejecucion de Procedimientos segun el Estado.
    begin
      l_proc := null;
    end;
    if l_proc is not null then
      begin
        l_sql := 'begin ' || l_proc || ' ( :1, :2, :3 ); End; ';
        execute immediate l_sql
          using a_idagenda, a_estagenda_old, a_estagenda;
      exception
        when others then
          raise;
      end;
    end if;
    --Inicio 32.0
    for c_tar in cur_tar loop
      begin
        select a.idtareawf
          into n_idtareawf_chg
          from tareawfcpy a, wf b
         where a.idwf = b.idwf
           and b.codsolot = n_codsolot
           and a.tareadef = c_tar.tareadef
           and b.valido = 1; --49.0
      exception
        when no_data_found then
          n_idtareawf_chg := 0;
      end;
      if n_idtareawf_chg > 0 then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(n_idtareawf_chg,
                                         c_tar.tipesttar,
                                         c_tar.esttarea,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      end if;
    end loop;
    /*for c_act in cur_act loop
      begin
        operacion.PQ_EQU_MAT.P_cargar_act_formula(n_codsolot,c_act.codact,a_idagenda,null);
      exception
        when others then
          null;
      end;
    end loop;
    for c_mat in cur_mat loop
      begin
        operacion.PQ_EQU_MAT.P_cargar_mat_formula(n_codsolot,trim(c_mat.codmat),a_idagenda,null);
      exception
        when others then
          null;
      end;
    end loop;*/ --37.0
    --Fin 32.0
    --Inicio 37.0
    if ln_flgliquidamo = 1 then
      --Se liquida la MO al Ejecutado
      ln_valida := 0;
      for c_c in cur_motsol loop
        begin
          begin
            select sum(codmot_Solucion)
              into n_total
              from agendamientochgest
             where idagenda = a_idagenda
             group by idagenda;
          exception
            when no_data_found then
              n_total := 0;
          end;
          if c_c.motsol_tot = n_total then
            n_codfor := c_c.codfor;
            for c_c1 in cur_actmotsol loop
              begin
                ln_valida := 1;
                operacion.PQ_EQU_MAT.P_cargar_act_formula(n_codsolot,
                                                          c_c1.codact,
                                                          a_idagenda,
                                                          c_c.codfor);
              exception
                when others then
                  null;
              end;
            end loop;
          end if;
        end;
      end loop;
      if ln_valida = 0 then
        for c_act in cur_act loop
          begin
            operacion.PQ_EQU_MAT.P_cargar_act_formula(n_codsolot,
                                                      c_act.codact,
                                                      a_idagenda,
                                                      null);
          exception
            when others then
              null;
          end;
        end loop;
      end if;
    end if;
    --Fin 37.0
    for c in c_estage_area loop
      select count(1)
        into n_val_estage_area
        from OPERACION.ESTAGENDAAREAHFC a, agendamiento b
       where a.AREAINI = n_area
         and a.ESTAGENDAINI = a_estagenda
         and b.codsolot = n_codsolot
         and not b.idagenda = a_idagenda;
      if n_val_estage_area = 1 then
        --Cambiar el estado de agenda
        select b.idagenda, a.estagendafin
          into n_idagenda_cambio, n_estadocambio
          from OPERACION.ESTAGENDAAREAHFC a, agendamiento b
         where a.AREAINI = n_area
           and a.ESTAGENDAINI = a_estagenda
           and b.codsolot = n_codsolot
           and not b.idagenda = a_idagenda;
        pq_agendamiento.p_chg_est_agendamiento(n_idagenda_cambio,
                                               n_estadocambio,
                                               null,
                                               l_observacion); --64.0
      end if;
    
    end loop;

    --INI 73.0
    metasolv.pkg_asignacion_pex_unico.sgass_libera_hilo_baja_conLH(n_codsolot,ln_resultado);
    --FIN 73.0
	
  end;

  /*********************************************************************************************************************/
  --Procedimiento que ejecuta el Agendamiento

  /*********************************************************************************************************************/
  procedure p_ejecucion_agendamiento(a_idagenda     in number,
                                     a_estagenda    in number,
                                     a_tipo         in number,
                                     a_observacion  in varchar2,
                                     a_mot_solucion in number default null,
                                     a_fecha        in date default sysdate) is
  
    n_idwf        number; --9.0
    ln_num        number; --11.0
    ln_valida     number; --31.0
    t_tareawfcpy  tareawfcpy%rowtype; --31.0
    n_idtareawf   number; --31.0
    n_codcon_pext number; --31.0
    n_codsolot    number; --31.0
    --Inicio 41.0
    n_tiptra    number;
    n_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;
    --Fin 41.0
    n_idagendapext   number; --31.0
    n_customer_id    number; --41.0
    n_tarea          number; --43.0
    n_areapext       number; --46.0
    n_cont_tiptra_cp number; --47.0
    n_cont_inst      number; --47.0
    n_cont_cp        number; --47.0
    n_codsolot_max   number; --48.0
    n_deriva_agenda  number; --59.0
    n_cont_cp_ce     number;
  
    --Inicio 26.0
    v_nomcli     vtatabcli.nomcli%type;
    v_distrito   vtatabdst.nomdst%type;
    dt_fecagenda date;
    cursor cur_correo is
      select a.codigon codcon,
             a.descripcion correo,
             c.fecagenda,
             to_char(c.codsolot) sot,
             d.descripcion estadoagenda
        from opedd a, tipopedd b, agendamiento c, estagenda d
       where a.tipopedd = b.tipopedd
         and b.abrev = 'REAGCONCORREO'
         and c.idagenda = a_idagenda
         and (c.codcon = a.codigon or a.codigon = 1)
         and d.estage = a.codigon_aux
         and a.codigon_aux = a_estagenda;
    lv_texto varchar2(400);
    --Fin 26.0
    --INI 65.0
    ln_cod_id_new solot.cod_id%type;
    ln_error      number;
    lv_error      varchar2(4000);
    ln_flag       number;
    --FIN 65.0
    --Inicio 71.0
    ln_visita number;
    ln_flag2  number;
    -- Fin 71.0
    -- Inicio 72.0
    ln_flag_TE NUMBER;
    -- Fin 72.0   
  
  begin
    select b.codsolot, b.tiptra, a.idtareawf, CUSTOMER_ID, b.cod_id --41.0
      into n_codsolot, n_tiptra, n_idtareawf, n_customer_id, ln_cod_id_new --41.0
      from agendamiento a, solot b
     where a.codsolot = b.codsolot
       and a.idagenda = a_idagenda;
    if a_estagenda = 16 then
      select max(idwf)
        into n_idwf
        from agendamiento, wf
       where idagenda = a_idagenda
         and agendamiento.codsolot = wf.codsolot;
      --      if not n_tiptra=658 then--41.0
      --Inicio 47.0
      SELECT count(1)
        INTO n_cont_inst
        FROM sales.int_negocio_instancia i, vtatabslcfac f, solot s
       where i.instancia = 'PROYECTO DE VENTA'
         and i.idinstancia = f.numslc
         and f.numslc = s.numslc
         and f.idsolucion = 182
         and s.codsolot = n_codsolot;
      SELECT count(1)
        INTO n_cont_cp
        FROM operacion.siac_instancia i
       where i.Tipo_Postventa in
             (select b.descripcion
                from tipopedd a, opedd b
               where a.tipopedd = b.tipopedd
                 and a.abrev = 'OPEGENRESSIAC'
                 and b.abreviacion = '1')
         AND I.TIPO_INSTANCIA = 'SOT'
         and i.instancia = to_char(n_codsolot); --50.0
      --Fin 47.0
    
      --      if n_customer_id is null then--41.0
      if n_cont_inst = 0 and n_cont_cp = 0 then
        --47.0
        --Cambio de la agenda a "En Agenda" Genera Reservas y Codigo de Activacion IW
        if n_idwf is not null then
          select count(1)
            into ln_num
            from int_mensaje_intraway a, wf b
           where a.codsolot = b.codsolot
             and b.idwf = n_idwf;
          if ln_num = 0 then
            select count(1)
              into n_cont_cp_ce
              from operacion.solot
             where codsolot = n_codsolot
               and tiptra in
                   (select codigon
                      from opedd
                     where tipopedd in
                           (select tipopedd
                              from tipopedd
                             where abrev = 'PROY_R_IW'));
            if n_cont_cp_ce = 0 then
              --Genera codigo de Activacion IW
              INTRAWAY.PQ_SOTS_AGENDADAS.P_REGISTRA_AGENDAMIENTO(null,
                                                                 n_idwf,
                                                                 null,
                                                                 null);
              --Genera Reserva  IW
              OPERACION.PQ_CUSPE_OPE2.p_gen_reserva_iway(null,
                                                         n_idwf,
                                                         null,
                                                         null);
            end if;
          end if;
        end if;
      else
        --Si viene del SISACT Inicio 41.0
        begin
          --48.0
          select valor
            into n_codsolot_max
            from constante
           where constante = 'MAXSOTSISACTCUS';
        exception
          when no_data_found then
            n_codsolot_max := 0;
        end;
        if n_customer_id is null and n_codsolot > n_codsolot_max then
          raise_application_error(-20000,
                                  'No se Puede agendar la SOT debido a que no tiene customer_id.');
        else
          begin
            --
            begin
              select op.codigon
                into ln_flag
                from opedd op, operacion.tipopedd b
               where op.abreviacion = 'ACT_HFC_RESERVA_IC'
                 and op.tipopedd = b.tipopedd
                 and b.abrev = 'CONF_WLLSIAC_CP';
            exception
              when no_data_found then
                ln_flag := 0;
              when others then
                ln_flag := 0;
            end;
          
            begin
              -- Inicio 71.0
              select count(*)
                into ln_flag2
                from opedd op, operacion.tipopedd b
               where op.abreviacion = 'CAMB_PLAN_VST_IC_RESERVA'
                 and op.tipopedd = b.tipopedd
                 and op.codigon_aux = n_tiptra -- correccion 71.0
                 and b.abrev = 'CONF_WLLSIAC_CP';
            exception
              when no_data_found then
                ln_flag2 := 0;
              when others then
                ln_flag2 := 0;
            end; -- Fin 71.0
          
            select count(*) -- Inicio 72
              into ln_flag_TE
              from opedd op, operacion.tipopedd b
             where op.abreviacion = 'CONF_TE_HFC_SIAC'
               and op.tipopedd = b.tipopedd
               AND OP.CODIGON_AUX = n_tiptra
               and b.abrev = 'CONF_TE_HFC_SIAC'; -- Fin 72
          
            if ln_flag_TE = 1 then
              -- Inicio 72
              SGASS_REGISTRA_DATOS_ORIGEN(ln_cod_id_new, n_codsolot);
            else
              -- Fin 72
              if ln_flag != 0 then
                intraway.pq_int_cambio_plan_sisact.sgasi_execute_main(ln_cod_id_new,
                                                                      n_customer_id,
                                                                      n_codsolot,
                                                                      ln_error,
                                                                      lv_error);
              else
                OPERACION.PQ_IW_SGA_BSCS.p_gen_reserva_iw(n_idtareawf,
                                                          n_idwf,
                                                          null,
                                                          null);
                -- Inicio 71.0
                SELECT OPERACION.PQ_SIAC_CAMBIO_PLAN.SGAFUN_VALIDA_CB_PLAN_VISITA(n_codsolot)
                  INTO ln_visita -- 1 = Sin Visita  0 = Con Visita
                  FROM dual;
              
                if ln_visita = 0 and ln_flag2 = 1 then
                  INTRAWAY.pkg_activacion_incognito.SGASS_CARGA_DATA_RESERVA(n_codsolot,
                                                                             p_mensaje,
                                                                             p_error);
                end if;
                --- Fin 71.0
              end if;
            end if;
          exception
            when others then
              raise_application_error(-20000,
                                      'Error generar plantilla:' || sqlerrm);
          end;
        end if;
      end if; --Fin 41.
    end if;
  
    if a_estagenda IN (20, 29, 30) then
      --19.0
      --Cambio de la agenda a "Ejecutado Servicio" se actualiza la fecha_instalacion
      update agendamiento
         set fecha_instalacion = a_fecha
       where idagenda = a_idagenda;
    end if;
    --9.0 Fin
  
    --Inicio 26.0
    if a_estagenda = 22 then
      select b.nomcli, c.nomdst, a.fecagenda
        into v_nomcli, v_distrito, dt_fecagenda
        from agendamiento a, vtatabcli b, vtatabdst c
       where a.codcli = b.codcli
         and a.codubi = c.codubi
         and a.idagenda = a_idagenda;
      lv_texto := 'Fue Reagendado por ' || user || ' Fecha Actual: ' ||
                  TO_CHAR(a_fecha, 'dd/mm/yyyy hh24:mi:ss') || CHR(13) ||
                  ' Fecha Anterior: ' ||
                  TO_CHAR(dt_fecagenda, 'dd/mm/yyyy hh24:mi:ss') || CHR(13) ||
                  ' Distrito: ' || v_distrito || CHR(13) || ' Cliente: ' ||
                  v_nomcli || CHR(13) || ' Observacion: '; -- 58.0 || substr(a_observacion,1,1000) || CHR (13);
      lv_texto := lv_texto ||
                  substr(a_observacion, 1, 399 - LENGTH(lv_texto)) ||
                  CHR(13); -- 58.0
      --Cambio fecha de agenda por el estado Reagendado
      update agendamiento
         set fecagenda = a_fecha, numveces = numveces + 1
       where idagenda = a_idagenda;
      for c_correo in cur_correo loop
        --raise_application_error(-20000,'Ruloso.');
        p_envia_correo_de_texto_att('SOT Agenda : ' || c_correo.sot,
                                    c_correo.correo,
                                    lv_texto);
      end loop;
    end if;
    --Fin 26.0
    --59.0
    select count(1)
      into n_deriva_agenda
      from opedd a, tipopedd b
     where a.tipopedd = b.tipopedd
       and a.codigon = a_estagenda
       and b.abrev = 'OPEDERIVAAGESGA';
    if n_deriva_agenda = 1 then
      --Genera agenda PEXT
      select count(1)
        into ln_valida
        from agendamiento a, agendamientochgest b
       where a.codsolot = n_codsolot
         and a.idagenda = b.idagenda
         and b.estado = a_estagenda; --4;59.0
    
      if ln_valida = 0 then
        select *
          into t_tareawfcpy
          from tareawfcpy
         where idtareawf = n_idtareawf;
        --43.0 Inicio
        begin
          select to_number(valor)
            into n_tarea
            from constante
           where constante = 'TARAGENDAPEXT';
        exception
          when no_data_found then
            n_tarea := t_tareawfcpy.tarea;
        end;
        --46.0 Inicio
        begin
          select a.codigon
            into n_areapext
            from opedd a, tipopedd b
           where a.tipopedd = b.tipopedd
             and b.abrev = 'AREAPEXTHFCWI'
             and a.codigon_aux = n_tiptra;
        exception
          when no_data_found then
            n_areapext := 343;
        end;
        --46.0 Fin
      
        --43.0 Fin
        OPERACION.P_GENERA_TAREA_WF(t_tareawfcpy.tareadef,
                                    t_tareawfcpy.idwf,
                                    t_tareawfcpy.wfdef,
                                    t_tareawfcpy.tipo,
                                    t_tareawfcpy.plazo,
                                    n_areapext,
                                    null,
                                    null,
                                    null,
                                    n_tarea); --46.0
      
        begin
          select decode(count(1), 0, null, 1, a.codcon, null)
            into n_codcon_pext
            from distritoxcontrata a, solotpto b, solot c
           where a.codubi = b.codubi
             and c.codsolot = b.codsolot
             and a.tiptra = 496
             and c.codsolot = n_codsolot
             and a.prioridad = 1
             and a.estado = 1
             and rownum = 1
           group by codcon;
        exception
          when no_data_found then
            n_codcon_pext := 1;
        end;
        select max(idagenda)
          into n_idagendapext
          from agendamiento
         where codsolot = n_codsolot;
        update agendamiento
           set codcon = n_codcon_pext, observacion = a_observacion --38.0
         where idagenda = n_idagendapext;
        --Inicio 38.0
        insert into agendamientochgest
          (idagenda, tipo, estado, fecreg, observacion, FECHAEJECUTADO)
        values
          (n_idagendapext, 1, 1, sysdate, a_observacion, a_fecha);
        --Fin 38.0
      end if;
    end if;
    --Fin 31.0
  
    --Cambiar de Estado a Agenda
    update agendamiento
       set estage = a_estagenda, tipo_agenda = a_tipo
     where idagenda = a_idagenda;
    if f_aplica_incidencia(a_idagenda) = 1 then
      --3.0
      --Interface con Incidencia
      p_interface_incidencia(a_idagenda,
                             a_estagenda,
                             a_tipo,
                             a_observacion,
                             a_mot_solucion,
                             a_fecha);
    end if; --3.0
  end;

  /*********************************************************************************************************************/
  --Procedimiento que cancela el Agendamiento

  /*********************************************************************************************************************/
  procedure p_cancelar_agendamiento(a_idagenda     in number,
                                    a_estagenda    in number,
                                    a_tipo         in number,
                                    a_observacion  in varchar2,
                                    a_mot_solucion in number default null,
                                    a_fecha        in date default sysdate) is
  
    --INI 58.0
    ln_iderror      NUMBER;
    lv_mensajeerror VARCHAR2(3000);
    ln_codsolot     operacion.agendamiento.codsolot%TYPE;
    ln_flag_aplica  NUMBER;
    v_iderror       operacion.transaccion_ws_adc.iderror%type; --62.0
    --FIN 58.0
  begin
    --Cambiar de Estado a Agenda
    update agendamiento
       set estage = a_estagenda, tipo_agenda = a_tipo
     where idagenda = a_idagenda;
  
    if f_aplica_incidencia(a_idagenda) = 1 then
      --3.0
      p_interface_incidencia(a_idagenda,
                             a_estagenda,
                             a_tipo,
                             a_observacion,
                             a_mot_solucion,
                             a_fecha);
    end if; --3.0
    --INI 58.0
    ln_flag_aplica := operacion.pq_adm_cuadrilla.f_obtiene_flag_orden_adc(a_idagenda);
    IF ln_flag_aplica = 1 THEN
      -- Ini 62.0
      Begin
        SELECT tw.iderror
          INTO v_iderror
          FROM operacion.transaccion_ws_adc tw
         WHERE tw.idagenda = a_idagenda
           AND tw.metodo = 'cancelarOrdenSGA'
           AND tw.idtransaccion =
               (SELECT max(adc.idtransaccion)
                  FROM operacion.transaccion_ws_adc adc
                 WHERE adc.idagenda = tw.idagenda);
      EXCEPTION
        WHEN no_data_found THEN
          v_iderror := 1;
      END;
      IF v_iderror <> 0 then
        --Fin 62.0
        operacion.pq_adm_cuadrilla.p_cancela_agenda(NULL,
                                                    a_idagenda,
                                                    a_estagenda,
                                                    substr(a_observacion,
                                                           1,
                                                           30),
                                                    ln_iderror,
                                                    lv_mensajeerror);
        IF ln_iderror = -99 THEN
          raise_application_error(-20099, 'ERROR-WS: ' || lv_mensajeerror);
        END IF;
        IF ln_iderror < 0 THEN
          raise_application_error(-20001, lv_mensajeerror);
        END IF;
      END IF; -- 62.0
    END IF;
    --FIN 58.0
  end;

  /*********************************************************************************************************************/
  --Procedimiento que cierra el Agendamiento

  /*********************************************************************************************************************/
  procedure p_cerrar_agendamiento(a_idagenda     in number,
                                  a_estagenda    in number,
                                  a_tipo         in number,
                                  a_observacion  in varchar2,
                                  a_mot_solucion in number default null,
                                  a_fecha        in date default sysdate,
                                  a_cadena_mots  in varchar2 default null) is
    --<12.0>
    n_codsolot          number;
    v_cintillo          agendamiento.cintillo%type; --9.0
    v_instalador        agendamiento.instalador%type; --9.0
    v_acta              agendamiento.acta_instalacion%type; --9.0
    n_cont_tiptravalida number; --17.0
    n_tiptra            number; --17.0
  
    --Inicio 26.0
    v_nomcli     vtatabcli.nomcli%type;
    v_distrito   vtatabdst.nomdst%type;
    dt_fecagenda date;
    cursor cur_correo is
      select a.codigon codcon,
             a.descripcion correo,
             c.fecagenda,
             to_char(c.codsolot) sot,
             d.descripcion estadoagenda
        from opedd a, tipopedd b, agendamiento c, estagenda d
       where a.tipopedd = b.tipopedd
         and b.abrev = 'REAGCONCORREO'
         and c.idagenda = a_idagenda
         and (c.codcon = a.codigon or a.codigon = 1)
         and d.estage = a.codigon_aux
         and a.codigon_aux = a_estagenda;
    lv_texto varchar2(400);
    --Fin 26.0
  
    --Inicio 32.0
    cursor cur_age_cli is
      select a.idagenda, a.codsolot, a.codcon, a.area, a.estage
        from agendamiento a, solot b
       where a.codsolot = n_codsolot
         and a.codsolot = B.codsolot
         and not idagenda = a_idagenda
         and b.tiptra in (480, 489); --38.0
    --Fin 32.0
  
  begin
    select codsolot
      into n_codsolot
      from agendamiento
     where idagenda = a_idagenda;
  
    if a_estagenda = 3 then
      --Cancelado Solucionado ==> Anular SOTs
      pq_solot.p_chg_estado_solot(n_codsolot, 13, null, a_observacion);
    
      p_inserta_motivos(a_cadena_mots, a_idagenda);
    end if;
  
    --ini 12.0
    if a_estagenda = 2 then
      --Ejecutado Solucionado
      update agendamiento
         set fecha_instalacion = a_fecha, fecmod = sysdate
       where idagenda = a_idagenda;
    
      p_inserta_motivos(a_cadena_mots, a_idagenda);
      --Inicio 32.0
      for c_age in cur_age_cli loop
        update agendamiento set estage = 2 where idagenda = c_age.idagenda;
        insert into agendamientochgest
          (idagenda, tipo, estado, fecreg, observacion, FECHAEJECUTADO)
        values
          (c_age.idagenda, 1, a_estagenda, sysdate, a_observacion, a_fecha);
      end loop;
      --Fin 32.0
    end if;
    --fin 12.0
  
    --9.0 Inicio
    if a_estagenda = 6 then
      --Cambio de la agenda a "Concluido Contratista"
      select cintillo, acta_instalacion, instalador
        into v_cintillo, v_acta, v_instalador
        from agendamiento
       where idagenda = a_idagenda;
      select tiptra into n_tiptra from solot where codsolot = n_codsolot; --17.0
      select count(1)
        into n_cont_tiptravalida
        from opedd
       where tipopedd = 564 --17.0
         and codigon = n_tiptra; --17.0
      if n_cont_tiptravalida = 1 then
        --17.0
        if v_cintillo is null then
          raise_application_error(-20000,
                                  'Registrar el Numero de Cintillo.');
        end if;
        if v_acta is null then
          raise_application_error(-20000,
                                  'Registrar el Acta de Instalacion.');
        end if;
        if v_instalador is null then
          raise_application_error(-20000,
                                  'Registrar el Nombre del Instalador o la Cuadrilla que realizo el trabajo.');
        end if;
      end if; --17.0
      update agendamiento
         set fechaagendafin = sysdate
       where idagenda = a_idagenda;
    end if;
    --9.0 Fin
  
    --Inicio 26.0
    if a_estagenda = 5 then
      select b.nomcli, c.nomdst, a.fecagenda
        into v_nomcli, v_distrito, dt_fecagenda
        from agendamiento a, vtatabcli b, vtatabdst c
       where a.codcli = b.codcli
         and a.codubi = c.codubi
         and a.idagenda = a_idagenda;
      lv_texto := 'Fue Cancelado por ' || user || ' Fecha Actual: ' ||
                  TO_CHAR(a_fecha, 'dd/mm/yyyy hh24:mi:ss') || CHR(13) ||
                  ' Distrito: ' || v_distrito || CHR(13) || ' Cliente: ' ||
                  v_nomcli || CHR(13) || ' Observacion: ' ||
                  substr(a_observacion, 1, 1000) || CHR(13);
      --Cambio fecha de agenda por el estado Reagendado
      update agendamiento
         set fecagenda = a_fecha, numveces = numveces + 1
       where idagenda = a_idagenda;
      for c_correo in cur_correo loop
        --raise_application_error(-20000,'Ruloso.');
        p_envia_correo_de_texto_att('SOT se Cancela : ' || c_correo.sot,
                                    c_correo.correo,
                                    lv_texto);
      end loop;
    end if;
    --Fin 26.0
  
    --Cambiar de Estado a Agenda
    update agendamiento
       set estage = a_estagenda, tipo_agenda = a_tipo
     where idagenda = a_idagenda;
    if f_aplica_incidencia(a_idagenda) = 1 then
      --3.0
      p_interface_incidencia(a_idagenda,
                             a_estagenda,
                             a_tipo,
                             a_observacion,
                             a_mot_solucion,
                             a_fecha);
    end if; --3.0
  
  end;

  /*********************************************************************************************************************/
  --Procedimiento que re-genera Agendamiento

  /*********************************************************************************************************************/
  procedure p_re_agendar(a_idagenda    in number,
                         a_fecha       varchar2,
                         a_hora        varchar2,
                         a_observacion varchar2,
                         a_idtareawf   in number default null) is
  
  begin
    --Cambiar de Estado a Agenda
    update agendamiento
       set estage            = 14, --Reagenda
           fecha_instalacion = to_date(a_fecha || ' ' || a_hora,
                                       'dd/mm/yyyy hh24:mi')
     where idagenda = a_idagenda;
    --Se genera Anotacion En tarea
    if a_idtareawf is not null then
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, 'Reagenda:' || a_observacion);
    end if;
  end;

  /*********************************************************************************************************************/
  --Procedimiento que genera el agendamiento

  /*********************************************************************************************************************/
  procedure p_genera_agenda(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) is
    n_codsolot    number;
    n_idagenda    number;
    v_mensaje_err varchar2(4000);
    n_error       number;
    --ini 7.0
    ln_area areaope.area%type;
    --fin 7.0
    --ini 14.0
    ldt_Feccom date;
    --fin 14.0
    --INI 58.0
    ln_flag_aplica  NUMERIC := 0;
    ln_iderror      NUMERIC;
    lv_mensajeerror VARCHAR2(3000);
    --FIN 58.0
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    --ini 14.0
    select NVL(feccom, sysdate)
      into ldt_feccom
      from solot
     where codsolot = n_codsolot;
    --fin 14.0
    --ini 7.0
    select area into ln_area from tareawf where idtareawf = a_idtareawf;
    --fin 7.0
    begin
      --Se agenda automaticamente
      --P_crea_agendamiento(n_codsolot,to_char(sysdate,'dd/mm/yyyy'),'00:00','','',a_idtareawf,n_idagenda);--3.0
      p_crea_agendamiento(n_codsolot,
                          null,
                          null,
                          -- ini 14.0
                          --to_char(sysdate, 'dd/mm/yyyy'),
                          --'00:00',
                          to_char(ldt_feccom, 'dd/mm/yyyy'),
                          to_char(ldt_feccom, 'hh24:mi'),
                          -- fin 14.0
                          '',
                          '',
                          a_idtareawf,
                          --ini 7.0
                          ln_area,
                          --fin 7.0
                          n_idagenda); --3.0
    exception
      when others then
        raise_application_error(-20001,
                                'Error al Generar la Agenda : ' || sqlerrm);
    end;
    -- Ini 58.0
    -- Validando si pertenece al Flujo de Oracle Field Service(EtaDirect)
    operacion.pq_adm_cuadrilla.p_valida_flujo_adc(n_idagenda,
                                                  ln_flag_aplica,
                                                  ln_iderror,
                                                  lv_mensajeerror);
    --si tiene el flujo ADC genera la OT
    IF ln_flag_aplica = 1 THEN
      UPDATE operacion.agendamiento
         SET flg_adc = 1
       WHERE idagenda = n_idagenda;
    
      --se invoca el procedimiento para generar OT en ADC
      operacion.pq_adm_cuadrilla.p_genera_ot_adc(n_codsolot,
                                                 n_idagenda,
                                                 ln_iderror,
                                                 lv_mensajeerror);
    ELSE
      -- Fin 58.0
      begin
        --Se Asigna contrata
        pq_agendamiento.p_asigna_contrataxdistrito(n_idagenda,
                                                   n_codsolot,
                                                   v_mensaje_err,
                                                   n_error);
      exception
        when others then
          raise_application_error(-20001,
                                  'Error al Asignar Contrata : ' ||
                                  v_mensaje_err);
      end;
    END IF; --58.0
  end;

  /*********************************************************************************************************************/
  --Procedimiento que asigna la contrata po distrito

  /*********************************************************************************************************************/
  procedure p_asigna_contrataxdistrito(a_idagenda in number,
                                       a_codsolot in number,
                                       o_mensaje  in out varchar2,
                                       o_error    in out number) is
    n_codcon number;
  
  begin
    --Identificar Contrata a Asignar
    begin
      select decode(count(1), 0, null, 1, a.codcon, null)
        into n_codcon
        from distritoxcontrata a, solotpto b, solot c
       where a.codubi = b.codubi
         and c.codsolot = b.codsolot
         and a.tiptra = c.tiptra --4.0
         and c.codsolot = a_codsolot
         and a.prioridad = 1 --5.0
            -- ini 14.0
         and a.estado = 1
      -- fin 14.0
       group by codcon;
    exception
      when no_data_found then
        o_mensaje := 'No tiene configurado Contrata para ese distrito.';
        o_error   := -20700;
    end;
    --Asignar Contrata basado en Distrito
    update agendamiento set codcon = n_codcon where idagenda = a_idagenda;
  end;

  /*********************************************************************************************************************/
  --Procedimiento genera agenda sin contrata
  /*********************************************************************************************************************/
  procedure p_gen_agenda_sin_asignar(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    n_codsolot number;
    n_idagenda number;
    --ini 7.0
    ln_area areaope.area%type;
    --fin 7.0
    --ini 11.0
    ln_num_wf_cancelado number;
    --fin 11.0
    --INI 58.0
    ln_flag_aplica  NUMERIC := 0;
    ln_iderror      NUMERIC;
    lv_mensajeerror VARCHAR2(3000);
    --FIN 58.0
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    --ini 7.0
    select area into ln_area from tareawf where idtareawf = a_idtareawf;
    --fin 7.0
    --ini 11.0
    --se cancelan las agendas generadas en wf cancelados de la misma SOT
    --ocurre cuando hay reasignacion de wf
    select count(1)
      into ln_num_wf_cancelado
      from wf
     where codsolot = n_codsolot
       and valido = 0;
  
    if ln_num_wf_cancelado > 0 then
      p_cancela_agenda_wf_ant(n_codsolot);
    end if;
    --fin 11.0
    begin
      --Se agenda automaticamente
      --P_crea_agendamiento(n_codsolot,to_char(sysdate,'dd/mm/yyyy'),'00:00','','',a_idtareawf,n_idagenda);--3.0
      p_crea_agendamiento(n_codsolot,
                          null,
                          null,
                          to_char(sysdate, 'dd/mm/yyyy'),
                          '00:00',
                          '',
                          '',
                          a_idtareawf,
                          --ini 7.0
                          ln_area,
                          --fin 7.0
                          n_idagenda); --3.0
    
      -- Ini 58.0
      -- Validando si pertenece al Flujo de Oracle Field Service(EtaDirect)
      operacion.pq_adm_cuadrilla.p_valida_flujo_adc(n_idagenda,
                                                    ln_flag_aplica,
                                                    ln_iderror,
                                                    lv_mensajeerror);
      --si tiene el flujo ADC genera la OT
      IF ln_flag_aplica = 1 THEN
        UPDATE operacion.agendamiento
           SET flg_adc = 1
         WHERE idagenda = n_idagenda;
      
        --se invoca el procedimiento para generar OT en ADC
        operacion.pq_adm_cuadrilla.p_genera_ot_adc(n_codsolot,
                                                   n_idagenda,
                                                   ln_iderror,
                                                   lv_mensajeerror);
      
      END IF;
      -- Fin 58.0
    
    exception
      when others then
        raise_application_error(-20001,
                                'Error al Generar la Agenda : ' || sqlerrm);
    end;
  
  end;

  /*********************************************************************************************************************/
  --Procedimiento que actualiza la incidencia segun agendamiento

  /*********************************************************************************************************************/
  procedure p_interface_incidencia(a_idagenda     in number,
                                   a_estagenda    in number,
                                   a_tipo         in number,
                                   a_observacion  in varchar2,
                                   a_mot_solucion in number default null,
                                   a_fecha        in date default sysdate) is
    v_codcnt             varchar2(8);
    v_deliveruser        varchar2(30);
    n_deliverdepartment  number;
    n_receiverdepartment number;
    n_codsequence        number;
    n_codstatus          number;
    v_service            varchar2(30);
    n_codinseqtype       number;
    n_codcase            number;
    n_codsubtype         number;
    n_tiptra             number;
    --46.0
    n_codsolot number;
    cursor c_inc_det is
      select a.codincidence, b.codcli
        from solotpto a, inssrv b
       where codsolot = n_codsolot
         and a.codincidence is not null
         and a.codinssrv = b.codinssrv
      union
      select a.recosi, a.codcli
        from solot a
       where a.codsolot = n_codsolot;
  begin
    select a.codcnt, s.tiptra, s.codsolot --46.0
      into v_codcnt, n_tiptra, n_codsolot
      from agendamiento a, solot s
     where a.codsolot = s.codsolot
       and a.idagenda = a_idagenda;
  
    for c_inc in c_inc_det loop
      --46.0
      begin
        select a.lastdeliveruser,
               a.lastdeliverdepartment,
               codsequence,
               a.codstatus,
               a.codcase,
               a.codsubtype
          into v_deliveruser,
               n_deliverdepartment,
               n_codsequence,
               n_codstatus,
               n_codcase,
               n_codsubtype
          from incidence a
         where a.codincidence = c_inc.codincidence;
        --ini 2.0
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'La Sot no tiene asociada una Incidencia. IDAgenda:' ||
                                  to_char(a_idagenda) || ' ' || sqlerrm);
      end;
      --fin 2.0
      n_codinseqtype := 1; --Por defecto son derivaciones
      --Obtener el n_receiverdepartment
      select receiverdepartment, service
        into n_receiverdepartment, v_service
        from incidence_sequence
       where codincidence = c_inc.codincidence
         and codsequence = n_codsequence;
      begin
        select codstatus
          into n_codstatus
          from conf_incixage
         where tiptra = n_tiptra
           and estage = a_estagenda
           and codsubtype = n_codsubtype;
      exception
        when no_data_found then
          n_codstatus := n_codstatus;
      end;
    
      if a_estagenda = 4 then
        --Derivado Planta Externa
        null;
      elsif a_estagenda = 2 or a_estagenda = 3 then
        --Ejecutado o Cancelado Solucionado
        --Actualizar fecha de ejecucion de operaciones en la incidencia
        update incidence
           set fecha_opera = a_fecha
         where codincidence = c_inc.codincidence;
      elsif a_estagenda = 1 then
        --Generado
        n_codinseqtype := 2; --Anotacion
      end if;
    
      begin
        --Actualizar la Incidencia
        insert into incidence_sequence
          (codincidence,
           userid,
           contactcode,
           customercode,
           service,
           deliveruser,
           observation,
           codcase,
           codtypeatention,
           codincseqtype,
           codstatus,
           deliverdepartment,
           receiverdepartment,
           codmot_solucion,
           sequencedate)
        values
          (c_inc.codincidence,
           user,
           v_codcnt,
           c_inc.codcli,
           v_service,
           v_deliveruser,
           a_observacion,
           n_codcase,
           0,
           n_codinseqtype,
           n_codstatus,
           n_deliverdepartment,
           n_receiverdepartment,
           a_mot_solucion,
           a_fecha);
      exception
        when others then
          raise_application_error(-20001,
                                  'Error interface Agenda Incidencia : ' ||
                                  sqlerrm);
      end;
    
    end loop;
  end;

  --ini 2.0
  /*********************************************************************************************************************/

  --Procedimiento genera asignar a la agenda la Contrata TELMEX

  /*********************************************************************************************************************/

  procedure p_asigna_contrata_telmex(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number)
  
   is
  
    n_codsolot number;
    n_idagenda number;
    lc_numslc  vtatabslcfac.numslc%type;
  
    lc_codmotivo_tf vtatabprecon.codmotivo_tf%type;
  
  begin
  
    select codsolot into n_codsolot from wf where idwf = a_idwf;
  
    update agendamiento
       set codcon = 1 --Telmex
     where codsolot = n_codsolot
          --ini 11.0
       and ((idtareawf is null) or
           (idtareawf in
           (select idtareawf from tareawf where idwf = a_idwf)));
    --fin 11.0
  exception
    when others then
      null;
  end;
  -- fin 2.0

  --ini 3.0
  procedure p_carga_masiva_agenda(a_idcarga    number,
                                  an_cod_error in out number,
                                  av_des_error in out varchar2) is
  
    ln_idagenda  agendamiento.idagenda%type;
    lv_fecha     varchar2(100);
    lv_hora      varchar2(100);
    lv_des_error varchar2(4000);
  
    cursor cur_carga is
      select *
        from ope_agenda_masiva_reg
       where idcarga = a_idcarga
       order by orden;
  begin
    for c_carga in cur_carga loop
      select to_char(c_carga.fec_prog, 'dd/mm/yyyy') fecha,
             to_char(c_carga.fec_prog, 'hh24:mi') hora
        into lv_fecha, lv_hora
        from dummy_ope;
      begin
        ln_idagenda := null;
        --se crea agenda
        p_crea_agendamiento(c_carga.codsolot,
                            c_carga.codcon,
                            c_carga.instalador,
                            lv_fecha,
                            lv_hora,
                            'Carga masiva',
                            null,
                            null,
                            --ini 7.0
                            null,
                            --fin 7.0
                            ln_idagenda);
      
        --se actualiza registro a procesado
        update ope_agenda_masiva_reg
           set idagenda = ln_idagenda, estado = 1 --procesado
         where idcarga = c_carga.idcarga
           and orden = c_carga.orden;
      exception
        when others then
          --se guarda error
          lv_des_error := substr(sqlerrm, 12);
        
          update ope_agenda_masiva_reg
             set idagenda    = ln_idagenda,
                 estado      = 2, --error proceso
                 observacion = lv_des_error
           where idcarga = c_carga.idcarga
             and orden = c_carga.orden;
      end;
    
    end loop;
  
  exception
    when others then
      an_cod_error := sqlcode;
      if an_cod_error = -20000 then
        av_des_error := substr(sqlerrm, 12);
      else
        av_des_error := substr(sqlerrm, 12) || ' (' ||
                        dbms_utility.format_error_backtrace || ')';
      end if;
  end;

  function f_aplica_incidencia(an_idagenda agendamiento.idagenda%type)
    return number is
  
    ln_tiptra       tiptrabajo.tiptra%type;
    ln_codincidence incidence.codincidence%type;
    ln_cont         number;
  begin
    select b.tiptra, b.recosi
      into ln_tiptra, ln_codincidence
      from agendamiento a, solot b
     where a.codsolot = b.codsolot
       and idagenda = an_idagenda;
  
    --se verifica si tiene incidencia asociada
    if ln_codincidence is not null then
      --se verifica si el tipo de trabajo de la sot esta configurado en atc
      select count(1)
        into ln_cont
        from conf_incixage
       where tiptra = ln_tiptra;
    
      if ln_cont > 0 then
        return 1;
      else
        return 0;
      end if;
    else
      --la sot no tiene incidencia
      return 0;
    end if;
  exception
    when others then
      return 0;
  end;
  --fin 3.0
  --4.0
  procedure p_actualiza_contrata(an_idagenda agendamiento.idagenda%type,
                                 an_codcon   agendamiento.codcon%type) is
  begin
  
    update agendamiento
       set codcon = an_codcon
     where idagenda = an_idagenda;
  
  end;
  --fin 4.0

  --Ini 8.0
  procedure p_asigna_contrataxplano(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) is
    ln_codcon   number;
    ln_idagenda agendamiento.idagenda%type;
    ln_codsolot solot.codsolot%type;
  
  Begin
    --Identificar Contrata a Asignar
    select codsolot into ln_codsolot from wf where idwf = a_idwf;
  
    begin
      select idagenda
        into ln_idagenda
        from agendamiento
       where codsolot = ln_codsolot
            --ini 11.0
         and ((idtareawf is null) or
             (idtareawf in
             (select idtareawf from tareawf where idwf = a_idwf)));
      --fin 11.0
    exception
      when others then
        raise_application_error(-20001,
                                'Error al encontrar agenda. ' || sqlerrm);
    end;
  
    begin
      select pxc.codcon
        into ln_codcon
        from OPE_PLANOXCONTRATA_REL pxc,
             solotpto               spto,
             solot                  s,
             inssrv                 i,
             vtasuccli              v
       where pxc.idplano = v.idplano
         and s.codsolot = spto.codsolot
         and spto.codinssrv = i.codinssrv
         and i.codsuc = v.codsuc
         and pxc.tiptra = s.tiptra
         and s.codsolot = ln_codsolot
         and pxc.prioridad = 1
       group by codcon;
    exception
      when others then
        ln_codcon := 1; --Contrata Telmex
    end;
    --Asignar Contrata basado en Plano
    update agendamiento
       set codcon = ln_codcon
     where idagenda = ln_idagenda;
  End;
  --Fin 8.0

  --Ini 9.0
  /*********************************************************************************************************************/
  --Procedimiento genera agenda en blanco
  /*********************************************************************************************************************/
  procedure p_gen_agenda_en_blanco(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
    n_codsolot number;
    n_idagenda number;
    ln_area    areaope.area%type;
    --ini 11.0
    ln_num_wf_cancelado number;
    --fin 11.0
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    select area into ln_area from tareawf where idtareawf = a_idtareawf;
    --ini 11.0
    --se cancelan las agendas generadas en wf cancelados de la misma SOT
    --ocurre cuando hay reasignacion de wf
    select count(1)
      into ln_num_wf_cancelado
      from wf
     where codsolot = n_codsolot
       and valido = 0;
  
    if ln_num_wf_cancelado > 0 then
      p_cancela_agenda_wf_ant(n_codsolot);
    end if;
    --fin 11.0
    begin
      --Se agenda automaticamente
      p_crea_agenda_sin_fecha(n_codsolot,
                              null,
                              null,
                              '',
                              '',
                              a_idtareawf,
                              ln_area,
                              n_idagenda);
    exception
      when others then
        raise_application_error(-20001,
                                'Error al Generar la Agenda : ' || sqlerrm);
    end;
  
  end;

  procedure p_crea_agenda_sin_fecha(a_codsolot    in number,
                                    a_codcon      in number,
                                    a_instalador  in varchar2,
                                    a_observacion varchar2,
                                    a_referencia  varchar2,
                                    a_idtareawf   in number default null,
                                    a_area        in number default null,
                                    a_idagenda    in out number) is
    v_nomcli       varchar2(200);
    v_dirsuc       varchar2(480);
    v_codcli       varchar2(10);
    v_codubi       varchar2(10);
    v_numslc       varchar2(10);
    n_idagenda     number;
    n_estage       number;
    n_codincidence number;
    ln_codsuc      varchar2(10);
    ln_codcase     number;
    --ini 13.0
    v_idplano   varchar2(10);
    n_idpaquete number(10);
    --fin 13.0
  begin
    begin
      select distinct a.codcli,
                      b.nomcli,
                      c.codubi,
                      nvl(e.dirsuc, d.direccion),
                      a.numslc,
                      a.recosi,
                      d.codsuc,
                      --ini 13.0
                      c.idplano,
                      d.idpaq
      --fin 13.0
        into v_codcli,
             v_nomcli,
             v_codubi,
             v_dirsuc,
             v_numslc,
             n_codincidence,
             ln_codsuc,
             v_idplano,
             n_idpaquete
      
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = a_codsolot
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+);
    exception
      when no_data_found then
        --NO SE OBTIENE RESULTADOS CON EL SELECT
        raise_application_error(-20001,
                                'No se encuentra informacion para la SOT a Agendar.');
    end;
    begin
      select y.codcase
        into ln_codcase
        from incidence y
       where y.codincidence = n_codincidence;
    exception
      when no_data_found then
        ln_codcase := null;
    end;
  
    n_estage := 1; --Generado
    --Se genera Agenda
    select sq_agendamiento.nextval into n_idagenda from dummy_ope;
    insert into agendamiento
      (codcli,
       codsolot,
       codcon,
       instalador,
       direccion,
       numslc,
       codubi,
       codincidence,
       observacion,
       referencia,
       estage,
       idtareawf,
       idagenda,
       codsuc,
       area,
       codcase,
       --ini 13.0
       idplano,
       idpaq)
    --fin 13.0
    values
      (v_codcli,
       a_codsolot,
       a_codcon,
       a_instalador,
       v_dirsuc,
       v_numslc,
       v_codubi,
       n_codincidence,
       a_observacion,
       a_referencia,
       n_estage,
       a_idtareawf,
       n_idagenda,
       ln_codsuc,
       a_area,
       ln_codcase,
       --ini 13.0
       v_idplano,
       n_idpaquete);
    --fin 13.0
  
    if f_es_puerta_puerta(a_codsolot) = 1 then
      --Si es Puerta a Puerta se tiene que cambiar de estado
      n_estage := 19; --Agenda Puerta Puerta
    end if;
  
    --Genera trs de cambio de estado de agendamiento
    if n_estage <> 1 then
      pq_agendamiento.p_chg_est_agendamiento(n_idagenda,
                                             n_estage,
                                             null,
                                             'Asignado por Puerta a Puerta');
    end if;
    a_idagenda := n_idagenda;
  
  end p_crea_agenda_sin_fecha;

  /*********************************************************************************************************************/
  -- Funcion que determina si el Proyecto es Puerta a Puerta
  /*********************************************************************************************************************/
  FUNCTION f_es_puerta_puerta(a_codsolot IN NUMBER) RETURN NUMBER IS
    v_numslc       vtatabslcfac.numslc%type;
    v_codmotivo_tf vtatabprecon.codmotivo_tf%type;
  BEGIN
    select numslc into v_numslc from solot where codsolot = a_codsolot;
    if v_numslc is not null then
      select codmotivo_tf
        into v_codmotivo_tf
        from vtatabprecon
       where numslc = v_numslc;
    end if;
  
    If v_codmotivo_tf = '029' then
      --Puerta Puerta
      return 1;
    End If;
    return 0;
    --ini 10.0
  EXCEPTION
    when others then
      return 0;
      --fin 10.0
  END;

  --Fin 9.0
  --ini 11.0
  procedure p_cancela_agenda_wf_ant(a_codsolot solot.codsolot%type) is
  begin
    update agendamiento
       set estage = 5 --se cambia a estado cancelado
     where idtareawf in (select a.idtareawf
                           from tareawf a, wf b
                          where a.idwf = b.idwf
                            and b.codsolot = a_codsolot
                            and b.valido = 0) --wf cancelado
       and estage in
           (select estage from estagenda where tipestage in (1, 2)); --generada, en ejecucion
  end;
  --fin 11.0

  --ini 12.0
  procedure p_asig_contrata(an_idagenda agendamiento.idagenda%type,
                            an_codcon   agendamiento.codcon%type,
                            av_obs      agendamientochgest.observacion%type) is
  
    /* n_estagenda number;
    n_tipo number;--44.0
    v_asignrotpigms varchar2(3);--49.0
    v_numero varchar2(30);--49.0
    n_codsolot number;--49.0
    n_codinssrv number;--49.0
    n_valida number;--49.0  */
    --Ini 52.0
    n_estage_nuevo  NUMBER;
    v_asignrotpigms VARCHAR2(3);
    v_numero        VARCHAR2(30);
    n_codsolot      NUMBER;
    n_valida        NUMBER;
    v_tipsrv        VARCHAR2(4);
    v_codubi        VARCHAR2(10);
    v_mensaje       VARCHAR2(400);
    n_codest        number;
    v_centro        VARCHAR2(4);
    v_almacen       VARCHAR2(4);
    n_codcon_ant    number;
    n_codinssrv     number;
    n_estage        number;
    --Fin 52.0
  begin
    --Ini 52.0
    /* update agendamiento
         set codcon = an_codcon
       where idagenda = an_idagenda;
      select estage
        into n_estagenda
        from agendamiento
       where idagenda = an_idagenda;
    
      if av_obs is not null then
        p_chg_est_agendamiento(an_idagenda,
                               n_estagenda,
                               null,
                               av_obs,
                               null,
                               sysdate);
      end if;
      --Inicio 44.0
      begin
        select a.codigon_aux,a.codigoc,c.codsolot into n_tipo,v_asignrotpigms,n_codsolot--49.0
        from opedd a, tipopedd b, solot c , agendamiento d
        where a.tipopedd=b.tipopedd and c.codsolot= d.codsolot
        and d.idagenda=an_idagenda
        and b.abrev='ASIGCONCAMESTAGE' and a.codigon= c.tiptra and rownum=1;
      exception
        when no_data_found then
        n_tipo:=0;
      end;
      if not n_tipo=0 then
         p_chg_est_agendamiento(an_idagenda,n_tipo,null,
                       'Cambio automatico de estado de Agenda por asignacion de contrata.'
                       ,null,sysdate);
         if v_asignrotpigms='X' then--Asigno Numero en base al almacen  49.0
           n_valida:=1;
           begin
              select MIN(F.NUMERO) into v_numero
              from DEPTXCONTRATA B,Z_MM_CONFIGURACION C,VTATABDST D, SOLOT E, NUMTEL F
              WHERE B.IDSUCXCONTRATA=C.OPERADOR   AND B.CODEST=D.CODEST AND D.CODPAI='51'
              AND C.flg_tpi='1' AND B.CODCON=an_codcon
             AND D.CODUBI =E.CODUBI AND E.codsolot= n_codsolot
              AND F.ALMACEN=C.ALMACEN AND F.ESTNUMTEL=1;
           exception
              when no_data_found then
               n_valida:=0;
           end;
           if n_valida=1 then
             select b.codinssrv into n_codinssrv from solotpto a,inssrv b
             where a.codinssrv=b.codinssrv and a.codsolot=n_codsolot and b.tipinssrv=3 and rownum=1;
             update inssrv set numero= v_numero where codinssrv =n_codinssrv;
             update numtel set estnumtel=2,codinssrv=n_codinssrv,fecasg=sysdate where numero=v_numero;
           end if;
         end if;
      end if;
    
      --Fin 44.0
    */
    --Fin 52.0
    --Ini 52.0
    select codcon, estage
      into n_codcon_ant, n_estage
      from agendamiento
     where idagenda = an_idagenda;
    if an_codcon = n_codcon_ant then
      return;
    end if;
    UPDATE agendamiento
       SET codcon = an_codcon
     WHERE idagenda = an_idagenda;
  
    BEGIN
      SELECT a.codigon_aux,
             a.codigoc,
             c.codsolot,
             c.tipsrv,
             d.codubi,
             e.codest,
             g.codinssrv,
             g.numero
        INTO n_estage_nuevo,
             v_asignrotpigms,
             n_codsolot,
             v_tipsrv,
             v_codubi,
             n_codest,
             n_codinssrv,
             v_numero
        FROM opedd        a,
             tipopedd     b,
             solot        c,
             agendamiento d,
             vtatabdst    e,
             solotpto     f,
             inssrv       g
       WHERE a.tipopedd = b.tipopedd
         AND c.codsolot = d.codsolot
         AND d.idagenda = an_idagenda
         AND b.abrev = 'ASIGCONCAMESTAGE'
         AND a.codigon = c.tiptra
         and c.codsolot = f.codsolot
         and f.codinssrv = g.codinssrv
         and g.tipinssrv = 3
         and a.abreviacion = c.tipsrv
         and d.codubi = e.codubi
         AND rownum = 1;
    EXCEPTION
      WHEN no_data_found THEN
        n_estage_nuevo := 0;
    END;
  
    IF NOT n_estage_nuevo = 0 THEN
      --existe configuracion
      if v_tipsrv = '0059' then
        --TPI GSM
        if not an_codcon = n_codcon_ant then
          --Limpiar la SID y liberar el numero
          update numtel
             set estnumtel = 1, codinssrv = null, fecasg = null
           where numero = v_numero;
          update inssrv set numero = null where codinssrv = n_codinssrv;
          if an_codcon = 1 then
            --Si es cuadrilla propia salir del proceso
            pq_agendamiento.p_chg_est_agendamiento(an_idagenda,
                                                   1,
                                                   NULL,
                                                   'Cambio de Estado por asignacion de contrata propia.',
                                                   NULL,
                                                   SYSDATE);
            return;
          end if;
        end if;
        begin
          select codigoc centro, abreviacion almacen
            into v_centro, v_almacen
            from opedd a, tipopedd b
           where a.tipopedd = B.Tipopedd
             and b.abrev = 'CEALTPIGSM'
             and codigon = n_codest
             and codigon_aux = an_codcon;
        exception
          WHEN no_data_found THEN
            return;
        end;
      
        n_valida := 1;
        BEGIN
          select min(numero)
            into v_numero
            from numtel
           where centro = v_centro
             and almacen = v_almacen
             and estnumtel = 1
             and codinssrv is null
             and simcard is not null;
        EXCEPTION
          WHEN no_data_found THEN
            n_valida := 0;
        END;
        IF n_valida = 1 and v_numero is not null THEN
          update numtel
             set estnumtel = 2, codinssrv = n_codinssrv, fecasg = sysdate
           where numero = v_numero;
          update inssrv
             set numero = v_numero
           where codinssrv = n_codinssrv;
          pq_agendamiento.p_chg_est_agendamiento(an_idagenda,
                                                 n_estage_nuevo,
                                                 NULL,
                                                 'Cambio automatico de estado de Agenda por asignacion de contrata.',
                                                 NULL,
                                                 SYSDATE);
        END IF;
        if n_valida = 0 then
          pq_agendamiento.p_chg_est_agendamiento(an_idagenda,
                                                 1,
                                                 NULL,
                                                 'La contrata asignada no tiene numero telefonico disponible.',
                                                 NULL,
                                                 SYSDATE);
        end if;
      
      END IF;
    else
      IF av_obs IS NOT NULL THEN
        pq_agendamiento.p_chg_est_agendamiento(an_idagenda,
                                               n_estage,
                                               NULL,
                                               av_obs,
                                               NULL,
                                               SYSDATE);
      END IF;
    END IF;
    --Fin  52.0
  end;

  Procedure p_inserta_motivos(av_cadena_mot in varchar2,
                              an_idagenda   agendamiento.idagenda%type) is
    ls_cable             varchar2(3);
    ls_internet          varchar2(3);
    ls_telefonia         varchar2(3);
    ls_cable_internet    varchar2(3);
    ls_cable_tel         varchar2(3);
    ls_telf_internet     varchar2(3);
    ls_telf_internet_cab varchar2(3);
    ls_pext              varchar2(3);
  Begin
    ls_cable             := operacion.f_cb_subcadena2(av_cadena_mot, 1);
    ls_internet          := operacion.f_cb_subcadena2(av_cadena_mot, 2);
    ls_telefonia         := operacion.f_cb_subcadena2(av_cadena_mot, 3);
    ls_cable_internet    := operacion.f_cb_subcadena2(av_cadena_mot, 4);
    ls_cable_tel         := operacion.f_cb_subcadena2(av_cadena_mot, 5);
    ls_telf_internet     := operacion.f_cb_subcadena2(av_cadena_mot, 6);
    ls_telf_internet_cab := operacion.f_cb_subcadena2(av_cadena_mot, 7);
    ls_pext              := operacion.f_cb_subcadena2(av_cadena_mot, 8);
  
    IF ls_internet <> 'N' THEN
      UPDATE agendamiento
         SET motsol_int = to_number(ls_internet)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_cable <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_CAB = to_number(ls_cable)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_telefonia <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_TEL = to_number(ls_telefonia)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_cable_internet <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_INTCAB = to_number(ls_cable_internet)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_cable_tel <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_CABINT = to_number(ls_cable_tel)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_telf_internet <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_INTTEL = to_number(ls_telf_internet)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_telf_internet_cab <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_INTTELCAB = to_number(ls_telf_internet_cab)
       WHERE idagenda = an_idagenda;
    END IF;
  
    IF ls_pext <> 'N' THEN
      UPDATE agendamiento
         SET MOTSOL_PEXT = to_number(ls_pext)
       WHERE idagenda = an_idagenda;
    END IF;
  
  End;
  --fin 12.0

  --Ini 13.0
  procedure p_actualiza_fec_progra(an_idagenda  agendamiento.idagenda%type,
                                   ad_fecagenda agendamiento.fecagenda%type) is
    v_codsolot solot.codsolot%type;
    --ini 20.0
    n_nrodecos    number;
    v_numslc      vtatabslcfac.numslc%type;
    v_ubigeo      varchar2(30);
    v_tiptra      tiptrabajo.tiptra%type;
    n_idsolucion  soluciones.idsolucion%type;
    v_fecprog     solot.feccom%type;
    v_sec         inssrv.numero%type;
    v_valida_cfg  number;
    v_valida_user number;
    v_cont        number;
  
    --Inicio 21.0
    li_soldth       number;
    P_CONTRATA      VARCHAR2(300);
    P_IDCONTRATA    NUMBER;
    P_DESCRIPCION_F VARCHAR2(300);
    P_FECHA_AGENDA  VARCHAR2(300);
    P_FRANJA        NUMBER;
    P_COD_RESP      VARCHAR2(300);
    P_MENSAJE       VARCHAR2(300);
    --Fin 21.0
    v_contrata varchar2(100); --22.0
    v_cod_resp varchar2(30); --22.0
    v_mensaje  varchar2(30); --22.0
  Begin
  
    --Inicio 19.0 envio a WEB UNI
    -- commit;
    --Obtener Contrata
    begin
      --22.0
      select d.ubigeo,
             b.tiptra,
             c.idsolucion,
             c.numslc,
             b.feccom,
             b.codsolot,
             e.descripcion
        into v_ubigeo,
             v_tiptra,
             n_idsolucion,
             v_numslc,
             v_fecprog,
             v_codsolot,
             v_contrata
        from agendamiento a,
             solot        b,
             vtatabslcfac c,
             vtatabdst    d,
             contrata     e
       where a.idagenda = an_idagenda
         and rownum = 1
         and a.codsolot = b.codsolot
         and b.numslc = c.numslc
         and a.codubi = d.codubi
         and a.codcon = e.codcon;
    exception
      when others then
        li_soldth := 0;
    end; --22.0
  
    li_soldth := sales.pq_dth_postventa.f_obt_solucion_dth(n_idsolucion);
    --Inicio 21.0
    if li_soldth = 1 then
      select count(1)
        into v_valida_user
        from opedd
       where tipopedd = 578
         and codigoc = user;
      if v_valida_user = 0 then
        return;
      end if;
      select count(1)
        into v_valida_cfg
        from opedd
       where tipopedd = 571
         and codigon = v_tiptra
         and codigon_aux = n_idsolucion;
      if v_valida_cfg = 0 then
        return;
      end if;
      select count(1)
        into v_cont
        from opedd
       where tipopedd = 570
         and codigon = v_tiptra;
      if v_cont = 0 then
        raise_application_error(-20001,
                                'El tipo de Trabajo de la SOT no se encuentra habilitada para esta funcionalidad.');
      end if;
      --Numero de Decos
      select count(*)
        into n_nrodecos
        from vtadetptoenl
       where numslc = v_numslc
         and codequcom IN (select o.codigoc
                             from operacion.tipopedd t, operacion.opedd o
                            where t.abrev = 'DECO_DTH'
                              and o.tipopedd = t.tipopedd);
      begin
        --ini 39.0
        /*select v.telefonom2 into v_sec
        from int_vtacliente_aux v, int_vtaregventa_aux t
        where v.idlote = t.idlote and t.o_numslc = v_numslc;*/
        SELECT t.numsec
          INTO v_sec
          FROM operacion.inssrv t
         WHERE t.numslc = v_numslc;
        --fin 39.0
      exception
        when others then
          v_sec := null;
      end;
    
      begin
        NULL;
         pvt.WEBUNI_SP_AGENDAMIENTO_IN@DBL_PVTDB(v_sec,
        n_nrodecos,
        3, --22.0
        v_contrata,
        v_ubigeo,
        user,
        ad_fecagenda,
        v_cod_resp,
        v_mensaje); --22.0
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Problemas en obtener informacion de WEB UNI.' ||
                                  sqlerrm);
      end;
      update agendamiento
         set fecagenda = to_date(to_char(ad_fecagenda, 'DD/MM/YYYY') || ' ' ||
                                 P_DESCRIPCION_F,
                                 'DD/MM/YYYY HH24:MI')
       where idagenda = an_idagenda;
      commit;
    else
      update agendamiento
         set fecagenda = ad_fecagenda
       where idagenda = an_idagenda;
    end if;
    --Fin 21.0
  End;
  --Fin 20.0
  --Fin 13.0

  --Inicio 15.0
  /*********************************************************************************************************************
  Procedimiento general para generar Agendamiento y maneja a nivel de definicion de tareas de WF
  una configuracion para asignar Contrata en base a los siguientes criterios:
  Plano
  Ubigeo
  Cuadrilla Propia
  *********************************************************************************************************************/
  procedure p_genera_agendamiento(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    n_codsolot            number;
    n_idagenda            number;
    n_area                areaope.area%type;
    dt_Feccom             date;
    n_regla_asig_contrata number;
    n_regla_asig_fecprog  number;
    n_codcon              number;
    n_eslima              number; --24.0
    n_valida              number; --24.0
    n_no_agenda           number; --27.0
    v_nomcli              vtatabcli.nomcli%type; --27.0
    v_codcli              vtatabslcfac.codcli%type; --27.0
    v_obs                 vtatabslcfac.obssolfac%type; --27.0
    lv_texto              varchar2(4000); --34.0
    l_cont_val            number; --30.0
    v_tipo                tareawfdef.tipo_agenda%type; --36.0
    ln_codcon             number;
    V_VALOR               varchar(1);
    v_observ              operacion.solot.observacion%type; --70.0
    n_pos                 number; --70.0
    d_fecha               date; --70.0
    n_id_consulta         number; --70.0
  
    cursor cur_correo is
      select email from ENVCORREO where tipo = 10; --27.0
    --Inicio 30.0
    cursor cur_cid is
      select distinct a.codinssrv,
                      a.cid,
                      (select count(1)
                         from opedd a, tipopedd b
                        where a.tipopedd = b.tipopedd
                          and b.abrev = 'PRODFAX'
                          and a.abreviacion = 'PRODUCTO'
                          and (codigon = b.idproducto)) cont,
                      e.tiptrs,
                      b.idproducto
        from solotpto a, tystabsrv b, insprd c, solot d, tiptrabajo e
       where a.codsrvnue = b.codsrv
         and b.idproducto <> 524
         and a.cid is null
         and a.pid = c.pid(+)
         and a.codsolot = d.codsolot
         and d.tiptra = e.tiptra
         and e.tiptrs = 1
         and a.codsolot = n_codsolot;
    --Fin 30.0
  
    --INI 58.0
    ln_flag_aplica  NUMERIC := 0;
    ln_iderror      NUMERIC;
    lv_mensajeerror VARCHAR2(3000);
    --FIN 58.0
  
    ln_estage_new number; -- 66.0
    V_ANOTACION   OPERACION.SIAC_POSTVENTA_PROCESO.ANOTACION_TOA%TYPE;
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    select area into n_area from tareawf where idtareawf = a_idtareawf;
    select tipo_agenda into v_tipo from tareawfdef where tarea = a_tarea; --36.0
  
    --Inicio 30.0
    select count(1)
      into l_cont_val
      from tipopedd
     where abrev = 'ASIGCIDSGA';
    if l_cont_val = 1 then
      FOR c_cid IN cur_cid LOOP
        IF c_cid.cont = 0 then
          METASOLV.P_MOVER_INSSRV_A_ACCESO(c_cid.codinssrv);
        end if;
      END LOOP;
    end if;
    --Fin 30.0
  
    --Inicio 27.0 Regla para SOTs que no necesitan Agendamiento
    select count(1)
      into n_no_agenda
      from vtatabslcfac a, solot b
     where a.numslc = b.numslc
       and b.codsolot = n_codsolot
       and a.FLG_CEHFC_CP in (1, 2)
       and a.FLG_AGENDA = 0; --<54.0>
    if n_no_agenda = 1 then
      --CE Venta Menor sin Agendamiento
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       SYSDATE,
                                       SYSDATE);
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf,
         'La SOT : ' || to_char(n_codsolot) ||
         ' se ha definido sin Agendamiento.');
      select a.nomcli, b.codcli, c.obssolfac
        into v_nomcli, v_codcli, v_obs
        from vtatabcli a, solot b, vtatabslcfac c
       where a.codcli = b.codcli
         and b.codsolot = n_codsolot
         and b.numslc = c.numslc;
      lv_texto := 'Se genero la SOT para atencion Remota por : ' || user ||
                  CHR(13) || 'SOT: ' || to_char(n_codsolot) || CHR(13) ||
                  'Codigo Cliente: ' || v_codcli || CHR(13) ||
                  'Nombre Cliente: ' || v_nomcli || CHR(13) ||
                  'Observaciones: ' || v_obs || CHR(13);
      for c_correo in cur_correo loop
        p_envia_correo_de_texto_att('SOT Servicio Menor Sin Agenda : ' ||
                                    to_char(n_codsolot),
                                    c_correo.email,
                                    lv_texto);
      end loop;
      return;
    end if;
    --Fin 27.0
  
    --Ini 70.0
    begin
      select fecha_progra
        into d_fecha
        from operacion.parametro_vta_pvta_adc
       where codsolot = n_codsolot;
    exception
      when no_data_found then
        select sysdate into d_fecha from dual;
    end;
    if d_fecha is null then
    
      select instr(trim(observacion), '|'), trim(observacion)
        into n_pos, v_observ
        from operacion.solot
       where codsolot = n_codsolot;
    
      if n_pos > 0 then
        v_observ := substr(v_observ, n_pos + 1);
        n_pos    := instr(v_observ, '|');
        if n_pos > 0 then
          v_observ := substr(v_observ, 1, n_pos - 1);
          if v_observ is not null then
            n_id_consulta := to_number(v_observ);
          
            select fecha_compromiso
              into d_fecha
              from sales.etadirect_sel
             where id_consulta = n_id_consulta;
          
            update operacion.parametro_vta_pvta_adc
               set fecha_progra = d_fecha
             where codsolot = n_codsolot;
          
          end if;
        end if;
      end if;
    end if;
  
    --Fin 70.0
  
    select regla_asig_contrata, regla_asig_fecprog
      into n_regla_asig_contrata, n_regla_asig_fecprog
      from tareawfdef
     where tarea = a_tarea;
    if n_regla_asig_fecprog = 1 then
      --Verificar Regla de asignacion de Fecha de Programacion
      select NVL(feccom, sysdate)
        into dt_feccom
        from solot
       where codsolot = n_codsolot;
    else
      dt_feccom := null;
    end if;
  
    begin
      p_crea_agenda(n_codsolot,
                    null,
                    null,
                    dt_feccom,
                    '',
                    '',
                    a_idtareawf,
                    n_area,
                    n_idagenda);
      -- PROY-31513
      BEGIN
        SELECT ANOTACION_TOA
          INTO V_ANOTACION
          FROM operacion.siac_postventa_proceso
         WHERE CODSOLOT = n_codsolot;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_ANOTACION := '';
      END;
      IF LENGTH(TRIM(V_ANOTACION)) > 0 THEN
        INSERT INTO tareawfseg
          (idtareawf, observacion)
        VALUES
          (a_idtareawf, V_ANOTACION);
      END IF;
      ---
    exception
      when others then
        raise_application_error(-20001,
                                'Error al Generar la Agenda : ' || sqlerrm);
    end;
    --INI 58.0
  
    --Inicio 36.0
    if v_tipo is not null then
      update agendamiento set tipo = v_tipo where idagenda = n_idagenda;
    end if;
    --Fin 36.0
  
    --INI PROY-27792
    --Validamos que sea un SOT de HFC de Cambio de Plan
    DECLARE
    BEGIN
      BEGIN
        SELECT NVL(op.codigoc, '0')
          INTO V_VALOR
          FROM opedd op
         WHERE op.abreviacion = 'ACT_CPLAN'
           AND op.tipopedd =
               (SELECT tipopedd
                  FROM operacion.tipopedd b
                 WHERE B.ABREV = 'CONF_WLLSIAC_CP');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VALOR := '0';
      END;
    
      IF V_VALOR = '1' THEN
        IF operacion.pq_siac_cambio_plan.sgafun_valida_cb_plan(n_codsolot) = 1 THEN
          IF operacion.pq_siac_cambio_plan.sgafun_valida_cb_plan_visita(n_codsolot) = 1 THEN
          
            --INI 66.0
            SELECT o.codigon, o.codigon_aux
              INTO ln_codcon, ln_estage_new
              FROM operacion.opedd o, operacion.tipopedd t
             WHERE o.abreviacion = 'CONT_DEFAULT'
               AND t.abrev = 'CONF_WLLSIAC_CP';
          
            UPDATE agendamiento
               SET codcon = ln_codcon, estage = ln_estage_new
             WHERE idagenda = n_idagenda;
          
            insert into agendamientochgest
              (idagenda,
               tipo,
               estado,
               fecreg,
               observacion,
               codmot_solucion)
            values
              (n_idagenda,
               1,
               ln_estage_new,
               sysdate,
               'CAMBIO DE PLAN POR SISTEMAS',
               0);
          
            opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                             4,
                                             8,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
          
            INSERT INTO tareawfseg
              (idtareawf, observacion)
            VALUES
              (a_idtareawf,
               'La SOT : ' || to_char(n_codsolot) ||
               ' es un Cambio de Plan por Sistemas; No Requiere Visita Tecnica');
            --FIN 66.0
            RETURN;
          END IF;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        OPERACION.PQ_SIAC_CAMBIO_PLAN.p_insert_log_post_siac(0,
                                                             v_codcli,
                                                             'PQ_AGENDAMIENTO',
                                                             to_char(SQLERRM));
    END;
    --FIN PROY-27792
  
    --INI 69.0
    --VALIDAMOS QUE SEA UN SOT DE ALTA POR PORT-OUT
    BEGIN
      BEGIN
        SELECT O.CODIGON, O.CODIGON_AUX
          INTO LN_CODCON, LN_ESTAGE_NEW
          FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
         WHERE O.ABREVIACION = 'CONTR_DEFECTO'
           AND T.ABREV = 'CONF_ALTA_PORTOUT';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VALOR := '0';
      END;
    
      IF LN_CODCON > 0 AND
         OPERACION.PKG_PORTABILIDAD.SGAFUN_PORTOUT_ES_ALTA(N_CODSOLOT) > 0 THEN
        UPDATE AGENDAMIENTO
           SET CODCON = LN_CODCON, ESTAGE = LN_ESTAGE_NEW
         WHERE IDAGENDA = N_IDAGENDA;
      
        INSERT INTO AGENDAMIENTOCHGEST
          (IDAGENDA, TIPO, ESTADO, FECREG, OBSERVACION, CODMOT_SOLUCION)
        VALUES
          (N_IDAGENDA, 1, LN_ESTAGE_NEW, SYSDATE, 'ALTA PORT-OUT', 0);
      
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(A_IDTAREAWF,
                                         4,
                                         4,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      
        INSERT INTO TAREAWFSEG
          (IDTAREAWF, OBSERVACION)
        VALUES
          (A_IDTAREAWF,
           'La SOT : ' || TO_CHAR(N_CODSOLOT) ||
           ' es un Cambio de Alta por Port-Out; No Requiere Visita Tecnica');
        RETURN;
      END IF;
    
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'Error al Generar Agendacmiento por Alta Port-Out : ' ||
                                SQLERRM);
    END;
    --FIN 69.0
  
    OPERACION.PQ_ADM_CUADRILLA.P_VALIDA_FLUJO_ADC(N_IDAGENDA,
                                                  LN_FLAG_APLICA,
                                                  LN_IDERROR,
                                                  LV_MENSAJEERROR);
    IF LN_FLAG_APLICA = 0 THEN
      --FIN 58.0
    
      if n_regla_asig_contrata = 1 then
        -- XDistrito
        begin
          select decode(count(1), 0, null, 1, a.codcon, null)
            into n_codcon
            from distritoxcontrata a, solotpto b, solot c
           where a.codubi = b.codubi
             and c.codsolot = b.codsolot
             and a.tiptra = c.tiptra
             and c.codsolot = n_codsolot
             and nvl(a.tipsrv, c.tipsrv) = c.tipsrv --51.0
             and a.prioridad = 1
             and a.estado = 1
             and rownum = 1
           group by codcon;
        exception
          when no_data_found then
            n_codcon := 1;
        end;
      elsif n_regla_asig_contrata = 2 then
        -- XPlano
        begin
          select pxc.codcon
            into n_codcon
            from OPE_PLANOXCONTRATA_REL pxc,
                 solotpto               spto,
                 solot                  s,
                 inssrv                 i,
                 vtasuccli              v
           where pxc.idplano = v.idplano
             and s.codsolot = spto.codsolot
             and spto.codinssrv = i.codinssrv
             and i.codsuc = v.codsuc
             and pxc.tiptra = s.tiptra
             and s.codsolot = n_codsolot
             and pxc.prioridad = 1
             and rownum = 1
           group by codcon;
        exception
          when others then
            n_codcon := 1;
        end;
        --Inicio 17.0
      elsif n_regla_asig_contrata = 3 then
        --Contrata desde ATC
        begin
          --59.0
          select nvl(codcon, 1)
            into n_codcon
            from ATCCORP.ATCINCIDENCEXSOLOT a, solot b
           where a.codsolot = n_codsolot
             and a.codsolot = b.codsolot
             and b.recosi = a.codincidence
             and rownum = 1
             and codcon is not null;
        exception
          when others then
            n_codcon := 1;
        end;
        --Fin 17.0
        --Inicio 18.0
      elsif n_regla_asig_contrata = 4 then
        --Contrata que Vende asigna a Contrata que Instala
        begin
          select decode(e.codcon_tpi, null, a.codcon, e.codcon_tpi)
            into n_codcon
            from distritoxcontrata a,
                 solotpto          b,
                 solot             c,
                 vtatabslcfac      d,
                 vtatabect         e
           where a.codubi = b.codubi
             and c.codsolot = b.codsolot
             and a.tiptra = c.tiptra
             and c.codsolot = n_codsolot
             and c.numslc = d.numslc
             and d.codsol = e.codect
             and a.prioridad = 1
             and a.estado = 1
             and rownum = 1;
        exception
          when others then
            n_codcon := 1;
        end;
        --Fin 18.0
      else
        --Cuadrilla Propia
        n_codcon := 1;
      end if;
      --Inicio 24.0
      select count(1)
        into n_eslima
        from agendamiento a, vtatabdst b
       where a.codubi = b.codubi
         and b.codpai = '51'
         and not b.codest = '1' --25.0
         and a.area = 342
         and a.idagenda = n_idagenda;
      select count(1)
        into n_Valida
        from tipopedd
       where abrev = 'ASIGPROVLIMA';
      if n_eslima = 1 and n_valida = 1 then
        --Es provincia y tiene asignado el area CONTRATISTA CE --25.0
        update agendamiento
           set area = 206, codcon = 1 --CONTRATISTA ALTA BAJA HFC&TPI
         where idagenda = n_idagenda;
      end if;
      --Fin 24.0
    
      update agendamiento
         set codcon = n_codcon
       where idagenda = n_idagenda;
      --INI 58.0
    END IF;
  
    --si tiene el flujo ADC genera la OT
    IF ln_flag_aplica = 1 THEN
      UPDATE operacion.agendamiento
         SET flg_adc = 1
       WHERE idagenda = n_idagenda;
    
      --se invoca el procedimiento para generar OT en ADC
      operacion.pq_adm_cuadrilla.p_genera_ot_adc(n_codsolot,
                                                 n_idagenda,
                                                 ln_iderror,
                                                 lv_mensajeerror);
    
    END IF;
    --FIN 58.0
  
    --Inicio 36.0
    --ini 58.0
    /*if v_tipo is not null then
      update agendamiento set tipo  = v_tipo
      where idagenda =n_idagenda;
    end if;*/
    --fin 58.0
    --Fin 36.0
  
  end;

  procedure p_crea_agenda(a_codsolot      in number,
                          a_codcon        in number,
                          a_instalador    in varchar2,
                          a_feccompromiso date,
                          a_observacion   varchar2,
                          a_referencia    varchar2,
                          a_idtareawf     in number default null,
                          a_area          in number default null,
                          a_idagenda      in out number) is
    v_nomcli       varchar2(200);
    v_dirsuc       varchar2(480);
    v_codcli       varchar2(10);
    v_codubi       varchar2(10);
    v_numslc       varchar2(10);
    n_idagenda     number;
    n_estage       number;
    n_codincidence number;
    ln_codsuc      varchar2(10);
    ln_codcase     number;
    v_idplano      varchar2(10);
    n_idpaquete    number(10);
    n_cid          number;
    n_codinssrv    number;
    v_numero       varchar2(20);
    v_codmotivo_tc varchar2(3); --40.0
    v_codmotivo_co varchar2(3); --40.0
  begin
    begin
      select distinct a.codcli,
                      b.nomcli,
                      c.codubi,
                      nvl(e.dirsuc, d.direccion),
                      a.numslc,
                      a.recosi,
                      d.codsuc,
                      e.idplano, --35.0
                      d.idpaq,
                      d.cid,
                      d.codinssrv,
                      d.numero,
                      f.codmotivo_co,
                      f.codmotivo_tc --40.0
        into v_codcli,
             v_nomcli,
             v_codubi,
             v_dirsuc,
             v_numslc,
             n_codincidence,
             ln_codsuc,
             v_idplano,
             n_idpaquete,
             n_cid,
             n_codinssrv,
             v_numero,
             v_codmotivo_co,
             v_codmotivo_tc --40.0
        from solot        a,
             vtatabcli    b,
             solotpto     c,
             inssrv       d,
             vtasuccli    e,
             vtatabprecon f --40.0
       where a.codsolot = a_codsolot
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+)
         and rownum = 1
         and a.numslc = f.numslc(+); --40.0;
    exception
      when no_data_found then
        raise_application_error(-20001,
                                'No se encuentra informacion para la SOT a Agendar.');
    end;
    begin
      select y.codcase
        into ln_codcase
        from incidence y
       where y.codincidence = n_codincidence;
    exception
      when no_data_found then
        ln_codcase := null;
    end;
  
    n_estage := 1; --Generado
    --Se genera Agenda
    select sq_agendamiento.nextval into n_idagenda from dummy_ope;
    insert into agendamiento
      (codcli,
       codsolot,
       codcon,
       instalador,
       direccion,
       numslc,
       codubi,
       codincidence,
       fecha_instalacion,
       fecagenda,
       observacion,
       referencia,
       estage,
       idtareawf,
       idagenda,
       codsuc,
       area,
       codcase,
       idplano,
       idpaq,
       cid,
       codinssrv,
       numero,
       codmotivo_tc,
       codmotivo_co) --40.0
    values
      (v_codcli,
       a_codsolot,
       a_codcon,
       a_instalador,
       v_dirsuc,
       v_numslc,
       v_codubi,
       n_codincidence,
       null,
       a_feccompromiso,
       a_observacion,
       a_referencia,
       n_estage,
       a_idtareawf,
       n_idagenda,
       ln_codsuc,
       a_area,
       ln_codcase,
       v_idplano,
       n_idpaquete,
       n_cid,
       n_codinssrv,
       v_numero,
       v_codmotivo_tc,
       v_codmotivo_co); --40.0
  
    --Genera trs de cambio de estado de agendamiento
    if n_estage <> 1 then
      pq_agendamiento.p_chg_est_agendamiento(n_idagenda, n_estage);
    end if;
    a_idagenda := n_idagenda;
  
  end p_crea_agenda;
  --Fin 15.0

  --Inicio 19.0
  --Inicio 19.0
  procedure p_obt_datos_web_uni(an_idagenda  agendamiento.idagenda%type,
                                ad_fecagenda agendamiento.fecagenda%type) is
    v_ubigeo     varchar2(30);
    v_fecprog    solot.feccom%type;
    v_sec        inssrv.numero%type;
    n_tiptra     tiptrabajo.tiptra%type;
    n_cont       number;
    n_valida_cfg number;
    n_idsolucion soluciones.idsolucion%type;
    v_numslc     vtatabslcfac.numslc%type;
    v_codsolot   solot.codsolot%type;
    n_nrodecos   number;
    --Inicio 21.0
    li_soldth       number;
    P_CONTRATA      VARCHAR2(300);
    P_IDCONTRATA    NUMBER;
    P_DESCRIPCION_F VARCHAR2(300);
    P_FECHA_AGENDA  VARCHAR2(300);
    P_FRANJA        NUMBER;
    P_COD_RESP      VARCHAR2(300);
    P_MENSAJE       VARCHAR2(300);
    --Fin 21.0
    --Incio 22.0
    v_contrata varchar2(100);
    v_cod_resp varchar2(300);
    --v_mensaje varchar2(300); 28.0
    n_codcon       number;
    v_FECHA_AGENDA VARCHAR2(300);
    --Fin 22.0
    v_hora_inicio varchar2(30); --28.0
    v_fecagenda   varchar2(30); --28.0
    v_tipo_trans  varchar2(30); --29.0
  begin
    v_fecagenda := to_Char(ad_fecagenda, 'DD/MM/YYYY HH24:MI'); --28.0
  
    select d.ubigeo, b.tiptra, c.idsolucion, c.numslc, b.feccom, b.codsolot
      into v_ubigeo,
           n_tiptra,
           n_idsolucion,
           v_numslc,
           v_fecprog,
           v_codsolot
      from agendamiento a, solot b, vtatabslcfac c, vtatabdst d
     where a.idagenda = an_idagenda
       and rownum = 1
       and a.codsolot = b.codsolot
       and b.numslc = c.numslc
       and a.codubi = d.codubi;
    li_soldth := sales.pq_dth_postventa.f_obt_facturable_dth(v_numslc); --30.0
    --li_soldth :=  sales.pq_dth_postventa.f_obt_solucion_dth(n_idsolucion); ---f_obt_facturable_dth  30.0
    --Inicio 21.0
    --if li_soldth = 1 then 29.0
  
    select count(1)
      into n_valida_cfg
      from opedd
     where tipopedd = 571
       and codigon = n_tiptra
       and codigon_aux = n_idsolucion;
    if n_valida_cfg = 0 then
      return;
    end if;
    select count(1)
      into n_cont
      from opedd
     where tipopedd = 570
       and codigon = n_tiptra;
    if n_cont = 0 then
      raise_application_error(-20001,
                              'El tipo de Trabajo de la SOT no se encuentra habilitada para esta funcionalidad.');
    end if;
    --Numero de Decos
    select count(*)
      into n_nrodecos
      from vtadetptoenl
     where numslc = v_numslc
       and codequcom IN (select o.codigoc
                           from operacion.tipopedd t, operacion.opedd o
                          where t.abrev = 'DECO_DTH'
                            and o.tipopedd = t.tipopedd);
    --ini 20.0
    if li_soldth = 1 then
      --29.0
    
      BEGIN
        --ini 39.0
        /*select v.telefonom2 into v_sec
        from int_vtacliente_aux v, int_vtaregventa_aux t
        where v.idlote = t.idlote and t.o_numslc = v_numslc;*/
        SELECT t.numsec
          INTO v_sec
          FROM operacion.inssrv t
         WHERE t.numslc = v_numslc;
        --fin 39.0
      exception
        when others then
          v_sec := null;
      end;
      begin
        --<28.0 ini
        pvt.WEBUNI_AGENDAMIENTO.SP_RE_AGENDAMIENTO_FRANJA@DBL_PVTDB(v_fecagenda,
        v_ubigeo,
        null,
        n_nrodecos,
        to_number(v_sec),
        user,
        null,
        2,
        null,
        null,
        3,
        'SGA',
        P_CONTRATA,
        P_IDCONTRATA,
        P_DESCRIPCION_F,
        P_FECHA_AGENDA,
        P_FRANJA,
        P_COD_RESP,
        P_MENSAJE);
        COMMIT;
        --28.0 fin>
      exception
        when no_data_found then
          raise_application_error(-20001,
                                  'Problemas en obtener informacion de WEB UNI.' ||
                                  sqlerrm);
      end;
      --<28.0 ini
      /*if v_cod_resp = 0 then
      update agendamiento
      set fecagenda = to_date(v_FECHA_AGENDA,'DD/MM/YYYY HH24:MI')
      where idagenda =  an_idagenda ;
      commit;*/
      --<29.0
    else
      begin
        select op.abreviacion
          into v_tipo_trans
          from sales.vtatabslcfac v,
               solot              s,
               opedd              op,
               tipopedd           td,
               solotpto           so,
               inssrv             i
         where op.tipopedd = td.tipopedd
           and UPPER(td.abrev) like '%TIPO_TRANS_DTH%'
           and op.codigon_aux = v.idsolucion
           and op.codigon = s.tiptra
           and so.codsolot = s.codsolot
           and so.codinssrv = i.codinssrv
           and i.numslc = v.numslc
           and s.codsolot = v_codsolot
           and rownum = 1;
      exception
        when others then
          v_tipo_trans := null;
      end;
      if v_tipo_trans is not null then
        begin
          PVT.WEBUNI_AGENDAMIENTO.SP_TRASLADO_EXT_AGENDA@DBL_PVTDB(v_fecagenda,
          v_ubigeo,
          null,
          n_nrodecos,
          to_number(v_sec),
          user,
          3,
          null,
          null,
          v_codsolot,
          v_tipo_trans,
          'SGA',
          P_CONTRATA,
          P_IDCONTRATA,
          P_DESCRIPCION_F,
          P_FECHA_AGENDA,
          P_FRANJA,
          P_COD_RESP,
          P_MENSAJE);
          commit;
        exception
          when no_data_found then
            raise_application_error(-20001,
                                    'Problemas en obtener informacion de WEB UNI.' ||
                                    sqlerrm);
        end;
      else
        raise_application_error(-20001,
                                'El tipo de Transaccion no se encuentra habilitada para esta funcionalidad.');
      end if;
    end if;
    --29.0>
    if P_COD_RESP = 0 then
      case p_franja
        when 1 then
          v_hora_inicio := '09:00';
        when 2 then
          v_hora_inicio := '11:00';
        when 3 then
          v_hora_inicio := '14:00';
        else
          v_hora_inicio := '16:00';
      end case;
    
      update agendamiento
         set fecagenda = to_date(trim(P_FECHA_AGENDA) || ' ' ||
                                 trim(v_hora_inicio),
                                 'dd/mm/yyyy HH24:MI')
       where idagenda = an_idagenda;
      commit;
      --28.0 fin>
    else
      raise_application_error(-20001, 'Mensaje : ' || p_mensaje);
    end if;
  
    --end if; 29.0
  
  end p_obt_datos_web_uni;
  --Fin 19.0

  --Inicio 26.0
  FUNCTION f_obt_horaxtiptrabajo(an_tiptra operacion.tiptrabajo.tiptra%type)
    return type_agenda_hora
    pipelined IS
    cursor cur_horas is
      select codigoc
        from tipopedd m, opedd d
       where m.tipopedd = d.tipopedd
         and m.abrev = 'HORAS_AGENDAR';
  
    lc_horas    operacion.tiptrabajo.horas%type;
    lc_hora_ini operacion.tiptrabajo.hora_ini%type;
    lc_hora_fin operacion.tiptrabajo.hora_fin%type;
    ld_horas    date;
  begin
    -- Test statements here
    select horas, hora_ini, hora_fin
      into lc_horas, lc_hora_ini, lc_hora_fin
      from tiptrabajo
     where tiptra = an_tiptra;
    if (lc_horas is null or lc_hora_ini is null or lc_hora_fin is null) then
      return;
    end if;
    pipe row(type_hora(lc_hora_ini));
    for reg_horas in cur_horas loop
      select to_date(lc_hora_ini, 'HH24:MI') + (lc_horas / 24)
        into ld_horas
        from dual;
      lc_hora_ini := to_char(ld_horas, 'HH24:MI');
      if ld_horas > to_date(lc_hora_fin, 'HH24:MI') then
        exit;
      end if;
      pipe row(type_hora(lc_hora_ini));
    end loop;
    return;
  end;

  procedure p_ins_horarioxcuadrillaanual(an_clave  operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                                         an_tiptra tiptrabajo.tiptra%type,
                                         an_dia    operacion.ope_horaxcuadrilla_det.dia%type) is
  begin
  
    insert into operacion.ope_horaxcuadrilla_det
      (id_ope_cuadrillaxdistrito_det, dia, hora, activo)
      select an_clave, an_dia, hora, 0
        from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
  
  end;

  procedure p_muestra_calendario(an_incidence   atccorp.incidence.codincidence%type,
                                 an_tiptra      tiptrabajo.tiptra%type,
                                 as_fechaagenda date default sysdate) is
    --declaracion de cursores: que cuadril
    ln_diasemana number;
  
    cursor cur_cuadrilla_tiptraxdist(ls_codubi inssrv.codubi%type,
                                     an_tiptra tiptrabajo.tiptra%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where codubi = ls_codubi
         and tiptra = an_tiptra;
  
    cursor cur_hora(ln_idopecuadrxdist operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                    ln_diasemana       number) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_idopecuadrxdist
         and dia = ln_diasemana;
  
    ls_codubi             inssrv.codubi%type;
    ln_num_fechxcuadrilla number;
    ld_fechaferiado       date;
    ln_coincidencia       number;
    ln_canthoras          number; --cantidad de horas que existen por tipo de trabajo
    ln_color              number;
    contador              number;
    ex_continuar1 exception; --exception salir para primer bucle
    ex_continuar2 exception; --excepcion para controlar si algun hora disponible
  begin
    --obtenemos el codubi con codigo de incidencia
    select i.codubi
      into ls_codubi
      from incidence ins, customerxincidence cxi, inssrv i
     where ins.codincidence = cxi.codincidence
       and cxi.servicenumber = i.codinssrv
       and ins.codincidence = an_incidence;
  
    for reg_cuadrilla_tiptraxdist in cur_cuadrilla_tiptraxdist(ls_codubi,
                                                               an_tiptra) loop
      begin
        --primero se busca si existe una programacion diaria
        select count(1)
          into ln_num_fechxcuadrilla
          from operacion.ope_fechaxcuadrilla_det
         where id_ope_cuadrillaxdistrito_det =
               reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det
           and fechadiaria = trunc(as_fechaagenda);
      
        if ln_num_fechxcuadrilla > 1 then
          null;
        else
          --validamos si la fecha seleccionada es feriado
          begin
            select trunc(fecini)
              into ld_fechaferiado
              from billcolper.tlftabfer
             where trunc(fecini) = as_fechaagenda
               and estado = 'ACT';
            ln_diasemana := 8;
          exception
            when NO_DATA_FOUND then
              select to_number(to_char(as_fechaagenda, 'D'))
                into ln_diasemana
                from dual;
          end;
        
          select count(1)
            into ln_canthoras
            from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
        
          contador := 0;
          for reg_hora in cur_hora(reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det,
                                   ln_diasemana) loop
            begin
              if reg_hora.activo = 0 then
                raise ex_continuar1;
              else
                select count(1)
                  into ln_coincidencia
                  from agendamiento
                 where codubi = ls_codubi
                   and trunc(fecagenda) = trunc(as_fechaagenda)
                   and to_char(fecagenda, 'HH24:MI') = reg_hora.hora
                   and codcon = reg_cuadrilla_tiptraxdist.codcon;
                if ln_coincidencia > 0 then
                  raise ex_continuar1; --ln_color := 1;
                else
                  ln_color := 0; --horario libre, se pinta de blanco
                end if;
              end if;
            exception
              when ex_continuar1 then
                contador := contador + 1;
                ln_color := 1; -- no se condidera, se debera pintar de rojo;
            end;
          end loop;
          if contador <> ln_canthoras then
            raise ex_continuar2; --si hay algun horario libre por cuadrilla salimos de todo
          end if;
        end if;
      exception
        when ex_continuar2 then
          exit;
      end;
    end loop;
  end;

  function f_busca_agenda_disponible(as_codubi      inssrv.codubi%type,
                                     ad_fechaagenda date,
                                     as_hora        char,
                                     as_codcon      contrata.codcon%type)
    return number is
    ln_coincidencia number;
  begin
    select count(1)
      into ln_coincidencia
      from agendamiento
     where codubi = as_codubi
       and trunc(fecagenda) = trunc(ad_fechaagenda)
       and to_char(fecagenda, 'HH24:MI') = as_hora
       and codcon = as_codcon;
    if ln_coincidencia > 0 then
      return 1;
    else
      return 0;
    end if;
  end;

  FUNCTION f_obt_calendario(an_incidence   atccorp.incidence.codincidence%type,
                            an_tiptra      tiptrabajo.tiptra%type,
                            as_fechaagenda date default sysdate)
    return type_table_calendario
    pipelined IS
  
    ln_diasemana number;
  
    cursor cur_cuadrilla_tiptraxdist(ls_codubi inssrv.codubi%type,
                                     an_tiptra tiptrabajo.tiptra%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where codubi = ls_codubi
         and tiptra = an_tiptra;
    --programacion diaria
    cursor cur_hora_excepcion(ln_idopecuadrxdist operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                              ld_fechadiaria     date) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_idopecuadrxdist
         and fechadiaria = ld_fechadiaria;
    --programacion anual
    cursor cur_hora(ln_idopecuadrxdist operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                    ln_diasemana       number) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_idopecuadrxdist
         and dia = ln_diasemana;
  
    ls_codubi             inssrv.codubi%type;
    ln_num_fechxcuadrilla number;
    ld_fechaferiado       date;
    ln_canthoras          number; --cantidad de horas que existen por tipo de trabajo
    ln_color              number;
    contador              number;
    ex_continuar1 exception; --exception salir para primer bucle
    ex_continuar2 exception; --excepcion para controlar si algun hora disponible
  begin
    --obtenemos el codubi con codigo de incidencia
    select i.codubi
      into ls_codubi
      from incidence ins, customerxincidence cxi, inssrv i
     where ins.codincidence = cxi.codincidence
       and cxi.servicenumber = i.codinssrv
       and ins.codincidence = an_incidence;
  
    for reg_cuadrilla_tiptraxdist in cur_cuadrilla_tiptraxdist(ls_codubi,
                                                               an_tiptra) loop
      begin
        --primero se busca si existe una programacion diaria
        select count(1)
          into ln_num_fechxcuadrilla
          from operacion.ope_fechaxcuadrilla_det
         where id_ope_cuadrillaxdistrito_det =
               reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det
           and fechadiaria = trunc(as_fechaagenda);
      
        if ln_num_fechxcuadrilla > 1 then
          --PROGRAMACION DIARIA (EXCEPCION)
          select count(1)
            into ln_canthoras
            from operacion.ope_fechaxcuadrilla_det
           where id_ope_cuadrillaxdistrito_det =
                 reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det
             and fechadiaria = trunc(as_fechaagenda);
        
          contador := 0;
          for reg_hora_excepcion in cur_hora_excepcion(reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det,
                                                       trunc(as_fechaagenda)) loop
            begin
              if reg_hora_excepcion.flg_activo = 0 then
                raise ex_continuar1;
              else
                if f_busca_agenda_disponible(ls_codubi,
                                             as_fechaagenda,
                                             reg_hora_excepcion.hora,
                                             reg_cuadrilla_tiptraxdist.codcon) = 1 then
                  raise ex_continuar1; --ln_color := 1;
                else
                  ln_color := 0; --horario libre, se pinta de blanco
                  pipe row(type_calendario(an_tiptra,
                                           reg_cuadrilla_tiptraxdist.codcon,
                                           reg_cuadrilla_tiptraxdist.codcuadrilla,
                                           reg_hora_excepcion.hora,
                                           ln_color));
                end if;
              end if;
            exception
              when ex_continuar1 then
                contador := contador + 1;
                ln_color := 1; -- no se condidera, se debera pintar de rojo;
                pipe row(type_calendario(an_tiptra,
                                         reg_cuadrilla_tiptraxdist.codcon,
                                         reg_cuadrilla_tiptraxdist.codcuadrilla,
                                         reg_hora_excepcion.hora,
                                         ln_color));
            end;
          end loop;
          if contador <> ln_canthoras then
            raise ex_continuar2; --si hay algun horario libre por cuadrilla salimos de todo
          end if;
        else
          --PROGRAMACION ANUAL
          --validamos si la fecha seleccionada es feriado
          begin
            select trunc(fecini)
              into ld_fechaferiado
              from billcolper.tlftabfer
             where trunc(fecini) = as_fechaagenda
               and trunc(sysdate) = trunc(as_fechaagenda)
               and estado = 'ACT'
               and rownum = 1;
          
            ln_diasemana := 8;
          exception
            when NO_DATA_FOUND then
              select to_number(to_char(as_fechaagenda, 'D'))
                into ln_diasemana
                from dual;
          end;
        
          select count(1)
            into ln_canthoras
            from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
        
          contador := 0;
          for reg_hora in cur_hora(reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det,
                                   ln_diasemana) loop
            begin
              if reg_hora.activo = 0 then
                raise ex_continuar1;
              else
                if f_busca_agenda_disponible(ls_codubi,
                                             as_fechaagenda,
                                             reg_hora.hora,
                                             reg_cuadrilla_tiptraxdist.codcon) = 1 then
                  raise ex_continuar1; --ln_color := 1;
                else
                  ln_color := 0; --horario libre, se pinta de blanco
                  pipe row(type_calendario(an_tiptra,
                                           reg_cuadrilla_tiptraxdist.codcon,
                                           reg_cuadrilla_tiptraxdist.codcuadrilla,
                                           reg_hora.hora,
                                           ln_color));
                end if;
              end if;
            exception
              when ex_continuar1 then
                contador := contador + 1;
                ln_color := 1; -- no se condidera, se debera pintar de rojo;
                pipe row(type_calendario(an_tiptra,
                                         reg_cuadrilla_tiptraxdist.codcon,
                                         reg_cuadrilla_tiptraxdist.codcuadrilla,
                                         reg_hora.hora,
                                         ln_color));
            end;
          end loop;
          if contador <> ln_canthoras then
            raise ex_continuar2; --si hay algun horario libre por cuadrilla salimos de todo
          end if;
        end if;
      exception
        when ex_continuar2 then
          exit;
      end;
    end loop;
  end;

  procedure p_valida_hora_agenda(ad_fecha_compromiso in agendamiento.fecagenda%type,
                                 an_tiptra           in tiptrabajo.tiptra%type,
                                 an_color            in number,
                                 a_msg_error         out varchar2,
                                 a_coderror          out number) is
  
    ex_excepcion1 exception;
    ex_excepcion2 exception;
    ex_excepcion3 exception;
    ex_excepcion4 exception;
    ln_horas_antes tiptrabajo.horas_antes%type;
  
  begin
    a_coderror := 0;
    select nvl(horas_antes, 0)
      into ln_horas_antes
      from tiptrabajo
     where tiptra = an_tiptra
       and agendable = 1;
  
    if ln_horas_antes = 0 then
      raise ex_excepcion1;
    end if;
  
    if an_color = 1 then
      raise ex_excepcion3;
    end if;
  
    if ((sysdate) - (ad_fecha_compromiso)) > 0 then
      raise ex_excepcion4;
    end if;
  
    if ((sysdate + (ln_horas_antes / 24)) - (ad_fecha_compromiso)) > 0 then
      raise ex_excepcion2;
    end if;
  
  exception
    when ex_excepcion1 then
      a_msg_error := 'No se ha configurado horas antes';
      a_coderror  := 1;
    when ex_excepcion4 then
      a_msg_error := 'No se puede seleccionar una fecha menos a la fecha actual';
      a_coderror  := 1;
    when ex_excepcion2 then
      a_msg_error := 'No se puede seleccionar este horario, deberia seleccionar un horario superior';
      a_coderror  := 1;
    when ex_excepcion3 then
      a_msg_error := 'No se puede seleccionar un horario ya agendado o no diponibles';
      a_coderror  := 1;
  end;

  procedure p_valida_hora_agenda_ope(ad_fecha_compromiso in agendamiento.fecagenda%type,
                                     an_tiptra           in tiptrabajo.tiptra%type,
                                     an_color            in number,
                                     an_idagenda         in agendamiento.idagenda%type,
                                     a_msg_error         out varchar2,
                                     a_coderror          out number) is
  
    ex_excepcion1 exception;
    ex_excepcion2 exception;
    ex_excepcion3 exception;
    ex_excepcion4 exception;
    ln_horas_antes tiptrabajo.horas_antes%type;
  
  begin
    a_coderror := 0;
    select nvl(horas_antes, 0)
      into ln_horas_antes
      from tiptrabajo
     where tiptra = an_tiptra
       and agendable = 1;
  
    if ln_horas_antes = 0 then
      raise ex_excepcion1;
    end if;
  
    if an_color = 1 and an_idagenda = 0 then
      raise ex_excepcion3;
    end if;
  
    if ((sysdate) - (ad_fecha_compromiso)) > 0 then
      raise ex_excepcion4;
    end if;
  
    if ((sysdate + (ln_horas_antes / 24)) - (ad_fecha_compromiso)) > 0 then
      raise ex_excepcion2;
    end if;
  
  exception
    when ex_excepcion1 then
      a_msg_error := 'No se ha configurado horas antes';
      a_coderror  := 1;
    when ex_excepcion4 then
      a_msg_error := 'No se puede seleccionar una fecha menos a la fecha actual';
      a_coderror  := 1;
    when ex_excepcion2 then
      a_msg_error := 'No se puede seleccionar este horario, deberia seleccionar un horario superior';
      a_coderror  := 1;
    when ex_excepcion3 then
      a_msg_error := 'No se puede seleccionar un horario no diponibles';
      a_coderror  := 1;
  end;

  function f_es_agendable(an_tiptra in tiptrabajo.tiptra%type) return number is
    ln_agendable tiptrabajo.agendable%type;
  begin
    select nvl(agendable, 0)
      into ln_agendable
      from tiptrabajo
     where tiptra = an_tiptra;
    return ln_agendable;
  end;

  procedure p_reagendamiento(an_idagenda     agendamiento.idagenda%type,
                             an_tiptrabajo   tiptrabajo.tiptra%type,
                             ad_fecreagenda  agendamiento.fecagenda%type,
                             as_observacion  agendamiento.observacion%type,
                             as_codcuadrilla operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type,
                             a_msg_error     out varchar2,
                             a_coderror      out number) is
  
    ln_numveces            agendamiento.numveces%type;
    ln_numerovecesreagenda tiptrabajo.num_reagenda%type;
    ln_estage              agendamiento.estage%type;
    ex_maxreagendamientos  exception;
    ex_validaestadosagenda exception;
    ex_numvecesreagenda    exception;
    ln_cont_conf_rea number;
    ln_codcon        number;
  begin
  
    select num_reagenda
      into ln_numerovecesreagenda
      from tiptrabajo
     where tiptra = an_tiptrabajo;
    if ln_numerovecesreagenda is null then
      raise ex_numvecesreagenda;
    end if;
  
    select nvl(numveces, 0), estage
      into ln_numveces, ln_estage
      from agendamiento
     where idagenda = an_idagenda;
    --Validamos si tiene el max numero de reagendamientos
    if ln_numerovecesreagenda = ln_numveces then
      raise ex_maxreagendamientos;
    else
      --validar que se pueda ragendar
      select count(1)
        into ln_cont_conf_rea
        from opedd
       where tipopedd = 577
         and codigon = ln_estage
         and codigon_aux = 1;
      if ln_cont_conf_rea > 0 then
        raise ex_validaestadosagenda;
      end if;
      if f_es_agendable(an_tiptrabajo) = 1 then
        begin
          select codcon
            into ln_codcon
            from cuadrillaxcontrata
           where codcuadrilla = as_codcuadrilla
             and rownum = 1;
        exception
          when others then
            ln_codcon := 1;
        end;
      else
        ln_codcon := null;
      end if;
      update agendamiento
         set codcuadrilla = as_codcuadrilla,
             codcon       = nvl(ln_codcon, codcon)
       where idagenda = an_idagenda;
      p_chg_est_Agendamiento(an_idagenda,
                             22,
                             null,
                             as_observacion,
                             null,
                             ad_fecreagenda);
    end if;
  exception
    when ex_maxreagendamientos then
      a_msg_error := 'Ha sobrepasado el numero de veces a reagendar. Se Debera cancelar la agenda';
      a_coderror  := 1;
    when ex_validaestadosagenda then
      a_msg_error := 'No se puede cambiar en este estado de la agenda';
      a_coderror  := 1;
    when ex_numvecesreagenda then
      a_msg_error := 'No se ha configurado numero de veces a reagendar';
      a_coderror  := 1;
  end;

  procedure p_cancelar_agenda(an_codincidence incidence.codincidence%type,
                              an_idagenda     agendamiento.idagenda%type,
                              an_tiptrabajo   tiptrabajo.tiptra%type,
                              as_observacion  agendamiento.observacion%type,
                              a_msg_error     out varchar2,
                              a_coderror      out number) is
    ln_estage        agendamiento.estage%type;
    ls_estincidence  incidence.codstatus%type;
    ln_sequencetype  incidence_seq_type.codincseqtype%type;
    ln_codsolot      solot.codsolot%type;
    ln_cont_conf_rea number;
    ln_tipestsol     number;
    ex_estadoagenda     exception;
    ex_estadoincidencia exception;
    ex_solot            exception;
  
  begin
    if f_es_agendable(an_tiptrabajo) = 1 then
      select codstatus
        into ls_estincidence
        from incidence
       where codincidence = an_codincidence;
      select sequencetype
        into ln_sequencetype
        from status
       where codstatus = ls_estincidence;
      if ln_sequencetype in (3, 4) then
        raise ex_estadoincidencia;
      end if;
    
      select estage, codsolot
        into ln_estage, ln_codsolot
        from agendamiento
       where idagenda = an_idagenda;
      if ln_codsolot is null then
        raise ex_solot;
      end if;
      --validar que se pueda Cancelar
      select count(1)
        into ln_cont_conf_rea
        from opedd
       where tipopedd = 577
         and codigon = ln_estage
         and codigon_aux = 2;
      if ln_cont_conf_rea > 0 then
        raise ex_estadoagenda;
      end if;
    
      update incidence
         set codstatus = 5
       where codincidence = an_codincidence;
      update agendamiento
         set codcuadrilla = null
       where idagenda = an_idagenda;
      begin
        p_chg_est_Agendamiento(an_idagenda,
                               5,
                               null,
                               as_observacion,
                               null,
                               sysdate);
      exception
        when others then
          raise_application_error(-20001,
                                  'Error en el cambio de estado de la Agenda.' ||
                                  sqlerrm);
      end;
      select b.tipestsol
        into ln_tipestsol
        from solot a, estsol b
       where a.estsol = b.estsol
         and a.codsolot = ln_codsolot;
      if ln_tipestsol not in (4, 5) then
        begin
          pq_solot.p_chg_estado_solot(ln_codsolot,
                                      12,
                                      null,
                                      as_observacion);
        exception
          when others then
            raise_application_error(-20001,
                                    'Error en el cambio de estado de la SOT.' ||
                                    sqlerrm);
        end;
      else
        raise_application_error(-20001, 'No se puede cerrar la SOT que');
      end if;
    end if;
  exception
    when ex_estadoincidencia then
      a_msg_error := 'No se tiene asociado ninguna SOT a esta incidencia';
      a_coderror  := 1;
    when ex_solot then
      a_msg_error := 'La incidencia ya se encuentra en estado cerrado o concluido';
      a_coderror  := 1;
    when ex_estadoagenda then
      a_msg_error := 'No se encuentra en un estado valido para cancelar la agenda';
      a_coderror  := 1;
  end;

  procedure p_eliminar_configxtipotrabajo(an_tiptra tiptrabajo.tiptra%type) is
    cursor cur_cuadrillasxdistrito is
      select id_ope_cuadrillaxdistrito_det
        from operacion.ope_cuadrillaxdistrito_det
       where tiptra = an_tiptra;
  begin
    for reg_cuadrillasxdistrito in cur_cuadrillasxdistrito loop
      delete from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det =
             reg_cuadrillasxdistrito.id_ope_cuadrillaxdistrito_det;
      delete from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det =
             reg_cuadrillasxdistrito.id_ope_cuadrillaxdistrito_det;
      for i in 1 .. 8 loop
        OPERACION.PQ_AGENDAMIENTO.p_ins_horarioxcuadrillaanual(reg_cuadrillasxdistrito.id_ope_cuadrillaxdistrito_det,
                                                               an_tiptra,
                                                               i);
      end loop;
    end loop;
  end;

  function f_busca_agenda_disponible_ope(as_codubi       inssrv.codubi%type,
                                         ad_fechaagenda  date,
                                         as_hora         char,
                                         as_codcon       contrata.codcon%type,
                                         as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type)
    return number is
    ln_idagenda number;
  begin
    select idagenda
      into ln_idagenda
      from agendamiento
     where codubi = as_codubi
       and trunc(fecagenda) = trunc(ad_fechaagenda)
       and to_char(fecagenda, 'HH24:MI') = as_hora
       and codcon = as_codcon
       and codcuadrilla = as_codcuadrilla
       and estage in
           (select estage from estagenda where tipestage not in (3, 4))
       and rownum = 1;
    return ln_idagenda;
  exception
    when NO_DATA_FOUND then
      return 0;
  end;

  function f_obt_calendario_ope(an_incidence    atccorp.incidence.codincidence%type,
                                an_tiptra       tiptrabajo.tiptra%type,
                                an_codcon       contrata.codcon%type,
                                as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                as_codubi       vtatabdst.codubi%type,
                                as_fechaagenda  date default sysdate)
    return type_table_calendario_ope
    pipelined IS
  
    ln_diasemana number;
  
    cursor cur_cuadrilla_tiptraxdist(ls_codubi       inssrv.codubi%type,
                                     ln_tiptra       tiptrabajo.tiptra%type,
                                     ln_codcon       contrata.codcon%type,
                                     ls_codcuadrilla cuadrillaxcontrata.codcuadrilla%type) is
    
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where codubi = ls_codubi
         and tiptra = ln_tiptra
         and codcon = ln_codcon
         and codcuadrilla = ls_codcuadrilla
         and flg_activo = 1;
    --programacion diaria
    cursor cur_hora_excepcion(ln_idopecuadrxdist operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                              ld_fechadiaria     date) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_idopecuadrxdist
         and fechadiaria = ld_fechadiaria;
    --programacion anual
    cursor cur_hora(ln_idopecuadrxdist operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                    ln_diasemana       number) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_idopecuadrxdist
         and dia = ln_diasemana;
  
    ls_codubi             inssrv.codubi%type;
    ln_num_fechxcuadrilla number;
    ld_fechaferiado       date;
    ln_canthoras          number; --cantidad de horas que existen por tipo de trabajo
    ln_color              number;
    contador              number;
    ln_idagenda           agendamiento.idagenda%type;
    ex_continuar1 exception; --exception salir para primer bucle
    ex_continuar2 exception; --excepcion para controlar si algun hora disponible
  begin
    --obtenemos el codubi con codigo de incidencia
    select i.codubi
      into ls_codubi
      from incidence ins, customerxincidence cxi, inssrv i
     where ins.codincidence = cxi.codincidence
       and cxi.servicenumber = i.codinssrv
       and ins.codincidence = an_incidence;
  
    for reg_cuadrilla_tiptraxdist in cur_cuadrilla_tiptraxdist(as_codubi,
                                                               an_tiptra,
                                                               an_codcon,
                                                               as_codcuadrilla) loop
      begin
        --primero se busca si existe una programacion diaria
        select count(1)
          into ln_num_fechxcuadrilla
          from operacion.ope_fechaxcuadrilla_det
         where id_ope_cuadrillaxdistrito_det =
               reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det
           and fechadiaria = trunc(as_fechaagenda);
      
        if ln_num_fechxcuadrilla > 1 then
          --PROGRAMACION DIARIA (EXCEPCION)
          select count(1)
            into ln_canthoras
            from operacion.ope_fechaxcuadrilla_det
           where id_ope_cuadrillaxdistrito_det =
                 reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det
             and fechadiaria = trunc(as_fechaagenda);
        
          contador := 0;
          for reg_hora_excepcion in cur_hora_excepcion(reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det,
                                                       trunc(as_fechaagenda)) loop
            begin
              ln_idagenda := 0;
              if reg_hora_excepcion.flg_activo = 0 then
                raise ex_continuar1;
              else
                ln_idagenda := f_busca_agenda_disponible_ope(ls_codubi,
                                                             as_fechaagenda,
                                                             reg_hora_excepcion.hora,
                                                             reg_cuadrilla_tiptraxdist.codcon,
                                                             reg_cuadrilla_tiptraxdist.codcuadrilla);
                if ln_idagenda <> 0 then
                  raise ex_continuar1;
                else
                  ln_color := 0; --horario libre, se pinta de blanco
                  pipe row(type_calendario_ope(ln_idagenda,
                                               as_fechaagenda,
                                               an_tiptra,
                                               reg_cuadrilla_tiptraxdist.codcon,
                                               reg_cuadrilla_tiptraxdist.codcuadrilla,
                                               reg_hora_excepcion.hora,
                                               ln_color));
                end if;
              end if;
            exception
              when ex_continuar1 then
                contador := contador + 1;
                ln_color := 1; -- no se condidera, se debera pintar de rojo;
                pipe row(type_calendario_ope(ln_idagenda,
                                             as_fechaagenda,
                                             an_tiptra,
                                             reg_cuadrilla_tiptraxdist.codcon,
                                             reg_cuadrilla_tiptraxdist.codcuadrilla,
                                             reg_hora_excepcion.hora,
                                             ln_color));
            end;
          end loop;
          if contador <> ln_canthoras then
            raise ex_continuar2; --si hay algun horario libre por cuadrilla salimos de todo
          end if;
        else
          --PROGRAMACION ANUAL
          --validamos si la fecha seleccionada es feriado
          begin
            select trunc(fecini)
              into ld_fechaferiado
              from billcolper.tlftabfer
             where trunc(fecini) = as_fechaagenda
               and trunc(sysdate) = trunc(as_fechaagenda)
               and estado = 'ACT'
               and rownum = 1;
          
            ln_diasemana := 8;
          exception
            when NO_DATA_FOUND then
              select to_number(to_char(as_fechaagenda, 'D'))
                into ln_diasemana
                from dual;
          end;
        
          select count(1)
            into ln_canthoras
            from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
        
          contador := 0;
          for reg_hora in cur_hora(reg_cuadrilla_tiptraxdist.id_ope_cuadrillaxdistrito_det,
                                   ln_diasemana) loop
            begin
              ln_idagenda := 0;
              if reg_hora.activo = 0 then
                raise ex_continuar1;
              else
                ln_idagenda := f_busca_agenda_disponible_ope(ls_codubi,
                                                             as_fechaagenda,
                                                             reg_hora.hora,
                                                             reg_cuadrilla_tiptraxdist.codcon,
                                                             reg_cuadrilla_tiptraxdist.codcuadrilla);
                if ln_idagenda <> 0 then
                  raise ex_continuar1; --ln_color := 1;
                else
                  ln_color := 0; --horario libre, se pinta de blanco
                  pipe row(type_calendario_ope(ln_idagenda,
                                               as_fechaagenda,
                                               an_tiptra,
                                               reg_cuadrilla_tiptraxdist.codcon,
                                               reg_cuadrilla_tiptraxdist.codcuadrilla,
                                               reg_hora.hora,
                                               ln_color));
                end if;
              end if;
            exception
              when ex_continuar1 then
                contador := contador + 1;
                ln_color := 1; -- no se condidera, se debera pintar de rojo;
                pipe row(type_calendario_ope(ln_idagenda,
                                             as_fechaagenda,
                                             an_tiptra,
                                             reg_cuadrilla_tiptraxdist.codcon,
                                             reg_cuadrilla_tiptraxdist.codcuadrilla,
                                             reg_hora.hora,
                                             ln_color));
            end;
          end loop;
          if contador <> ln_canthoras then
            raise ex_continuar2; --si hay algun horario libre por cuadrilla salimos de todo
          end if;
        end if;
      exception
        when ex_continuar2 then
          exit;
      end;
    end loop;
  end;

  procedure p_get_hora(an_incidence incidence.codincidence%type,
                       an_tiptra    tiptrabajo.tiptra%type,
                       ad_fecagenda agendamiento.fecagenda%type) is
    --horas x tipo de trabajo
    cursor cur_horas(an_tiptra tiptrabajo.tiptra%type) is
      select hora
        from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
  
    --ID de tiptraxcontxcuadxcodubi
    cursor cur_tiptraxcontxcuadxcodubi(ln_tiptra tiptrabajo.tiptra%type,
                                       ls_codubi vtatabdst.codubi%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where tiptra = ln_tiptra
         and codubi = ls_codubi
         and flg_activo = 1;
  
    --programacion excepcion
    cursor cur_diaexcepcion(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                            ld_fecagenda               agendamiento.fecagenda%type,
                            ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and fechadiaria = trim(ld_fecagenda)
         and hora = ls_hora;
    --programacion segun dia de semana
    cursor cur_diasemana(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                         ln_diasemana               number,
                         ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and dia = ln_diasemana
         and hora = ls_hora;
  
    --declaracion de variables
    ls_codubi       vtatabdst.codubi%type;
    ln_codcon       contrata.codcon%type;
    ln_diasemana    number;
    ld_fechaferiado billcolper.tlftabfer.fecini%type;
    ln_color        number;
    ln_color_aux    number;
    ls_codcuadrilla operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type;
  
    ls_hora tiptrabajo.hora_ini%type;
    ex_prueba           exception;
    ex_horadisponible   exception;
    ex_horanodisponible exception;
  begin
    --obtenemos el codubi con codigo de incidencia
    select i.codubi
      into ls_codubi
      from incidence ins, customerxincidence cxi, inssrv i
     where ins.codincidence = cxi.codincidence
       and cxi.servicenumber = i.codinssrv
       and ins.codincidence = an_incidence;
  
    for reg_horas in cur_horas(an_tiptra) loop
      begin
        for reg_tiptraxcontxcuadxcodubi in cur_tiptraxcontxcuadxcodubi(an_tiptra,
                                                                       ls_codubi) loop
          begin
            ln_color_aux := 1; --ocupado
            if f_busca_agenda_disponible_ope(ls_codubi,
                                             ad_fecagenda,
                                             reg_horas.hora,
                                             reg_tiptraxcontxcuadxcodubi.codcon,
                                             reg_tiptraxcontxcuadxcodubi.codcuadrilla) <> 0 then
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              ls_hora         := reg_horas.hora;
              raise ex_prueba;
            end if;
          
            --programacion excepcion
            for reg_diaexcepcion in cur_diaexcepcion(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                                     ad_fecagenda,
                                                     reg_horas.hora) loop
              begin
                if reg_diaexcepcion.flg_activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  ls_hora         := reg_horas.hora;
                  raise ex_horadisponible;
                end if;
              end;
            end loop;
            --programacion anual
            begin
              select trunc(fecini)
                into ld_fechaferiado
                from billcolper.tlftabfer
               where trunc(fecini) = trunc(ad_fecagenda)
                 and estado = 'ACT'
                 and rownum = 1;
            
              ln_diasemana := 8;
            exception
              when NO_DATA_FOUND then
                select to_number(to_char(ad_fecagenda, 'D'))
                  into ln_diasemana
                  from dual;
            end;
            for reg_diasemana in cur_diasemana(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                               ln_diasemana,
                                               reg_horas.hora) loop
              begin
                if reg_diasemana.activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  ls_hora         := reg_horas.hora;
                  raise ex_horadisponible;
                end if;
              end;
            end loop; --reg_diasemana
          exception
            when ex_prueba then
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              ls_hora         := reg_horas.hora;
              ln_color_aux    := 1;
          end;
        end loop; --reg_ids
        if ln_color_aux = 1 then
          ls_codcuadrilla := ls_codcuadrilla;
          ln_codcon       := ln_codcon;
          ls_hora         := reg_horas.hora;
          raise ex_horanodisponible;
        end if;
      exception
        when ex_horadisponible then
          ln_color := 0; --0: disponible, 1:ocupado
          dbms_output.put_line(ls_hora || ': ' || to_char(ln_color) ||
                               ' D ' || ls_codcuadrilla);
        when ex_horanodisponible then
          ln_color := 1;
          dbms_output.put_line(ls_hora || ': ' || to_char(ln_color) ||
                               ' N ' || ls_codcuadrilla);
      end;
    end loop; --reg_hora
  end;

  function f_genera_horario(an_incidence atccorp.incidence.codincidence%type,
                            an_tiptra    tiptrabajo.tiptra%type,
                            ad_fecagenda agendamiento.fecagenda%type default sysdate)
    return type_table_calendario
    pipelined IS
  
    --horas x tipo de trabajo
    cursor cur_horas(an_tiptra tiptrabajo.tiptra%type) is
      select hora
        from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(an_tiptra));
  
    --ID de tiptraxcontxcuadxcodubi
    cursor cur_tiptraxcontxcuadxcodubi(ln_tiptra tiptrabajo.tiptra%type,
                                       ls_codubi vtatabdst.codubi%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where tiptra = ln_tiptra
         and codubi = ls_codubi
         and flg_activo = 1;
  
    --programacion excepcion
    cursor cur_diaexcepcion(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                            ld_fecagenda               agendamiento.fecagenda%type,
                            ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and fechadiaria = trim(ld_fecagenda)
         and hora = ls_hora;
    --programacion segun dia de semana
    cursor cur_diasemana(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                         ln_diasemana               number,
                         ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and dia = ln_diasemana
         and hora = ls_hora;
  
    --declaracion de variables
    ls_codubi             vtatabdst.codubi%type;
    ln_codcon             contrata.codcon%type;
    ln_diasemana          number;
    ld_fechaferiado       billcolper.tlftabfer.fecini%type;
    ln_color              number;
    ln_color_aux          number;
    ls_codcuadrilla       operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type;
    ln_num_fechxcuadrilla number;
    ex_horadisponible   exception;
    ex_horanodisponible exception;
    ls_hora tiptrabajo.hora_ini%type;
    ex_salto exception;
    ln_agendable   number;
    ln_cliente_lib number; --45.0
    ls_codcli      varchar2(10);
  begin
    select agendable
      into ln_agendable
      from tiptrabajo
     where tiptra = an_tiptra;
    if ln_agendable <> 1 then
      --Si no es agendable en linea no devolver nada
      return;
    end if;
  
    --obtenemos el codubi con codigo de incidencia
    select i.codubi, cxi.customercode --45.0
      into ls_codubi, ls_codcli --45.0
      from incidence ins, customerxincidence cxi, inssrv i
     where ins.codincidence = cxi.codincidence
       and cxi.servicenumber = i.codinssrv
       and ins.codincidence = an_incidence;
  
    --Inicio 45.0
    select count(1)
      into ln_cliente_lib
      from operacion.clientexcontrata
     where tiptra = an_tiptra
       and codcli = ls_codcli;
    if ln_cliente_lib = 1 then
      select codcon
        into ln_codcon
        from operacion.clientexcontrata
       where tiptra = an_tiptra
         and codcli = ls_codcli;
      for reg_horas in cur_horas(an_tiptra) loop
        ln_color := 0; --0: disponible, 1:ocupado
        pipe row(type_calendario(an_tiptra,
                                 ln_codcon,
                                 '',
                                 reg_horas.hora,
                                 ln_color));
      end loop;
      return;
    end if;
    --Fin 45.0
  
    for reg_horas in cur_horas(an_tiptra) loop
      begin
        for reg_tiptraxcontxcuadxcodubi in cur_tiptraxcontxcuadxcodubi(an_tiptra,
                                                                       ls_codubi) loop
          begin
            ln_color_aux := 1; --ocupado
            --si f_busca <> 0 no disponible else disponible
            if f_busca_agenda_disponible_ope(ls_codubi,
                                             ad_fecagenda,
                                             reg_horas.hora,
                                             reg_tiptraxcontxcuadxcodubi.codcon,
                                             reg_tiptraxcontxcuadxcodubi.codcuadrilla) <> 0 then
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              ls_hora         := reg_horas.hora;
              raise ex_salto;
              --raise ex_horanodisponible;
            end if;
            --valida si es excepcion
            select count(1)
              into ln_num_fechxcuadrilla
              from operacion.ope_fechaxcuadrilla_det
             where id_ope_cuadrillaxdistrito_det =
                   reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det
               and fechadiaria = trunc(ad_fecagenda);
          
            if ln_num_fechxcuadrilla > 0 then
              --programacion excepcion
              for reg_diaexcepcion in cur_diaexcepcion(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                                       ad_fecagenda,
                                                       reg_horas.hora) loop
                begin
                  if reg_diaexcepcion.flg_activo = 1 then
                    ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                    ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                    ls_hora         := reg_horas.hora;
                    raise ex_horadisponible;
                  end if;
                end;
              end loop;
            else
              --programacion anual
              begin
                select trunc(fecini)
                  into ld_fechaferiado
                  from billcolper.tlftabfer
                 where trunc(fecini) = trunc(ad_fecagenda)
                   and estado = 'ACT'
                   and rownum = 1;
              
                ln_diasemana := 8;
              exception
                when NO_DATA_FOUND then
                  select to_number(to_char(ad_fecagenda, 'D'))
                    into ln_diasemana
                    from dual;
              end;
              for reg_diasemana in cur_diasemana(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                                 ln_diasemana,
                                                 reg_horas.hora) loop
                begin
                  if reg_diasemana.activo = 1 then
                    ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                    ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                    ls_hora         := reg_horas.hora;
                    raise ex_horadisponible;
                  end if;
                end;
              end loop; --reg_diasemana
            end if;
          exception
            when ex_salto then
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              ls_hora         := reg_horas.hora;
              ln_color_aux    := 1;
          end;
        end loop; --reg_ids
      
        if ln_color_aux = 1 then
          ls_codcuadrilla := ls_codcuadrilla;
          ln_codcon       := ln_codcon;
          raise ex_horanodisponible;
        end if;
      exception
        when ex_horadisponible then
          ln_color := 0; --0: disponible, 1:ocupado
          pipe row(type_calendario(an_tiptra,
                                   ln_codcon,
                                   ls_codcuadrilla,
                                   reg_horas.hora,
                                   ln_color));
        when ex_horanodisponible then
          ln_color := 1;
          pipe row(type_calendario(an_tiptra,
                                   ln_codcon,
                                   ls_codcuadrilla,
                                   reg_horas.hora,
                                   ln_color));
      end;
    end loop; --reg_hora
  end;

  procedure p_genera_horario_ope(an_tiptra       tiptrabajo.tiptra%type,
                                 an_codcon       contrata.codcon%type,
                                 as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                 as_codubi       vtatabdst.codubi%type,
                                 ad_fecagenda    agendamiento.fecagenda%type default sysdate) IS
    --horas x tipo de trabajo
    cursor cur_horas(ln_tiptra tiptrabajo.tiptra%type) is
      select hora
        from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(ln_tiptra));
  
    --ID de tiptraxcontxcuadxcodubi
    cursor cur_tiptraxcontxcuadxcodubi(ln_tiptra       tiptrabajo.tiptra%type,
                                       ls_codubi       vtatabdst.codubi%type,
                                       ln_codcon       contrata.codcon%type,
                                       ls_codcuadrilla cuadrillaxcontrata.codcuadrilla%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where tiptra = ln_tiptra
         and codubi = ls_codubi
         and codcon = ln_codcon
         and codcuadrilla = ls_codcuadrilla;
  
    --programacion excepcion
    cursor cur_diaexcepcion(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                            ld_fecagenda               agendamiento.fecagenda%type,
                            ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and trunc(fechadiaria) = trunc(ld_fecagenda)
         and hora = ls_hora;
    --programacion segun dia de semana
    cursor cur_diasemana(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                         ln_diasemana               number,
                         ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and dia = ln_diasemana
         and hora = ls_hora;
  
    --declaracion de variables
    ls_codubi       vtatabdst.codubi%type;
    ln_codcon       contrata.codcon%type;
    ln_diasemana    number;
    ln_idagenda     agendamiento.idagenda%type;
    ld_fechaferiado billcolper.tlftabfer.fecini%type;
    ln_color        number;
    ln_color_aux    number;
    ls_codcuadrilla operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type;
    ex_horadisponible   exception;
    ex_horanodisponible exception;
  begin
  
    for reg_horas in cur_horas(an_tiptra) loop
      begin
        for reg_tiptraxcontxcuadxcodubi in cur_tiptraxcontxcuadxcodubi(an_tiptra,
                                                                       as_codubi,
                                                                       an_codcon,
                                                                       as_codcuadrilla) loop
          begin
            ln_color_aux := 1; --ocupado
            ln_idagenda  := f_busca_agenda_disponible_ope(as_codubi,
                                                          ad_fecagenda,
                                                          reg_horas.hora,
                                                          reg_tiptraxcontxcuadxcodubi.codcon,
                                                          reg_tiptraxcontxcuadxcodubi.codcuadrilla);
            if ln_idagenda <> 0 then
              ln_idagenda     := ln_idagenda;
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              raise ex_horanodisponible;
            end if;
          
            --programacion excepcion
            for reg_diaexcepcion in cur_diaexcepcion(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                                     ad_fecagenda,
                                                     reg_horas.hora) loop
              begin
                if reg_diaexcepcion.flg_activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  raise ex_horadisponible;
                end if;
              end;
            end loop;
            --programacion anual
            begin
              select trunc(fecini)
                into ld_fechaferiado
                from billcolper.tlftabfer
               where trunc(fecini) = trunc(ad_fecagenda)
                 and estado = 'ACT'
                 and rownum = 1;
            
              ln_diasemana := 8;
            exception
              when NO_DATA_FOUND then
                select to_number(to_char(ad_fecagenda, 'D'))
                  into ln_diasemana
                  from dual;
            end;
            for reg_diasemana in cur_diasemana(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                               ln_diasemana,
                                               reg_horas.hora) loop
              begin
                if reg_diasemana.activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  raise ex_horadisponible;
                end if;
              end;
            end loop; --reg_diasemana
            ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
            ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
          end;
        end loop; --reg_ids
        if ln_color_aux = 1 then
          ls_codcuadrilla := ls_codcuadrilla;
          ln_codcon       := ln_codcon;
          raise ex_horanodisponible;
        end if;
      exception
        when ex_horadisponible then
          ln_color := 0; --0: disponible, 1:ocupado
          dbms_output.put_line(reg_horas.hora || ': ' || to_char(ln_color) ||
                               ls_codcuadrilla || ' - ' || ln_idagenda);
        when ex_horanodisponible then
          ln_color := 1;
          dbms_output.put_line(reg_horas.hora || ': ' || to_char(ln_color) ||
                               ls_codcuadrilla || ' - ' || ln_idagenda);
      end;
    end loop; --reg_hora
  end;

  function f_genera_horario_ope(an_tiptra       tiptrabajo.tiptra%type,
                                an_codcon       contrata.codcon%type,
                                as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type,
                                as_codubi       vtatabdst.codubi%type,
                                ad_fecagenda    agendamiento.fecagenda%type default sysdate)
    return type_table_calendario_ope
    pipelined IS
  
    --horas x tipo de trabajo
    cursor cur_horas(ln_tiptra tiptrabajo.tiptra%type) is
      select hora
        from table(operacion.pq_agendamiento.f_obt_horaxtiptrabajo(ln_tiptra));
  
    --ID de tiptraxcontxcuadxcodubi
    cursor cur_tiptraxcontxcuadxcodubi(ln_tiptra       tiptrabajo.tiptra%type,
                                       ls_codubi       vtatabdst.codubi%type,
                                       ln_codcon       contrata.codcon%type,
                                       ls_codcuadrilla cuadrillaxcontrata.codcuadrilla%type) is
      select id_ope_cuadrillaxdistrito_det, codcon, codcuadrilla
        from operacion.ope_cuadrillaxdistrito_det
       where tiptra = ln_tiptra
         and codubi = ls_codubi
         and codcon = ln_codcon
         and codcuadrilla = ls_codcuadrilla
         and flg_activo = 1;
  
    --programacion excepcion
    cursor cur_diaexcepcion(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                            ld_fecagenda               agendamiento.fecagenda%type,
                            ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, flg_activo
        from operacion.ope_fechaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and trunc(fechadiaria) = trunc(ld_fecagenda)
         and hora = ls_hora;
    --programacion segun dia de semana
    cursor cur_diasemana(ln_tiptraxcontxcuadxcodubi operacion.ope_horaxcuadrilla_det.id_ope_cuadrillaxdistrito_det%type,
                         ln_diasemana               number,
                         ls_hora                    tiptrabajo.hora_ini%type) is
      select hora, activo
        from operacion.ope_horaxcuadrilla_det
       where id_ope_cuadrillaxdistrito_det = ln_tiptraxcontxcuadxcodubi
         and dia = ln_diasemana
         and hora = ls_hora;
  
    --declaracion de variables
    ls_codubi       vtatabdst.codubi%type;
    ln_codcon       contrata.codcon%type;
    ln_diasemana    number;
    ln_idagenda     agendamiento.idagenda%type;
    ld_fechaferiado billcolper.tlftabfer.fecini%type;
    ln_color        number;
    ln_color_aux    number;
    ls_codcuadrilla operacion.ope_cuadrillaxdistrito_det.codcuadrilla%type;
    ex_horadisponible   exception;
    ex_horanodisponible exception;
  begin
  
    for reg_horas in cur_horas(an_tiptra) loop
      begin
        for reg_tiptraxcontxcuadxcodubi in cur_tiptraxcontxcuadxcodubi(an_tiptra,
                                                                       as_codubi,
                                                                       an_codcon,
                                                                       as_codcuadrilla) loop
          begin
            ln_color_aux := 1; --ocupado
            ln_idagenda  := f_busca_agenda_disponible_ope(as_codubi,
                                                          ad_fecagenda,
                                                          reg_horas.hora,
                                                          reg_tiptraxcontxcuadxcodubi.codcon,
                                                          reg_tiptraxcontxcuadxcodubi.codcuadrilla);
            if ln_idagenda <> 0 then
              ln_idagenda     := ln_idagenda;
              ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
              ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
              raise ex_horanodisponible;
            end if;
          
            --programacion excepcion
            for reg_diaexcepcion in cur_diaexcepcion(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                                     ad_fecagenda,
                                                     reg_horas.hora) loop
              begin
                if reg_diaexcepcion.flg_activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  raise ex_horadisponible;
                end if;
              end;
            end loop;
            --programacion anual
            begin
              select trunc(fecini)
                into ld_fechaferiado
                from billcolper.tlftabfer
               where trunc(fecini) = trunc(ad_fecagenda)
                 and estado = 'ACT'
                 and rownum = 1;
            
              ln_diasemana := 8;
            exception
              when NO_DATA_FOUND then
                select to_number(to_char(ad_fecagenda, 'D'))
                  into ln_diasemana
                  from dual;
            end;
            for reg_diasemana in cur_diasemana(reg_tiptraxcontxcuadxcodubi.id_ope_cuadrillaxdistrito_det,
                                               ln_diasemana,
                                               reg_horas.hora) loop
              begin
                if reg_diasemana.activo = 1 then
                  ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
                  ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
                  raise ex_horadisponible;
                end if;
              end;
            end loop; --reg dia semana
            ls_codcuadrilla := reg_tiptraxcontxcuadxcodubi.codcuadrilla;
            ln_codcon       := reg_tiptraxcontxcuadxcodubi.codcon;
          end;
        end loop; --reg_ids
        if ln_color_aux = 1 then
          ls_codcuadrilla := ls_codcuadrilla;
          ln_codcon       := ln_codcon;
          raise ex_horanodisponible;
        end if;
      exception
        when ex_horadisponible then
          ln_color := 0; --0: disponible, 1:ocupado
          pipe row(type_calendario_ope(ln_idagenda,
                                       ad_fecagenda,
                                       an_tiptra,
                                       ln_codcon,
                                       ls_codcuadrilla,
                                       reg_horas.hora,
                                       ln_color));
        when ex_horanodisponible then
          ln_color := 1;
          pipe row(type_calendario_ope(ln_idagenda,
                                       ad_fecagenda,
                                       an_tiptra,
                                       ln_codcon,
                                       ls_codcuadrilla,
                                       reg_horas.hora,
                                       ln_color));
      end;
    end loop;
  end;
  --Fin 26.0
  --Inicio 27.0
  procedure p_obt_idagenda(an_codsolot solot.codsolot%type,
                           a_idagenda  out number) is
  
  begin
    select max(idagenda)
      into a_idagenda
      from agendamiento
     where codsolot = an_codsolot;
  
  end;

  PROCEDURE P_CHG_GES_REC_IW(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number,
                             a_tipesttar in number,
                             a_esttarea  in number,
                             a_mottarchg in number,
                             a_fecini    in date,
                             a_fecfin    in date) IS
    cursor cur_correo is
      select email from ENVCORREO where tipo = 9;
    lv_texto    varchar2(400);
    n_codsolot  number;
    v_nomcli    vtatabcli.nomcli%type;
    v_codcli    vtatabslcfac.codcli%type;
    v_obs       vtatabslcfac.obssolfac%type;
    n_no_agenda number;
  BEGIN
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    select count(1)
      into n_no_agenda
      from vtatabslcfac a, solot b
     where a.numslc = b.numslc
       and b.codsolot = n_codsolot
       and a.FLG_CEHFC_CP in (1, 2)
       and a.FLG_AGENDA = 0; --<54.0>
    if n_no_agenda = 1 then
      --CE Venta Menor sin Agendamiento
      select a.nomcli, b.codcli, c.obssolfac
        into v_nomcli, v_codcli, v_obs
        from vtatabcli a, solot b, vtatabslcfac c
       where a.codcli = b.codcli
         and b.codsolot = n_codsolot
         and b.numslc = c.numslc;
      lv_texto := 'Se genero la SOT para atencion Remota por : ' || user ||
                  CHR(13) || 'SOT: ' || to_char(n_codsolot) || CHR(13) ||
                  'Codigo Cliente: ' || v_codcli || CHR(13) ||
                  'Nombre Cliente: ' || v_nomcli || CHR(13) ||
                  'Observaciones: ' || v_obs || CHR(13);
      for c_correo in cur_correo loop
        p_envia_correo_de_texto_att('SOT Servicio Menor Sin Agenda : ' ||
                                    to_char(n_codsolot),
                                    c_correo.email,
                                    lv_texto);
      end loop;
    end if;
  END;
  --Fin 27.0
  -- Ini 55.0
  procedure p_gen_agenda_sin_asignar_lte(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number) is
    n_codsolot          number;
    n_idagenda          number;
    ln_area             areaope.area%type;
    ln_num_wf_cancelado number;
    ln_flag_aplica      numeric := 0;
    ln_iderror          numeric;
    lv_mensajeerror     varchar2(3000);
    v_tipo              varchar2(30);
    ld_fecins           date;
    ln_codcon           number;
    V_VALOR             number;
    v_anotacion         varchar2(4000);
    LN_ESTAGE_NEW       number(10); --69.0
  begin
    select tipo_agenda into v_tipo from tareawfdef where tarea = a_tarea;
    select codsolot into n_codsolot from wf where idwf = a_idwf;
    select area into ln_area from tareawf where idtareawf = a_idtareawf;
    --se cancelan las agendas generadas en wf cancelados de la misma SOT
    --ocurre cuando hay reasignacion de wf
    select count(1)
      into ln_num_wf_cancelado
      from wf
     where codsolot = n_codsolot
       and valido = 0;
  
    if ln_num_wf_cancelado > 0 then
      p_cancela_agenda_wf_ant(n_codsolot);
    end if;
    begin
      --Se agenda automaticamente
      p_crea_agendamiento(n_codsolot,
                          null,
                          null,
                          to_char(sysdate, 'dd/mm/yyyy'),
                          '00:00',
                          '',
                          '',
                          a_idtareawf,
                          ln_area,
                          n_idagenda);
      if v_tipo is not null then
        update agendamiento set tipo = v_tipo where idagenda = n_idagenda;
      end if;
      --ini 66.00
      BEGIN
        SELECT ANOTACION_TOA
          INTO v_anotacion
          FROM operacion.siac_postventa_proceso
         WHERE CODSOLOT = n_codsolot;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_anotacion := '';
      END;
    
      IF LENGTH(TRIM(NVL(v_anotacion, ''))) > 0 THEN
        INSERT INTO tareawfseg
          (idtareawf, observacion)
        VALUES
          (a_idtareawf, v_anotacion);
      END IF;
      --fin 66.00
      --ini 65.00
      BEGIN
        SELECT NVL(op.codigoc, '0')
          INTO V_VALOR
          FROM opedd op
         WHERE op.abreviacion = 'ACT_CPLAN'
           AND op.tipopedd =
               (SELECT tipopedd
                  FROM operacion.tipopedd b
                 WHERE B.ABREV = 'CONF_WLLSIAC_CP');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VALOR := '0';
      END;
      --fin 65.00
    
      -- ini 57.0
      if operacion.pq_siac_cambio_plan_lte.fnc_valida_cp_lte(n_codsolot) = 1 and
         V_VALOR = 0 then
        if operacion.pq_siac_cambio_plan_lte.fnc_valida_agenda_lte(n_codsolot) = 0 then
        
          select valor
            into ln_codcon
            from constante
           where constante = 'CONF_AGENDA_LTE';
        
          update agendamiento
             set codcon = ln_codcon
           where idagenda = n_idagenda;
        
          opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                           4,
                                           8,
                                           0,
                                           sysdate,
                                           sysdate);
        
          insert into tareawfseg
            (idtareawf, observacion)
          values
            (a_idtareawf,
             'la SOT : ' || to_char(n_codsolot) ||
             ' Fue Generada Por Cambio de Plan LTE, : No requiere visita t?cnica.');
        end if;
        --Validamos que sea un SOT de LTE de Cambio de Plan
        --ini 65.0
      elsif operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan(n_codsolot) = 1 and
            V_VALOR = 1 then
        if operacion.pq_siac_cambio_plan_lte.sgafun_valida_cb_plan_visita(n_codsolot) = 1 then
        
          Begin
            select o.codigon
              into ln_codcon
              from operacion.opedd o, operacion.tipopedd t
             where o.abreviacion = 'CONT_DEFAULT'
               and t.abrev = 'CONF_WLLSIAC_CP';
          Exception
            when no_data_found then
              ln_codcon := 1; --TELMEX PERU
          End;
        
          update agendamiento
             set codcon = ln_codcon
           where idagenda = n_idagenda;
        
          opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                           4,
                                           8,
                                           0,
                                           sysdate,
                                           sysdate);
        
          insert into tareawfseg
            (idtareawf, observacion)
          values
            (a_idtareawf,
             'la SOT : ' || to_char(n_codsolot) ||
             ' Fue Generada Por Cambio de Plan LTE, : No requiere visita t?cnica.');
        
        end if; --fin 65.0
        --INI 69.0 VALIDAMOS QUE SEA UN SOT DE ALTA POR PORT-OUT
      ELSIF OPERACION.PKG_PORTABILIDAD.SGAFUN_PORTOUT_ES_ALTA(N_CODSOLOT) > 0 THEN
        BEGIN
          BEGIN
            SELECT O.CODIGON, O.CODIGON_AUX
              INTO LN_CODCON, LN_ESTAGE_NEW
              FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD T
             WHERE O.ABREVIACION = 'CONTR_DEFECTO'
               AND T.ABREV = 'CONF_ALTA_PORTOUT';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              V_VALOR := '0';
          END;
        
          IF LN_CODCON > 0 THEN
            UPDATE AGENDAMIENTO
               SET CODCON = LN_CODCON, ESTAGE = LN_ESTAGE_NEW
             WHERE IDAGENDA = N_IDAGENDA;
          
            INSERT INTO AGENDAMIENTOCHGEST
              (IDAGENDA,
               TIPO,
               ESTADO,
               FECREG,
               OBSERVACION,
               CODMOT_SOLUCION)
            VALUES
              (N_IDAGENDA, 1, LN_ESTAGE_NEW, SYSDATE, 'ALTA PORT-OUT', 0);
          
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(A_IDTAREAWF,
                                             4,
                                             4,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
          
            INSERT INTO TAREAWFSEG
              (IDTAREAWF, OBSERVACION)
            VALUES
              (A_IDTAREAWF,
               'La SOT : ' || TO_CHAR(N_CODSOLOT) ||
               ' es un Cambio de Alta por Port-Out; No Requiere Visita Tecnica');
            RETURN;
          END IF;
        
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'Error al Generar Agendacmiento por Alta Port-Out : ' ||
                                    SQLERRM);
        END;
        --FIN 69.0
      else
        -- Actualizando datos en base a la informacion del SISACT
        begin
          select inp.fecins, inp.codcon1
            into ld_fecins, ln_codcon
            from sales.int_negocio_proceso inp
           where inp.idprocess in
                 (select ini.idprocess
                    from sales.int_negocio_instancia ini
                  -- Ini 56.0
                  -- where ini.instancia = 'SOT'
                  -- and ini.idinstancia = n_codsolot);
                   where ini.instancia = 'PROYECTO DE VENTA'
                     and ini.idinstancia =
                         (select s.numslc
                            from operacion.solot s
                           where s.codsolot = n_codsolot));
          -- Fin 56.0
        
        exception
          when others then
            ld_fecins := null;
            ln_codcon := null;
        end;
      
        update agendamiento
           set fecagenda = ld_fecins, codcon = ln_codcon
         where idagenda = n_idagenda;
      end if;
      -- fin 57.0
    exception
      when others then
        raise_application_error(-20001,
                                'Error al Generar la Agenda : ' || sqlerrm);
    end;
  end;
  -- Fin 55.0

  --ini 63.0

  PROCEDURE SGASS_VALIDA_ESTADO(P_IDAGENDA          IN NUMBER,
                                P_ESTADO            OUT VARCHAR2,
                                P_CODIGO_RESPUESTA  OUT NUMBER,
                                P_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    ws_ll_existe VARCHAR2(20);
    ws_ls_estado VARCHAR2(100);
  
  BEGIN
    BEGIN
      select count(*),
             (select a.desc_corta
                from operacion.estado_adc a
               where a.id_estado = operacion.cambio_estado_ot_adc.id_estado) as descrip
        into ws_ll_existe, ws_ls_estado
        from operacion.cambio_estado_ot_adc
       where idagenda = P_IDAGENDA
         and secuencia = (select max(secuencia)
                            from operacion.cambio_estado_ot_adc
                           where idagenda = P_IDAGENDA)
         and id_estado not in
             (SELECT d.codigon
                FROM operacion.parametro_det_adc d,
                     operacion.parametro_cab_adc c
               WHERE d.estado = 1
                 AND d.id_parametro = c.id_parametro
                 AND c.estado = 1
                 AND c.abreviatura = 'ESTADOS_REAGENDAR')
       group by operacion.cambio_estado_ot_adc.id_estado;
    EXCEPTION
      WHEN no_data_found THEN
        P_CODIGO_RESPUESTA  := 1;
        P_MENSAJE_RESPUESTA := 'OK';
        RETURN;
    END;
  
    P_ESTADO            := ws_ls_estado;
    P_CODIGO_RESPUESTA  := -1;
    P_MENSAJE_RESPUESTA := 'La Orden de Trabajo no se puede Reagendar por estar en Estado ' ||
                           ws_ls_estado;
  
  EXCEPTION
    WHEN OTHERS THEN
      P_CODIGO_RESPUESTA  := SQLCODE;
      P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :' || SQLERRM;
  END SGASS_VALIDA_ESTADO;

  PROCEDURE SGASS_VALIDA_SUBTIPO(P_SUBTIPO_TRAB      IN VARCHAR2,
                                 P_CODIGO_RESPUESTA  OUT NUMBER,
                                 P_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    ws_ll_cantidad    VARCHAR2(20);
    ws_ls_observacion VARCHAR2(100);
  BEGIN
    BEGIN
      select count(*), descripcion
        into ws_ll_cantidad, ws_ls_observacion
        from operacion.subtipo_orden_adc
       where cod_subtipo_orden = P_SUBTIPO_TRAB
         and estado = 0
       group by descripcion;
    
    EXCEPTION
      WHEN no_data_found THEN
        P_CODIGO_RESPUESTA  := 1;
        P_MENSAJE_RESPUESTA := 'OK';
        RETURN;
    END;
  
    P_CODIGO_RESPUESTA  := -1;
    P_MENSAJE_RESPUESTA := 'No se puede Reagendar utilizando el Sub-tipo ' ||
                           ws_ls_observacion ||
                           ', porque se encuentra Inactivo.';
  
  EXCEPTION
    WHEN OTHERS THEN
      P_CODIGO_RESPUESTA  := SQLCODE;
      P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :' || SQLERRM;
  END SGASS_VALIDA_SUBTIPO;

  PROCEDURE SGASS_VALIDA_DATOS(P_IDAGENDA          IN NUMBER,
                               P_CUR_SALIDA        OUT SYS_REFCURSOR,
                               P_CODIGO_RESPUESTA  OUT NUMBER,
                               P_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    ln_zl NUMBER;
  BEGIN
    /*VALIDAR ZONA LEJANA*/
    BEGIN
      ln_zl := operacion.pq_adm_cuadrilla.f_val_zonalejana(P_IDAGENDA);
      IF ln_zl > 0 THEN
        P_CODIGO_RESPUESTA  := -1;
        P_MENSAJE_RESPUESTA := 'La orden no se puede reagendar por pertenecer a una zona lejana';
        return;
      end if;
    END;
    /*CAPTURAR DATOS DE AGENDAMIENTO*/
    Open P_CUR_SALIDA for
      select idagenda         Id_agenda,
             Codcon           Codcon,
             idagenda         Contacto_adc,
             direccion        Direccion,
             telefono_adc     Telefono,
             id_subtipo_orden Id_subtipo_orden,
             observacion      Observacion,
             codcuadrilla     CodCuadrilla
        from operacion.agendamiento
       where operacion.agendamiento.idagenda = P_IDAGENDA;
  
    P_CODIGO_RESPUESTA  := 0;
    P_MENSAJE_RESPUESTA := 'SE EJECUTO CORRECTAMENTE.';
    return;
  exception
    when others then
      P_CODIGO_RESPUESTA  := SQLCODE;
      P_MENSAJE_RESPUESTA := 'Ocurrio un error de SQL-SELECT :' || SQLERRM;
  end SGASS_VALIDA_DATOS;

  --fin 63.0
  -- ini 64.0
  FUNCTION SGAFUN_OBT_OBS_REAGEN(p_observacion IN VARCHAR2,
                                 p_fecha       IN date) RETURN VARCHAR2 IS
  
    /*
    ****************************************************************
    * Nombre FUN         : SGASS_OBT_OBS_REAGEN
    * Prop?sito         : Obtiene el texto predefinido concatenada con la observación registrada en el reagendamiento
    * Input             : pi_observacion   --> observacion original del usuario
                          pi_fecha         --> fecha de reagendamiento
    * Output            : VARCHAR2    --> observacion concatenada con texto de reagendamiento automatico
    * Creado por        : Edwin Vasquez
    * Fec Creaci?n      : 10/04/2017
    * Fec Actualizaci?n : N/A
    ****************************************************************
    */
    l_men_reagen_def opedd.descripcion%TYPE;
    l_observacion    agendamientochgest.observacion%TYPE;
    l_fecha_franja   varchar2(20);
    l_codigo_franja  operacion.franja_horaria.codigo%TYPE;
    l_desc_franja    operacion.franja_horaria.franja%TYPE;
  
  BEGIN
  
    BEGIN
      SELECT d.descripcion
        INTO l_men_reagen_def
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'etadirect'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion = 'mensaje_reagen_default'
         AND d.codigon_aux = 1;
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(-20500,
                                'Error - No se ha registrado mensaje en OPEDD abrev: etadirect , abreviacion :mensaje_reagen_default');
    END;
  
    l_fecha_franja := to_char(p_fecha, 'dd/mm/yyyy hh:mi AM');
  
    BEGIN
      SELECT f.codigo, f.franja
        INTO l_codigo_franja, l_desc_franja
        FROM operacion.franja_horaria f
       WHERE to_date(to_char(to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                             'dd/mm/yyyy') || ' ' || f.franja_ini || ' ' ||
                     f.ind_merid_fi,
                     'dd/mm/yyyy hh:mi AM') <=
             to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM')
         AND to_date(to_char(to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM'),
                             'dd/mm/yyyy') || ' ' || f.franja_fin || ' ' ||
                     f.ind_merid_ff,
                     'dd/mm/yyyy hh:mi AM') >
             to_date(l_fecha_franja, 'DD/MM/YYYY HH:MI AM')
         AND f.flg_ap_ctr = 1
         AND f.codigo NOT IN (SELECT d.codigoc
                                FROM tipopedd c, opedd d
                               WHERE c.abrev = 'etadirect'
                                 AND c.tipopedd = d.tipopedd
                                 AND d.abreviacion = 'Time_slot_franja'
                                 AND d.codigon_aux = 1);
    EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(-20500,
                                'Error - No se ha registrado franja horaria para rango de fecha : ' ||
                                l_fecha_franja || SQLERRM);
    END;
  
    l_observacion := l_men_reagen_def || ' ' ||
                     to_char(p_fecha, 'dd/mm/yyyy') || ' Franja ' ||
                     l_codigo_franja || ' : ' || l_desc_franja || ' - ' ||
                     p_observacion;
  
    RETURN l_observacion;
  
  END;
  -- fin 64.0

  -- Inicio 67.0
  --------------------------------------------------------------------------------
  procedure SGASS_ACCION_CIERRE(pi_estado_ini number,
                                pi_estado_fin number,
                                po_accion     out varchar2,
                                po_cod_error  out number,
                                po_des_error  out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_ACCION_CIERRE
    * Propósito         : Obtener la acción a realizar de acuerdo al
                          estado inicial y final del agendamiento.
    * Input             : pi_estado_ini --> Estado Inicial
                          pi_estado_fin --> Estado Final
    * Output            : po_accion    --> acción
                          po_cod_error --> Código de Error
                          po_des_error --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error exception;
  
  begin
    if pi_estado_ini is null or pi_estado_fin is null then
      raise v_error;
    end if;
  
    select t.regcv_accion
      into po_accion
      from operacion.sgat_reglas_cierre t
     where t.regcn_estage_inicial = pi_estado_ini
       and t.regcn_estage_final = pi_estado_fin
       and t.regcv_estado = '1';
  
    po_cod_error := 0;
    po_des_error := 'OK';
  
  exception
    when v_error then
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_ACT_ESTDO_RECL(pi_idagenda       number,
                                 pi_usuario        varchar2,
                                 pi_estagenda_ini  number,
                                 pi_estagenda_fin  number,
                                 po_flag_insercion out varchar2,
                                 po_msg_text       out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_ACT_ESTDO_RECL
    * Propï¿¿sito         : Actualizar el estado de agendamiento del Reclamo en CLARIFY.
    * Input             : pi_idagenda      --> Código Agenda
                          pi_usuario       --> Usuario
                          pi_estagenda_ini --> Estado actual,
                          pi_estagenda_fin --> Estado solicitado
    * Output            : N/A
    * Creado por        : Juan Olivares
    * Fec Creación      : 04/11/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_codsolot       number(8);
    v_accion         varchar2(100);
    v_cod_error      number;
    v_des_error      varchar2(100);
    v_nro_caso       varchar2(32);
    v_nro_reclamo    varchar2(32);
    v_estado1        varchar2(80);
    v_estado2        varchar2(80);
    v_resolucion     varchar2(80);
    v_resultado      varchar2(80);
    v_notas          varchar2(400);
    v_accion_msj     varchar2(100);
    v_codigo_recurso number;
    v_log            sales.etadirect_log%rowtype;
    v_id_consulta    sales.etadirect_log.id_consulta%type;
    v_usuario        varchar2(32);
    v_accion1 constant varchar2(100) := 'Cerrar';
    v_accion2 constant varchar2(100) := 'Ampliacion(24 horas)';
    V_FLAG_ACTUALIZACION varchar2(10);
    V_MSG_TEXT           VARCHAR2(4000);
  
  begin
    select a.codsolot
      into v_codsolot
      from agendamiento a, solot b
     where a.codsolot = b.codsolot
       and a.idagenda = pi_idagenda;
  
    select t.rsotv_nro_caso, t.rsotv_nro_reclamo
      into v_nro_caso, v_nro_reclamo
      from operacion.sgat_reclamo_sot t
     where t.rsotv_nro_sot = v_codsolot;
  
    select t.codigo_recurso
      into v_codigo_recurso
      from sa.reclamo_web_fase_recursos@dbl_timprod_bf t
     where t.nro_caso_incidencia = v_nro_caso;
  
    v_usuario := pi_usuario;
  
    if v_codigo_recurso =
       to_number(pq_solot.SGAFUN_GET_PARAMETRO('reclamos', 'fase_averia', 1)) then
      --------------
      sa.PCK_CASE_CLFY_2.sp_retrieve_case@dbl_timprod_bf(v_nro_caso,
                                                         v_usuario,
                                                         V_FLAG_ACTUALIZACION,
                                                         V_MSG_TEXT);
    
      IF V_FLAG_ACTUALIZACION = 'OK' THEN
      
        sgass_accion_cierre(pi_estagenda_ini,
                            pi_estagenda_fin,
                            v_accion,
                            v_cod_error,
                            v_des_error);
      
        if v_cod_error = 0 and v_accion is not null then
          v_estado1    := pq_solot.SGAFUN_GET_PARAMETRO('reclamos',
                                                        'param_agenda',
                                                        1);
          v_estado2    := pq_solot.SGAFUN_GET_PARAMETRO('reclamos',
                                                        'param_agenda',
                                                        2);
          v_resolucion := pq_solot.SGAFUN_GET_PARAMETRO('reclamos',
                                                        'param_agenda',
                                                        3);
          v_resultado  := pq_solot.SGAFUN_GET_PARAMETRO('reclamos',
                                                        'param_agenda',
                                                        4);
          v_notas      := ' ';
        
          case v_accion
            when v_accion1 then
              v_accion_msj := 'el Cierre del Reclamo';
              sa.pck_case_clfy.sp_close_case@dbl_timprod_bf(v_nro_caso,
                                                            v_usuario,
                                                            v_estado1,
                                                            v_resolucion,
                                                            v_resultado,
                                                            v_notas,
                                                            po_flag_insercion,
                                                            po_msg_text);
            when v_accion2 then
              v_accion_msj := 'la Ampliaciï¿¿n del Reclamo';
              sa.pck_case_clfy.sp_change_case_status@dbl_timprod_bf(v_nro_caso,
                                                                    v_usuario,
                                                                    v_estado2,
                                                                    v_notas,
                                                                    po_flag_insercion,
                                                                    po_msg_text);
          end case;
        end if;
      end if;
    else
      po_flag_insercion := 'NO OK';
      po_msg_text       := v_msg_text;
    end if;
  
    if po_flag_insercion = 'NO OK' then
      select max(t.id_consulta) + 1
        into v_id_consulta
        from sales.etadirect_log t;
      v_log.id_consulta := v_id_consulta;
      v_log.mensaje     := 'Nro Caso: ' || v_nro_caso || ' Nro Reclamo: ' ||
                           v_nro_reclamo || ' Nro SOT: ' || v_codsolot ||
                           ' - Problema en Clarify: ' || po_msg_text;
      sales.pkg_mnt_etadirect_log.insertar(v_log);
      po_msg_text := pq_solot.sgafun_get_parametro('reclamos',
                                                   'msj_agenda',
                                                   1);
      po_msg_text := replace(po_msg_text, 'ZZ', v_accion_msj);
      po_msg_text := replace(po_msg_text, 'XX', v_nro_caso);
      po_msg_text := replace(po_msg_text, 'YY', v_nro_reclamo);
    elsif po_flag_insercion = 'OK' then
      po_msg_text := pq_solot.sgafun_get_parametro('reclamos',
                                                   'msj_agenda',
                                                   2);
    end if;
  
  exception
    when no_data_found then
      po_flag_insercion := 'NO OK';
      po_msg_text       := 'No existe SOT asociada al Reclamo';
  end;
  --------------------------------------------------------------------------------
  -- Fin 67.0
  -- Inicio 72.0
  Procedure SGASS_REGISTRA_DATOS_ORIGEN(ln_cod_id   number,
                                        ln_codsolot number) IS
    n_IDTRS OPERACION.TRS_INTERFACE_IW.IDTRS%type;
  BEGIN
    FOR v_reg in (SELECT DISTINCT TI.*
                    FROM OPERACION.TRS_INTERFACE_IW TI,
                         SOLOT                      S,
                         SOLOTPTO                   PTO,
                         INSSRV                     INS,
                         INSPRD                     PID
                   WHERE TI.COD_ID = S.COD_ID
                     AND S.CODSOLOT =
                         OPERACION.PQ_SGA_IW.f_max_sot_x_cod_id(ln_cod_id)
                     AND PTO.CODSOLOT = S.CODSOLOT
                     AND PTO.CODINSSRV = INS.CODINSSRV
                     AND INS.CODINSSRV = PID.CODINSSRV
                     AND INS.CODINSSRV = TI.CODINSSRV
                     AND PID.PID = TI.PIDSGA
                     and PID.ESTINSPRD IN (1, 2)) LOOP
    
      SELECT OPERACION.SQ_TRS_INTERFACE_IW.nextval INTO n_IDTRS FROM dual;
    
      INSERT INTO OPERACION.TRS_INTERFACE_IW
        (IDTRS,
         TIP_INTERFASE,
         ID_INTERFASE,
         VALORES,
         MODELO,
         MAC_ADDRESS,
         UNIT_ADDRESS,
         CUSTOMER_ID,
         CODIGO_EXT,
         ID_PRODUCTO,
         ID_PRODUCTO_PADRE,
         ID_SERVICIO_PADRE,
         COD_ID,
         CODCLI,
         CODSOLOT,
         CODINSSRV,
         PIDSGA,
         ID_SERVICIO,
         ESTADO,
         CODACTIVACION,
         TRS_PROV_BSCS,
         ESTADO_BSCS,
         ESTADO_IW)
      VALUES
        (n_IDTRS,
         v_reg.TIP_INTERFASE,
         v_reg.ID_INTERFASE,
         v_reg.VALORES,
         v_reg.MODELO,
         v_reg.MAC_ADDRESS,
         v_reg.UNIT_ADDRESS,
         v_reg.CUSTOMER_ID,
         v_reg.CODIGO_EXT,
         v_reg.ID_PRODUCTO,
         v_reg.ID_PRODUCTO_PADRE,
         v_reg.ID_SERVICIO_PADRE,
         v_reg.COD_ID,
         v_reg.CODCLI,
         ln_codsolot,
         v_reg.CODINSSRV,
         v_reg.PIDSGA,
         v_reg.ID_SERVICIO,
         v_reg.ESTADO,
         v_reg.CODACTIVACION,
         v_reg.TRS_PROV_BSCS,
         v_reg.ESTADO_BSCS,
         v_reg.ESTADO_IW);
    END LOOP;
  
  END;
  -- Fin 72.0
end pq_agendamiento;
/
