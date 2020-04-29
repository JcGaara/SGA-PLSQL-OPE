CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_DTH_MSG_CONAX AS

  /***********************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      24/02/2015   Antonio Astete       Henry Quispe         PROY-15263 Envío mensaje CONAX
     2.0      21/05/2015   Antonio Astete       Henry Quispe         SD-337043  Envío mensaje CONAX
  ************************************************************************/

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : conversion de Binario a Decimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_BIN2DEC(BINVAL IN CHAR) RETURN NUMBER IS
    I                 NUMBER;
    DIGITS            NUMBER;
    RESULT            NUMBER := 0;
    CURRENT_DIGIT     CHAR(1);
    CURRENT_DIGIT_DEC NUMBER;
  BEGIN
    DIGITS := LENGTH(BINVAL);
    FOR I IN 1 .. DIGITS LOOP
      CURRENT_DIGIT     := SUBSTR(BINVAL, I, 1);
      CURRENT_DIGIT_DEC := TO_NUMBER(CURRENT_DIGIT);
      RESULT            := (RESULT * 2) + CURRENT_DIGIT_DEC;
    END LOOP;
    RETURN RESULT;
  END F_BIN2DEC;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : conversion de Decimal a binario
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_DEC2BIN(N IN NUMBER) RETURN VARCHAR2 IS
    BINVAL VARCHAR2(64);
    N2     NUMBER := N;
  BEGIN
    WHILE (N2 > 0) LOOP
      BINVAL := MOD(N2, 2) || BINVAL;
      N2     := TRUNC(N2 / 2);
    END LOOP;
    RETURN BINVAL;
  END F_DEC2BIN;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : conversion de Decimal a Hexadecimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_DEC2HEX(N IN NUMBER) RETURN VARCHAR2 IS
    HEXVAL   VARCHAR2(64);
    N2       NUMBER := N;
    DIGIT    NUMBER;
    HEXDIGIT CHAR;
  BEGIN
    WHILE (N2 > 0) LOOP
      DIGIT := MOD(N2, 16);
      IF DIGIT > 9 THEN
        HEXDIGIT := CHR(ASCII('A') + DIGIT - 10);
      ELSE
        HEXDIGIT := TO_CHAR(DIGIT);
      END IF;
      HEXVAL := HEXDIGIT || HEXVAL;
      N2     := TRUNC(N2 / 16);
    END LOOP;
    RETURN HEXVAL;
  END F_DEC2HEX;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Conversion a Hexadecimal
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_HEXADECIMAL(L_MENSAJE OPERACION.MENSAJE_DTH_CAB.MENSAJE%TYPE)
    RETURN VARCHAR IS
    A VARCHAR2(250); --2.0
  BEGIN
    SELECT RAWTOHEX(L_MENSAJE) INTO A FROM DUAL;
    RETURN A;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene configuraciones Establecidas en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_PARAMETRO_ANHOS(P_PARAMETRO OPEDD.CODIGOC%TYPE)
    RETURN VARCHAR IS
    L_PARAMETRO OPEDD.ABREVIACION%TYPE;
  BEGIN
    SELECT ABREVIACION
      INTO L_PARAMETRO
      FROM OPEDD
     WHERE TIPOPEDD =
           (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'anhos_tabla')
       AND CODIGOC = P_PARAMETRO;
    RETURN L_PARAMETRO;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_MENSAJE(' ||
                              L_PARAMETRO || '): ' || SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene configuraciones del FTP Establecidas en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_PARAMETRO_FTP(P_PARAMETRO OPEDD.CODIGOC%TYPE)
    RETURN VARCHAR IS
    L_PARAMETRO OPEDD.DESCRIPCION%TYPE;
  BEGIN
    SELECT DESCRIPCION
      INTO L_PARAMETRO
      FROM OPEDD
     WHERE TIPOPEDD =
           (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'conexiones')
       AND CODIGOC = P_PARAMETRO;
    RETURN L_PARAMETRO;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_MENSAJE(' ||
                              L_PARAMETRO || '): ' || SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Validacion de las Tarjetas Ingresadas en el Archivo Plano o Por medio de Consultas
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_VALIDA_TARJETA(P_COD_TARJETA OPERACION.MENSAJE_DTH_DET.CODTARJ%TYPE)
    RETURN NUMBER IS
    L_VALOR       INTEGER;
    L_COD_TARJETA OPERACION.MENSAJE_DTH_DET.CODTARJ%TYPE;
  BEGIN
    --- SE VALIDA TARJETA
    L_COD_TARJETA := replace(replace(P_COD_TARJETA, chr(10), ''),
                             chr(13),
                             '');
    SELECT COUNT(1)
      INTO L_VALOR
      FROM OPERACION.TABEQUIPO_MATERIAL TEM
     WHERE TEM.TIPO = 1
       AND TEM.NUMERO_SERIE = L_COD_TARJETA;
    IF L_VALOR = 0 THEN
      RETURN 0;
    END IF;
    RETURN 1;
  END;

  /************************************************************************************************
  *Tipo               : funcion
  *Descripción        : Obtiene el Maximo numero de envios Registardo en tipos y estados
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_OBTIENE_MAXIMO_ENVIOS RETURN NUMBER IS
    L_RETURN NUMBER;
  BEGIN
    SELECT CODIGON
      INTO L_RETURN
      FROM OPEDD
     WHERE TIPOPEDD = (SELECT TIPOPEDD
                         FROM TIPOPEDD
                        WHERE ABREV = 'envio_dth_parametros')
       AND CODIGOC = 'MAXIMO_ENVIOS';
    L_RETURN := NVL(L_RETURN, 6);
    RETURN L_RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OBTIENE_MAXIMO_ENVIOS: ' ||
                              SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Registra Cabecera del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_REG_CAB_MSG(L_DESCRIPCION    IN VARCHAR2,
                          L_MENSAJE        IN VARCHAR2,
                          L_TIPOMENSAJE    IN NUMBER,
                          L_DURACION       IN NUMBER,
                          L_NUMREPETIC     IN NUMBER,
                          L_INTERVAREPETIC IN NUMBER,
                          L_FECHAINI       IN DATE,
                          L_HORAINI        IN DATE,
                          L_RESP           OUT NUMBER,
                          L_IDARCH         OUT NUMBER) IS
  BEGIN
    SELECT OPERACION.SQ_IDCODIGO.NEXTVAL INTO L_IDARCH FROM DUMMY_OPE;
    INSERT INTO OPERACION.MENSAJE_DTH_CAB
      (IDARCH,
       DESCRIP,
       MENSAJE,
       TIPMSG,
       DURMSG,
       NUMREP,
       INTREP,
       FECHINI,
       HORAINI,
       ESTMSG)
    VALUES
      (L_IDARCH,
       L_DESCRIPCION,
       L_MENSAJE,
       L_TIPOMENSAJE,
       L_DURACION,
       L_NUMREPETIC,
       L_INTERVAREPETIC,
       L_FECHAINI,
       L_HORAINI,
       'Creado');
    L_RESP := 1;
  EXCEPTION
    WHEN OTHERS THEN
      L_RESP := 0;
      P_LOG_ERROR(L_IDARCH,
                  'P_REG_CAB_MSG: INSERT INTO OPERACION.MENSAJE_DTH_CAB',
                  SQLCODE,
                  SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Registra Detalle del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_REG_DET_MSG(ID_PROC    IN NUMBER,
                          NUMTARJETA IN V_NUMTARJETA,
                          TOTAL      IN NUMBER) IS
    LV_VALIDO NUMBER;
    LN_FILA   NUMBER;
  BEGIN
    P_SET_CONFIGURACION;
    FOR LN_FILA IN 1 .. TOTAL LOOP
      LV_VALIDO := F_VALIDA_TARJETA(NUMTARJETA(LN_FILA));
      IF LV_VALIDO = 1 THEN
        BEGIN
          INSERT INTO OPERACION.MENSAJE_DTH_DET
            (IDARCH, CODTARJ, FLGAGP, FLGVAL)
          VALUES
            (ID_PROC, TRIM(NUMTARJETA(LN_FILA)), 0, 1);
        EXCEPTION
          WHEN OTHERS THEN
            P_LOG_ERROR(ID_PROC,
                        'P_REG_DET_MSG: ' ||
                        'INSERT INTO OPERACION.MENSAJE_DTH_DET: ' ||
                        TRIM(NUMTARJETA(LN_FILA)),
                        SQLCODE,
                        SQLERRM);
        END;
      ELSE
        BEGIN
          INSERT INTO OPERACION.MENSAJE_DTH_DET
            (IDARCH, CODTARJ, FLGAGP, FLGVAL)
          VALUES
            (ID_PROC, TRIM(NUMTARJETA(LN_FILA)), 0, 0);
        EXCEPTION
          WHEN OTHERS THEN
            P_LOG_ERROR(ID_PROC,
                        'P_REG_DET_MSG: ' ||
                        'INSERT INTO OPERACION.MENSAJE_DTH_DET: ' ||
                        TRIM(NUMTARJETA(LN_FILA)),
                        SQLCODE,
                        SQLERRM);
        END;
      END IF;
    END LOOP;
    COMMIT;
    UPDATE OPERACION.MENSAJE_DTH_CAB
       SET CANTTAR = TOTAL
     WHERE IDARCH = ID_PROC;
  EXCEPTION
    WHEN OTHERS THEN
      P_LOG_ERROR(ID_PROC, 'P_REG_DET_MSG', SQLCODE, SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Recupera configuraciones del DTH
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_SET_CONFIGURACION IS
  BEGIN
    G_HOST                    := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'HOST');
    G_PUERTO                  := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'PUERTO');
    G_USUARIO                 := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'USUARIO');
    G_PASS2                   := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'CLAVE');
    G_PASS                    := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'IDRSA');
    G_DIRECTORIO_LOCAL        := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'DirectorioLocal');
    G_DIRECTORIO_REMOTO_ENVIO := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'Dir.remoto.Req');
    G_DIRECTORIO_REMOTO_OK    := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'Dir.remoto.Ok');
    G_DIRECTORIO_REMOTO_ERROR := OPERACION.PQ_DTH.F_OBT_PARAMETRO_D('PARAM_DTH',
                                                                    'Dir.remoto.Error');
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Creacion del Archivo para el envio a Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ENVIA_CONAX(ID_PROCESO IN NUMBER) IS
    TOTAL             NUMBER;
    P_TEXT_IO         UTL_FILE.FILE_TYPE;
    L_NOM_ARCH        VARCHAR2(30);
    L_NOMBRE_EMM      VARCHAR2(30);
    L_CODTRANS        NUMBER;
    P_RESULTADO       VARCHAR2(40);
    L_MONTH           NUMBER;
    L_MONTH_HEX       VARCHAR2(15);
    P_MENSAJE         VARCHAR2(40);
    L_ARCHIVO_REMOTO  VARCHAR(1000);
    L_CONCAT          VARCHAR2(100);
    L_HORA_HEX        VARCHAR2(15);
    L_HORA            NUMBER;
    L_MINUTO_HEX      VARCHAR2(15);
    L_MINUTO          NUMBER;
    L_MENSAJE         VARCHAR2(100);
    N_MENSAJE         NUMBER;
    I                 NUMBER;
    L_MINUTO_3B       VARCHAR2(15);
    L_MINUTO_2B       VARCHAR2(15);
    RESIDUO           NUMBER;
    VUELTA            NUMBER;
    L_TOTAL_TARJ_ARCH NUMBER;
    L_YEAR_MOD2       VARCHAR2(15);
    X                 NUMBER := 0;
    L_AÑO_HEX         VARCHAR2(15);
    L_DIA             NUMBER;
    L_HEX1            VARCHAR2(15);
    L_YEAR            VARCHAR2(10);
    L_YEAR_MOD        VARCHAR2(10);
    L_DUR             VARCHAR2(15);
    L_DURACION        NUMBER;
    L_TIPMENSAJE      NUMBER;
    L_DIA_HEX         VARCHAR2(15);
    L_INTERVREPET     NUMBER;
    L_NUMREPET        NUMBER;
    L_DUR6            VARCHAR2(15);
    L_DUR8            VARCHAR2(15);
    L_HEXAMESA        VARCHAR2(1000);
    L_VALOR_OBSERVADO NUMBER;
  
    CURSOR C_TARJETA(A NUMBER) IS
      SELECT D.CODTARJ, C.MENSAJE
        FROM OPERACION.MENSAJE_DTH_DET D, OPERACION.MENSAJE_DTH_CAB C
       WHERE D.IDARCH = C.IDARCH
         AND D.IDARCH = ID_PROCESO
         AND D.FLGAGP = A
       ORDER BY D.CODTARJ ASC;
  BEGIN
    P_SET_CONFIGURACION;
    --se agrupan las tarjetas
    P_TARJETAS(ID_PROCESO);
    COMMIT;
    -- Consulta numero de Tarjetas VALIDAS AGRUPADAS
    SELECT COUNT(D.CODTARJ)
      INTO TOTAL
      FROM OPERACION.MENSAJE_DTH_DET D
     WHERE D.IDARCH = ID_PROCESO
       AND D.FLGVAL = 1
       AND D.FLGAGP > 0;
  
    RESIDUO := MOD(TOTAL, 4000);
    VUELTA  := TRUNC(TOTAL / 4000);
    IF RESIDUO > 0 THEN
      VUELTA := TRUNC(TOTAL / 4000) + 1;
    END IF;
    FOR I IN 0 .. VUELTA - 1 LOOP
      X            := X + 1;
      L_NOMBRE_EMM := OPERACION.PQ_DTH.F_GENERA_NOMBRE_ARCHIVO(0, 'gp');
      L_NOM_ARCH   := REPLACE(REPLACE(L_NOMBRE_EMM, '//', '/'),
                              '.emm',
                              '.tmp');
    
      L_CODTRANS := SUBSTR(L_NOMBRE_EMM, 3, LENGTH(L_NOMBRE_EMM) - 6);
      --Abrir el Archivo
      OPERACION.PQ_DTH_INTERFAZ.P_ABRIR_ARCHIVO(P_TEXT_IO,
                                                PDIRECTORIO,
                                                L_NOM_ARCH,
                                                'W',
                                                P_RESULTADO,
                                                P_MENSAJE);
      --Escribir en Archivo
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'U', '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                TRIM(TO_CHAR(L_CODTRANS,
                                                             '000000')),
                                                '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                TRIM(TO_CHAR('00000002')),
                                                '1');
      ---Inicio Creacion de  mensaje  --2.0  
      SELECT C.TIPMSG, C.MENSAJE, LENGTH(C.MENSAJE), C.DURMSG
        INTO L_TIPMENSAJE, L_MENSAJE, N_MENSAJE, L_DURACION
        FROM OPERACION.MENSAJE_DTH_CAB C
       WHERE C.IDARCH = ID_PROCESO;
      L_HEX1     := lpad(F_DEC2HEX(N_MENSAJE), 2, '0');
      L_HEXAMESA := F_HEXADECIMAL(L_MENSAJE);
      L_DUR      := LPAD(F_DEC2HEX(L_DURACION), 4, 0);
      -- Tipo de Mensaje--2.0
      IF L_TIPMENSAJE = 1 THEN
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  '01' || L_HEX1 ||
                                                  L_HEXAMESA || '02' || '01' || 'ff' || '04' || '02' ||
                                                  L_DUR,
                                                  '1');
        --- Tipo de Mensaje 02
      ELSIF L_TIPMENSAJE = 2 THEN
        SELECT EXTRACT(YEAR FROM C.FECHINI),
               EXTRACT(DAY FROM C.FECHINI),
               TRUNC(EXTRACT(MONTH FROM C.FECHINI)),
               TO_CHAR(C.HORAINI + 5 / 24, 'HH24'),
               TO_CHAR(C.HORAINI, 'MI'),
               TO_CHAR(sysdate, 'yy')
          INTO L_YEAR, L_DIA, L_MONTH, L_HORA, L_MINUTO, L_YEAR_MOD2
          FROM OPERACION.MENSAJE_DTH_CAB C
         WHERE C.IDARCH = ID_PROCESO
           AND C.FECHINI IS NOT NULL;
        --se tiene q traer d una tabla
        SELECT TRUNC(L_YEAR, -1) INTO L_YEAR_MOD FROM DUAL;
        L_AÑO_HEX := F_OBTIENE_PARAMETRO_ANHOS(L_YEAR_MOD);
        L_AÑO_HEX := LPAD(L_AÑO_HEX, 3, 0);
      
        L_DIA_HEX := LPAD(F_DEC2BIN(L_DIA), 5, 0);
      
        L_YEAR_MOD2 := SUBSTR(L_YEAR_MOD2, -1);
        L_YEAR_MOD2 := LPAD(F_DEC2BIN(L_YEAR_MOD2), 4, 0);
      
        L_MONTH_HEX := LPAD(F_DEC2BIN(L_MONTH), 4, 0);
        L_MINUTO_3B := '000';
        L_HORA_HEX  := LPAD(nvl(F_DEC2BIN(L_HORA), '0'), 5, 0);
        L_HORA_HEX  := SUBSTR(L_HORA_HEX, -5);
      
        L_MINUTO_2B  := '00';
        L_MINUTO_HEX := lpad(nvl(F_DEC2BIN(L_MINUTO), '0'), 6, '0');
        L_MINUTO_HEX := SUBSTR(L_MINUTO_HEX, -6);
      
        L_CONCAT := L_AÑO_HEX || L_DIA_HEX || L_YEAR_MOD2 || L_MONTH_HEX ||
                    L_MINUTO_3B || L_HORA_HEX || L_MINUTO_2B ||
                    L_MINUTO_HEX;
      
        L_AÑO_HEX    := SUBSTR(L_CONCAT, 1, 4);
        L_AÑO_HEX    := F_BIN2DEC(nvl(L_AÑO_HEX, '0'));
        L_AÑO_HEX    := nvl(F_DEC2HEX(L_AÑO_HEX), '0');
        L_DIA_HEX    := SUBSTR(L_CONCAT, 5, 4);
        L_DIA_HEX    := F_BIN2DEC(L_DIA_HEX);
        L_DIA_HEX    := nvl(F_DEC2HEX(L_DIA_HEX), '0');
        L_YEAR_MOD2  := SUBSTR(L_CONCAT, 9, 4);
        L_YEAR_MOD2  := F_BIN2DEC(L_YEAR_MOD2);
        L_YEAR_MOD2  := nvl(F_DEC2HEX(L_YEAR_MOD2), '0');
        L_MONTH_HEX  := SUBSTR(L_CONCAT, 13, 4);
        L_MONTH_HEX  := F_BIN2DEC(L_MONTH_HEX);
        L_MONTH_HEX  := nvl(F_DEC2HEX(L_MONTH_HEX), '0');
        L_MINUTO_3B  := SUBSTR(L_CONCAT, 17, 4);
        L_MINUTO_3B  := F_BIN2DEC(L_MINUTO_3B);
        L_MINUTO_3B  := nvl(F_DEC2HEX(L_MINUTO_3B), '0');
        L_HORA_HEX   := SUBSTR(L_CONCAT, 21, 4);
        L_HORA_HEX   := F_BIN2DEC(L_HORA_HEX);
        L_HORA_HEX   := nvl(F_DEC2HEX(L_HORA_HEX), '0');
        L_MINUTO_2B  := SUBSTR(L_CONCAT, 25, 4);
        L_MINUTO_2B  := F_BIN2DEC(L_MINUTO_2B);
        L_MINUTO_2B  := nvl(F_DEC2HEX(L_MINUTO_2B), '0');
        L_MINUTO_HEX := SUBSTR(L_CONCAT, 29, 4);
        L_MINUTO_HEX := F_BIN2DEC(L_MINUTO_HEX);
        L_MINUTO_HEX := nvl(F_DEC2HEX(L_MINUTO_HEX), '0');
      
        L_CONCAT := L_AÑO_HEX || L_DIA_HEX || L_YEAR_MOD2 || L_MONTH_HEX ||
                    L_MINUTO_3B || L_HORA_HEX || L_MINUTO_2B ||
                    L_MINUTO_HEX;
      
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  '01' || L_HEX1 ||
                                                  L_HEXAMESA || '02' || '01' || 'ff' || '04' || '02' ||
                                                  L_DUR || '03' || '04' ||
                                                  L_CONCAT,
                                                  '1');
        --Tipo de Mensaje 03
      ELSIF L_TIPMENSAJE = 3 THEN
        SELECT nvl(C.NUMREP, 0), nvl(C.INTREP, 0)
          INTO L_NUMREPET, L_INTERVREPET
          FROM OPERACION.MENSAJE_DTH_CAB C
         WHERE C.IDARCH = ID_PROCESO;
      
        L_DUR8 := lpad(F_DEC2HEX(L_NUMREPET), 2, '0');
        L_DUR6 := lpad(F_DEC2HEX(L_INTERVREPET), 2, '0');
      
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  '01' || L_HEX1 ||
                                                  L_HEXAMESA || '02' || '01' || 'ff' || '04' || '02' ||
                                                  L_DUR || '05' || '01' ||
                                                  L_DUR8 || '06' || '01' ||
                                                  L_DUR6,
                                                  '1');
        --Tipo de Mensaje 04
      ELSIF L_TIPMENSAJE = 4 THEN
        SELECT EXTRACT(YEAR FROM C.FECHINI),
               EXTRACT(DAY FROM C.FECHINI),
               TRUNC(EXTRACT(MONTH FROM C.FECHINI)),
               TO_CHAR(C.HORAINI + 5 / 24, 'HH24'),
               TO_CHAR(C.HORAINI, 'MI'),
               TO_CHAR(sysdate, 'yy'),
               C.INTREP,
               C.NUMREP
          INTO L_YEAR,
               L_DIA,
               L_MONTH,
               L_HORA,
               L_MINUTO,
               L_YEAR_MOD2,
               L_INTERVREPET,
               L_NUMREPET
          FROM OPERACION.MENSAJE_DTH_CAB C
         WHERE C.IDARCH = ID_PROCESO
           AND C.FECHINI IS NOT NULL;
      
        L_DUR8 := lpad(F_DEC2HEX(L_NUMREPET), 2, '0');
        L_DUR6 := lpad(F_DEC2HEX(L_INTERVREPET), 2, '0');
      
        --se tiene q traer d una tabla
        SELECT TRUNC(L_YEAR, -1) INTO L_YEAR_MOD FROM DUAL;
        L_AÑO_HEX := F_OBTIENE_PARAMETRO_ANHOS(L_YEAR_MOD);
        L_AÑO_HEX := LPAD(L_AÑO_HEX, 3, 0);
      
        L_DIA_HEX := LPAD(F_DEC2BIN(L_DIA), 5, 0);
      
        L_YEAR_MOD2 := SUBSTR(L_YEAR_MOD2, -1);
        L_YEAR_MOD2 := LPAD(F_DEC2BIN(L_YEAR_MOD2), 4, 0);
      
        L_MONTH_HEX := LPAD(F_DEC2BIN(L_MONTH), 4, 0);
        L_MINUTO_3B := '000';
        L_HORA_HEX  := LPAD(nvl(F_DEC2BIN(L_HORA), '0'), 5, 0);
        L_HORA_HEX  := SUBSTR(L_HORA_HEX, -5);
      
        L_MINUTO_2B  := '00';
        L_MINUTO_HEX := lpad(nvl(F_DEC2BIN(L_MINUTO), '0'), 6, '0');
        L_MINUTO_HEX := SUBSTR(L_MINUTO_HEX, -6);
      
        L_CONCAT := L_AÑO_HEX || L_DIA_HEX || L_YEAR_MOD2 || L_MONTH_HEX ||
                    L_MINUTO_3B || L_HORA_HEX || L_MINUTO_2B ||
                    L_MINUTO_HEX;
      
        L_AÑO_HEX    := SUBSTR(L_CONCAT, 1, 4);
        L_AÑO_HEX    := F_BIN2DEC(nvl(L_AÑO_HEX, '0'));
        L_AÑO_HEX    := nvl(F_DEC2HEX(L_AÑO_HEX), '0');
        L_DIA_HEX    := SUBSTR(L_CONCAT, 5, 4);
        L_DIA_HEX    := F_BIN2DEC(L_DIA_HEX);
        L_DIA_HEX    := nvl(F_DEC2HEX(L_DIA_HEX), '0');
        L_YEAR_MOD2  := SUBSTR(L_CONCAT, 9, 4);
        L_YEAR_MOD2  := F_BIN2DEC(L_YEAR_MOD2);
        L_YEAR_MOD2  := nvl(F_DEC2HEX(L_YEAR_MOD2), '0');
        L_MONTH_HEX  := SUBSTR(L_CONCAT, 13, 4);
        L_MONTH_HEX  := F_BIN2DEC(L_MONTH_HEX);
        L_MONTH_HEX  := nvl(F_DEC2HEX(L_MONTH_HEX), '0');
        L_MINUTO_3B  := SUBSTR(L_CONCAT, 17, 4);
        L_MINUTO_3B  := F_BIN2DEC(L_MINUTO_3B);
        L_MINUTO_3B  := nvl(F_DEC2HEX(L_MINUTO_3B), '0');
        L_HORA_HEX   := SUBSTR(L_CONCAT, 21, 4);
        L_HORA_HEX   := F_BIN2DEC(L_HORA_HEX);
        L_HORA_HEX   := nvl(F_DEC2HEX(L_HORA_HEX), '0');
        L_MINUTO_2B  := SUBSTR(L_CONCAT, 25, 4);
        L_MINUTO_2B  := F_BIN2DEC(L_MINUTO_2B);
        L_MINUTO_2B  := nvl(F_DEC2HEX(L_MINUTO_2B), '0');
        L_MINUTO_HEX := SUBSTR(L_CONCAT, 29, 4);
        L_MINUTO_HEX := F_BIN2DEC(L_MINUTO_HEX);
        L_MINUTO_HEX := nvl(F_DEC2HEX(L_MINUTO_HEX), '0');
      
        L_CONCAT := L_AÑO_HEX || L_DIA_HEX || L_YEAR_MOD2 || L_MONTH_HEX ||
                    L_MINUTO_3B || L_HORA_HEX || L_MINUTO_2B ||
                    L_MINUTO_HEX;
      
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  '01' || L_HEX1 ||
                                                  L_HEXAMESA || '02' || '01' || 'ff' || '04' || '02' ||
                                                  L_DUR || '03' || '04' ||
                                                  L_CONCAT || '05' || '01' ||
                                                  L_DUR8 || '06' || '01' ||
                                                  L_DUR6,
                                                  '1');
        --- Tipo de Mensaje 05
      ELSIF L_TIPMENSAJE = 5 THEN
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  '01' || L_HEX1 ||
                                                  L_HEXAMESA || '02' || '01' || 'ff' || '04' || '02' ||
                                                  '0000',
                                                  '1');
      END IF;
      --fin mensaje
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'U', '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'U', '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'U', '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'U', '1');
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'EMM', '1');
    
      SELECT COUNT(CODTARJ)
        INTO L_TOTAL_TARJ_ARCH
        FROM (SELECT A.*, ROWNUM RNUM
                FROM (SELECT D.CODTARJ
                        FROM OPERACION.MENSAJE_DTH_DET D
                       WHERE D.IDARCH = ID_PROCESO
                         AND D.FLGVAL = 1
                         AND D.FLGAGP > 0
                       ORDER BY D.CODTARJ ASC) A
               WHERE ROWNUM <= (I * 4000) + 4000)
       WHERE RNUM > (I * 4000);
    
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                LPAD(L_TOTAL_TARJ_ARCH,
                                                     5,
                                                     0),
                                                '1');
      FOR C2 IN C_TARJETA(X) LOOP
        OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                  C2.CODTARJ,
                                                  '1');
      END LOOP;
      -- Limpiamos Arreglo
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO, 'ZZZ', '1');
      --NTARJETA.DELETE();hql
      --Cerrar el archivo
      OPERACION.PQ_DTH_INTERFAZ.P_CERRAR_ARCHIVO(P_TEXT_IO);
      --Calculamos los Archivos Observados
      SELECT COUNT(1)
        INTO L_VALOR_OBSERVADO
        FROM OPERACION.MENSAJE_DTH_DET D
       WHERE D.IDARCH = ID_PROCESO
         AND D.FLGVAL = 0;
    
      --insertando el nombre del archivo con sus detalles
      UPDATE OPERACION.MENSAJE_DTH_CAB C
         SET OBSMSG = 'N° Tarjetas Observadas: ' || L_VALOR_OBSERVADO
       WHERE IDARCH = ID_PROCESO;
    
      --enviar archivo
      BEGIN
        L_ARCHIVO_REMOTO := REPLACE(REPLACE(G_DIRECTORIO_REMOTO_ENVIO || '/' ||
                                            L_NOM_ARCH,
                                            '//',
                                            '/'),
                                    '.tmp',
                                    '.emm');
        OPERACION.PQ_DTH_INTERFAZ.P_ENVIAR_ARCHIVO_ASCII(G_HOST,
                                                         G_PUERTO,
                                                         G_USUARIO,
                                                         G_PASS,
                                                         PDIRECTORIO,
                                                         L_NOM_ARCH,
                                                         L_ARCHIVO_REMOTO);
        INSERT INTO OPERACION.TAB_ARCH_MSG_DTH
          (ID_ARCHIVO,
           COD_FILE,
           NOMBRE_FILE,
           ESTADO_FILE,
           FECH_ENVIO,
           COUNT_TARJETAS,
           NOMBRE_EMM,
           NUN_INTENTOS)
        VALUES
          (ID_PROCESO,
           L_CODTRANS,
           L_NOM_ARCH,
           'Enviado',
           SYSDATE,
           L_TOTAL_TARJ_ARCH,
           L_NOMBRE_EMM,
           1);
      
        UPDATE OPERACION.MENSAJE_DTH_DET D
           SET D.CODFILE = L_CODTRANS
         WHERE D.IDARCH = ID_PROCESO
           AND D.FLGAGP = X;
        COMMIT;
      END;
    END LOOP;
    UPDATE OPERACION.MENSAJE_DTH_CAB C
       SET C.USUENV = USER, C.FECENV = SYSDATE
     WHERE C.IDARCH = ID_PROCESO;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      P_LOG_ERROR(ID_PROCESO, 'P_ENVIA_CONAX', SQLCODE, SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : elimina el Archivo FTP que se creo en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ELIMINAR_ARCHIVO_FTP(PHOST           IN VARCHAR2,
                                   PPUERTO         IN VARCHAR2,
                                   PUSUARIO        IN VARCHAR2,
                                   PPASS           IN VARCHAR2,
                                   P_ARCHIVOREMOTO IN VARCHAR2,
                                   P_RESULTADO_FTP IN OUT VARCHAR,
                                   P_MENSAJE_FTP   IN OUT VARCHAR) IS
    L_CONN UTL_TCP.CONNECTION;
  BEGIN
    IF PPUERTO = 21 THEN
      L_CONN := FTP.LOGIN(PHOST, PPUERTO, PUSUARIO, PPASS);
      FTP.ASCII(P_CONN => L_CONN);
      FTP.DELETE(P_CONN => L_CONN, P_FILE => P_ARCHIVOREMOTO);
      FTP.LOGOUT(L_CONN);
      UTL_TCP.CLOSE_ALL_CONNECTIONS;
      P_RESULTADO_FTP := 'Ok';
      P_MENSAJE_FTP   := 'Ok';
    ELSIF PPUERTO = 22 THEN
      P_RESULTADO_FTP := OPERACION.SFTP.ELIMINARCHIVO(PUSUARIO,
                                                      PPASS,
                                                      PHOST,
                                                      PPUERTO,
                                                      PRUTKNOWHOST,
                                                      P_ARCHIVOREMOTO);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20080, SQLERRM);
  END P_ELIMINAR_ARCHIVO_FTP;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Lectura de un cursor para la Ejecucion del Envio de Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_CANT_ID_ARCHIVOS IS
    CURSOR C_IDS IS
      SELECT DISTINCT (D.IDARCH), D.FLGAGP, D.FLGVAL
        FROM OPERACION.MENSAJE_DTH_DET D, OPERACION.MENSAJE_DTH_CAB C
       WHERE D.IDARCH = C.IDARCH
         AND C.IDARCH IS NOT NULL
         AND C.ESTMSG = 'En proceso'
         AND D.FLGAGP = 0
         AND D.FLGVAL = 1;
  
  BEGIN
    FOR ING IN C_IDS LOOP
      P_ENVIA_CONAX(ING.IDARCH);
      COMMIT;
    END LOOP;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Almacena en el Servidor los archivos mayores a 1000 registros
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ALMACENAR_ARCHIVO(ID_PROC    IN NUMBER,
                                NUMTARJETA IN V_NUMTARJETA,
                                TOTAL      IN NUMBER) IS
    LN_FILA     NUMBER;
    P_RESULTADO VARCHAR2(40);
    P_MENSAJE   VARCHAR2(40);
    P_TEXT_IO   UTL_FILE.FILE_TYPE;
  BEGIN
    OPERACION.PQ_DTH_INTERFAZ.P_ABRIR_ARCHIVO(P_TEXT_IO,
                                              PDIRECTORIO,
                                              ID_PROC,
                                              'W',
                                              P_RESULTADO,
                                              P_MENSAJE);
    --escribir en el archivo
    FOR LN_FILA IN 1 .. TOTAL LOOP
      OPERACION.PQ_DTH_INTERFAZ.P_ESCRIBE_LINEA(P_TEXT_IO,
                                                NUMTARJETA(LN_FILA),
                                                '1');
    END LOOP;
    INSERT INTO OPERACION.TAB_ARCH_TMP
      (ID_ARCHIVO,
       COD_FILE,
       NOMBRE_FILE,
       ESTADO_FILE,
       COUNT_TARJETAS,
       FECUSU)
    VALUES
      (ID_PROC, '', ID_PROC, 'Temporal', TOTAL, SYSDATE);
    COMMIT;
    --cerrar el archivo--2.0
    OPERACION.PQ_DTH_INTERFAZ.P_CERRAR_ARCHIVO(P_TEXT_IO);
    IF TOTAL > 1000 AND TOTAL < 200000 THEN
      UPDATE OPERACION.MENSAJE_DTH_CAB
         SET ESTMSG = 'Carga Pendiente', CANTTAR = TOTAL
       WHERE IDARCH = ID_PROC;
      COMMIT;
    ELSE
      IF TOTAL >= 200000 THEN
        UPDATE OPERACION.MENSAJE_DTH_CAB
           SET ESTMSG = 'Pendiente de envio', CANTTAR = TOTAL
         WHERE IDARCH = ID_PROC;
        COMMIT;
      END IF;
    END IF;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Genera el detalle del Mensaje Para los Archivos en estado Carga Pendiente en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_SHELL_INSERCION IS
    P_TEXT_IO  UTL_FILE.FILE_TYPE;
    LS_TARJETA VARCHAR2(50);
    LN_FILA    NUMBER;
    --L_ARCHIVO_REMOTO VARCHAR2(50);
    LV_VALIDO NUMBER;
    CURSOR ID_PROC IS
      SELECT TP.NOMBRE_FILE, TP.ID_ARCHIVO, C.CANTTAR
        FROM OPERACION.TAB_ARCH_TMP TP, OPERACION.MENSAJE_DTH_CAB C
       WHERE TP.ID_ARCHIVO = C.IDARCH
         AND C.ESTMSG = 'Carga Pendiente'
         AND C.CANTTAR > 1000
         AND C.CANTTAR < 200000;
  
    CURSOR ENV_CONAX_1 IS
      SELECT C.IDARCH
        FROM OPERACION.MENSAJE_DTH_CAB C
       WHERE C.ESTMSG = 'Auto_1';
  BEGIN
    P_SET_CONFIGURACION;
    FOR REC IN ID_PROC LOOP
      BEGIN
        P_TEXT_IO := UTL_FILE.FOPEN(G_DIRECTORIO_LOCAL,
                                    REC.NOMBRE_FILE,
                                    'R');
        --Crear Archivo
        FOR LN_FILA IN 1 .. REC.CANTTAR LOOP
          BEGIN
            UTL_FILE.GET_LINE(P_TEXT_IO, LS_TARJETA);
            LV_VALIDO := F_VALIDA_TARJETA(LS_TARJETA);
            IF LV_VALIDO = 1 THEN
              INSERT INTO OPERACION.MENSAJE_DTH_DET
              VALUES
                (REC.ID_ARCHIVO, TRIM(LS_TARJETA), 0, 1, '');
            ELSE
              INSERT INTO OPERACION.MENSAJE_DTH_DET
              VALUES
                (REC.ID_ARCHIVO, TRIM(LS_TARJETA), 0, 0, '');
            END IF;
            -- COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              P_LOG_ERROR(REC.ID_ARCHIVO,
                          'P_SHELL_INSERCION: ' ||
                          'ERROR AL INSERTAR DETALLE DEL MENSAJE FLUJO MAYOR A MIL.',
                          SQLCODE,
                          SQLERRM);
              rollback;
          END;
          IF LN_FILA = REC.CANTTAR THEN
            BEGIN
              UTL_FILE.FCLOSE(P_TEXT_IO);
              DELETE OPERACION.TAB_ARCH_TMP TP
               WHERE TP.ID_ARCHIVO = REC.ID_ARCHIVO;
              --se envia a en proceso para su envio a conax
              UPDATE OPERACION.MENSAJE_DTH_CAB C
                 SET C.ESTMSG = 'Auto_1'
               WHERE C.IDARCH = REC.ID_ARCHIVO;
            EXCEPTION
              WHEN OTHERS THEN
                P_LOG_ERROR(REC.ID_ARCHIVO,
                            'P_SHELL_INSERCION: ' ||
                            'ERROR AL MOVER EL ARCHIVO: ' ||
                            TRIM(REC.NOMBRE_FILE),
                            SQLCODE,
                            SQLERRM);
                rollback;
            END;
          END IF;
          COMMIT;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          P_LOG_ERROR(REC.ID_ARCHIVO,
                      'P_SHELL_INSERCION: ' ||
                      'ERROR AL ABRIR EL ARCHIVO: ' ||
                      TRIM(REC.NOMBRE_FILE),
                      SQLCODE,
                      SQLERRM);
          rollback;
      END;
    END LOOP;
  
    FOR EC_1 IN ENV_CONAX_1 LOOP
      BEGIN
        P_ENVIA_CONAX(EC_1.IDARCH);
        -- Actualizacion En proceso
        UPDATE OPERACION.MENSAJE_DTH_CAB C
           SET C.ESTMSG = 'En proceso'
         WHERE C.IDARCH = EC_1.IDARCH;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          P_LOG_ERROR(EC_1.IDARCH,
                      'P_SHELL_INSERCION: ' ||
                      'ERROR AL EJECUTAR ENVIO A CONAX.',
                      SQLCODE,
                      SQLERRM);
          rollback;
          -- Error Vuelve a su estado Original
          UPDATE OPERACION.MENSAJE_DTH_CAB C
             SET C.ESTMSG = 'Auto_1'
           WHERE C.IDARCH = EC_1.IDARCH;
          COMMIT;
      END;
    END LOOP;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Genera el detalle del Mensaje Para los Archivos en estado Pendiente de Envio en el Servidor
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_SHELL_SEGUNDA_INSERCION IS
    P_TEXT_IO  UTL_FILE.FILE_TYPE;
    LS_TARJETA VARCHAR2(50);
    LN_FILA    NUMBER;
    LV_VALIDO  NUMBER;
    CURSOR ID_PROC IS
      SELECT TP.NOMBRE_FILE, TP.ID_ARCHIVO, C.CANTTAR
        FROM OPERACION.TAB_ARCH_TMP TP, OPERACION.MENSAJE_DTH_CAB C
       WHERE TP.ID_ARCHIVO = C.IDARCH
         AND C.ESTMSG = 'Pendiente de envio'
         AND C.CANTTAR >= 200000;
  
    CURSOR ENV_CONAX_2 IS
      SELECT C.IDARCH
        FROM OPERACION.MENSAJE_DTH_CAB C
       WHERE C.ESTMSG = 'Auto_2';
  BEGIN
    P_SET_CONFIGURACION;
    FOR REC IN ID_PROC LOOP
      BEGIN
        P_TEXT_IO := UTL_FILE.FOPEN(G_DIRECTORIO_LOCAL,
                                    REC.NOMBRE_FILE,
                                    'R');
        --Crear Archivo
        FOR LN_FILA IN 1 .. REC.CANTTAR LOOP
          BEGIN
            UTL_FILE.GET_LINE(P_TEXT_IO, LS_TARJETA);
            LV_VALIDO := F_VALIDA_TARJETA(LS_TARJETA);
            IF LV_VALIDO = 1 THEN
              INSERT INTO OPERACION.MENSAJE_DTH_DET
              VALUES
                (REC.ID_ARCHIVO, TRIM(LS_TARJETA), 0, 1, '');
            ELSE
              INSERT INTO OPERACION.MENSAJE_DTH_DET
              VALUES
                (REC.ID_ARCHIVO, TRIM(LS_TARJETA), 0, 0, '');
            END IF;
          EXCEPTION
            WHEN OTHERS THEN
              P_LOG_ERROR(REC.ID_ARCHIVO,
                          'P_SHELL_SEGUNDA_INSERCION: ' ||
                          'ERROR AL INSERTAR DETALLE DEL MENSAJE FLUJO MAYOR A DOSCIENTOS MIL.',
                          SQLCODE,
                          SQLERRM);
              rollback;
          END;
          IF LN_FILA = REC.CANTTAR THEN
            BEGIN
              UTL_FILE.FCLOSE(P_TEXT_IO);
              DELETE OPERACION.TAB_ARCH_TMP TP
               WHERE TP.ID_ARCHIVO = REC.ID_ARCHIVO;
            
              UPDATE OPERACION.MENSAJE_DTH_CAB C
                 SET C.ESTMSG = 'Auto_2'
               WHERE C.IDARCH = REC.ID_ARCHIVO;
            EXCEPTION
              WHEN OTHERS THEN
                P_LOG_ERROR(REC.ID_ARCHIVO,
                            'P_SHELL_SEGUNDA_INSERCION: ' ||
                            'ERROR AL MOVER EL ARCHIVO: ' ||
                            TRIM(REC.NOMBRE_FILE),
                            SQLCODE,
                            SQLERRM);
                rollback;
            END;
          END IF;
          COMMIT;
        END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
          P_LOG_ERROR(REC.ID_ARCHIVO,
                      'P_SHELL_SEGUNDA_INSERCION: ' ||
                      'ERROR AL ABRIR EL ARCHIVO: ' ||
                      TRIM(REC.NOMBRE_FILE),
                      SQLCODE,
                      SQLERRM);
      END;
    END LOOP;
  
    FOR EC_2 IN ENV_CONAX_2 LOOP
      BEGIN
        P_ENVIA_CONAX(EC_2.IDARCH);
        -- Actualizacion En proceso
        UPDATE OPERACION.MENSAJE_DTH_CAB C
           SET C.ESTMSG = 'En proceso'
         WHERE C.IDARCH = EC_2.IDARCH;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          P_LOG_ERROR(EC_2.IDARCH,
                      'P_SHELL_SEGUNDA_INSERCION: ' ||
                      'ERROR AL EJECUTAR ENVIO A CONAX.',
                      SQLCODE,
                      SQLERRM);
          rollback;
          -- Error Vuelve a su estado Original
          UPDATE OPERACION.MENSAJE_DTH_CAB C
             SET C.ESTMSG = 'Auto_2'
           WHERE C.IDARCH = EC_2.IDARCH;
          COMMIT;
      END;
    END LOOP;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Lectura de cursor de los Registros en Proceso Para su Actualiacion de Estad
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_FILE_ENVIADO_ACTUALIZA IS
    L_IDSOLICITUD NUMBER;
    CURSOR LISTA IS
      SELECT distinct C.IDARCH
        FROM OPERACION.MENSAJE_DTH_CAB C, OPERACION.TAB_ARCH_MSG_DTH DT
       WHERE C.IDARCH = DT.ID_ARCHIVO
         AND C.ESTMSG = 'En proceso'
       order by 1;
  BEGIN
    P_SET_CONFIGURACION;
    FOR ENVIO IN LISTA LOOP
      BEGIN
        L_IDSOLICITUD := ENVIO.IDARCH;
        P_ACTUALIZA_ESTADO_FILE(L_IDSOLICITUD);
      EXCEPTION
        WHEN OTHERS THEN
          P_LOG_ERROR(L_IDSOLICITUD,
                      'P_FILE_ENVIADO_ACTUALIZA',
                      SQLCODE,
                      SQLERRM);
      END;
    END LOOP;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Actualiza el estado de la cabecera del Mensaje
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ACTUALIZA_ESTADO_FILE(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE) IS
    L_RESULTADO_FTP VARCHAR(8);
    L_MENSAJE_FTP   VARCHAR(1000);
    L_CODFILE       NUMBER;
    L_IDARCHIVO     NUMBER;
    EST_FIN         VARCHAR2(12);
    L_CONTA5        NUMBER;
    L_CONTA6        NUMBER;
    RESPUESTAVRF    VARCHAR2(100);
    CURSOR CONS IS
      SELECT DT.ESTADO_FILE,
             C.ESTMSG,
             DT.COD_FILE,
             C.IDARCH,
             DT.NOMBRE_EMM,
             DT.NUN_INTENTOS
        FROM OPERACION.MENSAJE_DTH_CAB C, OPERACION.TAB_ARCH_MSG_DTH DT
       WHERE C.IDARCH = DT.ID_ARCHIVO
         AND C.IDARCH = P_ID_CORRELATIVO
         AND DT.ESTADO_FILE <> 'Ok';
  BEGIN
    P_SET_CONFIGURACION;
    FOR DAT IN CONS LOOP
      L_CODFILE   := DAT.COD_FILE;
      L_IDARCHIVO := DAT.IDARCH;
      IF DAT.NUN_INTENTOS <= 5 /*AND DAT.ESTADO_FILE <> 'Ok'*/
       THEN
        P_VRF_ARCHIVO_ASCII(G_HOST,
                            G_PUERTO,
                            G_USUARIO,
                            G_PASS2,
                            G_DIRECTORIO_REMOTO_OK || DAT.NOMBRE_EMM,
                            RESPUESTAVRF);
        IF RESPUESTAVRF = 'Ok' THEN
          P_ELIMINAR_ARCHIVO_FTP(G_HOST,
                                 G_PUERTO,
                                 G_USUARIO,
                                 G_PASS2,
                                 G_DIRECTORIO_REMOTO_OK || DAT.NOMBRE_EMM,
                                 L_RESULTADO_FTP,
                                 L_MENSAJE_FTP);
          UPDATE OPERACION.TAB_ARCH_MSG_DTH AP
             SET AP.ESTADO_FILE = 'Ok'
           WHERE AP.ID_ARCHIVO = DAT.IDARCH
             AND AP.COD_FILE = DAT.COD_FILE;
          COMMIT;
        
          SELECT COUNT(*)
            INTO L_CONTA5
            FROM OPERACION.TAB_ARCH_MSG_DTH AU
           WHERE AU.ID_ARCHIVO = P_ID_CORRELATIVO
             AND AU.ESTADO_FILE = 'Ok';
          --cuantos item son en total
          SELECT COUNT(*)
            INTO L_CONTA6
            FROM OPERACION.TAB_ARCH_MSG_DTH AP
           WHERE AP.ID_ARCHIVO = P_ID_CORRELATIVO;
        
          IF L_CONTA5 = L_CONTA6 THEN
            UPDATE OPERACION.MENSAJE_DTH_CAB TA
               SET TA.ESTMSG = 'Procesado Ok'
             WHERE TA.IDARCH = P_ID_CORRELATIVO;
            --COMMIT;
          END IF;
          IF L_CONTA5 <> L_CONTA6 AND DAT.NUN_INTENTOS < 5 THEN
            UPDATE OPERACION.MENSAJE_DTH_CAB TA
               SET TA.ESTMSG = 'En Proceso'
             WHERE TA.IDARCH = P_ID_CORRELATIVO;
            --COMMIT;
          END IF;
          IF L_CONTA5 <> L_CONTA6 AND DAT.NUN_INTENTOS = 5 THEN
            UPDATE OPERACION.MENSAJE_DTH_CAB TA
               SET TA.ESTMSG = 'Procesado con Errores'
             WHERE TA.IDARCH = P_ID_CORRELATIVO;
            --COMMIT;
          END IF;
          COMMIT;
        ELSE
          P_VRF_ARCHIVO_ASCII(G_HOST,
                              G_PUERTO,
                              G_USUARIO,
                              G_PASS2,
                              G_DIRECTORIO_REMOTO_ERROR || DAT.NOMBRE_EMM,
                              RESPUESTAVRF);
          IF RESPUESTAVRF = 'Ok' THEN
            UPDATE OPERACION.TAB_ARCH_MSG_DTH AP
               SET AP.ESTADO_FILE = 'Error'
             WHERE AP.ID_ARCHIVO = DAT.IDARCH
               AND AP.COD_FILE = DAT.COD_FILE;
            COMMIT;
          
            SELECT ESTADO_FILE
              INTO EST_FIN
              FROM OPERACION.TAB_ARCH_MSG_DTH
             WHERE ID_ARCHIVO = DAT.IDARCH
               AND COD_FILE = DAT.COD_FILE;
          
            IF DAT.COD_FILE = L_CODFILE AND DAT.NUN_INTENTOS = 5 AND
               EST_FIN = 'Error' THEN
              UPDATE OPERACION.TAB_ARCH_MSG_DTH AM
                 SET AM.FLG = 1
               WHERE AM.ID_ARCHIVO = DAT.IDARCH
                 AND AM.COD_FILE = DAT.COD_FILE;
              COMMIT;
            END IF;
            SELECT COUNT(*)
              INTO L_CONTA5
              FROM OPERACION.TAB_ARCH_MSG_DTH AM
             WHERE AM.ID_ARCHIVO = P_ID_CORRELATIVO
               AND AM.ESTADO_FILE = 'Ok';
            SELECT COUNT(*)
              INTO L_CONTA6
              FROM OPERACION.TAB_ARCH_MSG_DTH AP
             WHERE AP.ID_ARCHIVO = P_ID_CORRELATIVO;
          
            IF L_CONTA5 = L_CONTA6 THEN
              UPDATE OPERACION.MENSAJE_DTH_CAB TA
                 SET TA.ESTMSG = 'Procesado Ok'
               WHERE TA.IDARCH = P_ID_CORRELATIVO;
            END IF;
            IF L_CONTA5 <> L_CONTA6 AND DAT.NUN_INTENTOS < 5 THEN
              UPDATE OPERACION.MENSAJE_DTH_CAB TA
                 SET TA.ESTMSG = 'En Proceso'
               WHERE TA.IDARCH = P_ID_CORRELATIVO;
            END IF;
            IF L_CONTA5 <> L_CONTA6 AND DAT.NUN_INTENTOS = 5 THEN
              UPDATE OPERACION.MENSAJE_DTH_CAB TA
                 SET TA.ESTMSG = 'Procesado con Errores'
               WHERE TA.IDARCH = P_ID_CORRELATIVO;
            END IF;
            COMMIT;
            P_ENVIAR_FILE_REENVIO(P_ID_CORRELATIVO, L_CODFILE);
            P_ELIMINAR_ARCHIVO_FTP(G_HOST,
                                   G_PUERTO,
                                   G_USUARIO,
                                   G_PASS2,
                                   G_DIRECTORIO_REMOTO_ERROR ||
                                   DAT.NOMBRE_EMM,
                                   L_RESULTADO_FTP,
                                   L_MENSAJE_FTP);
          END IF;
        END IF;
      ELSE
        IF DAT.NUN_INTENTOS > 5 THEN
          P_VRF_ARCHIVO_ASCII(G_HOST,
                              G_PUERTO,
                              G_USUARIO,
                              G_PASS2,
                              G_DIRECTORIO_REMOTO_OK || DAT.NOMBRE_EMM,
                              RESPUESTAVRF);
          IF RESPUESTAVRF = 'Ok' THEN
            P_ELIMINAR_ARCHIVO_FTP(G_HOST,
                                   G_PUERTO,
                                   G_USUARIO,
                                   G_PASS2,
                                   G_DIRECTORIO_REMOTO_OK || DAT.NOMBRE_EMM,
                                   L_RESULTADO_FTP,
                                   L_MENSAJE_FTP);
            UPDATE OPERACION.TAB_ARCH_MSG_DTH AP
               SET AP.ESTADO_FILE = 'Ok'
             WHERE AP.ID_ARCHIVO = DAT.IDARCH
               AND AP.COD_FILE = DAT.COD_FILE;
            COMMIT;
            SELECT COUNT(*)
              INTO L_CONTA5
              FROM OPERACION.TAB_ARCH_MSG_DTH AL
             WHERE AL.ID_ARCHIVO = P_ID_CORRELATIVO
               AND AL.ESTADO_FILE = 'Ok';
            SELECT COUNT(*)
              INTO L_CONTA6
              FROM OPERACION.TAB_ARCH_MSG_DTH AT
             WHERE AT.ID_ARCHIVO = P_ID_CORRELATIVO;
            IF L_CONTA5 = L_CONTA6 THEN
              UPDATE OPERACION.MENSAJE_DTH_CAB TA
                 SET TA.ESTMSG = 'Procesado Ok'
               WHERE TA.IDARCH = P_ID_CORRELATIVO;
              COMMIT;
            END IF;
          ELSE
            P_VRF_ARCHIVO_ASCII(G_HOST,
                                G_PUERTO,
                                G_USUARIO,
                                G_PASS2,
                                G_DIRECTORIO_REMOTO_ERROR || DAT.NOMBRE_EMM,
                                RESPUESTAVRF);
            IF RESPUESTAVRF = 'Ok' THEN
              P_ELIMINAR_ARCHIVO_FTP(G_HOST,
                                     G_PUERTO,
                                     G_USUARIO,
                                     G_PASS2,
                                     G_DIRECTORIO_REMOTO_ERROR ||
                                     DAT.NOMBRE_EMM,
                                     L_RESULTADO_FTP,
                                     L_MENSAJE_FTP);
              UPDATE OPERACION.TAB_ARCH_MSG_DTH AP
                 SET AP.ESTADO_FILE = 'Error'
               WHERE AP.ID_ARCHIVO = DAT.IDARCH
                 AND AP.COD_FILE = DAT.COD_FILE;
              UPDATE OPERACION.MENSAJE_DTH_CAB TA
                 SET TA.ESTMSG = 'Procesado con Errores'
               WHERE TA.IDARCH = P_ID_CORRELATIVO;
              COMMIT;
            END IF;
          END IF;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      P_LOG_ERROR(P_ID_CORRELATIVO,
                  'P_ACTUALIZA_ESTADO_FILE',
                  SQLCODE,
                  SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Reenvia los Archivos, de acuerdo al valor establecido en Configuraciones de Tipos y estados.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ENVIAR_FILE_REENVIO(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE,
                                  P_COD_FILE       IN OPERACION.TAB_ARCH_MSG_DTH.COD_FILE%TYPE) IS
    LR_ATC_FILE_PAREO_DTH OPERACION.TAB_ARCH_MSG_DTH%ROWTYPE;
    L_ARCHIVO_REMOTO      VARCHAR(1000);
  BEGIN
    P_SET_CONFIGURACION;
    SELECT *
      INTO LR_ATC_FILE_PAREO_DTH
      FROM OPERACION.TAB_ARCH_MSG_DTH TH
     WHERE TH.ID_ARCHIVO = P_ID_CORRELATIVO
       AND TH.COD_FILE = P_COD_FILE;
    IF LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS < F_OBTIENE_MAXIMO_ENVIOS() THEN
      LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS := NVL(LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS,
                                                0) + 1;
      IF LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS <= 5 THEN
        L_ARCHIVO_REMOTO := REPLACE(REPLACE(G_DIRECTORIO_REMOTO_ENVIO || '/' ||
                                            LR_ATC_FILE_PAREO_DTH.NOMBRE_FILE,
                                            '//',
                                            '/'),
                                    '.tmp',
                                    '.emm');
        OPERACION.PQ_DTH_INTERFAZ.P_ENVIAR_ARCHIVO_ASCII(G_HOST,
                                                         G_PUERTO,
                                                         G_USUARIO,
                                                         G_PASS,
                                                         PDIRECTORIO,
                                                         LR_ATC_FILE_PAREO_DTH.NOMBRE_FILE,
                                                         L_ARCHIVO_REMOTO);
      END IF;
      UPDATE OPERACION.TAB_ARCH_MSG_DTH TA
         SET TA.NUN_INTENTOS = LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS
       WHERE TA.ID_ARCHIVO = P_ID_CORRELATIVO
         AND TA.COD_FILE = LR_ATC_FILE_PAREO_DTH.COD_FILE;
      UPDATE OPERACION.TAB_ARCH_MSG_DTH TE
         SET TE.ESTADO_FILE = 'Enviado',
             TE.USU_ENVIO   = USER,
             TE.FECH_ENVIO  = SYSDATE
       WHERE TE.ID_ARCHIVO = P_ID_CORRELATIVO
         AND TE.COD_FILE = LR_ATC_FILE_PAREO_DTH.COD_FILE;
      UPDATE OPERACION.MENSAJE_DTH_CAB TM
         SET TM.ESTMSG = 'En proceso'
       WHERE TM.IDARCH = P_ID_CORRELATIVO;
      COMMIT;
      LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS := NVL(LR_ATC_FILE_PAREO_DTH.NUN_INTENTOS,
                                                0) + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      Rollback;
      P_LOG_ERROR(P_ID_CORRELATIVO,
                  'P_ENVIAR_FILE_REENVIO',
                  SQLCODE,
                  SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Instruccion que realiza el Reenvio Manual desde el SGA
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_REENVIO_MANUAL(IDARCHIVORE IN V_NTARJETA) IS
    I NUMBER;
  BEGIN
    FOR I IN 1 .. IDARCHIVORE.COUNT() LOOP
      P_ACTUALIZA_ESTADO_FILE_MANUAL(IDARCHIVORE(I));
      COMMIT;
    END LOOP;
    COMMIT;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Devuelve un listado de registros al SGA
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_LISTAR_SOLICITUD_CAB_HIST RETURN TY_IENVDTH_TBL
    PIPELINED IS
    L_SOLICITUD_PROC_MENSJ TY_ENVDTH := TY_ENVDTH(NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL,
                                                  NULL);
  BEGIN
    FOR LISTA IN (SELECT /*+ FIRST_ROWS (20) */
                   (R.IDARCH),
                   R.TIPMSG,
                   (SELECT TM.DESCRIPCION
                      FROM OPERACION.TIP_MENSAJE TM
                     WHERE TM.IDTIPMENS = R.TIPMSG) AS TIPO_DE_MENSAJE,
                   R.CODMSGD,
                   R.DESCRIP AS DESCRIPCIÓN,
                   R.FECUSU AS FECHA_DE_CREACIÓN,
                   R.MENSAJE AS MENSAJE,
                   R.CANTTAR AS NUM_DE_TARJETAS,
                   R.FECENV,
                   R.ESTMSG AS ESTADO,
                   0 AS ELIMINAR
                    FROM OPERACION.MENSAJE_DTH_CAB R
                   where UPPER(R.USUREG) = UPPER(USER)
                   ORDER BY R.IDARCH DESC) LOOP
      L_SOLICITUD_PROC_MENSJ.ID_ARCHIVO        := LISTA.IDARCH;
      L_SOLICITUD_PROC_MENSJ.TIPMENSAJE        := LISTA.TIPMSG;
      L_SOLICITUD_PROC_MENSJ.TIPO_DE_MENSAJE   := LISTA.TIPO_DE_MENSAJE;
      L_SOLICITUD_PROC_MENSJ.COD_MSGDTH        := LISTA.CODMSGD;
      L_SOLICITUD_PROC_MENSJ.DESCRIPCION       := LISTA.DESCRIPCIÓN;
      L_SOLICITUD_PROC_MENSJ.MENSAJE           := LISTA.MENSAJE;
      L_SOLICITUD_PROC_MENSJ.FECHA_DE_CREACION := LISTA.FECHA_DE_CREACIÓN;
      L_SOLICITUD_PROC_MENSJ.FECHA_ENVIO       := LISTA.FECENV;
      L_SOLICITUD_PROC_MENSJ.NUM_DE_TARJETAS   := LISTA.NUM_DE_TARJETAS;
      L_SOLICITUD_PROC_MENSJ.ESTADO            := LISTA.ESTADO;
      L_SOLICITUD_PROC_MENSJ.FLG               := LISTA.ELIMINAR;
      PIPE ROW(L_SOLICITUD_PROC_MENSJ);
    END LOOP;
    RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Realiza en Reenvio de Archivos al Servidor.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_ACTUALIZA_ESTADO_FILE_MANUAL(P_ID_CORRELATIVO IN OPERACION.TAB_ARCH_MSG_DTH.ID_ARCHIVO%TYPE) IS
    L_ARCHIVO_REMOTO VARCHAR(1000);
    L_CODFILE        NUMBER;
    L_IDARCHIVO      NUMBER;
    L_NOMBRETMP      VARCHAR2(20);
    CURSOR CONS IS
      SELECT DT.ESTADO_FILE,
             TC.ESTMSG,
             DT.COD_FILE,
             TC.IDARCH,
             DT.NOMBRE_EMM,
             DT.NUN_INTENTOS,
             DT.NOMBRE_FILE
        FROM OPERACION.MENSAJE_DTH_CAB TC, OPERACION.TAB_ARCH_MSG_DTH DT
       WHERE TC.IDARCH = DT.ID_ARCHIVO
         AND TC.IDARCH = P_ID_CORRELATIVO
         AND DT.ESTADO_FILE = 'Error';
  BEGIN
    P_SET_CONFIGURACION;
    FOR DAT IN CONS LOOP
      L_CODFILE   := DAT.COD_FILE;
      L_IDARCHIVO := DAT.IDARCH;
      L_NOMBRETMP := DAT.NOMBRE_FILE;
      IF DAT.ESTADO_FILE = 'Error' THEN
        L_ARCHIVO_REMOTO := REPLACE(REPLACE(G_DIRECTORIO_REMOTO_ENVIO || '/' ||
                                            DAT.NOMBRE_FILE,
                                            '//',
                                            '/'),
                                    '.tmp',
                                    '.emm');
        OPERACION.PQ_DTH_INTERFAZ.P_ENVIAR_ARCHIVO_ASCII(G_HOST,
                                                         G_PUERTO,
                                                         G_USUARIO,
                                                         G_PASS,
                                                         PDIRECTORIO,
                                                         DAT.NOMBRE_FILE,
                                                         L_ARCHIVO_REMOTO);
        DAT.NUN_INTENTOS := NVL(DAT.NUN_INTENTOS, 0) + 1;
        UPDATE OPERACION.TAB_ARCH_MSG_DTH TA
           SET TA.NUN_INTENTOS = DAT.NUN_INTENTOS,
               TA.ESTADO_FILE  = 'Enviado'
         WHERE TA.ID_ARCHIVO = P_ID_CORRELATIVO
           AND TA.COD_FILE = DAT.COD_FILE;
        UPDATE OPERACION.MENSAJE_DTH_CAB TC
           SET TC.ESTMSG = 'En proceso'
         WHERE TC.IDARCH = P_ID_CORRELATIVO;
        COMMIT;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      P_LOG_ERROR(P_ID_CORRELATIVO,
                  'P_ACTUALIZA_ESTADO_FILE_MANUAL',
                  SQLCODE,
                  SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Procedimiento
  *Descripción        : Ejecuta la Actualizacion de la Cabecera del mensaje en el SGA para su envio
                        en el conax.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_BOTON_ENVIAR(IDARCHIVO IN V_NTARJETA) IS
    I NUMBER;
  BEGIN
    FOR I IN 1 .. IDARCHIVO.COUNT() LOOP
      UPDATE OPERACION.MENSAJE_DTH_CAB C
         SET C.ESTMSG = 'En proceso'
       WHERE C.IDARCH = IDARCHIVO(I);
    END LOOP;
    COMMIT;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Realiza la Busqueda de SOT en el SGA. retorna los numeros de tarjetas asociados
                        a la SOT.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_FIND_SOT(P_CODSOLOT OPE_SRV_RECARGA_CAB.CODSOLOT%TYPE)
    RETURN VTATABCLI.CODCLI%TYPE IS
    L_RETURN VTATABCLI.CODCLI%TYPE;
  BEGIN
    SELECT DISTINCT OSR.CODCLI
      INTO L_RETURN
      FROM OPE_SRV_RECARGA_CAB OSR, SOLOT SOT, ESTSOL EST
     WHERE SOT.CODSOLOT = OSR.CODSOLOT
       AND SOT.ESTSOL = EST.ESTSOL
       AND EST.ESTSOL IN (12, 29)
       AND OSR.CODSOLOT = P_CODSOLOT;
    RETURN L_RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      L_RETURN := '0';
      RETURN L_RETURN;
    WHEN OTHERS THEN
      L_RETURN := '-1';
      RETURN L_RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Realiza la Busqueda de Servicio en el SGA. retorna los numeros de tarjetas
                        asociados al servicio.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_FIND_SERVICIO(P_NRO_SERVICIO NUMBER) RETURN NUMBER IS
    L_RETURN NUMBER;
  BEGIN
    SELECT PDC.CUSTOMER_ID
      INTO L_RETURN
      FROM TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF PDC
     WHERE PDC.CUSTOMER_ID IN
           (SELECT CU.CUSTOMER_ID
              FROM CUSTOMER_ALL@DBL_BSCS_BF CU, CONTRACT_ALL@DBL_BSCS_BF CO
             WHERE CU.CUSTOMER_ID = CO.CUSTOMER_ID
               AND CU.CSTYPE = 'a'
               AND CU.CSLEVEL = '40'
               AND CO.TMCODE = 200)
       AND PDC.DN_NUM LIKE '2%'
       AND PDC.DN_NUM = P_NRO_SERVICIO;
    RETURN L_RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      L_RETURN := 0;
      RETURN L_RETURN;
    WHEN OTHERS THEN
      L_RETURN := -1;
      RETURN L_RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Realiza la Busqueda de Clientes en el SGA.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_FIND_CLIENTE(P_TIPO_PAREO VARCHAR2,
                          P_CODCLI     VTATABCLI.CODCLI%TYPE)
    RETURN VTATABCLI.NOMCLI%TYPE IS
    L_RETURN VTATABCLI.NOMCLI%TYPE;
  BEGIN
    IF P_TIPO_PAREO = 'PRE' THEN
      BEGIN
        SELECT VCL.NOMCLI
          INTO L_RETURN
          FROM MARKETING.VTATABCLI VCL
         WHERE VCL.CODCLI = P_CODCLI
           AND EXISTS (SELECT 1
                  FROM OPE_SRV_RECARGA_CAB OSR
                 WHERE OSR.CODCLI = VCL.CODCLI);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          L_RETURN := '0';
        WHEN OTHERS THEN
          L_RETURN := '-1';
      END;
    ELSE
      BEGIN
        SELECT CTA.CCNAME || ' ' || CTA.CCFNAME || ' ' || CTA.CCLNAME
          INTO L_RETURN
          FROM CCONTACT_ALL@DBL_BSCS_BF CTA
         WHERE TO_CHAR(CTA.CUSTOMER_ID) = P_CODCLI
           AND CTA.CCBILL = 'X';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          L_RETURN := '0';
        WHEN OTHERS THEN
          L_RETURN := '-1';
      END;
    END IF;
    RETURN L_RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Realiza la Busqueda de las tarjetas asociadas al cliente
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_LISTAR_TARJETAXCLIENTE(P_TIPO_PAREO  VARCHAR2,
                                    P_TIPO_FILTRO INTEGER,
                                    P_CODCLI      VTATABCLI.CODCLI%TYPE,
                                    P_DNI         OPE_SRV_RECARGA_CAB.CODIGO_RECARGA%TYPE,
                                    P_CODSOLOT    OPE_SRV_RECARGA_CAB.CODSOLOT%TYPE)
    RETURN TARJETA_CLIENTE_DTH_TBL
    PIPELINED IS
    L_CLIENTE_DTH TARJETA_CLIENTE_DTH := TARJETA_CLIENTE_DTH(NULL);
  BEGIN
    IF P_TIPO_PAREO = 'PRE' THEN
      IF P_TIPO_FILTRO = 1 THEN
        --- SOT
        FOR LISTA IN (SELECT DISTINCT TRIM(SPE.NUMSERIE) AS NRO_TARJETA
                        FROM SOLOTPTOEQU SPE, OPE_SRV_RECARGA_CAB OSR
                       WHERE OSR.CODSOLOT = SPE.CODSOLOT
                         AND SPE.NUMSERIE IS NOT NULL
                         AND OSR.CODSOLOT = P_CODSOLOT) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      ELSIF P_TIPO_FILTRO = 2 THEN
        --- CLIENTE
        FOR LISTA IN (SELECT DISTINCT TRIM(SPE.NUMSERIE) AS NRO_TARJETA
                        FROM SOLOTPTOEQU SPE, OPE_SRV_RECARGA_CAB OSR
                       WHERE OSR.CODSOLOT = SPE.CODSOLOT
                         AND SPE.NUMSERIE IS NOT NULL
                         AND SPE.TIPEQU = 7242
                         AND OSR.CODCLI = P_CODCLI) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      ELSE
        --- DNI
        FOR LISTA IN (SELECT DISTINCT TRIM(SPE.NUMSERIE) AS NRO_TARJETA
                        FROM SOLOTPTOEQU SPE
                       WHERE SPE.NUMSERIE IS NOT NULL
                         AND SPE.TIPEQU = 7242
                         AND EXISTS
                       (SELECT 1
                                FROM OPE_SRV_RECARGA_CAB OSR,
                                     MARKETING.VTATABCLI VTC
                               WHERE OSR.CODCLI = VTC.CODCLI
                                 AND VTC.TIPDIDE IN
                                     (SELECT VTP.TIPDIDE
                                        FROM MARKETING.VTATIPDID VTP
                                       WHERE VTP.ABRDID = 'DNI/LE')
                                 AND OSR.CODSOLOT = SPE.CODSOLOT
                                 AND SUBSTR(VTC.NTDIDE, 7, 8) = P_DNI)) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      END IF;
    ELSE
      IF P_TIPO_FILTRO = 1 THEN
        --- SERVICIO
        FOR LISTA IN (SELECT TO_CHAR(PDT.NRO_TARJETA) AS NRO_TARJETA
                        FROM TIM.PP_DTH_TARJETA@DBL_BSCS_BF    PDT,
                             TIM.PP_DTH_PROV@DBL_BSCS_BF       PDP,
                             TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF PDC
                       WHERE PDT.ID_TARJETA = PDP.ID_TARJETA
                         AND PDC.CO_ID = PDP.CO_ID
                         AND PDC.DN_NUM LIKE '21%'
                         AND PDC.DN_NUM = P_CODSOLOT) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      ELSIF P_TIPO_FILTRO = 2 THEN
        --- CLIENTE
        FOR LISTA IN (SELECT TO_CHAR(PDT.NRO_TARJETA) AS NRO_TARJETA
                        FROM TIM.PP_DTH_TARJETA@DBL_BSCS_BF    PDT,
                             TIM.PP_DTH_PROV@DBL_BSCS_BF       PDP,
                             TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF PDC
                       WHERE PDT.ID_TARJETA = PDP.ID_TARJETA
                         AND PDC.CO_ID = PDP.CO_ID
                         AND PDC.DN_NUM LIKE '21%'
                         AND PDC.CUSTOMER_ID = P_CODCLI) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      ELSE
        --- DNI Y SERVICIO
        FOR LISTA IN (SELECT TH.NRO_TARJETA AS NRO_TARJETA
                        FROM TIM.PP_DATOS_CONTRATO@DBL_BSCS_BF DC,
                             TIM.PP_DTH_PROV@DBL_BSCS_BF       V,
                             TIM.PP_DTH_TARJETA@DBL_BSCS_BF    TH
                       WHERE DC.TMCODE = 200
                         AND DC.CO_ID = V.CO_ID
                         AND DC.CH_STATUS IN ('a', 's')
                         AND V.ID_TARJETA = TH.ID_TARJETA
                         AND V.FECHA_DESACT IS NULL
                         AND (SELECT NVL(CU.CSCOMPREGNO, CU.PASSPORTNO)
                                FROM CUSTOMER_ALL@DBL_BSCS_BF CU
                               WHERE CU.CUSTOMER_ID = DC.CUSTOMER_ID) =
                             P_DNI) LOOP
          L_CLIENTE_DTH.NRO_TARJETA := LISTA.NRO_TARJETA;
          PIPE ROW(L_CLIENTE_DTH);
        END LOOP;
      END IF;
    END IF;
    RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Devuelve un listado de Clientes al SGA.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  FUNCTION F_LISTADO_CLIENTE(P_TIPO_PAREO VARCHAR2,
                             P_NOMCLI     VTATABCLI.NOMCLI%TYPE)
    RETURN CLIENTE_DTH_TBL
    PIPELINED IS
    L_CLIENTE CLIENTE_DTH := CLIENTE_DTH(NULL, NULL, NULL, NULL);
  BEGIN
    IF P_TIPO_PAREO = 'PRE' THEN
      IF LENGTH(TRIM(P_NOMCLI)) = 0 OR P_NOMCLI IS NULL THEN
        FOR L_LISTA IN (SELECT VCL.CODCLI,
                               VCL.NOMCLI,
                               VCL.DIRCLI,
                               SUBSTR(VUB.DISTRITO_DESC,
                                      1,
                                      INSTR(VUB.DISTRITO_DESC, '|') - 1) AS DISTRITO
                          FROM MARKETING.VTATABCLI VCL,
                               OPE_SRV_RECARGA_CAB OSR,
                               V_UBICACIONES       VUB
                         WHERE VCL.CODCLI = OSR.CODCLI
                           AND VCL.CODUBI = VUB.CODUBI
                           AND VCL.CODCLI LIKE '%'
                           AND ROWNUM < 100) LOOP
          L_CLIENTE.CODCLI   := L_LISTA.CODCLI;
          L_CLIENTE.NOMCLI   := L_LISTA.NOMCLI;
          L_CLIENTE.DIRCLI   := L_LISTA.DIRCLI;
          L_CLIENTE.DISTRITO := L_LISTA.DISTRITO;
          PIPE ROW(L_CLIENTE);
        END LOOP;
      ELSE
        FOR L_LISTA IN (SELECT VCL.CODCLI,
                               VCL.NOMCLI,
                               VCL.DIRCLI,
                               SUBSTR(VUB.DISTRITO_DESC,
                                      1,
                                      INSTR(VUB.DISTRITO_DESC, '|') - 1) AS DISTRITO
                          FROM MARKETING.VTATABCLI VCL,
                               OPE_SRV_RECARGA_CAB OSR,
                               V_UBICACIONES       VUB
                         WHERE OSR.CODCLI = VCL.CODCLI
                           AND VCL.CODUBI = VUB.CODUBI
                           AND VCL.NOMCLI LIKE '%' || P_NOMCLI || '%'
                           AND ROWNUM < 100) LOOP
          L_CLIENTE.CODCLI   := L_LISTA.CODCLI;
          L_CLIENTE.NOMCLI   := L_LISTA.NOMCLI;
          L_CLIENTE.DIRCLI   := L_LISTA.DIRCLI;
          L_CLIENTE.DISTRITO := L_LISTA.DISTRITO;
          PIPE ROW(L_CLIENTE);
        END LOOP;
      END IF;
    ELSE
      IF LENGTH(TRIM(P_NOMCLI)) = 0 OR P_NOMCLI IS NULL THEN
        FOR L_LISTA IN (SELECT CTA.CUSTOMER_ID AS CODCLI,
                               CTA.CCNAME || ' ' || CTA.CCFNAME || ' ' ||
                               CTA.CCLNAME AS NOMCLI,
                               CTA.CCADDR1 || ' ' || CTA.CCADDR2 AS DIRCLI,
                               CTA.CCADDR3 AS DISTRITO
                          FROM CCONTACT_ALL@DBL_BSCS_BF CTA
                         WHERE CTA.CCBILL = 'X'
                           AND EXISTS
                         (SELECT 1
                                  FROM CUSTOMER_ALL@DBL_BSCS_BF CU,
                                       CONTRACT_ALL@DBL_BSCS_BF CO
                                 WHERE CU.CUSTOMER_ID = CO.CUSTOMER_ID
                                   AND CU.CSTYPE = 'a'
                                   AND CU.CSLEVEL = '40'
                                   AND CO.TMCODE = 200
                                   AND CU.CUSTOMER_ID = CTA.CUSTOMER_ID)
                           AND ROWNUM <= 100
                         ORDER BY 1 DESC) LOOP
          L_CLIENTE.CODCLI   := L_LISTA.CODCLI;
          L_CLIENTE.NOMCLI   := L_LISTA.NOMCLI;
          L_CLIENTE.DIRCLI   := L_LISTA.DIRCLI;
          L_CLIENTE.DISTRITO := L_LISTA.DISTRITO;
          PIPE ROW(L_CLIENTE);
        END LOOP;
      ELSE
        FOR L_LISTA IN (SELECT CTA.CUSTOMER_ID AS CODCLI,
                               CTA.CCNAME || ' ' || CTA.CCFNAME || ' ' ||
                               CTA.CCLNAME AS NOMCLI,
                               CTA.CCADDR1 || ' ' || CTA.CCADDR2 AS DIRCLI,
                               CTA.CCADDR3 AS DISTRITO
                          FROM CCONTACT_ALL@DBL_BSCS_BF CTA
                         WHERE CTA.CCBILL = 'X'
                           AND EXISTS
                         (SELECT 1
                                  FROM CUSTOMER_ALL@DBL_BSCS_BF CU,
                                       CONTRACT_ALL@DBL_BSCS_BF CO
                                 WHERE CU.CUSTOMER_ID = CO.CUSTOMER_ID
                                   AND CU.CSTYPE = 'a'
                                   AND CU.CSLEVEL = '40'
                                   AND CO.TMCODE = 200
                                   AND CU.CUSTOMER_ID = CTA.CUSTOMER_ID)
                           AND TO_CHAR(CTA.CUSTOMER_ID) = P_NOMCLI
                           AND ROWNUM <= 100
                         ORDER BY 1 DESC) LOOP
          L_CLIENTE.CODCLI   := L_LISTA.CODCLI;
          L_CLIENTE.NOMCLI   := L_LISTA.NOMCLI;
          L_CLIENTE.DIRCLI   := L_LISTA.DIRCLI;
          L_CLIENTE.DISTRITO := L_LISTA.DISTRITO;
          PIPE ROW(L_CLIENTE);
        END LOOP;
      END IF;
    END IF;
    RETURN;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Verifica la conectividad
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_VRF_ARCHIVO_ASCII(PHOST      IN VARCHAR2,
                                PPUERTO    IN VARCHAR2,
                                PUSUARIO   IN VARCHAR2,
                                PPASS      IN VARCHAR2,
                                PDIRECARCH IN VARCHAR2,
                                RESPUESTA  OUT VARCHAR2) IS
    L_CONN UTL_TCP.CONNECTION;
    PVRF   OPERACION.FTP.T_STRING_TABLE;
  BEGIN
    IF PPUERTO = 21 THEN
      L_CONN := OPERACION.FTP.LOGIN(PHOST, PPUERTO, PUSUARIO, PPASS);
      OPERACION.FTP.ASCII(P_CONN => L_CONN);
      OPERACION.FTP.NLST(P_CONN => L_CONN,
                         P_DIR  => PDIRECARCH,
                         P_LIST => PVRF);
      OPERACION.FTP.LOGOUT(L_CONN);
      UTL_TCP.CLOSE_ALL_CONNECTIONS;
      IF PVRF.COUNT > 0 THEN
        RESPUESTA := 'Ok';
      END IF;
    ELSIF PPUERTO = 22 THEN
      RESPUESTA := OPERACION.SFTP.VERIFARCHIVO(PUSUARIO,
                                               PPASS,
                                               PHOST,
                                               PPUERTO,
                                               PRUTKNOWHOST,
                                               PDIRECARCH);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20080, SQLERRM);
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Agrupa los archivos de mas de mil registros en grupos de 4000 reg.
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_TARJETAS(ID_PROCESO IN NUMBER) IS
    TOTAL   NUMBER;
    RESIDUO NUMBER;
    VUELTA  NUMBER;
    A       NUMBER;
  BEGIN
    SELECT COUNT(D.CODTARJ)
      INTO TOTAL
      FROM OPERACION.MENSAJE_DTH_DET D
     WHERE D.IDARCH = ID_PROCESO
       AND D.FLGVAL = 1
       AND D.FLGAGP = 0;
    RESIDUO := MOD(TOTAL, 4000);
    VUELTA  := TRUNC(TOTAL / 4000);
    IF RESIDUO > 0 THEN
      VUELTA := TRUNC(TOTAL / 4000) + 1;
    END IF;
    A := 0;
    FOR I IN 0 .. VUELTA - 1 LOOP
      A := A + 1;
      UPDATE OPERACION.MENSAJE_DTH_DET D
         SET D.FLGAGP = A
       WHERE D.IDARCH = ID_PROCESO
         AND ROWNUM <= 4000
         AND D.FLGAGP = 0
         AND D.FLGVAL = 1;
    END LOOP;
  END;

  /************************************************************************************************
  *Tipo               : Funcion
  *Descripción        : Registra los Errores presentados durante el proceso de Envio a Conax
  *Autor              : Antonio Astete
  *Proyecto o REQ     : PQT-208477-TSK-56543 Envío mensaje CONAX
  *Fecha de Creación  : 24/02/2015
  ************************************************************************************************/
  PROCEDURE P_LOG_ERROR(AN_ARCH   IN NUMBER,
                        AN_PROC   IN VARCHAR2,
                        AN_CODERR IN NUMBER,
                        AN_MSJERR IN VARCHAR2) IS
    L_IDERROR NUMBER;
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    SELECT OPERACION.SQ_SEQ_ENVIO.NEXTVAL INTO L_IDERROR FROM DUAL;
    INSERT INTO HISTORICO.LOG_ERRORES_ENVIO_DTH
      (ID_ERROR,
       ID_ARCH,
       PROCEDIMIENTO,
       COD_ERR,
       MSJ_ERR,
       USU_ERR,
       FEC_ERR)
    VALUES
      (L_IDERROR, AN_ARCH, AN_PROC, AN_CODERR, AN_MSJERR, USER, SYSDATE);
    COMMIT;
  END;
END PQ_DTH_MSG_CONAX;
/