CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_PORTOUT_CORP AS
  /******************************************************************************
     NOMBRE:       OPERACION.PKG_PORTOUT_CORP
     PROPOSITO:    AUTOMATIZAR EL PROCESO DE LIBERACIÓN PARCIAL DE NÚMERO EN PORT OUT DE
                   LÍNEAS FIJAS CORPORATIVAS Y CLARO NEGOCIOS HFC.
    VERSION     FECHA       AUTOR            SOLICITADO POR  DESCRIPCIÓN.
    ---------  ----------  ---------------   --------------  ---------------------------------
      1.0      01/02/2019  CONRAD AGÜERO     MARIO HIDALGO   PORT OUT
	  1.1      13/03/2019  CONRAD AGÜERO     MARIO HIDALGO   MODIFICACIÓN SP  SGASS_VALIDA_NUMERO

  ******************************************************************************/

  /******************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGASS_VALIDA_NUMERO
     PROPOSITO:  VALIDA EL NÚMERO TELEFÓNICO.
     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO   VALIDA EL NÚMERO TELEFÓNICO
	 1.1        13/03/2019  CONRAD AGÜERO   SE QUITÓ LAS VALIDACIONES "QUE LA LINEA NO ESTE CANCELADA" Y QUE EL ESTADO DEL NUMERO NO SEA 12 (RESERVA PORT-OUT)
  ******************************************************************/
  PROCEDURE SGASS_VALIDA_NUMERO(PI_NUM    IN VARCHAR2,
                                PO_CODERR OUT NUMBER,
                                PO_MSJERR OUT VARCHAR2) IS

    L_VAL        NUMBER;
    L_RUC        VARCHAR2(15);
    L_ENVIADO    NUMBER;
    L_CODERR     NUMBER;
    L_MSJERR     VARCHAR2(100);
    L_EXCEPT EXCEPTION;

  BEGIN
    PO_CODERR := 0;
    PO_MSJERR := 'LINEA LISTA PARA PORTAR';
    --VALIDAMOS REGISTRO EN LA NUMTEL
    SELECT COUNT(1) INTO L_VAL FROM NUMTEL WHERE NUMERO = PI_NUM;

    IF L_VAL = 0 THEN
      L_CODERR := -1;
      L_MSJERR := 'LA LINEA NO SE ENCUENTRA REGISTRADA EN SGA';
      RAISE L_EXCEPT;
    END IF;
    --  VALIDAR SI YA SE ENVIO CORREO
    SELECT COUNT(1)
      INTO L_ENVIADO
      FROM OPERACION.SGAT_PORTOUTCORPLOG
     WHERE POCD_FECIN > SYSDATE - 90
       AND POCN_NUMERO = PI_NUM;

    IF L_ENVIADO > 0 THEN
      L_CODERR := -1;
      L_MSJERR := 'ESTE NÚMERO YA FUE PROCESADO';
      RAISE L_EXCEPT;
    END IF;
    --  VALIDAMOS QUE EL CLIENTE TENGA RUC
    SELECT C.NTDIDE
      INTO L_RUC
      FROM INSSRV A, NUMTEL B, VTATABCLI C
     WHERE A.CODINSSRV = B.CODINSSRV
       AND A.NUMERO = B.NUMERO
       AND A.CODCLI = C.CODCLI
       AND A.NUMERO = PI_NUM;

    IF LENGTH(L_RUC) >= 11 AND
       (SUBSTR(L_RUC, 1, 2) = '10' OR SUBSTR(L_RUC, 1, 2) = '20') THEN
      PO_MSJERR := 'LINEA LISTA PARA PORTAR';
    ELSE
      L_CODERR := -1;
      L_MSJERR := 'EL CLIENTE NO TIENE RUC';
      RAISE L_EXCEPT;
    END IF;

  EXCEPTION
    WHEN L_EXCEPT THEN
      PO_CODERR := L_CODERR;
      PO_MSJERR := L_MSJERR;
    WHEN OTHERS THEN
      PO_CODERR := -1;
      PO_MSJERR := 'ERROR AL VALIDAR NUMERO:' || TO_CHAR(SQLERRM);
  END;
  /******************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGAFS_CID
     PROPOSITO:  FUNCIÓN PARA OBTENER EL CID A PARTIR DE UN NÚMERO TELEFÓNICO..
     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO   OBTENER EL CID .
  ******************************************************************/

  FUNCTION SGAFS_CID(PI_NUM IN VARCHAR2) RETURN VARCHAR2 IS
    LV_CID VARCHAR2(20);

  BEGIN
    SELECT A.CID
      INTO LV_CID
      FROM INSSRV A, NUMTEL B, NUMXGRUPOTEL C, PRIXHUNTING D, PRITEL E
     WHERE A.CODINSSRV = E.CODINSSRV
       AND B.CODNUMTEL = C.CODNUMTEL
       AND C.CODCAB = D.CODCAB
       AND D.CODPRITEL = E.CODPRITEL
       AND B.NUMERO = PI_NUM;

    RETURN LV_CID;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /******************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGAFS_OBT_MAIL
     PROPOSITO:  FUNCIÓN PARA OBTENER EL EMAIL.
     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO   OBTENER EMAIL.

    PI_TIP     DESCRIPCIÓN
     1          EMAIL DEL EJECUTIVO
     2          EMAIL DEL SUPERVISOR
     3          EMAIL CONTROL DE ATENCIÓN EMPRESARIAL (CAE)
     4          EMAIL NO CARTERIZADO
  ******************************************************************/

  FUNCTION SGAFS_OBT_MAIL(PI_RUC IN VARCHAR2, PI_TIP IN INTEGER)
    RETURN VARCHAR2 IS
    LV_MAIL VARCHAR2(100);
    LN_ID   NUMBER;

  BEGIN
    SELECT MAX(ASESN_ID) INTO LN_ID FROM MARKETING.SGAT_ASESOR_CORP;
    CASE PI_TIP
      WHEN 1 THEN
        SELECT ASEDV_ASES_EMAIL
          INTO LV_MAIL
          FROM MARKETING.SGAT_ASESOR_CORP_DET
         WHERE ASEDV_CLIENTE_RUC = PI_RUC
           AND ASEDN_ESTADO = 1
           AND ASEDN_TIPO = 1
           AND ASESN_ID = LN_ID
           AND ROWNUM = 1;
      WHEN 2 THEN
        SELECT ASEDV_SUPERV_EMAIL
          INTO LV_MAIL
          FROM MARKETING.SGAT_ASESOR_CORP_DET
         WHERE ASEDV_CLIENTE_RUC = PI_RUC
           AND ASEDN_ESTADO = 1
           AND ASEDN_TIPO = 1
           AND ASESN_ID = LN_ID
           AND ROWNUM = 1;
      WHEN 3 THEN
        SELECT ASEDV_ASES_EMAIL
          INTO LV_MAIL
          FROM MARKETING.SGAT_ASESOR_CORP_DET
         WHERE ASEDN_ID_DET = 0
           AND ASEDN_ESTADO = 1
           AND ASEDN_TIPO = 2;
      WHEN 4 THEN
        SELECT ASEDV_SUPERV_EMAIL
          INTO LV_MAIL
          FROM MARKETING.SGAT_ASESOR_CORP_DET
         WHERE ASEDN_ID_DET = 0
           AND ASEDN_ESTADO = 1
           AND ASEDN_TIPO = 2;
    END CASE;
    RETURN LV_MAIL;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;

  /******************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGASI_INSERT_LOG
     PROPOSITO:  INSERTAR DATA EN LA TABLA LOG.
     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO   INSERTAR DATA EN LA TABLA LOG.
  ******************************************************************/

  PROCEDURE SGASI_INSERT_LOG(PI_NUM        IN VARCHAR2,
                             PI_CLI        IN VARCHAR2,
                             PI_MAIL_ASESO IN VARCHAR2,
                             PI_MAIL_SUPER IN VARCHAR2,
                             PO_MSJERR     OUT VARCHAR2) IS
  BEGIN
    INSERT INTO OPERACION.SGAT_PORTOUTCORPLOG
      (POCN_NUMERO,
       POCV_CLIENTE,
       POCV_ASES_EMAIL,
       POCV_SUPERV_EMAIL,
       POCN_ESTADO)
    VALUES
      (PI_NUM, PI_CLI, PI_MAIL_ASESO, PI_MAIL_SUPER, 1);

  EXCEPTION

    WHEN OTHERS THEN
      PO_MSJERR := 'ERROR AL INSERTAR LOG:' || TO_CHAR(SQLERRM);

  END;

  /***************************************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGASS_OBT_ASESO
     PROPOSITO:  OBTENER  CORREOS DE ASESORES Y SUPERVISORES.

     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0      01/02/2019  CONRAD AGÜERO    LISTA DE CORREOS DE ASESORES Y SUPERVISORES.
  *****************************************************************************************/

  PROCEDURE SGASS_OBT_ASESO(PO_CURSOR            OUT SYS_REFCURSOR,
                            PO_CODIGO_RESPUESTA  OUT INTEGER,
                            PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    CURSOR CUR_NUMEROS_PORTOUT IS
      SELECT B.NUMERO, C.CODCLI
        FROM SOPFIJA.NUMEROS_PORT B
        LEFT JOIN NUMTEL A
          ON A.NUMERO = B.NUMERO
        LEFT JOIN INSSRV C
          ON A.CODINSSRV = C.CODINSSRV
         AND A.NUMERO = C.NUMERO
       ORDER BY C.CODCLI DESC;

    L_CODERR       NUMBER;
    L_MSJERR       VARCHAR2(400);
    L_MAIL_ASES    VARCHAR2(100);
    L_MAIL_SUPERVI VARCHAR2(100);
    L_RUC          VARCHAR2(15);
    L_EXCEPTION EXCEPTION;

  BEGIN

    UPDATE OPERACION.SGAT_PORTOUTCORPLOG
       SET POCN_ESTADO = 0
     WHERE POCN_ESTADO = 1;
    FOR C IN CUR_NUMEROS_PORTOUT LOOP
      --VALIDAMOS LOS NÚMEROS
      SGASS_VALIDA_NUMERO(C.NUMERO, L_CODERR, L_MSJERR);
      IF L_CODERR = 0 THEN
        --OBTENER RUC
        SELECT NTDIDE INTO L_RUC FROM VTATABCLI WHERE CODCLI = C.CODCLI;
        --OBTENER CORREOS
        L_MAIL_ASES    := SGAFS_OBT_MAIL(L_RUC, 1);
        L_MAIL_SUPERVI := SGAFS_OBT_MAIL(L_RUC, 2);

        SGASI_INSERT_LOG(C.NUMERO,
                         C.CODCLI,
                         L_MAIL_ASES,
                         L_MAIL_SUPERVI,
                         L_MSJERR);
      END IF;
    END LOOP;
   COMMIT;

    OPEN PO_CURSOR FOR
      SELECT DISTINCT B.POCV_ASES_EMAIL, B.POCV_SUPERV_EMAIL
        FROM OPERACION.SGAT_PORTOUTCORPLOG B
       INNER JOIN VTATABCLI A
          ON A.CODCLI = B.POCV_CLIENTE
       WHERE B.POCN_ESTADO = 1
         AND B.POCV_ASES_EMAIL IS NOT NULL;

    PO_CODIGO_RESPUESTA  := 0;
    PO_MENSAJE_RESPUESTA := 'EXITO';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_CODIGO_RESPUESTA  := '1';
      PO_MENSAJE_RESPUESTA := 'NO SE ENCONTRO REGISTROS';

    WHEN OTHERS THEN
      ROLLBACK;
      PO_CODIGO_RESPUESTA  := -1;
      PO_MENSAJE_RESPUESTA := 'ERROR AL OBTENER ASESORES :' ||
                              TO_CHAR(SQLERRM);

  END;

  /***************************************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGASS_NO_CARTE
     PROPOSITO:  ENVIAR  DATOS PARA LOS CORREOS AL CAE Y A LOS ASESORES NO CARTERIZADOS.

     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO    ENVIAR  DATOS PARA ASESORES NO CARTERIZADOS.
  *****************************************************************************************/
   PROCEDURE SGASS_NO_CARTE(PO_CURSOR               OUT SYS_REFCURSOR,
                           PO_MAIL_CAE             OUT VARCHAR2,
                           PO_MAIL_NO_CARTERIZADOS OUT VARCHAR2,
                           PO_CODIGO_RESPUESTA     OUT INTEGER,
                           PO_MENSAJE_RESPUESTA    OUT VARCHAR2) IS

  BEGIN
    PO_MAIL_CAE             := SGAFS_OBT_MAIL('', 3);
    PO_MAIL_NO_CARTERIZADOS := SGAFS_OBT_MAIL('', 4);

    OPEN PO_CURSOR FOR
      SELECT B.POCN_NUMERO,
             OPERACION.PKG_PORTOUT_CORP.SGAFS_CID(B.POCN_NUMERO) CID,
             A.NOMCLI,
             A.NTDIDE,
             A.CODCLI
        FROM OPERACION.SGAT_PORTOUTCORPLOG B
       INNER JOIN VTATABCLI A
          ON A.CODCLI = B.POCV_CLIENTE
       WHERE B.POCN_ESTADO = 1
         AND B.POCV_ASES_EMAIL IS NULL
       ORDER BY A.CODCLI, B.POCN_NUMERO;

    PO_CODIGO_RESPUESTA  := 0;
    PO_MENSAJE_RESPUESTA := 'EXITO';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_CODIGO_RESPUESTA  := '1';
      PO_MENSAJE_RESPUESTA := 'NO SE ENCONTRO REGISTROS';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA  := '-1';
      PO_MENSAJE_RESPUESTA := 'ERROR AL OBTENER ASESORES NO CARTERIZADOS:' ||
                              TO_CHAR(SQLERRM);
  END;

  /***************************************************************************************
     NOMBRE:     OPERACION.PKG_PORTOUT_CORP.SGASS_CARTERI
     PROPOSITO:  ENVIAR  DATOS PARA LOS CORREOS DE ASESORES CARTERIZADOS

     VER        FECHA        AUTOR             DESCRIPCIÓN
  ---------  ----------  ---------------    ------------------------
     1.0        01/02/2019  CONRAD AGÜERO    ENVIAR  DATOS PARA LOS CORREOS DE ASESORES CARTERIZADOS.
  *****************************************************************************************/

  PROCEDURE SGASS_CARTERI(PI_EMAIL_CONSULTOR   IN VARCHAR2,
                          PO_CURSOR            OUT SYS_REFCURSOR,
                          PO_MAIL_CAE          OUT VARCHAR2,
                          PO_CODIGO_RESPUESTA  OUT INTEGER,
                          PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS

  BEGIN
    PO_MAIL_CAE := SGAFS_OBT_MAIL('', 3);
    OPEN PO_CURSOR FOR

      SELECT B.POCN_NUMERO,
             OPERACION.PKG_PORTOUT_CORP.SGAFS_CID(B.POCN_NUMERO) CID,
             A.NOMCLI,
             A.NTDIDE,
             A.CODCLI
        FROM OPERACION.SGAT_PORTOUTCORPLOG B
       INNER JOIN VTATABCLI A
          ON A.CODCLI = B.POCV_CLIENTE
       WHERE B.POCN_ESTADO = 1
         AND B.POCV_ASES_EMAIL = PI_EMAIL_CONSULTOR
       ORDER BY A.CODCLI, B.POCN_NUMERO;

    PO_CODIGO_RESPUESTA  := 0;
    PO_MENSAJE_RESPUESTA := 'EXITO';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      PO_CODIGO_RESPUESTA  := '1';
      PO_MENSAJE_RESPUESTA := 'NO SE ENCONTRO REGISTROS';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA  := '-1';
      PO_MENSAJE_RESPUESTA := 'ERROR AL OBTENER ASESORES NO CARTERIZADOS:' ||
                              TO_CHAR(SQLERRM);
  END;

END PKG_PORTOUT_CORP;
/