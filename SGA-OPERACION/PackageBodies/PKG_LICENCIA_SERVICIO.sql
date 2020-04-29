CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_LICENCIA_SERVICIO IS

  PROCEDURE SGASS_VALIDA_LIC_CAB(AV_NUMSLC SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                 AN_ERROR  OUT NUMBER,
                                 AV_ERROR  OUT VARCHAR2) IS
    LN_CANT_PROY NUMBER;
    LN_CANT_LIC  NUMBER;
  BEGIN
    SELECT COUNT(FAC.NUMSLC)
      INTO LN_CANT_PROY
      FROM SALES.VTATABSLCFAC FAC
     WHERE FAC.NUMSLC = AV_NUMSLC;
  
    SELECT COUNT(CAB.LCABC_NUMSLC)
      INTO LN_CANT_LIC
      FROM OPERACION.SGAT_PROCESO_LIC_CAB CAB
     WHERE CAB.LCABC_NUMSLC = AV_NUMSLC;
  
    IF LN_CANT_PROY = 0 THEN
      AN_ERROR := -1;
      AV_ERROR := 'EL PROYECTO NO EXISTE, INGRESE NUEVAMENTE';
    ELSIF LN_CANT_LIC = 0 THEN
      AN_ERROR := -2;
      AV_ERROR := 'EL PROYECTO NO TIENE ASIGNADO LICENCIA Y/O SOPORTE ';
    ELSE
      AN_ERROR := 1;
      AV_ERROR := 'OK';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      AN_ERROR := -1;
      AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;
  
  PROCEDURE SGASS_CONSULTA_FILTROS(
      AC_LCABC_NUMSLC    OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_NUMSLC%TYPE, 
      AC_LCABC_CODCLI    OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_CODCLI%TYPE,
      AN_SERLN_CID       OPERACION.SGAT_CID_SERV_LICENCIA.SERLN_CID%TYPE, 
      AI_LICDI_CODPROV   OPERACION.SGAT_PROCESO_LIC_DET.LICDI_CODPROV%TYPE, 
      AI_LICSI_TIPO      OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_TIPO%TYPE,  
      AD_LICSD_FECINICIO OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECINICIO%TYPE,  
      AD_LICSD_FECFIN    OPERACION.SGAT_PROCESO_LIC_SOP.LICSD_FECFIN%TYPE, 
      AC_CUR_LICSER      OUT SYS_REFCURSOR
  )
  IS
  LV_QUERY      VARCHAR2(4000);
  LV_WHERE      VARCHAR2(4000);
  LV_SQL        VARCHAR2(4000);
  BEGIN
     LV_WHERE :='';
     LV_QUERY :='SELECT 
                    DISTINCT
                    FAC.NUMSLC,CLI.CODCLI,CLI.NOMCLI,
                    (CASE WHEN FAC.NRO_LICITACION IS NULL THEN NULL
                         ELSE FAC.NRO_LICITACION || ''-'' || GOB.DES_CONVOCATORIA
                    END) LICDV_PROCON,
                    (CASE WHEN FAC.NRO_LICITACION IS NULL THEN ''NO''
                         ELSE ''SI''
                    END) LICDI_FLAGLIC,
                    SEL.SERLN_CID,
                    LID.LICDC_CODMODELO,
                    LID.LICDV_NUMSERIE,
                    LID.LICDI_CODPROV,
                    (SELECT C.NOMBRE
                     FROM OPERACION.CONTRATA C
                    WHERE C.CODCON = LID.LICDI_CODPROV) LICDV_NOMPROV,
                    LLS.LICSV_NOM_LICENCIA,
                    (SELECT OPK.DESCRIPCION
                       FROM OPERACION.OPEDD OPK,
                            OPERACION.TIPOPEDD TPK
                      WHERE OPK.TIPOPEDD = TPK.TIPOPEDD 
                        AND TPK.ABREV = ''ESTADO_LICENCIA_SOPORTE'' 
                        AND LLS.LICSN_ESTADOLIC = OPK.CODIGON
                    ) LICSV_EST,
                    LLS.LICSV_NUMEROOC,
                    LLS.LICSI_POSICIONOC,
                    LLS.LICSD_FECINICIO,
                    LLS.LICSD_FECFIN,
                    LLS.LICSI_PERIOREN,
                    (SELECT OPR.DESCRIPCION
                       FROM OPERACION.OPEDD OPR,
                            OPERACION.TIPOPEDD TPR 
                      WHERE OPR.TIPOPEDD = TPR.TIPOPEDD 
                        AND TPR.ABREV = ''TIPO_LICENCIA_SOPORTE''
                        AND LLS.LICSI_TIPO = OPR.CODIGON
                    ) LICSV_TIPL,
                    TO_DATE(TO_CHAR(SEL.SERLD_FECINISRV,''DD/MM/YYYY'')) SERLD_FECINISRV,
                    TO_DATE(TO_CHAR(SEL.SERLD_FECFINSRV,''DD/MM/YYYY'')) SERLD_FECFINSRV,
                    SEL.SERLI_PERRENSRV,
                    LLS.LICSV_OBSERVACION,
                    LLS.LICSV_CORREOLIC,
                    ETC.NOMECT LICDV_ASESOR,
                    BTB.NOMECT LICDV_CONSULTOR
                 FROM OPERACION.SGAT_PROCESO_LIC_CAB   CAB,
                      MARKETING.VTATABCLI              CLI,
                      SALES.VTATABSLCFAC               FAC,
                      SALES.VTATABECT                  ETC,
                      SALES.VTATABECT                  BTB,      
                      BILLCOLPER.LICITACIONGOB         GOB,
                      OPERACION.SGAT_CID_SERV_LICENCIA SEL,
                      OPERACION.SGAT_PROCESO_LIC_DET   LID,      
                      OPERACION.SGAT_PROCESO_LIC_SOP   LLS           
                WHERE CAB.LCABC_CODCLI = CLI.CODCLI
                  AND CLI.CODCLI = FAC.CODCLI
                  AND CLI.CODECT = ETC.CODECT(+)
                  AND CLI.CODSOCIO = BTB.CODECT(+)
                  AND FAC.NUMSLC = CAB.LCABC_NUMSLC
                  AND FAC.CODCLI = CAB.LCABC_CODCLI
                  AND FAC.NRO_LICITACION = GOB.NRO_LICITACION(+)
                  AND SEL.SERLC_NUMSLC(+) = CAB.LCABC_NUMSLC
                  AND LID.LICDC_NUMSLC(+) = SEL.SERLC_NUMSLC
                  AND LID.LICDN_CID(+) = SEL.SERLN_CID
                  AND LLS.LICSI_SECUENCIA(+) = LID.LICDI_SECUENCIA';
                    
      IF ((RTRIM(AC_LCABC_NUMSLC) IS NOT NULL) OR (RTRIM(AC_LCABC_NUMSLC)<>'')) THEN
        LV_WHERE := LV_WHERE || ' AND CAB.LCABC_NUMSLC=''' || RTRIM(AC_LCABC_NUMSLC) || '''';
      END IF;
      
      IF ((RTRIM(AC_LCABC_CODCLI) IS NOT NULL) OR (RTRIM(AC_LCABC_CODCLI)<>'')) THEN
        LV_WHERE := LV_WHERE || ' AND CAB.LCABC_CODCLI=''' || RTRIM(AC_LCABC_CODCLI) || '''';
      END IF;
      
      IF ((RTRIM(AN_SERLN_CID) IS NOT NULL) OR (RTRIM(AN_SERLN_CID)<>'')) THEN
        LV_WHERE := LV_WHERE || ' AND SEL.SERLN_CID=''' || RTRIM(AN_SERLN_CID) || '''';
      END IF;
      
      IF ((RTRIM(AI_LICDI_CODPROV) IS NOT NULL) OR (RTRIM(AI_LICDI_CODPROV)<>'')) THEN
        LV_WHERE := LV_WHERE || ' AND LID.LICDI_CODPROV=''' || RTRIM(AI_LICDI_CODPROV) || '''';
      END IF;      
      
      IF ((RTRIM(AI_LICSI_TIPO) IS NOT NULL) OR (RTRIM(AI_LICSI_TIPO)<>'')) THEN
        IF(RTRIM(AI_LICSI_TIPO) = '9') THEN
            LV_WHERE := LV_WHERE || ' AND LLS.LICSI_TIPO IN (SELECT P.CODIGON FROM OPERACION.OPEDD P,TIPOPEDD T WHERE T.TIPOPEDD = P.TIPOPEDD AND T.ABREV=''TIPO_LICENCIA_SOPORTE'')';
            
          ELSE
            LV_WHERE := LV_WHERE || ' AND LLS.LICSI_TIPO=''' || RTRIM(AI_LICSI_TIPO) || '''';            
        END IF;
        
      END IF;  
      
      IF AD_LICSD_FECINICIO IS NOT NULL THEN
         LV_WHERE := LV_WHERE || ' AND LLS.LICSD_FECINICIO >=  TO_DATE(' || CHR(39) || TO_CHAR(AD_LICSD_FECINICIO,'DD/MM/YYYY') || CHR(39) || ', ' || CHR(39) || 'DD/MM/YYYY' || CHR(39) || ') AND  LLS.LICSD_FECFIN <= TO_DATE(' || CHR(39) || TO_CHAR(AD_LICSD_FECFIN,'DD/MM/YYYY') || CHR(39) || ', ' || CHR(39) || 'DD/MM/YYYY' || CHR(39) || ')';
      END IF;   
      
      IF RTRIM(LV_WHERE) IS NOT NULL THEN
        LV_SQL := LV_QUERY || CHR(13) || LV_WHERE;
      ELSE
        LV_SQL := LV_QUERY;
      END IF; 
      
   OPEN AC_CUR_LICSER FOR LV_SQL;
   
  END;
  
  PROCEDURE SGASS_OBTENER_FECHAS(ADT_FECHA_INI OUT DATE,
                                 ADT_FECHA_FIN OUT DATE) IS
  BEGIN
    SELECT TRUNC(SYSDATE, 'MM') PRIMER_DIA_DEL_MES,
           TRUNC(LAST_DAY(SYSDATE)) ULTIMO_DIA_DEL_MES
      INTO ADT_FECHA_INI, ADT_FECHA_FIN
      FROM DUAL;
  END;
  
  PROCEDURE SGASS_VALIDA_SOT (AN_SOLOT  OPERACION.SOLOT.CODSOLOT%TYPE,
                              AN_CID    OPERACION.SOLOTPTO.CID%TYPE,
                              AN_ERROR  OUT NUMBER,
                              AV_ERROR  OUT VARCHAR2) IS
    AN_CANT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO AN_CANT
      FROM SOLOTPTO PTO
     WHERE PTO.CODSOLOT = AN_SOLOT
       AND PTO.CID = AN_CID;
    
    IF AN_CANT > 0 THEN 
       AN_ERROR := 1;
       AV_ERROR := 'OK';
    ELSE
       AN_ERROR := -1;
       AV_ERROR := 'LA SOT REGISTRADA, NO ESTA ASOCIADA A LA CID ('||AN_CID||')';
    END IF;
    EXCEPTION
      WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;
  
  PROCEDURE SGASS_VALIDA_CID_SOT (AV_NUMSLC OPERACION.SOLOT.NUMSLC%TYPE,
                                  AN_CID    OPERACION.SOLOTPTO.CID%TYPE,
                                  AN_SOLOT  OPERACION.SOLOT.CODSOLOT%TYPE,
                                  AN_ERROR  OUT NUMBER,
                                  AV_ERROR  OUT VARCHAR2) IS
    AN_CANT        NUMBER; 
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := '';
    IF AN_SOLOT IS NULL THEN
       SELECT COUNT(1)
        INTO AN_CANT
        FROM OPERACION.SGAT_CID_SERV_LICENCIA LIC
       WHERE LIC.SERLC_NUMSLC = AV_NUMSLC
         AND LIC.SERLN_CODSOLOT IS NULL
         AND LIC.SERLN_CID = AN_CID;
    ELSE 
      SELECT COUNT(1)
        INTO AN_CANT
        FROM OPERACION.SGAT_CID_SERV_LICENCIA LIC
       WHERE LIC.SERLC_NUMSLC = AV_NUMSLC
         AND LIC.SERLN_CODSOLOT = AN_SOLOT
         AND LIC.SERLN_CID = AN_CID;
    END IF;
    
    IF AN_CANT > 0 THEN 
       AN_ERROR := 2;
       IF AN_SOLOT IS NULL THEN
         AV_ERROR := 'EL CID INGRESADO YA SE ENCUENTRA REGISTRADO EN EL PROYECTO ('||AV_NUMSLC||'), VERIFICAR EL CID INGRESADO';
       ELSE
         AV_ERROR := 'EL CID Y LA SOT INGRESADO YA SE ENCUENTRAN REGISTRADOS EN EL PROYECTO ('||AV_NUMSLC||'), VERIFICAR EL CID Y LA SAT INGRESADO';
       END IF;
    ELSE
       SGASS_VALIDA_CID (AV_NUMSLC,AN_CID,AN_ERROR, AV_ERROR);
       IF AN_ERROR = -1 THEN
          RETURN;
       END IF;
       
       IF AN_SOLOT IS NOT NULL THEN
          SGASS_VALIDA_SOT(AN_SOLOT ,AN_CID ,AN_ERROR , AV_ERROR);
          IF AN_ERROR = -1 THEN
             RETURN;
          END IF;  
       END IF;       
    END IF;
    EXCEPTION
      WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;
  
  PROCEDURE SGASS_CONSULTA_PROY(AV_NUMSLC                 OPERACION.SOLOT.NUMSLC%TYPE,
                                AV_CODCLI             OUT OPERACION.SOLOT.CODCLI%TYPE,
                                AV_NOMCLI             OUT MARKETING.VTATABCLI.NOMCLI%TYPE,
                                AV_PROCESO_CONTRATO   OUT VARCHAR2,
                                AV_FLAG_LICITACION    OUT VARCHAR2,
                                AV_GESTOR             OUT VARCHAR2,
                                AV_ASESOR             OUT VARCHAR2) IS
  BEGIN
    SELECT CLI.CODCLI,
           CLI.NOMCLI,
           CASE
             WHEN FAC.NRO_LICITACION IS NULL THEN
              NULL
             ELSE
              FAC.NRO_LICITACION || '-' || GOB.DES_CONVOCATORIA
           END AS PROCESO_CONTRATO,
           CASE
             WHEN FAC.NRO_LICITACION IS NULL THEN
              'NO'
             ELSE
              'SI'
           END AS FLAG_LICITACION,
           E.NOMECT AS GESTOR,
           B.NOMECT AS ASESOR
      INTO AV_CODCLI,
           AV_NOMCLI,
           AV_PROCESO_CONTRATO,
           AV_FLAG_LICITACION ,
           AV_GESTOR ,
           AV_ASESOR    
      FROM SALES.VTATABSLCFAC FAC
     INNER JOIN MARKETING.VTATABCLI CLI
        ON FAC.CODCLI = CLI.CODCLI
      LEFT JOIN BILLCOLPER.LICITACIONGOB GOB
        ON FAC.NRO_LICITACION = GOB.NRO_LICITACION
      LEFT JOIN SALES.VTATABECT E
        ON CLI.CODECT = E.CODECT
      LEFT JOIN SALES.VTATABECT B
        ON CLI.CODSOCIO = B.CODECT
     WHERE FAC.NUMSLC = AV_NUMSLC
     GROUP BY CLI.CODCLI,
              CLI.NOMCLI,
              FAC.NRO_LICITACION,
              GOB.DES_CONVOCATORIA,
              B.NOMECT,
              E.NOMECT;
  END;

  PROCEDURE SGASS_VALIDA_CID (AV_NUMSLC SALES.VTATABSLCFAC.NUMSLC%TYPE,
                              AN_CID    OPERACION.INSSRV.CID%TYPE,
                              AN_ERROR  OUT NUMBER,
                              AV_ERROR  OUT VARCHAR2) IS
    AN_LOG_CID NUMBER;
  BEGIN
    SELECT 1
      INTO AN_LOG_CID
      FROM OPERACION.INSSRV I
     WHERE I.NUMSLC = AV_NUMSLC
       AND I.CID = AN_CID
       AND I.ESTINSSRV <> 3;
       
    AN_ERROR := 1;
    AV_ERROR := 'OK';  
     
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           BEGIN  
              SELECT 1
                INTO AN_LOG_CID
                FROM operacion.inssrv ins
               WHERE EXISTS
                     (SELECT 1
                        FROM operacion.solotpto pto, operacion.solot sol
                       WHERE ins.codinssrv = pto.codinssrv
                         AND pto.codsolot = sol.codsolot
                         AND sol.numslc = AV_NUMSLC)
                 AND ins.cid = AN_CID;

              AN_ERROR := 1;
              AV_ERROR := 'OK';
           EXCEPTION
              WHEN NO_DATA_FOUND THEN      
                   AN_ERROR := -1;
                   AV_ERROR := 'LA CID NO ESTA RELACIONADA AL PROYECTO ('||AV_NUMSLC||'), O FUE DADO DE BAJA';
			  WHEN OTHERS THEN
				   AN_ERROR := -1;
				   AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
           END;
      WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;

  PROCEDURE SGASS_OBTIENE_FECFIN (ADT_FECHA_INI     DATE,
                                  AN_PERIODO        NUMBER,
                                  ADT_FECHA_FIN OUT DATE,
                                  AN_ERROR      OUT NUMBER,
                                  AV_ERROR      OUT VARCHAR2) IS
  AN_TIPO NUMBER;
  BEGIN
     BEGIN 
       SELECT O.CODIGON_AUX
         INTO AN_TIPO
         FROM TIPOPEDD T, OPEDD O
        WHERE T.TIPOPEDD = O.TIPOPEDD
          AND T.ABREV = 'LICITACION_FECH_FIN'
          AND O.CODIGON = 1;
     EXCEPTION 
       WHEN NO_DATA_FOUND THEN
            AN_ERROR := -1;
            AV_ERROR := 'NO SE REALIZO LA CONFIGURACIÓN DEL PERIODO DE FECHA';
            RETURN;
       WHEN TOO_MANY_ROWS THEN
            AN_ERROR := -1;
            AV_ERROR := 'SE DEBE CONFIGURAR UN SOLO TIPO DE PERIODO DE FECHA';
            RETURN;
       WHEN OTHERS THEN
            AN_ERROR := -1;
            AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
            RETURN;
     END;
     
     IF  AN_TIPO = 2 THEN 
        ADT_FECHA_FIN := TRUNC(ADT_FECHA_INI) + AN_PERIODO;
     ELSE
        ADT_FECHA_FIN := ADD_MONTHS(TRUNC(ADT_FECHA_INI), AN_PERIODO);
     END IF;
     
     AN_ERROR := 1;
     AV_ERROR := 'OK';
     ADT_FECHA_FIN := TRUNC(ADT_FECHA_FIN);
   EXCEPTION
     WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;
  
  PROCEDURE SGASS_OBTIENE_UBICACION (AV_NUMSLC       SALES.VTATABSLCFAC.NUMSLC%TYPE,
                                     AN_CID           OPERACION.INSSRV.CID%TYPE,
                                     AV_CODEST     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODEST%TYPE,
                                     AV_CODPVC     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODPVC%TYPE,
                                     AV_CODUBI     OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODDST%TYPE,
                                     AV_DIRECCION  OUT OPERACION.SGAT_PROCESO_LIC_DET.LICDV_DIRECCION%TYPE,
                                     AN_ERROR      OUT NUMBER,
                                     AV_ERROR      OUT VARCHAR2) IS
  AN_TIPO NUMBER;
  BEGIN 
   SELECT D.CODUBI, D.CODEST, D.CODPVC, V.DIRSUC
     INTO AV_CODUBI, AV_CODEST, AV_CODPVC, AV_DIRECCION
     FROM MARKETING.VTASUCCLI V
    INNER JOIN MARKETING.VTATABDST D
       ON V.UBISUC = D.CODUBI
    INNER JOIN OPERACION.INT_PRYOPE IP
       ON V.CODSUC = IP.CODSUC
    WHERE IP.NUMSLC = AV_NUMSLC
      AND IP.IDSEQ = (SELECT MAX(AP.IDSEQ)
                        FROM OPERACION.INT_PRYOPE AP
                       INNER JOIN OPERACION.SOLOTPTO PTO
                          ON AP.CODSOLOT = PTO.CODSOLOT
                       WHERE AP.NUMSLC = IP.NUMSLC
                         AND PTO.CID = AN_CID
                       GROUP BY PTO.CID);
     AN_ERROR := 1;
     AV_ERROR := 'OK';
     AV_CODUBI := TRIM(AV_CODUBI);
     AV_CODEST := TRIM(AV_CODEST);
     AV_CODPVC := TRIM(AV_CODPVC);
     AV_DIRECCION := TRIM(AV_DIRECCION);
     
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
            AN_ERROR := -1;
            AV_ERROR := 'CID NO TIENE DIRECCIÓN DE INSTALACION. CONSULTAR CON EL ÁREA DE PROVISIÓN';
     WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;  

  PROCEDURE SGASS_OBTIENE_PROV (AN_CODCON        OPERACION.CONTRATA.CODCON%TYPE,
                                AV_PROVEEDOR OUT OPERACION.CONTRATA.NOMBRE%TYPE,
                                AN_ERROR     OUT NUMBER,
                                AV_ERROR     OUT VARCHAR2) IS                          
  BEGIN
   SELECT C.NOMBRE
     INTO AV_PROVEEDOR
     FROM OPERACION.CONTRATA C
    WHERE C.CODCON = AN_CODCON;
       
    AN_ERROR := 1;
    AV_ERROR := 'OK';  
     
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
            AN_ERROR := -1;
            AV_ERROR := 'EL PROVEEDOR INGRESADO NO EXISTE';
     WHEN OTHERS THEN
        AN_ERROR := -1;
        AV_ERROR := SUBSTR('ERROR : ' || SQLERRM, 1, 250);
  END;
  
  PROCEDURE SGASP_GRABAR_TRAZA_LICITACION(AV_NRO_LICITACION     BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_NRO_LICITACION%TYPE,
                                          AC_CODCLI             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISC_CODCLI%TYPE,
                                          AV_DETALLE_CAMBIO_OLD BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_DETALLE_CAMBIO_OLD%TYPE,
                                          AC_NUMSLC             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISC_NUMSLC%TYPE,
                                          AV_TIPO_REGISTRO      BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_TIPO_REGISTRO%TYPE,
                                          AV_CONCEPTO_CAMBIO    BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_CONCEPTO_CAMBIO%TYPE,
                                          AV_DETALLE_CAMBIO_NEW BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_DETALLE_CAMBIO_NEW%TYPE,
                                          AD_FECUSU             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISD_FECUSU%TYPE,
                                          AV_CODUSU             BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISV_CODUSU%TYPE,
                                          AN_ERROR              OUT NUMBER,
                                          AV_ERROR              OUT VARCHAR2) IS
  
    LN_LHISN_ID_HIS BILLCOLPER.SGAT_LICITACIONGOB_HIS.LHISN_ID_HIS%TYPE;
    LN_ERROR        NUMBER;
    LV_ERROR        VARCHAR2(4000);
  BEGIN
    SELECT BILLCOLPER.SGASEQ_LICITACIONGOB_HIS.NEXTVAL
      INTO LN_LHISN_ID_HIS
      FROM DUAL;
  
    LN_ERROR := 0;
    LV_ERROR := 'OK';
  
    INSERT INTO BILLCOLPER.SGAT_LICITACIONGOB_HIS
      (LHISN_ID_HIS,
       LHISV_NRO_LICITACION,
       LHISC_CODCLI,
       LHISV_DETALLE_CAMBIO_OLD,
       LHISC_NUMSLC,
       LHISV_TIPO_REGISTRO,
       LHISV_CONCEPTO_CAMBIO,
       LHISV_DETALLE_CAMBIO_NEW,
       LHISD_FECUSU,
       LHISV_CODUSU)
    VALUES
      (LN_LHISN_ID_HIS,
       AV_NRO_LICITACION,
       AC_CODCLI,
       AV_DETALLE_CAMBIO_OLD,
       AC_NUMSLC,
       AV_TIPO_REGISTRO,
       AV_CONCEPTO_CAMBIO,
       AV_DETALLE_CAMBIO_NEW,
       AD_FECUSU,
       AV_CODUSU);
  
    AN_ERROR := LN_ERROR;
    AV_ERROR := LV_ERROR;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASP_GRABAR_TRAZA_LICITACION : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;
  END;
 
  PROCEDURE SGASS_OBTIENE_FORMATO_CORREO(AN_TIPOMSJ    IN NUMBER,
                                         AC_CUR_FORCOR OUT SYS_REFCURSOR,
                                         AN_ERROR      OUT NUMBER,
                                         AV_ERROR      OUT VARCHAR2)
  IS
   LN_ERROR        NUMBER;
   LV_ERROR        VARCHAR2(4000);
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';
    OPEN AC_CUR_FORCOR FOR
      SELECT 
          PEMN_IDMSJ,
          PEMV_ASUNTO,
          PEMV_CUERPO,
          PEMV_FROM,
          PEMN_INTENTO
      FROM OPERACION.SGAT_PROCESO_ENVIO_MAIL
      WHERE PEMN_IDMSJ = AN_TIPOMSJ
        AND PEMN_ESTMSJ = 1;  
  EXCEPTION
    WHEN OTHERS THEN      
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASS_OBTIENE_FORMATO_CORREO : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;
  END;
  
  PROCEDURE SGASS_OBTIENE_CORREOS_CLIENTE(AC_CODCLI     IN MARKETING.VTATABCLI.CODCLI%TYPE,
                                          AV_EMAIL      OUT VARCHAR2,                                                                                               
                                          AN_ERROR      OUT NUMBER,
                                          AV_ERROR      OUT VARCHAR2)
  IS
   LN_ERROR        NUMBER;
   LV_ERROR        VARCHAR2(4000);
  BEGIN
   AN_ERROR := 0;
   AV_ERROR := 'OK';
    SELECT CORP.ASEDV_ASES_EMAIL || ';' || CORP.ASEDV_SUPERV_EMAIL  || ';' || CORP.ASEDV_JEF_EMAIL
       INTO AV_EMAIL
    FROM MARKETING.VTATABCLI CLI,
         MARKETING.SGAT_ASESOR_CORP_DET CORP
    WHERE CLI.NTDIDE = CORP.ASEDV_CLIENTE_RUC
      AND CLI.CODCLI = AC_CODCLI
      AND CLI.tipdide = '001'
    GROUP BY CORP.ASEDV_CLIENTE_RUC, 
             CLI.CODCLI, 
             CORP.ASEDV_ASES_EMAIL,       
             CORP.ASEDV_ASES_EMAIL,
             CORP.ASEDV_SUPERV_EMAIL,
             CORP.ASEDV_JEF_EMAIL;
  EXCEPTION
    WHEN OTHERS THEN      
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASS_OBTIENE_CORREOS_CLIENTE : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;             
  END;  

  PROCEDURE SGASS_OBTIENE_CORREOS_LICENCIA(AI_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,
                                           AV_Cc    OUT VARCHAR2,                                                      
                                           AN_ERROR OUT NUMBER,
                                           AV_ERROR OUT VARCHAR2)
  IS
  CURSOR C_CUR_CC(LI_ID_LIC NUMBER) IS
    SELECT
      LICSI_ID_LIC,
      LICSV_CORREOLIC
    FROM OPERACION.SGAT_PROCESO_LIC_SOP_MAIL LSM
    WHERE LICSI_ID_LIC = LI_ID_LIC
      AND LICSN_ESTADOLIC = 1;
   LN_ERROR        NUMBER;
   LV_ERROR        VARCHAR2(4000);
   LV_EMAIL_CC     VARCHAR2(600);
   REGISTROS       C_CUR_CC%ROWTYPE;
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';
    OPEN C_CUR_CC(AI_ID_LIC);
    LOOP
        FETCH C_CUR_CC INTO REGISTROS;
        EXIT WHEN C_CUR_CC%NOTFOUND;
        /* Procesamiento de los registros recuperados */
        LV_EMAIL_CC := LV_EMAIL_CC || REGISTROS.LICSV_CORREOLIC || ';';
    END LOOP;
    CLOSE C_CUR_CC;
    AV_Cc := LV_EMAIL_CC;
  EXCEPTION
    WHEN OTHERS THEN
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASS_OBTIENE_CORREOS_LICENCIA : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;      
  END;

  PROCEDURE SGASP_VALIDA_VEN_LIC_SOP(AN_TOTAL OUT NUMBER,
                                     AN_ERROR OUT NUMBER,
                                     AV_ERROR OUT VARCHAR2) IS
  
   CURSOR CUR_LICENCIA IS
    SELECT
            LDET.LICSI_ID_LIC,
            LDET.LICSI_SECUENCIA,
            LDET.LICSV_NOM_LICENCIA,
            LDET.LICSV_CORREOLIC,
            LDET.LICSI_CODPROV,
            LDET.LICSD_FECINICIO,
            LDET.LICSD_FECFIN,
            LDET.LICSD_FECACTUAL,
            LDET.LICSI_TIPO,
            LDET.LICSI_DIAS,
            LDET.LICSN_ESTADOLIC,
            (LDET.LICSD_FECFIN - LDET.LICSI_DIAS) FECHA_ALERTA
        FROM 
           (SELECT 
                LSOP.LICSI_ID_LIC,
                LSOP.LICSI_SECUENCIA,
                LSOP.LICSV_NOM_LICENCIA,
                LSOP.LICSV_CORREOLIC,
                LSOP.LICSI_CODPROV, 
                LSOP.LICSD_FECINICIO,
                LSOP.LICSD_FECFIN,
                TRUNC(SYSDATE) LICSD_FECACTUAL,
                LSOP.LICSI_TIPO,
                TRUNC(LSOP.LICSD_FECFIN - SYSDATE) LICSI_DIAS,
                LSOP.LICSN_ESTADOLIC
            FROM OPERACION.SGAT_PROCESO_LIC_SOP LSOP
            WHERE LSOP.LICSN_ESTADOLIC NOT IN (4 /*0-DE BAJA*/, 1 /*1-VENCIDO*/)
              AND LSOP.LICSI_ID_LIC in (61,62,63,181,302,303,601,621,641,642,643,661,662,663)
            ORDER BY LSOP.LICSI_TIPO, LSOP.LICSD_FECFIN DESC) LDET
            WHERE LDET.LICSI_DIAS IN (SELECT P.CODIGON
                                      FROM OPERACION.OPEDD P, OPERACION.TIPOPEDD O
                                      WHERE P.TIPOPEDD = O.TIPOPEDD
                                        AND O.ABREV = 'TIPO_ANTICIPACION_ALERTAS');
    LN_ERROR        NUMBER;
    LV_ERROR        VARCHAR2(4000);
    LN_NOTIF       NUMBER;
    LN_NOTSIG      NUMBER;
    LN_DIAS        NUMBER;
    LN_DIF_ALERTA  NUMBER;
    LN_DIF_VENCIDO NUMBER;    
    LV_NTDIDE      VTATABCLI.NTDIDE%TYPE;
    LN_CLINN_ID    NUMBER;  
    LN_CLINN_IDMSJ OPERACION.SGAT_NOTIFICACION_CLIENTE.CLINN_IDMSJ%TYPE; 
    LN_CLIND_FECENVIO DATE;
    LC_NUMSLC      CHAR(10);
    LN_CID         CHAR(10);
    LN_CODSOLOT    NUMBER(8);
    LN_CODCLI      CHAR(8);
    LN_IDSEC       NUMBER;
    LV_FECHA       CHAR(8);
  BEGIN
    AN_TOTAL := 0;
    FOR R IN CUR_LICENCIA LOOP
        --OBTENEMOS EL CODIGO DEL MENSAJE A ENVIARSE.
        BEGIN
          SELECT PEML.PEMN_IDMSJ INTO LN_CLINN_IDMSJ
          FROM OPERACION.SGAT_PROCESO_ENVIO_MAIL PEML
          WHERE PEML.PEMN_ESTMSJ = 1;
          
         EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LN_CLINN_IDMSJ := -1;                          
        END;
        
        --OBTENEMOS LA PERIORICIDAD DE LA ALERTA
        SELECT P.CODIGON,P.CODIGON_AUX INTO LN_NOTIF, LN_NOTSIG
        FROM OPERACION.OPEDD P, OPERACION.TIPOPEDD O
        WHERE P.TIPOPEDD = O.TIPOPEDD
          AND O.ABREV = 'TIPO_ANTICIPACION_ALERTAS'
          AND P.CODIGON = R.LICSI_DIAS;

        --OBTENER DETALLE 
        SELECT D.LICDC_NUMSLC,D.LICDN_CID INTO LC_NUMSLC, LN_CID
       FROM OPERACION.SGAT_PROCESO_LIC_DET D
        WHERE D.LICDI_SECUENCIA = R.LICSI_SECUENCIA;

        --OBTENER CLIENTE   
        SELECT S.LCABC_CODCLI INTO LN_CODCLI
        FROM OPERACION.SGAT_PROCESO_LIC_CAB S 
        WHERE S.LCABC_NUMSLC = LC_NUMSLC ;
        
        --OBTENEMOS RUC
        BEGIN
          SELECT I.NTDIDE
            INTO LV_NTDIDE
            FROM VTATABCLI I
           WHERE I.CODCLI = LN_CODCLI
             AND I.TIPDIDE = '001';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            LV_NTDIDE := NULL;
        END;
        --CANTIDAD A REGISTRAR EN LA NOTIFICACIÓN
        LN_DIAS := (TRUNC(LN_NOTIF/LN_NOTSIG)) + 1;
        IF(LV_NTDIDE IS NOT NULL) THEN
             FOR X IN  1 .. LN_DIAS LOOP
                BEGIN
                  IF X = LN_DIAS THEN
                       LV_FECHA:=TO_CHAR(SYSDATE,'YYYYMMDD');
                   ELSE
                       LN_CLIND_FECENVIO := R.FECHA_ALERTA + LN_NOTSIG;
                       R.FECHA_ALERTA:=LN_CLIND_FECENVIO;  
                       LV_FECHA:=TO_CHAR(LN_CLIND_FECENVIO,'YYYYMMDD');
                 END IF;
                 SELECT 
                    COUNT(NC.CLINN_ID) INTO LN_CLINN_ID
                 FROM OPERACION.SGAT_NOTIFICACION_CLIENTE NC
                 WHERE NC.CLINC_NUMSLC = LC_NUMSLC
                   AND NC.CLINN_CID  = LN_CID
                   --AND (NC.CLINN_CODSOLOT = R.SERLN_CODSOLOT OR NC.CLINN_CODSOLOT IS NULL)
                   AND NC.CLINV_RUC  = LV_NTDIDE
                   AND NC.CLINC_CODCLI  = LN_CODCLI
                   AND NC.CLINI_ID_LIC  = R.LICSI_ID_LIC
                   AND NC.CLINI_SECUENCIA  = R.LICSI_SECUENCIA
                   AND NC.CLIND_FECENVIO = LV_FECHA;  
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      LN_CLINN_ID := 0;
                 END;
                 DBMS_OUTPUT.PUT_LINE('ID:=' || LN_CLINN_ID);
                 IF LN_CLINN_ID = 0 THEN
                     AN_TOTAL := AN_TOTAL +1;
                     --REGISTRO DE LA NOTIFICACION
                     INSERT INTO OPERACION.SGAT_NOTIFICACION_CLIENTE
                     (  
                        CLINC_NUMSLC,CLINN_CID,CLINN_CODSOLOT,CLINV_RUC,
                        CLINC_CODCLI,CLINN_IDMSJ,CLINI_ID_LIC,CLINI_SECUENCIA,
                        CLINI_TIPSRV,CLIND_FECINICIO,CLIND_FECFIN,CLIND_FECENVIO,CLINI_CANTNOTIF
                     )
                     VALUES
                     (
                        LC_NUMSLC,
                        LN_CID,
                        NULL,
                        LV_NTDIDE,
                        LN_CODCLI,
                        LN_CLINN_IDMSJ,
                        R.LICSI_ID_LIC,
                        R.LICSI_SECUENCIA,
                        R.LICSI_TIPO,
                        R.LICSD_FECINICIO,
                        R.LICSD_FECFIN,
                        LV_FECHA,
                        TRUNC(LN_CLIND_FECENVIO - SYSDATE)        
                      );   
                      --Actualizamos la licencia o soporte a estado de "ALERTA"
                      UPDATE OPERACION.SGAT_PROCESO_LIC_SOP
                      SET LICSN_ESTADOLIC = 2
                      WHERE LICSI_ID_LIC = R.LICSI_ID_LIC;                               
                  END IF;      
              END LOOP;
        END IF;
    END LOOP;
    COMMIT;
    AN_ERROR := 1;
    AV_ERROR := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASP_VALIDA_VEN_LIC_SOP : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;
  END;

  PROCEDURE SGASS_OBTENER_NOTIFICACIONES(AC_CUR_NOTIF OUT SYS_REFCURSOR,
                                         AN_ERROR      OUT NUMBER,
                                         AV_ERROR      OUT VARCHAR2)
  IS 
   LN_ERROR        NUMBER;
   LV_ERROR        VARCHAR2(4000);
   LC_FECHA        CHAR(8);  
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';
    LC_FECHA := TO_CHAR(SYSDATE,'YYYYMMDD');
    OPEN AC_CUR_NOTIF FOR
      SELECT 
        NC.CLINN_ID,
        NC.CLINC_NUMSLC,
        NC.CLINN_CID,
        NC.CLINN_CODSOLOT,
        NC.CLINV_RUC,
        NC.CLINC_CODCLI,
        NC.CLINN_IDMSJ,
        NC.CLINI_ID_LIC,
        NC.CLINI_SECUENCIA,
        NC.CLINI_TIPSRV,
        NC.CLIND_FECINICIO,
        NC.CLIND_FECFIN,
        NC.CLINI_CANTNOTIF
       FROM OPERACION.SGAT_NOTIFICACION_CLIENTE NC
       WHERE NC.CLIND_FECENVIO = LC_FECHA
        AND NC.CLINI_ESTADO = 0
       ORDER BY NC.CLINN_IDMSJ DESC;
  EXCEPTION
    WHEN OTHERS THEN      
      LN_ERROR := -1;
      LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASS_OBTENER_NOTIFICACIONES : ' ||
                  SQLERRM;
      AN_ERROR := LN_ERROR;
      AV_ERROR := LV_ERROR;       
  END;

  PROCEDURE SGASP_GRABAR_NOTIFICACION_LOG(AN_CLINN_ID OPERACION.SGAT_NOTIFICACION_CLIENTE.CLINN_ID%TYPE,
                                          AN_CLINI_ID_LIC OPERACION.SGAT_NOTIFICACION_CLIENTE.CLINI_ID_LIC%TYPE,                                                        
                                          AN_ERROR      OUT NUMBER,
                                          AV_ERROR      OUT VARCHAR2)
  IS
     LN_ERROR        NUMBER;
     LV_ERROR        VARCHAR2(4000);
     LN_CLINN_ID     NUMBER;
     LN_TOT_CLINN    NUMBER;
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';
    
    --Evaluamos que exista la notificación realizada al cliente.
    BEGIN
      SELECT NC.CLINN_ID INTO LN_CLINN_ID
      FROM OPERACION.SGAT_NOTIFICACION_CLIENTE NC
      WHERE NC.CLINN_ID = AN_CLINN_ID;
     EXCEPTION
      WHEN NO_DATA_FOUND then
        LN_CLINN_ID := NULL;
    END;

    IF ((LN_CLINN_ID IS NOT NULL) OR (LN_CLINN_ID > 0)) THEN
     BEGIN
          AN_ERROR := 1;
          AV_ERROR := 'OK';
          SELECT COUNT(NC.CLINN_ID) INTO LN_TOT_CLINN
          FROM OPERACION.SGAT_NOTIFICACION_CLIENTE NC
          WHERE NC.CLINI_ID_LIC = AN_CLINI_ID_LIC
            AND NC.CLINI_ESTADO=0;
              
          IF LN_TOT_CLINN = 0 THEN
            --Actualizar la licencia o soporte a estado de Vencido.
            UPDATE OPERACION.SGAT_PROCESO_LIC_SOP LSOP
            SET LSOP.LICSN_ESTADOLIC=1
            WHERE LSOP.LICSI_ID_LIC=AN_CLINI_ID_LIC;
          END IF;
         --Actualizar el registro del cliente.
         UPDATE OPERACION.SGAT_NOTIFICACION_CLIENTE NC SET CLINI_ESTADO = 1 WHERE NC.CLINN_ID = AN_CLINN_ID;
     END;
    END IF;

    EXCEPTION
      WHEN OTHERS THEN      
        LN_ERROR := -1;
        LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASP_GRABAR_NOTIFICACION_LOG : ' ||
                    SQLERRM;
        AN_ERROR := LN_ERROR;
        AV_ERROR := LV_ERROR;  
  END;

  PROCEDURE SGASS_OBTENER_NOTIFICACION_CAB(AV_LCABC_NUMSLC OPERACION.SGAT_PROCESO_LIC_CAB.LCABC_NUMSLC%TYPE,                                                          
                                           AN_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,
                                           AC_CUR_NOTCAB OUT SYS_REFCURSOR,                                                     
                                           AN_ERROR OUT NUMBER,
                                           AV_ERROR OUT VARCHAR2)
  IS
  LV_NOMCLI MARKETING.VTATABCLI.NOMCLI%TYPE;
  LV_LICITACION CHAR(4);
  LI_CODPROV OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_CODPROV%TYPE;
  LN_DIAS    NUMBER;
  LV_NOMPROV OPERACION.CONTRATA.NOMBRE%TYPE;
  LV_PROCESO VARCHAR2(300);
  LN_ERROR NUMBER;
  LV_ERROR VARCHAR2(400);    
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';  
    
    --Obtener si el proyecto es Licitación
    SELECT 
           (CASE WHEN FAC.NRO_LICITACION IS NULL 
                 THEN 'NO' ELSE 'SI'
            END) LICSV_LICITACION,
            (CASE WHEN FAC.NRO_LICITACION IS NULL THEN NULL
                         ELSE FAC.NRO_LICITACION || ''-'' || GOB.DES_CONVOCATORIA
            END) LICDV_PROCON, CLI.NOMCLI INTO LV_LICITACION, LV_PROCESO , LV_NOMCLI
    FROM OPERACION.SGAT_PROCESO_LIC_CAB  CAB,
        MARKETING.VTATABCLI      CLI,
        SALES.VTATABSLCFAC       FAC,      
        BILLCOLPER.LICITACIONGOB GOB
    WHERE CAB.LCABC_CODCLI = CLI.CODCLI
      AND CLI.CODCLI = FAC.CODCLI
      AND FAC.NUMSLC = CAB.LCABC_NUMSLC
      AND FAC.CODCLI = CAB.LCABC_CODCLI
      AND FAC.NRO_LICITACION = GOB.NRO_LICITACION(+)  
      AND CAB.LCABC_NUMSLC = AV_LCABC_NUMSLC;   
    
    --Obtener el Proveedor
    SELECT LICS.LICSI_CODPROV, TRUNC(LICS.LICSD_FECFIN - SYSDATE) INTO LI_CODPROV, LN_DIAS FROM OPERACION.SGAT_PROCESO_LIC_SOP LICS WHERE LICS.LICSI_ID_LIC = AN_ID_LIC; 
    
    SELECT C.NOMBRE INTO LV_NOMPROV FROM OPERACION.CONTRATA C WHERE C.CODCON = LI_CODPROV;
      
    OPEN AC_CUR_NOTCAB FOR
      SELECT 
           LV_LICITACION LICSV_LICITACION,
           LV_PROCESO LICSV_PROCESO,
           LV_NOMCLI LICSV_NOMCLI,
           LN_DIAS LICSI_DIAS,
           LV_NOMPROV LICSV_NOMPROV
      FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        LN_ERROR := -1;
        LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGASS_OBTENER_NOTIFICACION_CAB : ' ||
                    SQLERRM;
        AN_ERROR := LN_ERROR;
        AV_ERROR := LV_ERROR;         
  END;

  PROCEDURE SGASS_OBTENER_NOTIFICACION_DET(AN_ID_LIC OPERACION.SGAT_PROCESO_LIC_SOP.LICSI_ID_LIC%TYPE,                                                          
                                          AC_CUR_NOTDET OUT SYS_REFCURSOR,                                                     
                                          AN_ERROR OUT NUMBER,
                                          AV_ERROR OUT VARCHAR2)
  IS
    CURSOR C_DETALLE(AN_ID_LICS NUMBER)
    IS
    SELECT
           LICS.LICSI_SECUENCIA,
           LICS.LICSV_NOM_LICENCIA,
           LICS.LICSI_CODPROV,
           LICS.LICSV_NUMEROOC,
           LICS.LICSI_POSICIONOC,
           LICS.LICSD_FECINICIO,
           LICS.LICSD_FECFIN,
           LICS.LICSI_TIPO,
           TRUNC(LICS.LICSD_FECFIN - SYSDATE) LICSI_DIAS,
           LICS.LICSV_OBSERVACION
    FROM OPERACION.SGAT_PROCESO_LIC_SOP LICS
    WHERE LICS.LICSI_ID_LIC = AN_ID_LICS
      AND LICS.LICSN_ESTADOLIC NOT IN (1,4);
  LV_NUMSLC OPERACION.SGAT_PROCESO_LIC_DET.LICDC_NUMSLC%TYPE;
  LN_CID    OPERACION.SGAT_PROCESO_LIC_DET.LICDN_CID%TYPE;  
  LV_MODELO OPERACION.SGAT_PROCESO_LIC_DET.LICDC_CODMODELO%TYPE;
  LV_SERIE  OPERACION.SGAT_PROCESO_LIC_DET.LICDV_NUMSERIE%TYPE;
  LV_CODCLI MARKETING.VTATABCLI.CODCLI%TYPE;
  LV_NOMCLI MARKETING.VTATABCLI.NOMCLI%TYPE;
  LV_PROV   OPERACION.CONTRATA.NOMBRE%TYPE;
  LV_SERVICIO VARCHAR2(200);
  LN_ERROR NUMBER;
  LV_ERROR VARCHAR2(400);  
  BEGIN
    AN_ERROR := 0;
    AV_ERROR := 'OK';
    FOR R IN C_DETALLE(AN_ID_LIC) LOOP
      --Obtener el Proyecto / CID
      SELECT licd.licdc_numslc,licd.licdn_cid,licd.licdc_codmodelo,licd.licdv_numserie INTO LV_NUMSLC, LN_CID, LV_MODELO, LV_SERIE FROM operacion.sgat_proceso_lic_det licd WHERE licd.licdi_secuencia = R.licsi_secuencia;
      --Obtener el codigo del cliente
      SELECT licc.lcabc_codcli INTO LV_CODCLI FROM operacion.sgat_proceso_lic_cab licc WHERE licc.lcabc_numslc = LV_NUMSLC;
      --Obtener el nombre del cliente
      SELECT C.NOMCLI INTO LV_NOMCLI FROM MARKETING.VTATABCLI c WHERE c.codcli = LV_CODCLI;
      --Obtiene el Proveedor
      SELECT P.NOMBRE INTO LV_PROV FROM OPERACION.CONTRATA p WHERE p.codcon = R.licsi_codprov;
      --Obtiene el tipo de servicio
      SELECT TD.DESCRIPCION INTO LV_SERVICIO
      FROM OPERACION.TIPOPEDD TP,
      OPERACION.OPEDD TD
      WHERE TP.TIPOPEDD = TD.TIPOPEDD
        AND TP.ABREV = 'TIPO_LICENCIA_SOPORTE'
        AND TD.CODIGON = R.LICSI_TIPO;
          
      OPEN AC_CUR_NOTDET FOR
           SELECT 
                 LV_NUMSLC LICS_NUMSLC,
                 LN_CID LICS_CID,
                 LV_MODELO LICS_MODELO,
                 LV_SERIE LICS_SERIE,
                 LV_PROV LICS_PROV,
                 LV_NOMCLI LICS_NOMCLI,
                 R.LICSV_NOM_LICENCIA LICS_NOMLIC,
                 LV_SERVICIO LICS_TIPSRV,
                 R.LICSV_NUMEROOC LICS_NUMOC,
                 R.LICSI_POSICIONOC LICS_POSOC,
                 R.LICSD_FECINICIO LICS_FECINI,
                 R.LICSD_FECFIN LICS_FECFIN,
                 R.LICSV_OBSERVACION LICS_OBSERV
           FROM DUAL;      
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        LN_ERROR := -1;
        LV_ERROR := 'ERROR EN EL PROCEDIMIENTO PKG_LICENCIA_SERVICIO.SGAS_OBTENER_NOTIFICACION_DETALLE : ' ||
                    SQLERRM;
        AN_ERROR := LN_ERROR;
        AV_ERROR := LV_ERROR;   
  END;

  FUNCTION SGAFUN_OBTIENE_TXT_PER_RENOV RETURN VARCHAR2 IS
    l_txt opedd.abreviacion%type;
  BEGIN
    SELECT o.abreviacion INTO l_txt
      FROM operacion.tipopedd t, operacion.opedd o
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev = 'LICITACION_FECH_FIN'
       AND o.codigon = 1;
       
      RETURN l_txt;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
      RETURN '';
  END;
END;
/