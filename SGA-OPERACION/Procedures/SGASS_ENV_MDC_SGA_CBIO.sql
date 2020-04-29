CREATE OR REPLACE PROCEDURE OPERACION.SGASS_ENV_MDC_SGA_CBIO(PO_CURSOR_CAB OUT SYS_REFCURSOR,
                                                             PO_CURSOR_DET OUT SYS_REFCURSOR) IS
  
    LD_TODAY DATE := SYSDATE;
    
  CURSOR C_TIPTRA IS
    SELECT CB.TIPTRA
      FROM WEBSERVICE.SGAT_LOG_API_CBIO CB
     WHERE TRUNC(CB.FECHA_INS) = TRUNC(LD_TODAY) - 1
       AND NOT EXISTS (SELECT 1
              FROM TIPOPEDD T, OPEDD O
             WHERE T.TIPOPEDD = O.TIPOPEDD
               AND UPPER(T.ABREV) = 'TRANS_TIPTRA_APIS_CBIOS'
               AND O.CODIGON = CB.TIPTRA)
     GROUP BY CB.TIPTRA;
  
  BEGIN
   FOR C1 IN C_TIPTRA LOOP
      INSERT INTO OPEDD
         (IDOPEDD,
          CODIGOC,
          CODIGON,
          DESCRIPCION,
          ABREVIACION,
          TIPOPEDD,
          CODIGON_AUX)
       VALUES
         ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD),
          TRUNC(LD_TODAY),
          C1.TIPTRA,
          (SELECT substr(TRIM(DESCRIPCION), 1, 100)
             FROM TIPTRABAJO T
            WHERE T.TIPTRA = C1.TIPTRA),
          NULL,
          (SELECT MAX(TIPOPEDD)
             FROM TIPOPEDD
            WHERE UPPER(ABREV) = 'TRANS_TIPTRA_APIS_CBIOS'),
          NULL);
          COMMIT;
     END LOOP;
     
     OPEN PO_CURSOR_CAB FOR
        SELECT TRUNC(LD_TODAY) AS FEC_EJEC,
               TRUNC(LD_TODAY - 1) AS PEDIDO_FECHA_CREA,
               T.DESCRIPCION AS DESC_TRANSACCION,
               LOG.NOMBREXML AS METODO,
               COUNT(LOG.CODSOLOT) AS CANT_TRANSACCION,
               'ÉXITO' AS EST_TRANSACCION
          FROM OPERACION.TIPTRABAJO T
         INNER JOIN (SELECT O.CODIGON
                       FROM TIPOPEDD T, OPEDD O
                      WHERE T.TIPOPEDD = O.TIPOPEDD
                        AND UPPER(T.ABREV) = 'TRANS_TIPTRA_APIS_CBIOS') CONF
            ON T.TIPTRA = CONF.CODIGON
          LEFT JOIN (SELECT CB.CODSOLOT, CB.TIPTRA, CB.NOMBREXML
                       FROM WEBSERVICE.SGAT_LOG_API_CBIO CB
                      WHERE CB.ID_API_CBIO IN
                            (SELECT MAX(CB2.ID_API_CBIO)
                               FROM WEBSERVICE.SGAT_LOG_API_CBIO CB2
                              WHERE CB2.CODSOLOT = CB.CODSOLOT
                                AND CB2.NOMBREXML = CB.NOMBREXML)
                        AND TRUNC(CB.FECHA_INS) = TRUNC(LD_TODAY) - 1
                        AND CB.COD_ERROR = '0') LOG
            ON T.TIPTRA = LOG.TIPTRA
         GROUP BY T.DESCRIPCION, LOG.NOMBREXML
        
        UNION
        
        SELECT TRUNC(LD_TODAY) AS FEC_EJEC,
               TRUNC(LD_TODAY - 1) AS PEDIDO_FECHA_CREA,
               T.DESCRIPCION AS DESC_TRANSACCION,
               LOG.NOMBREXML AS METODO,
               COUNT(LOG.CODSOLOT) AS CANT_TRANSACCION,
               'ERROR' AS EST_TRANSACCION
          FROM OPERACION.TIPTRABAJO T
         INNER JOIN (SELECT O.CODIGON
                       FROM TIPOPEDD T, OPEDD O
                      WHERE T.TIPOPEDD = O.TIPOPEDD
                        AND UPPER(T.ABREV) = 'TRANS_TIPTRA_APIS_CBIOS') CONF
            ON T.TIPTRA = CONF.CODIGON
          LEFT JOIN (SELECT CB.CODSOLOT, CB.TIPTRA, CB.NOMBREXML
                       FROM WEBSERVICE.SGAT_LOG_API_CBIO CB
                      WHERE CB.ID_API_CBIO IN
                            (SELECT MAX(CB2.ID_API_CBIO)
                               FROM WEBSERVICE.SGAT_LOG_API_CBIO CB2
                              WHERE CB2.CODSOLOT = CB.CODSOLOT
                                AND CB2.NOMBREXML = CB.NOMBREXML)
                        AND TRUNC(CB.FECHA_INS) = TRUNC(LD_TODAY) - 1
                        AND CB.COD_ERROR <> '0') LOG
            ON T.TIPTRA = LOG.TIPTRA
         GROUP BY T.DESCRIPCION, LOG.NOMBREXML;
        
        
     OPEN PO_CURSOR_DET FOR
      SELECT TRUNC(LD_TODAY - 1) AS PEDIDO_FECHA_CREA,
             CB.CODSOLOT AS CODSOLOT,
             CB.IDWF     AS IDWF,
             CB.TAREADEF AS TAREADEF,
             T.TIPTRA AS TIPO_TRANSACCION,
             T.DESCRIPCION AS DESC_TRANSACCION,
             CB.NOMBREXML AS METODO,
             CB.COD_ERROR AS COD_ERROR,
             CB.MENSAJE AS MSJ_ERROR
        FROM WEBSERVICE.SGAT_LOG_API_CBIO CB,
             OPERACION.TIPTRABAJO T
       WHERE CB.TIPTRA = T.TIPTRA
         AND CB.ID_API_CBIO =
                     (SELECT MAX(CB2.ID_API_CBIO)
                               FROM WEBSERVICE.SGAT_LOG_API_CBIO CB2
                              WHERE CB2.CODSOLOT = CB.CODSOLOT
                                AND CB2.NOMBREXML = CB.NOMBREXML)
         AND TRUNC(CB.FECHA_INS) = TRUNC(LD_TODAY) - 1
         AND CB.COD_ERROR <> '0';
  
  END;
/