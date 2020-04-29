CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CUSPE_OPE AS
/******************************************************************************
   NOMBRE:    PQ_CUSPE_OPE
   DESCRIPCION:  Manejo de las customizaciones de Operaciones.


       Ver        Date        Author          Solicitado por       Description
       ---------  ----------  --------------- ----------------   ------------------------------------
       1.0        12/07/2005  Victor Valqui                       Creado
       2.0        13/07/2005  Carmen Quilca                       Permite enviar mail al area de provisionning
                                                                  al cambiar el estado de la tarea "ENVIAR A ATC" o
                                                                  ENVIAR A LEGAL". y cambiar el estado de la SOT a
                                                                  "ENVIAR A ATC" o ENVIAR A LEGAL".
        3.0       25/07/2007  Roy Concepción                      Procedimientos de Workflow automátivo y actualizatareaworkflow - para la automatización de paquetes Pymes y TPI
        4.0       19/03/2009  Hector Huaman                       REQ-85701: se modifico query, validar puerta - puerta por el flg_puerta( procedimientos: p_filtratareaworkflow y p_Asigna_Resp_Contrata
        5.0       13/05/2009  Hector Huaman                       REQ-92491: se modifico query para validar cuando un paquete tienes en su servicio cable analogico,  procedmiento p_filtratareaworkflow
        6.0       13/05/2009  Hector Huaman                       REQ-95364:se agrego validacion para producto Red Telmex Negocio,procedmiento p_filtratareaworkflow
        7.0       08/07/2009  Edilberto Astulle                   REQ-97265:se agrego el procedimiento p_reg_solotptoequ_gsm_cdma(generar las reservas de los proyectos de venta  de GSM)
        8.0       15/07/2009  Hector Huaman                       REQ-97536:se modifico el procedimiento P_WORKFLOWAUTOMATICOCABLE que asigne CID a todos los tipo de trabajo de tipo activacion y que no tenga asociado ya un CID
        9.0       13/08/2009  Hector Huaman M                     REQ-99917:se modifico el procedimiento P_REGISTRO_FECINSRV pata atender automaticamnet las altas de profesor 24 horas
        10.0      13/08/2009  Hector Huaman                       REQ-100671: se agrego validacion para producto Shared Server Hosting,procedmiento p_filtratareaworkflow
        11.0      23/08/2009  Hector Huaman                       REQ-103634: se agrego la funcion f_producto_sot
        12.0      29/09/2009  Hector Huaman                       REQ-104101: se comento obtencion de idmat para que se utilice el secuencial de la tabla solotptoetamat
        13.0      11/08/2009  Hector Huaman                       REQ-96885:se realizo modificaciones en el procedimiento P_REGISTRO_FECINSRV
        14.0      02/09/2009  Hector Huaman                       REQ-93190:se agrego validacion para reconocer cuando un servicio de telefonia
        15.0      06/11/2009  Hector Huaman                       REQ-92361:consideraciones para TPI
        16.0      01/12/2009  Alfonso Pérez                       REQ-110675: Tareas, Canalizacion y  GIS Canalización
        17.0      20/10/2009  Joseph Asencios                     REQ-102623: Se modificó el procedimiento p_filtratareaworkflow y se creó el procedimiento p_actualizar_area_tareawf
        18.0      14/12/2009  Marcos Echevarria                   REQ-111756: Se agregó obtencion de datos para considerar  tipo de trabajo 170 en el cierre automatico de tarea act/desct factur.
        19.0      13/01/2010  Luis Patiño                         Proyecto CDMA
        20.0      18/01/2009  Joseph Asencios                     REQ-113879: Se modificó el procedimiento p_filtratareaworkflow para que ponga a la tarea Asignación de recursos - NETSECURE (731) a No Interviene,
                                                                  solo para aquellas SOTs que tengan un servicio del grupo de productos Telmex Negocio - Seguridad Gestionada Centralizada (Idproducto 858)
        21.0      18/01/2010  Alfonso Pérez                       REQ-117403:SOT¿s Triple play cerradas por el SGA pero no efectuadas en Intraway
        22.0      15/04/2010  Marcos Echevarria                   REQ-123242: Las anotaciones son acotadas al maximo de su capacidad.
        23.0      26/04/2010  Marcos Echevarria                   REQ-126502: Se agrega el tipo de trabajo 442 en el procedimiento de p_filtratareaworkflow para poner como no interviene las tareas de agendamiento y liquidaciones telmex tv
        24.0      19/05/2010  Marcos Echevarria  César Rosciano   REQ-128017: Se comenta condicional de tipsrv para tomar en cuenta la asignacion de area configurada en p_actualizar_area_tareawf
        25.0      06/07/2010  Marcos Echevarria  Marco De La Cruz REQ-133887: Se modifica p_workflowautomaticoasigsu para que no actualice el area de la tarea  de ejecucion de procedimiento Intraway_cambio de plan
        26.0      25/08/2010  Alexander Yong     José Ramos       REQ-139507: Error del procedimiento constraint (OPEWF.PK_TAREAWFSEG
        27.0      23/08/2010  Alexander Yong     Cesar Rosciano   REQ-139928: Problemas con el cambio de área SOTs de Baja
        28.0      07/09/2010  Joseph Asencios    Marco De La Cruz REQ-132080: Se modifico proc. P_LIBERAR_NUMERORESERVADO
        29.0      06/10/2010                                      REQ.139588 Cambio de Marca
        30.0      24/01/2011  Alexander Yong     Miguel Londoña   REQ-150348: CREO - Rechazo de MIGRACION A RPV / Traslado externo de forma automática
        31.0      28/02/2011  Antonio Lagos                       REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
        32.0      07/04/2011  Antonio Lagos      Zulma Quispe     REQ-157966 SVA Fax Virtual
        33.0      11/05/2011  Antonio Lagos      Zulma Quispe     REQ-159162 Correccion para enviar correo
        34.0      16/05/2011  Alberto Miranda                     REQ 03: Cambio Reserva de Numero - Proyecto Central Virtual
        35.0      07/06/2011  Madeleine Isidro                    REQ159721: Correccion Asignación de Número - Proyecto Central Virtual
        36.0      25/08/2011  Antonio Lagos      Edilberto A.     REQ-160772: El Fax Server no debe tener asociado CID
        37.0      23/02/2012  Fernando Canaval   Edilberto A.     REQ-161730: Reconfiguración del servicio Fax Server CE en HFC.
        38.0      20/04/2012  Miguel Londoña                      Error en la asignacion de WF para CE.
        39.0      03/05/2012                     Edilberto A.     PROY-3766_Modificacion de las tareas de las SOT en HFC Claro Empresas
        40.0      13/07/2012                     Edilberto A.     PROY-4191_Cambio Work Flow CE HFC
        41.0      06/08/2012                     Edilberto A.     PQT-124883-TSK-12763 Office 365
        42.0      15/10/2012                     Edilberto A.     PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
        43.0      30/10/2012                     Edilberto A.     PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
        44.0      15/11/2012                     Edilberto A.     PROY-5513_HFC - Funcionalidad de Bajas de Servicio 3play
        45.0      30/01/2013 Alfonso Pérez Ramos Elver Ramirez    REQ:163839 CIERRE DE FACTURACIÓN
        46.0      30/03/2013                     Edilberto A.     PROY-6254_Recojo de decodificador
        47.0      01/07/2013 Carlos Lazarte      Tommy Arakaki    RQM 164387 - Mejoras en Operaciones
        48.0      07/08/2013 Erlinton Buitron    Alberto Miranda  REQ 164617 Instalacion TPI GSM
        49.0      08/11/2013                     Alberto Miranda  SD-845846 TPI-GSM No debe ser Transferido a Billing
        50.0      10/02/2014 Alex Alamo          Alberto Miranda  TPI-GSM Calculo de Nro. Telefonico
        51.0      25/03/2014 Dorian Sucasaca     Arturo Saavedra  REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
        52.0      28/05/2014 Justiniano Condori                   PQT-195288-TSK-49691 -  Portabilidad Numérica Fija ¿ Flujo Masivo
        53.0      13/06/2014 Dorian Sucasaca     Manuel Gallegos  PQT-195288-TSK-49690 - Portabilidad Numérica Fija  Flujo Corporativo
        54.0      10/08/2014 Justiniano Condori  Manuel Gallegos  PQT-207116-TSK-55835 - Portabilidad Numérica Fija - Flujo Masivo
        55.0      11/09/2014 Dorian Sucasaca     Manuel Gallegos  PQT-215654-TSK-60289
        56.0      04/05/2014 Jorge Rivas         Edilberto A.     SD-301932 Duplicidad de números - Altas CE HFC
        57.0      02/10/2015 Jose Varillas       Giovanni Vasquez SD-426907 Instalación diferentes MTA
        58.0      21/09/2016 Juan Olivares       Elias Reyes      SD-851979 Obtener Codcli según el Número de la Línea
        59.0      19/02/2019 Abel Ojeda                		  PROY-32581 Obtener fecha de Compromiso para SOT de Desactivacion por Sustitucion
    **********************************************************************************************************************/
  PROCEDURE P_CHG_TAREAWF_MAIL(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number,
                               a_tipesttar in number,
                               a_esttarea  in number,
                               a_mottarchg in number,
                               a_fecini    in date,
                               a_fecfin    in date) IS

    ls_desctarea tareawfcpy.descripcion%type;
    l_codsolot   number;
    l_estsol     number;
    l_tipestsol  number;

    l_cid        number;
    l_punto      number;
    ls_nomcli    vtatabcli.nomcli%type;
    ls_tiposot   tiptrabajo.descripcion%type;

    ls_subject      varchar2(200);
    ls_cuerpo       varchar2(4000);
    ls_cuerpo1      varchar2(4000);
    ls_sede         solotpto.descripcion%type;
    ls_descesttarea esttarea.descripcion%type;
    l_estado        number;

    cursor cur_obs is
      select punto, observacion
        from solotpto_id
       where codsolot = l_codsolot
         and flg_pi = 1;

  BEGIN

    /******************************************************************************
    Permite cambiar el estado de la solot segun sea el estado de la tarea
    "ENVIAR A ATC" o "ENVIAR A LEGAL".
    ******************************************************************************/
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select solot.estsol, tipestsol
      into l_estsol, l_tipestsol
      from solot, estsol
     where solot.estsol = estsol.estsol
       and codsolot = l_codsolot;

    if l_tipestsol = 6 then
      --EN EJECUCION
      if a_esttarea = 9 or a_esttarea = 10 then
        if (a_esttarea = 9) then
          l_estado := 28;
        end if;
        if (a_esttarea = 10) then
          l_estado := 27;
        end if;
      else
        l_estado := null;
      end if;

      if l_estado is not null then
        pq_solot.p_chg_estado_solot(l_codsolot, l_estado);
      end if;
    end if;

    /******************************************************************************
    Permite enviar mail al area de provisionning al cambiar el estado de la tarea
    "ENVIAR A ATC" o "ENVIAR A LEGAL".
    ******************************************************************************/
    if (a_esttarea = 9 or a_esttarea = 10) then

      select codsolot into l_codsolot from wf where idwf = a_idwf;

      select descripcion
        into ls_desctarea
        from tareawfcpy
       where idtareawf = a_idtareawf;

      select descripcion
        into ls_descesttarea
        from esttarea
       where esttarea = a_esttarea;

      select vtatabcli.nomcli, tiptrabajo.descripcion
        into ls_nomcli, ls_tiposot
        from solot, vtatabcli, tiptrabajo
       where solot.codcli = vtatabcli.codcli(+)
         and solot.tiptra = tiptrabajo.tiptra(+)
         and solot.codsolot = l_codsolot;

      ls_subject := 'SOT - ' || l_codsolot || ' - ' || 'Tarea - ' ||
                    ls_desctarea;

      ls_cuerpo := 'SOT: ' || l_codsolot || ' - Tipo SOT: ' || ls_tiposot ||
                   chr(13);
      ls_cuerpo := ls_cuerpo || 'Cliente: ' || ls_nomcli || chr(13);
      ls_cuerpo := ls_cuerpo || 'Tarea: ' || ls_desctarea || chr(13);
      ls_cuerpo := ls_cuerpo || 'Estado: ' || ls_descesttarea || chr(13) ||
                   chr(13);

      ls_cuerpo1 := '';

      for l in cur_obs loop
        l_cid   := null;
        ls_sede := null;
        select cid, descripcion
          into l_cid, ls_sede
          from solotpto
         where codsolot = l_codsolot
           and punto = l.punto;

        ls_cuerpo1 := ls_cuerpo1 || 'Punto: ' || l.punto || ' - ' ||
                      ls_sede || chr(13);
        ls_cuerpo1 := ls_cuerpo1 || 'CID: ' || l_cid || chr(13);

        ls_cuerpo1 := ls_cuerpo1 || 'Observacion: ' || l.observacion ||
                      chr(13);
      end loop;

      ls_cuerpo := ls_cuerpo || ls_cuerpo1 || chr(13);

      OPEWF.PQ_SEND_MAIL_JOB.P_SEND_MAIL(ls_subject,
                                         'adolfo.martinez@claro.com.pe',
                                         ls_cuerpo,
                                         'SGA');
    end if;
  END;

  PROCEDURE P_POS_CHECK_METRICA(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) IS
    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        14/07/2005  Carmen Quilca     Permite crear una plantilla automatica para
                                   marcar con check  de metrica una de las lineas
                           de las SOTs segun tipo de sot y servicio,
                           dicha relacion se encuentra en la tabla
                           TIPOTRABAJO_MET, y se ejecutara cuando se cierre la tarea:
                           GESTION DE PLANTA INTERNA.
    ******************************************************************************/
    l_codsolot number;
    l_tiptra   solot.tiptra%type;

    cursor cur_puntos is
      select punto, s.tiptra, codsrvnue
        from solot s, solotpto
       where s.codsolot = solotpto.codsolot
         and s.codsolot = l_codsolot;

    cursor cur_plantilla is
      select tiptra, codsrv from tiptrabajo_met where tiptra = l_tiptra;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    for l in cur_puntos loop
      l_tiptra := l.tiptra;
      for k in cur_plantilla loop
        if k.codsrv = l.codsrvnue then
          update solotpto_id
             set flg_pi = 1
           where codsolot = l_codsolot
             and punto = l.punto;
        end if;
      end loop;
    end loop;
    -- ini 55.0
    telefonia.pq_portabilidad.p_sisact_fech_est( a_idtareawf,
                                                 a_idwf,
                                                 a_tarea,
                                                 a_tareadef);
    -- fin 55.0
  END;

  PROCEDURE P_POS_TAREAWF_CERRAR_PUNTOS(a_idtareawf in number,
                                        a_idwf      in number,
                                        a_tarea     in number,
                                        a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        14/07/2005  Carmen Quilca     Permite cerrar los punto q no tienen
                                   check de metrica cuando se cierre la tarea
                           del wf ACTIVACION/DESACTIVACION DE SERVICIO.
    ******************************************************************************/
    l_codsolot    number;
    l_cont        number;
    l_punto       number;
    l_contmetrica number;

    cursor cur_punto is
      select punto, estado
        from solotpto_id
       where codsolot = l_codsolot
         and flg_pi = 0;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select count(1)
      into l_contmetrica
      from solotpto_id
     where codsolot = l_codsolot
       and flg_pi = 1;
    if l_contmetrica > 0 then
      --AL MENOS EXISTE UN PUNTO CON METRICA
      for l in cur_punto loop
        if ((l.estado = '---') OR (l.estado = 'Generado') OR
           (l.estado IS NULL)) then
          l_punto := l.punto;
          update solotpto_id
             set estado = 'Ejecutado'
           where codsolot = l_codsolot
             and punto = l_punto;
        end if;
      end loop;
    end if;
  END;

  PROCEDURE P_POS_TAREAWF_PERMISO(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        14/07/2005  Carmen Quilca     Permite actualizar la fecha de permiso de
                                   la tabla SOLOTPTO_ID, cuando se cierra la tarea
                           PERMISOS.
    ******************************************************************************/
    l_codsolot number;
    l_fecfin   date;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select fecfin into l_fecfin from tareawf where idtareawf = a_idtareawf;

    update solotpto_id
       set fecpermiso = l_fecfin
     where codsolot = l_codsolot;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_fecfin := NULL;

  END;

  PROCEDURE P_POS_TAREAWF_DISENO(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        14/07/2005  Carmen Quilca     Permite actualizar la fecha de dise?o de
                                   la tabla SOLOTPTO_ID, cuando se cierra la tarea
                           DISE?O.
    ******************************************************************************/
    l_codsolot number;
    l_fecfin   date;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select fecfin into l_fecfin from tareawf where idtareawf = a_idtareawf;

      update solotpto_id
         set fecdiseno = l_fecfin
       where codsolot = l_codsolot;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_fecfin := NULL;
  END;

  PROCEDURE p_workflowautomatico(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        25/07/2007  Roy Concepcion
    ******************************************************************************/

    l_codsolot       solotpto.codsolot%type;
    ln_valida_agenda number;
    l_valida_flag    number;
    ln_fax            number;--36.0

    CURSOR c1 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             tystabsrv.tipsrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid(+)
         and codsolot = l_codsolot;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;
    ln_valida_agenda := 0;
    l_valida_flag    := 0;

    select count(1)
      into l_valida_flag
      from solotpto s
     where s.codsolot = l_codsolot
       and s.flg_agenda = 1;

    UPDATE SOLOT_ADI SET FLGEF = 1, FLGSOT = 1,FEC_FLGSOT=SYSDATE WHERE CODSOLOT = l_codsolot;

    FOR au IN c1 LOOP
      IF au.flgprinc = 1 THEN
        UPDATE SOLOTPTO
           SET PUERTA = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        --ini 36.0
        select count(1) into ln_fax
          from opedd a,tipopedd b
         where a.tipopedd = b.tipopedd
           and b.abrev = 'PRODFAX'
           and a.abreviacion = 'PRODUCTO'
           and codigon = au.idproducto;
        --IF au.idproducto <> 524 and au.idproducto <> 702 then
        IF au.idproducto <> 524 and ln_fax = 0 then
        --fin 36.0
          METASOLV.P_MOVER_INSSRV_A_ACCESO(au.codinssrv);
        end if;
      ELSE
        UPDATE SOLOTPTO
           SET PUERTA = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
      END IF;
    END LOOP;
    ----Inserta Flg Agenda
    IF l_valida_flag = 0 THEN
      ---si tiene Flag Principal
      FOR a1 IN c1 LOOP
        IF a1.flgprinc = 1 THEN
          if a1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = a1.codsolot
               and punto = a1.punto;
            ln_valida_agenda := 1;
          end if;
        END IF;
      END LOOP;

      if ln_valida_agenda = 0 then
        FOR a2 IN c1 LOOP
          IF a2.flgprinc = 1 THEN
            if a2.tipsrv = '0061' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a2.codsolot
                 and punto = a2.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a3 IN c1 LOOP
          IF a3.flgprinc = 1 THEN
            if a3.tipsrv = '0006' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a3.codsolot
                 and punto = a3.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR a4 IN c1 LOOP
          IF a4.flgprinc = 1 THEN
            if a4.tipsrv = '0004' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a4.codsolot
                 and punto = a4.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR a5 IN c1 LOOP
          IF a5.flgprinc = 1 THEN
            if a5.tipsrv = '0058' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a5.codsolot
                 and punto = a5.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a6 IN c1 LOOP
          IF a6.flgprinc = 1 THEN
            if a6.tipsrv = '0050' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a6.codsolot
                 and punto = a6.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      --- Buscar producto secundario
      if ln_valida_agenda = 0 then
        FOR b1 IN c1 LOOP
          if b1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b1.codsolot
               and punto = b1.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b2 IN c1 LOOP
          if b2.tipsrv = '0061' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b2.codsolot
               and punto = b2.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b3 IN c1 LOOP
          if b3.tipsrv = '0006' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b3.codsolot
               and punto = b3.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b4 IN c1 LOOP
          if b4.tipsrv = '0004' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b4.codsolot
               and punto = b4.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b5 IN c1 LOOP
          if b5.tipsrv = '0058' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b5.codsolot
               and punto = b5.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b6 IN c1 LOOP
          if b6.tipsrv = '0050' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b6.codsolot
               and punto = b6.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      --Si no encuentra ninguno de los servicios anteriores, añade al flag agenda a un servicio
      if ln_valida_agenda = 0 then
        FOR b7 IN c1 LOOP
          if ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b7.codsolot
               and punto = b7.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

    end if;
  END;

  PROCEDURE P_WORKFLOWAUTO_DETALLE(a_codsolot in number) is
    CURSOR c1 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid
         and codsolot = a_codsolot
         and solotpto.puerta is null
         and tipsrv in ('0004', '0006', '0059');

  begin

    UPDATE SOLOT_ADI SET FLGEF = 1, FLGSOT = 1,FEC_FLGSOT=SYSDATE WHERE CODSOLOT = a_codsolot;

    FOR au IN c1 LOOP
      IF au.flgprinc = 1 THEN
        UPDATE SOLOTPTO
           SET PUERTA = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        IF au.idproducto <> 524 and au.idproducto <> 702 then
          METASOLV.P_MOVER_INSSRV_A_ACCESO(au.codinssrv);
        end if;
      ELSE
        UPDATE SOLOTPTO
           SET PUERTA = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
      END IF;
    END LOOP;
  end;

  PROCEDURE p_actualizartareaworkflow(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        25/07/2007  Roy Concepcion
    ******************************************************************************/

    l_tipsrv     vtatabslcfac.tipsrv%type;
    l_codsolot   solotpto.codsolot%type;
    l_count      number;
    l_countfax   number;
    l_countmail  number;
    -- ini 45.0
    ln_sot_cp    number;
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;
  ln_tarea    number;
    -- fin 45.0
    l_tiptra     number;
    l_solucion   number;
    ls_numslc    vtatabslcfac.numslc%type;
    ln_telefonia number;
    --ini 32.0
    ln_tipsrv_valido number;
    --fin 32.0
    l_contfxs integer; --39.0
    ln_cloud integer; --41.0
    l_no_agenda number;--42.0
    l_area number;--42.0
    l_tarea number;--42.0
    l_subject varchar2(200);--44.0
    l_cuerpo varchar2(4000);--44.0
    query_str  varchar2(200);--44.0
    l_cont_val number;--44.0
    CURSOR c1 IS
      select idtareawf, tarea, idwf, tareadef, tipo
        from tareawfcpy
       where idwf = a_idwf;

  BEGIN
    begin
      SELECT distinct s.tipsrv, s.tiptra
        into l_tipsrv, l_tiptra
        from solot s, wf b
       where s.codsolot = b.codsolot
         and rownum = 1
         and b.idwf = a_idwf;

      /* SELECT distinct a.tipsrv,s.tiptra into l_tipsrv,l_tiptra
      from  vtatabslcfac a,solot s, wf b
      where  a.numslc=s.numslc and s.codsolot = b.codsolot
             and b.idwf= a_idwf;*/

      select count(1)
        into l_solucion --- X-PLOR@ CONTROL
        from vtatabslcfac v, solot s, solotpto p, wf
       where v.numslc = s.numslc
         and s.estsol in (12, 29)
         and v.idsolucion = 59
         and p.codsolot = s.codsolot
         and s.codsolot = wf.codsolot
         and wf.idwf = a_idwf
         and p.cid in
             (select cid from solotpto where codsolot = s.codsolot --196192
              );

    exception
      when others then
        raise_application_error(-20411, 'no existe registro.' || a_idwf);
    end;

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    SELECT COUNT(1)
      into l_count
      FROM SOLOTPTO S, V_UBICACIONES V -- Lima - Provincias
     WHERE S.CODUBI = V.codubi
       AND V.codest <> 1
       AND V.CODPAI = 51
       AND S.CODSOLOT = l_codsolot;

    --ini 32.0
    select count(1) into ln_tipsrv_valido
    from opedd a,tipopedd b
    where a.tipopedd = b.tipopedd
    and b.abrev = 'PRODFAX' and a.abreviacion = 'FAMILIA'
    AND a.codigoc = l_tipsrv;

    if ln_tipsrv_valido > 0 then
    --fin 32.0
      SELECT count(1)
        into l_countfax
        FROM SOLOTPTO, tystabsrv
       WHERE solotpto.codsrvnue = tystabsrv.codsrv
         --ini 32.0
         --and tystabsrv.idproducto = 702
         and tystabsrv.idproducto in (select a.codigon from opedd a,tipopedd b
                                     where a.tipopedd = b.tipopedd
                                     and b.abrev = 'PRODFAX' and a.abreviacion = 'PRODUCTO')
         --fin 32.0
         and solotpto.codsolot = l_codsolot; -- FAX SERVER
    --ini 32.0
    end if;
    --fin 32.0

    SELECT count(1)
      into l_countmail
      FROM SOLOTPTO, tystabsrv
     WHERE solotpto.codsrvnue = tystabsrv.codsrv
       and tystabsrv.idproducto = 524
       and solotpto.codsolot = l_codsolot; -- SERVICIO E-MAIL

    select numslc into ls_numslc from solot where codsolot = l_codsolot;

    select count(1)
      into ln_telefonia
      from tystipsrv
     where tipsrv in (select b.tipsrv
                        from vtadetptoenl a, producto b
                       where a.numslc = ls_numslc
                         and a.idproducto = b.idproducto)
       and tipsrv = '0004';
    --Inicio 41.0
    select count(1) into ln_cloud
    from solotpto s, insprd e, tystabsrv f
    where s.pid = e.pid and e.codsrv in
    (select codigoc from opedd where tipopedd =  582)
    and e.codsrv=f.codsrv and s.codsolot = l_codsolot;
    --Inicio 41.0


     --<INI 45.0>
     begin
     select count(1)
       into ln_sot_cp
       from atccorp.atc_trs_baja_x_cp
      where codsolot = l_codsolot;
     exception
       when others then
         ln_sot_cp:=0;
     end;
    --<FIN 45.0>


    if l_tiptra <> 117 and l_tiptra <> 374 and l_tiptra <> 5 then
      --ini 32.0
      select count(1) into ln_tipsrv_valido
      from opedd a,tipopedd b
      where a.tipopedd = b.tipopedd
      and b.abrev = 'PRODFAX' and a.abreviacion = 'FAMILIA'
      AND a.codigoc = l_tipsrv;

      if ln_tipsrv_valido > 0 then
      --if l_tipsrv = '0058' or l_tipsrv = '0059' or l_tipsrv = '0061' then
      --fin 32.0
        -- para el caso de los proyectos pymes y TPI
        FOR au IN c1 LOOP
          if au.tipo = 1 then
            -- si la tarea esta en el tipo opcional
            IF au.TAREADEF = 523 THEN
              if l_countfax > 0 then
                --Inicio 39.0
                select count(1) into l_contfxs --Tarea Cerrada
                from tareawf where idtareawf=au.idtareawf
                and esttarea in (4,8);
                --Fin 39.0
                if l_contfxs = 0 then --39.0
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
                end if;  --39.0
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            END IF;
            IF au.TAREADEF = 554 THEN
              if l_countmail > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            END IF;
            IF au.tareadef = 103 then
              if l_count > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;
            if au.tareadef = 527 then
              if ln_telefonia > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;
            --Inicio 41.0
            if au.tareadef in (1077,1081) then
              if ln_cloud > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
               --Inicio 44.0
               select count(1) into l_cont_val from tipopedd where abrev ='ENVCORREOCLOUD';
               if l_cont_val=1 then
                 query_str :='begin OPEWF.P_MAIL_WF_SOLOT_PE ( :1, :2, :3, :4 ); End; ';
                 execute immediate  query_str
                 using IN au.idtareawf , IN 1, OUT l_subject, OUT l_cuerpo;
                 if au.tareadef = 1077 then
                    P_ENVIA_CORREO_DE_TEXTO_ATT(l_subject, 'ActivacionOffice365@claro.com.pe', l_cuerpo );
                 end if;
                 if au.tareadef = 1081 then
                    P_ENVIA_CORREO_DE_TEXTO_ATT(l_subject, 'SoportePrimerNivelCorporativo@claro.com.pe', l_cuerpo );
                 end if;
               end if;
               --Fin 44.0


              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(au.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            --Fin 41.0

            end if;
           --<INI 45.0>
          select codigon
            into ln_tarea
            from crmdd
           where abreviacion = 'CORTE_CP'  ;

           if au.tareadef = ln_tarea then
            if ln_sot_cp=1 then
              -- interviene
               opewf.pq_wf.p_chg_status_tareawf(au.idtareawf,
                                                       1,
                                                       4,
                                                       0,
                                                       sysdate,
                                                       sysdate);

              begin
              select codsolot into v_codsolot from wf where idwf = a_idwf;

              v_opcion := 7; -- Corte Telefonia
              intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                                         v_codsolot,
                                                         p_resultado,
                                                         p_mensaje,
                                                         p_error);

            EXCEPTION
              WHEN OTHERS THEN
                ROLLBACK;
                p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
                p_mensaje   := SQLERRM;
            end;

            else
               -- no interviene
               opewf.pq_wf.p_chg_status_tareawf(au.idtareawf,
                                                       4,
                                                       8,
                                                       0,
                                                       sysdate,
                                                       sysdate);
               -- Capturo el codigo de la solot


            end if;
          end if;
          --<FIN 45.0>
          end if;
        END LOOP;
      end if;

    end if;
    if l_tiptra = 117 then

      FOR a1 IN c1 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 557 THEN
            if l_countmail > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;
          IF a1.TAREADEF = 558 THEN
            if l_countfax > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;

          IF a1.TAREADEF = 559 THEN
            if l_count > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;
        end if;

      END LOOP;

    end if;

    if l_tiptra = 371 then
      FOR a1 IN c1 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 559 THEN
            if l_count > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;
        end if;

      END LOOP;

    end if;

    if l_tiptra = 370 then

      FOR a1 IN c1 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 557 THEN
            if l_countmail > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;
          IF a1.TAREADEF = 558 THEN
            if l_countfax > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;

          IF a1.TAREADEF = 559 THEN
            if l_count > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;
          IF a1.TAREADEF = 677 THEN
            if l_solucion > 0 then
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               1,
                                               1,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            else
              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               8,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
            end if;
          END IF;

        end if;

      END LOOP;

    end if;

    if l_tiptra = 5 then

      if l_tipsrv = '0058' then
        FOR a1 IN c1 LOOP
          if a1.tipo = 1 then
            if a1.TAREADEF = 559 then
              IF l_count > 0 THEN
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              END IF;
            end if;
            if a1.TAREADEF = 677 then
              IF l_solucion > 0 THEN
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              END IF;
            end if;

            if a1.TAREADEF = 370 then
              if l_countmail > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;

            if a1.TAREADEF = 539 then
              if l_countfax > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;

          end if;
        END LOOP;
      end if;

    end if;

    if l_tiptra = 374 then

      if l_tipsrv = '0058' then
        FOR a1 IN c1 LOOP
          if a1.tipo = 1 then
            if a1.TAREADEF = 559 then
              IF l_count > 0 THEN
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              END IF;
            end if;
            if a1.TAREADEF = 677 then
              IF l_solucion > 0 THEN
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              END IF;
            end if;

            if a1.TAREADEF = 370 then
              if l_countmail > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;

            if a1.TAREADEF = 539 then
              if l_countfax > 0 then
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 1,
                                                 1,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              else
                OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                                 4,
                                                 8,
                                                 0,
                                                 SYSDATE,
                                                 SYSDATE);
              end if;
            end if;

          end if;
        END LOOP;
      end if;

    end if;

    --Inicio 42.0
    if l_tiptra=620 or l_tiptra=724 then --<57.0>
      select count(1) into l_no_agenda from vtatabslcfac a, solot b
      where a.numslc=b.numslc and b.codsolot = l_codsolot
      and a.FLG_CEHFC_CP in(1,2) and a.FLG_AGENDA = 0; --<57.0>
      if l_no_agenda = 1 then
        select codigon, codigon_aux into l_area, l_tarea
        from opedd where tipopedd =283 and rownum=1;
        update tareawfcpy set area=l_area
        where idwf= a_idwf and tarea= l_tarea;
      end if;
    end if;
    --Fin 42.0
  END;

  PROCEDURE P_WORKFLOWAUTOMATICOCABLE(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS
    /******************************************************************************
       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       09/11/2007  Roy Concepcion    Procedimiento donde se agrega
                                               asignación de CID de Cable, y luego marca el flag FLG_AGENDA.
    ******************************************************************************/
    l_codsolot        solotpto.codsolot%type;
    l_tiptra          solot.tiptra%type;
    l_cid             number;
    ln_cont           number;
    l_rep             number;
    l_contador_puntos number;
    l_valida_flag     number;
    ln_valida_agenda  number;
    ln_contador       number;
    l_tiptrs          number;
    ln_fax            number;--36.0

    CURSOR c1 IS

      select solotpto.codsolot,
             solotpto.codinssrv,
             insprd.flgprinc,
             solotpto.cid, --<8.0>
             solotpto.pid,
             solotpto.punto,
             solotpto.flg_agenda,
             tystabsrv.dscsrv,
             tystabsrv.idproducto,
             tystabsrv.tipsrv
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid(+)
         and codsolot = l_codsolot;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    --Actualizamos el PID de la SOT
-- modificación par que sólo actualice el pid de esta SOT - 23/06/2008
--    operacion.P_actualiza_pidxsot;
/* inicio modificaciòn para que no asigne automàticamente pid a los solotpto - 19/08/2008 g. ormeno
     update solotpto s
      set s.pid = (select max(i.pid) from insprd i where i.codinssrv = s.codinssrv and i.codsrv = s.codsrvnue)
      where s.pid is null and s.codsolot = l_codsolot;
 fin 19/08/2008 g. ormeno
*/
-- fin de modoficación 23/06/2008

    commit;

    ln_valida_agenda := 0;
    ln_contador      := 0;
    l_valida_flag    := 0;

    select count(1)
      into l_valida_flag
      from solotpto s
     where s.codsolot = l_codsolot
       and s.flg_agenda = 1;

    UPDATE SOLOT_ADI SET FLGEF = 1, FLGSOT = 1,FEC_FLGSOT=SYSDATE WHERE CODSOLOT = l_codsolot;

    FOR au IN c1 LOOP
      --ini 36.0
      select count(1) into ln_fax
        from opedd a,tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev = 'PRODFAX'
         and a.abreviacion = 'PRODUCTO'
         and codigon = au.idproducto;
      --IF au.idproducto <> 524 and au.idproducto <> 702 then
      IF au.idproducto <> 524 and ln_fax = 0 then
      --fin 36.0
      --<8.0
        -- select tiptra into l_tiptra from solot where codsolot = l_codsolot;
           begin
           select tiptrs
             into l_tiptrs
             from solot s, tiptrabajo t
            where t.tiptra = s.tiptra
              and s.codsolot = l_codsolot;
           exception
            when others then
            l_tiptrs:=0;
           end;
        if l_tiptrs=1 and  au.cid is null then
        --if l_tiptra = 404 or l_tiptra = 424 or l_tiptra = 419 or l_tiptra = 438 THEN
        --8.0>
          --Solamente si es Instalacion o Traslado Externo
          METASOLV.P_MOVER_INSSRV_A_ACCESO(au.codinssrv);
        end if;
      end if;
  --REQ.65544 HHM  INICIO
/*      if ln_cont > 0 then
        SELECT max(ACCESO.CID)
          INTO l_cid
          FROM ACCESO, INSSRV, TIPINSSRV
         WHERE ACCESO.CODINSSRV = INSSRV.CODINSSRV
           AND INSSRV.TIPINSSRV = TIPINSSRV.TIPINSSRV
           AND TIPINSSRV.TIPINSSRV = 1
           AND INSSRV.CODINSSRV = au.codinssrv;
      end if;*/
  --REQ.65544 HHM  FIN
    END LOOP;

    IF l_valida_flag = 0 THEN

      ---si tiene Flag Principal

      FOR a1 IN c1 LOOP
        IF a1.flgprinc = 1 THEN
          if a1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = a1.codsolot
               and punto = a1.punto;
            ln_valida_agenda := 1;
          end if;
        END IF;
      END LOOP;

      if ln_valida_agenda = 0 then
        FOR a2 IN c1 LOOP
          IF a2.flgprinc = 1 THEN
            if a2.tipsrv = '0061' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET  flg_agenda = 1
               where codsolot = a2.codsolot
                 and punto = a2.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a3 IN c1 LOOP
          IF a3.flgprinc = 1 THEN
            if a3.tipsrv = '0006' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET  flg_agenda = 1
               where codsolot = a3.codsolot
                 and punto = a3.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a4 IN c1 LOOP
          IF a4.flgprinc = 1 THEN
            if a4.tipsrv = '0004' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET  flg_agenda = 1
               where codsolot = a4.codsolot
                 and punto = a4.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a5 IN c1 LOOP
          IF a5.flgprinc = 1 THEN
            if a5.tipsrv = '0058' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET  flg_agenda = 1
               where codsolot = a5.codsolot
                 and punto = a5.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      END IF;
      if ln_valida_agenda = 0 then
        FOR a6 IN c1 LOOP
          IF a6.flgprinc = 1 THEN
            if a6.tipsrv = '0050' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET  flg_agenda = 1
               where codsolot = a6.codsolot
                 and punto = a6.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;

      end if;

      --- Buscar producto secundario

      if ln_valida_agenda = 0 then
        FOR b1 IN c1 LOOP
          if b1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b1.codsolot
               and punto = b1.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR b2 IN c1 LOOP
          if b2.tipsrv = '0061' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b2.codsolot
               and punto = b2.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR b3 IN c1 LOOP
          if b3.tipsrv = '0006' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b3.codsolot
               and punto = b3.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR b4 IN c1 LOOP
          if b4.tipsrv = '0004' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b4.codsolot
               and punto = b4.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR b5 IN c1 LOOP
          if b5.tipsrv = '0058' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b5.codsolot
               and punto = b5.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR b6 IN c1 LOOP
          if b6.tipsrv = '0050' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET  flg_agenda = 1
             where codsolot = b6.codsolot
               and punto = b6.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

      --Si no encuentra ninguno de los servicios anteriores, añade al flag agenda a un servicio
      if ln_valida_agenda = 0 then
        FOR b7 IN c1 LOOP
          if ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b7.codsolot
               and punto = b7.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

    end if;

  END;

  PROCEDURE P_WORKFLOWAUTOMATICOASIGSUC(a_idtareawf in number,
                                        a_idwf      in number,
                                        a_tarea     in number,
                                        a_tareadef  in number) IS

    /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       09/11/2007  Roy Concepcion    Procedimiento que cambia las responsable depediendo de si es Lima o
                                               Chiclayo.
    ******************************************************************************/
    l_codsolot       solotpto.codsolot%type;
    l_rep            number;
    l_cid            number;
    l_areasol        number;
    l_wfdef          number;
    l_codubi         vtasuccli.ubisuc%type;
    l_nomest         v_ubicaciones.nomest%type;
    l_valida_flag    number;
    ln_valida_agenda number;

    CURSOR c1 IS
      select solotpto.codsolot,
             solotpto.codinssrv,
             insprd.flgprinc,
             solotpto.pid,
             solotpto.punto,
             solotpto.flg_agenda,
             tystabsrv.dscsrv,
             tystabsrv.idproducto,
             tystabsrv.tipsrv
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid(+)
         and codsolot = l_codsolot;

  BEGIN
    -- Capturo el codigo del wf y de la solot
    select wfdef, codsolot
      into l_wfdef, l_codsolot
      from wf
     where idwf = a_idwf;
    -- Capturo el area de la solot, para luego verificar si es de la sucursal del lima o chiclayo.
    select v.nomest
      into l_nomest
      from solotpto s, v_ubicaciones v
     where s.codsolot = l_codsolot
       and s.codubi = v.codubi
       and rownum = 1;
    select areasol into l_areasol from solot where codsolot = l_codsolot;

    if l_nomest = 'LAMBAYEQUE' then
      l_areasol := 205; -- Chiclayo
    else
      l_areasol := 200; -- Lima
    end if;

    l_rep := 0;

    UPDATE SOLOT_ADI SET FLGEF = 1, FLGSOT = 1,FEC_FLGSOT=SYSDATE WHERE CODSOLOT = l_codsolot;

-- modificación par que sólo actualice el pid de esta SOT - 23/06/2008 - GORMENO
--    operacion.P_actualiza_pidxsot;
/* inicio modificaciòn para que no asigne automàticamente pid a los solotpto - 19/08/2008 g. ormeno
     update solotpto s
      set s.pid = (select max(i.pid) from insprd i where i.codinssrv = s.codinssrv and i.codsrv = s.codsrvnue)
      where s.pid is null and s.codsolot = l_codsolot;
 fin 19/08/2008 g. ormeno
*/
-- fin de modoficación 23/06/2008
    commit;

    --if l_areasol = 200 or l_areasol = 205 then
    if (l_areasol = 200 or l_areasol = 205) and l_wfdef <> 834 then  --19.0
      -- Verifico si es del area de Lima o Chiclayo

      -- Modifica las areas para todas la tareas que estehen definidas en el wf de def.
      UPDATE tareawf
         set area = l_areasol
       WHERE idwf = a_idwf
       --ini 25.0
       /*and tareadef <> 527;*/ -- para que esta tarea quede en COMUTACIÓN
      and tareadef not in (527,697);
       --fin 25.0
      UPDATE tareawfcpy
         set area = l_areasol
       WHERE idwf = a_idwf
       --ini 25.0
        /*and tareadef <> 527;*/ -- para que esta tarea quede en COMUTACIÓN
       and tareadef not in (527,697);
       --fin 25.0
    end if;
    -- Para asignar el flag de la agenda
    ln_valida_agenda := 0;
    l_valida_flag    := 0;

    select count(1)
      into l_valida_flag
      from solotpto s
     where s.codsolot = l_codsolot
       and s.flg_agenda = 1;

    IF l_valida_flag = 0 THEN
      ---si tiene Flag Principal
      FOR a1 IN c1 LOOP
        IF a1.flgprinc = 1 THEN
          if a1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = a1.codsolot
               and punto = a1.punto;
            ln_valida_agenda := 1;
          end if;
        END IF;
      END LOOP;

      if ln_valida_agenda = 0 then
        FOR a2 IN c1 LOOP
          IF a2.flgprinc = 1 THEN
            if a2.tipsrv = '0061' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a2.codsolot
                 and punto = a2.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a3 IN c1 LOOP
          IF a3.flgprinc = 1 THEN
            if a3.tipsrv = '0006' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a3.codsolot
                 and punto = a3.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR a4 IN c1 LOOP
          IF a4.flgprinc = 1 THEN
            if a4.tipsrv = '0004' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a4.codsolot
                 and punto = a4.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR a5 IN c1 LOOP
          IF a5.flgprinc = 1 THEN
            if a5.tipsrv = '0058' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a5.codsolot
                 and punto = a5.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;

      if ln_valida_agenda = 0 then
        FOR a6 IN c1 LOOP
          IF a6.flgprinc = 1 THEN
            if a6.tipsrv = '0050' and ln_valida_agenda = 0 then
              UPDATE SOLOTPTO
                 SET flg_agenda = 1
               where codsolot = a6.codsolot
                 and punto = a6.punto;
              ln_valida_agenda := 1;
            end if;
          END IF;
        END LOOP;
      end if;
      --- Buscar producto secundario
      if ln_valida_agenda = 0 then
        FOR b1 IN c1 LOOP
          if b1.tipsrv = '0062' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b1.codsolot
               and punto = b1.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b2 IN c1 LOOP
          if b2.tipsrv = '0061' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b2.codsolot
               and punto = b2.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b3 IN c1 LOOP
          if b3.tipsrv = '0006' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b3.codsolot
               and punto = b3.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b4 IN c1 LOOP
          if b4.tipsrv = '0004' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b4.codsolot
               and punto = b4.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b5 IN c1 LOOP
          if b5.tipsrv = '0058' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b5.codsolot
               and punto = b5.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      if ln_valida_agenda = 0 then
        FOR b6 IN c1 LOOP
          if b6.tipsrv = '0050' and ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b6.codsolot
               and punto = b6.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;
      --Si no encuentra ninguno de los servicios anteriores, añade al flag agenda a un servicio
      if ln_valida_agenda = 0 then
        FOR b7 IN c1 LOOP
          if ln_valida_agenda = 0 then
            UPDATE SOLOTPTO
               SET flg_agenda = 1
             where codsolot = b7.codsolot
               and punto = b7.punto;
            ln_valida_agenda := 1;
          end if;
        END LOOP;
      end if;

    end if;

  END;

  PROCEDURE p_tareawfautomatico(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        30/11/2007  Roy Concepcion
    ******************************************************************************/

    l_codsolot solotpto.codsolot%type;

    CURSOR c1 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid
         and codsolot = l_codsolot
         and solotpto.puerta is null
         and tipsrv in ('0004', '0006', '0059');

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    UPDATE SOLOT_ADI SET FLGSOT = 1,FEC_FLGSOT=SYSDATE WHERE CODSOLOT = l_codsolot;

    FOR au IN c1 LOOP
      IF au.flgprinc = 1 THEN
        UPDATE SOLOTPTO
           SET PUERTA = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
      ELSE
        UPDATE SOLOTPTO
           SET PUERTA = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
      END IF;
    END LOOP;
  END;

  PROCEDURE p_CargaMatxEtapa(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) IS

    n_solot         solot.codsolot%type;
    n_orden         number;
    n_espaquete     number;
    n_idmat         number;
    n_esCable       number;
    n_esInternet    number;
    n_producto      number;
    n_hayMateriales number;

    cursor c_puntos(v_solot solot.codsolot%type) is
      select * from solotpto where codsolot = v_solot;

    cursor c_materiales(v_codsrv solotpto.codsrvnue%type, v_espaquete char) is
      select *
        from operacion.SERVICIOXMATERIAL
       where codsrv = v_codsrv
         and espaquete = v_espaquete;

  begin

    n_espaquete  := 0;
    n_esCable    := 0;
    n_esInternet := 0;

    -- ubicar sot
    select codsolot into n_solot from wf where wf.idwf = a_idwf;

    -- Por si existiesen una carga previa de materiales generada por un WF que fue cancelado
    -- Se elimina cualquier ingreso previo de materiales, ya que la carga proviene de una tarea automática
    -- inicio GORMENO, MBALCAZAR. 27/02/2008
    delete from solotptoetamat where codsolot = n_solot;
    delete from solotptoeta where codsolot = n_solot;
    -- fin GORMENO, MBALCAZAR. 27/02/2008

    for c_ptos in c_puntos(n_solot) loop

      select t.idproducto
        into n_producto
        from tystabsrv t
       where t.codsrv = c_ptos.codsrvnue;

      if (n_producto = 768) then
        n_esCable := 1;
      end if;

      if (n_producto = 767) then
        n_esInternet := 1;
      end if;

    end loop;

    if (n_esCable = 1 and n_esInternet = 1) then
      n_espaquete := 1;
    end if;

    n_orden := 1;
    -- ubicar servicios
    for c_ptos in c_puntos(n_solot) loop
      select t.idproducto
        into n_producto
        from tystabsrv t
       where t.codsrv = c_ptos.codsrvnue;

      if (n_espaquete = 1 and (n_producto = 768 /*or n_producto = 767*/
         )) then
        /*
                  select count(esprincipal) into n_esPrincipal
                  from operacion.SERVICIOPRINCIPAL_MATERIALES S
                  where S.tipsrv = c_ptos.odsrvnue
                  and esprincipal = 1;
        */
        /*          if(n_esPrincipal = 1) then*/
        select COUNT(1)
          INTO n_hayMateriales
          from operacion.SERVICIOXMATERIAL
         where codsrv = c_ptos.codsrvnue
           and espaquete = 1;

        if n_hayMateriales > 0 then

          insert into solotptoeta
            (codsolot, punto, orden, codeta)
          values
            (c_ptos.codsolot, c_ptos.punto, n_orden, 700);
          -- insertar equipo por cada punto
          for c_mat in c_materiales(c_ptos.codsrvnue, n_espaquete) loop

            --select nvl(max(idmat), 0) + 1 into n_idmat from solotptoetamat; <12.0>

            insert into solotptoetamat
              (codsolot,
               punto,
               orden,
               codmat,
               --idmat, <12.0>
               moneda_id,
               candis,
               cosdis,
               codfas)
              select c_ptos.codsolot,
                     c_ptos.punto,
                     n_orden,
                     m.CODMAT,
                     --n_idmat, <12.0>
                     m.moneda_id,
                     c_mat.cant,
                     m.costo,
                     1
                from matope m
               where to_number(m.codmat) = c_mat.codmat;
          end loop;
        end if;
        -- n_espaquete:= 0;

        /*          end if;*/

      else
        if (n_espaquete = 0 or (n_espaquete = 1 and n_producto <> 767)) then
          -- por cada servicio
          -- insetar punto por cada servicio

          -- VERFICAMOS SI EXISTEN MATERIALES PREDEFINIDOS PARA ESE TIPO DE SERVICIO.
          select COUNT(1)
            INTO n_hayMateriales
            from operacion.SERVICIOXMATERIAL
           where codsrv = c_ptos.codsrvnue
             and espaquete = 0;

          if n_hayMateriales > 0 then
            insert into solotptoeta
              (codsolot, punto, orden, codeta)
            values
              (c_ptos.codsolot, c_ptos.punto, n_orden, 700);
            -- insertar equipo por cada punto

            for c_mat in c_materiales(c_ptos.codsrvnue, 0) loop

              --select max(idmat) + 1 into n_idmat from solotptoetamat;  <12.0>

              insert into solotptoetamat
                (codsolot,
                 punto,
                 orden,
                 codmat,
                 -- idmat, <12.0>
                 moneda_id,
                 candis,
                 cosdis,
                 codfas)
                select c_ptos.codsolot,
                       c_ptos.punto,
                       n_orden,
                       m.CODMAT,
                      -- n_idmat, <12.0>
                       m.moneda_id,
                       c_mat.cant,
                       m.costo,
                       1
                  from matope m
                 where to_number(m.codmat) = c_mat.codmat;

            end loop;
          end if;
        end if;
      end if;
    end loop;

  end;

  PROCEDURE P_CREA_TAREA_WF_INDEP(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) IS

    n_wfdef       NUMBER;
    n_tipo        NUMBER;
    n_plazo       NUMBER default null;
    n_area        NUMBER;
    n_responsable CHAR default null;
    n_pre_mail    CHAR default null;
    n_pos_mail    CHAR default null;
    n_tarea       TAREAWFCPY.tarea%TYPE;
    n_idtareawf   TAREAWFCPY.idtareawf%TYPE;
    n_estwf       number;
    l_codsolot    solot.codsolot%type;
    l_count       number;
    /******************************************************************************
    PROCEDIMIENTO PARA GENERAR TAREAS EN WF EN EJECUCION SIN DEPENDENCIA
      REVISIONES:
      Ver        Fecha       Autor            Descripcion
      ---------  ----------  ---------------  ------------------------
      1.0        17/01/2008  Roy Concepcion
      Contantes:
      a_tipo: 0 (Normal), 1 (Opcional) y 2 (Automatica)
    ******************************************************************************/

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select wfdef into n_wfdef from wf where idwf = a_idwf;
    select count(1)
      into l_count
      from solotpto
     where codsolot = l_codsolot
       -- ini 38.0
       -- and codsrvnue = 4666;
       and codsrvnue = '4666';
       -- fin 38.0
    n_tipo := 1;
    n_area := 56;

    if l_count > 0 then
      select estwf into n_estwf from wf where idwf = a_idwf;

      IF n_estwf in (3, 5) THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'No puede generar tareas en Flujos Suspendidos o Cancelados');
      END IF;

      --Validacion de tarea exista en el flujo
      SELECT MAX(tarea) + 1
        INTO n_tarea
        FROM TAREAWFCPY
       WHERE idwf = a_idwf;
      --Se crea el registro instanciado de la tarea dinamica
      SELECT opewf.F_Get_Id_Tareawfcpy() INTO n_idtareawf FROM dummy_ope;

      INSERT INTO TAREAWFCPY
        (IDTAREAWF,
         TAREA,
         IDWF,
         DESCRIPCION,
         TIPO,
         AREA,
         RESPONSABLE,
         WFDEF,
         TAREADEF,
         PRE_MAIL,
         POS_MAIL,
         PRE_PROC,
         CUR_PROC,
         CHG_PROC,
         POS_PROC,
         PLAZO,
         OPCIONAL)
        SELECT n_idtareawf,
               n_tarea,
               a_idwf,
               descripcion,
               n_tipo,
               n_area,
               n_responsable,
               n_wfdef,
               a_tareadef,
               DECODE(pre_mail,
                      NULL,
                      n_pre_mail,
                      pre_mail || ',' || nvl(n_pre_mail, '')),
               DECODE(pos_mail,
                      NULL,
                      n_pos_mail,
                      pos_mail || ',' || nvl(n_pos_mail, '')),
               pre_proc,
               cur_proc,
               chg_proc,
               pos_proc,
               n_plazo,
               NULL
          FROM TAREADEF
         WHERE TAREADEF = 660;

      Pq_Wf.P_GENERA_TAREA(a_idwf, n_tarea, n_idtareawf);

      INSERT INTO V_TAREAWF
        (IDTAREAWF,
         MOTTARCHG,
         TAREA,
         IDWF,
         TIPESTTAR,
         ESTTAREA,
         TAREADEF,
         AREA,
         RESPONSABLE,
         TIPO,
         FECCOM,
         FECINI,
         FECFIN,
         FECINISYS,
         FECFINSYS,
         USUFIN,
         OBSERVACION,
         FECUSUMOD,
         OPCIONAL,
         CODUSUMOD)
        SELECT IDTAREAWF,
               MOTTARCHG,
               TAREA,
               IDWF,
               TIPESTTAR,
               ESTTAREA,
               TAREADEF,
               AREA,
               RESPONSABLE,
               TIPO,
               FECCOM,
               FECINI,
               FECFIN,
               FECINISYS,
               FECFINSYS,
               USUFIN,
               OBSERVACION,
               FECUSUMOD,
               OPCIONAL,
               CODUSUMOD
          FROM TAREAWF
         WHERE IDTAREAWF = n_idtareawf;

    end if;
  END;

  PROCEDURE P_EJECUTA_PROC_WF(pnomproc in varchar2, constante in number) IS
    query_str varchar2(2500);
  BEGIN
    query_str := 'begin ' || pnomproc || ' ( :1, :2 ); End; ';
    execute immediate query_str
      using constante;
  exception
    when others then
      raise;
  END;

  FUNCTION F_VALIDA_MOTIVO(an_codsolot NUMBER, an_motivo NUMBER)
    RETURN VARCHAR2 is
    an_codmot NUMERIC;
    an_valida numeric;
  BEGIN
    SELECT count(1)
      into an_codmot
      FROM solot
     WHERE CODMOTOT = an_motivo
       AND CODSOLOT = an_codsolot;

    IF (an_codmot IS NULL) or (an_codmot = 0) THEN
      an_valida := 0;
    ELSE
      an_valida := 1;
    END IF;
    RETURN(an_valida);
  END;

  PROCEDURE p_filtratareaworkflow( a_idtareawf in number,
                               a_idwf in number,
                               a_tarea in number,
                               a_tareadef in number
                             )
IS

/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/03/2008  Hector Huaman M.  Actualiza los estados de las tareas de la SOT, dependiendo del detalle de la SOT.
******************************************************************************/


l_tipsrv   vtatabslcfac.tipsrv%type;
l_codsolot solotpto.codsolot%type;
l_numslc solot.numslc%type;
l_hora VARCHAR2(50);
l_fecha VARCHAR2(50);
l_tipmotot motot.tipmotot%type;
l_count  number;
l_countfax number;
l_countmail number;
l_countnumtpi number;
l_countnumadic number;
l_tiptra number;
l_solucion number;
l_countwireless1 number;
l_countwireless2 number;
l_countcobre1 number;
l_countcobre2 number;
l_countfibra1 number;
l_countfibra2 number;
l_countsatelital1 number;
l_countsatelital2 number;
l_codmotot number;
l_countPIA number;
l_countinmobiliario number;
l_countanalogica number;
l_countdigital number;
--l_countCableAnalog number; <11.0>
ln_countagendacabletripleplay  number;
l_counttpicoaxial number;
l_countpermisos number;
ll_punto number;
l_countrx number;
l_numslc_ori vtatabslcfac.numslc%type;
l_countcabinas number;
l_countredclaro number;
l_countsharedsever number; --<10.0>
l_counttelefonia number; --<14.0>
l_cont_etapa number; --<16.0>
l_bajasot number ;  --<21.0>
--<REQ ID = 102623>
ln_solucion   number;
ln_idcampanha number;
ln_area       number;
ln_wfdef      number;
--</REQ>

CURSOR c1 IS select idtareawf,tarea,idwf,tareadef,tipo from tareawfcpy where idwf=a_idwf;

BEGIN
begin

     select codsolot ,
            wfdef      -- REQ 102623
     into l_codsolot ,
          ln_wfdef     -- REQ 102623
     from wf where idwf = a_idwf;

     SELECT distinct s.tipsrv,s.tiptra,s.codmotot,s.numslc into l_tipsrv,l_tiptra,l_codmotot,l_numslc
     from  solot s, wf b
     where  s.codsolot = b.codsolot and rownum=1
            and b.idwf= a_idwf;

     --<REQ ID = 102623>
     begin
      select idsolucion , idcampanha
      into ln_solucion, ln_idcampanha
      from vtatabslcfac
      where numslc = (select max(numslc) from insprd
      where codinssrv in
      (select codinssrv from solotpto
      where codsolot = l_codsolot));

     exception
      when others then
        null;
     end;

     --</REQ>

 --Tipo de motivo
     BEGIN
     select  tipmotot into l_tipmotot from motot
     where codmotot= l_codmotot;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
         l_tipmotot := 0;
    END;

--- Tipo de Solucion  Control
      select count(1)
        into l_solucion
        from solotpto p, tystabsrv t
       where p.codsrvnue = t.codsrv
         and t.flag_lc = 1
         and p.codsolot = l_codsolot;

     if l_numslc is not null then
      begin
        select numslc_ori
          into l_numslc_ori
          from regvtamentab
         where numregistro in (select nvl(max(r.numregistro), 0)
                                 from regvtamentab r
                                where r.numslc = l_numslc);
      exception
        when too_many_rows then

          select numslc_ori
            into l_numslc_ori
            from regvtamentab
           where numregistro in (select nvl(max(r.numregistro), 0)
                                   from regvtamentab r
                                  where r.numslc = l_numslc)
          and rownum = 1;

     WHEN NO_DATA_FOUND THEN
         l_numslc_ori := null;
    END;

    if (l_numslc_ori is not null) and (l_solucion=0) then
      select count(1)
        into l_solucion
        from solotpto p, tystabsrv t, solot s
       where s.codsolot=p.codsolot
         and p.codsrvnue = t.codsrv
         and t.flag_lc = 1
         and s.numslc=l_numslc_ori;
    end if;

  end if;

exception
  when others then
         raise_application_error (-20411, 'no existe registro.'||a_idwf);
end;

     SELECT COUNT(1) into l_count FROM SOLOTPTO S,V_UBICACIONES V -- Lima - Provincias
     WHERE  S.CODUBI=V.codubi AND
            V.codest=1  and codpvc in(1,2) AND
            V.CODPAI = 51 AND
            S.CODSOLOT=l_codsolot;

    ---mediotx wireless
    select count(1) into l_countwireless1
    from efpto e,
    solotpto s1,
    solot so,
    opedd op
          where
   so.codsolot=s1.codsolot
   and s1.efpto=e.punto
   and so.numslc=e.codef
   and op.codigon=e.mediotx
   and op.tipopedd=169
   and op.codigon in (2,6,7)
   and s1.codsolot=l_codsolot;

  select count(1)  into l_countwireless2
         from OPEDD op7,
        puertoxequipo pxe7,
         cidxide cxi7,
         solotpto s2
         where
         s2.cid=cxi7.cid
          and cxi7.ide=pxe7.ide
          and op7.codigon=pxe7.mediotx
          and op7.tipopedd=169
          and op7.codigon in (2,6,7)
          and s2.codsolot=l_codsolot;

    ---mediotx cobre
    select count(1) into l_countcobre1
    from efpto e,
    solotpto s1,
    solot so,
    opedd op
          where
   so.codsolot=s1.codsolot
   and s1.efpto=e.punto
   and so.numslc=e.codef
   and op.codigon=e.mediotx
   and op.tipopedd=169
   and op.codigon=1
   and s1.codsolot=l_codsolot;

   select count(1)  into l_countcobre2
         from OPEDD op7,
        puertoxequipo pxe7,
         cidxide cxi7,
         solotpto s2
         where
         s2.cid=cxi7.cid
          and cxi7.ide=pxe7.ide
          and op7.codigon=pxe7.mediotx
          and op7.tipopedd=169
          and op7.codigon=1
          and s2.codsolot=l_codsolot;

      ---mediotx fibra
    select count(1) into l_countfibra1
    from efpto e,
    solotpto s1,
    solot so,
    opedd op
          where
   so.codsolot=s1.codsolot
   and s1.efpto=e.punto
   and so.numslc=e.codef
   and op.codigon=e.mediotx
   and op.tipopedd=169
   and op.codigon=3
   and s1.codsolot=l_codsolot;

  select count(1)  into l_countfibra2
         from OPEDD op7,
        puertoxequipo pxe7,
         cidxide cxi7,
         solotpto s2
         where
         s2.cid=cxi7.cid
          and cxi7.ide=pxe7.ide
          and op7.codigon=pxe7.mediotx
          and op7.tipopedd=169
          and op7.codigon=3
          and s2.codsolot=l_codsolot;

    ---mediotx Satelital
    select count(1) into l_countsatelital1
    from efpto e,
    solotpto s1,
    solot so,
    opedd op
          where
   so.codsolot=s1.codsolot
   and s1.efpto=e.punto
   and so.numslc=e.codef
   and op.codigon=e.mediotx
   and op.tipopedd=169
   and op.codigon=4
   and s1.codsolot=l_codsolot;

   select count(1)  into l_countsatelital2
         from OPEDD op7,
        puertoxequipo pxe7,
         cidxide cxi7,
         solotpto s2
         where
         s2.cid=cxi7.cid
          and cxi7.ide=pxe7.ide
          and op7.codigon=pxe7.mediotx
          and op7.tipopedd=169
          and op7.codigon=4
          and s2.codsolot=l_codsolot;


      SELECT count(1) into l_countfax FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto = 702 and
      solotpto.codsolot=l_codsolot; -- FAX SERVER

      SELECT count(1) into l_countmail FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto = 524 and
      solotpto.codsolot=l_codsolot; -- SERVICIO E-MAIL

      SELECT count(1) into l_countPIA FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto = 523 and
      solotpto.codsolot=l_codsolot; -- Professional Internet Access


      SELECT count(1) into l_countnumtpi FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto = 757 and
      solotpto.codsolot=l_codsolot; -- Numeracion TPI

      SELECT count(1) into l_countnumadic FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto =21 and
      solotpto.codsolot=l_codsolot; -- Numera Adicionales

      SELECT count(1) into l_countinmobiliario FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto =712 and
      solotpto.codsolot=l_codsolot; -- Internet ADSL Claro

      SELECT count(1) into l_countanalogica FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      tystabsrv.idproducto =503 and
      solotpto.codsolot=l_codsolot; -- Linea Analogica

      SELECT count(1) into l_countdigital FROM solotpto, tystabsrv, insprd, vtadetptoenl, paquete_venta
      WHERE vtadetptoenl.idpaq=paquete_venta.idpaq
      and solotpto.codsrvnue = tystabsrv.codsrv
      and insprd.numslc=vtadetptoenl.numslc
       and vtadetptoenl.numpto=insprd.numpto
       and insprd.codequcom is not null
       and solotpto.pid = insprd.pid(+)
       and insprd.codequcom is not null
      --and paquete_venta.tipo in (1,4)
      and solotpto.codsolot=l_codsolot; -- Paquete Digital
  --<5.0
/*      SELECT count(1) into l_countCableAnalog
          FROM solotpto, insprd
         WHERE solotpto.codsrvnue = '5058'
           and solotpto.pid = insprd.pid
           and insprd.flgprinc = 1
           and solotpto.codsolot = l_codsolot; -- Paquete con cable analògico*/
    --<11.0
/*      SELECT count(1) into l_countCableAnalog
          FROM solotpto
         WHERE solotpto.codsrvnue = '5058'
           and solotpto.codsolot = l_codsolot; -- Paquete con cable analògico */--11.0>
--5.0>

       select count(1)
         into ln_countagendacabletripleplay
         from vtatabprecon v, solot s
        where v.numslc = s.numslc
          and s.codsolot = l_codsolot
          and (v.codmotivo_tf in (select codmotivo
                                    from vtatabmotivo_venta
                                   where codtipomotivo = '023'                 --REQ modifico query, validar puerta - puerta por el flg_puerta
                                     and flg_puerta = 1) or v.codmotivo = 22); -- se cambio el motivo


      select count(1) into l_counttpicoaxial
      from solot s,vtatabslcfac v where
      s.numslc=v.numslc and s.codsolot=l_codsolot
      and v.idcampanha=43;          -- TPI Coaxial

      --<21.0> contador de sot de baja, para tiptra 448
      select count(1)
      into l_bajasot
      from solot
      where tiptra = 448
      and codsolot = l_codsolot;

      select count(1) into l_countpermisos  from
      efptoeta e,
      solot s
      where
      e.codef=to_number(s.numslc)
      and e.codeta  in(644)
      and s.codsolot=l_codsolot;--Etapa CLIENTE-PERMISOS

      select count(1) into l_countcabinas
      from solot s,vtatabslcfac v where
      s.numslc=v.numslc and s.codsolot=l_codsolot
      and v.idsolucion in(60,63);  -- Claro cabinas
 --<6.0
      select count(1) into l_countredclaro
      from solot s,vtatabslcfac v,solotpto p , tystabsrv tb where
      s.numslc=v.numslc and s.codsolot=l_codsolot and
      v.idsolucion in(95) and p.codsolot=s.codsolot
      and tb.codsrv=p.codsrvnue and tb.idproducto in(834) ;  -- Red Claro Empresa
--6.0>
      --<10.0
      SELECT count(1) into l_countsharedsever FROM SOLOTPTO,tystabsrv
      WHERE solotpto.codsrvnue = tystabsrv.codsrv and
      --ini 32.0
      --tystabsrv.idproducto =842 and
      tystabsrv.idproducto in (select a.codigon from opedd a,tipopedd b
                               where a.tipopedd = b.tipopedd
                               and b.abrev = 'PRODMAIL') and
      --fin 32.0
      solotpto.codsolot=l_codsolot; -- Shared Server Hosting
      --10.0>
      --<14.0
      select count(1) into l_counttelefonia
      from solotpto s,inssrv i where
      s.codinssrv=i.codinssrv and s.codsolot=l_codsolot and
      i.tipinssrv=3 ;  -- Servicio de Telefonia
      --14.0>
      BEGIN

         select count(1) into l_countrx from reconexion_apc
         where codsolotrx=l_codsolot;

      EXCEPTION
         WHEN  OTHERS THEN
         l_countrx := 0;
      END;

        FOR a1 IN c1 LOOP
           if a1.tipo=1 then
               if a1.TAREADEF=5  then
                  IF l_count = 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN--Valida si es Provincia
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               if a1.TAREADEF=20  then
                  IF l_count = 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN--Valida si es Provincia
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               if    a1.TAREADEF=62 then
                  IF l_count = 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN--Valida si es Provincia
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               if a1.TAREADEF=91  then
                  if l_countwireless1 > 0 or l_countwireless2 > 0 then--valida medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
                   if l_count = 0  then--valida medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              if   a1.TAREADEF=192  then
                  IF l_count = 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN--Valida si es Provincia
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               if a1.TAREADEF=220 then
                   if  l_countsatelital1 > 0 or l_countsatelital2 >0 then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=223 then
                   if  l_countsatelital1 = 0 and l_countsatelital2 = 0 then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=227 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=229 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=245 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=316 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=340   then
                  if (l_tipmotot=1 or l_tipmotot=3) or ( l_countcabinas>0) then--valida motivo RETRASO DE PAGOS
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
                  --<REQ ID = 102623>
                  if l_tipsrv = '0058' then
                     begin
                        select area into ln_area from reasigna_area_wf
                        where idsolucion = ln_solucion and
                              idcampanha = ln_idcampanha and
                              wfdef = ln_wfdef and
                              tareadef = a1.TAREADEF;


                        update tareawf
                        set area  = ln_area
                        where idtareawf = a1.idtareawf;

                        update tareawfcpy
                        set area  = ln_area
                        where idtareawf = a1.idtareawf ;
                     exception
                      when others then
                       null;
                     end;
                  end if;
                  --</REQ>
               END IF;
               if a1.TAREADEF=341  then
                  IF l_tipmotot=2 or l_tipmotot=3  THEN --valida motivo RETRASO DE PAGOS
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
                if a1.TAREADEF=370 then
                   if l_countmail = 0 then--Valida si tiene correo
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
                end if;
               if a1.TAREADEF=425 then
                   if l_count > 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if   a1.TAREADEF=431 then
                  IF l_count > 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
                IF a1.TAREADEF=433 THEN
                  if l_count=0 or ((l_countfibra1=0 and l_countfibra2=0) and (l_countcobre1=0 and l_countcobre2=0) )then--Valida si es Provincia y medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
                IF a1.TAREADEF=434  THEN
                  if l_count=0 and l_countanalogica>0 then --Valida si es Provincia y medio analogico
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if a1.TAREADEF=435 then
                   if l_counttpicoaxial > 0 then--Valida si es  tpi coaxial
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF = 445   then
                  IF l_codmotot = 443  THEN--valida motivo LIMITE DE CRÉDITO VENCIDO
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
                if a1.TAREADEF = 453 then
                      if (l_count > 0) or (l_countsatelital1 > 0 or l_countsatelital2 > 0) then--Valida Provincia
                           OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                       end if;
                end if;
                if a1.TAREADEF = 454 then
                      if l_countfax = 0 and ln_solucion <> 58 then--Valida si tiene Fax server    --REQ 102623
                           OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                       end if;

                end if;
              if   a1.TAREADEF=455   then
                  IF l_count > 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) or (l_countsatelital1 > 0 or l_countsatelital2 > 0) THEN
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;

              if   a1.TAREADEF=456   then
                  IF l_count > 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) or (l_countsatelital1 > 0 or l_countsatelital2 > 0) THEN
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;

              if   a1.TAREADEF=457 then
                  IF l_count > 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) THEN
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
              if  a1.TAREADEF=458 then
                   IF l_count > 0 or (l_countwireless1 > 0 or l_countwireless2 > 0) or (l_countsatelital1 > 0 or l_countsatelital2 > 0) THEN
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
                if  a1.TAREADEF=456 then
                  IF l_count>0  THEN--Valida si es provincia
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
                  IF l_countwireless1>0 OR l_countwireless2>0 THEN--Valida medio de acceso
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               if a1.TAREADEF=462   then
                  IF l_count = 0 then --Valida Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
                if  a1.TAREADEF=490 then
                  IF l_countcobre1 = 0 and l_countcobre2 = 0 THEN--valida medio de acceso
                     OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,4,0,SYSDATE,SYSDATE);
                  END IF;
               end if;
               IF a1.TAREADEF=501 THEN
                  if l_countmail = 0 and l_countPIA = 0 and l_countinmobiliario=0 then--Valida si correo y producto
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if a1.TAREADEF=519  then
                   if l_count = 0 or((l_countfibra1=0 and l_countfibra2>0 ) and (l_countcobre1=0 or l_countcobre2=0)) then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=520 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=522 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=524 then
                   if  l_countsatelital1 = 0 and l_countsatelital2 = 0 then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=530 then
                   if  l_countsatelital1 = 0 and l_countsatelital2 = 0 then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=536 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=537 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=539 then
                   if l_countfax = 0 then -- Valida si tiene fax server
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=540   then
                  IF l_tipmotot=2  THEN--valida motivo RETRASO DE PAGOS
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  else
                    if l_codmotot<>443 then --valida motivo LIMITE DE CRÉDITO VENCIDO
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                    end if;
                  end if;
               END IF;
               if a1.TAREADEF=541  then
                  IF l_codmotot<> 443  THEN--valida motivo LIMITE DE CRÉDITO VENCIDO
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if a1.TAREADEF=545 then
                   if l_count > 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=546 then
                   if l_count = 0 or l_countpermisos=0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;

               if a1.TAREADEF=547 then
                   if (l_countcobre1 > 0 OR l_countcobre2 > 0) or (l_countfibra1> 0 OR l_countfibra2> 0 ) then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,4,0,SYSDATE,SYSDATE);
                   else
                   OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;

               if a1.TAREADEF=548 then
                   if l_numslc is null then
                   OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;

               IF a1.TAREADEF=557 THEN
                  if l_countmail = 0 then--Valida si tiene correo
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               IF a1.TAREADEF=558 THEN
                  if l_countfax = 0 then -- Valida si tiene fax server
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               IF a1.TAREADEF=559 THEN
                  if l_count > 0 then--Valida Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               IF a1.TAREADEF=660 THEN
                  if l_solucion = 0 then--Valida si es Xplora control
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if a1.TAREADEF=661 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=662 then
                   if l_count = 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;

               if a1.TAREADEF=667 then
                   --if ((l_tiptra in(441,443,444))and (l_countCableAnalog = 0))  or l_countrx >0 then --Valida si el paquete es sólo digital <11.0>
                   -- if ((l_tiptra in(441,443,444))and (f_producto_sot(l_codsolot,768) = 0))  or l_countrx >0 then --Valida si el paquete es sólo digital <23.0> comentado
                   if ((l_tiptra in(441,443,444,442))and (f_producto_sot(l_codsolot,768) = 0))  or l_countrx >0 then -- Se agrega lógica para corte <23.0>
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
                   if ln_countagendacabletripleplay > 0 then--Valida si el paquete es slo digital
                          if l_numslc is not null then
                             PQ_AGENDA.P_AGENDA_TAREAS(l_numslc,TO_CHAR(sysdate,'dd/mm/yyyy'),TO_CHAR(sysdate,'hh24:mi'),l_codsolot,'Servicio Puerta - Puerta', null);
                          end if;
                   end if;
                end if;
               if a1.TAREADEF=668 then
                   if ln_countagendacabletripleplay > 0 then--Valida si el paquete es sólo digital
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;

               if a1.TAREADEF=669 then
                   if ln_countagendacabletripleplay > 0  or l_countrx >0 then--Valida si el paquete es slo digital
                     BEGIN
                     select sp.punto
                     into ll_punto
                     from solotpto sp, insprd i
                     where sp.pid=i.pid
                     and i.flgprinc=1
                     AND sp.codsolot = l_codsolot
                     and rownum=1;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           ll_punto:=1;
                      END;
                      BEGIN
                        update solotpto set cintillo='0' where codsolot=l_codsolot and punto=ll_punto;
                        commit;
                      EXCEPTION
                        WHEN  OTHERS THEN
                          NULL;
                      END;
                      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,4,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=676   then
                  IF l_count > 0 then --Valida Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if  a1.TAREADEF=677  then
                    IF l_solucion = 0 THEN--Valida si es Xlora
                      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                     END IF;
               end if;
               if a1.TAREADEF=687   then
                  IF l_count > 0 then --Valida Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               --<11.0 --- Tarea de Liquidacion HFC No Interviene cuando la SOT solo tiene servicios Digitales
               if a1.TAREADEF=690  then
                  -- IF (f_producto_sot(l_codsolot,768) = 0 and l_tiptra in (441,443,444))  THEN
                  --IF (f_producto_sot(l_codsolot,768) = 0 and l_tiptra in (441,443,444))  THEN --<23.0> comentado
                    IF (f_producto_sot(l_codsolot,768) = 0 and l_tiptra in (441,442,443,444))  THEN --<23.0> se agrega tiptra 442 para corte
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --11.0>
               IF a1.TAREADEF=692 THEN
                  if l_count > 0 or (l_countsatelital1 > 0  or l_countsatelital2 > 0 )then --Valida si es provincia y el medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               IF a1.TAREADEF=693 THEN
                  if l_tipmotot=1 or l_tipmotot=3 then --Valida si es provincia y el medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
                  --<REQ ID = 102623>
                  if l_tipsrv = '0058' then
                     begin
                        select area into ln_area from reasigna_area_wf
                        where idsolucion = ln_solucion and
                              idcampanha = ln_idcampanha and
                              wfdef = ln_wfdef and
                              tareadef = a1.TAREADEF;


                        update tareawf
                        set area  = ln_area
                        where idtareawf = a1.idtareawf;

                        update tareawfcpy
                        set area  = ln_area
                        where idtareawf = a1.idtareawf;
                     exception
                      when others then
                        null;
                     end;
                  end if;
                  --</REQ>

               END IF;
               IF a1.TAREADEF=694 THEN
                  if l_tipmotot=1 or l_tipmotot=3 then --Valida si es provincia y el medio de acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
               if a1.TAREADEF=700 then
                  if l_bajasot = 0 then   --<21.0>
                   if l_countdigital = 0 then--Valida si el paquete es digital
                       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
                  end if;
                end if;
               if a1.TAREADEF=710 /*and((l_countfibra1>0 or l_countfibra2>0 ) or (l_countcobre1>0 or l_countcobre2>0))*/ then
                   if l_count > 0 or ((l_countfibra1=0 and l_countfibra2=0 ) and (l_countcobre1=0 and l_countcobre2=0)) then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=711 then
                   if l_count > 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=712 then
                   if l_count > 0 then -- Valida si es de Provincia
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=715 then
                   if (l_countwireless1 > 0 or l_countwireless2 > 0) then
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=717 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=721 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
              if a1.TAREADEF=722 then
                   if (l_countcobre1 > 0 or l_countcobre2 > 0) or (l_countfibra1 > 0 or l_countfibra2 > 0) then -- Valida el medio de Acceso
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                   end if;
               end if;
               if a1.TAREADEF=728  then
                  IF (l_tipmotot=2 or l_tipmotot=3) or (l_countcabinas>0)  THEN --valida motivo RETRASO DE PAGOS
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;

               --<REQ ID = 113879>
               if a1.TAREADEF=731  then
                  if  f_producto_sot(l_codsolot,858) = 0  then
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               end if;
              --</REQ>

               --<6.0
               if a1.TAREADEF=740  then
                  IF l_countredclaro=0  THEN
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --6.0>
              --<10.0
               if a1.TAREADEF=742  then
                  IF l_countsharedsever=0  THEN
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --10.0>
              --<14.0
               if a1.TAREADEF=753  then
                  IF  l_counttelefonia=0  THEN
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --14.0>
              --<16.0
               if a1.TAREADEF=746  then
                  select count(1)
                  into l_cont_etapa
                  from solotptoeta
                  where codsolot = l_codsolot and codeta in(713,718,639);
                  IF  l_cont_etapa=0  THEN
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --16.0>
              --<16.0
               if a1.TAREADEF=747  then
                  select count(1)
                  into l_cont_etapa
                  from solotptoeta
                  where codsolot = l_codsolot and codeta in(713,718,639);
                  IF  l_cont_etapa=0  THEN
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,8,0,SYSDATE,SYSDATE);
                  end if;
               END IF;
              --16.0>

          end if;
          --Ini 27.0
          if a1.TAREADEF in (454,340) then

                     begin
                       select distinct area
                         into ln_area
                         from reasigna_area_wf
                        where idsolucion = ln_solucion
                          and idcampanha = ln_idcampanha
                          and wfdef = ln_wfdef
                          and tareadef = a1.TAREADEF;

                       update tareawf
                          set area = ln_area
                        where idtareawf = a1.idtareawf;

                       update tareawfcpy
                          set area = ln_area
                        where idtareawf = a1.idtareawf;

                     exception
                       when others then
                         null;

                     end;
            end if;
             --Fin 27.0
        END LOOP;

END;

  PROCEDURE p_revision_sot_auto(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) IS


    l_tiptra    number;
    l_codsolot  solotpto.codsolot%type;
    l_valida    number;
    l_valida_flag number;
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/05/2008  Hector Huaman M.  Actualiza el campo FLG_PI en SOLOTPTO_ID
******************************************************************************/



    CURSOR c2 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv(+)
         and solotpto.pid = insprd.pid(+)
         and codsolot = l_codsolot;

  BEGIN
    l_valida    := 0;
    l_valida_flag:=0;
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select tiptra into l_tiptra from solot where codsolot = l_codsolot;

/*    if l_tiptra = 371 or l_tiptra = 370 or l_tiptra = 5 or l_tiptra = 374 or
       l_tiptra = 115  or l_tiptra = 389 or l_tiptra=390 then */ -- modificacion HHUAMAN 23/06/2008

      UPDATE SOLOT_ADI
         SET FLGEF = 1, FLGSOT = 1,FEC_FLGSOT=SYSDATE
       WHERE CODSOLOT = l_codsolot;

       select count(1)
      into l_valida_flag
      from solotpto_id s
     where s.codsolot = l_codsolot
       and s.flg_pi = 1;

    if l_valida_flag=0 then

      FOR ax IN c2 LOOP
        IF ax.flgprinc = 1 and l_valida = 0 THEN
          UPDATE SOLOTPTO_ID
             SET FLG_PI = 1
           WHERE CODSOLOT = ax.CODSOLOT
             AND PUNTO = ax.PUNTO;
          l_valida := 1;
        ELSE
          UPDATE SOLOTPTO_ID
             SET FLG_PI = 0
           WHERE CODSOLOT = ax.CODSOLOT
             AND PUNTO = ax.PUNTO;
        END IF;
      END LOOP;
      if l_valida = 0 then
        FOR az IN c2 LOOP
          if l_valida = 0 then
          UPDATE SOLOTPTO_ID
             SET FLG_PI = 1
           WHERE CODSOLOT = az.CODSOLOT
             AND PUNTO = az.PUNTO;
            l_valida := 1;
          end if;
        END LOOP;
      end if;

      end if;

--    end if; -- modificacion HHUAMAN 23/06/2008
  END;

  PROCEDURE P_ACTIVA_SID_CID(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) IS

    l_tipsrv   vtatabslcfac.tipsrv%type;
    l_codsolot solotpto.codsolot%type;
    l_numsid   number;
    l_sid      number;
    l_numcid   number;
    l_cid      number;
    l_tiptra   number;

    CURSOR c1 IS
      select idtareawf, tarea, idwf, tareadef, tipo
        from tareawfcpy
       where idwf = a_idwf;

  BEGIN
    begin
      SELECT distinct s.tipsrv, s.tiptra
        into l_tipsrv, l_tiptra
        from solot s, wf b
       where s.codsolot = b.codsolot
         and rownum = 1
         and b.idwf = a_idwf;

    exception
      when others then
        raise_application_error(-20411, 'no existe registro.' || a_idwf);
    end;

    select codsolot into l_codsolot from wf where idwf = a_idwf;

      BEGIN
          select s.cid
            into l_cid
            from solotpto s
           where s.codsolot = l_codsolot
             and s.cid is not null
             and rownum = 1;
     EXCEPTION                  --- Para CIDs nulos
     WHEN NO_DATA_FOUND THEN
         l_cid := null;
      END;


    select s.codinssrv
      into l_sid
      from solotpto s
     where s.codsolot = l_codsolot
       and s.codinssrv is not null
       and rownum = 1;

    select count(1)
      into l_numsid
      from solotpto s, inssrv i
     where s.codsolot = l_codsolot
       and s.codinssrv = i.codinssrv
       and i.estinssrv <> 1;

    select count(1)
      into l_numcid
      from solotpto s, acceso a
     where a.cid = s.cid
       and a.estado <> 1
       and s.cid = l_cid;

    if l_tipsrv = '0064' and l_tiptra in (1,457) and (l_cid is not null)  then
      if l_numcid > 0 then
        update acceso set estado = 1 where cid = l_cid;
      end if;
      if l_numsid > 0 then
        update inssrv i set i.estinssrv = 1 where i.codinssrv = l_sid;
      end if;
    end if;

  END;

  PROCEDURE P_CREA_OBS_TAREA_TLF(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date                        Author                            Description
       --------- ----------                   ---------------               ------------------------------------
       1.0    10/04/2008     Melvin Balcazar/ G. Ormeño     Procedimiento donde se agrega la observacion de forma automatica a la
                                                                                tarea de Asignacion de recursos - CX

    ******************************************************************************/

    l_codsolot    solotpto.codsolot%type;
    l_observacion varchar2(4000);
    l_usufin      varchar2(30);
    ln_maxchar    number; --<22.0> flag de aviso de capacidad maxima del varchar
    cursor c2 is
      select distinct solotpto.codsolot,
                      inssrv.codinssrv,
                      inssrv.cid,
                      inssrv.numero
        from solotpto, inssrv
       where solotpto.codinssrv = inssrv.codinssrv
         and codsolot = l_codsolot
         and inssrv.tipinssrv = 3
       order by inssrv.codinssrv desc;
     v_mensaje     opedd.descripcion%type;
     
  BEGIN 
    
    if f_verf_prixhunting(a_idwf) = 0 then 
         select o.descripcion into v_mensaje
           from tipopedd t, opedd o
          where t.abrev       = 'VALIDA_PRIXHUNTING'
            and t.tipopedd    =  o.tipopedd
            and o.abreviacion = 'VALIDA PRIXHUNTING';
            
          raise_application_error(-20001, v_mensaje);
    end if;
    
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    --  select usufin into l_usufin from tareawf where tareawf.idwf=a_idwf and tareawf.tareadef=a_tareadef and tareawf.tipesttar=4 and tareawf.esttarea=4 ;
    --Cambio Gustavo ormeño
    l_usufin      := USER;
    l_observacion := 'Numero(s): ';

    for an in c2 loop

      if an.numero is not null then
         if length(l_observacion) + length(an.numero || ', ') <=4000 then --<22.0>
            l_observacion := l_observacion || an.numero || ', ';
         --<22.0>
         else
            ln_maxchar:=1;
            goto salto;
         end if;
         --</22.0>
      end if;

    end loop;

    if l_observacion = 'Numero(s): ' then
      l_observacion := 'Se cerró tarea sin haberse asignado ningún número.';
    end if;

    --<22.0> caso la observacion pase los 4000 de varchar
    <<salto>>
    if ln_maxchar=1 then
       l_observacion:= trim(substr(l_observacion,0,3997))||'...';
    end if;
    --</22.0>
   insert into tareawfseg
      (idtareawf, observacion, fecusu, codusu, flag, idobserv)
    values
      (a_idtareawf, l_observacion, sysdate, l_usufin, 0, null);
      
  END;

  PROCEDURE P_REGISTRO_FECINSRV(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) IS
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/03/2008  Hector Huaman M.  Activa/Desactiva el servicio y cierra la tarea de Activacion /Desactivacion del servicio
******************************************************************************/




    ln_contador           number;
    l_codsolot            solotpto.codsolot%type;
    l_tiptra              number;
    l_valida              number;
    l_cont                number;
    l_num_reg             number;
    l_feccom              date;
    l_numslc              number;
    l_fecins_plan_externa date;
    l_codtrs              number;
    l_validaprof          number;--<9.0>
    l_tipsrv              varchar2(4); --59.0
    l_tipsrv_conf         varchar2(4); --59.0

    CURSOR c1 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid
         and codsolot = l_codsolot;

    CURSOR c3 IS
      select idtareawf, tarea, idwf, tareadef, tipo
        from tareawfcpy
       where idwf = a_idwf;

    cursor c_trssolot is
      select codtrs, fectrs, esttrs
        from trssolot
       where codsolot = l_codsolot;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    BEGIN
      select tiptra, feccom, numslc, tipsrv --59.0
        into l_tiptra, l_feccom, l_numslc, l_tipsrv --59.0
        from solot
       where codsolot = l_codsolot
         and rownum = 1;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_tiptra := NULL;
        l_feccom := NULL;
        l_numslc := NULL;
    END;

    BEGIN
      select (sp2.fecinisrv - 1)
        into l_fecins_plan_externa
        from solot s1, solot s2, solotpto sp2
       where s2.numslc = s1.numslc
         and s2.tiptra in( 80,390,412,170)  --<18.0>
         and sp2.fecinisrv is not null      --<18.0>
         and sp2.codsolot = s2.codsolot
         and rownum = 1
         and s1.codsolot = l_codsolot;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_fecins_plan_externa := NULL;
    END;
    --Ini 59.0
        IF l_fecins_plan_externa is null THEN
          select codigoc 
          into l_tipsrv_conf
      	  from operacion.opedd o
      	  inner join operacion.tipopedd t on o.tipopedd = t.tipopedd
      	  and t.abrev = 'PQ_PYMES_HFC_CE';

      	  if l_tiptra = 7 and l_tipsrv = l_tipsrv_conf then
        	l_fecins_plan_externa := l_feccom - 1;
      	  end if;
        END IF;
    --Fin 59.0
    --<9.0
        --Profesor 24 horas
    select count(1)
      into l_validaprof
      from reginsprof24h
     where codsolot = l_codsolot;--9.0>

    ---DESACTIVACIÓN DE FACTURACIÓN /DESACTIVACIÓN DE FACTURACIÓN
    if l_tiptra = 364 OR l_tiptra = 363 OR l_tiptra = 403 then
      FOR a1 IN c3 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 686 THEN
            if l_feccom is not null then
              UPDATE SOLOTPTO
                 SET FECINISRV = l_feccom
               WHERE CODSOLOT = l_codsolot;
              --<13.0
              operacion.p_ejecuta_activ_desactiv(l_codsolot,686,l_feccom);
              /*OPERACION.pq_solot.p_crear_trssolot(4,
                                                  l_codsolot,
                                                  null,
                                                  null,
                                                  null,
                                                  null);
              for lc_trssolot in c_trssolot loop
                operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs,
                                                  2,
                                                  l_feccom);
              end loop;
              opewf.pq_wf.P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               4,
                                               0,
                                               sysdate,
                                               sysdate); 13.0> */
            end if;
          END IF;
        end if;

      END LOOP;

    end if;
    ---DESACTIVACIÓN POR SUSTITUCIÓN
    if l_tiptra = 7 then
      FOR a1 IN c3 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 686 THEN
            if l_fecins_plan_externa is not null then
              UPDATE SOLOTPTO
                 SET FECINISRV = l_fecins_plan_externa
               WHERE CODSOLOT = l_codsolot;
              --<13.0
              operacion.p_ejecuta_activ_desactiv(l_codsolot,686,l_fecins_plan_externa) ;
              /*OPERACION.pq_solot.p_crear_trssolot(4,
                                                  l_codsolot,
                                                  null,
                                                  null,
                                                  null,
                                                  null);
              for lc_trssolot in c_trssolot loop
                operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs,
                                                  2,
                                                  l_fecins_plan_externa);
              end loop;
              opewf.pq_wf .P_CHG_STATUS_TAREAWF(a1.idtareawf,
                                               4,
                                               4,
                                               0,
                                               sysdate,
                                               sysdate); 13.0>*/
               UPDATE SOLOT SET  ESTSOL=29 WHERE CODSOLOT= l_codsolot;
            end if;
          END IF;
        end if;

      END LOOP;

    end if;
  --<9.0
     if l_validaprof > 0 then
      FOR a1 IN c3 LOOP
        if a1.tipo = 0 then
          IF a1.TAREADEF = 686 THEN
              operacion.p_ejecuta_activ_desactiv(l_codsolot,686,sysdate) ;
          END IF;
        end if;
      END LOOP;
    end if;  --9.0>

  END;

  PROCEDURE P_BAJA_ANULACION(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) IS
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        19/06/2008  Hector Huaman M.  Rechaz la SOT de Instalacion del servicio
   1.1        15/12/2008  Franklin Barrios  Rechaz la SOT de Instalacion del servicio excepto de los estados 12 y 29
******************************************************************************/



    l_codsolot         solotpto.codsolot%type;
    l_codsolot_rechazo solotpto.codsolot%type;
    l_tiptra           number;
    l_cid              number;
    l_estasol_rechazo  number;

    --Ini 30.0
    cursor c_sots is
    select s.codsolot, estsol, 1 idwf
      from solotpto p, solot s
     where p.codsolot = s.codsolot
       and s.tiptra in (select codigon
                          from opedd o, tipopedd t
                         where o.tipopedd = t.tipopedd
                           and t.abrev = 'RECHAZO_ANULA'
                           and t.descripcion = 'OP-Rechazo bajas por anulación')
       and p.cid = l_cid
       and estsol not in (12,29);
    -- Fin 30.0
  BEGIN


    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select cid
      into l_cid
      from solotpto
     where codsolot = l_codsolot
     and cid is not null
       and rownum = 1;

    -- Ini 30.0
    /*select s.codsolot, estsol
       into l_codsolot_rechazo, l_estasol_rechazo
       from solotpto p, solot s
      where p.codsolot = s.codsolot
        and s.tiptra in (1, 368, 369, 390, 391, 393, 394, 402)
        and p.cid = l_cid
        and rownum = 1;

    if (l_codsolot_rechazo is not null) and (l_estasol_rechazo not in (12,29))  then
      PQ_SOLOT.P_CHG_ESTADO_SOLOT(l_codsolot_rechazo,
                                  15,
                                  l_estasol_rechazo);
      update solot
         set observacion = observacion || ' Se rechazo la SOT :' ||
                           l_codsolot_rechazo
       where codsolot = l_codsolot;
    end if;*/

    for r_sot in c_sots loop

      if (r_sot.codsolot is not null) and (r_sot.estsol not in (12,29))  then
        pq_solot.p_chg_estado_solot(r_sot.codsolot,
                                    15,
                                    r_sot.estsol);
        begin
          select idwf
            into r_sot.idwf
            from wf
           where codsolot = r_sot.codsolot
             and valido = 1;
          pq_wf.p_cancelar_wf(r_sot.idwf);
        exception
          when others then
            null;
        end;
        update solot
           set observacion = observacion || ' Se rechazo la SOT :' || r_sot.codsolot
         where codsolot = l_codsolot;
      end if;
    end loop;
    -- Fin 30.0

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      l_cid := NULL;

  END;

  procedure P_INTRAWAYEXE(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number) is

    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  begin
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 3; -- Alta de Servicios
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               --ini 31.0
                                               --p_error);
                                               p_error,
                                               0); --58.0
    --fin 31.0
    --ini 58.0
    update intraway.agendamiento_int
       set est_envio = 6, mensaje = 'PENDIENTE RESERVA'
     where codsolot = v_codsolot;
    commit;
    --fin 58.0

  exception
    when others then
      rollback;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := sqlerrm;
  end;

  procedure P_INTRAWAY_BAJA(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) is
    /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       03/12/2007  Zulma Quispe      Baja de Servicios
    ******************************************************************************/
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  begin
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 4; -- Baja de Servicios
    --ini 58.0

    INTRAWAY.PQ_PROVISION_ITW.P_INT_EJECBAJA(v_codsolot, p_error, p_mensaje, 0);
    --fin 58.0

  exception
    when others then
      rollback;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := sqlerrm;
  end;

  PROCEDURE P_INTRAWAY_SUSPENSION(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Corte de los servicios de Paquetes Multiplay
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 5; -- Corte Total
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  PROCEDURE P_INTRAWAY_CORTE_TELEFONIA(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Corte de los servicios de Paquetes Multiplay
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 7; -- Corte Telefonia
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  PROCEDURE P_INTRAWAY_CORTE_LC(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Corte de los servicios de Paquetes Multiplay
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 8; -- Corte Límite de Crédito
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  PROCEDURE P_INTRAWAY_CORTE_FRAUDE(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Corte de los servicios de Paquetes Multiplay
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 9; -- Corte por Fraude
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  PROCEDURE P_INTRAWAY_RECONEXION(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Reactivacion de los servicios de Paquetes Multiplay
     2.0       26/06/2017  Servicio Fallas-HITSS INC000000837877 Las reconexiones SGA para servicios HFC no se visualizan en Intraway/Incognito
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
  -- inicio 2.0
   select s.codsolot, to_number(o.proc)
    into v_codsolot, v_opcion
    from solot s
    left join (select distinct o.codigon tiptra, o.codigoc proc
                 from opedd o, tipopedd t
                where o.tipopedd = t.tipopedd
                  and t.tipopedd in (1418, 1050)
          and o.codigoc is not null ) o
      on (s.tiptra = o.tiptra)
   where s.codsolot = (select distinct w.codsolot
                         from wf w
                        where w.idwf = a_idwf
                          and w.valido = 1);
  intraway.pq_provision_itw.p_int_ejecscr(v_codsolot,
                                          v_opcion,
                                          p_resultado,
                                          p_mensaje,
                                          p_error);
   -- fin 2.0

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  PROCEDURE P_INTRAWAY_UP_DOWN(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number)
  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       12/03/2007  Zulma Quispe     Corte de los servicios de Paquetes Multiplay
    ******************************************************************************/
   IS
    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 14; -- Suspension
    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  procedure p_asig_numtelef_wf(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number)
  is
  /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        03/06/2008  Roy Concepcion   Asigna automaticamente números,
                                               usado en la tarea 689 para Intraway
       2.0        05/06/2008  Romer Babilonia  Se modifica el sistema para tomar la Zona Telefonica
                                               3 Play Automatico
    ******************************************************************************/

    l_countcola         number;
    vn_cantvtadetptoenl number;
    vn_cantreserva      number;
    vv_numslc           solot.numslc%type;
    vv_numeroini        numtel.numero%type;
    -- Ini 52.0
    l_flg_port_masivo   number;
    l_rsvtel            number;
    lv_msj_rst          varchar2(200);
    ln_rst_ss           number;
    -- Fin 52.0
--    vn_codsolot         solot.codsolot%type;
    vn_codnumtel numtel.codnumtel%type;
    exceptioncodsuc exception;
    exceptioninventario exception;
    exceptionnumtel exception; --47.0
    v_mensaje   varchar2(3000);
    v_error     number;
    l_idseq     number;
    l_zona      number;
    --<34.0 Inicio
    ln_producto number;
    ln_central  number;
    --34.0 Fin>
    --<35.0 Inicio
    l_zona3Play_aut  number;
    l_zona_TPILim_aut number;
    --35.0 Fin>
    --ini 37.0
    ln_prodfax      number;
    ln_faxserver    number;
    l_zonafaxserver number;
    --fin 37.0
    --ini 47.0
    ln_cod_error    number;
    ls_des_error    varchar2(1000);
    ls_email        varchar2(100);
    --fin 47.0
    --ini 50.0
    ln_codinssrv    numtel.codinssrv%type;
    lc_imei         numtel.imei%type;
    lc_simcard      numtel.simcard%type;
    l_subject       VARCHAR2(200);
    l_cuerpo        VARCHAR2(4000);
    l_pre_mail      tareawfcpy.pre_mail%TYPE;
    --fin 50.0
    --ini 51.0
    cnt_res_num     number;
    ls_codsolot     solot.codsolot%type;
    ls_codnumtel    numtel.codnumtel%type;
    ls_punto_port   reservatel.numpto%type;
    --fin 51.0

    -- ini 53.0
    ln_port_corp    number;
    -- fin 53.0
    cursor c1 is
      select a.numslc,
             a.numpto,
             a.ubipto,
             a.codsuc,
             e.codcli,
             e.idsolucion --<34.0>
        from vtadetptoenl a,
             tystabsrv    b,
             producto     c,
             vtatabslcfac e
       where a.codsrv = b.codsrv
         and b.idproducto = c.idproducto
         and a.numslc = e.numslc
         and a.numslc = vv_numslc
         and c.idtipinstserv = 3
         and a.flgsrv_pri = 1 --09/10/2008
         --ini 31.0
         order by a.numpto;
         --fin 31.0

  begin
    vv_numeroini := null;

    --<35.0 Inicio
    select to_number(valor) into l_zona3Play_aut from constante where trim(constante) = 'ZONA3PLAY_AUT';
    select to_number(valor) into l_zona_TPILim_aut from constante where trim(constante) = 'ZONA_TPILIM_AUT';
    --35.0 Fin>

    select b.numslc--, b.codsolot
    into vv_numslc--, vn_codsolot
    from wf a,solot b
    where a.codsolot=b.codsolot and
          a.idwf = a_idwf;
    select count(1)
      into vn_cantreserva
      from reservatel
     where numslc = vv_numslc;
    select count(1)
      into vn_cantvtadetptoenl
      from vtadetptoenl a, tystabsrv b, producto c
     where a.codsrv = b.codsrv
       and b.idproducto = c.idproducto
       and a.numslc = vv_numslc
       and c.idtipinstserv = 3;

    -- Ini 53.0 Flujo corporativo Portable
    select count(*)
      into ln_port_corp
      from vtatabslcfac
     where numslc = vv_numslc
       and flg_portable = 1
       and tipsrv in ( select codigoc
                         from opedd
                        where tipopedd in ( select tipopedd
                                             from tipopedd
                                            where abrev in( 'PR_CORP_CONF','PARAM_PORTA')) -- 54.0
                          and abreviacion in( 'TIPSRV','MASIVO-TIPSRV')); -- 54.0
    -- Fin 53.0 Flujo corporativo Portable
    -- Ini 54.0
    /*
    -- Ini 52.0  Portacioin fija HFC masivo
    select telefonia.pq_portabilidad.f_verif_portable(1,vv_numslc)
    into l_flg_port_masivo
    from dummy_ope;
    --Fin 52.0
    */
    -- Fin 54.0

    if ln_port_corp = 0 then       -- < 53.0 >
      if vn_cantreserva <> vn_cantvtadetptoenl /* Ini 54.0 or
          (vn_cantreserva = vn_cantvtadetptoenl and l_flg_port_masivo = 1) Fin 54.0*/  then
        for cn1 in c1 loop
          If cn1.codsuc = null then
            raise exceptioncodsuc;
          End if;
          --<15.0 select F_GET_NUMERO_TEL_ITW(98,cn1.ubipto) into vv_numeroini from dual;

          --<34.0 Inicio
          select valor into ln_producto from constante where constante = 'CVIRTUAL_PRD';
          /*
          select count(1)
            into ln_central
            from paquete_venta paq, detalle_paquete det
           where det.idpaq = paq.idpaq
             and paq.idsolucion = cn1.idsolucion
             and det.idproducto = ln_producto
             and det.flgestado = 1;*/
          --<35.0 Inicio
          select count(1)
            into ln_central
           from vtadetptoenl a,
               tystabsrv    b,
               producto     c,
               vtatabslcfac e
         where a.codsrv = b.codsrv
           and b.idproducto = c.idproducto
           and a.numslc = e.numslc
           and a.numslc = vv_numslc
           and ( b.codsrv in (select valor from constante where constante = 'CVIRTUAL_SRV')
           or  c.idproducto in (select valor from constante where constante = 'CVIRTUAL_PRD'));
          --35.0 Fin>

          if ln_central > 0 then

             select distinct codzona
               into l_zona
               from serietel
              where codzona in
                    (select codzona
                       from zonatel
                      where codplan in
                            (select codplan from planproducto where idproducto = ln_producto))
                and codubi = cn1.ubipto
                and rownum = 1;
          --Ini 50.0
          elsif exist_paquete_tpi_gsm(vv_numslc) then
                 select distinct codzona
                   into l_zona
                   from serietel
                  where codzona in
                        (select codzona
                           from zonatel
                          where codplan in
                                (SELECT o.codigon
                                   FROM operacion.tipopedd t
                                  INNER JOIN operacion.opedd o
                                     ON (t.tipopedd = o.tipopedd)
                                  WHERE o.abreviacion = 'TPIGSM/codplan'
                                    AND t.descripcion = 'OPE-Config TPI - GSM'));

           ---Fin 50.0
          else
            --Inicio 37.0
            select to_number(codigoc)  into ln_prodfax
            from opedd where tipopedd= 1085 and abreviacion='CFAXSERVER_PRD';
            select count(1) into ln_faxserver
            from vtadetptoenl a
            where a.codsrv in  (select codigoc
                          from opedd where tipopedd= 1085 and abreviacion='CFAXSERVER_SRV')
               and a.idproducto = ln_prodfax
               and a.numslc = cn1.numslc
               and a.numpto = cn1.numpto;
            if ln_faxserver > 0 then
              select distinct codzona into l_zona
              from serietel
              where codzona in (select codzona from zonatel
                            where codplan in (select codplan
                            from planproducto where idproducto = ln_prodfax))
              and codzona in (select to_number(codigoc)
                           from opedd where tipopedd= 1085 and abreviacion='CFAXSERVER_ZONA')
              and codubi = cn1.ubipto and rownum = 1;
            else --37.0 Fin
              --34.0 Fin>
              l_zona :=l_zona3Play_aut; --3play --35.0
              if intraway.PQ_sots_agendadas.f_verif_tp_tpi_coaxial(a_idtareawf,a_idwf, a_tarea, a_tareadef )> 0 then--TPI TP Coaxial
                 l_zona:=l_zona_TPILim_aut; --35.0
              end if;
            end if; --37.0

          end if;

          --ini 47.0
          loop
            -- ini 51.0
            begin
              select codsolot
                into ls_codsolot
                from wf
               where idwf = a_idwf;

              select count(*)
                into cnt_res_num
                from solot
               where codsolot = ls_codsolot
                 and tiptra in ( select codigon
                                   from crmdd
                                  where abreviacion = trim('TIPTRA_ALT_NUM')) ;

              if cnt_res_num  = 1 then
                select codnumtel
                  into ls_codnumtel
                  from reservatel
                 where numslc = vv_numslc;

                select numero
                  into vv_numeroini
                  from numtel
                 where codnumtel = ls_codnumtel;

                 update inssrv
                    set estinssrv = 4
                  where numslc    = cn1.numslc
                    and tipinssrv = 3;
              else
                vv_numeroini := '';
              end if;

            exception
              when others then
                vv_numeroini := '';
                cnt_res_num  := 0;
            end;
            -- fin 51.0

            if vv_numeroini is null or vv_numeroini = '' then  --- 51.0
              --Comentado para pruebas:
              -- Ini 54.0
              /*
              -- Ini 52.0

              if l_flg_port_masivo = 1 then

                select count(*) into l_rsvtel from telefonia.reservatel rt
                 where rt.numslc=vv_numslc;
                if l_rsvtel=1 then  -- debe ser unico
                  -- Tomando el Número Portado de Numtel
                  begin
                    select nt.numero into vv_numeroini
                      from telefonia.numtel nt, telefonia.reservatel rt
                     where nt.codnumtel = rt.codnumtel
                       and rt.numslc=vv_numslc
                       and flg_portable = 1;
                  exception
                    when others then
                      vv_numeroini := '';
                  end;
                  -- Actualizando en SISACT
                  ln_rst_ss := telefonia.pq_portabilidad.f_sisact_actualiza(ls_codsolot,'ALTA',lv_msj_rst);
                  if ln_rst_ss <> 1 then  --graba log
                    telefonia.pq_portabilidad.p_ing_portabilidad_fija_log(to_char(a_idtareawf),'Asignacion deNumero',ls_codsolot, 'Proyecto no envio correctamente fecha estimada al SISACT,'||lv_msj_rst);
                  end if;

                else
                  telefonia.pq_portabilidad.p_ing_portabilidad_fija_log(to_char(a_idtareawf),'Asignacion deNumero',ls_codsolot, 'Proyecto portable tiene mas de un registro en reservatel');
                  exit;
                end if;
              else
              -- Fin 52.0
                */
                -- Fin 54.0
                select F_GET_NUMERO_TEL_ITW(l_zona,cn1.ubipto) into vv_numeroini from dummy_ope;
              -- Ini 52.0
              -- end if; -- 54.0
            -- Fin 52.0
            end if; -- 51.0
            --ini 33.0
            if vv_numeroini is null or vv_numeroini = '0' then
            --fin 33.0
               raise exceptioninventario;
            end if;

      --ini 56.0
      select codnumtel
              into vn_codnumtel
              from numtel
             where numero = vv_numeroini;
            update numtel set estnumtel = 5 where codnumtel = vn_codnumtel;
      --fin 65.0

            --Valida que el numero no este activo para otro cliente
            OPERACION.pq_cuspe_ope2.p_valida_numtel(vv_numeroini,cn1.codcli,ln_cod_error,ls_des_error);
            if ln_cod_error < 0 then
              update numtel set estnumtel = 2 where numero = vv_numeroini;
              ls_des_error:='Se cambio a estado Asignado al numero telefonico ' || vv_numeroini || ' ya que servicio se encuentra activo, hacer seguimiento. ' || ls_des_error;
              select d.descripcion into ls_email from tipopedd m, opedd d where m.tipopedd = d.tipopedd and m.abrev = 'EMAIL_PLAT_FIJA';
              insert into opewf.cola_send_mail_job (nombre,subject,destino,cuerpo,flg_env)
              values ('SGA-SoportealNegocio','Asignacion de Numero Telefonico para Paquetes Intraway',ls_email,ls_des_error,'0');
              commit;
            else
        --ini 56.0
              if cnt_res_num = 0 then-- 51.0
                  insert into reservatel
                    (codnumtel, numslc, numpto, valido, codcli, estnumtel, publicar)
                  values
                    (vn_codnumtel, vv_numslc, cn1.numpto, 1, cn1.codcli,2, 0);
                  commit;
              end if;            -- 51.0
        --fin 56.0
              exit;
            end if;
          end loop;
          --fin 47.0
  /*
          select F_GET_NUMERO_TEL_ITW(l_zona,cn1.ubipto) into vv_numeroini from dummy_ope;
          --15.0>
          --ini 33.0
          --if vv_numeroini = '0' then
          if vv_numeroini is null or vv_numeroini = '0' then
          --fin 33.0
            raise exceptioninventario;
          end if;
          --ini 47.0
          OPERACION.pq_cuspe_ope2.p_valida_numtel(vv_numeroini,cn1.codcli,ln_cod_error,ls_des_error);
          if ln_cod_error < 0 then
            raise_application_error(-20000, ls_des_error);
          end if;
          --fin 47.0
  */
          -- if l_flg_port_masivo<>1 then --52.0 -- 54.0

--ini 56.0
/*
            select codnumtel
              into vn_codnumtel
              from numtel
             where numero = vv_numeroini;
            update numtel set estnumtel = 5 where codnumtel = vn_codnumtel;

              if cnt_res_num = 0 then-- 51.0
                  insert into reservatel
                    (codnumtel, numslc, numpto, valido, codcli, estnumtel, publicar)
                  values
                    (vn_codnumtel, vv_numslc, cn1.numpto, 1, cn1.codcli,2, 0);
                  commit;
              end if;            -- 51.0
          -- end if;--52.0 -- 54.0
*/
--fin 56.0
        end loop;

        intraway.pq_intraway_proceso.p_asignar_numeros(vv_numslc, v_mensaje, v_error);

        /* RCS rEQ. 63131*/
        IF v_error = 0 THEN
          --Ini 50.0
         if exist_paquete_tpi_gsm(vv_numslc) then

            SELECT n.imei, n.simcard, n.codinssrv
              INTO lc_imei, lc_simcard, ln_codinssrv
              FROM telefonia.reservatel r
             INNER JOIN numtel n
                ON (r.codnumtel = n.codnumtel)
             WHERE r.numslc = vv_numslc
               AND r.valido = 1;

            UPDATE operacion.inssrv
               SET imei = lc_imei, simcard = lc_simcard
             WHERE codinssrv = ln_codinssrv;

          --Envio de Informacion por mail
          p_mail_wf_solot_tpigsm(a_idtareawf, 1, l_subject, l_cuerpo);

            SELECT tc.pre_mail
              INTO l_pre_mail
              FROM tareawfcpy tc
             WHERE tc.idtareawf = a_idtareawf;
            IF l_pre_mail IS NOT NULL THEN
              p_envia_correo_de_texto_att(l_subject, l_pre_mail, l_cuerpo);
            END IF;
         end if;
        --Fin 50.0
           --Ini 26.0
           --select max(idseq) + 1 into l_idseq from TAREAWFSEG;
           INSERT INTO TAREAWFSEG(IDTAREAWF,OBSERVACION,FLAG)
           VALUES (a_idtareawf,v_mensaje || vv_numeroini, 1);
           --Fin 26.0
        ELSE
           RAISE exceptioninventario;
        END IF;
      end if;
    else
      -- Ini 53.0 Flujo corporativo Portable
      telefonia.pq_portabilidad.p_asignacion_port_corp( a_idtareawf,
                                                        a_idwf,
                                                        a_tarea,
                                                        a_tareadef);
      -- Ini 53.0 Flujo corporativo Portable
    end if;
  EXCEPTION
    --Inicio 46.0
    WHEN exceptioncodsuc THEN
      select SQ_COLA_SEND_MAIL_JOB.nextval into l_countcola from DUMMY_OPWF;
      insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env)
      values (l_countcola,'SGA-SoportealNegocio','Asignacion de Numero Telefonico para Paquetes Intraway',
      'SoporteTelefoniaFijayPortales@claro.com.pe','No se realizo correctamente la asignacion de Numero Telefonico para el paquete de Intraway en el Proyecto ' || vv_numslc,'0');
    WHEN exceptioninventario THEN
      select SQ_COLA_SEND_MAIL_JOB.nextval into l_countcola from DUMMY_OPWF;
      insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env)
      values (l_countcola,'SGA-SoportealNegocio','Asignacion de Numero Telefonico para Paquetes Intraway',
      'DL-PE-Conmutacion@claro.com.pe','No se asignó Numero telefonico por falta de disponibilidad para el proyecto:' || vv_numslc,'0');
      INSERT INTO TAREAWFSEG(IDTAREAWF,OBSERVACION,FLAG)
      VALUES (a_idtareawf,'No se asignó Numero telefonico a la SOT por falta de disponibilidad.', 1);
      commit;
    --Fin 46.0
  end;


PROCEDURE p_Asigna_Resp_Contrata (a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        02/06/2008  Mbalcazar/Gormeño
    ******************************************************************************/
    l_tipsrv     vtatabslcfac.tipsrv%type;
    l_codsolot   solotpto.codsolot%type;
    l_tiptra     number;
    l_responsable varchar2(30);
    l_codcon number;
    sqlerrm varchar2(200);
    l_var varchar2(200);
    l_fecusu solot.fecusu%type;
    ln_countagendacabletripleplay number;
  BEGIN

      select s.codsolot, s.tipsrv, s.tiptra
        into l_codsolot, l_tipsrv, l_tiptra
        from solot s, wf b
       where s.codsolot = b.codsolot and b.valido = 1 and b.idwf = a_idwf;

    --Servicio Digital Triple Play (Puerta - Puerta)
    ln_countagendacabletripleplay := 0;

    BEGIN
      select count(1)
      into ln_countagendacabletripleplay
      from vtatabprecon v,solot s
      where v.numslc=s.numslc
      and s.codsolot=l_codsolot
     and (v.codmotivo_tf in (select codmotivo
                                from vtatabmotivo_venta
                               where codtipomotivo = '023'                --REQ modifico query, validar puerta - puerta por el flg_puerta
                                 and flg_puerta = 1) or v.codmotivo = 22); -- se cambio el motivo


    EXCEPTION
       WHEN OTHERS THEN
         ln_countagendacabletripleplay := 0;
    END;

    if l_tiptra = 419 then

          if a_tareadef = 668 then  -- Asignar Responsable Cable
                        l_responsable := 'KSONCO';
                        l_codcon := 43;  -- Contratista BMP
                          update SOLOTPTO_ID
                          set
                                 RESPONSABLE_PI = l_responsable,
                                 CODCON = l_codcon,
                                 ESTADO = 'Generado',
                                 FECESTPROG = sysdate,
                                 CODUSUESTPROG = user
                          where codsolot = l_codsolot
                          and codcon is null
                          and responsable_pi is null and flg_pi=1;
                          commit;

                         OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf, 4, 4, null, sysdate, sysdate);
              end if;
     end if;

         if l_tiptra = 438 then

          if a_tareadef = 668 then  -- Asignar Responsable Cable
             l_responsable := 'LSENCIO';

             select distinct codcon into l_codcon from reginsdth where estado in ('02', '07') and flg_facturable = 1
             and flg_validado=1 and codsolot =  l_codsolot ;

             select distinct fecusu into l_fecusu from solot where codsolot =  l_codsolot ;

             update solotpto_id set responsable_pi = l_responsable, codcon = l_codcon, estado = 'Generado', fecprog=l_fecusu,
             fecestprog=sysdate, codusuestprog=user
             where codsolot = l_codsolot and codcon is null and responsable_pi is null and flg_pi=1;
             commit;

             OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf, 4, 4, null, sysdate, sysdate);
          end if;
     end if;

   if ln_countagendacabletripleplay > 0 then

          if a_tareadef = 668 then  -- Asignar Responsable Cable
                       --l_responsable := 'JFORONDA';
                       SELECT valor
                       INTO l_responsable
                       FROM constante
                       WHERE trim(constante) = 'RESP_AGPUERTAP';

                       l_codcon := 123;  -- Contratista TECNICOS BOGA

                       update SOLOTPTO_ID
                       set
                                 RESPONSABLE_PI = l_responsable,
                                 CODCON = l_codcon,
                                 ESTADO = 'Generado',
                                 FECESTPROG = sysdate,
                                 CODUSUESTPROG = user
                          where codsolot = l_codsolot;

                          commit;

                         OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf, 4, 4, null, sysdate, sysdate);
              end if;
     end if;
 exception

              WHEN OTHERS THEN
                   l_var := 'OPERACION.PQ_CUSPE_OPE.p_Asigna_Resp_Contrata' || l_codsolot ||
                 ' Error en asignacion de responsable y contrata (Tarea Automatica - Asignar Responsable Cable - Problema presentado: ' || sqlerrm;

                  if trim(l_var) <> '' then
                       opewf.pq_send_mail_job.p_send_mail('OPERACION.PQ_CUSPE_OPE.p_Asigna_Resp_Contrata',
                                                       'DL-PE-ITSoportealNegocio@claro.com.pe',--29.0
                                                       l_var);
                  end if;

END;

PROCEDURE P_LIQUIDACION_AUTO_DTH(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        28/08/2008  MBalcazar/CNajarro
    ******************************************************************************/
    l_codsolot   solotpto.codsolot%type;
    l_numslc     vtatabslcfac.numslc%type;
    l_tipsrv     vtatabslcfac.tipsrv%type;
    l_tiptra     number;
    l_fecusu solot.fecusu%type;
    l_estado varchar2(30);
    l_codact actividad.codact%type;
    l_codcon number;
    l_punto   solotpto.punto%type;
    l_observacion varchar2(100);
    sqlerrm varchar2(200);
    l_var varchar2(200);
    l_codprecdis solotptoetaact.codprecdis%type;
    l_cosdis solotptoetaact.cosdis%type;
    l_monedaid solotptoetaact.moneda_id%type;
    l_contequdth number;
    l_contfecinisrv number;
    l_solotptoeta number;
    l_solotptoetaact number;


    cursor cur is
          select r.codsolot, op.tipequope, op.serie, op.unitaddress from reginsdth r, operacion.equiposdth op
          where r.numregistro=op.numregistro
          and r.estado in ('02','07')
          and op.grupoequ in (1,2,3)
          and r.codsolot =l_codsolot;

  BEGIN

 select distinct s.codsolot, s.numslc, s.tiptra, s.fecusu into l_codsolot, l_numslc, l_tiptra, l_fecusu from solot s, wf b where s.codsolot = b.codsolot and b.valido = 1 and b.idwf = a_idwf;

 if l_tiptra = 438 then

     if a_tareadef = 548 then  -- Atendido - PINT

             select count (fecinisrv) into l_contfecinisrv from solotpto where codsolot=l_codsolot;

             if l_contfecinisrv > 0 then

                l_estado := 'Concluido Contratista';
                l_codact :=11791;

                select count (codsolot) into l_solotptoeta from solotptoeta where codsolot=l_codsolot;
                select count (codsolot) into l_solotptoetaact from solotptoetaact where codsolot=l_codsolot;

                if l_solotptoeta =0 then

                    -- Inserta el punto principal en la etapa
                    select solotpto.codsolot, solotpto.punto, reginsdth.codcon, contrata.nombre into l_codsolot, l_punto, l_codcon,  l_observacion
                    from solotpto, insprd, reginsdth, contrata where solotpto.pid = insprd.pid(+) and reginsdth.codsolot=solotpto.codsolot and reginsdth.codcon=contrata.codcon
                    and reginsdth.estado in ('02','07') and insprd.flgprinc=1 and rownum=1 and solotpto.codsolot =l_codsolot;

                    insert into solotptoeta (codsolot, punto, orden, codeta, codcon, esteta,fecdis,porcontrata,fecliq )
                    values ( l_codsolot, l_punto, 1, 645, l_codcon, 3, sysdate, 0, sysdate);

                end if;

                 if l_solotptoetaact =0 then

                      -- Asignamos el costo a la actividad segun el preciario activo
                      select actxpreciario.codprec, actxpreciario.costo, actxpreciario.moneda_id into l_codprecdis, l_cosdis, l_monedaid from actividad, actxpreciario
                      where actividad.codact=actxpreciario.codact and actxpreciario.activo=1 and actividad.estado=1 and rownum=1 and actividad.codact=l_codact;

                      insert into solotptoetaact (codsolot, punto, orden, moneda_id, codact, candis,cosdis, canliq, cosliq, contrata,observacion, codprecdis, codprecliq,canins)
                      values ( l_codsolot, l_punto, 1, l_monedaid, l_codact, 1, l_cosdis, 1, l_cosdis, 1, l_observacion,l_codprecdis , l_codprecdis, 1);
                      end if;

              -- Inserta equipos en la SOT

              select count(numserie) into l_contequdth from solotptoequ where tipequ in (7111, 7113, 7242) and codsolot =  l_codsolot;

              if l_contequdth = 0 then
                    OPERACION.P_LLENA_SOLOTEQU_DE_EF(l_codsolot);
                    commit;
              end if;

               -- Inserta el numero de serie en los equipos

              for c in cur loop
                    update solotptoequ set numserie=c.serie where codsolot=c.codsolot and tipequ=c.tipequope and rownum=1;
                    commit;
                    update solotptoequ set numserie=c.serie where codsolot=c.codsolot and  tipequ=c.tipequope and numserie is null;
                    commit;
              end loop;

              select count(numserie) into l_contequdth from solotptoequ where tipequ in (7111, 7113, 7242) and codsolot =  l_codsolot;

              if l_contequdth=3 or l_contequdth=5 then
                 -- Validamos la reserva
                 update solotptoequ set flgsol = 1, fecfdis = l_fecusu  where codsolot = l_codsolot;
                  -- Insertar la reserva
                 insert into operacion.tmp_gen_masiva_pep(codsolot,numslc) values (l_codsolot, l_numslc);
                     -- Cierre de tarea
                    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf, 4, 4, null, sysdate, sysdate);
              end if;

              commit;
           end if;
      end if;
  end if;

 exception

              WHEN OTHERS THEN
                   l_var := 'OPERACION.PQ_CUSPE_OPE.P_LIQUIDACION_AUTO_DTH' || l_codsolot ||
                 ' Error en asignacion de responsable y contrata (Tarea Automatica - Liquidación automaticamente DTH - Problema presentado: ' || sqlerrm;

                  if trim(l_var) <> '' then
                       opewf.pq_send_mail_job.p_send_mail('OPERACION.PQ_CUSPE_OPE.P_LIQUIDACION_AUTO_DTH',
                                                       'DL-PE-ITSoportealNegocio@claro.com.pe',--29.0
                                                       l_var);
                  end if;

END;

procedure P_LIBERAR_NUMERORESERVADO(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number)
/******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        24/06/2008  Roy Concepcion   Proceso que liberara los numeros telefonicos al
                              momento de dar de baja el servicio.
******************************************************************************/
IS
l_codsolot solot.codsolot%type;
--l_numero   numtel.numero%type;
--l_codinssrv inssrv.codinssrv%type;
l_numslc vtatabslcfac.numslc%type;
l_codnumtel numtel.codnumtel%type;
l_var varchar2(200);
cursor c1 is
/*select b.numero,b.codinssrv --into l_numero,l_codinssrv
from  solotpto a,inssrv b,tystabsrv c,producto d
where a.codinssrv = b.codinssrv and
     b.codsrv = c.codsrv and
     c.idproducto = d.idproducto and
     d.idtipinstserv = 3 and
     a.codsolot = l_codsolot;*/
   SELECT d.numero, d.codinssrv
     FROM SOLOTPTO A, INSPRD P, TYSTABSRV C,NUMTEL D , PRODUCTO R
    WHERE a.codsolot = l_codsolot
      AND a.codinssrv = d.codinssrv
      AND a.codsrvnue = c.codsrv
      AND a.pid = p.pid
      AND c.tipsrv = '0004'
      AND p.flgprinc = 1  -- Es Principal
      AND c.idproducto = r.idproducto
      AND r.idtipinstserv = 3
      --ini 28.0
      AND a.pid_old is null;
      --fin 28.0
BEGIN
     select codsolot into l_codsolot from wf where idwf = a_idwf;
     BEGIN
        select numslc into l_numslc from solot where codsolot = l_codsolot;
     EXCEPTION
         WHEN OTHERS THEN
            l_numslc := '';
     END;

     for cn1 in c1 loop

       BEGIN
           update numtel
           SET estnumtel = 1,
               codinssrv = NULL,
               codusuasg = NULL,
               FECASG = NULL
           where numero = cn1.numero;

           select codnumtel
           into l_codnumtel
           from numtel
           where numero = cn1.numero;

           update inssrv set numero = ''
           where codinssrv = cn1.codinssrv;

           update reservatel
           set estnumtel = 1,
               NUMSLC = NULL,
               CODCLI = NULL
           where codnumtel = l_codnumtel
           and numslc = l_numslc;

           COMMIT;

       EXCEPTION
          WHEN OTHERS THEN
             ROLLBACK;
       END;

     end loop;
exception
     WHEN OTHERS THEN
        ROLLBACK;
         l_var := 'OPERACION.PQ_CUSPE_OPE.P_LIBERAR_NUMERORESERVADO' || l_codsolot ||
       ' Error en la liberacion del Numero Telefonico ' || sqlerrm;

        if l_var is not null then
             opewf.pq_send_mail_job.p_send_mail('OPERACION.PQ_CUSPE_OPE.P_LIBERAR_NUMERORESERVADO',
                                             'DL-PE-ITSoportealNegocio@claro.com.pe',--29.0
                                             l_var);
        end if;
END;

procedure P_CORTE_DTH(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number)
    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        01/07/2008  Gormeño  Guarda un registro de pid para que sea enviado a corte a través de un job
    ******************************************************************************/
IS
cursor c_pid is
  select s.codsolot, sp.codinssrv, i.pid
    from solot s, wf, solotpto sp, insprd i
    where wf.codsolot = s.codsolot
    and s.codsolot = sp.codsolot
    and i.codinssrv = sp.codinssrv
--    and sp.pid = i.pid
    and i.flgprinc = 1
    and wf.idwf = a_idwf  ;

BEGIN
    for c in c_pid loop
        insert into tmp_corte_dth(codsolot, codinssrv, pid, estado, codusu, fecusu, TRANSACCION) values (c.codsolot, c.codinssrv, c.pid, 1, user, sysdate, 'CORTE');
    end loop;
END;

procedure P_RECONEXION_DTH(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number)
    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        01/07/2008  Gormeño  Guarda un registro de pid para que sea enviado a corte a través de un job
    ******************************************************************************/
IS
cursor c_pid is
select s.codsolot, sp.codinssrv, i.pid
    from solot s, wf, solotpto sp, insprd i
    where wf.codsolot = s.codsolot
    and s.codsolot = sp.codsolot
    and i.codinssrv = sp.codinssrv
--    and sp.pid = i.pid
    and i.flgprinc = 1
    and wf.idwf = a_idwf  ;

BEGIN
    for c in c_pid loop
        insert into tmp_corte_dth(codsolot, codinssrv, pid, estado, codusu, fecusu, TRANSACCION) values (c.codsolot, c.codinssrv, c.pid, 1, user, sysdate, 'RECONEXION');
    end loop;
END;

procedure p_reg_solotptoequ_gsm_cdma(a_idtareawf in number,
                                      a_idwf      in number,
                                      a_tarea     in number,
                                      a_tareadef  in number) is



   l_cont number;
   l_codsolot number;
   v_serie varchar2(100);
   v_numslc varchar2(100);
   v_observacion varchar2(100);
   v_cod_sap varchar2(100);
   l_orden number;
   l_punto number;
   l_punto_ori number;
   l_punto_des number;
   l_codeta number;
   l_cont_equipos number;
cursor c_equ is
SELECT trim(A.NUMSERIE) serie1, g.tipequ, g.costo,
trim(A.NUMNSE) serie2, A.NUMSLC,  E.COD_SAP,E.NROSERIE,a.fecusu fecha_creacion
FROM SALES.REGINFCDMA  A, (select * from opedd where tipopedd=201 and abreviacion='CDMA') D ,
Maestro_Series_Equ e, almtabmat f, tipequ g
WHERE a.numslc = v_numslc
and D.CODIGOC=E.COD_SAP AND E.NROSERIE=TRIM(A.NUMSERIE)
and e.cod_sap = trim(f.cod_sap) and f.codmat=g.codtipequ;

begin
  select codsolot into l_codsolot from wf where idwf = a_idwf;
  select numslc into v_numslc from solot where codsolot = l_codsolot;
  for c_s in c_equ loop
     v_serie:= null;
     v_observacion :='';--29.0
     operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,l_punto,l_punto_ori,l_punto_des);
     SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from solotptoequ
     where codsolot = l_codsolot and punto = l_punto;

     select codigon into l_codeta from opedd where tipopedd = 197
     and trim(codigoc) = trim(c_S.cod_sap);

     select count(1) into l_cont_equipos from solotptoequ where
     codsolot = l_codsolot and trim(numserie) = trim(c_s.nroserie);
     if l_cont_equipos = 0 then --No esta registrado el Equipo en la SOT
        insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,COSTO,NUMSERIE,flgsol,
        flgreq,codeta,tran_solmat,observacion,fecfdis)
        values(l_codsolot,l_punto,l_orden,c_s.tipequ,1,0,nvl(c_s.costo,0),c_s.NroSerie,1,
        0,l_codeta,null,v_observacion ,c_s.fecha_creacion);
     end if;

   end loop;

end;
FUNCTION f_producto_sot(l_sot NUMBER,l_idpro NUMBER)

  return number  IS
  l_cont number;
  l_val number;
  BEGIN
    select count(1)
      into l_cont
      from solotpto so, tystabsrv tys
     where so.codsrvnue = tys.codsrv
       and tys.idproducto = l_idpro
       and so.codsolot = l_sot;
     if(l_cont > 0) then
       l_val := 1;
      else
      l_val := 0;
     end if;
   return l_val;
  END;

--<REQ ID = 102623>
 PROCEDURE p_actualizar_area_tareawf( a_idtareawf in number,
                                            a_idwf      in number,
                                            a_tarea     in number,
                                            a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        22/10/2009  Joseph Asencios  Actualiza el area encargada de la tarea según configuración.
    ******************************************************************************/

    l_tipsrv     vtatabslcfac.tipsrv%type;
    l_codsolot   solotpto.codsolot%type;
    l_count      number;
    l_countfax   number;
    l_countmail  number;
    l_tiptra     number;
    l_solucion   number;
    ls_numslc    vtatabslcfac.numslc%type;
    ln_telefonia number;
    ln_solucion   number;
    ln_idcampanha number;
    ln_area       number;
    ln_wfdef      number;

    CURSOR c1 IS
      select idtareawf, tarea, idwf, tareadef, tipo
        from tareawfcpy
       where idwf = a_idwf;

  BEGIN
    begin
      SELECT distinct s.tipsrv, s.tiptra
        into l_tipsrv, l_tiptra
        from solot s, wf b
       where s.codsolot = b.codsolot
         and rownum = 1
         and b.idwf = a_idwf;

    exception
      when others then
        raise_application_error(-20411, 'no existe registro.' || a_idwf);
    end;

    select codsolot , wfdef into l_codsolot , ln_wfdef  from wf where idwf = a_idwf;

    select count(1)
      into l_count
      from solotpto s, v_ubicaciones v -- provincias
     where s.codubi = v.codubi
       and v.codest <> 1
       and v.codpai = 51
       and s.codsolot = l_codsolot;

     begin
      select idsolucion , idcampanha
      into ln_solucion, ln_idcampanha
      from vtatabslcfac
      where numslc = (select max(numslc) from insprd
      where codinssrv in
      (select codinssrv from solotpto
      where codsolot = l_codsolot));

     exception
      when others then
        null;
     end;


        -- Para el caso de los proyectos pymes y TPI
       --ini 24.0
       -- if l_tipsrv = '0058' then
       --fin 24.0
           for au in c1 loop
            /* if au.tipo = 1 then*/
             -- Si la tarea esta en el tipo opcional
                if au.TAREADEF = a_tareadef then
                --Activación/Desactivación del servicio
                  begin
                    select area into ln_area from reasigna_area_wf
                    where idsolucion = ln_solucion and
                          idcampanha = ln_idcampanha and
                          wfdef = ln_wfdef and
                          tareadef = a_tareadef;


                    update tareawf
                    set area  = ln_area
                    where idtareawf = au.idtareawf;

                    update tareawfcpy
                    set area  = ln_area
                    where idtareawf = au.idtareawf;


                  exception
                    when others then
                    null;
                  end;

                end if;
             /*end if;*/
           end loop;
       --ini 24.0
       -- end if;
       --fin 24.0
  END;
  --</REQ>

--Inicio 40.0
 PROCEDURE  p_deriva_tarea_area( a_idtareawf in number,a_area  in number) IS
  ls_correo opewf.tareawfdef.area_deriva_correo%type;
  ln_tareawfdef number;
  ln_tarea number;
  l_cuerpo varchar2(4000);
  l_subject varchar2(200);
  l_codsolot number;
  l_descripcion opewf.tareawfcpy.descripcion%type;
  v_nomcli vtatabcli.nomcli%type;
  BEGIN

      select a.tarea, b.codsolot, a.descripcion, d.nomcli,e.area_deriva_correo
      into ln_tarea , l_codsolot,l_descripcion ,v_nomcli,ls_correo
      from tareawfcpy a , wf b, solot c, vtatabcli d, TAREAWFDEF e
      where a.idtareawf=a_idtareawf and a.idwf =b.idwf
      and b.codsolot =c.codsolot and c.codcli=d.codcli
      and a.tarea=e.tarea;

      update tareawf set area = a_area, responsable = null
      where idtareawf = a_idtareawf;
      if ls_correo is not null then
        l_subject := 'SOT - ' || to_char( l_codsolot) || ' - ' || 'Tarea : ' || l_descripcion;
        l_cuerpo := 'Se ha derivado la tarea: ' || l_descripcion || chr(13);
        l_cuerpo := l_cuerpo || 'SOT: ' ||  to_char( l_codsolot) || chr(13);
        l_cuerpo := l_cuerpo || 'Cliente: ' || v_nomcli || chr(13);
        P_ENVIA_CORREO_DE_TEXTO_ATT(l_subject, ls_correo, l_cuerpo );
      end if;
  END;
--Fin 40.0
  -- ini 48.0
  PROCEDURE p_mail_wf_solot_tpigsm(a_idtareawf IN NUMBER,
                                   a_tipesttar IN NUMBER,
                                   a_subject   OUT VARCHAR2,
                                   a_texto     OUT VARCHAR2) IS
    /******************************************************************************
    Genera el texto para el correo a enviar por el workflow
    ******************************************************************************/

    l_codsolot   solot.codsolot%TYPE;
    l_subject    VARCHAR2(200);
    l_cuerpo     VARCHAR2(4000);
    l_cuerpo_sot VARCHAR2(4000);
    l_temp       VARCHAR2(4000);
    r_tareawfcpy tareawfcpy%ROWTYPE;

    -- Solo hasta 10 lineas
  BEGIN

    SELECT * INTO r_tareawfcpy FROM tareawfcpy WHERE idtareawf = a_idtareawf;

    SELECT codsolot INTO l_codsolot FROM wf WHERE idwf = r_tareawfcpy.idwf;

    P_MAIL_SOLOT_INFORMACION(l_codsolot, l_subject, l_cuerpo_sot);

    l_cuerpo := 'Tarea: ' || r_tareawfcpy.descripcion;

    SELECT 'Estado: ' || esttarea.descripcion || chr(13) || 'Area: ' ||
           areaope.descripcion || chr(13) || 'Responsable: ' ||
           nvl(usuarioope.nombre, '<null>')
      INTO l_temp
      FROM areaope, tareawf, usuarioope, esttarea
     WHERE (tareawf.area = areaope.area(+))
       AND (tareawf.responsable = usuarioope.usuario(+))
       AND (tareawf.esttarea = esttarea.esttarea)
       AND tareawf.idtareawf = r_tareawfcpy.idtareawf;

    l_cuerpo := l_cuerpo || chr(13) || l_temp;

    l_cuerpo := l_cuerpo || chr(13) || l_cuerpo_sot;

    l_cuerpo := l_cuerpo || chr(13) || chr(13) || 'Usuario: ' || USER ||
                chr(13) || 'Fecha: ' || to_char(SYSDATE, 'dd/mm/yyyy hh24:mi') ||
                chr(13);

    a_subject := l_subject;
    a_texto   := l_cuerpo;

  END;
  --Ini 50.0
 /* PROCEDURE p_asignar_numeros_tpigsm(p_numslc  IN VARCHAR2,
                                     o_mensaje IN OUT VARCHAR2,
                                     o_error   IN OUT NUMBER) IS
    ln_aux               NUMBER;
    ln_cabecera          NUMBER;
    ln_codcab            NUMBER;
    ln_codgrupo          NUMBER;
    ln_orden             NUMBER;
    ln_cant_reser        NUMBER;
    ln_cant_inssrv       NUMBER;
    ln_codinssrv         NUMBER;
    an_numservice        inssrv.codinssrv%TYPE;
    v_mensaje            VARCHAR2(3000);
    v_error              NUMBER;
    ln_mayor_numpto_prin vtadetptoenl.numpto_prin%TYPE;
    ln_codnumtel         reservatel.codnumtel%TYPE;


    -- Atributos de Reservatel para actualizar Numtel.
    CURSOR c_numeros IS
      SELECT r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             n.imei,
             n.simcard
        FROM telefonia.reservatel r
       INNER JOIN numtel n
          ON (r.codnumtel = n.codnumtel)
       WHERE r.numslc = p_numslc
         AND r.valido = 1
       ORDER BY r.idseq;

  BEGIN
    --Validar la cantidad de numeros reservados vs intancia de servicio.
    -- # Numeros Reservados
    SELECT COUNT(*)
      INTO ln_cant_reser
      FROM telefonia.reservatel
     WHERE TRIM(numslc) = TRIM(p_numslc)
       AND valido = 1;

    IF ln_cant_reser > 0 THEN
      -- # Instancias de Servicio
      SELECT COUNT(*)
        INTO ln_cant_inssrv
        FROM operacion.inssrv
       WHERE numslc = p_numslc
            -- AND tipinssrv = 3
         AND numero IS NULL;

      IF ln_cant_reser <> ln_cant_inssrv THEN
        --raise_application_error(-20501,'No coincide numeros reservados vs los servicios creados');
        v_error   := -1;
        v_mensaje := 'No coincide numeros reservados vs los servicios creados';
      ELSE
        -- Fin de validacion.
        -- Se elige el numero de cabecera para la estructura de Telefonia
        ln_mayor_numpto_prin := intraway.pq_intraway_proceso.f_obt_numpto_princ(p_numslc);

        SELECT codnumtel
          INTO ln_cabecera
          FROM telefonia.reservatel
         WHERE numslc = p_numslc
           AND numpto = ln_mayor_numpto_prin;

        FOR cur_in IN c_numeros LOOP
          SELECT codinssrv
            INTO ln_codinssrv
            FROM operacion.inssrv
           WHERE tipinssrv = 3
             AND numero IS NULL
             AND numslc = p_numslc
             AND numpto = cur_in.numpto
             AND rownum = 1;

          -- Se actualiza Numtel: estado, inssrv, etc..
          UPDATE telefonia.numtel
             SET codinssrv = ln_codinssrv,
                 estnumtel = 2,
                 publicar  = cur_in.publicar
           WHERE codnumtel = cur_in.codnumtel;

          UPDATE operacion.inssrv
             SET numero  = cur_in.numero,
                 imei    = cur_in.imei,
                 simcard = cur_in.simcard
           WHERE codinssrv = ln_codinssrv;

          UPDATE telefonia.reservatel
             SET valido = 1
           WHERE idseq = cur_in.idseq;

        --ini 33.0
        END LOOP;

        pq_telefonia.p_crear_hunting(ln_cabecera, ln_codcab);

        SELECT codcab, codgrupo
          INTO ln_codcab, ln_codgrupo
          FROM telefonia.grupotel
         WHERE codnumtel = ln_cabecera;

        FOR cur_in IN c_numeros LOOP
          IF ln_cabecera <> cur_in.codnumtel THEN
            pq_telefonia.p_crear_numxgrupotel(cur_in.codnumtel,
                                              ln_codcab,
                                              ln_codgrupo,
                                              ln_orden);
          END IF;

        END LOOP;
        v_error   := 0;
        v_mensaje := 'Se asigno automaticamente el numero: ';
      END IF;

    END IF;
    o_error   := v_error;
    o_mensaje := v_mensaje;

  END;

  PROCEDURE p_asig_numtel_tpigsm(a_idtareawf IN NUMBER,
                                 a_idwf      IN NUMBER,
                                 a_tarea     IN NUMBER,
                                 a_tareadef  IN NUMBER) IS

    l_countcola        NUMBER;
    l_cantvtadetptoenl NUMBER;
    l_cantreserva        NUMBER;
    l_numslc           operacion.solot.numslc%TYPE;
    l_numeroini        telefonia.numtel.numero%TYPE;
    l_codnumtel        telefonia.numtel.codnumtel%TYPE;
    l_pre_mail         tareawfcpy.pre_mail%TYPE;
    l_subject          VARCHAR2(200);
    l_cuerpo           VARCHAR2(4000);
    exceptioncodsuc     EXCEPTION;
    exceptioninventario EXCEPTION;
    exceptionnumtel     EXCEPTION;
    l_mensaje   VARCHAR2(3000);
    l_error     NUMBER;
    l_cod_error NUMBER;
    l_des_error VARCHAR2(1000);

    CURSOR c1 IS
      SELECT s.codsolot,
             p.numslc,
             e.numpto,
             e.ubipto,
             e.codsuc,
             p.codcli,
             p.idsolucion
        FROM operacion.solot s
       INNER JOIN sales.vtatabslcfac p
          ON (s.numslc = p.numslc)
       INNER JOIN sales.vtadetptoenl e
          ON (p.numslc = e.numslc AND e.flgsrv_pri = 1)
       INNER JOIN inssrv i
          ON (e.numslc = i.numslc AND e.numpto = i.numpto)
       WHERE s.numslc = l_numslc
         AND tipsrv IN
             (SELECT o.codigoc
                FROM operacion.tipopedd t
               INNER JOIN operacion.opedd o
                  ON (t.tipopedd = o.tipopedd)
               WHERE o.abreviacion = 'TPIGSM/tipsrv'
                 AND t.descripcion = 'OPE-Config TPI - GSM');
  BEGIN
    l_numeroini := NULL;

    SELECT b.numslc
      INTO l_numslc
      FROM wf a, solot b
     WHERE a.codsolot = b.codsolot
       AND a.idwf = a_idwf;

    SELECT COUNT(1) INTO l_cantreserva FROM reservatel WHERE numslc = l_numslc;

    SELECT COUNT(1)
      INTO l_cantvtadetptoenl
      FROM vtadetptoenl a, tystabsrv b, producto c
     WHERE a.codsrv = b.codsrv
       AND b.idproducto = c.idproducto
       AND a.numslc = l_numslc
       AND c.idtipinstserv = 3;

    IF l_cantreserva <> l_cantvtadetptoenl THEN
      FOR cn1 IN c1 LOOP
        IF cn1.codsuc IS NULL THEN
          RAISE exceptioncodsuc;
        END IF;

        SELECT MIN(n.numero)
          INTO l_numeroini
          FROM operacion.solot s
         INNER JOIN sales.vtatabslcfac v -- 49.0
            ON (s.numslc = v.numslc) -- 49.0
         INNER JOIN sales.vtadetptoenl e
            ON (v.numslc = e.numslc AND e.flgsrv_pri = 1) -- 49.0
         INNER JOIN operacion.inssrv i
            ON (e.numslc = i.numslc AND e.numpto = i.numpto)
         INNER JOIN marketing.vtasuccli t
            ON (s.codcli = t.codcli AND e.codsuc = t.codsuc)
         INNER JOIN telefonia.planproducto p
            ON (p.idproducto = e.idproducto)
         INNER JOIN telefonia.plannum pl on (pl.codplan = p.codplan) -- 49.0
         INNER JOIN telefonia.zonatel z
            ON (pl.codplan = z.codplan) -- 49.0
         INNER JOIN telefonia.serietel r
            ON (\*t.ubisuc = r.codubi AND*\ z.codzona = r.codzona AND r.estado = 1) -- 49.0
          --AND r.disponibles > 0) -- 49.0
         INNER JOIN marketing.vtatabdst a1 on (a1.codpai = cc_codpai and r.codubi = a1.codubi) -- 49.0
         INNER JOIN marketing.vtatabdst b1 on (b1.codest = a1.codest and b1.codubi = t.ubisuc) -- 49.0
         INNER JOIN telefonia.numtel n
            ON (n.numero BETWEEN r.numini AND r.numfin AND tipnumtel = 1 AND n.estnumtel = 1) -- 49.0
         WHERE v.numslc = l_numslc -- 49.0
           AND e.numpto = cn1.numpto
           AND i.tipsrv IN
               (SELECT o.codigoc
                  FROM operacion.tipopedd t
                 INNER JOIN operacion.opedd o
                    ON (t.tipopedd = o.tipopedd)
                 WHERE o.abreviacion = 'TPIGSM/tipsrv'
                   AND t.descripcion = 'OPE-Config TPI - GSM')
           -- ini 49.0
           AND pl.codplan in
               (SELECT o.codigon
                  FROM operacion.tipopedd t
            INNER JOIN operacion.opedd o
                    ON (t.tipopedd = o.tipopedd)
                 WHERE o.abreviacion = 'TPIGSM/codplan'
                   AND t.descripcion = 'OPE-Config TPI - GSM')
           -- fin 49.0
           AND NOT EXISTS
         (SELECT '*'
                  FROM operacion.inssrv i1
                 WHERE (n.numero = i1.numero)
                   AND (i1.fecfin IS NULL OR i1.fecfin > SYSDATE)
                   AND (i1.tipinssrv = 3)
                   AND (i1.estinssrv = 1))
           AND NOT EXISTS (SELECT codcli, codinssrv
                  FROM billcolper.instanciaservicio a
                 WHERE (n.numero = a.nomabr)
                   AND (a.fecfin IS NULL OR a.fecfin > SYSDATE)
                   AND (a.tipinstserv = 3));

        IF l_numeroini IS NULL OR l_numeroini = '0' THEN
          RAISE exceptioninventario;
        END IF;

        operacion.pq_cuspe_ope2.p_valida_numtel(l_numeroini,
                                                cn1.codcli,
                                                l_cod_error,
                                                l_des_error);

        IF l_cod_error < 0 THEN
          RAISE exceptionnumtel;
        END IF;

        SELECT codnumtel
          INTO l_codnumtel
          FROM numtel
         WHERE numero = l_numeroini;

        UPDATE numtel SET estnumtel = 5 WHERE codnumtel = l_codnumtel;

        INSERT INTO reservatel
          (codnumtel, numslc, numpto, valido, codcli, estnumtel, publicar)
        VALUES
          (l_codnumtel, l_numslc, cn1.numpto, 1, cn1.codcli, 5, 0);

        COMMIT;

      END LOOP;

      p_asignar_numeros_tpigsm(l_numslc, l_mensaje, l_error);
      IF l_error = 0 THEN
        --Envio de Informacion por mail
        p_mail_wf_solot_tpigsm(a_idtareawf, 1, l_subject, l_cuerpo);

        SELECT tc.pre_mail
          INTO l_pre_mail
          FROM tareawfcpy tc
         WHERE tc.idtareawf = a_idtareawf;
        IF l_pre_mail IS NOT NULL THEN
          p_envia_correo_de_texto_att(l_subject, l_pre_mail, l_cuerpo);
        END IF;
        INSERT INTO tareawfseg
          (idtareawf, observacion, flag)
        VALUES
          (a_idtareawf, l_mensaje || l_numeroini, 1);
      ELSE
        RAISE exceptioninventario;
      END IF;

    END IF;
  EXCEPTION
    WHEN exceptioncodsuc THEN

      SELECT sq_cola_send_mail_job.nextval INTO l_countcola FROM dummy_opwf;

      INSERT INTO opewf.cola_send_mail_job
        (idmail, nombre, subject, destino, cuerpo, flg_env)
      VALUES
        (l_countcola,
         'SGA-SoportealNegocio',
         'Asignacion de Numero Telefonico para tipos de servicios TPI SGM',
         'dl-pe-itsoportealnegocio@claro.com.pe',
         'No se realizo correctamente la asignacion de Numero Telefonico para tipos de servicios TPI SGM ' ||
         l_numslc,
         '0');

    WHEN exceptioninventario THEN
      SELECT sq_cola_send_mail_job.nextval INTO l_countcola FROM dummy_opwf;

      INSERT INTO opewf.cola_send_mail_job
        (idmail, nombre, subject, destino, cuerpo, flg_env)
      VALUES
        (l_countcola,
         'SGA-SoportealNegocio',
         'Asignacion de Numero Telefonico para tipos de servicios TPI SGM',
         'dl-pe-itsoportealnegocio@claro.com.pe',
         'No se realizo correctamente la asignacion de Numero Telefonico para tipos de servicios TPI SGM ' ||
         l_numslc,
         '0');
      COMMIT;
    WHEN exceptionnumtel THEN
      SELECT sq_cola_send_mail_job.nextval INTO l_countcola FROM dummy_opwf;

      INSERT INTO opewf.cola_send_mail_job
        (idmail, nombre, subject, destino, cuerpo, flg_env)
      VALUES
        (l_countcola,
         'SGA-SoportealNegocio',
         'Asignacion de Numero Telefonico para tipos de servicios TPI SGM',
         'dl-pe-itsoportealnegocio@claro.com.pe',
         l_des_error || ' - ' || l_numslc,
         '0');
  END;*/
  --Fin 50.0
  FUNCTION exist_paquete_tpi_gsm(p_numslc vtadetptoenl.numslc%TYPE)
    RETURN BOOLEAN IS
    l_idsolucion vtatabslcfac.idsolucion%TYPE;
    l_idcampanha solucionxcampanha.idcampanha%TYPE;
    l_count      PLS_INTEGER;
    l_result     BOOLEAN := FALSE;
    l_cnt_cr     NUMBER;
  BEGIN
    --ini 49.0
  /*SELECT t.idsolucion
      INTO l_idsolucion
      FROM vtatabslcfac t
     WHERE t.numslc = p_numslc;

    SELECT COUNT(*)
      INTO l_count
      FROM solucionxcampanha t
     WHERE t.idsolucion = l_idsolucion
       AND t.idcampanha =
           (SELECT d.codigon
              FROM tipopedd c, opedd d
             WHERE c.tipopedd = d.tipopedd
               AND c.descripcion = 'OPE-Config TPI - GSM'
               AND d.abreviacion = 'TPIGSM/idcampanha');


    select count(*)  into l_cnt_cr
      from regvtamentab r, instancia_paquete_cambio ip
     where r.numregistro = ip.numregistro
       and ip.flg_tipo_vm ='CR'
       and r.numslc = p_numslc ;*/

    SELECT COUNT(*)
      INTO l_count
      FROM vtatabslcfac t
     WHERE t.numslc = p_numslc
       and t.idcampanha in
           (SELECT d.codigon
              FROM tipopedd c, opedd d
             WHERE c.tipopedd = d.tipopedd
               AND c.descripcion = 'OPE-Config TPI - GSM'
               AND d.abreviacion = 'TPIGSM/idcampanha');

    IF l_count > 0 THEN
      /*IF l_cnt_cr > 0 THEN
         l_result := FALSE;
      ELSE*/
         l_result := TRUE;
      --END IF;
  --fin 49.0
    END IF;

    RETURN l_result;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN l_result;
  END;

  PROCEDURE P_MAIL_SOLOT_INFORMACION(a_codsolot IN NUMBER,
                    a_subject OUT VARCHAR2,
                    a_texto OUT VARCHAR2) IS

  l_subject VARCHAR2(200);
  l_cuerpo          VARCHAR2(4000);
  l_temp            VARCHAR2(4000);
  ln_tiptra         NUMBER;

  CURSOR cur_det IS
    SELECT rpad('CID', 8, ' ') || '  ' || rpad('Servicio', 50, ' ') || '  ' ||
           'Direccion' linea
      FROM dual
    UNION ALL
    SELECT rpad('-', 8, '-') || '  ' || rpad('-', 50, '-') || '  ' ||
           rpad('-', 70, '-')
      FROM dual
    UNION ALL
    SELECT rpad(s.cid, 8, ' ') || '  ' || rpad(ltrim(t.DSCSRV), 50, ' ') || '  ' ||
           s.direccion || ' - ' || d.distrito_desc ||
           decode(inmueble, NULL, ' ', ' - ' || 'IDINMUEBLE ' || inmueble)
      FROM solotpto s, ubired u, edificio e, V_UBICACIONES d, tystabsrv t
     WHERE s.codubi = d.codubi(+)
       AND s.codsrvnue = t.codsrv(+)
       AND rownum < 10
       AND s.pop = u.codubired(+)
       AND u.edificio = e.codigo(+)
       AND codsolot = a_codsolot;

BEGIN

  SELECT 'SOT ' || a_codsolot || ' - ' || a.descripcion, a.tiptra
    INTO l_subject, ln_tiptra
    FROM tiptrabajo a, solot s
   WHERE s.tiptra = a.tiptra
     AND s.codsolot = a_codsolot;

  SELECT 'Cliente: ' || vtatabcli.nomcli || chr(13) || 'Proyecto: ' ||
         nvl(solot.numslc, '<null>') || chr(13) || 'Plan: ' ||
         (select campanha.descripcion
          from vtatabslcfac, campanha
         where campanha.idcampanha = vtatabslcfac.idcampanha
           and vtatabslcfac.numslc = solot.Numslc) || chr(13) ||
         DECODE(vtatabcli.tipdide,
                '001',
                'RUC: ' || vtatabcli.ntdide,
                'DNI: ' || vtatabcli.ntdide) || chr(13) || 'Número: ' ||
         (SELECT inssrv.numero FROM inssrv WHERE inssrv.numslc = solot.Numslc) ||
         chr(13) || 'SIMCARD: ' ||
         (SELECT inssrv.simcard FROM inssrv WHERE inssrv.numslc = solot.Numslc) ||
         chr(13) || 'Número Domicilio Referencial : ' ||
         (SELECT numcomcli
            FROM vtamedcomcli, vtatabmedcom
           WHERE vtamedcomcli.codcli = vtatabcli.codcli
             AND vtamedcomcli.idmedcom = '006'
             AND vtamedcomcli.idmedcom = vtatabmedcom.idmedcom) || chr(13) ||
         'Número Celular Referencial : ' ||
         (SELECT numcomcli
            FROM vtamedcomcli, vtatabmedcom
           WHERE vtamedcomcli.codcli = vtatabcli.codcli
             AND vtamedcomcli.idmedcom = '007'
             AND vtamedcomcli.idmedcom = vtatabmedcom.idmedcom)
    INTO l_temp
    FROM vtatabcli, solot
   WHERE solot.codsolot = a_codsolot
     AND vtatabcli.codcli(+) = solot.codcli;

  l_cuerpo := l_cuerpo || chr(13) || chr(13) || l_temp;

  l_temp := '';
  FOR lcur IN cur_det LOOP
    l_temp := l_temp || chr(13) || lcur.linea;
  END LOOP;

  l_cuerpo := l_cuerpo || chr(13) || chr(13) || l_temp;

  IF ln_tiptra = 24 OR ln_tiptra = 25 THEN
    l_temp   := 'Esta OS deve ser atendida como prioritária, pois deve cumprir com os prazos definidos pela ' ||
                'Anatel (usuários residenciais 3dias úteis - usuários não residenciais 24hs e serviços de utilidade pública 6hs).';
    l_cuerpo := l_cuerpo || chr(13) || chr(13) || l_temp;
  END IF;

  a_subject := l_subject;
  a_texto   := l_cuerpo;

END;
  --Fin 48.0
  --------------------------------------------------------------------------------
  --Ini 58.0
  procedure MICLSS_OBT_COD_CLIENTE(P_NUMERO    varchar2,
                                   P_CODCLI    out varchar2,
                                   P_COD_ERROR out number,
                                   P_DES_ERROR out varchar2) is
    V_ERROR exception;

  begin
    if P_NUMERO is null then
      raise V_ERROR;
    end if;

    select distinct t.codcli
      into P_CODCLI
      from inssrv t
     where t.numero = P_NUMERO
       and t.estinssrv in (1, 2);

    P_COD_ERROR := 0;
    P_DES_ERROR := 'Operación Exitosa';

  exception
    when NO_DATA_FOUND then
      P_COD_ERROR := 1;
      P_DES_ERROR := 'NO ENCONTRADO';
    when TOO_MANY_ROWS then
      P_CODCLI    := null;
      P_COD_ERROR := 3;
      P_DES_ERROR := 'SE ENCONTRO MAS DE UN REGISTRO';
    when V_ERROR then
      P_COD_ERROR := 2;
      P_DES_ERROR := 'FALTAN PARAMETROS';
    when others then
      P_COD_ERROR := '-1';
      P_DES_ERROR := 'ERROR: ' || sqlerrm;
  end;
  --Fin 58.0
  
FUNCTION f_verf_prixhunting (a_idwf number )    
  return number  IS   -- valido = 1 , no valido = 0

  l_cont     number;
  v_codcli solot.codcli%type;  
  v_numslc solot.numslc%type;
  
  BEGIN
    
     select s.codcli, s.numslc   
       into v_codcli, v_numslc    
       from solot s, wf w
      where w.idwf      = a_idwf
        and s.codsolot  = w.codsolot;

     select count(*) into l_cont  -- tiene bundle ?
       from bundlexproyecto 
      where codcli = v_codcli  
        and numslc = v_numslc;
  
       if l_cont >= 1 then 
         
         l_cont := 0;
         select count(*) into l_cont  -- verf en prixhunting
         from prixhunting pp
         where pp.codcab in (
                    select h.codcab   
                      from hunting h,   
                           inssrv i,   
                           numtel n  
                     where i.codinssrv = n.codinssrv  
                       and h.codnumtel = n.codnumtel  
                       and i.codcli    = v_codcli
                       and i.numslc    = v_numslc )
         and pp.codpritel in (
                     select p.codpritel  
                       from pritel p, inssrv i, solot s, wf w
                      where w.idwf      = a_idwf
                        and s.codsolot  = w.codsolot
                        and i.codcli    = s.codcli
                        and i.numslc    = s.numslc      
                        and p.codinssrv = i.codinssrv 
                        and i.numslc    = v_numslc ) ;
                        
          if l_cont > 0 then
            return 1;   
          else
            return 0;    
          end if;
       else
         return 1;       
       end if;
       
  exception
    when others then
      return 0;    
  END;
  
end;
/
