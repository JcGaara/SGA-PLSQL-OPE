CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SGA_FULLCLARO_CORP IS

PROCEDURE SGASI_ENTREGA_BONO(PI_NUMERO IN VARCHAR2,
                               PO_CODERROR OUT VARCHAR2,
                               PO_MSJERROR OUT VARCHAR2)
IS
  vCOUNT                       NUMBER;
  vCNEW                        VARCHAR2(4);
  vCOLD                        VARCHAR2(4);
  vSERVICIO                    VARCHAR2(50);
  vSEQ                         NUMBER;
  vCODSOLOT                    NUMBER;
  vCODINSSRV                   NUMBER(10);
  vESTADO                      CHAR(1);
  
BEGIN

  IF LENGTH(TRIM(PI_NUMERO)) <= 0 OR PI_NUMERO IS NULL THEN
     PO_CODERROR := '-1';
     PO_MSJERROR := 'Se debe ingresar parametro PI_NUMERO';
     RETURN;
  END IF;

  SELECT COUNT(*) INTO vCOUNT
    FROM INSSRV I WHERE I.NUMERO = PI_NUMERO AND I.ESTINSSRV IN (1,2);

  IF vCOUNT = 0 THEN
     PO_CODERROR := '-2';
     PO_MSJERROR := 'No se encontró la Linea';
     RETURN;
  ELSE
     SELECT COUNT(*) INTO vCOUNT FROM SALES.SGAT_BONOS_PROGRAMACION B 
      WHERE B.SGAV_LINEA = PI_NUMERO;
      
     IF vCOUNT > 0 THEN
        SELECT G.SGAC_ESTADO INTO vESTADO FROM SALES.SGAT_BONOS_PROGRAMACION G
        WHERE G.SGAV_LINEA = PI_NUMERO;
         
        IF vESTADO = 'A' THEN   
           PO_CODERROR := '-3';
           PO_MSJERROR := 'La linea ya cuenta con el bono activo';
           RETURN;
        ELSIF vESTADO = 'D' THEN
           PO_CODERROR := '-4';
           PO_MSJERROR := 'La linea ya esta programada para activación';
           RETURN;
        ELSE
           PO_CODERROR := '-5';
           PO_MSJERROR := 'La linea no puede activarse';
           RETURN;  
        END IF;
     END IF; 
     
     SELECT NVL(V.CODINSSRV,0) INTO vCODINSSRV
       FROM INSSRV V WHERE V.TIPSRV = '0006' AND V.ESTINSSRV =1
        AND V.NUMSLC IN (SELECT I.NUMSLC
                           FROM INSSRV I WHERE I.NUMERO = PI_NUMERO AND I.ESTINSSRV =1);
                     
     IF vCODINSSRV > 0 THEN   
        BEGIN            
          SELECT P.CODSRV INTO vCOLD
            FROM INSPRD P WHERE P.CODINSSRV = vCODINSSRV AND P.ESTINSPRD =1 AND P.FLGPRINC = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            PO_CODERROR := '-6';
            PO_MSJERROR := 'No cuenta con el producto activo';
            RETURN;
        END;
        
        BEGIN
          SELECT MAX(S.CODSOLOT) INTO vCODSOLOT FROM SOLOT S 
           WHERE S.CODSOLOT IN (SELECT CODSOLOT FROM SOLOTPTO P 
                                 WHERE P.CODINSSRV = vCODINSSRV)
             AND EXISTS (SELECT 1 FROM TIPOPEDD T, OPEDD O
                          WHERE T.TIPOPEDD = O.TIPOPEDD
                            AND T.ABREV = 'CONFSERVADICIONAL'
                            AND O.ABREVIACION = 'ESTSOL_MAXALTA'
                            AND O.CODIGON = S.ESTSOL);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            PO_CODERROR := '-7';
            PO_MSJERROR := 'No se encontrò una sot específica';
            RETURN;
        END;    
         
     ELSE
       PO_CODERROR := '-8';
       PO_MSJERROR := 'El servicio no esta activo';
       RETURN;                  
     END IF;
  END IF;
  
  IF vCODSOLOT > 0 THEN
    
    SELECT COUNT(*) INTO vCOUNT
      FROM SALES.SGAT_BONOS_CONFIGURACION 
     WHERE SGAV_CODSRV = vCOLD AND SGAN_ESTADO = 1;

    IF vCOUNT = 0 THEN
       PO_CODERROR := '-9';
       PO_MSJERROR := 'No se encontró el Bono correspondiente';
       RETURN;
    ELSE
       SELECT C.SGAV_CODSRV_BONO, C.SGAV_DES_SERV INTO vCNEW, vSERVICIO
         FROM SALES.SGAT_BONOS_CONFIGURACION C
        WHERE C.SGAV_CODSRV = vCOLD;
    END IF;

    SELECT SALES.SGASEQ_BONOS_PROGRAMACION.NEXTVAL INTO vSEQ FROM DUAL;
    
    BEGIN
      
      INSERT INTO SALES.SGAT_BONOS_PROGRAMACION
                             (SGAN_ID_PROG,
                              SGAV_LINEA,
                              SGAN_CODSOLOT,
                              SGAV_DES_SERV,
                              SGAV_CODSRV_OLD,
                              SGAV_CODSRV_NEW,
                              SGAV_TIPO_SERVICIO,
                              SGAV_TIPO_PRODUCTO,
                              SGAC_ESTADO)
                       VALUES(vSEQ,
                              PI_NUMERO,
                              vCODSOLOT,
                              vSERVICIO,
                              vCOLD,
                              vCNEW,
                              'CORE',
                              'INTERNET',
                              'D');
      COMMIT;
      
      PO_CODERROR :='0';
      PO_MSJERROR := 'OK';
      
    EXCEPTION
      WHEN OTHERS THEN
        
        PO_CODERROR := '-10';
        PO_MSJERROR := 'Error: '|| SQLERRM;
        ROLLBACK;
        
    END;
  ELSE
    PO_CODERROR := '-11';
    PO_MSJERROR := 'No se encontrò alguna SOT para esta linea'; 
  END IF;
  
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
       PO_CODERROR := sqlcode;
       PO_MSJERROR := SUBSTR('ERROR : '|| sqlerrm,1,250);
       
END;

PROCEDURE SGASI_ASIGNA_BONO_FC_CORP(CO_ACTIVADOS OUT SYS_REFCURSOR,
                                    PO_CODERROR OUT VARCHAR2, 
                                    PO_MSJERROR OUT VARCHAR2)IS
                                    
   V_AUX                             INTEGER;              
   V_COD                             INTEGER;
   V_MSJ                             VARCHAR2(100);
   V_PROCOUNT                        INTEGER;
   V_PROCESADOS                      INTEGER;
   V_COUNT                           INTEGER;
   V_WF                              NUMBER;      

   CURSOR C_PROCESA IS
     SELECT C.SGAN_ID_PROG FROM SALES.SGAT_MIGRA_UP_CORP C
      WHERE TRUNC(C.SGAD_FECMOD) = TRUNC(SYSDATE)
        AND C.SGAN_FLG_PROCESA = 1;
                                                       
   CURSOR C_PIDS IS
     SELECT SGAV_TIPO_SERVICIO, SGAV_TIPO_PRODUCTO, SGAV_SERVICIO, SGAV_CODSRV_OLD,
      SGAV_CODSRV_NEW,
           (SELECT I.PID FROM SOLOT S, TIPTRABAJO T, INSPRD I
             WHERE S.TIPTRA = T.TIPTRA
               AND T.TIPTRS = 1
               AND S.NUMSLC = I.NUMSLC
               AND T.TIPTRA IN (658, 676, 695, 814, 678, 693, 427, 412)
               AND I.ESTINSPRD IN (1, 2, 4) 
               AND I.CODEQUCOM IS NULL
               AND S.CODSOLOT = U.SGAN_CODSOLOT
               AND I.CODSRV = U.SGAV_CODSRV_OLD
               AND ROWNUM = 1) PID_OLD,
           U.ROWID ROW_ID
      FROM SALES.SGAT_MIGRA_UP_CORP U
     WHERE SGAN_FLG_PROCESA = 0
       AND SGAV_CODSRV_OLD IS NOT NULL;
                
   CURSOR C_SEQ IS
      SELECT S.ROWID ROW_ID FROM SALES.SGAT_MIGRA_UP_CORP S
       WHERE SGAN_FLG_PROCESA = 0;
       
     CURSOR C_WF IS
        SELECT S.CODSOLOT, S.COD_ID
          FROM SOLOT S
         WHERE S.CODSOLOT IN
               (SELECT DISTINCT R.SGAN_CODSOLOT_UP
                  FROM SALES.SGAT_MIGRA_UP_CORP R
                 WHERE TRUNC(FECUSU) = TRUNC(SYSDATE))
           AND S.ESTSOL = 10;
         
   CURSOR C_ENV_INC IS
      SELECT * FROM INT_TRANSACCIONESXSOLOT
       WHERE CODSOLOT IN (SELECT CODSOLOT FROM SOLOT
                           WHERE TIPTRA = 814
                             AND TRUNC(FECUSU) = TRUNC(SYSDATE))
         AND ESTADO = 0;  
         
   CURSOR C_PIDD IS
       SELECT DISTINCT T.SGAN_PID_OLD
         FROM SALES.SGAT_MIGRA_UP_CORP T
        WHERE T.SGAD_FECUSU > TRUNC(SYSDATE);   
               
  BEGIN
    
    INSERT INTO SALES.SGAT_MIGRA_UP_CORP(SGAN_ID_PROG,
                                       SGAN_CODSOLOT,
                                       SGAV_SERVICIO,
                                       SGAV_CODSRV_OLD,
                                       SGAV_CODSRV_NEW,
                                       SGAV_TIPO_SERVICIO,
                                       SGAV_TIPO_PRODUCTO,
                                       SGAV_LINEA)
          SELECT P.SGAN_ID_PROG, P.SGAN_CODSOLOT, P.SGAV_DES_SERV, P.SGAV_CODSRV_OLD, P.SGAV_CODSRV_NEW, 
                 P.SGAV_TIPO_SERVICIO, P.SGAV_TIPO_PRODUCTO,P.SGAV_LINEA 
            FROM SALES.SGAT_BONOS_PROGRAMACION P
           WHERE TRUNC(P.SGAD_FECREG) >= TRUNC(SYSDATE -1) AND P.SGAC_ESTADO = 'D' 
             AND NOT P.SGAN_ID_PROG IN (SELECT M.SGAN_ID_PROG FROM SALES.SGAT_MIGRA_UP_CORP M 
                                         WHERE M.SGAN_FLG_PROCESA = 0);
    --COMMIT;                                     
    
    SELECT COUNT(*)INTO V_COUNT FROM SALES.SGAT_MIGRA_UP_CORP M
     WHERE M.SGAN_FLG_PROCESA = 0;
     
    IF V_COUNT > 0 THEN
      
      FOR REG IN C_PIDS LOOP
          UPDATE SALES.SGAT_MIGRA_UP_CORP
             SET SGAN_PID_OLD = REG.PID_OLD
           WHERE ROWID = REG.ROW_ID;
      END LOOP;
      --COMMIT;
      
      V_AUX :=0;
      
      FOR REG IN C_SEQ LOOP
          UPDATE SALES.SGAT_MIGRA_UP_CORP
             SET SGAN_SEQ = V_AUX + 1
           WHERE ROWID = REG.ROW_ID;
           V_AUX := V_AUX + 1;
      END LOOP;
      --COMMIT;
       
      OPERACION.PKG_UPGRADE_SERV_CORP.SGASS_PROCESAR_SOT;
      
      SELECT WFDEF INTO V_WF FROM OPEWF.WFDEF 
       WHERE DESCRIPCION = 'WF DE UPGRADE SERVICIO CORPORATIVO';
      
      FOR REG IN C_WF LOOP
          PQ_SOLOT.P_ASIG_WF(REG.CODSOLOT,V_WF);
          COMMIT;
      END LOOP;
      
      OPERACION.PKG_UPGRADE_SERV_CORP.SGASI_JOB_ATIENDE_SOT_UP;
      
      FOR REG IN C_ENV_INC LOOP
        SOPFIJA.P_INT_REGXLOTE(REG.ID_LOTE, V_COD, V_MSJ);
        IF V_COD = 1 THEN
          UPDATE INT_MENSAJE_INTRAWAY
             SET ESTADO = 'PROCESO'
           WHERE ID_LOTE = REG.ID_LOTE
             AND CODSOLOT = REG.CODSOLOT;
          UPDATE INT_TRANSACCIONESXSOLOT
             SET ESTADO = 2
           WHERE ID_LOTE = REG.ID_LOTE
             AND CODSOLOT = REG.CODSOLOT;
        END IF;
        --COMMIT;
      END LOOP;
      
      OPERACION.PKG_UPGRADE_SERV_CORP.SGASI_JOB_ATIENDE_SOT_UP;
      OPERACION.PKG_UPGRADE_SERV_CORP.SGASI_JOB_ATIENDE_SOT_UP;
      
      FOR REG IN C_PIDD LOOP
        UPDATE INSPRD P
           SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
         WHERE P.PID = REG.SGAN_PID_OLD;
        --COMMIT;
      END LOOP;
      
      V_PROCESADOS :=0;
      
      FOR REG IN C_PROCESA LOOP
        
        UPDATE SALES.SGAT_BONOS_PROGRAMACION P
           SET P.SGAC_ESTADO = 'A'
         WHERE P.SGAN_ID_PROG = REG.SGAN_ID_PROG AND P.SGAC_ESTADO = 'D';
        --COMMIT;
        
        SELECT COUNT(*) INTO V_PROCOUNT FROM SALES.SGAT_BONOS_PROGRAMACION B
         WHERE B.SGAN_ID_PROG = REG.SGAN_ID_PROG AND B.SGAC_ESTADO = 'A';
         
        IF V_PROCOUNT > 0 THEN
           V_PROCESADOS := V_PROCESADOS + 1; 
        END IF;
        
      END LOOP;
      
      IF V_PROCESADOS = V_COUNT THEN
         PO_MSJERROR := 'OK, Se activaron '||TO_CHAR(V_COUNT)||' lineas.';
         PO_CODERROR := '0';
      ELSE
         PO_MSJERROR := 'Se activaron '||V_PROCESADOS||' de '||V_COUNT;
         PO_CODERROR := '1';
      END IF;
      
    ELSE
      PO_MSJERROR := 'No existen Lineas para Activar';
      PO_CODERROR := '2'; 
    END IF;
    
    COMMIT;
    
    OPEN CO_ACTIVADOS FOR
         SELECT C.SGAV_LINEA, C.SGAN_CODSOLOT,  C.SGAN_CODSOLOT_UP, C.SGAV_CODSRV_OLD, C.SGAV_CODSRV_NEW,C.SGAN_FLG_PROCESA, C.SGAD_FECUSU  
           FROM SALES.SGAT_MIGRA_UP_CORP C WHERE TRUNC(C.SGAD_FECMOD) = TRUNC(SYSDATE) AND C.SGAN_FLG_PROCESA = 1;
         
  END;

END;
/