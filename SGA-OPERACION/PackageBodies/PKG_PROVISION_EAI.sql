CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_PROVISION_EAI IS
  PROCEDURE SSGA_SOT_PROCESO(PI_CUSTOMERID NUMBER,
                             PO_CODERROR   OUT NUMBER,
                             PO_MSJERROR   OUT VARCHAR2) IS
    AV_CODCLI VTATABCLI.CODCLI%TYPE;
    AV_NUMSLC VTATABSLCFAC.NUMSLC%TYPE;
    LE_ERROR_CONF_GC_CIERRE EXCEPTION; --7.0
  BEGIN
    PO_CODERROR := 0;
    PO_MSJERROR := 'Customer no cuenta con sot en proceso';
  
    BEGIN
      SELECT C.CODCLI, max(C.NUMSLC) NUMSLC
        INTO AV_CODCLI, AV_NUMSLC
        FROM SOLOT A, SOLOTPTO B, INSSRV C
       WHERE B.CODINSSRV = C.CODINSSRV
         AND A.CODSOLOT = B.CODSOLOT
         AND A.CODCLI = C.CODCLI
         AND C.ESTINSSRV IN (1, 2)
         AND A.CUSTOMER_ID = PI_CUSTOMERID
       GROUP BY C.CODCLI;
    
      IF collections.PQ_OAC.F_OBT_TIP_TRANSACCION(7) = 1 AND
         collections.PQ_OAC.F_VAL_EXISTE_SOT_CORTE(AV_CODCLI, AV_NUMSLC, 26) > 0 THEN
        --INI 7.0
        --VALIDAR SI GRUPO DE CORTE ESTA CONFIGURADO PARA FUNCIONALIDAD
        IF collections.PQ_OAC.F_VAL_CONF_GC_X_CIERRE(26) = 1 THEN
          --Forzar cierre o anulacion de sot
          PO_CODERROR := 1;
          PO_MSJERROR := 'Customer cuenta con sot en proceso';
        
        ELSE
          -- ini 9.0
          IF collections.PQ_OAC.F_SUS_GEN_RX(26) = 1 THEN
            NULL;
          ELSE
            RAISE LE_ERROR_CONF_GC_CIERRE;
          END IF;
          -- fin 9.0
        END IF;
        --FIN 7.0
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_CODERROR := -1;
        PO_MSJERROR := 'Customer ' || PI_CUSTOMERID ||
                       ' no cuenta con servicios activos o suspendidos';
    END;
  END;

  PROCEDURE ISGA_GENERA_SOT(PI_CUSTOMERID number,
                            PO_CODERROR   OUT NUMBER,
                            PO_MSJERROR   OUT VARCHAR2,
                            PI_TIPTRS     NUMBER, --3 Suspension,4 Reconexion
                            PI_IDTRSEXT   NUMBER) is
  
    LE_ERROR_PLANTILLA_TRS    EXCEPTION;
    LE_ERROR_PLANTILLA_SOT    EXCEPTION;
    LE_ERROR_SIDS_ACTIVOS     EXCEPTION;
    LE_ERROR_CIERRE_SOT_CORTE EXCEPTION;
    LE_ERROR_SOT              EXCEPTION;
    LE_ERROR_CONF_GC_CIERRE   EXCEPTION;
    L_PAR_SOT       OPE_PLANTILLASOT%ROWTYPE;
    LOUT_CODSOLOT   SOLOT.CODSOLOT%TYPE;
    LC_MENSAJE      VARCHAR2(2000);
    LN_PUNTOS       NUMBER;
    N_IDTRSOAC      NUMBER;
    AV_CODCLI       VTATABCLI.CODCLI%TYPE;
    AV_NUMSLC       VTATABSLCFAC.NUMSLC%TYPE;
    AN_IDGRUPOCORTE NUMBER;
    AN_IDTRANCORTE  NUMBER;
    L_WFDEF         NUMBER;
  
  BEGIN
    PO_CODERROR := 0;
    PO_MSJERROR := 'Sot generado Correctamente';
    begin
      SELECT A.CODCLI, MAX(A.NUMSLC) NUMSLC, 26 IDGRUPOCORTE, 7 IDTRANCORTE
        INTO AV_CODCLI, AV_NUMSLC, AN_IDGRUPOCORTE, AN_IDTRANCORTE
        FROM SOLOT A, SOLOTPTO B, INSSRV C
       WHERE B.CODINSSRV = C.CODINSSRV
         AND A.CODSOLOT = B.CODSOLOT
         AND A.CODCLI = C.CODCLI
         AND C.ESTINSSRV IN (1, 2)
         AND A.CUSTOMER_ID = PI_CUSTOMERID
       GROUP BY A.CODCLI;
    
      SELECT OPERACION.SQ_IDTRSEAI.NEXTVAL INTO N_IDTRSOAC FROM DUMMY_OPE;
    
      INSERT INTO OPERACION.TRSRECEAI
        (IDTRSEAI,
         CODCLI,
         CUSTOMER_ID,
         NUMSLC,
         IDGRUPOCORTE,
         IDTRANCORTE,
         USUARIO,
         IDOAC,
         TIPTRS)
      VALUES
        (N_IDTRSOAC,
         AV_CODCLI,
         PI_CUSTOMERID,
         AV_NUMSLC,
         AN_IDGRUPOCORTE,
         AN_IDTRANCORTE,
         USER,
         PI_IDTRSEXT,
         PI_TIPTRS);
    
      L_PAR_SOT.TIPTRA := F_GET_TIPTRA(PI_TIPTRS);
    
      SELECT CODIGON
        INTO L_PAR_SOT.MOTOT
        FROM OPEDD A, TIPOPEDD B
       WHERE A.TIPOPEDD = B.TIPOPEDD
         AND A.ABREVIACION = 'OAC_SAC_EAI';
    
      /*********************************
      Generación de cabecera de la SOT
      **********************************/
      P_INSERT_SOT(AV_CODCLI,
                   L_PAR_SOT.TIPTRA,
                   L_PAR_SOT.TIPSRV,
                   1,
                   L_PAR_SOT.MOTOT,
                   L_PAR_SOT.AREASOL,
                   PI_CUSTOMERID,
                   N_IDTRSOAC,
                   LOUT_CODSOLOT);
      /****************************************
       Actualización de la fecha de compromiso
      *****************************************/
      UPDATE SOLOT
         SET FECCOM = SYSDATE + L_PAR_SOT.DIASFECCOM
       WHERE CODSOLOT = LOUT_CODSOLOT;
      /*********************************
       Generación de detalle de la SOT
      **********************************/
      P_INSERT_SOLOTPTO(LOUT_CODSOLOT,
                        AV_CODCLI,
                        PI_CUSTOMERID,
                        LC_MENSAJE,
                        LN_PUNTOS);
    
      /*********************************
       EJECUTAR SOLOT
      **********************************/
      L_WFDEF := CUSBRA.F_BR_SEL_WF(LOUT_CODSOLOT);
      OPERACION.PQ_SOLOT.P_ASIG_WF(LOUT_CODSOLOT, L_WFDEF);
    
      PO_MSJERROR := PO_MSJERROR || ' ' || LOUT_CODSOLOT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_MSJERROR := 'Cliente no existe o no cuenta con servicio activo' ||
                       PI_CUSTOMERID;
    END;
  END;

  PROCEDURE P_INSERT_SOT(V_CODCLI      IN SOLOT.CODCLI%TYPE,
                         V_TIPTRA      IN SOLOT.TIPTRA%TYPE,
                         V_TIPSRV      IN SOLOT.TIPSRV%TYPE,
                         V_GRADO       IN SOLOT.GRADO%TYPE,
                         V_MOTIVO      IN SOLOT.CODMOTOT%TYPE,
                         V_AREASOL     IN SOLOT.AREASOL%TYPE,
                         PI_CUSTOMERID IN SOLOT.CUSTOMER_ID%TYPE,
                         A_IDOAC       IN NUMBER,
                         A_CODSOLOT    OUT NUMBER) IS
  BEGIN
    A_CODSOLOT := F_GET_CLAVE_SOLOT();
    INSERT INTO SOLOT
      (CODSOLOT,
       CODCLI,
       ESTSOL,
       TIPTRA,
       TIPSRV,
       GRADO,
       CODMOTOT,
       AREASOL,
       Customer_Id)
    VALUES
      (A_CODSOLOT,
       V_CODCLI,
       10,
       V_TIPTRA,
       V_TIPSRV,
       V_GRADO,
       V_MOTIVO,
       V_AREASOL,
       PI_CUSTOMERID);
    G_CODSOLOT := A_CODSOLOT; --8.0
  
    UPDATE OPERACION.TRSRECEAI
       SET CODSOLOT = A_CODSOLOT
     WHERE IDTRSEAI = A_IDOAC;
  END;

  PROCEDURE P_INSERT_SOLOTPTO(AN_CODSOLOT  IN SOLOT.CODSOLOT%TYPE,
                              AV_CODCLI    IN VARCHAR2,
                              AV_CUSTMERID IN NUMBER,
                              AC_MENSAJE   OUT VARCHAR2,
                              AN_PUNTOS    OUT NUMBER) IS
    L_CONT NUMBER;
    CURSOR CUR_DETALLE_SOT IS
    --Considera todos los servicios de la factura, incluso aquellos que no han generado cargos recurrentes
      SELECT DISTINCT I.CODSRV      CODSRVNUE,
                      I.BW          BWNUE,
                      I.NUMERO,
                      I.CODINSSRV,
                      I.CID,
                      I.DESCRIPCION,
                      I.DIRECCION,
                      2             TIPO,
                      1             ESTADO,
                      1             VISIBLE,
                      I.CODUBI,
                      1             FLGMT
        FROM SOLOT A, SOLOTPTO B, INSSRV I
       WHERE B.CODINSSRV = I.CODINSSRV
         AND A.CODSOLOT = B.CODSOLOT
         AND A.CODCLI = I.CODCLI
         AND I.ESTINSSRV IN (1, 2)
         AND A.CUSTOMER_ID = AV_CUSTMERID
         AND I.CODCLI = AV_CODCLI;
  BEGIN
    L_CONT := 0;
    FOR C_DET IN CUR_DETALLE_SOT LOOP
      L_CONT := L_CONT + 1;
      INSERT INTO SOLOTPTO
        (CODSOLOT,
         PUNTO,
         CODSRVNUE,
         BWNUE,
         CODINSSRV,
         CID,
         DESCRIPCION,
         DIRECCION,
         TIPO,
         ESTADO,
         VISIBLE,
         CODUBI,
         FLGMT)
      VALUES
        (AN_CODSOLOT,
         L_CONT,
         C_DET.CODSRVNUE,
         C_DET.BWNUE,
         C_DET.CODINSSRV,
         C_DET.CID,
         C_DET.DESCRIPCION,
         C_DET.DIRECCION,
         C_DET.TIPO,
         C_DET.ESTADO,
         C_DET.VISIBLE,
         C_DET.CODUBI,
         C_DET.FLGMT);
    END LOOP;
  
    AC_MENSAJE := '';
    AN_PUNTOS  := L_CONT;
  
  EXCEPTION
    WHEN OTHERS THEN
      AC_MENSAJE := SQLERRM;
      AN_PUNTOS  := 0;
  END;
  FUNCTION F_GET_TIPTRA(LN_TIPTRS NUMBER) RETURN NUMBER IS
    LN_TIPTRA NUMBER;
  BEGIN
  
    SELECT CODIGON
      INTO LN_TIPTRA
      FROM OPEDD A, TIPOPEDD B, TIPTRABAJO C
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND A.ABREVIACION = 'PROVISION_EAI'
       AND C.TIPTRA = A.CODIGON
       AND C.TIPTRS = LN_TIPTRS;
    RETURN LN_TIPTRA;
  
  END;
END;
/