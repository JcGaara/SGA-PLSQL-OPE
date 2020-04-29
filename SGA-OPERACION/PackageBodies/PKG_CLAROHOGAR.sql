CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_CLAROHOGAR is

/*
****************************************************************'
* Nombre SP : CLRHSS_DIRECCION_INSTAL
* Propósito : El SP permite traer las direccion de instalacion relacionado
               a su contrato de acuerdo a las diferentes sucursales que tenga
               el cliente
* Input :  PI_NRO_DOCUMENTO  - Numero de documento de identidad del cliente
           PI_TIPO_DOCUMENTO - Tipo de documento asociado al cliente.
* Output : PO_CURSOR    - Listado de direcciones
           PO_RESULTADO - Codigo resultado
           PO_MSGERR    - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 14/01/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_DIRECCION_INSTAL(
                                      PI_NRO_DOCUMENTO  IN  VARCHAR2,
                                      PI_TIPO_DOCUMENTO  IN  VARCHAR2,
                                      PO_CURSOR   OUT SYS_REFCURSOR,
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2)
 IS
 BEGIN

   OPEN PO_CURSOR FOR
  SELECT DISTINCT SC.DIRSUC,
                  S.COD_ID,
                  S.CUSTOMER_ID,
                  S.CODSOLOT,
                  I.CODCLI,
                  U.NOMDEPA DEPARTAMENTO,
                  U.NOMPROV PROVINCIA,
                  U.NOMDST  DISTRITO
    FROM OPERACION.INSSRV    I,
         MARKETING.VTASUCCLI SC,
         OPERACION.SOLOT     S,
         SALES.VTATABSLCFAC  P,
         MARKETING.VTATABDST U
   WHERE SC.CODSUC = I.CODSUC
     AND I.NUMSLC = P.NUMSLC
     AND S.NUMSLC = P.NUMSLC
     AND U.CODUBI = SC.UBISUC
     AND I.CODCLI IN (SELECT CODCLI
                        FROM MARKETING.VTATABCLI C
                       WHERE C.NTDIDE = PI_NRO_DOCUMENTO AND C.TIPDIDE = PI_TIPO_DOCUMENTO)
     AND I.ESTINSSRV IN (1, 2)
     AND S.ESTSOL IN (12, 29);

  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        OPEN PO_CURSOR FOR
        SELECT
               '' DIRSUC,
               '' COD_ID
          FROM DUAL
         WHERE 1=2;

        PO_RESULTADO := -99;
        PO_MSGERR    := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

/*
****************************************************************'
* Nombre SP : CLRHSS_CONTRATA
* Propósito : El SP permite traer el nombre de las contratas a partir de los ID
* Input :  PI_ID_CONTRATA        - Id de la contrata
* Output : PO_NOM_CONTRATA       - Nombre asignado a la contrata
           PO_RESULTADO          - Codigo resultado
           PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/01/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_CONTRATA(
                                      PI_ID_CONTRATA  IN  INTEGER,
                                      PO_NOM_CONTRATA   OUT VARCHAR2,
                                      PO_RESULTADO    OUT INTEGER,
                                      PO_MSGERR       OUT VARCHAR2)
 IS
 BEGIN

  SELECT NOMBRE INTO PO_NOM_CONTRATA FROM OPERACION.CONTRATA WHERE CODCON = PI_ID_CONTRATA;
  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        PO_NOM_CONTRATA       := '';
        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;


/*
****************************************************************'
* Nombre SP : CLRHSS_TIPO_SUBTIPO_OT
* Propósito : El SP permite traer el nombre del tipo y subtipo de Orden
* Input :  PI_COD_TIPO_ORDEN       - Codigo concatenado del tipo de Orden
           PI_COD_SUBTIPO_ORDEN    - Codigo concatenado del subtipo de Orden
* Output : PO_CURSOR_TIP_ORDEN     - Listado de nombres del tipo de Orden
           PO_CURSOR_SUBTIP_ORDEN  - listado de nombres del subtipo de Orden
           PO_RESULTADO            - Codigo resultado
           PO_MSGERR               - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 21/01/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_TIPO_SUBTIPO_OT(
                                      PI_COD_TIPO_ORDEN     IN  VARCHAR2,
                                      PI_COD_SUBTIPO_ORDEN  IN  VARCHAR2,
                                      PO_CURSOR_TIP_ORDEN    OUT SYS_REFCURSOR,
                                      PO_CURSOR_SUBTIP_ORDEN OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)
 IS
 BEGIN

 OPEN PO_CURSOR_TIP_ORDEN FOR
 SELECT COD_TIPO_ORDEN, DESCRIPCION
  FROM OPERACION.TIPO_ORDEN_ADC
 WHERE COD_TIPO_ORDEN IN
       (SELECT REGEXP_SUBSTR(PI_COD_TIPO_ORDEN, '[^,]+', 1, LEVEL)
          FROM DUAL
        CONNECT BY REGEXP_SUBSTR(PI_COD_TIPO_ORDEN, '[^,]+', 1, LEVEL) IS NOT NULL);

 OPEN PO_CURSOR_SUBTIP_ORDEN FOR

 SELECT COD_SUBTIPO_ORDEN, DESCRIPCION
  FROM OPERACION.SUBTIPO_ORDEN_ADC
 WHERE COD_SUBTIPO_ORDEN IN
       (SELECT REGEXP_SUBSTR(PI_COD_SUBTIPO_ORDEN, '[^,]+', 1, LEVEL)
          FROM DUAL
        CONNECT BY REGEXP_SUBSTR(PI_COD_SUBTIPO_ORDEN, '[^,]+', 1, LEVEL) IS NOT NULL);

  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        OPEN PO_CURSOR_TIP_ORDEN FOR
        SELECT
               '' COD_TIPO_ORDEN,
               '' DESCRIPCION
          FROM DUAL
         WHERE 1=2;

         OPEN PO_CURSOR_SUBTIP_ORDEN FOR
        SELECT
               '' COD_SUBTIPO_ORDEN,
               '' DESCRIPCION
          FROM DUAL
         WHERE 1=2;

        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

 /*
****************************************************************'
* Nombre SP : CLRHSS_VISITA_CLIENTE
* Propósito : El SP permite traer las visitas pendientes del cliente generadas
              en el SGA.
* Input  :  PI_CUSTOMER_ID        - CUSTOMER_ID
* Output :  PO_CURSOR_LIS_ORDEN   - Cursor del listado de Ordenes pendientes
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 04/02/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSS_VISITA_CLIENTE(
                                      PI_CUSTOMER_ID        IN  VARCHAR2,
                                      PO_CURSOR_LIS_ORDEN   OUT SYS_REFCURSOR,
                                      PO_CURSOR_FRANJA_HO   OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)
 IS
 V_VALIDA_CUSTOMER NUMBER;
 BEGIN

 SELECT COUNT(1)
   INTO V_VALIDA_CUSTOMER
   FROM OPERACION.SOLOT S
  WHERE S.CUSTOMER_ID = PI_CUSTOMER_ID;

 IF V_VALIDA_CUSTOMER = 0 THEN
   OPEN PO_CURSOR_LIS_ORDEN FOR
        SELECT
               '' idEta,
               '' idAgenda,
               '' codSolot,
               '' SUBTIPO_ORDEN,
               '' TIPO_ORDEN,
               '' TIEMPO_MIN
          FROM DUAL
         WHERE 1=2;

         OPEN PO_CURSOR_FRANJA_HO FOR
        SELECT
               '' CODIGO,
               '' FRANJA,
               '' FRANJA_INI,
               '' IND_MERID_FI,
               '' FRANJA_FIN,
               '' IND_MERID_FF
          FROM DUAL
         WHERE 1=2;
   PO_RESULTADO := -1;
   PO_MSGERR := 'CUSTOMER_ID NO ENCONTRADO';
   RETURN;
 END IF;

 OPEN PO_CURSOR_LIS_ORDEN FOR
 SELECT DISTINCT to_number(WEBSERVICE.PQ_OBTIENE_ENVIA_TRAMA_ADC.f_obtener_tag('idETA',
                                                                               TWA.XMLRESPUESTA)) idEta,
                 A.idAgenda,
                 S.codSolot,
                 STO.DESCRIPCION SUBTIPO_ORDEN,
                 TIO.DESCRIPCION TIPO_ORDEN,
                 STO.TIEMPO_MIN
   FROM SOLOT                        S,
        OPERACION.AGENDAMIENTO       A,
        OPERACION.TRANSACCION_WS_ADC TWA,
        OPERACION.SUBTIPO_ORDEN_ADC  STO,
        OPERACION.TIPO_ORDEN_ADC     TIO
  WHERE A.CODSOLOT = S.CODSOLOT
    AND TWA.CODSOLOT = S.CODSOLOT
    AND A.IDAGENDA = TWA.IDAGENDA
    AND STO.ID_SUBTIPO_ORDEN = A.ID_SUBTIPO_ORDEN
    AND TIO.ID_TIPO_ORDEN = STO.ID_TIPO_ORDEN
    AND S.CUSTOMER_ID = PI_CUSTOMER_ID
    AND S.ESTSOL = 17
    AND A.ESTAGE IN (SELECT D.CODIGON
                       FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
                      WHERE C.TIPOPEDD = D.TIPOPEDD
                        AND C.ABREV = 'ESTVIAGECH')
    AND TWA.IDERROR in (0, 3)
    AND TWA.METODO IN ('gestionarOrdenSGA', 'gestionarOrden');

  OPEN PO_CURSOR_FRANJA_HO FOR
 SELECT FH.CODIGO,
       FH.FRANJA,
       FH.FRANJA_INI,
       FH.IND_MERID_FI,
       FH.FRANJA_FIN,
       FH.IND_MERID_FF
  FROM OPERACION.FRANJA_HORARIA FH
 WHERE FH.FLG_AP_CTR = 1;

  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        OPEN PO_CURSOR_LIS_ORDEN FOR
        SELECT
               '' idEta,
               '' idAgenda,
               '' codSolot,
               '' SUBTIPO_ORDEN,
               '' TIPO_ORDEN,
               '' TIEMPO_MIN
          FROM DUAL
         WHERE 1=2;

         OPEN PO_CURSOR_FRANJA_HO FOR
        SELECT
               '' CODIGO,
               '' FRANJA,
               '' FRANJA_INI,
               '' IND_MERID_FI,
               '' FRANJA_FIN,
               '' IND_MERID_FF
          FROM DUAL
         WHERE 1=2;

        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

 /*
****************************************************************'
* Nombre SP : CLRHSS_DATOS_CAPACIDAD
* Propósito : El SP permite traer las visitas pendientes del cliente generadas
              en el SGA.
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
* Output :  PO_CURSOR             - Cursor del listado los datos de capacidad
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_DATOS_CAPACIDAD(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PO_CURSOR             OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)IS

 V_NRO_REGLA         NUMBER := 187;
 BEGIN

 OPEN PO_CURSOR FOR
SELECT DISTINCT A.IDPLANO,
                Z.CODZONA,
                SU.COD_SUBTIPO_ORDEN,
                (select DISTINCT PDA.ABREVIATURA as deta_abrev
                   from OPERACION.PARAMETRO_DET_ADC PDA,
                        OPERACION.PARAMETRO_CAB_ADC PCA
                  where PDA.ID_PARAMETRO = V_NRO_REGLA
                    AND PDA.CODIGON = S.TIPTRA
                    AND PDA.ID_PARAMETRO = PCA.ID_PARAMETRO) REGVAL,
                SU.TIEMPO_MIN,
                TI.TIPO_SERVICIO
  FROM OPERACION.AGENDAMIENTO      A,
       OPERACION.SOLOT             S,
       OPERACION.SUBTIPO_ORDEN_ADC SU,
       OPERACION.TIPO_ORDEN_ADC    TI,
       marketing.vtatabgeoref      M,
       operacion.zona_adc          z
 WHERE S.CODSOLOT = A.CODSOLOT
   AND A.ID_SUBTIPO_ORDEN = SU.ID_SUBTIPO_ORDEN
   AND SU.ID_TIPO_ORDEN = TI.ID_TIPO_ORDEN
   AND A.IDPLANO = M.IDPLANO
   AND M.IDZONA = Z.IDZONA
   AND A.IDAGENDA = PI_ID_AGENDA;

  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        OPEN PO_CURSOR FOR
        SELECT
               '' IDPLANO,
               '' CODZONA,
               '' COD_SUBTIPO_ORDEN,
               '' REGVAL,
               '' TIEMPO_MIN,
               '' TIPO_SERVICIO
          FROM DUAL
         WHERE 1=2;

        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

/*
****************************************************************'
* Nombre SP : CLRHSI_REAGENDAMIENTO
* Propósito : El SP reagendar las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_FECHA_AGENDA       - Fecha de nueva agenda
            PI_FRANJA             - Nueva franja horaria
            PI_ID_BUCKET          - Id de contrata seleccionada
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
            PO_HORA_INI           - Hora inicio de la nueva agenda
            PO_HORA_FIN           - Hora final de la nueva agenda
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSI_REAGENDAMIENTO(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PI_FECHA_AGENDA       IN  DATE,
                                      PI_FRANJA             IN  VARCHAR2,
                                      PI_ID_BUCKET          IN  VARCHAR2,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2,
                                      PO_HORA_INI           OUT VARCHAR2,
                                      PO_HORA_FIN           OUT VARCHAR2)
 IS
 V_CODIGO_RESPUESTA  NUMBER;
 V_MENSAJE_RESPUESTA VARCHAR2(100);
 V_ESTADO            VARCHAR2(50);
 V_COD_SUBTIPO_ORDEN OPERACION.SUBTIPO_ORDEN_ADC.COD_SUBTIPO_ORDEN%TYPE;
 V_TIPO_TRABAJO      TIPTRABAJO.TIPTRA%TYPE;
 V_COD_CUADRILLA     OPERACION.AGENDAMIENTO.CODCUADRILLA%TYPE;
 V_CONTRACT_ADC      OPERACION.AGENDAMIENTO.CODCON%TYPE;
 V_DIRECCION         OPERACION.AGENDAMIENTO.DIRECCION%TYPE;
 V_TELEFONO          OPERACION.AGENDAMIENTO.TELEFONO_ADC%TYPE;
 V_OBSERVACION       VARCHAR2(150);
 V_HORA_INICIO       VARCHAR2(50);
 V_HORA_FIN          VARCHAR2(50);
 V_ZL                NUMBER;
 V_FECHA_PROGRA      VARCHAR2(50);
 V_FECHA_PROGRA_2    DATE;
 V_EXISTE           NUMBER;
 V_ESTAGENDA_OLD    operacion.agendamiento.estage%type;
 V_VALIDA           VARCHAR2(50);
 BEGIN

 SELECT (F.FRANJA_INI || ' ' || F.IND_MERID_FI),
        (F.FRANJA_FIN || ' ' || F.IND_MERID_FF)
   INTO V_HORA_INICIO, V_HORA_FIN
   FROM OPERACION.FRANJA_HORARIA F
  WHERE F.CODIGO = PI_FRANJA;

 SELECT S.COD_SUBTIPO_ORDEN, SO.TIPTRA
   INTO V_COD_SUBTIPO_ORDEN, V_TIPO_TRABAJO
   FROM OPERACION.AGENDAMIENTO      A,
        OPERACION.SUBTIPO_ORDEN_ADC S,
        OPERACION.SOLOT             SO
  WHERE A.ID_SUBTIPO_ORDEN = S.ID_SUBTIPO_ORDEN
    AND SO.CODSOLOT = A.CODSOLOT
    AND A.IDAGENDA = PI_ID_AGENDA;

 SELECT D.DESCRIPCION
   INTO V_OBSERVACION
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'OBSREAGEAPP';

 V_VALIDA := 0;
 OPERACION.PQ_AGENDAMIENTO.SGASS_VALIDA_ESTADO(PI_ID_AGENDA,V_ESTADO,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
 V_VALIDA := 1;
 IF V_CODIGO_RESPUESTA = 1 THEN
   OPERACION.PQ_AGENDAMIENTO.SGASS_VALIDA_SUBTIPO(V_COD_SUBTIPO_ORDEN,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
   V_VALIDA := 2;
   IF V_CODIGO_RESPUESTA = 1 THEN
        V_ZL := OPERACION.PQ_ADM_CUADRILLA.f_val_zonalejana(PI_ID_AGENDA);
        V_VALIDA := 3;
        IF V_ZL > 0 THEN
          PO_HORA_INI := '';
          PO_HORA_FIN := '';
          PO_RESULTADO := -3;
          PO_MSGERR := 'La orden no se puede reagendar por pertenecer a una zona lejana';
          return;
        end if;

        FOR C_DATO IN (select idagenda          Id_agenda,
                              Codcon            Codcon,
                              idagenda          Contacto_adc,
                              direccion         Direccion,
                              telefono_adc      Telefono,
                              id_subtipo_orden  Id_subtipo_orden,
                              observacion       Observacion,
                              codcuadrilla      CodCuadrilla
                              from operacion.agendamiento
                              where operacion.agendamiento.idagenda = PI_ID_AGENDA)
          LOOP
            V_COD_CUADRILLA := C_DATO.CODCUADRILLA;
            V_CONTRACT_ADC := C_DATO.CODCON;
            V_DIRECCION := C_DATO.DIRECCION;
            V_TELEFONO := C_DATO.Telefono;
          END LOOP;
        V_FECHA_PROGRA := PI_FECHA_AGENDA|| ' ' ||V_HORA_INICIO;
        SELECT to_date(to_char(to_date(V_FECHA_PROGRA,
                                       'DD/MM/YY HH:MI AM'),
                               'dd/mm/yyyy') || ' ' || V_HORA_INICIO,
                       'dd/mm/yyyy hh:mi AM') INTO V_FECHA_PROGRA_2
          FROM DUAL;

        OPERACION.PQ_AGENDAMIENTO.P_REAGENDAMIENTO(PI_ID_AGENDA,V_TIPO_TRABAJO,V_FECHA_PROGRA_2,V_OBSERVACION,V_CONTRACT_ADC,V_MENSAJE_RESPUESTA,V_CODIGO_RESPUESTA);
        V_VALIDA := 4;
        IF V_CODIGO_RESPUESTA = -1 THEN
          PO_HORA_INI := '';
          PO_HORA_FIN := '';
          PO_RESULTADO := -4;
          PO_MSGERR := V_MENSAJE_RESPUESTA;
          RETURN;
        ELSE

        if to_number(V_CONTRACT_ADC) > 0 then
          select estage
            into V_ESTAGENDA_OLD
            from operacion.agendamiento a
           where idagenda = PI_ID_AGENDA;
           begin
             select 1
               into V_EXISTE
               from operacion.contrata
              where codcon = to_number(V_CONTRACT_ADC);
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               V_EXISTE := 0;
           end;

        if V_EXISTE = 0 then
          PO_HORA_INI := '';
            PO_HORA_FIN := '';
            PO_RESULTADO := -6;
            PO_MSGERR := 'NO EXISTE CONTRATA';
        else
          UPDATE operacion.agendamiento
             SET codcon = to_number(V_CONTRACT_ADC)
           WHERE idagenda = PI_ID_AGENDA;


          operacion.pq_agendamiento.p_asig_contrata(PI_ID_AGENDA,
                                                    to_number(V_CONTRACT_ADC),
                                                    'Asigando por proceso ETADirect');
          V_VALIDA := 5;

          operacion.pq_agendamiento.p_chg_est_agendamiento(PI_ID_AGENDA,
                                                           '16',
                                                           V_ESTAGENDA_OLD,
                                                           'Agendado en ETADirect',
                                                           null,
                                                           trunc(sysdate),
                                                           null);
          V_VALIDA := 5;


            PO_HORA_INI := V_HORA_INICIO;
            PO_HORA_FIN := V_HORA_FIN;
            PO_RESULTADO := 0;
            PO_MSGERR := 'EXITO';
        end if;
      ELSE
            PO_HORA_INI := '';
            PO_HORA_FIN := '';
            PO_RESULTADO := -5;
            PO_MSGERR := 'CONTRATA NO ENVIADA';
      end if;

          OPERACION.PQ_ADM_CUADRILLA.P_ASIGNACONTRATA_ST(PI_ID_AGENDA,V_COD_SUBTIPO_ORDEN,PI_ID_BUCKET,V_CONTRACT_ADC,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
          V_VALIDA := 6;
          IF V_CODIGO_RESPUESTA = -1 THEN
            PO_HORA_INI := '';
            PO_HORA_FIN := '';
            PO_RESULTADO := -5;
            PO_MSGERR := V_MENSAJE_RESPUESTA;
            RETURN;
          ELSE
            PO_HORA_INI := V_HORA_INICIO;
            PO_HORA_FIN := V_HORA_FIN;
            PO_RESULTADO := 0;
            PO_MSGERR := 'EXITO';
          END IF;

        END IF;
   ELSE
      PO_HORA_INI := '';
      PO_HORA_FIN := '';
      PO_RESULTADO := -2;
      PO_MSGERR := 'No se puede Reagendar utilizando el Sub-tipo porque se encuentra Inactivo.';
      RETURN;
   END IF;
 ELSE
   PO_HORA_INI := '';
   PO_HORA_FIN := '';
   PO_RESULTADO := -1;
   PO_MSGERR := 'La Orden de Trabajo no se puede Reagendar por estar en Estado no permitido';
   RETURN;
 END IF;

 EXCEPTION
   WHEN OTHERS THEN
        PO_HORA_INI := '';
        PO_HORA_FIN := '';
        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM || ' Valida: ' || V_VALIDA;
 END;

/*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_ORDEN
* Propósito : El SP cancela las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_ID_MOTIVO          - Id motivo de cancelacion
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 06/03/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSI_CANCELA_ORDEN(
                                      PI_ID_AGENDA          IN  NUMBER,
                                      PI_ID_MOTIVO          IN  NUMBER,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)
 IS
 V_ESTAGENDA_OLD   NUMBER;
 V_CODSOLOT        NUMBER;
 V_USERNAME        VARCHAR2(50);
 V_ESTAGENDA_NEW   NUMBER := 136;
 V_flag_insercion  VARCHAR2(50);
 V_msg_text        VARCHAR2(100);
 V_ESTSOT_OLD      NUMBER;
 V_ESTSOT_NEW      NUMBER;
 V_OBSERVACION     VARCHAR(100);
 V_ESTSOL_ACT      estsol.estsol%type;
 V_NUMSLC          vtatabslcfac.numslc%type;
 V_CODCLI          solot.codcli%type;
 V_TIPO            paquete_venta.tipo%type;
 V_TIP             tipestsol.tipestsol%type;
 v_TIPSVR          solot.tipsrv%type;
 V_EST_OLD         estsol.estsol%type;
 V_TIP_OLD         tipestsol.tipestsol%type;
 V_FECACTUAL       date;
 V_ESTSOLRXS       number;
 V_MENSAJERECHAZO  varchar2(100);
 V_TIPOPEDD7       number;
 V_TIPOPEDD        number;
 V_SRV_DTH         number(5);
 V_NUMREGISTRO     ope_srv_recarga_cab.numregistro%type;
 V_RESULTADO       varchar2(4000);
 V_MENSAJE         varchar2(4000);
 V_IDWF            wf.idwf%type;
 V_IW              number(5);
 V_MENSAJE_DATO    varchar(1000);
 V_GENERADO        estsol.estsol%type := 17;
 V_CONT            number;
 V_IDWFS            wf.idwf%type;
 V_FLG             number(1);
 BEGIN

 SELECT D.DESCRIPCION
   INTO V_OBSERVACION
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'OBSCANAPP';

 SELECT D.CODIGON
   INTO V_ESTSOT_NEW
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'NEWESTSOT';

  select estage, CODSOLOT
    into V_ESTAGENDA_OLD, V_CODSOLOT
    from operacion.agendamiento a
   where idagenda = PI_ID_AGENDA;

   select S.ESTSOL
    into V_ESTSOT_OLD
    from operacion.SOLOT S
   where S.CODSOLOT = V_CODSOLOT;

   CLRHSI_CAMBIO_AGENDA(PI_ID_AGENDA,
                                                           V_ESTAGENDA_NEW,
                                                           V_ESTAGENDA_OLD,
                                                           V_OBSERVACION,
                                                           PI_ID_MOTIVO,
                                                           trunc(sysdate),
                                                           null);

  SELECT SYS_CONTEXT ('USERENV', 'OS_USER') into V_USERNAME FROM dual;

  operacion.pq_agendamiento.SGASS_ACT_ESTDO_RECL(PI_ID_AGENDA, V_USERNAME, V_ESTAGENDA_OLD, V_ESTAGENDA_NEW,V_flag_insercion,V_msg_text);

  OPERACION.PQ_SOLOT.p_chg_estado_solot(V_CODSOLOT,
                               V_ESTSOT_NEW,
                               V_ESTSOT_OLD,
                               V_OBSERVACION);

    UPDATE OPERACION.AGENDAMIENTO A SET A.FLG_ADC = 0, A.FLG_ORDEN_ADC = 0
    WHERE A.IDAGENDA = PI_ID_AGENDA;

   PO_RESULTADO := 0;
   PO_MSGERR := 'EXITO';
 EXCEPTION
   WHEN OTHERS THEN
        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

 /*
****************************************************************'
* Nombre SP : CLRHSS_MOTIVO_CANCELA
* Propósito : El SP permite traer los motivos de cancelacion para las ordenes agendadas
* Input  :
* Output :  PO_CURSOR             - Cursor del listado los datos de capacidad
            PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_MOTIVO_CANCELA(
                                      PO_CURSOR             OUT SYS_REFCURSOR,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)IS

 BEGIN

 OPEN PO_CURSOR FOR
SELECT DISTINCT M.CODMOT_SOLUCION ID_MOTIVO,
                M.DESCRIPCION DESCRIPCION,
                S.DESCRIPCION DESCRIPCION_CLIENTE
  FROM OPERACION.MOT_SOLUCION M,
       (SELECT D.CODIGON, D.DESCRIPCION
          FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
         WHERE C.TIPOPEDD = D.TIPOPEDD
           AND C.ABREV = 'MOTCANORDCH') S
 WHERE M.CODMOT_SOLUCION = S.CODIGON;


  PO_RESULTADO := 0;
  PO_MSGERR    := 'CONSULTA SATISFACTORIA';

 EXCEPTION
   WHEN OTHERS THEN
        OPEN PO_CURSOR FOR
        SELECT
               '' ID_MOTIVO,
               '' DESCRIPCION,
               '' DESCRIPCION_CLIENTE
          FROM DUAL
         WHERE 1=2;

        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;

 /*
****************************************************************'
* Nombre SP : CLRHSI_CAMBIO_AGENDA
* Propósito : El SP permite cambio de estados para la agenda.
* Input  :  PI_idagenda           - Id Agenda
            PI_estagenda          - Estado de la nueva agenda
            PI_estagenda_old      - Estados de la antigua agenda
            PI_observacion        - Observacion
            PI_mot_solucion       - Motivo Solucion
            PI_fecha              - Fecha de cambio
            PI_cadena_mots        - Varios motivos de solucion
            PI_estado_adc         - Estado ADC de la agenda
            PI_ticket_remedy      - Ticket Remedi
* Output :
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/03/2019
* Fec Actualización : --
****************************************************************
*/

procedure CLRHSI_CAMBIO_AGENDA(PI_idagenda      in number,
                                   PI_estagenda     in number,
                                   PI_estagenda_old in number default null,
                                   PI_observacion   in varchar2 default null,
                                   PI_mot_solucion  in number default null,
                                   PI_fecha         in date default sysdate,
                                   PI_cadena_mots   in varchar2 default null,
                                   PI_estado_adc   in number default null,
                                   PI_ticket_remedy in varchar2 default null
) is

    V_estsol_act   number;
    V_tipo          number;
    V_tipoagenda   number;
    V_proc          number;
    V_sql           varchar2(500);
    V_fecactual     date;
    V_codincidence number;
    V_valida     number;
    V_flgliquidamo number;
    V_ticket_remedy varchar2(20);
    V_idtareawf tareawf.idtareawf%type;
    V_idestado_adc number;
    V_origen       number;
    V_tipo_orden   operacion.tipo_orden_adc.id_tipo_orden%type;
    V_flag_aplica  number;
    V_error        number;
    V_error_T        varchar2(500);
    V_tiptra   number;
    V_codsolot   number;
    V_idtareawf_chg number;
    V_tipo_T         number;
    V_iderror      NUMERIC;
    V_mensajeerror VARCHAR2(200);
    V_observacion   agendamientochgest.observacion%type;
    V_TIPSRV solot.tipsrv%type;
    V_count number;

    cursor cur_tar  is
    select b.tareadef,b.esttarea, c.tipesttar
    from secuencia_estados_agenda a,OPERACION.CIERRE_TAREA_AGENDA b, esttarea c
    where estagendafin=PI_estagenda and estagendaini =V_estsol_act and tiptra=V_tiptra
    and a.idseq=b.idseq and b.esttarea=c.esttarea;
    cursor cur_act  is
    select TIPTRA,CODMOT_SOLUCION,cantidad,codeta,codact from OPERACION.MOT_SOLUCIONXTIPTRA_ACT
    WHERE tiptra=  V_tiptra AND CODMOT_SOLUCION in
    (select codmot_solucion from agendamientochgest where idagenda=PI_idagenda);

    cursor cur_mat  is
    select tiptra,codmot_solucion,cantidad,codeta,codmat from OPERACION.MOT_SOLUCIONXTIPTRA_mat
    WHERE tiptra=  V_tiptra AND CODMOT_SOLUCION=PI_mot_solucion;

    n_total number;
    ln_codmot_solucion number;
    n_codfor number;
    cursor cur_motsol  is
    select a.codfor, sum(a.codmot_solucion) motsol_tot
    from operacion.mot_solucionxfor a, formula b
    where a.codfor=b.codfor and b.flg_motsol=1  and a.tiptra=V_tiptra
    group by a.codfor;
    cursor cur_actmotsol  is
    SELECT codact FROM actetapaxfor WHERE codfor = n_codfor;

    n_val_estage_area number;
    n_idagenda_cambio number;
    n_estadocambio number;
    n_area number;
    cursor c_estage_area is
    select tiptra,areaini,areafin,estagendaini,estagendafin,aplica_bitacora
    from OPERACION.ESTAGENDAAREAHFC where tiptra=V_tiptra and areaini=n_area and estagendaini=PI_estagenda;


    excep_adc EXCEPTION;
    PRAGMA EXCEPTION_INIT(excep_adc, -20099);

  begin

    V_observacion := PI_observacion;
    if V_observacion is null or V_observacion = '' then
      raise_application_error(-20500,
                              'Debe ingresar un comentario para poder cambiar de estado.');
    end if;

    select a.codincidence, a.idtareawf, a.estage,a.tipo_agenda,b.tiptra,b.codsolot,a.area
    into V_codincidence, V_idtareawf,V_estsol_act, V_tipoagenda,V_tiptra,V_codsolot,n_area
    from agendamiento a, solot b
    where a.idagenda = PI_idagenda and a.codsolot=b.codsolot;


    if V_estsol_act <> nvl(PI_estagenda_old, V_estsol_act) then
      raise_application_error(-20500,
                              'Error - El estado no coincide con el valor actual en la Base de Datos.');
    end if;

    select tipestage,FLG_LIQUIDAMO into V_tipo,V_flgliquidamo
    from estagenda where estage = PI_estagenda;
    V_fecactual := sysdate;

    if PI_estagenda in (2, 4) and (PI_cadena_mots = 'N,N,N,N,N,N,N,N' or PI_mot_solucion = 0) then
      raise_application_error(-20500,
                              'Error - Seleccione un motivo de Solucion.');
    end if;

    if V_tipo = 1 then

      OPERACION.PQ_AGENDAMIENTO.p_ejecucion_agendamiento(PI_idagenda,
                               PI_estagenda,
                               V_tipo,
                               V_observacion,
                               PI_mot_solucion,
                               PI_fecha);
    elsif V_tipo = 2 then

      OPERACION.PQ_AGENDAMIENTO.p_ejecucion_agendamiento(PI_idagenda,
                               PI_estagenda,
                               V_tipo,
                               V_observacion,
                               PI_mot_solucion,
                               PI_fecha);
    elsif V_tipo = 3 then

      OPERACION.PQ_AGENDAMIENTO.p_cerrar_agendamiento(PI_idagenda,
                            PI_estagenda,
                            V_tipo,
                            V_observacion,
                            PI_mot_solucion,
                            PI_fecha,
                            PI_cadena_mots);
    elsif V_tipo = 4 then
    BEGIN
      CLRHSI_CANCELA_ORDEN_SGA(PI_idagenda,
                              PI_estagenda,
                              V_tipo,
                              V_observacion,
                              PI_mot_solucion,
                              PI_fecha);
      EXCEPTION
        WHEN excep_adc THEN
          raise_application_error(-20099, SQLERRM);
      END;
    else
      update agendamiento
         set estage = PI_estagenda
       where idagenda = PI_idagenda;
    end if;

      BEGIN
        SELECT nvl(flg_orden_adc, 0)
          INTO V_flag_aplica
          FROM operacion.agendamiento
         WHERE idagenda = PI_idagenda;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_flag_aplica := 0;
      END;

    IF V_flag_aplica = 1 THEN
      V_idestado_adc := PI_estado_adc;
      if PI_estagenda = 22 then
       begin
    select TIPSRV
      into V_TIPSRV
      from solot s
     where s.codsolot = V_codsolot;
    if V_TIPSRV is not null then
        SELECT count(*)
          into V_count
          FROM operacion.parametro_cab_adc c, operacion.parametro_det_adc d
         WHERE d.estado = 1
           AND upper(d.abreviatura) = upper('Claro Empresa')
           AND d.id_parametro = c.id_parametro
           AND c.estado = 1
           AND upper(c.abreviatura) = upper('TIPO_SERVICIOS')
           and d.codigoc = V_TIPSRV;
        if V_count > 0 then
          V_tipo_T := 2;
        else
          V_tipo_T := 1;
        End if;


    end if;
  exception
    WHEN NO_DATA_FOUND THEN
      V_tipo_T         := 0;
      V_iderror      := -1;
      V_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_x_tiposerv] SOT no tiene Tipo Orden definido';
    when others then
      V_tipo_T         := 0;
      V_iderror      := -1;
      V_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_x_tiposerv] Error ' ||
                         sqlerrm;
  end;


        if V_tipo_T = 0 then
          raise_application_error(-20001,
                                  'OPERACION.pq_agendamiento.p_chg_est_agendamiento - ' ||
                                  to_char(V_iderror) || '-' || V_mensajeerror);
        end if;

       if V_tipo_T=2 then
            begin
              select t.id_tipo_orden_ce
                into V_tipo_orden
                from operacion.agendamiento a,
                     operacion.solot        s,
                     operacion.tiptrabajo   t
               where a.idagenda = PI_idagenda
                 and a.codsolot = s.codsolot
                 and s.tiptra = t.tiptra;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_tipo_orden := NULL;
              when others then
                V_tipo_orden := NULL;
            end;
        end if;

       if V_tipo_T=1 then
        begin
              select t.id_tipo_orden
                into V_tipo_orden
                from operacion.agendamiento a,
                     operacion.solot        s,
                     operacion.tiptrabajo   t
               where a.idagenda = PI_idagenda
                 and a.codsolot = s.codsolot
                 and s.tiptra = t.tiptra;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                V_tipo_orden := NULL;
              when others then
                V_tipo_orden := NULL;
            end;
        end if;
        if V_tipo_orden is null then
          V_error := -1;
          V_error_T := '[operacion.pq_adm_cuadrilla.p_act_estado_agenda] Tipo de Trabajo de la Agenda ' ||
                      PI_idagenda || ' No tiene asociado un Tipo de Orden.';

        end if;

        V_idestado_adc := operacion.pq_adm_cuadrilla.f_retorna_estado_ETA_SGA('SGA',
                                                    V_tipo_orden,
                                                    PI_estagenda,
                                                    null,
                                                    V_origen);
        V_observacion := OPERACION.PQ_AGENDAMIENTO.SGAFUN_OBT_OBS_REAGEN(V_observacion,PI_fecha); --64.0
      end if;
    else
      V_idestado_adc := null;
    end if;
    insert into agendamientochgest
      (idagenda,
       tipo,
       estado,
       fecreg,
       observacion,
       FECHAEJECUTADO,
       codmot_solucion
      ,idestado_adc
      ,ticket_remedy)
    values
      (PI_idagenda,
       1,
       PI_estagenda,
       V_fecactual,
       V_observacion,
       PI_fecha,
       PI_mot_solucion
      ,V_idestado_adc
      ,PI_ticket_remedy);

    if V_idtareawf is not null then
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (V_idtareawf, PI_observacion);
    end if;

    begin
      V_proc := null;
    end;
    if V_proc is not null then
      begin
        V_sql := 'begin ' || V_proc || ' ( :1, :2, :3 ); End; ';
        execute immediate V_sql
          using PI_idagenda, PI_estagenda_old, PI_estagenda;
      exception
        when others then
          raise;
      end;
    end if;

    for c_tar in cur_tar loop
      begin
        select a.idtareawf into V_idtareawf_chg
        from tareawfcpy a, wf b
        where a.idwf=b.idwf and b.codsolot=V_codsolot
        and a.tareadef=c_tar.tareadef and b.valido=1;
      exception
        when no_data_found  then
          V_idtareawf_chg:=0;
      end;
      if V_idtareawf_chg>0 then
        OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(V_idtareawf_chg,c_tar.tipesttar, c_tar.esttarea,0,SYSDATE, SYSDATE);
      end if;
    end loop;
    if V_flgliquidamo=1 then
      V_valida:=0;
      for c_c in cur_motsol loop
        begin
          begin
            select sum(codmot_Solucion) into n_total
            from agendamientochgest where idagenda=PI_idagenda
            group by idagenda;
          exception
          when no_data_found  then
            n_total:=0;
          end;
          if c_c.motsol_tot = n_total then
            n_codfor:=c_c.codfor;
            for c_c1 in cur_actmotsol loop
              begin
                V_valida:=1;
                operacion.PQ_EQU_MAT.P_cargar_act_formula(V_codsolot,c_c1.codact,PI_idagenda,c_c.codfor);
              exception
              when others then
                  null;
              end;
            end loop;
         end if;
        end;
      end loop;
      if V_valida =0 then
        for c_act in cur_act loop
          begin
            operacion.PQ_EQU_MAT.P_cargar_act_formula(V_codsolot,c_act.codact,PI_idagenda,null);
          exception
          when others then
             null;
          end;
        end loop;
      end if;
    end if;

    for c in c_estage_area loop
      select count(1) into n_val_estage_area from OPERACION.ESTAGENDAAREAHFC a,agendamiento b
      where a.AREAINI=n_area and a.ESTAGENDAINI=PI_estagenda and b.codsolot=V_codsolot and not b.idagenda=PI_idagenda;
      if n_val_estage_area=1  then
        select b.idagenda,a.estagendafin into n_idagenda_cambio,n_estadocambio from OPERACION.ESTAGENDAAREAHFC a,agendamiento b
        where a.AREAINI=n_area and a.ESTAGENDAINI=PI_estagenda and b.codsolot=V_codsolot and not b.idagenda=PI_idagenda;
        CLRHSI_CAMBIO_AGENDA(n_idagenda_cambio, n_estadocambio,null,V_observacion);--64.0
      end if;

    end loop;


  end;

 /*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_ORDEN
* Propósito : El SP permite cambio de estados para la agenda.
* Input  :  PI_idagenda           - Id Agenda
            PI_estagenda          - Estado de la nueva agenda
            PI_tipo               - Tipo de agenda
            PI_observacion        - Observacion
            PI_mot_solucion       - Motivo Solucion
            PI_fecha              - Fecha de cambio
* Output :
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/03/2019
* Fec Actualización : --
****************************************************************
*/

procedure CLRHSI_CANCELA_ORDEN_SGA(PI_idagenda     in number,
                                    PI_estagenda    in number,
                                    PI_tipo         in number,
                                    PI_observacion  in varchar2,
                                    PI_mot_solucion in number default null,
                                    PI_fecha        in date default sysdate) is

    v_iderror_T      NUMBER;
    V_mensajeerror VARCHAR2(3000);
    V_codsolot     operacion.agendamiento.codsolot%TYPE;
    V_flag_aplica  NUMBER;
    v_iderror       operacion.transaccion_ws_adc.iderror%type;

 begin

    update agendamiento
       set estage = PI_estagenda, tipo_agenda = PI_tipo
     where idagenda = PI_idagenda;

    if OPERACION.PQ_AGENDAMIENTO.f_aplica_incidencia(PI_idagenda) = 1 then

    OPERACION.PQ_AGENDAMIENTO.p_interface_incidencia(PI_idagenda,
                             PI_estagenda,
                             PI_tipo,
                             PI_observacion,
                             PI_mot_solucion,
                             PI_fecha);
    end if;

    Begin
      SELECT nvl(flg_orden_adc, 0)
        INTO V_flag_aplica
        FROM operacion.agendamiento
       WHERE idagenda = PI_idagenda;
    EXCEPTION
      WHEN no_data_found THEN
        v_iderror := -99;
    END;
    IF v_iderror_T = -99 THEN
        raise_application_error(-99, 'ERROR-WS: ' || 'No se encontro flag de visita');
    END IF;

   IF V_flag_aplica = 1 THEN
       Begin
         SELECT tw.iderror
           INTO v_iderror
           FROM operacion.transaccion_ws_adc tw
          WHERE tw.idagenda = PI_idagenda
            AND tw.metodo = 'cancelarOrdenSGA'
            AND tw.idtransaccion =
                (SELECT max(adc.idtransaccion)
                   FROM operacion.transaccion_ws_adc adc
                  WHERE adc.idagenda = tw.idagenda);
       EXCEPTION
          WHEN no_data_found THEN
               v_iderror:=1;
       END;
        IF  v_iderror <> 0 then

      CLRHSI_CANCELA_AGENDA(NULL,
                                                  PI_idagenda,
                                                  PI_estagenda,
                                                  substr(PI_observacion,
                                                         1,
                                                         30),
                                                  v_iderror_T,
                                                  V_mensajeerror);
      IF v_iderror_T = -99 THEN
        raise_application_error(-20099, 'ERROR-WS: ' || V_mensajeerror);
      END IF;
      IF v_iderror_T < 0 THEN
        raise_application_error(-20001, V_mensajeerror);
      END IF;
        END IF;
    END IF;
  end;

PROCEDURE CLRHSI_CANCELA_AGENDA(PI_codsolot     IN operacion.agendamiento.codsolot%TYPE,
                             PI_idagenda     IN operacion.agendamiento.idagenda%TYPE,
                             PI_estagenda    IN NUMBER,
                             PI_observacion  IN operacion.cambio_estado_ot_adc.motivo%TYPE,
                             PO_iderror      OUT NUMERIC,
                             PO_mensajeerror OUT VARCHAR2) IS
    V_error    EXCEPTION;
    V_error_ws EXCEPTION;
    V_codsolot   operacion.agendamiento.codsolot%TYPE;
    V_tipo_orden operacion.tipo_orden_adc.id_tipo_orden%type;
    V_origen     NUMBER;
    V_id_estado  NUMBER;
    V_process    VARCHAR2(50);
    V_tipo       number;
    V_aplicacion VARCHAR2(20) := 'SGA';
    V_motivo_T     number := 0;
    V_motivo   operacion.estado_motivo_sga_adc.idmotivo_sga_origen%type;

    CURSOR c_agenda IS
      SELECT a.idagenda, a.estage
        FROM operacion.agendamiento a
       WHERE a.codsolot = PI_codsolot;
  BEGIN
    PO_iderror      := 1;
    PO_mensajeerror := NULL;
    V_codsolot     := PI_codsolot;

    IF V_codsolot IS NULL OR V_codsolot = 0 THEN
      V_process := 'Cancelacion de Agenda';
      BEGIN
        SELECT codsolot
          INTO V_codsolot
          FROM operacion.agendamiento
         WHERE idagenda = PI_idagenda
           and rownum = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          PO_iderror      := 0;
          PO_mensajeerror := '[operacion.PKG_CLAROHOHAR.CLRHSI_CANCELA_AGENDA] Agenda no existe';
          RAISE V_error;

      END;

  begin
    select t.flg_tipo
      into V_tipo
      from operacion.agendamiento a
      join operacion.SUBTIPO_ORDEN_ADC st
        on a.id_subtipo_orden = st.id_subtipo_orden
      join operacion.TIPO_ORDEN_ADC t
        on st.id_tipo_orden = t.id_tipo_orden
     where a.idagenda = PI_idagenda;

  exception
    WHEN NO_DATA_FOUND THEN
      V_tipo         := 0;
      PO_iderror      := -1;
      PO_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_agenda] Agenda no tiene Tipo ';
    when others then
      V_tipo         := 0;
      PO_iderror      := -1;
      PO_mensajeerror := '[operacion.pq_adm_cuadrilla.p_tipo_serv_x_agenda] Error ' ||
                         sqlerrm;
  end;

      if V_tipo = 0 then
        RAISE V_error;
      END if;
      BEGIN
        if V_tipo = 1 then
          select t.id_tipo_orden
            into V_tipo_orden
            from operacion.tiptrabajo t
           where t.tiptra in (SELECT s.tiptra
                                FROM operacion.solot s
                               WHERE codsolot = V_codsolot);
        else
          select t.id_tipo_orden_ce
            into V_tipo_orden
            from operacion.tiptrabajo t
           where t.tiptra in (SELECT s.tiptra
                                FROM operacion.solot s
                               WHERE codsolot = V_codsolot);
        end if;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          PO_iderror      := 0;
          PO_mensajeerror := '[operacion.PKG_CLAROHOHAR.CLRHSI_CANCELA_AGENDA] Tipo de Trabajo no existe';
          RAISE V_error;
      END;

      if V_tipo_orden is null then
        PO_iderror      := 0;
        PO_mensajeerror := '[operacion.PKG_CLAROHOHAR.CLRHSI_CANCELA_AGENDA] Tipo de Orden no esta Configurada.';
        RAISE V_error;
      end if;
    ELSE
      V_process  := 'Anulacion de SOLOT';
      V_codsolot := PI_codsolot;
    END IF;

    begin
      SELECT d.codigon
        into V_origen
        FROM operacion.parametro_det_adc d, operacion.parametro_cab_adc c
       WHERE d.abreviatura = V_aplicacion
         AND d.id_parametro = c.id_parametro
         AND c.abreviatura = 'SISTEMA'
         and d.estado = 1
         and c.estado = 1;
    EXCEPTION
      WHEN no_data_found THEN
        V_origen := 0;
    END;

    if V_motivo_T is null then
      V_motivo := 0;
    else
      V_motivo := V_motivo_T;
    end if;

    if V_origen = 1 then
      begin
        select idestado_sga_origen
          into V_id_estado
          from operacion.estado_motivo_sga_adc
         where id_tipo_orden = V_tipo_orden
           and idestado_adc_destino = PI_estagenda
           and idmotivo_sga_destino = V_motivo;
      EXCEPTION
        WHEN no_data_found THEN
          V_id_estado := 0;
      END;
    end if;

    if V_origen = 2 then
      begin
        select idestado_adc_destino
          into V_id_estado
          from operacion.estado_motivo_sga_adc
         where id_tipo_orden = V_tipo_orden
           and idestado_sga_origen = PI_estagenda
           and idmotivo_sga_origen = V_motivo;
      EXCEPTION
        WHEN no_data_found THEN
          V_id_estado := 0;
      END;
    end if;

    INSERT INTO operacion.cambio_estado_ot_adc
      (codsolot, origen, idagenda, id_estado, motivo)
    VALUES
      (V_codsolot, V_aplicacion, PI_idagenda, V_id_estado, PI_observacion);

  BEGIN
    FOR c1 IN c_agenda LOOP
      CLRHSI_CAMBIO_AGENDA(c1.idagenda,
                                                       5,
                                                       c1.estage,
                                                       'Cancelado por Anulacion de SOT: ' ||
                                                       V_codsolot);
    END LOOP;
    PO_iderror := 1;
    PO_mensajeerror   := 'Ok';
  EXCEPTION
    WHEN OTHERS THEN
      PO_iderror := -1;
      PO_mensajeerror   := '[operacion.pq_adm_cuadrilla.p_cancelar_agendaxsot] Se genero el error: ' ||
                     SQLERRM || '.';
  END;
    if PO_iderror<>1 then
      return;
    end if;

    PO_iderror      := 1;
    PO_mensajeerror := NULL;
  EXCEPTION
    WHEN V_error_ws THEN
      PO_iderror := -99;

    WHEN V_error THEN
      PO_iderror := 0;

    WHEN OTHERS THEN
      PO_iderror      := -1;
      PO_mensajeerror := '[operacion.PKG_CLAROHOHAR.CLRHSI_CANCELA_AGENDA] Se genero el error: ' ||
                         sqlerrm || '.';
  END CLRHSI_CANCELA_AGENDA;

/*
****************************************************************'
* Nombre SP : CLRHSI_REAGENDA_TOA
* Propósito : El SP reagendar las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_FECHA_AGENDA       - Fecha de nueva agenda
            PI_FRANJA             - Nueva franja horaria
            PI_ID_BUCKET          - Id de contrata seleccionada
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 18/02/2019
* Fec Actualización : --
* 1.0       20/11/2019  Cesar Rengifo     Actualizacion campo fecagenda
****************************************************************
*/

PROCEDURE CLRHSI_REAGENDA_TOA(
                                      PI_ID_AGENDA          IN  VARCHAR2,
                                      PI_FECHA_AGENDA       IN  DATE,
                                      PI_FRANJA             IN  VARCHAR2,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)
 IS
 V_CODIGO_RESPUESTA  NUMBER;
 V_MENSAJE_RESPUESTA VARCHAR2(100);
 V_ESTADO            VARCHAR2(50);
 V_COD_SUBTIPO_ORDEN OPERACION.SUBTIPO_ORDEN_ADC.COD_SUBTIPO_ORDEN%TYPE;
 V_TIPO_TRABAJO      TIPTRABAJO.TIPTRA%TYPE;
 V_COD_CUADRILLA     OPERACION.AGENDAMIENTO.CODCUADRILLA%TYPE;
 V_CONTRACT_ADC      OPERACION.AGENDAMIENTO.CODCON%TYPE;
 V_DIRECCION         OPERACION.AGENDAMIENTO.DIRECCION%TYPE;
 V_TELEFONO          OPERACION.AGENDAMIENTO.TELEFONO_ADC%TYPE;
 V_OBSERVACION       VARCHAR2(150);
 V_ZL                NUMBER;
 V_FECHA_PROGRA      VARCHAR2(50);
 V_FECHA_PROGRA_2    DATE;
 V_EXISTE           NUMBER;
 V_ESTAGENDA_OLD    operacion.agendamiento.estage%type;
 V_VALIDA           VARCHAR2(50);
 V_HORA_INICIO       VARCHAR2(50);
 V_HORA_FIN          VARCHAR2(50);
 V_ID_BUCKET         VARCHAR2(50);
 BEGIN

 SELECT (F.FRANJA_INI || ' ' || F.IND_MERID_FI),
        (F.FRANJA_FIN || ' ' || F.IND_MERID_FF)
   INTO V_HORA_INICIO, V_HORA_FIN
   FROM OPERACION.FRANJA_HORARIA F
  WHERE F.CODIGO = PI_FRANJA;

 SELECT S.COD_SUBTIPO_ORDEN, SO.TIPTRA, A.IDBUCKET
   INTO V_COD_SUBTIPO_ORDEN, V_TIPO_TRABAJO, V_ID_BUCKET
   FROM OPERACION.AGENDAMIENTO      A,
        OPERACION.SUBTIPO_ORDEN_ADC S,
        OPERACION.SOLOT             SO
  WHERE A.ID_SUBTIPO_ORDEN = S.ID_SUBTIPO_ORDEN
    AND SO.CODSOLOT = A.CODSOLOT
    AND A.IDAGENDA = PI_ID_AGENDA;

 SELECT D.DESCRIPCION
   INTO V_OBSERVACION
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'OBSREAGETOA';

 V_VALIDA := 0;
 OPERACION.PQ_AGENDAMIENTO.SGASS_VALIDA_ESTADO(PI_ID_AGENDA,V_ESTADO,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
 V_VALIDA := 1;
 IF V_CODIGO_RESPUESTA = 1 THEN
   OPERACION.PQ_AGENDAMIENTO.SGASS_VALIDA_SUBTIPO(V_COD_SUBTIPO_ORDEN,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
   V_VALIDA := 2;
   IF V_CODIGO_RESPUESTA = 1 THEN
        V_ZL := OPERACION.PQ_ADM_CUADRILLA.f_val_zonalejana(PI_ID_AGENDA);
        V_VALIDA := 3;
        IF V_ZL > 0 THEN
          PO_RESULTADO := -3;
          PO_MSGERR := 'La orden no se puede reagendar por pertenecer a una zona lejana';
          return;
        end if;

        FOR C_DATO IN (select idagenda          Id_agenda,
                              Codcon            Codcon,
                              idagenda          Contacto_adc,
                              direccion         Direccion,
                              telefono_adc      Telefono,
                              id_subtipo_orden  Id_subtipo_orden,
                              observacion       Observacion,
                              codcuadrilla      CodCuadrilla
                              from operacion.agendamiento
                              where operacion.agendamiento.idagenda = PI_ID_AGENDA)
          LOOP
            V_COD_CUADRILLA := C_DATO.CODCUADRILLA;
            V_CONTRACT_ADC := C_DATO.CODCON;
            V_DIRECCION := C_DATO.DIRECCION;
            V_TELEFONO := C_DATO.Telefono;
          END LOOP;
        V_FECHA_PROGRA := PI_FECHA_AGENDA|| ' ' ||V_HORA_INICIO;
        SELECT to_date(to_char(to_date(V_FECHA_PROGRA,
                                       'DD/MM/YY HH:MI AM'),
                               'dd/mm/yyyy') || ' ' || V_HORA_INICIO,
                       'dd/mm/yyyy hh:mi AM') INTO V_FECHA_PROGRA_2
          FROM DUAL;

        OPERACION.PQ_AGENDAMIENTO.P_REAGENDAMIENTO(PI_ID_AGENDA,V_TIPO_TRABAJO,V_FECHA_PROGRA_2,V_OBSERVACION,V_CONTRACT_ADC,V_MENSAJE_RESPUESTA,V_CODIGO_RESPUESTA);
        V_VALIDA := 4;
        IF V_CODIGO_RESPUESTA = -1 THEN
          PO_RESULTADO := -4;
          PO_MSGERR := V_MENSAJE_RESPUESTA;
          RETURN;
        ELSE

        if to_number(V_CONTRACT_ADC) > 0 then
          select estage
            into V_ESTAGENDA_OLD
            from operacion.agendamiento a
           where idagenda = PI_ID_AGENDA;
           begin
             select 1
               into V_EXISTE
               from operacion.contrata
              where codcon = to_number(V_CONTRACT_ADC);
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               V_EXISTE := 0;
           end;

        if V_EXISTE = 0 then
            PO_RESULTADO := -6;
            PO_MSGERR := 'NO EXISTE CONTRATA';
        else
          UPDATE operacion.agendamiento
             SET codcon = to_number(V_CONTRACT_ADC),
			 fecagenda = to_date(to_char(to_date(V_FECHA_PROGRA,'DD/MM/YY HH:MI AM'),
                         'dd/mm/yyyy') || ' ' || V_HORA_INICIO,'dd/mm/yyyy hh:mi AM') --1.0
           WHERE idagenda = PI_ID_AGENDA;
		   commit; -- 1.0


          operacion.pq_agendamiento.p_asig_contrata(PI_ID_AGENDA,
                                                    to_number(V_CONTRACT_ADC),
                                                    'Asigando por proceso ETADirect');
          V_VALIDA := 5;

          operacion.pq_agendamiento.p_chg_est_agendamiento(PI_ID_AGENDA,
                                                           '16',
                                                           V_ESTAGENDA_OLD,
                                                           'Agendado en ETADirect',
                                                           null,
                                                           trunc(sysdate),
                                                           null);
          V_VALIDA := 5;

            PO_RESULTADO := 0;
            PO_MSGERR := 'EXITO';
        end if;
      ELSE
            PO_RESULTADO := -5;
            PO_MSGERR := 'CONTRATA NO ENVIADA';
      end if;

          OPERACION.PQ_ADM_CUADRILLA.P_ASIGNACONTRATA_ST(PI_ID_AGENDA,V_COD_SUBTIPO_ORDEN,V_ID_BUCKET,V_CONTRACT_ADC,V_CODIGO_RESPUESTA,V_MENSAJE_RESPUESTA);
          V_VALIDA := 6;
          IF V_CODIGO_RESPUESTA = -1 THEN
            PO_RESULTADO := -5;
            PO_MSGERR := V_MENSAJE_RESPUESTA;
            RETURN;
          ELSE
            PO_RESULTADO := 0;
            PO_MSGERR := 'EXITO';
          END IF;

        END IF;
   ELSE
      PO_RESULTADO := -2;
      PO_MSGERR := 'No se puede Reagendar utilizando el Sub-tipo porque se encuentra Inactivo.';
      RETURN;
   END IF;
 ELSE
   PO_RESULTADO := -1;
   PO_MSGERR := 'La Orden de Trabajo no se puede Reagendar por estar en Estado no permitido';
   RETURN;
 END IF;

 EXCEPTION
   WHEN OTHERS THEN
        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM || ' Valida: ' || V_VALIDA;
 END;

/*
****************************************************************'
* Nombre SP : CLRHSI_CANCELA_TOA
* Propósito : El SP cancela las visitas tecnicas asignadas al cliente
* Input  :  PI_ID_AGENDA          - Id agenda de la orden
            PI_ID_MOTIVO          - Id motivo de cancelacion
* Output :  PO_RESULTADO          - Codigo resultado
            PO_MSGERR             - Mensaje resultado
* Creado por : Obed Ortiz Navarrete
* Fec Creación : 06/03/2019
* Fec Actualización : --
****************************************************************
*/

PROCEDURE CLRHSI_CANCELA_TOA(
                                      PI_ID_AGENDA          IN  NUMBER,
                                      PI_ID_MOTIVO          IN  NUMBER,
                                      PO_RESULTADO          OUT INTEGER,
                                      PO_MSGERR             OUT VARCHAR2)
 IS
 V_ESTAGENDA_OLD   NUMBER;
 V_CODSOLOT        NUMBER;
 V_USERNAME        VARCHAR2(50);
 V_ESTAGENDA_NEW   NUMBER := 136;
 V_flag_insercion  VARCHAR2(50);
 V_msg_text        VARCHAR2(100);
 V_ESTSOT_OLD      NUMBER;
 V_ESTSOT_NEW      NUMBER;
 V_OBSERVACION     VARCHAR(100);
 V_ESTSOL_ACT      estsol.estsol%type;
 V_NUMSLC          vtatabslcfac.numslc%type;
 V_CODCLI          solot.codcli%type;
 V_TIPO            paquete_venta.tipo%type;
 V_TIP             tipestsol.tipestsol%type;
 v_TIPSVR          solot.tipsrv%type;
 V_EST_OLD         estsol.estsol%type;
 V_TIP_OLD         tipestsol.tipestsol%type;
 V_FECACTUAL       date;
 V_ESTSOLRXS       number;
 V_MENSAJERECHAZO  varchar2(100);
 V_TIPOPEDD7       number;
 V_TIPOPEDD        number;
 V_SRV_DTH         number(5);
 V_NUMREGISTRO     ope_srv_recarga_cab.numregistro%type;
 V_RESULTADO       varchar2(4000);
 V_MENSAJE         varchar2(4000);
 V_IDWF            wf.idwf%type;
 V_IW              number(5);
 V_MENSAJE_DATO    varchar(1000);
 V_GENERADO        estsol.estsol%type := 17;
 V_CONT            number;
 V_IDWFS            wf.idwf%type;
 V_FLG             number(1);
 BEGIN

 SELECT D.DESCRIPCION
   INTO V_OBSERVACION
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'OBSCANTOA';

 SELECT D.CODIGON
   INTO V_ESTSOT_NEW
   FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
  WHERE C.TIPOPEDD = D.TIPOPEDD
    AND C.ABREV = 'DATAGENDACH'
    AND D.ABREVIACION = 'NEWESTSOT';

  select estage, CODSOLOT
    into V_ESTAGENDA_OLD, V_CODSOLOT
    from operacion.agendamiento a
   where idagenda = PI_ID_AGENDA;

   select S.ESTSOL
    into V_ESTSOT_OLD
    from operacion.SOLOT S
   where S.CODSOLOT = V_CODSOLOT;

   CLRHSI_CAMBIO_AGENDA(PI_ID_AGENDA,
                                                           V_ESTAGENDA_NEW,
                                                           V_ESTAGENDA_OLD,
                                                           V_OBSERVACION,
                                                           PI_ID_MOTIVO,
                                                           trunc(sysdate),
                                                           null);

  SELECT SYS_CONTEXT ('USERENV', 'OS_USER') into V_USERNAME FROM dual;

  operacion.pq_agendamiento.SGASS_ACT_ESTDO_RECL(PI_ID_AGENDA, V_USERNAME, V_ESTAGENDA_OLD, V_ESTAGENDA_NEW,V_flag_insercion,V_msg_text);

  OPERACION.PQ_SOLOT.p_chg_estado_solot(V_CODSOLOT,
                               V_ESTSOT_NEW,
                               V_ESTSOT_OLD,
                               V_OBSERVACION);

    UPDATE OPERACION.AGENDAMIENTO A SET A.FLG_ADC = 0, A.FLG_ORDEN_ADC = 0
    WHERE A.IDAGENDA = PI_ID_AGENDA;

   PO_RESULTADO := 0;
   PO_MSGERR := 'EXITO';
 EXCEPTION
   WHEN OTHERS THEN
        PO_RESULTADO             := -99;
        PO_MSGERR                := 'ERROR: '||TO_CHAR(SQLCODE)||' '||SQLERRM;
 END;


 /*
****************************************************************'
* Nombre SP : CLRHSS_SUBSIDIARYDET_DTH
* Propósito : El obtiene la sot de un producto dth postpago bajo el contrato
* Input  :  PI_CODSOLOT           - Codigo de SOT
* Output :  PO_CODIGO_SALIDA      - Codigo resultado
            PO_MENSAJE_SALIDA     - Mensaje resultado
            PO_CURSOR_SUCURSALES  - Cursor del listado de direccion de instalaccion
* Creado por : Jefferson Ore
* Fec Creación : 20/06/2019
* Fec Actualización : --
****************************************************************
*/
PROCEDURE CLRHSS_SUBSIDIARYDET_DTH(PI_CODSOLOT          IN  NUMBER,
                                    PO_CODIGO_SALIDA     OUT INTEGER,
                                    PO_MENSAJE_SALIDA    OUT VARCHAR2,
                                    PO_CURSOR_SUCURSALES OUT SYS_REFCURSOR)
 IS
 BEGIN
    PO_CODIGO_SALIDA  := 0;
    PO_MENSAJE_SALIDA := 'OK';
    OPEN PO_CURSOR_SUCURSALES FOR
      SELECT DISTINCT I.CODCLI,
                      I.CODSUC,
                      SC.DIRSUC DIRECCION,
                      PI_CODSOLOT AS CODSOLOT,
                      U.CODUBI AS UBIGEO,
                      U.NOMDEPA AS DEPARTAMENTO,
                      U.NOMPROV AS PROVINCIA,
                      U.NOMDST AS DISTRITO,
                      '0' AS INTERNET,
                      '0' AS TELEFONIA,
                      '1' AS CABLE
        FROM OPERACION.SOLOT     S,
             SALES.VTATABSLCFAC  P,
             OPERACION.INSSRV    I,
             MARKETING.VTATABDST U,
             MARKETING.VTASUCCLI SC
       WHERE S.NUMSLC = P.NUMSLC
         AND P.NUMSLC = I.NUMSLC
         AND SC.CODSUC = I.CODSUC
         AND U.CODUBI = SC.UBISUC
         AND S.CODSOLOT = PI_CODSOLOT;
       EXCEPTION
 WHEN OTHERS THEN
  PO_CODIGO_SALIDA  := -1;
  PO_MENSAJE_SALIDA := 'ERROR EN CLRHSS_SUBSIDIARYDET_DTH: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
  OPEN PO_CURSOR_SUCURSALES FOR
    SELECT '' CODCLI,
           '' CODSUC,
           '' DIRECCION,
           '' CODSOLOT,
           '' UBIGEO,
           '' DEPARTAMENTO,
           '' PROVINCIA,
           '' DISTRITO,
           '' INTERNET,
           '' TELEFONIA,
           '' CABLE
      FROM DUAL
     WHERE ROWNUM < 1;
  END;

/*
****************************************************************'
* Nombre SP : CLRHSS_TRMODELO
* Propósito : El SP permite obtener el grupo, estado y la banda de un modelo CM
* Input :  PI_TRV_MODELO   - Modelo del CM
* Output : PO_TRV_GRUPO    - Grupo de modelos de CM
           PO_TRV_ESTADO   - Codigo resultado
           PO_TRV_BANDA    - Banda
           PO_RESULTADO    - Codigo resultado
           PO_MSGERR       - Mensaje resultado
* Creado por : Hitss
* Fec Creación : 25/07/2019
* Fec Actualización : --
****************************************************************
*/

 PROCEDURE CLRHSS_TRMODELO(PI_TRV_MODELO IN VARCHAR2,
                           PO_TRV_GRUPO  OUT VARCHAR2,
                           PO_TRV_ESTADO OUT VARCHAR2,
                           PO_TRV_BANDA  OUT VARCHAR2,
                           PO_RESULTADO  OUT INTEGER,
                           PO_MSGERR     OUT VARCHAR2) IS

 BEGIN

   SELECT trv_grupo, trv_estado, trv_banda
     INTO PO_TRV_GRUPO, PO_TRV_ESTADO, PO_TRV_BANDA
     FROM operacion.clrht_trmodelo
    WHERE trv_modelo_inc = PI_TRV_MODELO;

   PO_RESULTADO := 0;
   PO_MSGERR    := 'EXITO';

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_RESULTADO := -1;
      PO_MSGERR    := 'MODELO NO EXISTE';
   WHEN OTHERS THEN
     PO_RESULTADO := -99;
     PO_MSGERR    := 'ERROR: ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM;
 END;

PROCEDURE SP_REGISTRAR_NOCLIENTE(a_idtareawf in number default null,
                                a_idwf      in number,
                                a_tarea     in number default null,
                                a_tareadef  in number default null) IS

  l_codsolot                      varchar2(100);
  l_ntdide                        varchar2(100);
  l_tipdide                       varchar2(100);
  l_mail                          varchar2(100);
  l_customer_id                   operacion.solot.customer_id%type;
  l_cod_id                        operacion.solot.cod_id%type;
  v_target_url                    operacion.OPE_CAB_XML.target_url%type;
  v_xml_item                      CLOB;
  v_xml_static                    CLOB;
  v_xml_itemaux                   CLOB;
  v_output                        CLOB;
  v_metodo                        varchar2(2000);
  n_item                          number;
  n_idcab_item                    number;
  n_idcab                         number;
  n_tipsrv                        char(3);
  n_tipdide                       char(2);
  n_tecnologia                    varchar2(100);
  lc_soap_response                CLOB;
  lc_RESPUESTAXML                 CLOB;
  lv_code                         VARCHAR2(1000);
  lv_description                  VARCHAR2(1000);
  pn_idenvio                      number;
  status                          number;
  error                           varchar2(2000);
  CURSOR cur_usu_nocli IS
      select distinct a.ntdide, a.tipdide, a.mail, b.customer_id, b.cod_id, e.numero, g.descripcion, e.tipsrv, f.dscsrv
      from marketing.vtatabcli a, operacion.solot b, operacion.solotpto c, operacion.insprd d, operacion.inssrv e, sales.tystabsrv f, operacion.tiptrabajo g
      where a.codcli=b.codcli and b.codsolot=c.codsolot and c.pid=d.pid and c.codinssrv=e.codinssrv
      and e.codsrv=f.codsrv and b.tiptra=g.tiptra and b.codsolot=l_codsolot and e.tipsrv in ('0006', '0004', '0062');

  BEGIN
      n_tecnologia          := 'HFC';

      select codsolot into l_codsolot from wf where idwf = a_idwf;

      select idcab, xmlclob, xmlclob into n_idcab_item, v_xml_item, v_xml_itemaux
      from operacion.ope_cab_xml where programa = lv_registra_usuario_det;

      n_item := 1;
      for c in cur_usu_nocli loop
        if n_item != 1 then
          v_xml_item := v_xml_item ||','|| v_xml_itemaux;
        end if;

        if c.tipsrv = '0004' then          --telefonía SGA
           n_tipsrv := '002';
        elsif c.tipsrv = '0006' then       --Internet SGA
           n_tipsrv := '005';
        elsif c.tipsrv = '0062' then       --Cable TV SGA
           n_tipsrv := '003';
        end if;

        p_reg_xml(v_xml_item, 'f_productNumber', c.numero, 4, v_xml_item);
        p_reg_xml(v_xml_item, 'f_productPlatform', n_tecnologia, 4, v_xml_item);
        p_reg_xml(v_xml_item, 'f_productType', n_tipsrv, 4, v_xml_item);
        p_reg_xml(v_xml_item, 'f_prodOfferName', c.dscsrv, 4, v_xml_item);
        n_item := n_item + 1;

      end loop;

    select vt.ntdide, vt.tipdide, s.customer_id, s.cod_id, vt.MAIL
    into l_ntdide, l_tipdide, l_customer_id, l_cod_id, l_mail
    from operacion.solot s, marketing.vtatabcli vt where s.codcli=vt.codcli and s.codsolot = l_codsolot;

    select idcab, target_url, metodo, xmlclob
    into n_idcab, v_target_url, v_metodo, v_xml_static
    from operacion.ope_cab_xml
    where programa = lv_registra_usuario_cab;

    if l_tipdide = '002' then   --DNI SGA
       n_tipdide := '01';
    elsif l_tipdide = '004' then --Carnet Extranjeria SGA
       n_tipdide := '02';
    elsif l_tipdide = '006' then --Pasaporte SGA
       n_tipdide := '03';
    elsif l_tipdide = '001' then --RUC SGA
       n_tipdide := '04';
    end if;

    p_reg_xml(v_xml_static, 'f_idCardValue', l_ntdide, 4, v_xml_static);
    p_reg_xml(v_xml_static, 'f_customerDocType', n_tipdide, 4,v_xml_static);
    p_reg_xml(v_xml_static, 'f_customerId', l_customer_id, 4,v_xml_static);
    p_reg_xml(v_xml_static, 'f_coId', l_cod_id, 4,v_xml_static);
    p_reg_xml(v_xml_static, 'f_email', l_mail, 4, v_xml_static);
    p_reg_xml(v_xml_static, 'f_xml_dinamico', v_xml_item, 5, v_xml_static);

    p_call_webservice(v_xml_static,
                       v_target_url,
                       v_metodo,
                       lc_soap_response,
                       v_output,
                       status,
                       error);
    lc_RESPUESTAXML := lc_soap_response;

    if status >= 0 then
      lv_code        := f_obtener_tag('codeResponse', lc_RESPUESTAXML);
      lv_description := f_obtener_tag('descriptionResponse', lc_RESPUESTAXML);

      status := lv_code;
      error  := lv_description;
    else
      error := '[APP SmartHome] Error al llamar al WS - ' || error;
    end if;

    select max(idenvio)+1 into pn_idenvio from OPERACION.OPE_WS_INCOGNITO;
    insert into OPERACION.OPE_WS_INCOGNITO (idenvio, TIPO, RESPUESTAXML, ENVIOXML, RESULTADO, ERROR, FECACTWS, CUSTOMER_ID, AUTHORIZATION, codsolot, serviceid, url, cabecera)
    values(pn_idenvio, lv_registra_usuario_cab,lc_RESPUESTAXML, v_xml_static, status, error, sysdate, l_customer_id, null, l_codsolot, null, v_target_url,v_output);
    COMMIT;
END;

PROCEDURE P_REG_XML(a_xml        CLOB,
                    a_campo      varchar2,
                    a_query      varchar2,
                    a_tipo       in number default null,
                    a_xml_out    in out CLOB,
                    a_par1       in varchar2 default null,
                    a_par2       in varchar2 default null) is
    v_campo varchar2(200);
    begin
      if a_tipo=2 then--Ejecutable de la tabla
        EXECUTE IMMEDIATE a_query INTO v_campo;
        select replace(a_xml, '@'||a_campo,v_campo) into a_xml_out from dual;
      elsif a_tipo=4 then--valor ingresado
        select replace(a_xml, '@'||a_campo,a_query) into a_xml_out from dual ;
      elsif a_tipo=3 then --Ejecutable de la tabla con parametros
        EXECUTE IMMEDIATE a_query INTO v_campo using a_par1,a_par2;
        select replace(a_xml, '@'||a_campo,v_campo) into a_xml_out from dual ;
      elsif a_tipo=1 then --Constante de la tabla
        select replace(a_xml, '@'||a_campo,a_query) into a_xml_out from dual;
      elsif a_tipo=5 then --Constante de la tabla
        a_xml_out := f_clob_replace(a_xml,'@'||a_campo,a_query);
      end if;
end;

FUNCTION F_CLOB_REPLACE (p_clob IN CLOB,
                         p_what IN VARCHAR2,
                         p_with IN VARCHAR2) RETURN CLOB IS

   c_whatLen       CONSTANT PLS_INTEGER := LENGTH(p_what);
   c_withLen       CONSTANT PLS_INTEGER := LENGTH(p_with);
   l_return        CLOB;
   l_segment       CLOB;
   l_pos           PLS_INTEGER := 1-c_withLen;
   l_offset        PLS_INTEGER := 1;
  BEGIN
  IF p_what IS NOT NULL THEN
    WHILE l_offset < DBMS_LOB.GETLENGTH(p_clob) LOOP
      l_segment := DBMS_LOB.SUBSTR(p_clob,32767,l_offset);
      LOOP
        l_pos := DBMS_LOB.INSTR(l_segment,p_what,l_pos+c_withLen);
        EXIT WHEN (NVL(l_pos,0) = 0) OR (l_pos = 32767-c_withLen);
        l_segment := TO_CLOB( DBMS_LOB.SUBSTR(l_segment,l_pos-1)
                            ||p_with
                            ||DBMS_LOB.SUBSTR(l_segment,32767-c_whatLen-l_pos-c_whatLen+1,l_pos+c_whatLen));
      END LOOP;
      l_return := l_return||l_segment;
      l_offset := l_offset + 32767 - c_whatLen;
    END LOOP;
  END IF;
  RETURN(l_return);
END;

PROCEDURE P_CALL_WEBSERVICE(ac_payload         in CLOB,
                            ac_target_url      in varchar2,
                            v_metodo           in varchar2,
                            lc_soap_response   out CLOB,
                            v_output           out CLOB,
                            status             out number,
                            error              out varchar2) is
  http_req utl_http.req;
  http_resp utl_http.resp;
  lc_soap_request                     varchar2(30000);
  v_campo                             varchar2(400);
  v_cabecera                          varchar2(2000);
  v_valor                             varchar2(400);
  begin
    error      := 'Ok';
    v_cabecera := '';
    lc_soap_request := ac_payload;
    select OPERACION.SQ_OPE_WS_INCOGNITO.NEXTVAL into pn_idenvio from dual;

    http_req := utl_http.begin_request(ac_target_url, v_metodo, 'HTTP/1.1');
    Utl_Http.Set_Header(Http_Req, 'Content-Type', 'application/json');
    utl_http.set_header(http_req, 'Content-Length', length(lc_soap_request));

    for c_s in (select idcab, idseq, campo, nombrecampo, tipo
                from OPERACION.OPE_DET_XML
                where idcab = (SELECT idcab
                               from OPERACION.OPE_CAB_XML
                               where PROGRAMA = lv_registra_usuario_cab)
                and tipo = 3 ORDER BY idseq) loop
      --Cabecera
      if c_s.campo = 'userId' then
        v_campo := c_s.nombrecampo;
      elsif c_s.campo = 'accept' then
        v_campo := c_s.nombrecampo;
      else
        EXECUTE IMMEDIATE c_s.nombrecampo
          INTO v_campo;
      end if;

      Utl_Http.Set_Header(Http_Req, c_s.campo, v_campo);
      v_cabecera := v_cabecera || c_s.campo || ':' || v_campo || CHR(10);

    end loop;

    begin
      UTL_HTTP.set_transfer_timeout(1800);--1.6
      utl_http.write_text(http_req, lc_soap_request);
      http_resp:= utl_http.get_response(http_req);
      status    := Http_Resp.status_code;
    Exception
      When TIMEOUT_ON_RESOURCE Then
        status := Http_Resp.status_code;
        error  := 'Timeout: Error de disponibilidad al Recurso';
    end;

    utl_http.read_text(http_resp, lc_soap_response);

    FOR i IN 1 .. utl_http.get_header_count(Http_Resp) LOOP
      utl_http.get_header(Http_Resp, i, v_campo, v_valor);
      v_output := v_output || v_campo || ':' || v_valor || CHR(10);
    END LOOP;

    v_output := v_output || CHR(10);
    v_output := v_output || v_cabecera;

    utl_http.end_response(http_resp);

    EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(http_resp);
    WHEN OTHERS THEN
      UTL_HTTP.end_response(http_resp);
end;

FUNCTION F_OBTENER_TAG(av_tag VARCHAR2,
                         av_trama CLOB) RETURN VARCHAR2 IS
    lv_rpta CLOB;
    lv_retn VARCHAR2(1000);
  BEGIN
    IF INSTR(av_trama, av_tag) = 0 THEN
      RETURN '';
    END IF;

    lv_rpta := SUBSTR(av_trama, INSTR(av_trama, av_tag), LENGTH(av_trama));
    lv_rpta := SUBSTR(lv_rpta, INSTR(lv_rpta, ':') + 3, LENGTH(lv_rpta));
    lv_rpta := TRIM(SUBSTR(lv_rpta, 1, INSTR(lv_rpta, '"') - 1));
    lv_retn := lv_rpta;

    RETURN lv_retn;
  END;

END;
/