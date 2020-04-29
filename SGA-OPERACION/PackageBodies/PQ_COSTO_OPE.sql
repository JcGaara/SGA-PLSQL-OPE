CREATE OR REPLACE PACKAGE BODY OPERACION.Pq_Costo_Ope AS
 /******************************************************************************
     NAME:       Pq_Costo_Ope
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Solicitado por     Description
     ---------  ----------  ---------------  ----------------   ------------------------------------

      1        13/03/2009  Hector Arturo                        REQ 86835 :se creo el procedmiento P_CARGAR_INFO_EQU_INTRAWAY que Cargar equipos a SGA de Intraway
      2        14/04/2009  Hector Arturo                        REQ 85887 :se crearon los siguientes procedmientos:
                                                                    P_Valorizar_liquidacion:Procedimientos para atender proyectos Generacion de PEDIDO ASOCIADO SOT-ETAPA
                                                                    P_importar_sot_etapa:Procedimiento para importar SOT-Etapa en SOLOTPTOETA, actualiza el IDLIQ para maestros
                                                                    P_importar_sot_etapa_liq:Procedimiento para importar SOT-Etapa en SOLOTPTOETA, actualiza el IDLIQ para maestros
      3        17/04/2009  Joseph Asencios                      REQ 87333: se creo el procedimiento P_ACT_MAESTRO_SERIES_MAC1
                                                                que actualiza de forma masiva los UnitAddress de los equipos de Intraway.
      4        24/04/2009  Hector Huaman                        REQ  89517 :se crearon los siguientes procedmientos:
                                                                     p_cargar_formula_act_mat:Procedimiento que permite cargar la informacion de actividades a la Sot Basado en formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
                                                                     p_pre_liquidar_act_mat:Procedimiento que permite liquidar las lineas de control de costos por etapa, antes de liquidar las lineas se verifica que el servicio de la sot se encuentre activay que se haya registrado el Cintillo
                                                                     p_liquidar_act_mat:Se valida las actividades preliquidades y luego de la verificaciones se procede a Liquidar
      5        30/04/2009  Hector Huaman                        REQ  90344 :se creo el procedimiento p_llenar_actxcontrataxprec, que carga en la tabla actxcontrataxprec por actividad, todas las contratas con un preciario determinado

      6        21/05/2009  Hector Huaman                        REQ 93022: Se creo el procedimiento P_act_maestro_Series_sap, ctualizar bd de series en  base a SAP de manera automatica

      7        03/06/2009  Edilbeto Astulle                     REQ 85252: Se creó los procedimientos p_despacho_equ_mat y p_genera_pep_presupuesto

      8        11/06/2009  Hector Huaman                        REQ 94109: Se modifico el procedimiento p_importar_sot_etapa, se cambio los argumentos de entrada

      9        18/08/2009  Hector Huaman                        REQ 99445: se creo la funcion  f_verificar_almacen_equ para que se valide el equipo, que pertenezca almacen de la contrata asignada
                                                                1 : Valido
                                                                0 : Serie Nula
                                                               -1 : No Serie no Pertenece a Almacen
     10        18/08/2009  Hector Huaman                       REQ 101132: se creo el procedimiento p_cargar_info_equ_cdma_gsm y se modifico el procedimiento p_cargar_info_equ_dth para la carga de equipos.
     11        14/10/2009  Jimmy Farfán                        REQ 104404: Tareas de GIS para Inventario de Planos.
                                                               Se añadió los procedures p_genera_plano_gis y
                                                               p_elimina_plano_gis.
     12        20/10/2009  Jimmy Farfán                        REQ 106310: Procedure p_cargar_info_equ_dth. También se va a descargar el
                                                               campo solotptoequ.codequcom.

     13        03/12/2009  Joseph Asencios                     REQ 111840: Se modificó el procedimiento p_cargar_info_equ_intraway.

     14        06/01/2010  Alfonso Pérez                       REQ 110530: Se agrego logica para mostrar comentario.

     15        23/11/2009  Jimmy Farfán                        REQ 97766: Se creó p_cargar_equ_cdma_gsm para el WF de GSM (wfdef=855), se configura
                                                                   como proceso pre de la tarea Asignación de Número Telefónico.
                                                                   En caso haya 0 registros en la tabla operacion.solotptoequ,
                                                                   se inserta un registro.
     16.0      04/02/2010  Antonio Lagos                       REQ 106908: bundle DTH+CDMA
     17.0      29/04/2010  Marcos Echevarria                   REQ-123713: en  P_act_maestro_Series_mac1 se agrego mac2 y mac3 para su actualizacion
     18.0      29/04/2010  Marcos Echevarria Edilberto Astulle REQ-123713: se optimiza p_cargar_info_equ_intraway para que siemrep se extraiga info de MAESTRO_SERIES_EQU
     19.0      02/08/2010  Mariela Aguirre   Rolando Martinez  REQ-135892: Correcciones a querys
     20.0      27/08/2010  Alexander Yong    Marco De La Cruz  REQ-134351: Problema con la carga de equipos
     21.0      22/09/2010  Edson Caqui       Cesar Rosciano    Req.143672 - Validacion de servicios activos
     22.0      09/11/2010  Antonio Lagos     Edilberto Astulle REQ-134845:Guardar sot que ejecutó la recuperación
     23.0      16/03/2011  Antonio Lagos     Zulma Quispe      REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
     24.0      20/06/2011  Fernando Canaval  Edilberto Astulle REQ-159925: Registra mas de un equipo con mismo numero de Serie a la SOT
     25.0      04/07/2011  Fernando Canaval  Edilberto Astulle REQ-160072: Habilitar Acceso para Cierre de Tareas de Liquidacion de Materiales HFC al Liquidar SOT.
     26.0      13/07/2011  Fernando Canaval  Edilberto Astulle REQ-160184: Asignar Agenda en Proceso de Descarga de Equipos de IW.
     27.0      07/09/2011  Fernando Canaval  Edilberto Astulle REQ-160913: Interface SGA SAP.
     28.0      29/08/2011  Alexander Yong    Edilberto Astulle REQ-160185: SOTs Baja 3Play
     29.0      15/12/2011  Carlos Lazarte    Edilberto Astulle REQ-160183: Mantenimiento de Liquidacion MO
     30.0      15/12/2011  Edilberto Astulle Edilberto Astulle SD_697392
     31.0      19/06/2013  Miriam Mandujano  Jose Velarde Actualizacion del despacho del material (webservices)
   32.0      23.04.2015  Ricardo Crisostomo SINERGIA SGA-SAP
   33.0      27.09.2015  Edilberto Astulle SD-479472
     34.0      21.02.2019  LQ                SHELLs PARA LIMFTPV02
  /*********************************************************************************************************************/
  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de materiales de SOLOT x punto x etapa(fase: 1=dise?o, 2=Instalacion, 3=Liquidacion, 4=Valorizacion) --
  /*********************************************************************************************************************/
  FUNCTION f_sum_matxpuntoxetapa(a_codsolot IN NUMBER,
                                 a_punto    IN NUMBER,
                                 a_etapa    IN NUMBER,
                                 a_moneda   IN NUMBER,
                                 a_fase     IN NUMBER,
                                 a_area     IN NUMBER DEFAULT NULL)
    RETURN NUMBER IS
    l_costo NUMBER;

  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta b
         WHERE a.codsolot = b.codsolot
           AND a.punto = b.punto
           AND a.orden = b.orden
           AND b.codsolot = a_codsolot
           AND b.punto = a_punto
           AND b.codeta = a_etapa
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta b
         WHERE a.codsolot = b.codsolot
           AND a.punto = b.punto
           AND a.orden = b.orden
           AND b.codsolot = a_codsolot
           AND b.punto = a_punto
           AND b.codeta = a_etapa
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.codeta = a_etapa
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.codeta = a_etapa
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de actividad de una solotxpunto (Moneda:1 = Soles y 2 = Dolar / Permiso: 0 = Sin permiso y 1 = Con permiso)
  /*********************************************************************************************************************/
  FUNCTION f_sum_actxpuntoxetapa(a_codsolot IN NUMBER,
                                 a_punto    IN NUMBER,
                                 a_etapa    IN NUMBER,
                                 a_moneda   IN NUMBER,
                                 a_permiso  IN NUMBER,
                                 a_fase     IN NUMBER,
                                 a_area     IN NUMBER DEFAULT NULL)
    RETURN NUMBER IS
    l_costo NUMBER;
  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b, solotptoeta c
         WHERE a.codact = b.codact
           AND a.codsolot = c.codsolot
           AND a.punto = c.punto
           AND a.orden = c.orden
           AND b.espermiso = a_permiso
           AND c.codsolot = a_codsolot
           AND c.punto = a_punto
           AND c.codeta = a_etapa
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b, solotptoeta c
         WHERE a.codact = b.codact
           AND a.codsolot = c.codsolot
           AND a.punto = c.punto
           AND a.orden = c.orden
           AND b.espermiso = a_permiso
           AND c.codsolot = a_codsolot
           AND c.punto = a_punto
           AND c.codeta = a_etapa
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.codeta = a_etapa
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.codeta = a_etapa
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene los metros usaudos en cada etapa.
  /*********************************************************************************************************************/
  FUNCTION f_sum_metrosxetapa(a_codsolot IN NUMBER,
                              a_punto    IN NUMBER,
                              a_etapa    IN NUMBER) RETURN NUMBER IS
    l_metro NUMBER;
  BEGIN
    l_metro := 0;
    RETURN l_metro;
  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de materiales de SOLOT x punto (fase: 1=dise?o, 2=Instalacion, 3=Liquidacion, 4=Valorizacion) --
  /*********************************************************************************************************************/
  FUNCTION f_sum_matxpunto(a_codsolot IN NUMBER,
                           a_punto    IN NUMBER,
                           a_moneda   IN NUMBER,
                           a_fase     IN NUMBER,
                           a_area     IN NUMBER DEFAULT NULL) RETURN NUMBER IS
    l_costo NUMBER;

  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a
         WHERE a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a
         WHERE a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;
    RETURN l_costo;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de actividad de una solotxpunto (Moneda:1 = Soles y 2 = Dolar / Permiso: 0 = Sin permiso y 1 = Con permiso)
  /*********************************************************************************************************************/
  FUNCTION f_sum_actxpunto(a_codsolot IN NUMBER,
                           a_punto    IN NUMBER,
                           a_moneda   IN NUMBER,
                           a_permiso  IN NUMBER,
                           a_fase     IN NUMBER,
                           a_area     IN NUMBER DEFAULT NULL) RETURN NUMBER IS
    l_costo NUMBER;
  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b
         WHERE a.codact = b.codact
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b
         WHERE a.codact = b.codact
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.punto = a_punto
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;
    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de materiales de SOLOT (fase: 1=dise?o, 2=Instalacion, 3=Liquidacion, 4=Valorizacion) --
  /*********************************************************************************************************************/
  FUNCTION f_sum_matxsolot(a_codsolot IN NUMBER,
                           a_moneda   IN NUMBER,
                           a_fase     IN NUMBER,
                           a_area     IN NUMBER DEFAULT NULL) RETURN NUMBER IS
    l_costo NUMBER;

  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a
         WHERE a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a
         WHERE a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;
    RETURN l_costo;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtine el costo de actividad de una solot (Moneda:1 = Soles y 2 = Dolar / Permiso: 0 = Sin permiso y 1 = Con permiso)
  /*********************************************************************************************************************/
  FUNCTION f_sum_actxsolot(a_codsolot IN NUMBER,
                           a_moneda   IN NUMBER,
                           a_permiso  IN NUMBER,
                           a_fase     IN NUMBER,
                           a_area     IN NUMBER DEFAULT NULL) RETURN NUMBER IS
    l_costo NUMBER;
  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b
         WHERE a.codact = b.codact
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b
         WHERE a.codact = b.codact
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND a.codsolot = a_codsolot
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de los materiales de un EF
  /*********************************************************************************************************************/
  FUNCTION F_Sum_Materialxef(a_codsolot IN NUMBER) RETURN NUMBER IS

    l_costo NUMBER;

  BEGIN

    SELECT NVL(SUM(efptoetamat.costo * efptoetamat.cantidad), 0)
      INTO l_costo
      FROM efptoetamat, ef, efpto, solot
     WHERE (efpto.codef = ef.codef)
       AND (efpto.punto = efptoetamat.punto)
       AND (efpto.codef = efptoetamat.codef)
       AND (solot.numslc = ef.numslc)
       AND (solot.codsolot = a_codsolot);

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de las actividades de un EF (Moneda:1 = Soles y 2 = Dolar / Permiso: 0 = Sin permiso y 1 = Con permiso)
  /*********************************************************************************************************************/
  FUNCTION F_Sum_Actividadxef(a_codsolot IN NUMBER,
                              a_moneda   IN NUMBER,
                              a_permiso  IN NUMBER) RETURN NUMBER IS

    l_costo NUMBER;

  BEGIN

    SELECT NVL(SUM(efptoetaact.costo * efptoetaact.cantidad), 0)
      INTO l_costo
      FROM efptoetaact, actividad, ef, efpto, solot
     WHERE (efpto.codef = ef.codef)
       AND (efpto.punto = efptoetaact.punto)
       AND (efpto.codef = efptoetaact.codef)
       AND (actividad.codact = efptoetaact.codact)
       AND (solot.numslc = ef.numslc)
       AND (solot.codsolot = a_codsolot)
       AND (actividad.espermiso = a_permiso)
       AND (efptoetaact.moneda_id = a_moneda);

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  /*********************************************************************************************************************/
  PROCEDURE P_Llena_Presupuesto_De_Solot(a_codsolot solot.codsolot%TYPE) IS

    CURSOR cur_ubi IS
      SELECT solotpto.punto,
             solotpto.codinssrv codinssrv,
             solotpto.cid cid,
             solotpto.descripcion,
             solotpto.direccion,
             solotpto.codubi
        FROM solotpto, inssrv
       WHERE (solotpto.codinssrv = inssrv.codinssrv)
         AND (inssrv.tipinssrv <> 6)
         AND (solotpto.codsolot = a_codsolot)
         AND solotpto.punto NOT IN
             (SELECT punto FROM preubi WHERE codsolot = a_codsolot)
      UNION ALL
      SELECT solotpto.punto,
             solotpto.codinssrv,
             solotpto.cid,
             solotpto.descripcion,
             solotpto.direccion,
             solotpto.codubi
        FROM solotpto
       WHERE solotpto.codINSSRV IS NULL
         AND (solotpto.codsolot = a_codsolot)
         AND solotpto.punto NOT IN
             (SELECT punto FROM preubi WHERE codsolot = a_codsolot);

  BEGIN
    -- Se llenan las ubi
    FOR lc1 IN cur_ubi LOOP
      INSERT INTO PREUBI
        (punto,
         codinssrv,
         cid,
         descripcion,
         dirobra,
         disobra,
         fecini,
         codsolot)
      VALUES
        (lc1.punto,
         lc1.codinssrv,
         lc1.cid,
         lc1.descripcion,
         lc1.direccion,
         lc1.codubi,
         SYSDATE,
         a_codsolot);
    END LOOP;
    -- Se deberian borrar los SIDs que no se encuentren en solotpto
    -- PENDIENTE

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;

  END;

  /*********************************************************************************************************************/
  /*********************************************************************************************************************/
  PROCEDURE P_Pre_Act_Material(a_codsolot solot.codsolot%TYPE) IS

    CURSOR cur_mat IS
      SELECT solotptoeta.codsolot,
             solotptoeta.punto,
             solotptoeta.codeta,
             slcpedmatdet.codmat
        FROM solotpto, solotptoeta, slcpedmatcab, slcpedmatdet
       WHERE (solotptoeta.codsolot = solotpto.codsolot)
         AND (solotptoeta.punto = solotpto.punto)
         AND (slcpedmatcab.nroped = slcpedmatdet.nroped)
         AND (slcpedmatcab.codsolot = solotpto.codsolot)
         AND (slcpedmatcab.punto = solotpto.punto)
         AND (slcpedmatcab.codeta = solotptoeta.codeta)
         AND (solotpto.codsolot = a_codsolot)
      MINUS
      SELECT a.codsolot, a.punto, b.codeta, a.codmat
        FROM solotptoetamat a, solotptoeta b
       WHERE a.codsolot = b.codsolot
         AND a.punto = b.punto
         AND a.orden = b.orden
         AND a.codsolot = a_codsolot;

  BEGIN

    UPDATE solotptoetamat p
       SET (canins_sol, canins_ate) = (SELECT SUM(b.canped), SUM(b.canate)
                                         FROM slcpedmatcab a,
                                              slcpedmatdet b,
                                              solotptoeta  c
                                        WHERE a.codsolot = c.codsolot
                                          AND a.punto = c.punto
                                          AND a.codeta = c.codeta
                                          AND p.codsolot = c.codsolot
                                          AND p.punto = c.punto
                                          AND p.orden = c.orden
                                          AND p.codmat = b.codmat
                                          AND a.nroped = b.nroped
                                          AND p.contrata = 0
                                          AND c.codsolot = a_codsolot)
     WHERE p.codsolot = a_codsolot;

    COMMIT;

  END;

  /*********************************************************************************************************************/
  PROCEDURE P_OF_ACT_MATERIAL(a_codsolot solot.codsolot%TYPE) IS

    CURSOR cur_mat IS
      SELECT *
        FROM solotptoetamat
       WHERE contrata = 0
         AND codsolot = a_codsolot;

    l_sol     NUMBER;
    l_ate     NUMBER;
    l_dev     NUMBER;
    l_sol_ant NUMBER;
    l_ate_ant NUMBER;
    l_dev_ant NUMBER;
    l_codmat  NUMBER;
    vSegsItem VARCHAR2(10);
    LN_COUNT  NUMBER;

  BEGIN

    FOR c IN cur_mat LOOP

      /*--Modificacion por el requerimiento 38647...
      \*     SELECT NVL(SUM(b.canped),0) ,NVL(SUM(b.canate),0) INTO l_sol_ant,  l_ate_ant
               FROM slcpedmatcab a,
                  slcpedmatdet b,
               solotptoeta e,
               solotptoetamat d
            WHERE a.codsolot = e.codsolot AND
                a.punto = e.punto AND
                a.codeta = e.codeta AND
                d.codsolot = e.codsolot AND
                d.punto = e.punto AND
                d.orden = e.orden AND
                d.codmat = b.codmat AND
                a.nroped = b.nroped AND
                d.contrata = 0 AND
                d.codsolot = c.codsolot AND
                d.punto = c.punto AND
                d.orden = c.orden AND
                d.idmat= c.idmat;

      --      FINANCIAL.SP_CREO_MANEJO_CANTIDADES(c.codsolot, c.punto, c.Orden, c.codmat, l_sol, l_ate, l_dev );

      \*    UPDATE solotptoetamat p SET
               canins_sol = NVL(l_sol, 0) + l_sol_ant,
               canins_ate = NVL(l_ate, 0) + l_ate_ant,
           canins_dev = NVL(l_dev, 0) + l_dev_ant
          WHERE
               p.codsolot = c.codsolot AND
               p.punto = c.punto AND
               p.orden = c.orden AND
               p.idmat = c.idmat;
      *\
      */
      SELECT REPLACE(a.campo1, '.', '')
        INTO vSegsItem
        FROM matope a
       WHERE a.codmat = c.codmat;
      IF vSegsItem IS NULL OR vSegsItem = '' THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'No se ha registrado el codigo del Oracle Financial');
      END IF;

      --CUST_PER_IN_PKG_INTERFASE_SGA.CUST_PER_IN_SP_MANEJO_CANTIDAD(c.codsolot,c.punto,c.Orden,vSegsItem ,l_sol,l_ate,l_dev);

      UPDATE solotptoetamat p
         SET canins_sol = NVL(l_sol, 0),
             canins_ate = NVL(l_ate, 0),
             canins_dev = NVL(l_dev, 0)
       WHERE p.codsolot = c.codsolot
         AND p.punto = c.punto
         AND p.orden = c.orden
         AND p.idmat = c.idmat;

    END LOOP;

    --Para todo lo antiguo, consultar en la tabla de resumen que vino de oracle:

    --Para todo lo nuevo con SAP:
    SELECT COUNT(*)
      INTO LN_COUNT
      FROM SOLOTPTOETAMAT
     WHERE CODSOLOT = a_codsolot
       AND CONTRATA = 0
       AND ID_SOL IS NOT NULL;

    IF LN_COUNT > 0 THEN
      FINANCIAL.PQ_Z_MM_RESERV_MISC.SP_ACT_CANT_ATEDEV_MAT(a_codsolot);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'Error Interface Oracle Financial-' + SQLERRM);

  END;

  PROCEDURE P_act_maestro_Series_equ(n_idalm out number) IS
    l_cont number;

  BEGIN

    --Se obtiene el idalm de inicio de proceso
    select min(idalm)
      into n_idalm
      from maestro_series_equ
     where flg_proceso = 0;
    --Actualizas el flg de proceso a los nuevos, dado q no existen estos nros de series
    update maestro_series_equ b
       set flg_proceso = 1, codusu = USER || ' - Insertado.'
     where b.flg_proceso = 0
       and not exists (select 1
              from maestro_series_equ a
             where trim(a.nroserie) = trim(b.nroserie)
               and trim(a.cod_sap) = trim(b.cod_sap)
               and a.flg_proceso = 1);
    --Actualizo la informacion antigua
    update maestro_series_equ a
       set (a.almacen, a.centro, a.codusu, a.equipo) = (select b.almacen,
                                                               b.centro,
                                                               USER ||
                                                               ' - Actualizado.',
                                                               b.equipo
                                                          from maestro_series_equ b
                                                         where b.flg_proceso = 0
                                                           and trim(b.nroserie) =
                                                               trim(a.nroserie)
                                                           and trim(b.cod_sap) =
                                                               trim(a.cod_sap)
                                                           and rownum = 1)
     where a.flg_proceso = 1
       and exists (select 1
              from maestro_series_equ c
             where trim(a.nroserie) = trim(c.nroserie)
               and trim(a.cod_sap) = trim(c.cod_sap)
               and c.flg_proceso = 0);
    --Elimino la información que ya existe
    delete maestro_series_equ z where z.flg_proceso = 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de actividad de una solotxpunto (Moneda:1 = Soles y 2 = Dolar / Permiso: 0 = Sin permiso y 1 = Con permiso)
  /*********************************************************************************************************************/
  FUNCTION f_sum_actxpuntoxorden(a_codsolot IN NUMBER,
                                 a_punto    IN NUMBER,
                                 a_orden    IN NUMBER,
                                 a_moneda   IN NUMBER,
                                 a_permiso  IN NUMBER,
                                 a_fase     IN NUMBER,
                                 a_area     IN NUMBER DEFAULT NULL)
    RETURN NUMBER IS
    l_costo NUMBER;
  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b, solotptoeta c
         WHERE a.codact = b.codact
           AND a.codsolot = c.codsolot
           AND a.punto = c.punto
           AND a.orden = c.orden
           AND b.espermiso = a_permiso
           AND c.codsolot = a_codsolot
           AND c.punto = a_punto
           AND c.orden = a_orden
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a, actividad b, solotptoeta c
         WHERE a.codact = b.codact
           AND a.codsolot = c.codsolot
           AND a.punto = c.punto
           AND a.orden = c.orden
           AND b.espermiso = a_permiso
           AND c.codsolot = a_codsolot
           AND c.punto = a_punto
           AND c.orden = a_orden
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.orden = a_orden
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetaact a,
               solotptoeta    e,
               actividad      b,
               etapa          c,
               etapaxarea     d
         WHERE a.codact = b.codact
           AND a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND b.espermiso = a_permiso
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.orden = a_orden
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  -- Funcion que obtiene el costo de materiales de SOLOT x punto x etapa(fase: 1=dise?o, 2=Instalacion, 3=Liquidacion, 4=Valorizacion) --
  /*********************************************************************************************************************/
  FUNCTION f_sum_matxpuntoxorden(a_codsolot IN NUMBER,
                                 a_punto    IN NUMBER,
                                 a_orden    IN NUMBER,
                                 a_moneda   IN NUMBER,
                                 a_fase     IN NUMBER,
                                 a_area     IN NUMBER DEFAULT NULL)
    RETURN NUMBER IS
    l_costo NUMBER;

  BEGIN
    IF a_area IS NULL THEN
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta b
         WHERE a.codsolot = b.codsolot
           AND a.punto = b.punto
           AND a.orden = b.orden
           AND b.codsolot = a_codsolot
           AND b.punto = a_punto
           AND b.orden = a_orden
           AND a.moneda_id = a_moneda;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta b
         WHERE a.codsolot = b.codsolot
           AND a.punto = b.punto
           AND a.orden = b.orden
           AND b.codsolot = a_codsolot
           AND b.punto = a_punto
           AND b.orden = a_orden
           AND a.moneda_id = a_moneda;
      END IF;
    ELSE
      IF a_fase = 1 OR a_fase = 2 THEN
        SELECT NVL(SUM(a.cosdis * a.candis), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.orden = a_orden
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      ELSIF a_fase = 3 OR a_fase = 4 THEN
        SELECT NVL(SUM(a.cosliq * a.canliq), 0)
          INTO l_costo
          FROM solotptoetamat a, solotptoeta e, etapa c, etapaxarea d
         WHERE a.codsolot = e.codsolot
           AND a.punto = e.punto
           AND a.orden = e.orden
           AND e.codeta = c.codeta
           AND c.codeta = d.codeta
           AND e.codsolot = a_codsolot
           AND e.punto = a_punto
           AND e.orden = a_orden
           AND a.moneda_id = a_moneda
           AND d.area = a_area;
      END IF;
    END IF;

    IF l_costo IS NULL THEN
      l_costo := 0;
    END IF;

    RETURN l_costo;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  /*********************************************************************************************************************/
  --Procedimiento que permite cargar la informacion de materiales a la Sot Basado en
  --formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
  --   REVISIONS:
  --   Ver        Date        Author           Description
  --   ---------  ----------  ---------------  ------------------------------------
  --   1.0        22/01/2009  Edilberto Astulle

  /*********************************************************************************************************************/
  PROCEDURE p_cargar_inf_formula(a_codsolot solot.codsolot%type) IS

    l_codfor    number;
    l_punto     number;
    l_punto_ori number;
    l_punto_des number;
    l_codeta    number;
    l_orden     number;
    l_cont_mat  number;
    l_cont_for  number;
    --Identificar Etapas
    Cursor cur_etapa is
      select distinct codeta codeta
        from operacion.matetapaxfor
       where codfor = l_codfor;
    --Registros identificados en base a la formula
    cursor cur_mat is
      SELECT matetapaxfor.codmat,
             matetapaxfor.cantidad,
             matetapaxfor.codeta,
             matope.costo,
             almtabmat.desmat,
             matope.moneda_id,
             matope.coduni,
             almtabmat.cod_sap,
             z_ps_val_busqueda_det.valor || ' ' ||
             z_ps_val_busqueda_det.descripcion componente
        FROM almtabmat, matetapaxfor, matope, z_ps_val_busqueda_det
       WHERE almtabmat.codmat = matope.codmat
         and z_ps_val_busqueda_det.valor(+) =
             NVL(almtabmat.componente, '@')
         and z_ps_val_busqueda_det.CODIGO(+) = 'TIPO_COMP'
         and almtabmat.codmat = matetapaxfor.codmat
         and matetapaxfor.codfor = l_codfor
         and matetapaxfor.codeta = l_codeta
         and matetapaxfor.tipo = 1; --v19.0

  BEGIN
    --Se Valida que tenga Formula
    select count(*)
      into l_cont_for
      from TIPTRABAJOXFOR a, solot b
     where a.tiptra = b.tiptra
       and codsolot = a_codsolot;
    if l_cont_for = 0 then
      RAISE_APPLICATION_ERROR(-20500,
                              'El tipo de Trabajo de la SOT no tiene asociado una formula.');
    end if;
    --Se elimina para los cosas que se necesita resetear la informacion de materiales
    delete solotptoetamat where codsolot = a_codsolot;
    delete solotptoeta where codsolot = a_codsolot;
    --Se identifica la formula
    --Inicio 30.0
    select codfor into l_codfor
    from TIPTRABAJOXFOR a, solot b
    where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv
    and codsolot = a_codsolot ;
    --Fin 30.0
    --Se identificar el punto principal
    operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,
                                      l_punto,
                                      l_punto_ori,
                                      l_punto_des);
    --Cargar etapas a la SOT : SOLOTPTOETA
    for c_e in cur_etapa loop
      l_codeta := c_e.codeta;
      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from SOLOTPTOETA
       where codsolot = a_codsolot
         and punto = l_punto;
      --Genera la etapa en estado 15 : PreLiquidacion
      insert into solotptoeta
        (codsolot, punto, orden, codeta, porcontrata, esteta)
      values
        (a_codsolot, l_punto, l_orden, c_e.codeta, 1, 15);
      --Cargar info de materiales en base a la etapa
      for c_m in cur_mat loop
        insert into solotptoetamat
          (codsolot,
           punto,
           orden,
           codmat,
           canliq,
           cosliq,
           codfas,
           Moneda_Id,
           flg_depurar,
           observacion)
        values
          (a_codsolot,
           l_punto,
           l_orden,
           c_m.codmat,
           c_m.cantidad,
           c_m.costo,
           3,
           c_m.moneda_id,
           0,
           'ITTELMEX-MAT-HFC');
      end loop;
    end loop;
  END;

  /*********************************************************************************************************************/
  --Procedimiento que permite cargar automaticamente la informacion de STB y EMTA del Intraway a SGA
  --   REVISIONS:
  --   Ver        Date        Author           Description
  --   ---------  ----------  ---------------  ------------------------------------
  --   1.0        22/01/2009  Edilberto Astulle

  /*********************************************************************************************************************/
  PROCEDURE p_depurar_materiales(a_codsolot solot.codsolot%type) IS

    l_codsolot number;
    l_codeta   number;
    --Leer materiales de sot
    Cursor cur_sot_mat is
      select * from solotptoetamat where codsolot = a_codsolot;

  begin
    l_codsolot := a_codsolot;
    --Set Top Box
    for c_m in cur_sot_mat loop
      if c_m.flg_depurar = 0 then
        delete solotptoetamat where IDMAT = c_m.idmat;
      END IF;
    end loop;

  END;

  /*********************************************************************************************************************/
  --Procedimiento que permite liquidar las lineas de control de costos por etapa,
  --antes de liquidar las lineas se verifica que el servicio de la sot se encuentre activa
  --y que se haya registrado el Cintillo
  --   REVISIONS:
  --   Ver        Date        Author           Description
  --   ---------  ----------  ---------------  ------------------------------------
  --   1.0        22/01/2009  Edilberto Astulle
  --Validar Servicio activado
  --Cintillo registrado
  --Acta de Instalacion
  /*********************************************************************************************************************/
  PROCEDURE p_liquidar_materiales(a_codsolot solot.codsolot%type) IS
    l_cont          number;
    l_cont_cintillo number;
    l_cont_acta     number;
  begin
    --Se valida que el servicio este activo
    select count(*)
      into l_cont
      from inssrv
     where codinssrv in
           (select codinssrv from solotpto where codsolot = a_codsolot)
       and estinssrv = 1;
    if l_cont = 0 then
      --NO estan activos los servicios
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que el servicio aun no esta Activo.');
    else
      --Esta activo al menos un servicio
      null;
    end if;
    --Se valida que la contrata registre el Cintillo
    select count(*)
      into l_cont_cintillo
      from solotpto
     where codsolot = a_codsolot
       and cintillo is not null;
    if l_cont_cintillo = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que no tiene registrado el Cintillo.');
    end if;
    --Se valida que la contrata registre el Cintillo con mas d 6 digitos
    select count(*)
      into l_cont_cintillo
      from solotpto
     where codsolot = a_codsolot
       and length(cintillo) > 6;
    if l_cont_cintillo = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que el Cintillo debe tener mas de 6 digitos.');
    end if;
    --Validacion del Acta de Instalación
    select count(*)
      into l_cont_acta
      from solotpto_id
     where codsolot = a_codsolot
       and acta_instalacion is not null;
    if l_cont_acta = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que no tiene registrado el Acta de Instalación.');
    end if;

    --Actualiza las lineas de SOLOTPTOETA, a estado Liquidado : 3
    update solotptoeta set esteta = 3 where codsolot = a_codsolot;

  END;

  PROCEDURE p_reg_equipos_stb_emta(a_fecha date) IS
    /*********************************************************************************************************************/
    --Procedimiento que permite cargar automaticamente la informacion de STB y EMTA del Intraway a SGA
    /*Registro automatico de Equipos STB y Emta
    Se genera automaticamente en base al proceso Intraway se genera informacion para SetTopBox y EMTA
    --   REVISIONS:
    --   Ver        Date        Author           Description
    --   ---------  ----------  ---------------  ------------------------------------
    --   1.0        22/01/2009  Edilberto Astulle
    */
    l_codsolot     number;
    l_codeta       number;
    l_punto        number;
    l_punto_ori    number;
    l_punto_des    number;
    l_orden        number;
    l_tipequ       number;
    l_conteta      number;
    v_observacion  varchar2(200);
    v_email        varchar2(4000);
    l_cont_equipos number;
    --ini 26.0
    ln_idagenda    number;
    --fin 26.0
    -- Servicios Set Top Box2020  y Emta 620 y 820
    Cursor cur_equipos is
    --stb
      select 'STB' TIPO,
             (select count(*) from solotpto where pid = s.pid_sga) ContPtosSot_PID,
             (select descripcion
                from tiptrabajo
               where tiptra =
                     (select tiptra from solot where codsolot = s.codsolot)) TipoTrabajo,
             (select count(*) from solotptoequ where codsolot = s.codsolot) ContEquipos,
             codsolot,
             upper(s.macaddress) NroSerie,
             b.componente,
             (select count(*)
                from operacion.maestro_series_equ
               where upper(trim(nroserie)) = upper(s.macaddress)) ExisteNroSerie,
             (select punto
                from solotpto
               where codsolot = s.codsolot
                 and s.pid_sga = solotpto.pid) punto,
             s.fecha_creacion,
             (select min(feceje) from trssolot where codsolot = s.codsolot) fecha_activacion_trs, -- s.codusu,
             c.tipequ tipequ,
             c.descripcion,
             c.costo costo,
             b.cod_sap
        FROM intraway.INT_SERVICIO_INTRAWAY s,
             operacion.maestro_series_equ   a,
             almtabmat                      b,
             tipequ                         c
       WHERE ID_INTERFASE = 2020
         and macaddress is not null
         and trim(upper(s.macaddress)) = upper(trim(a.nroserie(+)))
         and trim(a.cod_sap) = trim(b.cod_sap(+))
         and trim(b.codmat) = trim(c.codtipequ(+))
         and (to_char((select min(feceje)
                        from trssolot
                       where codsolot = s.codsolot),
                      'yyyymmdd') = to_char(a_fecha, 'yyyymmdd'))
      union all --emta
      select 'EMTA',
             (select count(*) from solotpto where pid = pid_sga) ContPtosSot_PID,
             (select descripcion
                from tiptrabajo
               where tiptra =
                     (select tiptra from solot where codsolot = sot_min)) TipoTrabajo,
             (select count(*) from solotptoequ where codsolot = sot_min) ContEquipos,
             sot_min codsolot,
             serial_id,
             b.componente,
             (select count(*)
                from operacion.maestro_series_equ
               where upper(trim(nroserie)) = upper(serial_id)) ExisteNroSerie,
             (select punto
                from solotpto
               where codsolot = sot_min
                 and pid = pid_sga) punto,
             fec_creacion,
             (select min(feceje) from trssolot where codsolot = x.sot_min) fecha_activacion_trs,
             c.tipequ tipequ,
             c.descripcion,
             c.costo costo,
             b.cod_sap
        from (select serial_id,
                     cmac_address,
                     mta_mac_address,
                     (count(*)),
                     min(s.fecha_creacion) fec_creacion,
                     min(s.codsolot) sot_min,
                     min(s.pid_sga) pid_sga
                from operacion.data_emta, intraway.INT_SERVICIO_INTRAWAY s
               where cmac_address =
                     trim(upper(replace(replace(s.macaddress, ':', ''),
                                        '.',
                                        '')))
                  or mta_mac_address =
                     trim(upper(replace(replace(s.macaddress, ':', ''),
                                        '.',
                                        '')))
                 and s.macaddress is not null
                 and s.ID_INTERFASE IN (620, 820)
               group by serial_id, cmac_address, mta_mac_address) x,
             operacion.maestro_series_Equ a,
             almtabmat b,
             tipequ c
       where exists
       (select 'z'
                from operacion.maestro_series_Equ
               where upper(trim(nroserie)) = upper(x.serial_id))
         and trim(upper(x.serial_id)) = upper(trim(a.nroserie(+)))
         and trim(a.cod_sap) = trim(b.cod_sap(+))
         and trim(b.codmat) = trim(c.codtipequ(+))
         and (to_char((select min(feceje)
                        from trssolot
                       where codsolot = x.sot_min),
                      'yyyymmdd') = to_char(a_fecha, 'yyyymmdd'))
       order by 4 asc, 5 asc;
  begin

    v_email := '';
    --Carga de Equipos
    for c_s in cur_equipos loop
      v_observacion := '';
      --Verificar el Punto de la SOT a la que se asignará el equipo
      l_codsolot := c_s.codsolot;
      l_punto    := c_s.punto;
      if l_punto is null then
        operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,
                                          l_punto,
                                          l_punto_ori,
                                          l_punto_des);
      END IF;
      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from solotptoequ
       where codsolot = l_codsolot
         and punto = l_punto;

      if c_s.tipequ is null then
        l_tipequ := 5998;
      else
        l_tipequ := c_s.tipequ;
      end if;
      if c_s.ExisteNroSerie = 0 then
        --El Nro de Serie no existe
        v_observacion := v_observacion || 'Falta Serie en BD.';
      else
        --Seleccionar la Etapa respectiva
        --Set Top Box y Emta Siempre apunta a Etapa : Cliente - CPE
        l_codeta := 647;
      end if;
      select count(*)
        into l_cont_equipos
        from solotptoequ
       where codsolot = l_codsolot
         and trim(numserie) = trim(c_s.nroserie);
      if l_cont_equipos = 0 then
      -- ini 26.0
      select max(idagenda) into ln_idagenda from agendamiento where codsolot = l_codsolot;
      --fin 26.0

        --No esta registrado el Equipo en la SOT
        insert into solotptoequ
          (codsolot,
           punto,
           orden,
           tipequ,
           CANTIDAD,
           TIPPRP,
           COSTO,
           NUMSERIE,
           flgsol,
           flgreq,
           codeta,
           tran_solmat,
           observacion,
           fecfdis,
           -- ini 26.0
           idagenda )
           -- fin 26.0

        values
          (l_codsolot,
           l_punto,
           l_orden,
           l_tipequ,
           1,
           0,
           nvl(c_s.costo, 0),
           c_s.NroSerie,
           1,
           0,
           l_codeta,
           null,
           v_observacion || 'ITTELMEX-EQU-HFC',
           c_s.fecha_creacion,
           -- ini 26.0
           ln_idagenda);
           -- fin 26.0

        if length(v_observacion) > 0 then
          --Si existe observacion se envia un email
          null;
          --          v_email := v_email ||chr(32) ||to_char(l_codsolot) ||chr(32)|| c_s.NroSerie || chr(32) || v_observacion ||  chr(13);
        end if;
      end if;
    end loop;
    P_ENVIA_CORREO_DE_TEXTO_ATT('Registrar Equipos Intraway',
                                'DL - PE - Carga Equipos Intraway SGA',
                                v_email);

  END;

  PROCEDURE p_reg_equipos_router(a_codsolot solot.codsolot%type,
                                 a_punto    solotpto.punto%type,
                                 a_nroserie solotptoequ.numserie%type,
                                 a_cod_sap  almtabmat.cod_sap%type) IS
    /*********************************************************************************************************************/
    --Procedimiento que permite cargar el router
    --Se genera automaticamente en base al proceso Intraway se genera informacion para SetTopBox y EMTA
    --   REVISIONS:
    --   Ver        Date        Author           Description
    --   ---------  ----------  ---------------  ------------------------------------
    --   1.0        03/03/2009  Edilberto Astulle*/
    l_tipequ          number;
    v_nroserie        varchar2(400);
    v_cod_sap        almtabmat.Cod_Sap%type;--33.0
    l_cont            number;
    l_codeta          number;
    n_costo           tipequ.costo%type;
    l_orden           number;
    l_cont2           number;
    v_observacion     varchar2(200); --<9>
    l_ExisEquAlmacen  number; --<9>
    l_codcon          number; --<9>
    l_EquRouterUsado  number; --<14>
    n_codsolot_router number; --<14>

  begin

    delete solotptoequ
     where codsolot = a_codsolot
       and flg_ingreso = 1; --Eliminar los equipos de la mesa de validacion
    if a_cod_sap is not null then
      --Codigo Sap diferente de nul
      select count(*)
        into l_cont2
        from maestro_Series_equ
       where trim(nroserie) = trim(a_nroserie)
         and trim(cod_sap) = trim(a_cod_sap);
      if l_cont2 = 0 then
        RAISE_APPLICATION_ERROR(-20500,
                                'El Número de Serie no existe en la BD.');
      elsif l_cont > 1 then
        --El numero de serie esta repetido
        RAISE_APPLICATION_ERROR(-20500,
                                'El Numero de serie y el Codigo SAP se repite, depurar información de Números de Serie.');
      else
        select TRIM(a.nroserie), TRIM(a.cod_sap), c.tipequ, c.costo
          into v_nroserie, v_cod_sap, l_tipequ, n_costo
          from maestro_Series_equ a, almtabmat b, tipequ c
         where trim(nroserie) = trim(a_nroserie)
           and c.codtipequ = b.codmat
           and trim(a.cod_sap) = trim(b.cod_sap);
      end if;
    else
      --Codigo Sap es nulo
      if a_nroserie is null then
        RAISE_APPLICATION_ERROR(-20500,
                                'Ingrese un Número de Serie por favor.');
      else
        select count(*)
          into l_cont
          from maestro_Series_equ
         where trim(nroserie) = trim(a_nroserie);
        if l_cont = 0 then
          --No existe el Nro de serie en la BD
          RAISE_APPLICATION_ERROR(-20500,
                                  'El Número de Serie no existe en la BD.');
        elsif l_cont > 1 then
          --El numero de serie esta repetido
          RAISE_APPLICATION_ERROR(-20500,
                                  'Registrar el Codigo SAP por favor, el Numero de serie esta asociado a mas de un Equipo SAP.');
        else
          --
          select TRIM(a.nroserie), TRIM(a.cod_sap), c.tipequ, c.costo
            into v_nroserie, v_cod_sap, l_tipequ, n_costo
            from maestro_Series_equ a, almtabmat b, tipequ c
           where trim(nroserie) = trim(a_nroserie)
             and c.codtipequ = b.codmat
             and trim(a.cod_sap) = trim(b.cod_sap);
        end if;
      end if;
    end if;

    --l_codeta := 647; --Cliente CPE <9>

    --  select TIPEQU.tipequ,TIPEQU.costo into l_tipequ,n_costo from tipequ, almtabmat
    --  where tipequ.codtipequ = almtabmat.codmat and
    --  almtabmat.cod_sap = v_cod_sap;
    --<9 Seleccionar la Etapa respectiva en base a la configuracion, 197 : configuracion codigosap etapa
    select codigon
      into l_codeta
      from opedd
     where tipopedd = 197
       and trim(codigoc) = trim(a_cod_sap);
    v_observacion    := 'ITTELMEX-EQU-HFC';
    l_ExisEquAlmacen := f_verificar_almacen_equ(a_codsolot,
                                                a_punto,
                                                a_nroserie,
                                                a_cod_sap); --99445
    if l_ExisEquAlmacen = 0 then
      v_observacion := 'ITTELMEX-EQU-HFC.El Equipo No se encuentra en el Almacen de la Contrata.'; --99445
    end if;
    --9>

    --<14
    select count(1)
      into l_EquRouterUsado
      from solotptoequ
     where numserie = v_nroserie
       and tipequ = l_tipequ
       and flg_despacho = 0;
    if l_EquRouterUsado > 0 then
      select max(codsolot)
        into n_codsolot_router
        from solotptoequ
       where numserie = v_nroserie
         and tipequ = l_tipequ
         and flg_despacho = 0;
      RAISE_APPLICATION_ERROR(-20500,
                              'El Router ha sido utilizado en la SOT : ' ||
                              to_char(n_codsolot_router));
    end if;
    --14>

    SELECT NVL(MAX(ORDEN), 0) + 1
      INTO l_orden
      from solotptoequ
     where codsolot = a_codsolot
       and punto = a_punto;
    insert into solotptoequ
      (codsolot,
       punto,
       orden,
       tipequ,
       CANTIDAD,
       TIPPRP,
       COSTO,
       NUMSERIE,
       flgsol,
       flgreq,
       codeta,
       tran_solmat,
       observacion,
       fecfdis,
       flg_ingreso)
    values
      (a_codsolot,
       a_punto,
       l_orden,
       l_tipequ,
       1,
       0,
       nvl(n_costo, 0),
       v_nroserie,
       1,
       --<9 0,l_codeta,null,'ITTELMEX-EQU-HFC' ,sysdate,1);
       0,
       l_codeta,
       null,
       v_observacion,
       sysdate,
       1);

    update solotptoequ
       set valida_almacen = f_verificar_almacen_equ(a_codsolot,
                                                    a_punto,
                                                    v_nroserie,
                                                    a_cod_sap)
     where codsolot = a_codsolot
       and punto = a_punto
       and orden = l_orden;
    --9>

  END;

  procedure p_cargar_info_equ_intraway(a_codsolot in number,a_idagenda number default null) IS
  BEGIN
    null;
  END;

  /*********************************************************************************************************************/
  --Procedimiento para descargar los equipos de DTH en SOLOTPTOEQU despues de generar el proyecto
  --
  --   REVISIONS:
  --   Ver        Date        Author           Description
  --   ---------  ----------  ---------------  ------------------------------------
  --   1.0        03/03/2009  --

  /*********************************************************************************************************************/

  /*<10.0 PROCEDURE p_cargar_info_equ_dth(a_codsolot solot.codsolot%type)*/
  PROCEDURE p_cargar_info_equ_dth(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) --10.0>
   IS
    v_observacion    varchar2(200);
    l_punto          number;
    l_punto_ori      number;
    l_punto_des      number;
    l_orden          number;
    l_tipequ         number;
    l_codeta         number;
    l_cont_equipos   number;
    l_estado         number;
    l_ExisteNroSerie number; --<10.0>
    l_codsolot       solot.codsolot%type; --<10.0>
    v_numregistro    reginsdth.numregistro%type; --<10.0>
    cursor cur_dth is
    --<10.0
    /*select a.fecreg, b.idpaq,a.numregistro, a.codsolot, a.codcon, a.codinssrv,a.pid, b.serie,b.unitaddress,
                (select count(*) from operacion.maestro_series_equ where upper(trim(nroserie)) = upper(b.serie) ) ExisteNroSerie,
                b.tipequope,   d.codmat,(select desmat from almtabmat where codmat = d.codmat)  desmat,
                d.cod_sap, d.componente , b.cantidad, d.preprm_usd costo, d.moneda_id,
                (select count(*) from matope where upper(trim(codmat)) = upper(trim(d.codmat)) ) ExisteenMatOpe
                from reginsdth a,equiposdth b , tipequ c, almtabmat d
                where a.codsolot = a_codsolot
                and a.numregistro = b.numregistro
                and trim(b.tipequope) = trim(c.tipequ(+))
                and trim(c.codtipequ) = trim(d.codmat(+));

                --Identificar Etapas : Tipo 197 : OP-Conf EquMat-Etapa HFCDTH
                Cursor cur_etapa is
                select distinct codigon codeta from opedd where tipopedd = 197;*/
      select d.fecreg,
             a.numregistro,
             a.tipequope,
             a.serie,
             c.codmat,
             c.desmat,
             c.cod_sap,
             b.costo,
             a.cantidad,
             (SELECT count(*)
                FROM OPEDD
               WHERE TIPOPEDD = 201
                 AND ABREVIACION = 'DTH'
                 and trim(codigoc) = trim(c.cod_sap)) Seriable,
             (select codigon
                from opedd
               where tipopedd = 197
                 and trim(codigoc) = trim(c.cod_sap)) codeta,
             a.unitaddress,
             a.codequcom --<12.0>
        from equiposdth a, tipequ b, almtabmat c, reginsdth d
       where a.numregistro = v_numregistro
         and a.tipequope = b.tipequ
         and b.codtipequ = c.codmat
         and a.numregistro = d.numregistro;

  BEGIN
    --<10.0
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select max(numregistro)
      into v_numregistro
      from reginsdth
     where codsolot = l_Codsolot; --10.0>
    --Verificar el Punto de la SOT a la que se asignará el equipo
    if l_punto is null then
      operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,
                                        l_punto,
                                        l_punto_ori,
                                        l_punto_des);
    END IF;

    --Primero se registra informacion de equipos
    for c_e in cur_dth loop
      -- if c_e.ExisteenMatOpe = 0 then -- si no existe en MATOPE lo tomamos como EQUIPO <10.0>
      v_observacion := '';

      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from solotptoequ
       where codsolot = l_codsolot
         and punto = l_punto;
      if c_e.tipequope is null then
        --l_tipequ := 7113;
        l_tipequ := 8450; --<10.0>
      else
        l_tipequ := c_e.tipequope;
      end if;
      /*<10.0 if c_e.ExisteNroSerie = 0  then --El Nro de Serie no existe
            v_observacion := v_observacion || 'Falta Serie en BD.';
         else
           --Seleccionar la Etapa respectiva en base a la configuracion
           --197 : configuracion codigosap etapa
           select codigon into l_codeta from opedd where tipopedd = 197
           and trim(codigoc) = trim(c_e.cod_sap);
         end if;

         select count(*) into l_cont_equipos from solotptoequ where
         codsolot = a_codsolot and trim(numserie) = trim(c_e.serie);
         if l_cont_equipos = 0 then --No esta registrado el Equipo en la SOT
            l_estado:=4;
            if length(v_observacion) > 0 then --Si existe observacion se envia un email
               P_ENVIA_CORREO_DE_TEXTO_ATT('Registrar Equipos DTH', 'DL - PE - Carga Equipos Intraway SGA', v_observacion);
               l_estado := 9;
            end if;
            insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,COSTO,NUMSERIE,flgsol,
            flgreq,codeta,tran_solmat,observacion,fecfdis,estado)
            values(a_codsolot,l_punto,l_orden,l_tipequ,1,0,nvl(c_e.costo,0),c_e.Serie,1,
            0,l_codeta,null,v_observacion || 'ITTELMEX-EQU-DTH' ,c_e.fecreg,l_estado);
         end if;
       --end if;<10.0>
      end loop;

      for c_eta in cur_etapa loop
         SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from SOLOTPTOETA
         where codsolot = a_codsolot and punto = l_punto;
         --Genera la etapa en estado 15 : PreLiquidacion
         insert into solotptoeta(codsolot,punto,orden,codeta,porcontrata,esteta)
         values(a_codsolot,l_punto,l_orden,c_eta.codeta,1,15);
         --Cargar info de materiales en base a la etapa
         for c_m in cur_dth loop
            if c_m.ExisteenMatOpe = 1 then --Si existe en MATOPE es material
               --Seleccionar la Etapa respectiva en base a la configuracion
               --197 : configuracion codigosap etapa
               select count(*) into l_cont_eta from opedd where tipopedd = 197
               and trim(codigoc) = trim(c_m.cod_sap);
               if l_cont_eta = 1 then
                 select codigon into l_codeta from opedd where tipopedd = 197
                 and trim(codigoc) = trim(c_m.cod_sap);
                 if l_codeta = c_eta.codeta then
                   insert into solotptoetamat(codsolot,punto,orden,codmat,canliq,cosliq,
                   codfas,Moneda_Id,flg_depurar,observacion)
                   values(a_codsolot,l_punto,l_orden,c_m.codmat,c_m.cantidad,c_m.costo,3,
                   c_m.moneda_id,0,'ITTELMEX-MAT-DTH');
                 end if;
               else --No esta configurado la etapa en Tipopedd = 197
                 P_ENVIA_CORREO_DE_TEXTO_ATT('Registrar Materiales DTH', 'DL - PE - Carga Equipos Intraway SGA', 'El Material no esta configurado CodSap : ' ||trim(c_m.cod_sap) );
               end if;
            end if;
         end loop;*/
      l_codeta := c_e.codeta;
      l_estado := 4; --Instalado
      if l_codeta > 0 then
        if c_e.seriable = 1 then
          --Se verifica si el equipo se controla el Número de Serie EQUIPOS
          select count(*)
            into l_ExisteNroSerie
            from maestro_Series_equ m
           where trim(m.nroserie) = trim(c_e.serie)
             and trim(m.cod_sap) = trim(c_e.cod_sap);
          if l_ExisteNroSerie = 0 then
            --El Nro de Serie no existe
            l_estado := 9; --No existe Nro Serie en BD
            P_ENVIA_CORREO_DE_TEXTO_ATT('Registrar Equipos DTH',
                                        'DL - PE - Carga Equipos Intraway SGA',
                                        v_observacion);
            v_observacion := v_observacion || 'Falta Serie en BD.';
          end if;
          --Verificacion del Equipo en la SOT
          select count(*)
            into l_cont_equipos
            from solotptoequ
           where codsolot = l_Codsolot
             and trim(numserie) = trim(c_e.serie);
          if l_cont_equipos = 0 then
            --No esta registrado el Equipo en la SOT
            insert into solotptoequ
              (codsolot,
               punto,
               orden,
               tipequ,
               CANTIDAD,
               TIPPRP,
               COSTO,
               NUMSERIE,
               flgsol,
               flgreq,
               codeta,
               tran_solmat,
               observacion,
               fecfdis,
               estado,
               mac,
               codequcom) --<12.0>
            values
              (l_Codsolot,
               l_punto,
               l_orden,
               l_tipequ,
               c_e.cantidad,
               0,
               nvl(c_e.costo, 0),
               c_e.Serie,
               1,
               0,
               l_codeta,
               null,
               v_observacion || 'ITTELMEX-EQU-DTH',
               c_e.fecreg,
               l_estado,
               c_e.unitaddress,
               c_e.codequcom); --<12.0>
          end if;
        else
          --MATERIALES son NO Seriables
          --Verificacion del Material en la SOT
          select count(*)
            into l_cont_equipos
            from solotptoequ
           where codsolot = l_Codsolot
             and trim(tipequ) = trim(c_e.tipequope);
          l_cont_equipos := 0;
          if l_cont_equipos = 0 then
            --No esta registrado el Material en la SOT
            insert into solotptoequ
              (codsolot,
               punto,
               orden,
               tipequ,
               CANTIDAD,
               TIPPRP,
               COSTO,
               NUMSERIE,
               flgsol,
               flgreq,
               codeta,
               tran_solmat,
               observacion,
               fecfdis,
               estado,
               mac,
               codequcom) --<12.0>
            values
              (l_Codsolot,
               l_punto,
               l_orden,
               l_tipequ,
               c_e.cantidad,
               0,
               nvl(c_e.costo, 0),
               c_e.serie,
               1,
               0,
               l_codeta,
               null,
               'ITTELMEX-MAT-DTH',
               c_e.fecreg,
               l_estado,
               c_e.unitaddress,
               c_e.codequcom); --<12.0>
          end if;
        end if;
      end if; --10.0>
    end loop;

  END;

  PROCEDURE p_valorizar_liquidacion(n_idliq    number,
                                    n_codsolot number,
                                    n_punto    number,
                                    n_orden    number)

   IS
    l_cont     number;
    ld_costo   decimal(10, 4);
    l_punto    number;
    l_orden    number;
    l_codsolot number;
    Cursor CurPto is
      select * from solotptoeta where idliq = n_idliq;
    Cursor CurAct is
      select *
        from solotptoetaact
       where codsolot = l_codsolot
         and punto = l_punto
         and orden = l_orden;
    Cursor CurMat is
      select *
        from solotptoetamat
       where codsolot = l_codsolot
         and punto = l_punto
         and orden = l_orden;
  BEGIN

    --Valorizar Actividades
    for lc_pto in CurPto loop
      l_punto    := lc_pto.punto;
      l_orden    := lc_pto.orden;
      l_codsolot := lc_pto.codsolot;
      Update solotptoeta
         Set esteta = 5, fecval = sysdate
       Where CodSolot = l_codsolot
         and Punto = l_punto
         and Orden = l_orden;
      --Valorizar Actividades
      for lc_act in CurAct loop
        If 1 = 1 or lc_act.codprecliq is null or lc_act.codprecliq = 0 Then
          BEGIN
            Select costo
              into ld_costo
              from actxpreciario
             Where codact = lc_act.codact
               And codprec = lc_act.codprecdis;

            Update solotptoetaact
               set cosliq = ld_costo
             Where codsolot = l_codsolot
               And punto = l_punto
               And orden = l_orden
               And codact = lc_act.codact;
            if lc_act.codprecliq is null or lc_act.codprecliq = 0 then
              Update solotptoetaact
                 set codprecliq = lc_act.codprecdis, contrata = 1
               Where codsolot = l_codsolot
                 And punto = l_punto
                 And orden = l_orden
                 And codact = lc_act.codact;
            end if;
            if lc_act.canliq = 0 then
              Update solotptoetaact
                 set canliq = lc_act.candis
               Where codsolot = l_codsolot
                 And punto = l_punto
                 And orden = l_orden
                 And codact = lc_act.codact;
            end if;
          Exception
            when others then
              null;
          END;
        End If;
      end loop;

      --Valorizar Materiales
      For lc_mat in curMat loop
        If 1 = 1 or lc_mat.cosliq = 0 or lc_mat.cosliq is null then
          BEGIN
            Select costo
              into ld_costo
              from matope
             Where codmat = lc_mat.codmat;
            Update solotptoetamat
               set cosliq = ld_costo
             Where codsolot = l_codsolot
               And punto = l_punto
               And orden = l_orden
               And codmat = lc_mat.codmat;
            commit;
          Exception
            when others then
              null;
          END;
        End If;
      End loop;
    End loop;

  END;
  --<8
  --PROCEDURE p_importar_sot_etapa(n_idliq number, n_codsolot number, n_codeta number)
  PROCEDURE p_importar_sot_etapa(n_idliq    number,
                                 n_codsolot number,
                                 n_punto    number,
                                 n_orden    number)
  --8>
   IS
    l_cont number;

  BEGIN

    update solotptoeta
       set idliq = n_idliq
     where codsolot = n_codsolot
          --<8
          --and codeta = n_codeta;
       and punto = n_punto
       and orden = n_orden;
    --8>
    --<29.0
    update sot_liquidacion
       set tota_valoriz = (select sum(t.canliq * t.cosliq)
                            from solotptoeta s, solotptoetaact t
                           where s.codsolot = t.codsolot
                             and s.orden = t.orden
                             and s.punto = t.punto
                             and s.idliq = n_idliq)
     where idliq = n_idliq;
    --29.0>
  END;

  PROCEDURE p_importar_sot_etapa_liq(n_idliq number, n_codsolot number) IS
    l_cont number;

  BEGIN

    update solotptoeta
       set idliq = n_idliq
     where codsolot = n_codsolot
       and codcon in
           (select codcon from sot_liquidacion where idliq = n_idliq);

  END;

  PROCEDURE P_act_maestro_Series_mac1(n_idalm out number) IS
    l_cont number;

  BEGIN

    --Se obtiene el idalm de inicio de proceso
    select min(idalm)
      into n_idalm
      from maestro_series_equ
     where flg_proceso = 0;
    --Actualizas el flg de proceso a los nuevos, dado q no existen estos nros de series
    update maestro_series_equ b
       set flg_proceso = 2, codusu = USER || ' - Insertado.'
     where b.flg_proceso = 0
       and not exists (select 1
              from maestro_series_equ a
             where trim(a.nroserie) = trim(b.nroserie)
               and trim(a.cod_sap) = trim(b.cod_sap)
               and a.flg_proceso = 1);
    --Actualizo la informacion antigua
    update maestro_series_equ a
       set (a.MAC1, a.MAC2, a.MAC3) = --<17.0> se agrego mac2 y mac3
            (select b.MAC1, b.MAC2, b.MAC3
               from maestro_series_equ b --<17.0> se agrego mac2 y mac3
              where b.flg_proceso = 0
                and trim(b.nroserie) = trim(a.nroserie)
                and trim(b.cod_sap) = trim(a.cod_sap)
                and rownum = 1)
     where a.flg_proceso = 1
       and exists (select 1
              from maestro_series_equ c
             where trim(a.nroserie) = trim(c.nroserie)
               and trim(a.cod_sap) = trim(c.cod_sap)
               and c.flg_proceso = 0);
    --Elimino la información que ya existe
    delete maestro_series_equ z where z.flg_proceso = 0;
    delete maestro_series_equ z where z.flg_proceso = 2;

  END;

  PROCEDURE p_cargar_formula_act_mat(a_codsolot solot.codsolot%type,
                                     a_punto    solotpto.punto%type) IS

    l_codfor     number;
    l_punto      number;
    l_punto_ori  number;
    l_punto_des  number;
    l_codeta     number;
    l_codcon     number;
    l_orden      number;
    l_cont_for   number;
    l_cont_etapa number;
    --Identificar Etapas
    Cursor cur_etapa is
      SELECT DISTINCT CODETA FROM ACTETAPAXFOR WHERE CODFOR = l_codfor;

    --Actividades Registros identificados en base a la formula
    cursor cur_act is
      select a.codact,
             a.cantidad,
             a.codeta,
             b.costo,
             b.moneda_id,
             b.codprec
        from ACTETAPAXFOR a, actxpreciario b
       where a.codfor = l_codfor
         and a.codact = b.codact
         and b.activo = '1'
         and a.codeta = l_codeta;

    --Materiales identificados en base a la formula
    cursor cur_mat is
      SELECT matetapaxfor.codmat,
             tipequ.tipequ,
             tipequ.estequ,
             matetapaxfor.cantidad,
             matetapaxfor.codeta,
             almtabmat.Preprm_Usd,
             almtabmat.desmat,
             almtabmat.moneda_id,
             almtabmat.codund,
             almtabmat.cod_sap
        FROM almtabmat, matetapaxfor, tipequ
       WHERE almtabmat.codmat = matetapaxfor.codmat
         and almtabmat.codmat = tipequ.codtipequ
         and matetapaxfor.codfor = l_codfor
         and tipequ.estequ = 1
         and matetapaxfor.tipo = 1;--<20.0>

  BEGIN
    --Se Valida que tenga Formula
    select count(*)
      into l_cont_for
      from TIPTRABAJOXFOR a, solot b
     where a.tiptra = b.tiptra
       and codsolot = a_codsolot;
    if l_cont_for = 0 then
      RAISE_APPLICATION_ERROR(-20500,
                              'El tipo de Trabajo de la SOT no tiene asociado una formula.');
    end if;
    --Se elimina para las actividades instanciadas
    delete from solotptoequ
     where codsolot = a_codsolot
       and FLG_INGRESO = 2; --2 : Por proceso interno de carga masiva
    delete from solotptoetaact where codsolot = a_codsolot;
    delete from solotptoeta
     where codsolot = a_codsolot
       and obs = 'ITTELMEX-ACT-HFC';
    --Se identifica la formula
    --Inicio 30.0
    select codfor into l_codfor
    from TIPTRABAJOXFOR a, solot b
    where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv
    and codsolot = a_codsolot ;
    --Fin 30.0

    --Se identificar el punto principal
    operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,
                                      l_punto,
                                      l_punto_ori,
                                      l_punto_des);
    --Cargar Actividades a la SOT : SOLOTPTOETAACT y SOLOTPTOETA
    for c_e in cur_etapa loop
      l_codeta := c_e.codeta;
      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from SOLOTPTOETA
       where codsolot = a_codsolot
         and punto = l_punto;
      select count(*)
        into l_cont_etapa
        from solotptoeta
       where codsolot = a_codsolot
         and codeta = l_codeta;
      if l_cont_etapa = 1 then
        select orden
          into l_orden
          from solotptoeta
         where codsolot = a_codsolot
           and codeta = l_codeta;
      end if;
      --Asigna la contrata para que se pueda valorizar por contrata
      begin
        select nvl(codcon, -1)
          into l_codcon
          from solotpto_id
         where codsolot = a_codsolot
           and punto = a_punto;
      exception
        when no_data_found then
          l_codcon := -1;
      end;
      if l_codcon = -1 then
        raise_application_error(-20001,
                                'La SOT no tiene asignada Contratista, Asigne en la Programación.');
      end if;
      --Genera la etapa en estado 8 : Diseño
      insert into solotptoeta
        (codsolot,
         punto,
         orden,
         codeta,
         porcontrata,
         esteta,
         obs,
         Fecdis,
         codcon,
         fecini)
      values
        (a_codsolot,
         l_punto,
         l_orden,
         c_e.codeta,
         1,
         8,
         'ITTELMEX-ACT-HFC',
         null,
         l_codcon,
         sysdate);
      --Cargar info de materiales en base a la etapa
      for c_m in cur_act loop
        insert into solotptoetaact
          (codsolot,
           punto,
           orden,
           codact,
           canliq,
           cosliq,
           canins,
           candis,
           cosdis,
           Moneda_Id,
           observacion,
           codprecdis,
           codprecliq)
        values
          (a_codsolot,
           l_punto,
           l_orden,
           c_m.codact,
           c_m.cantidad,
           c_m.costo,
           c_m.cantidad,
           c_m.cantidad,
           c_m.costo,
           c_m.moneda_id,
           'ITTELMEX-ACT-HFC',
           c_m.codprec,
           c_m.codprec);
      end loop;
    end loop;

    --Cargar Materiales en SOLOTPTOEQU
    for c_m in cur_mat loop
      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from solotptoequ
       where codsolot = a_codsolot
         and punto = l_punto;
      insert into solotptoequ
        (codsolot,
         punto,
         orden,
         tipequ,
         CANTIDAD,
         TIPPRP,
         COSTO,
         flgsol,
         codeta,
         observacion,
         fecfdis,
         INSTALADO,
         FLG_INGRESO,
         flginv)
      values
        (a_codsolot,
         l_punto,
         l_orden,
         c_m.tipequ,
         c_m.cantidad,
         0,
         nvl(c_m.Preprm_Usd, 0),
         1,
         c_m.codeta,
         'ITTELMEX-MAT-HFC',
         sysdate,
         0,
         2,
         1);
    end loop;

  END;

  PROCEDURE p_pre_liquidar_act_mat(a_codsolot solot.codsolot%type,
                                   a_punto    solotpto.punto%type) IS
    l_cont          number;
    l_cont_cintillo number;
    l_cont_acta     number;
    l_tiptra       tiptrabajo.tiptra%type;--21.0
    l_tiptrs       tiptrabajo.tiptrs%type;--21.0
    --<9 Cursor para identificar equipos seriados
    cursor cur_equ is
      SELECT a.codsolot,
             a.punto,
             a.orden,
             trim(B.COD_SAP) COD_SAP,
             A.NUMSERIE
        FROM SOLOTPTOEQU A, ALMTABMAT B, TIPEQU C
       WHERE A.TIPEQU = C.TIPEQU
         AND C.CODTIPEQU = B.CODMAT
         AND A.CODSOLOT = a_codsolot
         and A.NUMSERIE is not null;
    --9>
  begin
    --Ini 21.0
    select tiptra into l_tiptra from solot where codsolot = a_codsolot;
    select tiptrs into l_tiptrs from tiptrabajo where tiptra = l_tiptra;
    if l_tiptrs <> 5 then
      --Se valida que el servicio este activo
      select count(1)
        into l_cont
        from inssrv
       where codinssrv in
             (select codinssrv from solotpto where codsolot = a_codsolot)
         and estinssrv in
             (select estinssrv from tiptrs where tiptrs = l_tiptrs);
      if l_cont = 0 then
        --NO estan activos los servicios
        raise_application_error(-20001,
                                'No puede Liquidar esta SOT por que el servicio aun no esta Activo.');
      else
        --Esta activo al menos un servicio
        null;
      end if;
    end if;
    --Fin 21.0
    --Se valida que la contrata registre el Cintillo
    select count(*)
      into l_cont_cintillo
      from solotpto
     where codsolot = a_codsolot
       and cintillo is not null;
    if l_cont_cintillo = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que no tiene registrado el Cintillo.');
    end if;
    --Se valida que la contrata registre el Cintillo con mas d 6 digitos
    select count(*)
      into l_cont_cintillo
      from solotpto
     where codsolot = a_codsolot
       and length(cintillo) > 6;
    if l_cont_cintillo = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que el Cintillo debe tener mas de 6 digitos.');
    end if;
    --Validacion del Acta de Instalación
    select count(*)
      into l_cont_acta
      from solotpto_id
     where codsolot = a_codsolot
       and acta_instalacion is not null;
    if l_cont_acta = 0 then
      --NO tiene asignado el Cintillo
      raise_application_error(-20001,
                              'No puede Liquidar esta SOT por que no tiene registrado el Acta de Instalación.');
    end if;

    --Actualiza las lineas de SOLOTPTOETA, a estado Liquidado : 3
    update solotptoeta
       set fecfin = sysdate, esteta = 15, fecdis = sysdate
     where (codsolot, punto, orden) in
           (select codsolot, punto, orden
              from solotptoetaact
             where codsolot = a_codsolot
               and flg_preliq = 1);

    update solotptoetaact
       set contrata = 1
     where codsolot = a_codsolot
       and flg_preliq = 1;
    update solotptoequ
       set fecins = sysdate
     where codsolot = a_codsolot
       and FLG_INGRESO = 2;
    --<9
    --Cargar Materiales en SOLOTPTOEQU
    for c_e in cur_equ loop
      update solotptoequ
         set valida_almacen = f_verificar_almacen_equ(a_codsolot,
                                                      a_punto,
                                                      c_e.numserie,
                                                      c_e.cod_sap)
       where codsolot = a_codsolot
         and punto = c_e.punto
         and orden = c_e.orden;
    end loop;
    --9>
  END;

  PROCEDURE p_liquidar_act_mat(a_codsolot solot.codsolot%type) IS
     --ini 25.0
    ln_num number;
    ln_idagenda number;
    ln_idtareawf tareawf.idtareawf%type;
    ln_tipest tareawf.tipesttar%type;
    --fin 25.0

    --ini 31.0
    ln_codsap      number;
    v_mensaje      varchar2(300);
    ln_transaccion number;
    v_transaccion  varchar2(20);
    --fin 31.0

    --Leer Actividades de sot
    Cursor cur_act is
      select * from solotptoetaact where codsolot = a_codsolot;
    --Leer materiales de sot
    --ini 31.0
    Cursor cur_mat is
--     select * from solotptoequ where codsolot = a_codsolot;
       select a.numserie,a.punto,a.orden,NVL(a.cantidad,0) as cantidad ,b.codtipequ codmat, a.instalado, a.codsolot
       from   solotptoequ a , tipequ b
       where  a.codsolot = a_codsolot
       and    a.tipequ   = b.tipequ
       and    nvl(a.sptoc_est_despacho,'0')='0';
    --fin 31.0

    --ini 22.0
    ln_tiptrs tiptrabajo.tiptrs%type;
    --fin 22.0

  begin

    --Depurar Actividades
    for c_a in cur_act loop
      if c_a.contrata = 0 then
        delete solotptoetaact where idact = c_a.idact;
      END IF;
    end loop;
    --Depurar Materiales
    for c_m in cur_mat loop
      if c_m.instalado = 0 then
        delete solotptoequ
         where codsolot = c_m.codsolot
           and punto = c_m.punto
           and orden = c_m.orden;
      END IF;
    end loop;
    --Actualiza las lineas de SOLOTPTOETA, a estado Liquidado : 3
    update solotptoeta
       set esteta = 3, fecliq = sysdate
     where codsolot = a_codsolot;
    update solotptoetaact
       set candis = canliq, canins = canliq
     where codsolot = a_codsolot
       and contrata = 1;

   --ini 22.0
   --actualiza equipos de sot de instalación para la SOT de baja o mantenimiento
   select nvl(b.tiptrs,0) into ln_tiptrs
   from solot a, tiptrabajo b
   where a.tiptra = b.tiptra
   and a.codsolot = a_codsolot;

   if ln_tiptrs <> 1 then
     update solotptoequ
     set estado = 10, --recuperado
     codsolot_recuperacion = a_codsolot
     where nvl(estado,0) <> 10 ---28.0
     and flg_recuperacion = 1 ---28.0
     and codsolot_recuperacion is null
     and codsolot in (select a.codsolot from solot a,solotpto b --28.0
                 where a.codsolot = b.codsolot and b.codinssrv in --28.0
                 (select codinssrv from solotpto where codsolot = a_codsolot));

   end if;

   --fin 22.0
   --ini 25.0
   select count(1) into ln_num
   from tareawf a, wf b
   where a.idwf = b.idwf
   and b.valido = 1
   and a.tarea in (select codigon from opedd where tipopedd = 281)
   and b.codsolot = a_codsolot;

     if ln_num = 1 then
        select a.idtareawf, a.tipesttar into ln_idtareawf,ln_tipest
        from tareawf a, wf b
        where a.idwf = b.idwf
        and b.valido = 1
        and a.tarea in (select codigon from opedd where tipopedd = 281)
        and b.codsolot = a_codsolot;
        --- Tipo de estado diferente de cerrado y cancelado.
        if  ln_tipest not in (4,5) then
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(ln_idtareawf,4,4,null,SYSDATE,SYSDATE);
        end if;
        select max(idagenda) into ln_idagenda from agendamiento where codsolot = a_codsolot;
        pq_agendamiento.p_chg_est_agendamiento(ln_idagenda, 21, null, 'Liquidado');
     end if;
   --fin 25.0

   --ini 31.0
   for c_m in cur_mat loop
      ln_codsap :=0;
      v_mensaje :='  ';

      select  DISTINCT sid
      into    ln_transaccion
      from    v$mystat
      where   rownum=1;

      v_transaccion:= to_char(ln_transaccion);

      IF NVL(c_m.numserie,'0')='0' THEN
           WEBSERVICE.PQ_WS_FAC.P_LIQUIDACION_EQUIPOS_MAT('M',v_transaccion,c_m.numserie,c_m.codmat,a_codsolot,c_m.cantidad,ln_codsap,v_mensaje);
      END IF;

      if ln_codsap>0 then

           UPDATE OPERACION.solotptoequ
           SET    SPTOC_EST_DESPACHO = '1',
                  SPTON_DCTOSAP      = ln_codsap
           WHERE  CODSOLOT = a_codsolot
           AND    PUNTO    = c_m.punto
           AND    ORDEN    = c_m.orden;

      end if;
      UPDATE OPERACION.solotptoequ
           SET    OBSERVACION = v_mensaje
           WHERE  CODSOLOT = a_codsolot
           AND    PUNTO    = c_m.punto
           AND    ORDEN    = c_m.orden;
   end loop;



   --fin 31.0

  END;
  procedure p_llenar_actxcontrataxprec(a_codact  in number,
                                       a_codprec in number) IS

  BEGIN

    insert into actxcontrataxprec
      (codact, codcon, codprec, costo)
      select codact,
             codcon,
             Codprec,
             (SELECT costo
                FROM actxpreciario
               where codprec = a_Codprec
                 and codact = a_codact) costo
        from (select a_codact codact, codcon, a_codprec codprec
                from contrata
               WHERE estado = 1
              minus
              select codact, codcon, codprec
                from actxcontrataxprec
               where codact = a_codact
                 and codprec = a_codprec);

  END;

procedure P_act_maestro_Series_sap is
  l_cont number;
  cursor x_ is
    select material, centro, almacen, series, count(1)
      from operacion.Z_MM_SERIES_STOCK
     group by material, centro, almacen, series
    having count(1) > 1;
begin
  --ini 27.0
  /*   --Se actualiza el codigo sap correcto
      update z_mm_series_stock set material = to_number(material);
  */
  --fin 27.0
  ---depuracion

    for a in x_ loop

      delete from operacion.Z_MM_SERIES_STOCK
       where material = a.material
         and centro = a.centro
         and almacen = a.almacen
         and series = a.series
         and rownum = 1;
       commit;

    end loop;


    --Se corrige los numeros de series que vienen con Ceros.
    update operacion.z_mm_series_stock
       set series = to_number(series)
     where operacion.is_number(series) = 1;

    --Se verifica que el codigo sap y el nro de serie no tengan espacios
    update maestro_Series_Equ
       set cod_sap = trim(cod_sap), nroserie = trim(nroserie);

    --Actualizo la informacion antigua
    update maestro_series_equ a
       set (a.almacen, a.centro, a.codusu, a.equipo , a.clase_val, a.mac1, a.mac2, a.mac3, a.mac4) = (select z.almacen,   -- 32.0
                                                               z.centro,
                                                               USER ||
                                                               ' - Actualizado.',
                                                               z.status_sistema,
                                                               z.clase_valoracion,         -- 32.0
                                                               NVL(z.mac1,a.mac1),
                                                               NVL(z.mac2,a.mac2),
                                                               NVL(z.mac3,a.mac3),
                                                               NVL(z.mac4,a.mac4)
                                                          from operacion.z_mm_series_stock z
                                                         where z.series =
                                                               a.nroserie
                                                           and z.material =
                                                               a.cod_sap);

    --Insertar los Nuevos
    insert into maestro_series_equ
      (cod_sap, nroserie, centro, almacen, equipo, sa ,clase_val, mac1, mac2, mac3, mac4)  -- 32.0
      select st.material,
             st.series,
             st.centro,
             st.almacen,
             st.status_sistema,
             st.tipo_stock,
             st.clase_valoracion,
			       st.mac1,
             st.mac2,
             st.mac3,
             st.mac4				
        from operacion.z_mm_series_stock st
       where not exists (select 1
                from maestro_series_equ a
               where a.nroserie = st.series
                 and a.cod_sap = st.material);

  END;

  PROCEDURE P_despacho_equ_mat(a_tipproyecto number,
                               a_Fecini      date,
                               a_Fecfin      date) IS
    /*********************************************************************************************************************/
    --
    --
    --   REVISIONS:
    --   Ver        Date        Author             Description
    --   ---------  ----------  ---------------    ------------------------------------
    --   1.0        27/04/2009  Edilberto Astulle  REQ 85252: Procedimiento para marcar los equs y mats que se van a despachar
    /*********************************************************************************************************************/
    l_cont_pep number;
    cursor c_solot Is
      select distinct codsolot codsolot
        from v_despacho_masivo
       where servicio = a_tipproyecto
         and despachado = 0
         and fecliq between a_fecini and a_fecfin;

  BEGIN
    --Se valida que se ingrese el tip proyecto : DTH HFC CDMA
    if a_tipproyecto is null then
      --NO se ha seleccionado el tipproyecto
      raise_application_error(-20001,
                              'Seleccion el Servicio que se va atender.');
    end if;
    if a_fecini is null or a_fecfin is null then
      --NO se ha seleccionado las fechas de liquidacion
      raise_application_error(-20001,
                              'Ingrese la fecha de Inicio y Fin correcta.');
    end if;

    for c_s in c_solot loop
      select count(*)
        into l_cont_pep
        from solotptoequ
       where codsolot = c_s.codsolot
         and pep is not null;
      if l_cont_pep = 0 then
        --Actualiza la transaccion en los componentes YA QUE LOS
        --COMPONENTES POR ÚLTIMA DEF VAN A TENER ETAPAS DIFERENTES TB--
        UPDATE SOLOTPTOEQU A
           SET FLG_DESPACHO = 1
         WHERE A.CODSOLOT = c_s.codsolot
           AND A.FLGREQ = 0
           AND A.COSTO > 0
           AND A.ORDEN IN (SELECT ORDEN
                             FROM SOLOTPTOEQU
                            WHERE CODSOLOT = A.CODSOLOT
                              AND PUNTO = A.PUNTO
                              AND ORDEN = A.ORDEN
                              AND FECFDIS IS NOT NULL);
      end if;
    end loop;
    COMMIT;
  END;

  PROCEDURE P_GENERA_PEP_PRESUPUESTO(a_tipproyecto number,
                                     a_Fecini      date,
                                     a_Fecfin      date) IS
    /*********************************************************************************************************************/
    --
    --
    --   REVISIONS:
    --   Ver        Date        Author             Description
    --   ---------  ----------  ---------------    ------------------------------------
    --   1.0        27/04/2009  Edilberto Astulle  REQ 85252: Procedimientos para la generación de peps, valorizacion de etapas y cierre de tarea de liquidación.
    --envia informacion a la tabla de temporal de generacion de reserva masiva
    /*********************************************************************************************************************/
    v_numslc   varchar2(10);
    l_cont_pep number;

    cursor c_solot Is
      select distinct codsolot codsolot
        from v_despacho_masivo
       where servicio = a_tipproyecto
         and despachado = 1
         and fecliq between a_fecini and a_fecfin;

  BEGIN
    --Se valida que se ingrese el tip proyecto : DTH HFC CDMA
    if a_tipproyecto is null then
      --NO se ha seleccionado el tipproyecto
      raise_application_error(-20001,
                              'Seleccione el Servicio que se va atender.');
    end if;
    if a_fecini is null or a_fecfin is null then
      --NO se ha seleccionado las fechas de liquidacion
      raise_application_error(-20001,
                              'Ingrese la fecha de Inicio y Fin correcta.');
    end if;

    for c_s in c_solot loop
      select count(*)
        into l_cont_pep
        from solotptoequ
       where codsolot = c_s.codsolot
         and pep is not null;
      if l_cont_pep = 0 then
        --Se inserta en la tabla de procesos si no tiene PEP asignado
        select numslc
          into v_numslc
          from solot
         where codsolot = c_s.codsolot;
        insert into OPERACION.TMP_GEN_MASIVA_PEP
          (codsolot, numslc, estado)
        values
          (c_s.codsolot, v_numslc, '0');
      end if;
    end loop;
    COMMIT;
  END;

  FUNCTION f_verificar_almacen_equ(a_codsolot in number,
                                   a_punto    in number,
                                   a_nroserie in varchar2,
                                   a_cod_sap  in varchar2) RETURN number IS

    l_codcon  number;
    v_codubi  varchar2(10);
    v_centro  varchar2(4);
    v_almacen varchar2(4);
    l_valido  number;
  BEGIN
    --Validar que el Equipo pertenezca al almacen de la contrata asignada
    SELECT codubi
      into v_codubi
      FROM SOLOTPTO
     WHERE codsolot = a_codsolot
       and punto = a_punto;
    SELECT codcon
      into l_codcon
      FROM SOLOTPTO_id
     WHERE codsolot = a_codsolot
       and punto = a_punto;
    select centro, almacen
      into v_centro, v_almacen
      from maestro_Series_equ
     where nroserie = a_nroserie
       and cod_sap = a_cod_sap;
    --Identificar si el Equipo pertenece al almacen de la contrata con el respectivo UBIGEO
    select count(*)
      into l_valido --0 No existe en almacen 1 Si Existe
      from sucursalxcontrata  a,
           z_mm_configuracion b,
           DEPTXCONTRATA      c,
           v_ubicaciones      d
     where a.codcon = l_codcon
       and d.codubi = v_codubi
       and b.centro = v_centro
       and b.almacen = v_almacen
       and a.idsucxcontrata = b.operador
       and a.idsucxcontrata = c.idsucxcontrata
       and trim(c.codest) = trim(d.codest)
       and d.codpai = 51;
    return l_valido;
  END;

  PROCEDURE p_cargar_info_equ_cdma_gsm(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number) IS
    l_codsolot     number;
    v_serie        varchar2(100);
    v_numslc       varchar2(100);
    v_observacion  varchar2(100);
    l_orden        number;
    l_punto        number;
    l_punto_ori    number;
    l_punto_des    number;
    l_codeta       number;
    l_cont_equipos number;
    cursor c_equ is
      SELECT trim(A.NUMSERIE) serie1,
             g.tipequ,
             g.costo,
             trim(A.NUMNSE) serie2,
             A.NUMSLC,
             E.COD_SAP,
             E.NROSERIE,
             a.fecusu fecha_creacion
        FROM SALES.REGINFCDMA A,
             (select *
                from opedd
               where tipopedd = 201
                 and abreviacion = 'CDMA') D,
             Maestro_Series_Equ e,
             almtabmat f,
             tipequ g
       WHERE a.numslc = v_numslc
         and D.CODIGOC = E.COD_SAP
         AND E.NROSERIE = TRIM(A.NUMSERIE)
         and e.cod_sap = trim(f.cod_sap)
         and f.codmat = g.codtipequ;

  BEGIN
    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select numslc into v_numslc from solot where codsolot = l_codsolot;
    for c_s in c_equ loop
      v_serie       := null;
      v_observacion := 'ITTELMEX-EQU-CDMA';
      operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,
                                        l_punto,
                                        l_punto_ori,
                                        l_punto_des);
      SELECT NVL(MAX(ORDEN), 0) + 1
        INTO l_orden
        from solotptoequ
       where codsolot = l_codsolot
         and punto = l_punto;

      select codigon
        into l_codeta
        from opedd
       where tipopedd = 197
         and trim(codigoc) = trim(c_S.cod_sap);

      select count(*)
        into l_cont_equipos
        from solotptoequ
       where codsolot = l_codsolot
         and trim(numserie) = trim(c_s.nroserie);
      if l_cont_equipos = 0 then
        --No esta registrado el Equipo en la SOT
        insert into solotptoequ
          (codsolot,
           punto,
           orden,
           tipequ,
           CANTIDAD,
           TIPPRP,
           COSTO,
           NUMSERIE,
           flgsol,
           flgreq,
           codeta,
           tran_solmat,
           observacion,
           fecfdis)
        values
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
           v_observacion,
           c_s.fecha_creacion);
      end if;

    end loop;

  END;

  --<11.0>
  PROCEDURE p_genera_plano_gis(a_codsolot  number,
                               a_punto     number,
                               a_orden     number,
                               a_idtareawf number) IS
    l_cont       number;
    l_idplano    number;
    l_idplanoseg number;

  BEGIN
    select SQ_PLANO.Nextval into l_idplano from dual;
    Insert into plano
      (codsolot, punto, orden, idplano, idtareawf)
    values
      (a_codsolot, a_punto, a_orden, l_idplano, a_idtareawf);

  END;
  --<\11.0>
  --<11.0>
  PROCEDURE p_elimina_plano_gis(a_idplano number) IS

  BEGIN

    delete from operacion.planochg where idplano = a_idplano;

    delete from operacion.planoseg where idplano = a_idplano;

    delete from operacion.plano where idplano = a_idplano;

  END;
  --<\11.0>

  --<15.0>
  PROCEDURE p_cargar_equ_cdma_gsm(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER)

    --  Cuando se ingresa a Opciones por Tarea, en caso haya 0 registros, se inserta un registro en
    --  la tabla operacion.solotptoequ.

   IS
    v_serie        varchar2(100);
    v_numslc       varchar2(100);
    v_observacion  varchar2(100);
    l_orden        number;
    l_punto        number;
    l_punto_ori    number;
    l_punto_des    number;
    l_codeta       number;
    l_cont_equipos number;
    l_codsolot     solot.codsolot%type;
    ls_tipsrv      tystipsrv.tipsrv%type; --16.0
  BEGIN

    SELECT codsolot INTO l_codsolot FROM wf WHERE idwf = a_idwf;

    select numslc into v_numslc from solot where codsolot = l_codsolot;
    delete solotptoequ
     where codsolot = l_codsolot
       and flg_ingreso = 1; --Eliminar los equipos de la mesa de validacion

    v_serie       := null;
    v_observacion := 'ITTELMEX-EQU-CDMA';
    select valor
      into ls_tipsrv
      from constante
     where constante = 'FAM_TELEF'; --16.0
    operacion.P_GET_PUNTO_PRINC_SOLOT(l_codsolot,
                                      l_punto,
                                      l_punto_ori,
                                      l_punto_des,
                                      ls_tipsrv); --16.0

    SELECT NVL(MAX(ORDEN), 0) + 1
      INTO l_orden
      from solotptoequ
     where codsolot = l_codsolot
       and punto = l_punto;

    insert into solotptoequ
      (codsolot,
       punto,
       orden,
       tipequ,
       CANTIDAD,
       TIPPRP,
       COSTO,
       NUMSERIE,
       flgsol,
       flgreq,
       tran_solmat,
       observacion,
       fecfdis)
    values
      (l_codsolot,
       l_punto,
       l_orden,
       8573,
       1,
       0,
       0,
       null,
       1,
       0,
       null,
       v_observacion,
       sysdate);

  END;
  --</15.0>
  --< 34.0 Agrega Ejecucion de Equipos PROY-LIMFTPV02>
  PROCEDURE SGASS_PROCESO_EQUIPOS IS

  cursor c_equipos is
    select a.cod_sap, A.CENTRO, A.ALMACEN, count(*) stock, 'PZA' medida, 
           decode(a.clase_val,'VALORADO',a.clase_val,'NO VALORADO',a.clase_val,null) valor  
	    from operacion.maestro_series_equ A 
		 where a.almacen is not null and a.centro is not null 
  group by a.cod_sap, A.CENTRO, A.ALMACEN, a.clase_val; 
  
  PRAGMA AUTONOMOUS_TRANSACTION;
  L_CNT NUMBER;
  l_valor varchar2(50); 
  BEGIN
    for c in c_equipos loop
      If c.valor = 'VALORADO' or c.valor = 'NO VALORADO' THEN
        l_valor := c.valor;
      ELSE
        l_valor := NULL;
      END IF;
      SELECT COUNT(1) INTO L_CNT
        FROM AGENLIQ.SGAT_RESUMENEQUIMAT
       WHERE COD_SAP = c.cod_sap
         AND CENTRO = c.centro
         AND ALMACEN = c.almacen 
         AND NVL(REQUV_VALOR,'X') = NVL(l_Valor,'X');
      
      IF L_CNT > 0 THEN
          UPDATE AGENLIQ.SGAT_RESUMENEQUIMAT 
             SET REQUN_CANTIDAD = c.stock,
                 REQUV_UNIMED = c.medida,
                 REQUV_VALOR = l_Valor,
                 codvalor = DECODE(trim(c.valor),'VALORADO',1,'NO VALORADO',2,0),
                 REQUC_TIPO = 'E'
           WHERE COD_SAP = c.cod_sap
             AND CENTRO = c.centro
             AND ALMACEN = c.almacen
             AND NVL(REQUV_VALOR,'X') = NVL(l_Valor,'X');
      ELSE
          INSERT INTO AGENLIQ.SGAT_RESUMENEQUIMAT  
            (COD_SAP, CENTRO, ALMACEN, CODVALOR,  
             REQUN_CANTIDAD,REQUV_UNIMED,REQUV_VALOR,REQUC_TIPO,
             REQUV_IPCRE,REQUV_USUCRE)
          VALUES (
             c.cod_sap, c.centro, c.almacen, DECODE(trim(c.valor),'VALORADO',1,'NO VALORADO',2,0),
             c.stock,
             c.medida,
             c.valor,
             'E',
             SYS_CONTEXT('USERENV','IP_ADDRESS'),
             user);
      END IF;
    end loop;
    commit;   
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20550,
                              'Error - SGASS_PROCESO_EQUIPOS'|| SQLERRM);  
  END;
  
  PROCEDURE SGASS_PROCESO_MATERIALES (V_CODSAP   AGENLIQ.SGAT_RESUMENEQUIMAT.COD_SAP%TYPE,
                                      V_CENTRO   AGENLIQ.SGAT_RESUMENEQUIMAT.CENTRO%TYPE,
                                      V_ALMACEN  AGENLIQ.SGAT_RESUMENEQUIMAT.ALMACEN%TYPE,
                                      --V_CANTIDAD AGENLIQ.SGAT_RESUMENEQUIMAT.REQUN_CANTIDAD%TYPE,
                                      V_CANTIDAD VARCHAR2,
                                      V_UNIMED   AGENLIQ.SGAT_RESUMENEQUIMAT.REQUV_UNIMED%TYPE,
                                      V_VALOR    AGENLIQ.SGAT_RESUMENEQUIMAT.CODVALOR%TYPE,
                                      V_ERROR    OUT NUMBER,
                                      V_MSJ      OUT VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  L_CNT NUMBER;
  BEGIN
    V_ERROR := 0;
    V_MSJ := 'OK';
    SELECT COUNT(1) INTO L_CNT
      FROM AGENLIQ.SGAT_RESUMENEQUIMAT
     WHERE COD_SAP = V_CODSAP
       AND CENTRO = V_CENTRO
       AND ALMACEN = V_ALMACEN 
       AND NVL(CODVALOR,0) = V_VALOR;
      
    IF L_CNT > 0 THEN
      UPDATE AGENLIQ.SGAT_RESUMENEQUIMAT 
         SET REQUN_CANTIDAD = TO_NUMBER(V_CANTIDAD),
             REQUV_UNIMED = V_UNIMED
       WHERE COD_SAP = V_CODSAP
         AND CENTRO = V_CENTRO
         AND ALMACEN = V_ALMACEN 
         AND CODVALOR = V_VALOR;
    ELSE
      INSERT INTO AGENLIQ.SGAT_RESUMENEQUIMAT  
				(COD_SAP, CENTRO, ALMACEN, CODVALOR, REQUN_CANTIDAD,REQUV_UNIMED,REQUV_VALOR,REQUC_TIPO,
         REQUV_IPCRE,REQUV_USUCRE)
			VALUES (
         V_CODSAP, 
         V_CENTRO,
         V_ALMACEN,
         V_VALOR,
         TO_NUMBER(V_CANTIDAD),
         V_UNIMED,
         DECODE(V_VALOR,1,'VALORADO',2,'NO VALORADO',null),
         'M',
         SYS_CONTEXT('USERENV','IP_ADDRESS'),
         user);
    END IF; 
    COMMIT; 
  EXCEPTION
    WHEN OTHERS THEN
      V_ERROR := 1; 
      V_MSJ := 'ERROR: ' || sqlerrm; 
  END;
  
    PROCEDURE SGASS_LISTA_OC
  /*******************************************************
    Nombre SP    : SGASS_LISTA_OC
    Propуsito    : Obtener las Ordenes de Compra.
    Input        : Parametro CAPEX / OPEX
    Ouput        : PO_DATO - Cursor de registro de Pedidos (CRM).
                   PO_COD_ERROR - Cуdigo Error SP, 0: Ok / 1: Error Ejecuciуn.
                   PO_DES_ERROR - Descripciуn Cуdigo Error.
    Creado por   : Lidia Quispe
    Fec Creacion : 28/09/2018
    Fec Actualizacion: N/A
    *******************************************************/
  (PI_PARAM     IN VARCHAR2,
   PO_DATO      OUT SYS_REFCURSOR,
   PO_COD_ERROR OUT NUMBER,
   PO_DES_ERROR OUT VARCHAR2) IS
  BEGIN
    OPEN PO_DATO FOR
      SELECT DLOCV_CLASE_PEDIDO, DLOCV_CONTR_MARCO, DLOCV_ESPACIO, DLOCN_POSICION_CONTR, DLOCV_INDIMPUESTO, 
			        DLOCV_NRO_NECESIDAD, LPAD(DLOCV_COD_MATERIAL,18,'0') DLOCV_COD_MATERIAL, DLOCV_CANT_MATERIAL, DLOCN_PREC_NETO, DLOCV_COD_SERV, 
			        DLOCV_CANT_SERV, DLOCV_GR_ARTICULO, DLOCV_CTA_MAYOR, DLOCV_PREC_BR_SERV, DLOCV_ELEM_PEP,       
			        DLOCV_CTO_COSTO, DLOCV_NRO_ORDINT, DLOCV_CTO_GESTOR, DLOCV_TXT_POS, DLOCV_TXT_CAB,             
			        DLOCV_GPO_COMPRA, TO_CHAR(DLOCD_FEC_ENTREGA,'DD.MM.YYYY') DLOCD_FEC_ENTREGA, DLOCV_SOLICITANTE                     
			   FROM AGENLIQ.SGAT_DOC_LIQUIDA_OC                 
              WHERE ( DLOCN_LOTE_PROCESO IN (SELECT L.LTPRN_LOTE  
                                              FROM AGENLIQ.SGAT_LOTE_PROCESOS L        
                                             WHERE L.LTPRN_FLG_ACT_OC = 1              
                                               AND L.LTPRV_TIPO_ARCHIVO = PI_PARAM) 
                      AND NVL(DLOCC_FLG_OC,0) = 1 )
              ORDER BY DLOCN_IDDOCLIQOC ;
    
               
    PO_COD_ERROR := 1;
    PO_DES_ERROR := 'Operaciуn Exitosa';
  EXCEPTION
    WHEN OTHERS THEN
      OPEN PO_DATO FOR
        SELECT NULL FROM DUAL;
      PO_COD_ERROR := 0;
      PO_DES_ERROR := 'ERROR: ' || SQLERRM;
  END ;
  
  PROCEDURE SGASS_COMPLETA_OC (PI_PARAM     IN NUMBER,
                               PI_ID        IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCN_IDDOCLIQOC%TYPE,
                               PI_CONTRATO  IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCV_CONTR_MARCO%TYPE,
                               PI_CODMAT    IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCV_COD_MATERIAL%TYPE,
                               PI_ITEM      IN AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCN_POSICION_CONTR%TYPE,
                               PO_COD_ERROR OUT NUMBER,
                               PO_DES_ERROR OUT VARCHAR2) IS
  /*******************************************************
    Nombre SP    : SGASS_COMPLETA_OC
    Propуsito    : Inserta en una tabla Temp los materiales y su posicion.
    Input        : PI_PARAM    0 [Insercion] / tamanio de los Item obtenidos [Update]
	               PI_ID       Id del contrato marco obtenido de la tabla SGAT_DOC_LIQUIDA_OC
				   PI_CONTRATO Contrato Marco
				   PI_CODMAT   Codigo Material
				   PI_ITEM     ItemNro (Posicion) Obtenido del servicio
    Ouput        : PO_COD_ERROR - Cуdigo Error SP, 0: Ok / 1: Error Ejecuciуn.
                   PO_DES_ERROR - Descripciуn Cуdigo Error.
    Creado por   : Lidia Quispe
    Fec Creacion : 28/09/2018
    Fec Actualizacion: N/A
    *******************************************************/
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  LN_CANTIDAD NUMBER;
  lv_material AGENLIQ.SGAT_DOC_LIQUIDA_OC.DLOCV_COD_MATERIAL%TYPE;
  PROCESO BOOLEAN;
  R  NUMBER;
  LN_PROCESO NUMBER;
  BEGIN
    PO_COD_ERROR := 1;
    PO_DES_ERROR := 'Operaciуn Exitosa' ;   
    INSERT INTO AGENLIQ.SGAT_DOC_LIQ_TMP (dlocn_iddocliqoc, dlocv_contr_marco,
                                          dlocn_posicion_contr, dlocv_cod_material)
    VALUES (PI_ID, PI_CONTRATO, PI_ITEM, PI_CODMAT);    
    
    IF PI_PARAM <> 0 THEN
      PROCESO := TRUE;
      R := 1;
      LN_PROCESO := 0;
      WHILE (PROCESO) 
        LOOP
        begin
          SELECT dlocv_cod_material into lv_material
           FROM AGENLIQ.SGAT_DOC_LIQUIDA_OC
          WHERE dlocn_iddocliqoc = (PI_ID+R)
            and DLOCV_CONTR_MARCO is null;
        exception
          when NO_DATA_FOUND then
             lv_material := ''; 
        end ;     
        
          IF (length(lv_material)>0) THEN
             UPDATE AGENLIQ.SGAT_DOC_LIQUIDA_OC t
               SET DLOCN_POSICION_CONTR = (
                       SELECT DLOCN_POSICION_CONTR 
                         FROM AGENLIQ.SGAT_DOC_LIQ_TMP
                        WHERE dlocv_cod_material = LPAD(lv_material,18,'0')
                        )
                   ,DLOCC_FLG_OC = 1
             WHERE T.dlocn_iddocliqoc = (PI_ID+R);               
             R:=R+1;
            PROCESO := TRUE;
          ELSE
            PROCESO := FALSE;
            DELETE FROM AGENLIQ.SGAT_DOC_LIQ_TMP ;
            UPDATE AGENLIQ.SGAT_DOC_LIQUIDA_OC set DLOCC_FLG_OC = 1
             WHERE dlocn_iddocliqoc = PI_ID;
          END IF;
                                 
        END LOOP;            
      
    END IF;      
    COMMIT;
    
    PO_DES_ERROR := PO_DES_ERROR||'-'||PI_PARAM||'-'||PI_ID;    
  EXCEPTION
    WHEN OTHERS THEN
      PO_COD_ERROR := 0;
      PO_DES_ERROR := 'ERROR: '||ln_cantidad ||'-'|| SQLERRM;
  END;
  --<34.0 FIN >
END;
/
