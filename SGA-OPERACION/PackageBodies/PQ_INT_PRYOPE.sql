CREATE OR REPLACE PACKAGE BODY operacion.pq_int_pryope AS
  /**********************************************************************************************************
    NOMBRE:       PQ_INT_PRYOPE
    PROPOSITO:    Manejo de Sol. OT.
  
    REVISIONES:
  
  Version      Fecha       Autor            Solicitado por      Descripcion
  ---------  ----------  ---------------    ------------------  ------------------------------------------
     1.0     16/10/2002  Carlos Corrales
             16/02/2003  Carlos Corrales                        Agrege un comportamiento adic a Valido
                                                                1: Valido
                                                                0: Invalido
                                                                2: Item Multiplicado
                                                                Agrege el comportamiento de SUBGRUPO
                                                                Dentro de un Grupo un subgrupo identifica una IS
             27/02/2003  Carlos Corrales                        Se agrego lo de traslado
             18/03/2003  Carlos Corrales                        Se agrego lo de IS Maestra
             26/03/2003  Carlos Corrales                        Corrigio la logica para generar IP Principal
             01/04/2003  Carlos Corrales                        Agrupar usando la IS Maestra.
             24/04/2003  Carlos Corrales                        Se agrego unas consideraciones para Pry. Internos
             02/06/2003  Carlos Corrales                        Se agrego logica para agrupar por IS
             01/09/2003  Carlos Corrales                        Se hizo las modificaciones para soportar DEMOs
    2.0      07/01/2005  VValqui                                Modificado por el requerimeinto 24667, se agrego la funcion F_EF_CONFORME.
    3.0      01/08/2007  LPatiño                                Agrupación de los proyectos de paquetes Pymes y Telefonía Publica en una única SOT
    4.0      23/08/2007  Rbabilonia                             Se incluye TPI
    5.0      11/09/2007  MLondona                               Se modifica p_load_int_pryope para que registre la fecha de compromiso de los tpi
    6.0      07/05/2009  Hector Huaman M                        REQ-91633: se hizo modificaciones para la Venta de PCs(procedmiento p_crear_solot_pryope)
    7.0      11/05/2009  Hector Huaman M                        REQ-91791:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion del servicio GSM
    8.0      03/03/2009  Hector Huaman M                        REQ-94423:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion de Venta de equipos LG-Nortel
    9.0      23/06/2009  Victor Valqui                          cambios Primesys
   10.0      13/08/2009  Hector Huaman M                        REQ-99917:se modifico el procedimiento P_CREAR_SOLOT_PRYOPE para adecuacion del servicioo de profesor 24 horas
   11.0      01/09/2009  Raúl Pari                              REQ-96442: Se modificó el procedimiento p_load_int_pryope para que se considere al upgrade o downgrade
                                                                en la agrupacion unica en la tabla int_pryope.
   12.0      15/09/2009  Hector Huaman M                        REQ-98909:se agrego procedimiento p_crea_solot para poder identificar los proyectos sin la necesidad de formar la SOT.
   13.0      28/09/2009  Hector Huaman M.                       REQ.102366:se cambio procedimiento p_crear_solot_pryope para agregar direccion referencial.
   14.0      13/11/2009  Hector Huaman M.                       REQ.106908:cambios para adecuaciones CDMA
   15.0      11/12/2009                                         REQ.105525:TN Por Coaxial
   16.0      16/12/2009  Jimmy Farfán G.                        Req. 97766: Se modificó el procedure P_CREA_TIPTRA para la asignación
                                                                de tiptra a servicios GSM-CDMA.
   17.0      12/03/2010  MEchevarria                            Req.122276: Se modificó el procedure P_CREA_TIPTRA para la asignación
                                                                de tiptra inalambrico- instalacion bundle dth y cdma.
   18.0      08/02/2010  Antonio Lagos                          Req. 106908 Configuracion Bundle DTH+CDMA
   19.0      31/03/2010  Edson Caqui        Req. 114519         Modificacion en p_crea_tiptra - Asignacion de Tipo de Trabajo - fase de post venta de TN en HFC
                                                                Depuracion de todo el paquete, depuracion de codigo comentado, variables no usadas, uso de dual y count(*).
                                                                Modificacion en maestro de procedimientos p_exe_int_pryope
   20.0      19/07/2010  Giovanni Vasquez   Req. 120091         Puerto 25
   21.0      16/09/2010  Antonio Lagos      Juan Gallegos       REQ.142338, Migracion DTH
   22.0      31/05/2010  Widmer Quispe      Edilberto Astulle   Req: 123054 y 123052, Asignacion de plataforma de acceso.
   23.0      22/02/2012  Kevy Carranza      Manuel Gallegos     REQ 161738 Venta Menor VOD
   24.0      22/03/2012  Kevy Carranza      Manuel Gallegos     REQ 162188 Venta Menor VOD
   25.0      10/11/2011  Ivan Untiveros     Guillermo Salcedo   SINCR 10/05/2012 REQ-161199 DTH Post Pago RF02, se agrega en cabecera comentarios body cambios 23 y 24
   26.0      16/06/2012  Edilberto Astulle                      PROY-3766_Modificacion de las tareas de las SOT en HFC Claro Empresas
   27.0      04/07/2012  Mauro Zegarra      Hector Huaman       REQ-162820 Sincronización de proceso de ventas HFC (SISACT - SGA) - Etapa 1
   28.0      09/08/2012  Alex Alamo         Christian Riquelme  REQ-162977 - Proceso de Sincronizacion OFFICE 365
   29.0      17/08/2012  Christian R.       Christian Riquelme  SD-247986 - Cambio de Codigos de Tipo de Servicio y Tipo de Trabajo con el de Produccion.
   30.0      27/09/2012  Alex Alamo         Karen Velezmoro     PROY-3605 IDEA-3162 - Procesos Post Venta CE HFC ¿ Servicios Menores
   31.0      03/10/2012  Alex Alamo         Karen Velezmoro     PROY-3605 IDEA-3162 - Procesos Post Venta CE HFC ¿ Servicios Menores
   32.0      03/10/2012  Edilberto Astulle                      SD_460264 Inventario de equipos en SOT de Bajas
   33.0      01/03/2013  Ronald Ramirez     Zaira Escudero      PROY-5922 Configuración Nuevo servicio Cloud Presencia Web
   34.0      07/07/2013  Alex Alamo         Christian Riquelme  REQ 163564 Venta de los Productos Soportados en HFC en las aplicaciones SISACT
   35.0      29/08/2013  Juan Pablo Ramos   Hector Huaman       SD-744299
   36.0      07/08/2013  Erlinton Buitron   Alberto Miranda     REQ 164617 Instalacion TPI GSM
   37.0      17/09/2013  Dorian Sucasaca    Arturo Saavedra     IDEA-10970 CAMBIO DE RECAUDACIÓN
   38.0      02/09/2013  Alfonso Perez      Hector Huaman       IDEA-9767 Generación de Códigos de servicios por SOT CE Wimax
   39.0      21/10/2013  Edilberto Astulle  PQT-169335-TSK-36028
   40.0      20/01/2014  Dorian Sucasaca    Arturo Saavedra     REQ 164813 PROY-11240 IDEA-13797 SOT para duplicar ancho de banda a clientes HFC
   41.0      03/03/2014  Dorian Sucasaca    Arturo Saavedra     REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
   42.0      23/06/2014  Dorian Sucasaca    Arturo Saavedra     INCIDENCIA.
   43.0      01/09/2014  Mauro Zegarra      Edilberto Astulle   Tipo de trabajo para Portabilidad
   44.0      12/11/2014  Eustaquio Gibaja   Hector Huaman       Tipo de trabajo Cloud
   45.0      2015-05-08  Jose Ruiz Cueva    Eustaquio Gibaja    IDEA-22294- Automatización TPE HFC
   46.0      2015-06-25  Freddy Gonzales    Eustaquio Jibaja    SD 372800
   47.0      2015-08-06  Jose Varillas      Giovanni Vasquez    SD 415065
   48.0      2015-09-22  Danny Sánchez      Eustaquio Gibaja    PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
   49.0      2015-11-04  Dorian Sucasaca                        PROY-20152: IDEA-24390 Proyecto LTE - 3Play inalámbrico
   50.0      2015-11-17  Freddy Gonzales    Alberto Miranda     Migracion - DTH
   51.0      2015-11-24  Juan Olivares      Eustaquio Gibaja    PROY-17652 IDEA-22491 - ETAdirect
   52.0      2016-06-06  Edwin Vasquez      Lucia Manta         Proy-23947: Migración de clientes SGA a BSCS
   53.0      24/11/2016  Jose Varillas       Alertas Transfer Billing
   54.0      25/01/2017  Servicio Fallas-HITSS
   55.0      17/07/2017  Freddy Gonzales    Sandra Salazar      PROY-28061 IDEA-25279 Funcionalidad preselección - PROY-28061
   56.0      31/07/2018  Hitss                                  Portabilidad LTE
   57.0      23/08/2018  Justiniano Condori Justiniano Condori  PROY-33535 IDEA-44958 FTTH
   58.0      18/09/2018  Jose Arriola    Juan Cuya      PROY-32581 Agregar transacción CE cambio de plan
   59.0      16/10/2018  Jeny Valencia      Jose Varillas       PROY-32581 Portabilidad
   60.0     26/10/2018   Equipo TOA       Dante Sunohara      PROY-32581_SGA12
   61.0     28/11/2018   Equipo TOA       Dante Sunohara      PROY-32581_SGA15
  62.0     07/12/2018   Equipo TOA       Dante Sunohara      PROY-32581_SGA16
   63.0      15/10/2018  Alvaro Peña Gamarra                    PROY-XXXXX IDEA-44958 FTTH
   64.0      09/09/2019  Alvaro Peña G       FTTH               Configuracion de producto FTTH
   65.0      31/10/2019  Steve Panduro       FTTH               Traslado Externo / Interno FTTH
  *************************************************************************************************************************************************************************************/

  --<19.0
  /***********************************************************************
    PROCEDIMIENTO MAESTRO DE INTERFAZ VENTAS - OPERACIONES
  ************************************************************************/
  i_numpto NUMBER := 0; --<53.0>

  PROCEDURE p_exe_int_pryope(a_numslc IN CHAR,
                             a_numpsp IN CHAR DEFAULT NULL,
                             a_idopc  IN CHAR DEFAULT NULL,
                             a_estado IN NUMBER,
                             a_tipcon IN CHAR DEFAULT NULL) IS
  
    lv_solot VARCHAR2(4000);
    ln_val   NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO ln_val
      FROM opedd o, tipopedd t
     WHERE o.tipopedd = t.tipopedd
       AND t.abrev = 'TRANS_BILL'
       AND o.abreviacion = 'P_EXE_INT_PRYOPE'
       AND o.codigoc = '1';
    IF ln_val > 0 THEN
      operacion.p_val_doblereg_numslc(a_numslc, lv_solot);
    ELSE
      lv_solot := ' ';
    END IF;
  
    IF lv_solot = ' ' THEN
      p_valida_inf_pry(a_numslc, a_numpsp, a_idopc);
      p_actualiza_int_pryope(a_numslc);
      p_load_int_pryope(a_numslc, a_numpsp, a_idopc, a_tipcon);
      p_crear_is_pry(a_numslc);
      p_reagrupa_int_pry(a_numslc);
      p_crear_solot_pryope(a_numslc, a_numpsp, a_idopc, a_estado, a_tipcon);
      p_finales_int_pryope(a_numslc);
    ELSE
      raise_application_error(-20500,
                              'El cliente cuenta con SOTs de UPGRADE o DOWNGRADE en EJECUCION para los servicios seleccionados en proyecto actual, favor de terminar la Atencion o Anular :' ||
                              chr(13) || lv_solot);
    END IF;
  
  END;
  --19.0>

  /**********************************************************
    PROCEDIMIENTO CON LAS VALIDACIONES EN LA INFORMACION
    DEL PROYECTO  PARA LA GENERACION DE LA SOT
  ***********************************************************/
  PROCEDURE p_valida_inf_pry(a_numslc IN CHAR,
                             a_numpsp IN CHAR DEFAULT NULL,
                             a_idopc  IN CHAR DEFAULT NULL) IS
    l_cont NUMBER;
    l_temp NUMBER;
  
  BEGIN
    -- Inicio 55.0
    IF sales.pkg_preseleccion.sgafun_tipsrv_tfi(a_numslc, NULL) THEN
      -- TFI
      l_temp := 1;
    ELSE
      -- Inicio 55.0
      -- verificacion de solicitud de estudio de factibilidad es conforme
      l_temp := f_ef_conforme(a_numslc);
      -- Inicio 55.0
    END IF;
    -- Inicio 55.0
  
    -- valida que los campos numpto_orig y dest esten consistentes
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND numpto_orig IS NOT NULL
       AND numpto_orig NOT IN
           (SELECT numpto FROM vtadetptoenl WHERE numslc = a_numslc);
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en el campo NUMPTO_ORIG. Proyecto: ' ||
                              a_numslc);
    END IF;
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND numpto_dest IS NOT NULL
       AND numpto_dest NOT IN
           (SELECT numpto FROM vtadetptoenl WHERE numslc = a_numslc);
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en el campo NUMPTO_DEST. Proyecto: ' ||
                              a_numslc);
    END IF;
    -- validacion en el campo paquete
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND (paquete IS NULL OR paquete = 0);
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en el campo PAQUETE. No puede ser null o 0. Proyecto: ' ||
                              a_numslc);
    END IF;
    -- Problemas con los campos NUMPTO_ORIG y NUMPTO_DEST
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND (numpto = numpto_orig OR numpto = numpto_dest);
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en el campo NUMPTO_ORIG. El campo NUMPTO no puede ser igual a ORIG o DEST. Proyecto: ' ||
                              a_numslc);
    END IF;
    -- Problemas con los campos NUMPTO_ORIG y NUMPTO_DEST
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND (descpto IS NULL OR dirpto IS NULL OR codsrv IS NULL OR
           ubipto IS NULL);
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en los campos DESCPTO, DIRPTO, CODSRV, UBIPTO no pueden ser null. Proyecto: ' ||
                              a_numslc);
    END IF;
    -- Problemas con los campos TIPTRA
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND pid_old IS NOT NULL
       AND tiptra IS NULL;
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en el campo TIPTRA, No puede ser nulo para upgrades. Proyecto: ' ||
                              a_numslc);
    END IF;
  
    p_valida_grp_pry(a_numslc);
  
  END;

  /**********************************************************************
    Valida que todos los item del proyecto esten agrupados
  **********************************************************************/
  PROCEDURE p_valida_grp_pry(a_numslc IN CHAR) IS
    l_cont NUMBER;
  BEGIN
  
    p_agrupar_vtadetptoenl(a_numslc);
  
    SELECT COUNT(1)
      INTO l_cont
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND grupo IS NULL;
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'Error en la agrupacion de servicios del proyecto ' ||
                              a_numslc);
    END IF;
    RETURN;
  
  END;

  /*********************************************************
    Carga la interface Ventas - Operaciones: INT_PRYOPE
    Datos del proyecto , Detalle y OC
    Agrupa las IS por subgrupo y Multiplica las IS
  **********************************************************/
  PROCEDURE p_load_int_pryope(a_numslc IN CHAR,
                              a_numpsp IN CHAR DEFAULT NULL,
                              a_idopc  IN CHAR DEFAULT NULL,
                              a_tipcon IN CHAR DEFAULT NULL) IS
  
    l_grupo          NUMBER;
    l_subgrupo       NUMBER;
    minplaz          NUMBER;
    maxplaz          NUMBER;
    ln_proyect_pymes NUMBER;
    ln_proyecto_tpi  NUMBER;
    l_cont           NUMBER;
    l_feccom         DATE;
    l_cad            VARCHAR2(10);
    ln_count         NUMBER;
    ln_valcloud      NUMBER; --53.0
    lv_tipsrv        VARCHAR2(10);
  
    CURSOR cur_int IS
      SELECT ROWID, pid_old, tiptra
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1;
  
    CURSOR cur_grp IS
      SELECT grupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
       GROUP BY grupo;
  
    -- Agrupacion por IS
    CURSOR cur_subgrp IS
      SELECT numpto_pri
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND grupo = l_grupo
       GROUP BY numpto_pri;
  
    -- Productos que se multiplican
    -- Solo pueden ser principales
    CURSOR cur_mult IS
      SELECT i.idseq
        FROM int_pryope i, producto p
       WHERE i.numslc = a_numslc
         AND i.cantidad > 1
         AND i.valido = 1
         AND i.idproducto = p.idproducto
         AND p.flgcantuno = 2
         AND i.numpto = i.numpto_pri;
  
    --<53.0 Ini>
    -- Productos que se multiplican
    -- Solo pueden ser principales
    CURSOR cur_mult_prin IS
      SELECT i.idseq
        FROM int_pryope i, producto p
       WHERE i.numslc = a_numslc
         AND i.cantidad > 1
         AND i.valido = 1
         AND i.idproducto = p.idproducto
         AND p.flgcantuno = 3
         AND i.numpto = i.numpto_pri;
  
    -- Productos que se multiplican
    -- Solo pueden ser adicionales
    CURSOR cur_mult_adic IS
      SELECT i.idseq
        FROM int_pryope i, producto p
       WHERE i.numslc = a_numslc
         AND i.cantidad > 1
         AND i.valido = 1
         AND i.idproducto = p.idproducto
         AND p.flgcantuno = 3
         AND i.numpto <> i.numpto_pri;
    --<53.0 Fin>         
  
    CURSOR cur_is IS
      SELECT codinssrv, MIN(grupo) grupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
       GROUP BY codinssrv;
  
  BEGIN
  
    -- Carga los datos iniciales
    INSERT INTO int_pryope
      (numslc,
       numpto,
       numpto_pri,
       descripcion,
       direccion,
       codubi,
       codsrv,
       codequcom,
       bw,
       codsuc,
       on_net,
       codinssrv,
       pid,
       pid_old,
       tipsrv,
       idproducto,
       codcli,
       cantidad,
       codinssrv_tra,
       codinssrv_des,
       codinssrv_ori,
       numpto_ori,
       numpto_des,
       numpsp,
       idopc,
       grupo,
       codsolot,
       punto,
       tipinssrv,
       tiptra,
       codinssrv_pad,
       codubired,
       plazoins,
       cliint,
       tipcon,
       idpaq,
       iddet,
       idinssla, --9.0
       idplataforma --<22.0>
       )
      SELECT vtadetptoenl.numslc,
             vtadetptoenl.numpto,
             vtadetptoenl.numpto_prin,
             vtadetptoenl.descpto,
             vtadetptoenl.dirpto,
             vtadetptoenl.ubipto,
             vtadetptoenl.codsrv,
             vtadetptoenl.codequcom,
             vtadetptoenl.banwid,
             vtadetptoenl.codsuc,
             vtadetptoenl.on_net,
             vtadetptoenl.codinssrv,
             NULL,
             vtadetptoenl.pid_old,
             tystabsrv.tipsrv,
             tystabsrv.idproducto,
             vtatabslcfac.codcli,
             vtadetptoenl.cantidad,
             vtadetptoenl.codinssrv_tras,
             vtadetptoenl.codinssrv_dest,
             vtadetptoenl.codinssrv_orig,
             vtadetptoenl.numpto_orig,
             vtadetptoenl.numpto_dest,
             a_numpsp,
             a_idopc,
             grupo,
             NULL,
             NULL,
             NULL,
             vtadetptoenl.tiptra,
             vtadetptoenl.codinssrv_pad,
             vtadetptoenl.codceninx,
             vtadetptoenl.plazo_instalacion,
             vtatabslcfac.cliint,
             a_tipcon,
             vtadetptoenl.idpaq,
             vtadetptoenl.iddet,
             (SELECT idinssla
                FROM vtainssla a
               WHERE a.numslc = vtadetptoenl.numslc
                 AND a.numpto = vtadetptoenl.numpto
                 AND a.estado = 1), --9.0
             vtadetptoenl.idplataforma --<22.0>
        FROM tystabsrv, vtadetptoenl, vtatabslcfac
       WHERE tystabsrv.codsrv = vtadetptoenl.codsrv
         AND vtadetptoenl.numslc = vtatabslcfac.numslc
         AND vtatabslcfac.numslc = a_numslc;
  
    SELECT MIN(plazoins), MAX(plazoins)
      INTO minplaz, maxplaz
      FROM int_pryope
     WHERE numslc = a_numslc
       AND valido = 1;
  
    l_cad := pq_constantes.f_get_cfg;
  
    -- Se calcula la Fecha de compromiso
    IF l_cad IN ('BRA') THEN
      UPDATE int_pryope
         SET feccom = SYSDATE + plazoins
       WHERE numslc = a_numslc
         AND valido = 1;
    END IF;
  
    -- validaciones
    SELECT f_verifica_proyecto_pymes(a_numslc)
      INTO ln_proyect_pymes
      FROM dummy_ope;
  
    SELECT f_verifica_proyecto_tpi(a_numslc)
      INTO ln_proyecto_tpi
      FROM dummy_ope;
  
    -- Se actualiza a estado 5: Pendiente en Ventas
    IF ln_proyect_pymes = 1 OR ln_proyecto_tpi = 1 THEN
      UPDATE int_pryope
         SET feccom = SYSDATE + plazoins
       WHERE numslc = a_numslc;
    END IF;
  
    -- Se setea la F.Comp a todos los elementos del grupo
    FOR g IN cur_grp LOOP
      SELECT MIN(plazoins), MAX(plazoins)
        INTO minplaz, maxplaz
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1;
    
      SELECT MIN(feccom)
        INTO l_feccom
        FROM int_pryope
       WHERE numslc = a_numslc
         AND grupo = g.grupo
         AND valido = 1
         AND feccom IS NOT NULL;
    
      IF l_feccom IS NOT NULL THEN
        UPDATE int_pryope
           SET feccom = l_feccom
         WHERE numslc = a_numslc
           AND valido = 1
           AND grupo = g.grupo;
      END IF;
    END LOOP;
  
    -- Cod. Postal
    UPDATE int_pryope
       SET codpostal =
           (SELECT codpos
              FROM vtasuccli
             WHERE vtasuccli.codsuc = int_pryope.codsuc)
     WHERE numslc = a_numslc
       AND codsuc IS NOT NULL
       AND valido = 1;
  
    -- Se actualiza los Tipos de Instancia
    UPDATE int_pryope i
       SET tipinssrv =
           (SELECT p.idtipinstserv
              FROM producto p
             WHERE p.idproducto = i.idproducto)
     WHERE numslc = a_numslc
       AND valido = 1;
  
    SELECT COUNT(1)
      INTO l_cont
      FROM int_pryope
     WHERE numslc = a_numslc
       AND numpto = numpto_pri
       AND tipinssrv = 2
       AND valido = 1
       AND numpto_ori IS NULL
       AND numpto_des IS NULL
       AND codinssrv_ori IS NULL
       AND numpto_ori IS NULL;
  
    IF l_cont > 0 THEN
      raise_application_error(-20500,
                              'No se especifico Origen y Destino a una Instancia de Servicio de Tipo enlace. Proyecto: ' ||
                              a_numslc);
    END IF;
  
    -- el resto es por defecto ACCESO (Generico)
    UPDATE int_pryope
       SET tipinssrv = 1
     WHERE numslc = a_numslc
       AND numpto = numpto_pri
       AND tipinssrv IS NULL
       AND numpto_ori IS NULL
       AND numpto_des IS NULL
       AND codinssrv_ori IS NULL
       AND numpto_ori IS NULL
       AND valido = 1;
  
    -- TIPTRA -Proceso que determina cual es el tipo de la SOT
    FOR l IN cur_int LOOP
      IF l.pid_old IS NULL AND l.tiptra IS NULL THEN
        UPDATE int_pryope SET tiptra = i_tipo_ins WHERE ROWID = l.rowid;
      END IF;
    END LOOP;
  
    -- Agrupar por IS, todas las IS van en la misma SOT (Grupo)
    FOR c IN cur_is LOOP
      UPDATE int_pryope
         SET grupo = c.grupo
       WHERE numslc = a_numslc
         AND valido = 1
         AND codinssrv = c.codinssrv;
    END LOOP;
  
    -- Si alguno del grupo es de tipo upgrade todo es upgrade
    FOR g IN cur_grp LOOP
      SELECT COUNT(1)
        INTO l_cont
        FROM int_pryope
       WHERE numslc = a_numslc
         AND grupo = g.grupo
         AND valido = 1
         AND tiptra = i_tipo_upg;
    
      IF l_cont > 0 THEN
        UPDATE int_pryope
           SET tiptra = i_tipo_upg
         WHERE numslc = a_numslc
           AND valido = 1
           AND grupo = g.grupo;
      ELSE
        -- Si alguno del grupo es de tipo Downgrade todo es  Downgrade
        SELECT COUNT(1)
          INTO l_cont
          FROM int_pryope
         WHERE numslc = a_numslc
           AND grupo = g.grupo
           AND valido = 1
           AND tiptra = i_tipo_dow;
      
        IF l_cont > 0 THEN
          UPDATE int_pryope
             SET tiptra = i_tipo_dow
           WHERE numslc = a_numslc
             AND valido = 1
             AND grupo = g.grupo;
        END IF;
      END IF;
    
      -- agrupa las IS
      l_grupo    := g.grupo;
      l_subgrupo := 1;
    
      FOR s IN cur_subgrp LOOP
        UPDATE int_pryope
           SET subgrupo = l_subgrupo
         WHERE numslc = a_numslc
           AND valido = 1
           AND grupo = l_grupo
           AND numpto_pri = s.numpto_pri;
        l_subgrupo := l_subgrupo + 1;
      END LOOP;
    END LOOP;
  
    -- Si alguno del grupo es de tipo cambio de plan todos pasan a cambio de plan.
    -- REQ-96442: se agrego el upgrade/downgrade
    SELECT COUNT(1)
      INTO ln_count
      FROM regdetsrvmen
     WHERE flg_tipo_vm IN ('TE', 'TER', 'UDG', 'TIT', 'CN') --- 41.0  (se agrego tipo TIT/CN)
       AND numslc = a_numslc;
  
    IF ln_count > 0 THEN
      UPDATE vtadetptoenl SET grupo = 1 WHERE numslc = a_numslc;
      UPDATE int_pryope SET grupo = 1 WHERE numslc = a_numslc;
    END IF;
  
    -- Se multiplican los productos
    -- Validar Primero Servicio Cloud
    --<53.0 Ini>
    SELECT codigon
      INTO ln_valcloud
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd FROM tipopedd WHERE abrev = 'CLOUD')
       AND abreviacion = 'SWITCH';
  
    IF ln_valcloud <> 1 THEN
      FOR m IN cur_mult LOOP
        p_mult_int_pryope(m.idseq);
      END LOOP;
    ELSE
      SELECT tipsrv
        INTO lv_tipsrv
        FROM sales.vtatabslcfac
       WHERE numslc = a_numslc;
    
      SELECT COUNT(1)
        INTO ln_valcloud
        FROM opedd o, tipopedd t
       WHERE o.tipopedd = t.tipopedd
         AND t.abrev = 'CONFAC_CLOUD'
         AND o.codigoc = lv_tipsrv;
    
      IF ln_valcloud > 0 THEN
        FOR o IN cur_mult_prin LOOP
          p_mult_int_pryope_prin(o.idseq);
        END LOOP;
        FOR p IN cur_mult_adic LOOP
          p_mult_int_pryope_adc(p.idseq);
        END LOOP;
      ELSE
        FOR m IN cur_mult LOOP
          p_mult_int_pryope(m.idseq);
        END LOOP;
      END IF;
    
    END IF;
    --<53.0 Ini>
  END;

  /**********************************************************************
    Crea las instancias de servicio y de producto para el detalle del
    proyecto
  **********************************************************************/
  PROCEDURE p_crear_is_pry(a_numslc IN CHAR) IS
  
    CURSOR cur_ismst IS
      SELECT idseq, numslc
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND numpto = numpto_pri
         AND codinssrv_pad IS NULL
         AND idproducto IN
             (SELECT idproducto FROM producto WHERE flgismst = 1);
  
    CURSOR cur_det_is1 IS
      SELECT idseq, numslc, grupo, numpto_pri, subgrupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND numpto = numpto_pri
         AND codinssrv IS NULL
         AND tipinssrv <> 2;
  
    CURSOR cur_det_is2 IS
      SELECT idseq, numslc, grupo, subgrupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND numpto = numpto_pri
         AND codinssrv IS NULL
         AND tipinssrv = 2;
  
    CURSOR cur_det_ip IS
      SELECT idseq
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1;
    --and numpto <> numpto_pri;
  
    l_codinssrv inssrv.codinssrv%TYPE;
    l_pid       insprd.pid%TYPE;
    -- ini 37.0
    li_inscxc NUMBER(10);
    ls_paqcxc NUMBER(10);
    il_cnt_cr NUMBER;
    -- fin 37.0
    l_cont NUMBER;
  
  BEGIN
  
    -- Creacion de IS Maestra por Proyecto
    -- Solo se creara una IS Maestra por todo el proyecto
    SELECT COUNT(1)
      INTO l_cont
      FROM int_pryope
     WHERE numslc = a_numslc
       AND valido = 1
       AND numpto = numpto_pri
       AND codinssrv_pad IS NULL
       AND idproducto IN
           (SELECT idproducto FROM producto WHERE flgismst = 1);
  
    IF l_cont > 0 THEN
      FOR c IN cur_ismst LOOP
        p_crear_inssrv_pryope_mst(c.idseq, l_codinssrv);
      
        UPDATE int_pryope a
           SET codinssrv_pad = l_codinssrv
         WHERE a.numslc = c.numslc
           AND a.valido = 1
           AND a.numpto = a.numpto_pri
           AND a.codinssrv_pad IS NULL
           AND a.idproducto IN
               (SELECT idproducto FROM producto WHERE flgismst = 1);
        -- Se actualiza uno y se termina
        EXIT;
      END LOOP;
    END IF;
  
    -- Si se marca como off-net una IS entonces esta se marca como MT
    UPDATE inssrv
       SET campo1 = 'PENDIENTE'
     WHERE codinssrv IN (SELECT codinssrv
                           FROM int_pryope
                          WHERE numslc = a_numslc
                            AND valido = 1
                            AND on_net = 0);
  
    -- primero se crean todas las IS de Acceso
    FOR c IN cur_det_is1 LOOP
      p_crear_inssrv_pryope(c.idseq, l_codinssrv);
    
      UPDATE int_pryope a
         SET codinssrv = l_codinssrv
       WHERE a.numslc = c.numslc
         AND a.valido = 1
         AND a.grupo = c.grupo
         AND a.numpto_pri = c.numpto_pri
         AND a.subgrupo = c.subgrupo;
    
    END LOOP;
  
    -- se actualiza los SID de tipo enlace con los datos de SID ori y destino
    UPDATE int_pryope a
       SET codinssrv_ori =
           (SELECT b.codinssrv
              FROM int_pryope b
             WHERE b.numslc = a_numslc
               AND b.valido = 1
                  --and b.grupo = a.grupo
                  --and b.subgrupo = a.subgrupo
               AND b.numpto = a.numpto_ori
               AND rownum = 1)
     WHERE numslc = a_numslc
       AND tipinssrv = 2
       AND valido = 1
       AND codinssrv IS NULL
       AND codinssrv_ori IS NULL;
  
    UPDATE int_pryope a
       SET codinssrv_des =
           (SELECT b.codinssrv
              FROM int_pryope b
             WHERE b.numslc = a_numslc
               AND b.valido = 1
                  --and b.grupo = a.grupo
                  --and b.subgrupo = a.subgrupo
               AND b.numpto = a.numpto_des
               AND rownum = 1)
     WHERE numslc = a_numslc
       AND tipinssrv = 2
       AND valido = 1
       AND codinssrv IS NULL
       AND codinssrv_des IS NULL;
  
    -- Luego se crean todas las IS de enlace
    FOR c IN cur_det_is2 LOOP
      p_crear_inssrv_pryope(c.idseq, l_codinssrv);
    
      UPDATE int_pryope a
         SET codinssrv = l_codinssrv
       WHERE a.numslc = c.numslc
         AND a.valido = 1
         AND a.grupo = c.grupo
         AND a.subgrupo = c.subgrupo;
    END LOOP;
  
    -- se crean las Inst. Producto
    FOR c IN cur_det_ip LOOP
      p_crear_insprd_pryope(c.idseq, l_pid);
    END LOOP;
  
    --ini 37.0  Actualiza el numero de Proyecto y paquete
    SELECT COUNT(*)
      INTO il_cnt_cr
      FROM regvtamentab r, instancia_paquete_cambio ip
     WHERE r.numregistro = ip.numregistro
       AND ip.flg_tipo_vm = 'CR'
       AND r.numslc = a_numslc;
  
    IF il_cnt_cr > 0 THEN
      SELECT DISTINCT codinssrv, idpaq
        INTO li_inscxc, ls_paqcxc
        FROM int_pryope
       WHERE numslc = a_numslc;
    
      UPDATE inssrv
         SET numslc = a_numslc, idpaq = ls_paqcxc
       WHERE codinssrv = li_inscxc;
    END IF;
    -- fin 37.0
  END;

  /**********************************************************************************
    PROCEDIMIENTO QUE CREA VARIAS SOT EN BASE A LOS GRUPOS DETECTADOS EN EL PROYECTO
  ***********************************************************************************/
  PROCEDURE p_crear_solot_pryope(a_numslc IN CHAR,
                                 a_numpsp IN CHAR,
                                 a_idopc  IN CHAR,
                                 a_estado IN NUMBER,
                                 a_tipcon IN CHAR DEFAULT NULL) IS
  
    l_codsolot  NUMBER;
    ls_tipsrv   tystipsrv.tipsrv%TYPE;
    ln_num5     NUMBER;
    ln_num13    NUMBER; -- Cable satelital puerta a puerta
    r_solot     solot%ROWTYPE;
    r_det       int_pryope%ROWTYPE;
    l_tiptra    tiptrabajo.tiptra%TYPE;
    ln_solucion soluciones.idsolucion%TYPE; --<8.0>
    --ini 21.0
    ln_num_1 NUMBER;
    ln_num_2 NUMBER;
    --fin 21.0
    ln_num_3   NUMBER; --<40.0>
    ln_pid_ant NUMBER; --<40.0>
    ln_pid_new NUMBER; --<40.0>
    ln_num_4   NUMBER; --<41.0>
    ln_num_5   NUMBER; --<41.0>
    l_codmotot motot.codmotot%TYPE; --<41.0>
  
    --<INI 38.0>
    os_abreviatura solot.resumen%TYPE;
    on_error       NUMBER;
    os_desc        VARCHAR2(100);
    ls_numslc      vtatabslcfac.numslc%TYPE;
    --<FIN 38.0>
    --ini 58.0
    lv_observacion operacion.solot.observacion%TYPE;
    lv_correo      operacion.sgat_postv_proyecto_origen.prorv_correo%TYPE;
    lv_numero      operacion.sgat_postv_proyecto_origen.prorv_telfcontacto%TYPE;
    ln_tiptra_cp   NUMBER;
    --fin 58.0
    --INI V60.0
    ln_tiptra_in NUMBER;
    ln_tiptra_ex NUMBER;
    ln_tiptra_id NUMBER;
    --FIN V60.0
    ln_tiptra_pa NUMBER; --61.0
    CURSOR cur_grp IS
      SELECT DISTINCT grupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1;
  
  BEGIN
    --INI V60.0
    -- OBTIENE EL TIPO DE TRABAJO PARA TRASLADO INTERNO
    SELECT codigon
      INTO ln_tiptra_in
      FROM opedd o
     WHERE o.tipopedd =
           (SELECT tipopedd
              FROM operacion.tipopedd
             WHERE descripcion = 'HFC CE Transacciones Postventa'
               AND abrev = 'CEHFCPOST')
       AND abreviacion = 'CEHFC_TRSINT';
  
    -- OBTIENE EL TIPO DE TRABAJO PARA TRASLADO EXTERNO 
    SELECT codigon
      INTO ln_tiptra_ex
      FROM opedd o
     WHERE o.tipopedd =
           (SELECT tipopedd
              FROM operacion.tipopedd
             WHERE descripcion = 'HFC CE Transacciones Postventa'
               AND abrev = 'CEHFCPOST')
       AND abreviacion = 'CEHFC_TRSEXT';
  
    -- OBTIENE EL TIPO DE TRABAJO PARA INSTALACION DE DECOS       
    SELECT codigon
      INTO ln_tiptra_id
      FROM opedd o
     WHERE o.tipopedd =
           (SELECT tipopedd
              FROM operacion.tipopedd
             WHERE descripcion = 'HFC CE Transacciones Postventa'
               AND abrev = 'CEHFCPOST')
       AND abreviacion = 'CEHFC_INSDECO';
  
    -- OBTIENE EL TIPO DE TRABAJO PARA CAMBIO DE PLAN     
    SELECT codigon
      INTO ln_tiptra_cp
      FROM opedd o
     WHERE o.tipopedd =
           (SELECT tipopedd
              FROM operacion.tipopedd
             WHERE descripcion = 'HFC CE Transacciones Postventa'
               AND abrev = 'CEHFCPOST')
       AND abreviacion = 'CEHFC_CP';
  
    --FIN V60.0
  
    --INI 61.0
    -- OBTIENE EL TIPO DE TRABAJO PARA PUNTO ADICIONAL
    SELECT codigon
      INTO ln_tiptra_pa
      FROM opedd o
     WHERE o.tipopedd =
           (SELECT tipopedd
              FROM operacion.tipopedd
             WHERE descripcion = 'HFC CE Transacciones Postventa'
               AND abrev = 'CEHFCPOST')
       AND abreviacion = 'CEHFC_INSPTO';
    --FIN 61.0
  
    FOR s IN cur_grp LOOP
      l_codsolot := NULL;
      l_codmotot := NULL; -- 41.0
    
      -- Se obtiene los datos para una s
      SELECT *
        INTO r_det
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND grupo = s.grupo
         AND rownum = 1;
    
      -- se obtiene el tipo de servicio del proyecto
      SELECT tipsrv, idsolucion --18.0
        INTO ls_tipsrv, ln_solucion
        FROM vtatabslcfac
       WHERE numslc = a_numslc;
    
      -- se obtiene el tipo de trabajo asociado a la modalidad de venta
      SELECT decode(r_det.tiptra, NULL, 1, r_det.tiptra)
        INTO l_tiptra
        FROM dummy_ope;
    
      --<18.0
      BEGIN
        --configuracion de asignacion automatica tipo de trabajo x solucion
        --INSTALACION
        SELECT codigon
          INTO l_tiptra
          FROM opedd a, tipopedd b
         WHERE a.tipopedd = b.tipopedd
           AND b.abrev = 'INSTIPTRA'
           AND codigoc = to_char(ln_solucion);
      
        --ini 21.0
        --si la solucion esta registrado en instalacion entonces se comprueba si es cambio de plan
        SELECT COUNT(1)
          INTO ln_num_1
          FROM instancia_paquete_cambio a
         WHERE numslc = a_numslc;
      
        SELECT COUNT(1)
          INTO ln_num_2
          FROM regdetsrvmen a
         WHERE numslc = a_numslc;
      
        IF (ln_num_1 + ln_num_2) > 0 THEN
          --si es mayor a 0 es cambio de plan o traslados
          -- ini 40.0
          SELECT COUNT(1)
            INTO ln_num_3
            FROM instancia_paquete_cambio a
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'FI';
        
          --ini 41.0
          SELECT COUNT(1)
            INTO ln_num_4
            FROM regdetsrvmen
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'TIT';
        
          SELECT COUNT(1)
            INTO ln_num_5
            FROM regdetsrvmen
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'CN';
          --fin 41.0
        
          IF ln_num_3 > 0 THEN
            SELECT codigon
              INTO l_tiptra
              FROM opedd
             WHERE abreviacion = TRIM('TIPTRA_FID');
            -- ini 41.0
          ELSIF ln_num_4 > 0 THEN
            SELECT codigon, codigoc
              INTO l_tiptra, l_codmotot
              FROM crmdd
             WHERE abreviacion = TRIM('TIPTRA_ALT_TIT');
          ELSIF ln_num_5 > 0 THEN
            SELECT codigon, codigoc
              INTO l_tiptra, l_codmotot
              FROM crmdd
             WHERE abreviacion = TRIM('TIPTRA_ALT_NUM');
            -- fin 41.0
          ELSE
            p_crea_tiptra(a_numslc, s.grupo, l_tiptra);
          END IF;
          -- fin 40.0
        END IF;
        --fin 21.0
      
        -- Ini 59.0
        IF operacion.pkg_portabilidad.sgafun_portout_es_vtaalt(a_numslc) THEN
          p_crea_tiptra(a_numslc, s.grupo, l_tiptra);
        END IF;
        -- Fin 59.0
      
      EXCEPTION
        WHEN no_data_found THEN
          -- ini 40.0
          SELECT COUNT(1)
            INTO ln_num_3
            FROM instancia_paquete_cambio a
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'FI';
        
          --ini 41.0
          SELECT COUNT(1)
            INTO ln_num_4
            FROM regdetsrvmen
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'TIT';
        
          SELECT COUNT(1)
            INTO ln_num_5
            FROM regdetsrvmen
           WHERE numslc = a_numslc
             AND flg_tipo_vm = 'CN';
          --fin 41.0
        
          IF ln_num_3 > 0 THEN
            SELECT codigon
              INTO l_tiptra
              FROM opedd
             WHERE abreviacion = TRIM('TIPTRA_FID');
            -- ini 41.0
          ELSIF ln_num_4 > 0 THEN
            SELECT codigon, codigoc
              INTO l_tiptra, l_codmotot
              FROM crmdd
             WHERE abreviacion = TRIM('TIPTRA_ALT_TIT');
          ELSIF ln_num_5 > 0 THEN
            SELECT codigon, codigoc
              INTO l_tiptra, l_codmotot
              FROM crmdd
             WHERE abreviacion = TRIM('TIPTRA_ALT_NUM');
            -- fin 41.0
          ELSE
            p_crea_tiptra(a_numslc, s.grupo, l_tiptra); --<12.0>
          END IF;
          -- fin 40.0
      END; --18.0>
    
      r_solot.tiptra    := l_tiptra; --<12.0>
      r_solot.tipsrv    := ls_tipsrv; --<12.0>
      r_solot.codmotot  := l_codmotot; -- 41.0
      r_solot.estsol    := 10;
      r_solot.numslc    := r_det.numslc;
      r_solot.numpsp    := r_det.numpsp;
      r_solot.idopc     := r_det.idopc;
      r_solot.tipcon    := a_tipcon;
      r_solot.codcli    := r_det.codcli;
      r_solot.feccom    := r_det.feccom;
      r_solot.cliint    := r_det.cliint;
      r_solot.direccion := r_det.direccion; --<13.0>
      r_solot.codubi    := r_det.codubi; --<13.0>
    
      --<INI 38.0>
      ls_numslc := r_det.numslc;
      BEGIN
        operacion.pq_abrev.p_ejecuta_abreviatura(ls_numslc,
                                                 os_abreviatura,
                                                 on_error,
                                                 os_desc);
      EXCEPTION
        WHEN OTHERS THEN
          os_abreviatura := NULL;
      END;
      IF on_error <> 0 THEN
        r_solot.resumen := os_abreviatura;
      ELSE
        r_solot.resumen := NULL;
      END IF;
      --<FIN 38.0>
    
      --cambio 9.0: Primesys
      --Asigna responsable automaticamente
      BEGIN
        SELECT area, usuarioope.usuario
          INTO r_solot.arearesp, r_solot.usuarioresp
          FROM vtatabcli, customer_atention, usuarioope
         WHERE codcli = r_solot.codcli
           AND vtatabcli.codcli = customer_atention.customercode
           AND customer_atention.codccareuser = usuarioope.usuario;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
      -- Fin del cambio 9.0: Primesys
    
      BEGIN
        --ini 58.0
        IF l_tiptra IN
           (ln_tiptra_in, ln_tiptra_ex, ln_tiptra_id, ln_tiptra_cp, ln_tiptra_pa) THEN  --62.0 
          SELECT a.prorv_anotacion,
                 a.prorv_cod_motivo,
                 a.prorv_telfcontacto,
                 a.prorv_correo
            INTO lv_observacion, r_solot.codmotot, lv_numero, lv_correo
            FROM operacion.sgat_postv_proyecto_origen a
           WHERE a.prorv_numslc_new = ls_numslc;
        
          IF lv_numero IS NOT NULL THEN
            lv_numero := chr(10) || lv_numero;
          END IF;
          IF lv_correo IS NOT NULL THEN
            lv_correo := chr(10) || lv_correo;
          END IF;
          r_solot.observacion := lv_observacion || lv_numero || lv_correo;
        ELSE
          --fin 58.0    
          SELECT vtatabpspcli.obsaprofe
            INTO r_solot.observacion
            FROM vtatabpspcli
           WHERE numpsp = a_numpsp
             AND idopc = a_idopc;
        END IF;
      EXCEPTION
        WHEN no_data_found THEN
          NULL;
      END;
    
      IF r_solot.observacion IS NULL THEN
        BEGIN
          SELECT vtatabslcfac.obssolfac
            INTO r_solot.observacion
            FROM vtatabslcfac
           WHERE numslc = a_numslc;
        EXCEPTION
          WHEN no_data_found THEN
            NULL;
        END;
      END IF;
    
      pq_solot.p_insert_solot(r_solot, l_codsolot);
    
      -- Ini 51.0
      -- Agendamiento ETAdirect
      sales.pkg_etadirect.registrar_agendamiento(l_codsolot,
                                                 r_solot.numslc);
      -- Fin 51.0
    
      -- Se asigna las SOLOT
      UPDATE int_pryope
         SET codsolot = l_codsolot
       WHERE numslc = a_numslc
         AND grupo = s.grupo
         AND valido = 1;
    
      -- ini 40.0 se asigna la SOT a la fidelizacion
      IF ln_num_3 > 0 THEN
        SELECT pid
          INTO ln_pid_ant
          FROM billcolper.fidelizacion
         WHERE numslc = a_numslc
           AND estado = 1;
      
        SELECT pid
          INTO ln_pid_new
          FROM int_pryope
         WHERE codsolot = l_codsolot
           AND pid_old = ln_pid_ant;
      
        UPDATE billcolper.fidelizacion
           SET codsolot = l_codsolot, pid = ln_pid_new
         WHERE numslc = a_numslc
           AND estado = 1;
      
      END IF;
      -- fin 40.0
    
      -- Se le asigna la SOT en reginsdth
      IF ln_num5 > 0 THEN
        UPDATE reginsdth SET codsolot = l_codsolot WHERE numslc = a_numslc;
      END IF;
    
      IF ln_num13 > 0 THEN
        UPDATE reginsdth SET codsolot = l_codsolot WHERE numslc = a_numslc;
      END IF;
    
      p_crear_solotpto_pryope(a_numslc, l_codsolot);
    
      pq_solot.p_crear_trssolot(0, NULL, a_numslc, a_numpsp, a_idopc);
    
      -- ini 41.0 generacion de Baja por cambio de Titularidad
      IF ln_num_4 > 0 THEN
        operacion.pq_solot.p_gen_sot_baja(l_codsolot, 'TIPTRA_BAJ_TIT');
      ELSIF ln_num_5 > 0 THEN
        operacion.pq_solot.p_gen_sot_baja(l_codsolot, 'TIPTRA_BAJ_NUM');
      END IF;
      -- fin 41.0
      --if ( ln_num_4 = 0 and ln_num_5 = 0 ) then  --42.0
      IF a_estado <> 10 THEN
        pq_solot.p_chg_estado_solot(l_codsolot, a_estado);
      END IF;
      --end if;                                    --42.0
    END LOOP;
  
  END p_crear_solot_pryope;

  /**********************************************************************
    Crea un SID desde un numero de proyecto y numpto
  **********************************************************************/
  PROCEDURE p_crear_inssrv_pryope(a_idseq     IN NUMBER,
                                  a_codinssrv OUT NUMBER) IS
  
    r_det         int_pryope%ROWTYPE;
    r_inssrv      inssrv%ROWTYPE;
    l_codinssrv   inssrv.codinssrv%TYPE;
    ls_num        VARCHAR2(20); --25.0
    ls_telefonom2 sales.int_vtacliente_aux.telefonom2%TYPE; -- 27.0
  
  BEGIN
    SELECT *
      INTO r_det
      FROM int_pryope
     WHERE idseq = a_idseq
       AND valido = 1;
  
    -- se crea el SID solosi no existe
    IF r_det.codinssrv IS NOT NULL THEN
      l_codinssrv := r_det.codinssrv;
    ELSE
    
      IF r_det.tipinssrv IS NULL THEN
        raise_application_error(-20500,
                                'No se determino el TIPINSSRV registro:' ||
                                r_det.idseq);
      END IF;
    
      r_inssrv.codcli      := r_det.codcli;
      r_inssrv.codsrv      := r_det.codsrv;
      r_inssrv.estinssrv   := 4;
      r_inssrv.tipinssrv   := r_det.tipinssrv;
      r_inssrv.descripcion := r_det.descripcion;
      r_inssrv.direccion   := r_det.direccion;
      --Ini 25.0
      --Validando si viene por venta normal/webuni o por SISACT
      /*r_inssrv.numero :=  null;*/
      IF sales.pq_dth_postventa.f_obt_facturable_dth(r_det.numslc) = 1 THEN
        BEGIN
          SELECT v.telefonom2
            INTO ls_num
            FROM int_vtacliente_aux v, int_vtaregventa_aux t
           WHERE v.idlote = t.idlote
             AND t.o_numslc = r_det.numslc;
          r_inssrv.numero := ls_num;
          --<35.0
          BEGIN
            r_inssrv.numsec := to_number(ls_num);
          EXCEPTION
            WHEN OTHERS THEN
              r_inssrv.numsec := NULL;
          END;
          --35.0>
        EXCEPTION
          --Mientras no se bloquee por SGA no utilizar idsolucion PostPago DTH
          WHEN OTHERS THEN
            r_inssrv.numero := NULL;
        END;
        -- Inicio 55.0
      ELSIF sales.pkg_preseleccion.sgafun_tipsrv_tfi(r_det.numslc, NULL) THEN
        r_inssrv.numero := sales.pkg_preseleccion.sgafun_obtiene_numero_portable(r_det.numslc);
        -- Fin 55.0
      ELSE
        r_inssrv.numero := NULL;
      END IF;
      --Fin 25.0
      -- ini 27.0
      IF sales.pq_dth_postventa.f_is_hfc(r_det.numslc) = 1 THEN
        BEGIN
          SELECT v.telefonom2
            INTO ls_telefonom2
            FROM sales.int_vtacliente_aux v, sales.int_vtaregventa_aux t
           WHERE v.idlote = t.idlote
             AND t.o_numslc = r_det.numslc;
          r_inssrv.numsec := to_number(ls_telefonom2);
        EXCEPTION
          WHEN OTHERS THEN
            r_inssrv.numsec := NULL;
        END;
        --ELSE
        --r_inssrv.numsec :=  NULL; 38.0
      END IF;
      -- fin 27.0
      r_inssrv.codsuc        := r_det.codsuc;
      r_inssrv.bw            := r_det.bw;
      r_inssrv.numslc        := r_det.numslc;
      r_inssrv.numpto        := r_det.numpto;
      r_inssrv.codubi        := r_det.codubi;
      r_inssrv.tipsrv        := r_det.tipsrv;
      r_inssrv.codinssrv_ori := r_det.codinssrv_ori;
      r_inssrv.codinssrv_des := r_det.codinssrv_des;
      r_inssrv.codinssrv_pad := r_det.codinssrv_pad;
      r_inssrv.codpostal     := r_det.codpostal;
      r_inssrv.idpaq         := r_det.idpaq;
      r_inssrv.idplataforma  := r_det.idplataforma; --<22.0>
    
      SELECT decode(r_det.on_net, 0, 'PENDIENTE', NULL)
        INTO r_inssrv.campo1
        FROM dummy_ope;
    
      pq_inssrv.p_insert_inssrv(r_inssrv, l_codinssrv);
      pq_inssrv.p_insert_inssrvsla(l_codinssrv, r_det.idinssla); --cambio 9.0
    
    END IF;
    a_codinssrv := l_codinssrv;
  END;

  /**********************************************************************
    Crea una IS Maestra desde un numero de proyecto y numpto
  **********************************************************************/
  PROCEDURE p_crear_inssrv_pryope_mst(a_idseq     IN NUMBER,
                                      a_codinssrv OUT NUMBER) IS
  
    r_det         int_pryope%ROWTYPE;
    r_inssrv      inssrv%ROWTYPE;
    l_codinssrv   inssrv.codinssrv%TYPE;
    ls_num        VARCHAR2(20); --25.0
    ls_telefonom2 sales.int_vtacliente_aux.telefonom2%TYPE; -- 27.0
  
  BEGIN
    SELECT *
      INTO r_det
      FROM int_pryope
     WHERE idseq = a_idseq
       AND valido = 1;
  
    -- se crea el SID solosi no existe
    IF r_det.codinssrv_pad IS NOT NULL THEN
      l_codinssrv := r_det.codinssrv;
    ELSE
    
      r_inssrv.codcli      := r_det.codcli;
      r_inssrv.codsrv      := r_det.codsrv;
      r_inssrv.estinssrv   := 4;
      r_inssrv.tipinssrv   := 4; -- Tipo IS Maestra
      r_inssrv.descripcion := r_det.descripcion;
      r_inssrv.direccion   := r_det.direccion;
      --Ini 25.0
      --Validando si viene por venta normal/webuni o por SISACT
      /*r_inssrv.numero :=  null;*/
      IF sales.pq_dth_postventa.f_obt_facturable_dth(r_det.numslc) = 1 THEN
        BEGIN
          SELECT v.telefonom2
            INTO ls_num
            FROM int_vtacliente_aux v, int_vtaregventa_aux t
           WHERE v.idlote = t.idlote
             AND t.o_numslc = r_det.numslc;
          r_inssrv.numero := ls_num;
          --<35.0
          BEGIN
            r_inssrv.numsec := to_number(ls_num);
          EXCEPTION
            WHEN OTHERS THEN
              r_inssrv.numsec := NULL;
          END;
          --35.0>
        EXCEPTION
          --Mientras no se bloquee por SGA no utilizar idsolucion PostPago DTH
          WHEN OTHERS THEN
            r_inssrv.numero := NULL;
        END;
        -- else
        --r_inssrv.numero :=  null; --38.0
      END IF;
      --Fin 25.0
      -- ini 27.0
      IF sales.pq_dth_postventa.f_is_hfc(r_det.numslc) = 1 THEN
        BEGIN
          SELECT v.telefonom2
            INTO ls_telefonom2
            FROM sales.int_vtacliente_aux v, sales.int_vtaregventa_aux t
           WHERE v.idlote = t.idlote
             AND t.o_numslc = r_det.numslc;
        EXCEPTION
          WHEN OTHERS THEN
            r_inssrv.numsec := NULL;
        END;
      ELSE
        r_inssrv.numsec := NULL;
      END IF;
      -- fin 27.0
      r_inssrv.codsuc        := r_det.codsuc;
      r_inssrv.bw            := r_det.bw;
      r_inssrv.numslc        := r_det.numslc;
      r_inssrv.numpto        := r_det.numpto;
      r_inssrv.codubi        := r_det.codubi;
      r_inssrv.tipsrv        := r_det.tipsrv;
      r_inssrv.codinssrv_ori := NULL;
      r_inssrv.codinssrv_des := NULL;
      r_inssrv.codpostal     := r_det.codpostal;
      r_inssrv.idpaq         := r_det.idpaq;
      r_inssrv.idplataforma  := r_det.idplataforma; --<22.0>
    
      SELECT decode(r_det.on_net, 0, 'PENDIENTE', NULL)
        INTO r_inssrv.campo1
        FROM dummy_ope;
    
      pq_inssrv.p_insert_inssrv(r_inssrv, l_codinssrv);
      pq_inssrv.p_insert_inssrvsla(l_codinssrv, r_det.idinssla); --cambio 9.0
    
    END IF;
    a_codinssrv := l_codinssrv;
  END;

  /**********************************************************************
    Crea un PID desde un numero de proyecto y numpto
  **********************************************************************/
  PROCEDURE p_crear_insprd_pryope(a_idseq IN NUMBER, a_pid OUT NUMBER) IS
  
    r_det    int_pryope%ROWTYPE;
    r_insprd insprd%ROWTYPE;
    l_pid    insprd.pid%TYPE;
    l_princ  NUMBER(1);
    l_flg    NUMBER(1);
    l_cont   NUMBER;
  
  BEGIN
  
    SELECT *
      INTO r_det
      FROM int_pryope
     WHERE idseq = a_idseq
       AND valido = 1;
  
    -- se crea el SID solo si no existe
    IF r_det.pid IS NOT NULL THEN
      l_pid := r_det.pid;
    ELSE
    
      IF r_det.codinssrv IS NULL THEN
        raise_application_error(-20500,
                                'Registro no esta asociado a una Instancia de Servicio ' ||
                                r_det.idseq || ' numpto ' || r_det.numpto ||
                                ' numpto_pri ' || r_det.numpto_pri);
      END IF;
    
      r_insprd.descripcion  := r_det.descripcion;
      r_insprd.estinsprd    := 4;
      r_insprd.codsrv       := r_det.codsrv;
      r_insprd.codequcom    := r_det.codequcom;
      r_insprd.codinssrv    := r_det.codinssrv;
      r_insprd.cantidad     := r_det.cantidad;
      r_insprd.iddet        := r_det.iddet;
      r_insprd.idplataforma := r_det.idplataforma; --<22.0>
    
      l_princ := 0;
    
      IF r_det.numpto_pri = r_det.numpto THEN
        IF r_det.pid_old IS NOT NULL THEN
          SELECT flgprinc INTO l_flg FROM insprd WHERE pid = r_det.pid_old;
          IF l_flg = 1 THEN
            -- Si reemplaza a un producto principal => Es principal
            l_princ := 1;
          END IF;
        ELSE
          -- Para crear la Primera IP Principal
          SELECT COUNT(1)
            INTO l_cont
            FROM insprd
           WHERE codinssrv = r_insprd.codinssrv
             AND flgprinc = 1;
          IF l_cont = 0 THEN
            l_princ := 1;
          END IF;
        END IF;
      END IF;
    
      r_insprd.flgprinc := l_princ;
      r_insprd.numslc   := r_det.numslc;
      r_insprd.numpto   := r_det.numpto;
    
      IF r_det.tipcon = 'C' THEN
        r_insprd.tipcon := 0;
      ELSE
        r_insprd.tipcon := 1;
      END IF;
    
      pq_inssrv.p_insert_insprd(r_insprd, l_pid);
      pq_inssrv.p_insert_insprdsla(l_pid, r_det.idinssla); --cambio 9.0
    
      UPDATE int_pryope a SET pid = l_pid WHERE idseq = r_det.idseq;
    
    END IF;
  
    a_pid := l_pid;
  
  END;

  /**********************************************************************
    Crea varias SOT en base a los grupos detectados en el
    proyecto
  **********************************************************************/
  PROCEDURE p_crear_solotpto_pryope(a_numslc IN CHAR, a_codsolot IN NUMBER) IS
  
    r_solotpto solotpto%ROWTYPE;
    l_punto    solotpto.punto%TYPE;
    r_inssrv   inssrv%ROWTYPE;
    r_cnt_tit  NUMBER; --<41.0>
    l_feccorte DATE; --<41.0>
  
    CURSOR cur_det IS
      SELECT codsolot,
             punto,
             tiptrs,
             codsrv,
             bw,
             codinssrv,
             codubired,
             descripcion,
             direccion,
             codubi,
             numpto,
             pid,
             pid_old,
             cantidad,
             codinssrv_tra,
             on_net,
             codpostal,
             idplataforma --<22.0>
        FROM int_pryope
       WHERE numslc = a_numslc
         AND codsolot = a_codsolot
         AND valido = 1;
  
    CURSOR cur_is_pad IS
      SELECT DISTINCT codinssrv_pad codinssrv
        FROM int_pryope
       WHERE numslc = a_numslc
         AND codsolot = a_codsolot
         AND codinssrv_pad IS NOT NULL
         AND valido = 1;
  
  BEGIN
  
    FOR r_det IN cur_is_pad LOOP
      -- ini 41.0
      BEGIN
        SELECT COUNT(1)
          INTO r_cnt_tit
          FROM regdetsrvmen
         WHERE numslc = a_numslc
           AND flg_tipo_vm = 'TIT';
      
        IF r_cnt_tit > 0 THEN
        
          SELECT feccorte
            INTO l_feccorte
            FROM regvtamentab
           WHERE numslc = a_numslc;
        
          r_solotpto.fecinisrv := l_feccorte;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          r_cnt_tit := 0;
      END;
      -- fin 41.0
    
      SELECT * INTO r_inssrv FROM inssrv WHERE codinssrv = r_det.codinssrv;
    
      r_solotpto.codsolot     := a_codsolot;
      r_solotpto.tiptrs       := NULL;
      r_solotpto.codsrvnue    := r_inssrv.codsrv;
      r_solotpto.bwnue        := r_inssrv.bw;
      r_solotpto.codinssrv    := r_det.codinssrv;
      r_solotpto.cid          := r_inssrv.cid;
      r_solotpto.descripcion  := r_inssrv.descripcion;
      r_solotpto.direccion    := r_inssrv.direccion;
      r_solotpto.tipo         := 2;
      r_solotpto.estado       := 1;
      r_solotpto.visible      := 1;
      r_solotpto.codubi       := r_inssrv.codubi;
      r_solotpto.pid          := NULL;
      r_solotpto.codpostal    := r_inssrv.codpostal;
      r_solotpto.idplataforma := r_inssrv.idplataforma; --<22.0>
    
      pq_solot.p_insert_solotpto(r_solotpto, l_punto);
    
    END LOOP;
  
    FOR r_det IN cur_det LOOP
    
      -- ini 41.0
      BEGIN
        SELECT COUNT(1)
          INTO r_cnt_tit
          FROM regdetsrvmen
         WHERE numslc = a_numslc
           AND flg_tipo_vm = 'TIT';
        IF r_cnt_tit > 0 THEN
          SELECT feccorte
            INTO l_feccorte
            FROM regvtamentab
           WHERE numslc = a_numslc;
          r_solotpto.fecinisrv := l_feccorte;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          r_cnt_tit := 0;
      END;
      -- fin 41.0
    
      r_solotpto.codsolot      := r_det.codsolot;
      r_solotpto.tiptrs        := r_det.tiptrs;
      r_solotpto.codsrvnue     := r_det.codsrv;
      r_solotpto.bwnue         := r_det.bw;
      r_solotpto.codinssrv     := r_det.codinssrv;
      r_solotpto.pop           := r_det.codubired;
      r_solotpto.descripcion   := r_det.descripcion;
      r_solotpto.direccion     := r_det.direccion;
      r_solotpto.tipo          := 1;
      r_solotpto.estado        := 1;
      r_solotpto.visible       := 1;
      r_solotpto.codubi        := r_det.codubi;
      r_solotpto.efpto         := to_number(r_det.numpto);
      r_solotpto.pid           := r_det.pid;
      r_solotpto.pid_old       := r_det.pid_old;
      r_solotpto.cantidad      := r_det.cantidad;
      r_solotpto.codinssrv_tra := r_det.codinssrv_tra;
      r_solotpto.idplataforma  := r_det.idplataforma; --<22.0>
    
      SELECT decode(r_det.on_net, 0, 1, 0)
        INTO r_solotpto.flgmt
        FROM dummy_ope;
    
      r_solotpto.codpostal := r_det.codpostal;
    
      pq_solot.p_insert_solotpto(r_solotpto, l_punto);
    END LOOP;
  
  END;

  /*****************************************************************************************
    Ejecuta la agrupacion de los detalles del proyecto en grupos
    para poder generar SOT, segun logica del negocio de Brasil
  *****************************************************************************************/
  PROCEDURE p_agrupar_vtadetptoenl(a_numslc IN CHAR) IS
  
    CURSOR cursor_detalle IS
      SELECT a.rowid FROM vtadetptoenl a WHERE a.numslc = a_numslc;
  
    CURSOR cur_enl IS
      SELECT d.numpto_orig,
             d.numpto_dest,
             d.codinssrv_orig,
             d.codinssrv_dest,
             d.grupo
        FROM vtadetptoenl d, producto p
       WHERE d.idproducto = p.idproducto
         AND d.numslc = a_numslc
         AND p.flgenlprc = 1
         AND (d.numpto_orig IS NOT NULL OR d.numpto_dest IS NOT NULL OR
             d.codinssrv_orig IS NOT NULL OR d.codinssrv_dest IS NOT NULL);
  
    CURSOR cur_enl_is IS
      SELECT d.codinssrv, d.grupo, i.codinssrv_ori, i.codinssrv_des
        FROM vtadetptoenl d, producto p, inssrv i, tystabsrv s
       WHERE d.idproducto = p.idproducto
         AND d.codinssrv = i.codinssrv
         AND i.codsrv = s.codsrv
         AND s.idproducto = p.idproducto
         AND d.numslc = a_numslc
         AND p.flgenlprc = 1
         AND i.tipinssrv = 2;
  
    CURSOR cur_explo IS
      SELECT MIN(ve.grupo) grupo, ip.idinsxpaq
        FROM vtadetptoenl ve, instancia_paquete ip
       WHERE ve.numslc = a_numslc
         AND ve.idinsxpaq = ip.idinsxpaq
         AND ve.numpto = ip.numpto
       GROUP BY ip.idinsxpaq;
  
    l_grup NUMBER;
    ln_num NUMBER;
    l_grp  NUMBER;
  
  BEGIN
  
    UPDATE vtadetptoenl d
       SET idproducto =
           (SELECT idproducto FROM tystabsrv t WHERE t.codsrv = d.codsrv)
     WHERE numslc = a_numslc
       AND idproducto IS NULL;
  
    -- Se agrupa por paquetes
    FOR r IN cursor_detalle LOOP
      UPDATE vtadetptoenl SET grupo = paquete WHERE ROWID = r.rowid;
    END LOOP;
  
    -- Se busca por enlaces que sean del tipo PLS, PRODUCTO:FLGENLPRC
    FOR c IN cur_enl LOOP
      IF c.numpto_orig IS NOT NULL THEN
        SELECT grupo
          INTO l_grp
          FROM vtadetptoenl
         WHERE numslc = a_numslc
           AND numpto = c.numpto_orig;
        UPDATE vtadetptoenl
           SET grupo = c.grupo
         WHERE numslc = a_numslc
           AND grupo = l_grp;
      END IF;
    
      IF c.numpto_dest IS NOT NULL THEN
        SELECT grupo
          INTO l_grp
          FROM vtadetptoenl
         WHERE numslc = a_numslc
           AND numpto = c.numpto_dest;
        UPDATE vtadetptoenl
           SET grupo = c.grupo
         WHERE numslc = a_numslc
           AND grupo = l_grp;
      END IF;
    
    END LOOP;
  
    -- Se busca por enlaces que sean del tipo PLS, PRODUCTO:FLGENLPRC
    -- Pero para las IS de upgrade
    FOR c IN cur_enl_is LOOP
      IF c.codinssrv_ori IS NOT NULL THEN
        BEGIN
          SELECT grupo
            INTO l_grp
            FROM vtadetptoenl
           WHERE numslc = a_numslc
             AND codinssrv = c.codinssrv_ori
             AND rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            l_grp := NULL;
        END;
        IF l_grp IS NOT NULL THEN
          UPDATE vtadetptoenl
             SET grupo = c.grupo
           WHERE numslc = a_numslc
             AND grupo = l_grp;
        END IF;
      END IF;
    
      IF c.codinssrv_des IS NOT NULL THEN
        BEGIN
          SELECT grupo
            INTO l_grp
            FROM vtadetptoenl
           WHERE numslc = a_numslc
             AND codinssrv = c.codinssrv_des
             AND rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            l_grp := NULL;
        END;
        IF l_grp IS NOT NULL THEN
          UPDATE vtadetptoenl
             SET grupo = c.grupo
           WHERE numslc = a_numslc
             AND grupo = l_grp;
        END IF;
      END IF;
    
    END LOOP;
  
    --Agrupa los puntos del detalle por paquete explora
    l_grup := 0;
  
    FOR cur_ex IN cur_explo LOOP
      l_grup := l_grup + 1;
      UPDATE vtadetptoenl
         SET grupo = l_grup
       WHERE numslc = a_numslc
         AND idinsxpaq = cur_ex.idinsxpaq;
    END LOOP;
  
    --Agrupa los puntos del detalle por paquete tpi
    l_grup := 1;
    SELECT COUNT(1)
      INTO ln_num
      FROM proyecto_tpi a, vtadetptoenl b
     WHERE a.numslc = b.numslc
       AND a.numslc = a_numslc;
    IF ln_num > 0 THEN
      UPDATE vtadetptoenl SET grupo = l_grup WHERE numslc = a_numslc;
    END IF;
  
  END;

  /********************************************************
    Multiplica una linea de la interface X la cantidad
  *********************************************************/
  PROCEDURE p_mult_int_pryope(a_idseq IN NUMBER) IS
    r_int_pryope int_pryope%ROWTYPE;
    r_int        int_pryope%ROWTYPE;
    l_subgrupo   NUMBER;
    i            NUMBER;
    l_num        NUMBER;
  
    CURSOR cur_subgrp IS
      SELECT numslc,
             numpto,
             grupo,
             numpto_pri,
             codsolot,
             punto,
             numpsp,
             idopc,
             descripcion,
             direccion,
             codubi,
             codsrv,
             codequcom,
             bw,
             codsuc,
             on_net,
             codinssrv,
             pid,
             pid_old,
             tipsrv,
             idproducto,
             tipinssrv,
             tiptra,
             tiptrs,
             codcli,
             codinssrv_tra,
             codinssrv_des,
             codinssrv_ori,
             numpto_ori,
             numpto_des,
             feccom,
             codpostal,
             codinssrv_pad,
             codubired,
             plazoins,
             cliint,
             tipcon,
             idpaq,
             iddet,
             idplataforma --<22.0>
        FROM int_pryope
       WHERE numslc = r_int.numslc
         AND valido = 2
         AND grupo = r_int.grupo
         AND subgrupo = r_int.subgrupo;
  
  BEGIN
  
    SELECT * INTO r_int FROM int_pryope WHERE idseq = a_idseq;
    l_num := r_int.cantidad;
  
    UPDATE int_pryope
       SET valido = 2
     WHERE numslc = r_int.numslc
       AND valido = 1
       AND grupo = r_int.grupo
       AND subgrupo = r_int.subgrupo;
  
    l_subgrupo := 1;
    FOR i IN 1 .. l_num LOOP
      FOR r_int_pryope IN cur_subgrp LOOP
        INSERT INTO int_pryope
          (valido,
           numslc,
           numpto,
           grupo,
           subgrupo,
           numpto_pri,
           codsolot,
           punto,
           numpsp,
           idopc,
           descripcion,
           direccion,
           codubi,
           codsrv,
           codequcom,
           bw,
           codsuc,
           on_net,
           codinssrv,
           pid,
           pid_old,
           tipsrv,
           idproducto,
           tipinssrv,
           tiptra,
           tiptrs,
           codcli,
           cantidad,
           codinssrv_tra,
           codinssrv_des,
           codinssrv_ori,
           numpto_ori,
           numpto_des,
           feccom,
           codpostal,
           codinssrv_pad,
           codubired,
           plazoins,
           cliint,
           tipcon,
           idpaq,
           iddet,
           idplataforma --<22.0>
           )
        VALUES
          (1,
           r_int_pryope.numslc,
           r_int_pryope.numpto,
           r_int_pryope.grupo,
           l_subgrupo, -- Nuevo subgrupo
           r_int_pryope.numpto_pri,
           r_int_pryope.codsolot,
           r_int_pryope.punto,
           r_int_pryope.numpsp,
           r_int_pryope.idopc,
           r_int_pryope.descripcion,
           r_int_pryope.direccion,
           r_int_pryope.codubi,
           r_int_pryope.codsrv,
           r_int_pryope.codequcom,
           r_int_pryope.bw,
           r_int_pryope.codsuc,
           r_int_pryope.on_net,
           r_int_pryope.codinssrv,
           r_int_pryope.pid,
           r_int_pryope.pid_old,
           r_int_pryope.tipsrv,
           r_int_pryope.idproducto,
           r_int_pryope.tipinssrv,
           r_int_pryope.tiptra,
           r_int_pryope.tiptrs,
           r_int_pryope.codcli,
           1, /*r_int_pryope.cantidad,*/
           r_int_pryope.codinssrv_tra,
           r_int_pryope.codinssrv_des,
           r_int_pryope.codinssrv_ori,
           r_int_pryope.numpto_ori,
           r_int_pryope.numpto_des,
           r_int_pryope.feccom,
           r_int_pryope.codpostal,
           r_int_pryope.codinssrv_pad,
           r_int_pryope.codubired,
           r_int_pryope.plazoins,
           r_int_pryope.cliint,
           r_int_pryope.tipcon,
           r_int_pryope.idpaq,
           r_int_pryope.iddet,
           r_int_pryope.idplataforma --<22.0>
           );
      END LOOP;
      l_subgrupo := l_subgrupo + 1;
    END LOOP;
  END;
  /********************************************************
    Multiplica una linea de la interface X la cantidad para Servicios Principales
  *********************************************************/
  PROCEDURE p_mult_int_pryope_prin(a_idseq IN NUMBER) IS
    r_int_pryope int_pryope%ROWTYPE;
    r_int        int_pryope%ROWTYPE;
    l_subgrupo   NUMBER;
    i            NUMBER;
    l_num        NUMBER;
  
    CURSOR cur_subgrp IS
      SELECT numslc,
             numpto,
             grupo,
             numpto_pri,
             codsolot,
             punto,
             numpsp,
             idopc,
             descripcion,
             direccion,
             codubi,
             codsrv,
             codequcom,
             bw,
             codsuc,
             on_net,
             codinssrv,
             pid,
             pid_old,
             tipsrv,
             idproducto,
             tipinssrv,
             tiptra,
             tiptrs,
             codcli,
             codinssrv_tra,
             codinssrv_des,
             codinssrv_ori,
             numpto_ori,
             numpto_des,
             feccom,
             codpostal,
             codinssrv_pad,
             codubired,
             plazoins,
             cliint,
             tipcon,
             idpaq,
             iddet,
             idplataforma --<22.0>
        FROM int_pryope
       WHERE numslc = r_int.numslc
         AND valido = 2
         AND grupo = r_int.grupo
         AND subgrupo = r_int.subgrupo
         AND numpto = numpto_pri;
  BEGIN
  
    SELECT *
      INTO r_int
      FROM int_pryope
     WHERE idseq = a_idseq
       AND numpto = numpto_pri;
    l_num := r_int.cantidad;
  
    UPDATE int_pryope
       SET valido = 2
     WHERE numslc = r_int.numslc
       AND valido = 1
       AND grupo = r_int.grupo
       AND subgrupo = r_int.subgrupo
       AND idseq = a_idseq
       AND numpto = numpto_pri;
  
    l_subgrupo := 1;
    FOR i IN 1 .. l_num LOOP
      FOR r_int_pryope IN cur_subgrp LOOP
      
        --i_numpto            := i_numpto + 1;
        --r_int_pryope.numpto := lpad(to_char(i_numpto), 5, '0');
      
        INSERT INTO int_pryope
          (valido,
           numslc,
           numpto,
           grupo,
           subgrupo,
           numpto_pri,
           codsolot,
           punto,
           numpsp,
           idopc,
           descripcion,
           direccion,
           codubi,
           codsrv,
           codequcom,
           bw,
           codsuc,
           on_net,
           codinssrv,
           pid,
           pid_old,
           tipsrv,
           idproducto,
           tipinssrv,
           tiptra,
           tiptrs,
           codcli,
           cantidad,
           codinssrv_tra,
           codinssrv_des,
           codinssrv_ori,
           numpto_ori,
           numpto_des,
           feccom,
           codpostal,
           codinssrv_pad,
           codubired,
           plazoins,
           cliint,
           tipcon,
           idpaq,
           iddet,
           idplataforma --<22.0>
           )
        VALUES
          (1,
           r_int_pryope.numslc,
           r_int_pryope.numpto,
           r_int_pryope.grupo,
           l_subgrupo, -- Nuevo subgrupo
           r_int_pryope.numpto_pri,
           r_int_pryope.codsolot,
           r_int_pryope.punto,
           r_int_pryope.numpsp,
           r_int_pryope.idopc,
           r_int_pryope.descripcion,
           r_int_pryope.direccion,
           r_int_pryope.codubi,
           r_int_pryope.codsrv,
           r_int_pryope.codequcom,
           r_int_pryope.bw,
           r_int_pryope.codsuc,
           r_int_pryope.on_net,
           r_int_pryope.codinssrv,
           r_int_pryope.pid,
           r_int_pryope.pid_old,
           r_int_pryope.tipsrv,
           r_int_pryope.idproducto,
           r_int_pryope.tipinssrv,
           r_int_pryope.tiptra,
           r_int_pryope.tiptrs,
           r_int_pryope.codcli,
           1, /*r_int_pryope.cantidad,*/
           r_int_pryope.codinssrv_tra,
           r_int_pryope.codinssrv_des,
           r_int_pryope.codinssrv_ori,
           r_int_pryope.numpto_ori,
           r_int_pryope.numpto_des,
           r_int_pryope.feccom,
           r_int_pryope.codpostal,
           r_int_pryope.codinssrv_pad,
           r_int_pryope.codubired,
           r_int_pryope.plazoins,
           r_int_pryope.cliint,
           r_int_pryope.tipcon,
           r_int_pryope.idpaq,
           r_int_pryope.iddet,
           r_int_pryope.idplataforma --<22.0>
           );
        <<siguiente>>
        NULL;
      END LOOP;
    END LOOP;
  END;
  --<54.0 Ini>
  /********************************************************
    Multiplica una linea de la interface X la cantidad para Servicios Adicionales
  *********************************************************/
  PROCEDURE p_mult_int_pryope_adc(a_idseq IN NUMBER) IS
    r_int_pryope int_pryope%ROWTYPE;
    r_int        int_pryope%ROWTYPE;
    l_subgrupo   NUMBER;
    i            NUMBER;
    l_num        NUMBER;
  
    CURSOR cur_subgrp IS
      SELECT numslc,
             numpto,
             grupo,
             numpto_pri,
             codsolot,
             punto,
             numpsp,
             idopc,
             descripcion,
             direccion,
             codubi,
             codsrv,
             codequcom,
             bw,
             codsuc,
             on_net,
             codinssrv,
             pid,
             pid_old,
             tipsrv,
             idproducto,
             tipinssrv,
             tiptra,
             tiptrs,
             codcli,
             codinssrv_tra,
             codinssrv_des,
             codinssrv_ori,
             numpto_ori,
             numpto_des,
             feccom,
             codpostal,
             codinssrv_pad,
             codubired,
             plazoins,
             cliint,
             tipcon,
             idpaq,
             iddet,
             idplataforma --<22.0>
        FROM int_pryope
       WHERE numslc = r_int.numslc
         AND valido = 2
         AND grupo = r_int.grupo
         AND subgrupo = r_int.subgrupo
         AND idseq = a_idseq
         AND numpto <> numpto_pri;
  BEGIN
  
    SELECT *
      INTO r_int
      FROM int_pryope
     WHERE idseq = a_idseq
       AND numpto <> numpto_pri;
    l_num := r_int.cantidad;
  
    UPDATE int_pryope
       SET valido = 2
     WHERE numslc = r_int.numslc
       AND valido = 1
       AND grupo = r_int.grupo
       AND subgrupo = r_int.subgrupo
       AND idseq = a_idseq
       AND numpto <> numpto_pri;
  
    l_subgrupo := 1;
    FOR i IN 1 .. l_num LOOP
      FOR r_int_pryope IN cur_subgrp LOOP
      
        --i_numpto            := i_numpto + 1;
        --r_int_pryope.numpto := lpad(to_char(i_numpto), 5, '0');
      
        INSERT INTO int_pryope
          (valido,
           numslc,
           numpto,
           grupo,
           subgrupo,
           numpto_pri,
           codsolot,
           punto,
           numpsp,
           idopc,
           descripcion,
           direccion,
           codubi,
           codsrv,
           codequcom,
           bw,
           codsuc,
           on_net,
           codinssrv,
           pid,
           pid_old,
           tipsrv,
           idproducto,
           tipinssrv,
           tiptra,
           tiptrs,
           codcli,
           cantidad,
           codinssrv_tra,
           codinssrv_des,
           codinssrv_ori,
           numpto_ori,
           numpto_des,
           feccom,
           codpostal,
           codinssrv_pad,
           codubired,
           plazoins,
           cliint,
           tipcon,
           idpaq,
           iddet,
           idplataforma --<22.0>
           )
        VALUES
          (1,
           r_int_pryope.numslc,
           r_int_pryope.numpto,
           r_int_pryope.grupo,
           l_subgrupo, -- Nuevo subgrupo
           r_int_pryope.numpto_pri,
           r_int_pryope.codsolot,
           r_int_pryope.punto,
           r_int_pryope.numpsp,
           r_int_pryope.idopc,
           r_int_pryope.descripcion,
           r_int_pryope.direccion,
           r_int_pryope.codubi,
           r_int_pryope.codsrv,
           r_int_pryope.codequcom,
           r_int_pryope.bw,
           r_int_pryope.codsuc,
           r_int_pryope.on_net,
           r_int_pryope.codinssrv,
           r_int_pryope.pid,
           r_int_pryope.pid_old,
           r_int_pryope.tipsrv,
           r_int_pryope.idproducto,
           r_int_pryope.tipinssrv,
           r_int_pryope.tiptra,
           r_int_pryope.tiptrs,
           r_int_pryope.codcli,
           1, /*r_int_pryope.cantidad,*/
           r_int_pryope.codinssrv_tra,
           r_int_pryope.codinssrv_des,
           r_int_pryope.codinssrv_ori,
           r_int_pryope.numpto_ori,
           r_int_pryope.numpto_des,
           r_int_pryope.feccom,
           r_int_pryope.codpostal,
           r_int_pryope.codinssrv_pad,
           r_int_pryope.codubired,
           r_int_pryope.plazoins,
           r_int_pryope.cliint,
           r_int_pryope.tipcon,
           r_int_pryope.idpaq,
           r_int_pryope.iddet,
           r_int_pryope.idplataforma --<22.0>
           );
        <<siguiente>>
        NULL;
      END LOOP;
    END LOOP;
  END;
  --<54.0 Fin>
  /**********************************************************************
    Agrupa los servicios por SOT - Se ejecuta una vez creada las IS
      - Logica de IS Maestra
      - Logica Numero Tel. Caso Traslado
  **********************************************************************/
  PROCEDURE p_reagrupa_int_pry(a_numslc IN CHAR) IS
  
    CURSOR cur_agrupa_ismst IS
      SELECT DISTINCT codinssrv_pad
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND codinssrv_pad IS NOT NULL;
  
    CURSOR cur_tel IS
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, hunting h, int_pryope s
       WHERE n.codnumtel = h.codnumtel
         AND s.codinssrv_tra = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
      UNION
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, grupotel h, int_pryope s
       WHERE n.codnumtel = h.codnumtel
         AND s.codinssrv_tra = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
      UNION
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, numxgrupotel h, int_pryope s
       WHERE n.codnumtel = h.codnumtel
         AND s.codinssrv_tra = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
       ORDER BY 1;
  
    CURSOR cur_tel2 IS
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, hunting h, int_pryope s, insprd p
       WHERE n.codnumtel = h.codnumtel
         AND s.pid_old = p.pid
         AND p.codinssrv = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
      UNION
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, grupotel h, int_pryope s, insprd p
       WHERE n.codnumtel = h.codnumtel
         AND s.pid_old = p.pid
         AND p.codinssrv = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
      UNION
      SELECT h.codcab, s.grupo, n.codinssrv
        FROM numtel n, numxgrupotel h, int_pryope s, insprd p
       WHERE n.codnumtel = h.codnumtel
         AND s.pid_old = p.pid
         AND p.codinssrv = n.codinssrv
         AND s.numslc = a_numslc
         AND s.valido = 1
       ORDER BY 1;
  
    l_grupo  NUMBER;
    l_codcab NUMBER;
  
  BEGIN
  
    -- Se completa la IS Maestra
    UPDATE int_pryope a
       SET codinssrv_pad =
           (SELECT b.codinssrv_pad
              FROM inssrv b
             WHERE b.codinssrv = a.codinssrv
               AND b.codinssrv_pad IS NOT NULL)
     WHERE numslc = a_numslc
       AND valido = 1
       AND codinssrv_pad IS NULL
       AND EXISTS (SELECT b.codinssrv_pad
              FROM inssrv b
             WHERE b.codinssrv = a.codinssrv
               AND b.codinssrv_pad IS NOT NULL);
  
    -- Vuelve a agrupar usando la IS Principal
    FOR c IN cur_agrupa_ismst LOOP
      SELECT grupo
        INTO l_grupo
        FROM int_pryope
       WHERE numslc = a_numslc
         AND valido = 1
         AND codinssrv_pad = c.codinssrv_pad
         AND rownum = 1;
    
      UPDATE int_pryope a
         SET grupo = l_grupo
       WHERE a.numslc = a_numslc
         AND a.valido = 1
         AND a.grupo IN (SELECT grupo
                           FROM int_pryope
                          WHERE numslc = a_numslc
                            AND valido = 1
                            AND codinssrv_pad = c.codinssrv_pad);
    
    END LOOP;
  
    -- Logica TELEFONIA Numeros Trasladados
    l_codcab := NULL;
    FOR h IN cur_tel LOOP
      IF l_codcab = h.codcab THEN
        NULL;
      ELSE
        l_codcab := h.codcab;
        l_grupo  := h.grupo;
      END IF;
      UPDATE int_pryope a
         SET a.grupo = l_grupo
       WHERE a.numslc = a_numslc
         AND a.valido = 1
         AND a.grupo = h.grupo;
    END LOOP;
  
    -- Logica TELEFONIA Numeros Trasladados
    l_codcab := NULL;
    FOR h IN cur_tel2 LOOP
      IF l_codcab = h.codcab THEN
        NULL;
      ELSE
        l_codcab := h.codcab;
        l_grupo  := h.grupo;
      END IF;
      UPDATE int_pryope a
         SET a.grupo = l_grupo
       WHERE a.numslc = a_numslc
         AND a.valido = 1
         AND a.grupo = h.grupo;
    END LOOP;
  
  END;

  --------------------------------------------------------------------------------
  /*******************************************************************************
     PROCEDIMIENTO QUE ASIGNA TIPO DE TRABAJO
  ********************************************************************************/
  PROCEDURE p_crea_tiptra(a_numslc vtatabslcfac.numslc%TYPE,
                          a_grupo  int_pryope.grupo%TYPE,
                          a_tiptra IN OUT solot.tiptra%TYPE) IS
  
    ls_tipsrv        tystipsrv.tipsrv%TYPE;
    ln_solucion      soluciones.idsolucion%TYPE;
    ln_tipsrvgsm     tystipsrv.tipsrv%TYPE; --Obtener el tipo de servicio TPI GSM
    ln_num           NUMBER; -- PAQUETES PYMES
    ln_num1          NUMBER; -- TPI CDMA
    ln_num2          NUMBER; -- CAMBIO DE PLAN DTH
    ln_num4          NUMBER; -- RPX
    ln_num5          NUMBER; -- CABLE SATELITAL
    ln_num7          NUMBER; -- CABLE DIGITAL - INTRAWAY
    ln_num8          NUMBER; -- TRASLADO EXTERNO
    ln_num9          NUMBER; -- TRASLADO INTERNO
    ln_num10         NUMBER; -- VENTAS MENORES - CONFIGURACION
    ln_num11         NUMBER; -- CAMBIO DE PLAN
    ln_num12         NUMBER; -- TPI COAXIAL
    ln_num13         NUMBER; -- CABLE SATELITAL PUERTA A PUERTA
    ln_num14         NUMBER; -- MIGRACION A TELMEX TV
    ln_num17         NUMBER; -- PROFESOR 24 HORAS
    ln_num18         NUMBER; -- TIENE PRODUCTO CDMA
    ln_num19         NUMBER; -- TIENE PRODUCTO TV-SAT
    ln_num20         NUMBER; -- 26.0
    ln_num21         NUMBER; -- 36.0 TPI GSM - tipsrv
    ln_num22         NUMBER; -- 39.0
    ln_num23         NUMBER; -- 47.0
    ln_num24         NUMBER; -- 49.0
    ln_num25         NUMBER; -- 50.0
    n_cont_tiptra_tc NUMBER; -- 39.0
    ln_tipo          NUMBER; -- para tipo trabajo segun tipo de tecnologia
    ln_cuentatipovc  NUMBER; -- para validar que las ventas complementarias sean del mismo tipo
    ln_proyect_ve    NUMBER; -- para validar tipo de proyecto de venta de pcs
    ln_idsolucion    NUMBER;
    ln_value         NUMBER;
    ln_num30         NUMBER;
    ln_num31         NUMBER;
    ln_tiptra        NUMBER;
    n_codincidence   NUMBER; --Para obtener la incidencia del proyecto
    n_vod            NUMBER; --para validar si el el servicio es VOD
    l_idcampanha     vtatabslcfac.idcampanha%TYPE;
    ln_val_hfc_siac  NUMBER; -- Luis Flores
    --ini V60.0
    ln_tiptra_in NUMBER;
    ln_tiptra_ex NUMBER;
    ln_tiptra_id NUMBER;
    ln_tiptra_cp NUMBER;
    --fin V60.0
    --ini 61.0
    ln_tiptra_pa     NUMBER;
    ln_tiptra_regdet NUMBER;
    --fin 61.0
    lb_paquete_masivo number; --64.0
    ln_count_ftth     number; -- 65.0
  BEGIN
    --VALIDA SI EXISTE EL SERVICIO VOD
    SELECT COUNT(DISTINCT c.tiposervicioitw)
      INTO n_vod
      FROM sales.vtadetptoenl         a,
           sales.tystabsrv            b,
           intraway.configuracion_itw c
     WHERE c.tiposervicioitw = 6 --VOD
       AND c.estado = 1
       AND TRIM(to_char(c.idconfigitw, '99999999')) = TRIM(b.codigo_ext)
       AND b.estado = 1
       AND b.codsrv = a.codsrv
       AND a.numslc = a_numslc;
  
    -- SE OBTIENE EL TIPO DE TRABAJO CONFIGURADO EN MODALIDAD DE LA VENTA
    SELECT nvl(tiptra, 1)
      INTO a_tiptra
      FROM vtadetptoenl
     WHERE numslc = a_numslc
       AND grupo = a_grupo
       AND rownum = 1;
  
    -- SE OBTIENE EL TIPO DE SERVICIO (FAMILIA) DEL PROYECTO
    SELECT tipsrv, codincidence, idcampanha
      INTO ls_tipsrv, n_codincidence, l_idcampanha
      FROM vtatabslcfac
     WHERE numslc = a_numslc;
  
    --ini 64.0
    select count(1)
      into lb_paquete_masivo
      from tipopedd a
     inner join opedd b
        on a.tipopedd = b.tipopedd
     where b.codigoc = ls_tipsrv
       and a.abrev = 'PAQ_MASIVO_FIJA';
    --fin 64.0   
    --PAQUETES MASIVOS
    IF lb_paquete_masivo > 0 THEN-- 64.0
      -- CABLE DIGITAL - INTRAWAY
      SELECT COUNT(1)
        INTO ln_num7
        FROM vtadetptoenl ve, vtatabslcfac p, paquete_venta c
       WHERE p.numslc = ve.numslc
         AND c.idpaq = ve.idpaq
         AND ve.numslc = a_numslc
         AND p.tipsrv = ls_tipsrv --64.0 
         AND c.tipo = 4;
    
      -- CABLE SATELITAL
      SELECT COUNT(1)
        INTO ln_num5
        FROM vtadetptoenl ve, vtatabslcfac p, paquete_venta q
       WHERE p.numslc = ve.numslc
         AND p.tipsrv = '0061'
         AND p.idsolucion = q.idsolucion
         AND q.tipo = 3
         AND NOT EXISTS
       (SELECT r.numslc FROM reginsdth r WHERE r.numslc = a_numslc)
         AND NOT EXISTS (SELECT i.numslc
                FROM instancia_paquete_cambio i
               WHERE i.flg_tipo_vm IN ('CP')
                 AND i.numslc = a_numslc)
         AND ve.idpaq <> 790
         AND ve.numslc = a_numslc
         AND p.numslc = a_numslc;
    
      -- PRODUCTO CDMA
      SELECT COUNT(1)
        INTO ln_num18
        FROM vtadetptoenl ve, vtatabslcfac p
       WHERE ve.numslc = p.numslc
         AND ve.numslc = a_numslc
         AND p.tipsrv = '0061'
         AND ve.idproducto = 776;
    
      -- TIENE PRODUCTO TV SAT
      SELECT COUNT(1)
        INTO ln_num19
        FROM vtadetptoenl ve, vtatabslcfac p
       WHERE ve.numslc = p.numslc
         AND ve.numslc = a_numslc
         AND p.tipsrv = '0061'
         AND ve.idproducto = 785;
    
      -- TRASLADO EXTERNO
    
      SELECT COUNT(1)
        INTO ln_num8
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('TE', 'TER')
         AND numslc = a_numslc;
    
      -- TRASLADO INTERNO
      SELECT COUNT(1)
        INTO ln_num9
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('TI', 'TIR')
         AND numslc = a_numslc;
    
      -- VENTAS MENORES - CONFIGURACION
      SELECT COUNT(1)
        INTO ln_num10
        FROM sales.regdetsrvmen a, sales.detalle_paquete b
       WHERE a.iddet = b.iddet
         AND flg_tipo_vm IN ('SC')
         AND a.numslc = a_numslc;
    
      IF ln_num10 > 0 THEN
        -- para sacar si es digital o analogico
        SELECT DISTINCT b.tipo
          INTO ln_tipo
          FROM vtadetptoenl a, paquete_venta b
         WHERE a.idpaq = b.idpaq
           AND a.numslc = a_numslc;
      
        -- para sacar los servicios de tipo configuracion
        SELECT COUNT(1)
          INTO ln_cuentatipovc
          FROM sales.regdetsrvmen a, sales.detalle_paquete b
         WHERE a.iddet = b.iddet
           AND a.numslc = a_numslc
           AND b.flg_vc = 11 -- es tipo configuracion
           AND a.codequcom IS NULL;
      
        -- se valida que la venta sea de un solo tipo
        IF (ln_cuentatipovc > 0 AND ln_cuentatipovc = ln_num10) THEN
          ln_num10 := 0;
        END IF;
      END IF;
    
      -- CAMBIO DE PLAN
      SELECT COUNT(1)
        INTO ln_num11
        FROM instancia_paquete_cambio a, paquete_venta b
       WHERE a.idpaq = b.idpaq
         AND flg_tipo_vm IN ('CP')
         AND numslc = a_numslc
         AND b.tipo NOT IN (3);
    
      -- CABLE SATELITAL PUERTA A PUERTA
      SELECT COUNT(1)
        INTO ln_num13
        FROM vtatabslcfac a, reginsdth b
       WHERE a.numslc = b.numslc
         AND a.numslc = a_numslc
         AND b.numslc = a_numslc
         AND b.fecreg < a.fecusu;
    
      -- MIGRACION A TELMEX TV
      SELECT COUNT(1)
        INTO ln_num14
        FROM regvtamentab
       WHERE numslc = a_numslc
         AND tipsrv <> tipsrv_des;
    
      -- CAMBIO DE PLAN DTH
      SELECT COUNT(1)
        INTO ln_num2
        FROM instancia_paquete_cambio a, paquete_venta b
       WHERE a.idpaq = b.idpaq
         AND flg_tipo_vm IN ('CP')
         AND numslc = a_numslc
         AND b.tipo = 3;
    
      -- PROFESOR 24 HORAS
      SELECT COUNT(1)
        INTO ln_num17
        FROM reginsprof24h
       WHERE numslc = a_numslc;
    
      SELECT COUNT(1)
        INTO n_cont_tiptra_tc
        FROM vtatabprecon a, vtatabmotivo_venta b
       WHERE a.codmotivo_tc = b.codmotivo
         AND a.numslc = a_numslc
         AND b.tiptra IS NOT NULL
         AND b.codtipomotivo = '012';
    
      -- Cambio de Luis Flores
      ln_val_hfc_siac := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                       'SOLUCION');
    
      -- ASIGNACION DE TIPO DE TRABAJO
      IF ln_num8 > 0 THEN
        -- Cambio de Luis Flores
        IF ln_val_hfc_siac > 0 THEN
          --ini 65.0
          SELECT COUNT(1)
            into ln_count_ftth
            FROM sales.vtadetptoenl a, sales.tystabsrv b
           WHERE b.estado = 1
             AND b.codsrv = a.codsrv
             AND a.numslc = a_numslc
             and idgrupocorte = 57;
          
          if ln_count_ftth > 0 then
            a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                      'TRASLADO_EXT_SIAC_FTTH');
          else
           --fin  65.0
          a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                    'TRASLADO_EXT_SIAC');
          end if; --65.0
        ELSE
          --a_tiptra := 412; -- telmex tv traslado externo
          a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                    'TRASLADO_EXT_SGA'); -- Cambio de Luis Flores
        END IF;
      ELSIF ln_num9 > 0 THEN
        a_tiptra := 418; -- telmex tv traslado interno
      ELSIF ln_num10 > 0 THEN
        IF ln_tipo = 4 THEN
          a_tiptra := 424; -- intalacion paquetes digital
        ELSE
          a_tiptra := 404; -- telmex tv instalacion paquetes
        END IF;
      ELSIF ln_cuentatipovc > 0 THEN
        IF ln_tipo IN (1, 4) THEN
          a_tiptra := 414;
          IF n_vod = 1 THEN
            a_tiptra := 494; --VOD
          END IF;
        END IF;
      ELSIF ln_num13 > 0 THEN
        a_tiptra := 438; -- cable satelital Puerta a puerta.
      ELSIF (ln_num5 > 0 AND ln_num18 = 0) THEN
        a_tiptra := 419; -- cable satelital.
      ELSIF ln_num14 > 0 THEN
        a_tiptra := 439; -- migracion a cambio de plan.
      ELSIF ln_num11 > 0 THEN
        IF n_cont_tiptra_tc = 1 THEN
          -- Cambio de Luis Flores
          IF ln_val_hfc_siac > 0 THEN
            a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                      'CAMBIO_PLAN_SIAC');
          ELSE
            SELECT nvl(tiptra, 427)
              INTO a_tiptra
              FROM vtatabprecon a, vtatabmotivo_venta b
             WHERE a.codmotivo_tc = b.codmotivo
               AND a.numslc = a_numslc
               AND b.tiptra IS NOT NULL
               AND b.codtipomotivo = '012';
          END IF;
        ELSE
          -- Cambio de Luis Flores
          IF ln_val_hfc_siac > 0 THEN
            a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                      'CAMBIO_PLAN_SIAC');
          ELSE
            a_tiptra := operacion.pq_siac_postventa.g_get_is_hfc_siac(a_numslc,
                                                                      'CAMBIO_PLAN_SGA');
            --a_tiptra := 427; -- cambio de Plan
          END IF;
        END IF;
      ELSIF ln_num2 > 0 THEN
        a_tiptra := 458; -- cambio satelital
      ELSIF ln_num7 > 0 THEN
        IF es_venta_sisact(a_numslc) THEN
          a_tiptra := get_tiptra(a_numslc);
        ELSE
          a_tiptra := 424; -- cable digital.
        END IF;
      
      ELSIF ln_num17 > 0 THEN
        a_tiptra := 453; -- profesor 24 horas
      ELSIF (ln_num18 > 0 AND ln_num19 > 0) THEN
        a_tiptra := 469; -- bundle cdma + dth
      ELSE
        a_tiptra := 404; -- telmex tv instalacion paquetes
      END IF;
      -- PAQUETES PYMES - TMX NEGOCIO
    ELSIF ls_tipsrv = '0058' THEN
      -- PAQUETES RPX
      SELECT COUNT(1)
        INTO ln_num4
        FROM vtatabslcfac p
       WHERE p.numslc = a_numslc
         AND p.idcampanha = 39;
    
      -- PAQUETES PYMES
      SELECT COUNT(1)
        INTO ln_num
        FROM vtatabslcfac p
       WHERE p.numslc = a_numslc
         AND idcampanha <> 39;
    
      -- TRASLADO EXTERNO
      SELECT COUNT(1)
        INTO ln_num8
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('TE', 'TER')
         AND numslc = a_numslc;
    
      -- TRASLADO INTERNO
      SELECT COUNT(1)
        INTO ln_num9
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('TI', 'TIR')
         AND numslc = a_numslc;
    
      -- VENTAS MENORES - CONFIGURACION PAQUETE 397
      SELECT COUNT(1)
        INTO ln_num10
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('SC')
         AND numslc = a_numslc;
    
      -- CAMBIO DE PLAN
      SELECT COUNT(1)
        INTO ln_num11
        FROM instancia_paquete_cambio
       WHERE flg_tipo_vm IN ('CP')
         AND numslc = a_numslc;
    
      -- ASIGNACION DE TIPO DE TRABAJO
      IF ln_num4 > 0 THEN
        a_tiptra := 388;
      ELSIF ln_num8 > 0 THEN
        a_tiptra := 390;
      ELSIF ln_num9 > 0 THEN
        a_tiptra := 389;
      ELSIF ln_num10 > 0 THEN
        a_tiptra := a_tiptra;
      ELSIF ln_num11 > 0 THEN
        a_tiptra := 391;
      ELSIF ln_num > 0 THEN
        a_tiptra := 368;
      END IF;
      -- TELEFONIA PUBLICA DEL INTERIOR
    ELSIF ls_tipsrv = '0059' THEN
      -- TPI COAXIAL
      SELECT COUNT(1)
        INTO ln_num12
        FROM vtatabslcfac ve, proyecto_tpi tp
       WHERE ve.numslc = a_numslc
         AND ve.numslc = tp.numslc
         AND ve.idcampanha = 43;
    
      -- TPI CDMA
      SELECT COUNT(1)
        INTO ln_num1
        FROM vtatabslcfac ve, proyecto_tpi tp
       WHERE ve.numslc = a_numslc
         AND ve.numslc = tp.numslc
         AND ve.idcampanha = 48;
    
      -- INI 36.0 TPI GSM
      SELECT COUNT(1)
        INTO ln_num21
        FROM vtatabslcfac ve
       INNER JOIN proyecto_tpi tp
          ON (ve.numslc = tp.numslc)
       INNER JOIN operacion.opedd op
          ON (ve.idcampanha = op.codigon)
       WHERE ve.numslc = a_numslc
         AND op.abreviacion = 'TPIGSM/idcampanha';
    
      -- ASIGNACION DE TIPO DE TRABAJO
      IF ln_num12 > 0 THEN
        a_tiptra := 402;
      ELSIF ln_num1 > 0 THEN
        a_tiptra := 450;
      ELSIF ln_num21 > 0 THEN
        SELECT d.codigon
          INTO a_tiptra
          FROM tipopedd c, opedd d
         WHERE c.tipopedd = d.tipopedd
           AND c.descripcion = 'OPE-Config TPI - GSM'
           AND d.abreviacion = 'TPIGSM/tiptra';
      ELSE
        SELECT b.codigon
          INTO a_tiptra
          FROM tipcrmdd a, crmdd b
         WHERE a.tipcrmdd = b.tipcrmdd
           AND a.abrev = 'CXC_TIPTRA'
           AND codigoc =
               (SELECT idcampanha FROM vtatabslcfac WHERE numslc = a_numslc);
        IF a_tiptra IS NULL THEN
          a_tiptra := 369;
        END IF;
      END IF;
      -- PAQUETES CDMA
    ELSIF ls_tipsrv = '0064' THEN
      a_tiptra := 457;
      -- VENTA DE EQUIPOS
    ELSIF ls_tipsrv = '0011' THEN
      -- VALIDAR TIPO VENTA DE EQUIPOS
      ln_proyect_ve := sales.f_verifica_proyecto_ve(a_numslc);
      -- SOLUCION VENTA PYME O EQUIPO DE COMPUTO
      SELECT a.idsolucion
        INTO ln_solucion
        FROM vtatabslcfac a
       WHERE a.numslc = a_numslc;
    
      -- ASIGNACION DE TIPO DE TRABAJO
      IF (ln_proyect_ve = 1 AND ln_solucion = 93) THEN
        a_tiptra := 463;
      ELSIF (ln_proyect_ve = 1 AND ln_solucion = 90) THEN
        a_tiptra := 465;
      ELSE
        a_tiptra := a_tiptra;
      END IF;
      --PAQUETES GSM
    ELSIF ls_tipsrv = '0068' THEN
      a_tiptra := 464;
      --PAQUETES TMX NEGOCIO HFC
    ELSIF ls_tipsrv = '0073' THEN
      -- INI v60.0   
      -- OBTIENE EL TIPO DE TRABAJO PARA TRASLADO INTERNO
      SELECT codigon
        INTO ln_tiptra_in
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd
               WHERE descripcion = 'HFC CE Transacciones Postventa'
                 AND abrev = 'CEHFCPOST')
         AND abreviacion = 'CEHFC_TRSINT';
      -- OBTIENE EL TIPO DE TRABAJO PARA TRASLADO EXTERNO 
      SELECT codigon
        INTO ln_tiptra_ex
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd
               WHERE descripcion = 'HFC CE Transacciones Postventa'
                 AND abrev = 'CEHFCPOST')
         AND abreviacion = 'CEHFC_TRSEXT';
      -- OBTIENE EL TIPO DE TRABAJO PARA INSTALACION DE DECOS       
      SELECT codigon
        INTO ln_tiptra_id
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd
               WHERE descripcion = 'HFC CE Transacciones Postventa'
                 AND abrev = 'CEHFCPOST')
         AND abreviacion = 'CEHFC_INSDECO';
    
      -- OBTIENE EL TIPO DE TRABAJO PARA CAMBIO DE PLAN     
      SELECT codigon
        INTO ln_tiptra_cp
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd
               WHERE descripcion = 'HFC CE Transacciones Postventa'
                 AND abrev = 'CEHFCPOST')
         AND abreviacion = 'CEHFC_CP';
      --FIN 61.0
      --INI 60.0
      -- OBTIENE EL TIPO DE TRABAJO PARA PUNTO ADICIONAL
      SELECT o.codigon
        INTO ln_tiptra_pa
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd
               WHERE descripcion = 'HFC CE Transacciones Postventa'
                 AND abrev = 'CEHFCPOST')
         AND abreviacion = 'CEHFC_INSPTO';
    
      --FIN 61.0          
      -- TRASLADO EXTERNO
      SELECT COUNT(1)
        INTO ln_num8
        FROM operacion.sga_visita_tecnica_ce
       WHERE numslc_new = a_numslc
         AND tiptrx = ln_tiptra_ex; --v60.0
    
      -- TRASLADO INTERNO
      SELECT COUNT(1)
        INTO ln_num9
        FROM regdetsrvmen
       WHERE flg_tipo_vm IN ('TI', 'TIR')
         AND numslc = a_numslc;
    
      SELECT idsolucion
        INTO ln_idsolucion
        FROM vtatabslcfac
       WHERE numslc = a_numslc;
    
      -- HFC / WIMAX
      SELECT COUNT(*)
        INTO ln_num30
        FROM regdetsrvmen s
       WHERE s.flg_tipo_vm IN ('SC')
         AND numslc = a_numslc
         AND s.codsrv IN
             (SELECT c.codigoc
                FROM crmdd c
               WHERE c.tipcrmdd =
                     (SELECT j.tipcrmdd
                        FROM tipcrmdd j
                       WHERE j.abrev = 'SELSRVVTAMENOR'));
    
      IF ln_num30 < 1 OR ln_num30 = NULL THEN
        -- VENTAS MENORES CONFIGURACION
        SELECT COUNT(1)
          INTO ln_num10
          FROM regdetsrvmen
         WHERE flg_tipo_vm IN ('SC')
           AND numslc = a_numslc;
      END IF;
    
      ln_num20 := 0;
      SELECT COUNT(1)
        INTO ln_num20
        FROM vtatabslcfac
       WHERE numslc = a_numslc
         AND flg_cehfc_cp = 1
         AND (SELECT COUNT(1) FROM tipopedd WHERE abrev = 'SRVMENORCEHFC') = 1;
    
      IF ln_num10 > 0 THEN
        -- para sacar si es digital o analogico
        SELECT DISTINCT b.tipo
          INTO ln_tipo
          FROM vtadetptoenl a, paquete_venta b
         WHERE a.idpaq = b.idpaq
           AND a.numslc = a_numslc;
      
        -- para sacar los servicios de tipo configuracion
        SELECT COUNT(1)
          INTO ln_cuentatipovc
          FROM sales.regdetsrvmen a, sales.detalle_paquete b
         WHERE a.iddet = b.iddet
           AND a.numslc = a_numslc
           AND b.flg_vc = 13 -- indica que es de tipo configuracion
           AND a.codequcom IS NULL;
      
        -- se valida que la venta sea de un solo tipo
        IF (ln_cuentatipovc > 0 AND ln_cuentatipovc = ln_num10) THEN
          ln_num10 := 0;
        END IF;
      END IF;
    
      -- CAMBIO DE PLAN
      SELECT COUNT(1)
        INTO ln_num11
        FROM instancia_paquete_cambio
       WHERE flg_tipo_vm IN ('CP')
         AND numslc = a_numslc;
    
      --<Ini 47.0>
      ln_num23 := 0;
      SELECT COUNT(1)
        INTO ln_num23
        FROM vtatabslcfac
       WHERE numslc = a_numslc
         AND flg_cehfc_cp = 2;
      --<Fin 47.0>
    
      -- ASIGNACION DE TIPO DE TRABAJO
      IF ln_num8 > 0 THEN
        a_tiptra := ln_tiptra_ex; -- 60.0 Traslado Externo
      ELSIF ln_num9 > 0 THEN
        a_tiptra := ln_tiptra_in; -- 60.0 Traslado Interno
      ELSIF ln_num10 > 0 THEN
        --ini 61.0          
        SELECT COUNT(tiptra)
          INTO ln_tiptra_regdet
          FROM regdetsrvmen
         WHERE flg_tipo_vm IN ('SC')
        AND numslc = a_numslc AND tiptra = ln_tiptra_pa;
        IF ln_tiptra_regdet > 0 THEN
           a_tiptra := ln_tiptra_pa; -- 62.0 Punto Adicional
        ELSE
          --fin 61.0
          SELECT VALUE
            INTO ln_value
            FROM atcparameter
           WHERE codparameter = 'SOLUCIONPWEB';
          IF ln_idsolucion = ln_value THEN
            a_tiptra := 404; -- Ventas Complementarias
          ELSE
            a_tiptra := ln_tiptra_id; -- 60.0 Ventas Complementarias
          END IF;
          --ini 61.0
        END IF; --fin 61.0
      ELSIF ln_num30 > 0 THEN
        a_tiptra := a_tiptra;
      ELSIF ln_cuentatipovc > 0 THEN
        a_tiptra := 414;
        IF n_vod = 1 THEN
          a_tiptra := 494; --VOD
        END IF;
        --<Ini 47.0>
      ELSIF ln_num23 > 0 THEN
        a_tiptra := 724; -- CE HFC - SERVICIOS MENORES CP
        --<Fin 47.0>
      ELSIF ln_num11 > 0 THEN
        a_tiptra := ln_tiptra_cp;
      ELSIF ln_num20 > 0 THEN
        a_tiptra := 620; -- HFC - CE SERVICIOS MENORES
      ELSE
        a_tiptra := 424; -- Instalacion
      END IF;
      -- Ini 49.0
    ELSIF ls_tipsrv = '0077' THEN
      -- Ini 50.0
      IF operacion.pkg_dth_migracion.es_migracion(a_numslc) = 1 THEN
        a_tiptra := operacion.pkg_dth_migracion.get_datos_dth_migra('tiptra_dth_migra');
        -- Ini 56.0
      ELSIF es_venta_sisact(a_numslc) THEN
        a_tiptra := get_tiptra(a_numslc);
      ELSE
        -- Fin 56.0
        -- Fin 50.0
        -- CABLE
        SELECT COUNT(1)
          INTO ln_num24
          FROM vtadetptoenl ve, vtatabslcfac p, paquete_venta c
         WHERE p.numslc = ve.numslc
           AND c.idpaq = ve.idpaq
           AND ve.numslc = a_numslc
           AND p.tipsrv = '0077'
           AND c.idsolucion = (SELECT so.idsolucion
                                 FROM soluciones so
                                WHERE so.flg_sisact_sga = 2)
           AND c.tipo = 4;
      
        -- ini 50.0
        SELECT COUNT(*)
          INTO ln_num25
          FROM vtatabslcfac v
         WHERE v.numslc = a_numslc
           AND v.idsolucion = (SELECT so.idsolucion
                                 FROM soluciones so
                                WHERE so.flg_sisact_sga = 2)
           AND (SELECT COUNT(*)
                  FROM instancia_paquete_cambio
                 WHERE numslc = a_numslc
                   AND flg_tipo_vm = 'CP') > 0;
        -- fin 50.0
        IF ln_num24 > 0 THEN
          SELECT codigon
            INTO a_tiptra
            FROM opedd
           WHERE abreviacion = 'SISACT_WLL';
        END IF;
      
        SELECT COUNT(1)
          INTO ln_num8
          FROM regdetsrvmen
         WHERE flg_tipo_vm IN ('TE', 'TER')
           AND numslc = a_numslc;
      
        IF ln_num8 > 0 THEN
          --cambio LTE T. Externo
          SELECT tiptra
            INTO a_tiptra
            FROM sales.regdetsrvmen
           WHERE numslc = a_numslc
             AND rownum < 2;
        END IF;
        -- ini 50.0
        IF ln_num25 > 0 THEN
          SELECT sales.f_obt_tiptraxtipsrv(ls_tipsrv, 6)
            INTO a_tiptra
            FROM dual;
        END IF;
        -- fin 50.0
        -- Ini 50.0
      END IF;
      -- Fin 50.0
      -- Fin 49.0
      --PAQUETES CLOUD OFFICE 365
    ELSIF ls_tipsrv = '0082' THEN
      a_tiptra := 622;
    ELSIF ls_tipsrv = '0081' THEN
      a_tiptra := 628;
    ELSIF ls_tipsrv = sales.pq_servicio_cloud.get_tipsrv_cloud() THEN
      IF sales.pq_servicio_cloud.es_cambio_plan(a_numslc) THEN
        a_tiptra := sales.pq_servicio_cloud.get_tiptra_cloud_cp();
      ELSE
        a_tiptra := sales.pq_servicio_cloud.get_tiptra_cloud_alta();
      END IF;
      sales.pq_servicio_cloud.actualizar_costo_srv(a_numslc);
    ELSIF pkg_tpe.es_tpe(ls_tipsrv) AND
          pkg_tpe.es_campanha_tpe(l_idcampanha) THEN
      a_tiptra := pkg_tpe.get_tiptra();
      --Inicio 55.0
    ELSIF sales.pkg_preseleccion.sgafun_tipsrv_tfi(NULL, ls_tipsrv) THEN
      a_tiptra := sales.pkg_preseleccion.sgafun_obtiene_tiptra_tfi();
      -- Fin 55.0
    END IF;
  
    IF n_codincidence IS NOT NULL THEN
      -- BUSCAR TIPO DE TRABAJO
      SELECT nvl(tiptra, 1)
        INTO a_tiptra
        FROM vtadetptoenl
       WHERE numslc = a_numslc
         AND grupo = a_grupo
         AND rownum = 1;
    END IF;
  END;
  --------------------------------------------------------------------------------
  FUNCTION es_venta_sisact(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM sales.int_negocio_instancia t
     WHERE t.instancia = 'PROYECTO DE VENTA'
       AND t.idinstancia = p_numslc;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  FUNCTION get_tiptra(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN tiptrabajo.tiptra%TYPE IS
    c_migra CONSTANT PLS_INTEGER := 2;
    l_lte            BOOLEAN := FALSE;
    l_venta          sales.int_negocio_proceso%ROWTYPE;
    l_migracion      BOOLEAN := FALSE;
    l_portabilidad   BOOLEAN := FALSE;
    l_migra_sga_bscs BOOLEAN := FALSE; -- 52.0
    l_tipo           opedd.codigoc%TYPE; -- 52.0
    v_tfi            BOOLEAN := FALSE; -- 55.0
    v_ftth           BOOLEAN := FALSE; -- 57.0
    -- Ini 59.0
    l_portout_alta BOOLEAN := FALSE;
    l_val_single   VARCHAR2(30);
    -- Fin 59.0
  
  BEGIN
    l_venta          := get_venta(p_numslc);
    l_lte            := get_lte(p_numslc); -- 49.0
    l_migra_sga_bscs := get_migra_sga_bscs(l_venta.tipo); -- 52.0
    -- Inicio 55.0
    v_tfi := sales.pkg_preseleccion.sgafun_tipsrv_tfi(p_numslc, NULL);
    -- Fin 55.0
    v_ftth := sgafun_get_ftth(p_numslc); -- 57.0
  
    IF l_venta.tipo = c_migra THEN
      l_migracion := TRUE;
    END IF;
  
    IF l_venta.numero_portable IS NOT NULL THEN
      l_portabilidad := TRUE;
    END IF;
  
    -- Ini 59.0
    --PORT-OUT ALTA
    IF operacion.pkg_portabilidad.sgafun_portout_es_vtaalt(p_numslc) THEN
      l_portout_alta := TRUE;
      l_portabilidad := FALSE;
    END IF;
    -- Fin 59.0    
  
    IF l_migracion AND l_portabilidad THEN
      RETURN get_tiptra_migra_porta();
    ELSIF l_migracion THEN
      RETURN get_tiptra_migra();
    ELSIF l_portabilidad THEN
      RETURN get_tiptra_porta(l_lte); --56.0
      -- Ini 59.0
    ELSIF l_portout_alta AND l_lte THEN
      RETURN sgafun_get_tiptra_altout('LTE');
    ELSIF l_portout_alta THEN
      RETURN sgafun_get_tiptra_altout('HFC');
      -- Fin 59.0 
    ELSIF l_lte THEN
      RETURN get_tiptra_lte(); -- 49.0
    ELSIF l_migra_sga_bscs THEN
      -- 52.0 ini
      p_validar_tipo_asignacion(p_numslc, l_tipo);
      RETURN get_tiptra_sga_bscs(l_tipo); -- 52.0 fin
      -- Inicio 55.0
    ELSIF v_tfi THEN
      RETURN sales.pkg_preseleccion.sgafun_obtiene_tiptra_tfi(); -- 49.0
      -- Fin 55.0
      -- Ini 57.0
    ELSIF v_ftth THEN
      RETURN sgafun_get_tiptra_ftth(p_numslc);--64.0
      -- Fin 57.0
    ELSE
      RETURN get_tiptra_sisact();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA() ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_venta(p_numslc vtatabslcfac.numslc%TYPE)
    RETURN sales.int_negocio_proceso%ROWTYPE IS
    l_venta sales.int_negocio_proceso%ROWTYPE;
  
  BEGIN
    SELECT p.*
      INTO l_venta
      FROM sales.int_negocio_instancia i, sales.int_negocio_proceso p
     WHERE i.instancia = 'PROYECTO DE VENTA'
       AND i.idinstancia = p_numslc
       AND i.idprocess = p.idprocess;
  
    RETURN l_venta;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_VENTA(p_numslc => ' ||
                              p_numslc || ') ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_tiptra_migra_porta RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_tiptra
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPTRABAJO'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'MIGRA_PORTA';
  
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_MIGRA_PORTA() ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_tiptra_migra RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_tiptra
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPTRABAJO'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'MIGRA';
  
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_MIGRA() ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_tiptra_porta(an_lte BOOLEAN) RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    --Ini 56.0
    IF an_lte = TRUE THEN
      SELECT d.codigon
        INTO l_tiptra
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'TIPTRABAJO'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion = 'SISACT_WLL_PORTA';
    ELSE
      --Fin 56.0
      SELECT d.codigon
        INTO l_tiptra
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'TIPTRABAJO'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion = 'PORTA';
    END IF;
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_PORTA() ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_tiptra_sisact RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_tiptra
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPTRABAJO'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'SISACT';
  
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_SISACT() ' ||
                              SQLERRM);
  END;
  /**********************************************************************
    PROCEDIMIENTO PARA ACTUALIZAR CAMPO VALIDO DE TABLA INT_PRYOPE
  **********************************************************************/
  PROCEDURE p_actualiza_int_pryope(a_numslc IN CHAR) IS
  BEGIN
    UPDATE int_pryope SET valido = 0 WHERE numslc = a_numslc;
  END;

  /*********************************
    OTROS PROCEDIMIENTOS FINALES
  **********************************/
  PROCEDURE p_finales_int_pryope(a_numslc IN CHAR) IS
    ls_tipsrv tystipsrv.tipsrv%TYPE;
  BEGIN
    SELECT tipsrv INTO ls_tipsrv FROM vtatabslcfac WHERE numslc = a_numslc;
    -- Promociones Upgrade
    IF ls_tipsrv = '0061' THEN
      NULL;
      --  operacion.pq_promo3play.p_asigna_pomo3playcliente(a_numslc);
    END IF;
    -- Interfaz MT
    pq_mt.p_interface_oc(a_numslc);
  END;
  --19.0>

  -- Ini 48.0
  FUNCTION get_lte(p_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    l_solucion sales.soluciones.flg_sisact_sga%TYPE;
  
  BEGIN
  
    SELECT b.flg_sisact_sga
      INTO l_solucion
      FROM sales.vtatabslcfac a, sales.soluciones b
     WHERE a.idsolucion = b.idsolucion
       AND a.numslc = p_numslc;
  
    IF l_solucion = 2 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION get_tiptra_lte RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_tiptra
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPTRABAJO'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'SISACT_WLL';
  
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_LTE() ' ||
                              SQLERRM);
  END;
  -- Fin 48.0
  -- ini 52.0
  FUNCTION get_migra_sga_bscs(k_tipo sales.int_negocio_proceso.tipo%TYPE)
    RETURN BOOLEAN IS
    v_tipo_migracion opedd.codigoc%TYPE;
  
  BEGIN
    SELECT d.codigoc
      INTO v_tipo_migracion
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'MIGR_SGA_BSCS'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'TIP_INDMIGRA';
  
    IF k_tipo = v_tipo_migracion THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.GET_MIGRA_SGA_BSCS(K_TIPO => ' || k_tipo || ' )' ||
                              SQLERRM);
  END;

  PROCEDURE p_validar_tipo_asignacion(p_numslc vtatabslcfac.numslc%TYPE,
                                      p_tipo   OUT operacion.migrt_cab_temp_sot.datai_tipoagenda%TYPE) IS
  
    v_codcli     vtatabslcfac.codcli%TYPE;
    v_numdoc     VARCHAR2(15);
    v_id         NUMBER;
    v_tipsrv     vtatabslcfac.tipsrv%TYPE;
    v_tipoagenda migrt_cab_temp_sot.datai_tipoagenda%TYPE;
  
    v_error_no_numslc     EXCEPTION;
    v_error_no_tipoagenda EXCEPTION;
    v_error_registros     EXCEPTION;
  
    v_mensaje VARCHAR2(1000);
  
  BEGIN
  
    BEGIN
      SELECT t.codcli, t.tipsrv
        INTO v_codcli, v_tipsrv
        FROM vtatabslcfac t
       WHERE t.numslc = p_numslc;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE v_error_no_numslc;
    END;
  
    BEGIN
      SELECT t.datan_id, t.datai_tipoagenda, t.datav_numdoc
        INTO v_id, v_tipoagenda, v_numdoc
        FROM operacion.migrt_cab_temp_sot t
       WHERE t.datac_codcli = v_codcli
         AND t.datac_tipsrv = v_tipsrv
       GROUP BY t.datan_id, t.datai_tipoagenda, t.datav_numdoc;
    EXCEPTION
      WHEN no_data_found THEN
        RAISE v_error_no_tipoagenda;
      WHEN too_many_rows THEN
        RAISE v_error_registros;
    END;
  
    p_tipo := v_tipoagenda;
  
  EXCEPTION
    WHEN v_error_no_numslc THEN
      v_mensaje := 'Error, No se ha registrado la venta del proyecto Nº ' ||
                   p_numslc;
    
      operacion.pkg_migracion_sga_bscs.migrsi_registra_error(v_id,
                                                             v_numdoc,
                                                             NULL,
                                                             'ALTA',
                                                             v_mensaje);
    
      raise_application_error(-20000, v_mensaje);
    
    WHEN v_error_no_tipoagenda THEN
      v_mensaje := 'Error, No se ha definido el tipo de agendamiento  de la venta del proyecto N? ' ||
                   p_numslc;
    
      operacion.pkg_migracion_sga_bscs.migrsi_registra_error(v_id,
                                                             v_numdoc,
                                                             NULL,
                                                             'ALTA',
                                                             v_mensaje);
    
      raise_application_error(-20000, v_mensaje);
    
    WHEN v_error_registros THEN
      v_mensaje := 'Error, se ha encontrado mas de un registro para el proyecto N? ' ||
                   p_numslc;
    
      operacion.pkg_migracion_sga_bscs.migrsi_registra_error(v_id,
                                                             v_numdoc,
                                                             NULL,
                                                             'ALTA',
                                                             v_mensaje);
    
      raise_application_error(-20000, v_mensaje);
    
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.P_VALIDAR_TIPO_ASIGNACION( p_numslc => ' ||
                              p_numslc || ') ' || SQLERRM);
  END;

  FUNCTION get_tiptra_sga_bscs(p_tipo opedd.codigoc%TYPE)
    RETURN tiptrabajo.tiptra%TYPE IS
    v_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
  
    SELECT d.codigon
      INTO v_tiptra
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'MIGR_SGA_BSCS'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'MIG_TIPTRA'
       AND d.codigoc = p_tipo;
  
    RETURN v_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_SGA_BSCS() ' ||
                              SQLERRM);
  END;
  -- fin 52.0
  -- Ini 57.0
  FUNCTION sgafun_get_ftth(pi_numslc vtatabslcfac.numslc%TYPE) RETURN BOOLEAN IS
    v_val_cnt NUMBER;
    ln_idprocess sales.int_negocio_proceso.idprocess%type;--64.0   
  BEGIN
    ln_idprocess := sales.pq_int_sisact_sga_utl.g_idprocess;--64.0
     -- Ini 63.0
   SELECT count(ope.codigon_aux)
     INTO v_val_cnt
     FROM tipopedd tip
    inner join opedd ope
       on tip.tipopedd = ope.tipopedd
    inner join sales.int_negocio_proceso inp
       on inp.idtecnologia = ope.codigon_aux
    inner join vtatabslcfac vta
       on inp.numsec = vta.numsec
    where tip.abrev = 'TIPTRABAJO'
       and inp.idprocess = ln_idprocess--64.0
      and vta.numslc = pi_numslc;
  -- Fin 63.0 
  
    IF v_val_cnt > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
  FUNCTION sgafun_get_tiptra_ftth(pi_numslc vtatabslcfac.numslc%TYPE)--64.0
   RETURN tiptrabajo.tiptra%TYPE IS
    v_tiptra NUMBER;
    ln_idprocess sales.int_negocio_proceso.idprocess%type;--64.0  
  BEGIN
    --ini 64.0
    ln_idprocess := sales.pq_int_sisact_sga_utl.g_idprocess;
    SELECT ope.codigon
      INTO v_tiptra
      FROM tipopedd tip
     inner join opedd ope
        on tip.tipopedd = ope.tipopedd
     inner join sales.int_negocio_proceso inp
        on inp.idtecnologia = ope.codigon_aux
     inner join vtatabslcfac vta
        on inp.numsec = vta.numsec
     where tip.abrev = 'TIPTRABAJO'
       and inp.idprocess = ln_idprocess
       and vta.numslc = pi_numslc;
    --fin 64.0
  
    RETURN v_tiptra;
  END;
  -- Fin 57.0
  -- Ini 59.0
  FUNCTION sgafun_get_tiptra_altout(a_tipo VARCHAR2)
    RETURN tiptrabajo.tiptra%TYPE IS
    l_tiptra tiptrabajo.tiptra%TYPE;
  
  BEGIN
    IF a_tipo = 'LTE' THEN
      SELECT d.codigon
        INTO l_tiptra
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'TIPTRABAJO'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion = 'SISACT_ALTA_LTE';
    ELSIF a_tipo = 'HFC' THEN
      SELECT d.codigon
        INTO l_tiptra
        FROM tipopedd c, opedd d
       WHERE c.abrev = 'TIPTRABAJO'
         AND c.tipopedd = d.tipopedd
         AND d.abreviacion = 'SISACT_ALTA_HFC';
    END IF;
    RETURN l_tiptra;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.GET_TIPTRA_PORTA() ' ||
                              SQLERRM);
  END;
  -- Fin 59.0
END pq_int_pryope;
/