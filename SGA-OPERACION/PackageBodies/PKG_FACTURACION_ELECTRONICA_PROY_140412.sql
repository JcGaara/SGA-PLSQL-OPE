CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_FACTURACION_ELECTRONICA IS

/**********************************************************************************
                        HISTORIAL DE REVISIONES
-----------------------------------------------------------------------------------
VERSIÓN   FECHA         AUTOR                  DESCRIPCIÓN
-----------------------------------------------------------------------------------
1.0       02/12/2019    Fernando Villarruel    CREACIÓN
***********************************************************************************/

  PROCEDURE SGASS_GET_REC_PEND_ENVIO_ANU(PI_FECHA         IN DATE,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2)
   IS
  
    AN_TIPOPEDD NUMBER;  
    V_CODIGO_NC  VARCHAR2(2);
    V_CODIGO_ND  VARCHAR2(2);
    V_CODIGO_REC VARCHAR2(2);    
    V_TIPO_RECIBO VARCHAR2(3);
    V_TIPO_NC VARCHAR2(3);
    V_TIPO_ND VARCHAR2(3);  
    V_CARAC_ESPECIAL CHAR(1) := '|';  
    V_RUC_EMISOR VARCHAR2(20);  
    V_MENSAJE_REC VARCHAR(100);
    V_MENSAJE_NC  VARCHAR(100);
    V_MENSAJE_ND  VARCHAR(100);  
    V_COD_ARCHIVO VARCHAR2(20);
  
  BEGIN
  
    SELECT A.TIPOPEDD
      INTO AN_TIPOPEDD
      FROM OPERACION.TIPOPEDD A
     WHERE A.DESCRIPCION = 'PARAMETROS_DOCS_ELECT';
  
    --SETEO DE PARAMETROS
    SELECT CODIGOC
      INTO V_CODIGO_REC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_RECIBO'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_CODIGO_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_NC'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_CODIGO_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ND'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_TIPO_RECIBO
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_RECIBO'
       AND TIPOPEDD = AN_TIPOPEDD; 
  
    SELECT CODIGOC
      INTO V_TIPO_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_NC'
       AND TIPOPEDD = AN_TIPOPEDD;

    SELECT CODIGOC
      INTO V_TIPO_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_ND'
       AND TIPOPEDD = AN_TIPOPEDD; 
  
    SELECT CODIGOC
      INTO V_RUC_EMISOR
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'RUC_CLARO'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    SELECT CODIGOC
      INTO V_COD_ARCHIVO
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_ANULACION'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    SELECT CODIGOC
      INTO V_MENSAJE_REC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'MENSAJE_ANU_REC'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_MENSAJE_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'MENSAJE_ANU_NC'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_MENSAJE_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'MENSAJE_ANU_ND'
       AND TIPOPEDD = AN_TIPOPEDD;

    FOR TRAMA IN (SELECT
      
                   CASE
                     WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN V_CODIGO_REC
                     WHEN c.tipdoc IN (V_TIPO_NC) THEN V_CODIGO_NC
                     WHEN c.tipdoc IN (V_TIPO_ND) THEN V_CODIGO_ND
                   END || V_CARAC_ESPECIAL ||
                   
                   TRIM(C.SERSUT) || V_CARAC_ESPECIAL ||
                   TRIM(C.NUMSUT) || V_CARAC_ESPECIAL ||
                   
                   CASE
                     WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN V_MENSAJE_REC
                     WHEN c.tipdoc IN (V_TIPO_NC) THEN V_MENSAJE_NC
                     WHEN c.tipdoc IN (V_TIPO_ND) THEN V_MENSAJE_ND
                   END
                   
                   TRAMA
                  
                    FROM COLLECTIONS.CXCTABFAC C
                    LEFT JOIN BILLCOLPER.BILFAC F
                      ON C.IDFAC = F.IDFACCXC
                    LEFT JOIN COLLECTIONS.CXCFAC_ORI O
                      ON C.IDFAC = O.IDFAC
                   WHERE C.FECEMI = PI_FECHA
                     AND C.TIPDOC IN ('REC', 'N/C', 'N/D')
                     AND C.ESTFAC IN ('06')
                     AND SUBSTR(TRIM(C.SERSUT),1,1) IN (
                                         SELECT CODIGOC
                                          FROM OPERACION.opedd
                                         WHERE DESCRIPCION = 'SERIES_PERMITIDAS'
                                           AND TIPOPEDD = AN_TIPOPEDD
                                         )
                     AND TRIM(C.TIPDOC) || TRIM(C.SERSUT) || TRIM(C.NUMSUT) NOT IN
                         (SELECT ADJV_TIPDOC || ADJV_SERSUT || ADJV_NUMSUT
                            FROM OPERACION.SGAT_DOCS_ELECS
                           WHERE ADJC_TIPO_LOTE = V_COD_ARCHIVO)
                    AND 
                    (
                        (c.tipdoc IN (V_TIPO_RECIBO)) OR
                        (c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) AND o.NUMSUT_ORI IS NOT NULL
                         AND o.tipdoc_ori IN (V_TIPO_RECIBO, V_TIPO_NC, V_TIPO_ND)
                        )
                    )                  
                  ) LOOP
      DBMS_OUTPUT.put_line(TRAMA.TRAMA);
    END LOOP;
  
    PO_COD_RESULTADO := '0';
    PO_MSG_RESULTADO := 'TRANSACCION EXITOSA';
  
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
      
        PO_COD_RESULTADO := '-99';
        PO_MSG_RESULTADO := 'ERROR: ' || SQLERRM;
      END;
    
  END SGASS_GET_REC_PEND_ENVIO_ANU;

  PROCEDURE SGASS_GET_REC_PEND_ENVIO_EMI(PI_FECHA         IN DATE,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2) IS
      
    AN_TIPOPEDD NUMBER;  
    V_CODIGO_REC VARCHAR2(2);
    V_CODIGO_NC  VARCHAR2(2);
    V_CODIGO_ND  VARCHAR2(2);        
    V_TIPO_RECIBO VARCHAR2(3);
    V_TIPO_NC VARCHAR2(3);
    V_TIPO_ND VARCHAR2(3);
    V_CARAC_ESPECIAL CHAR(1) := '|';  
    V_RUC_EMISOR VARCHAR2(20);
    V_RS_EMISOR  VARCHAR2(30);  
    V_SOLES   VARCHAR2(3);
    V_DOLARES VARCHAR2(3);  
    V_COD_ARCHIVO VARCHAR2(20);  
    V_CANT_MAX_DOCS NUMBER;
    V_FLAG_ANEXO_1 NUMBER;
    
    V_RESULTADO VARCHAR2(4000);

    CURSOR TRAMA IS
                     SELECT
      
                      CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN V_CODIGO_REC
                        WHEN c.tipdoc IN (V_TIPO_NC) THEN V_CODIGO_NC
                        WHEN c.tipdoc IN (V_TIPO_ND) THEN V_CODIGO_ND
                      END campo_1, --1 Tipo Doc
                      TRIM(C.SERSUT) campo_2, --2 Serie Doc
                      TRIM(C.NUMSUT) campo_3, --3 Nro Doc
                      CASE
                        WHEN C.MONEDA_ID = '1' THEN V_SOLES
                        WHEN C.MONEDA_ID = '2' THEN V_DOLARES
                      END campo_4, -- 4 Tipo de Moneda

                      CASE
                        WHEN (select count(distinct d1.pid)
                                from bilfac        a1,
                                     cr            b1,
                                     instxproducto c1,
                                     insprd        d1
                               where a1.idfaccxc = C.idfac
                                 and b1.idbilfac = a1.idbilfac
                                 and c1.idinstprod = b1.idinstprod
                                 and d1.pid = c1.pid
                                 and d1.flgprinc = 1) >= 2 THEN --Definir si es Recibo Multiple
                         5
                        ELSE

                            CASE
                              WHEN (select
                                        count(distinct e1.tipsrv)
                                    from bilfac   a1,
                                    cr            b1,
                                    instxproducto c1,
                                    insprd        d1,
                                    inssrv        e1
                                    where a1.idfaccxc = C.idfac
                                    and b1.idbilfac = a1.idbilfac
                                    and c1.idinstprod = b1.idinstprod
                                    and d1.pid = c1.pid
                                    and d1.flgprinc = 1
                                    and d1.codinssrv=e1.codinssrv
                                    and e1.tipsrv = '0002') > 0 THEN 7

                               WHEN (select
                                        count(distinct e1.tipsrv)
                                    from bilfac   a1,
                                    cr            b1,
                                    instxproducto c1,
                                    insprd        d1,
                                    inssrv        e1
                                    where a1.idfaccxc = C.idfac
                                    and b1.idbilfac = a1.idbilfac
                                    and c1.idinstprod = b1.idinstprod
                                    and d1.pid = c1.pid
                                    and d1.flgprinc = 1
                                    and d1.codinssrv=e1.codinssrv
                                    and e1.tipsrv = '0004') > 0 THEN 4

                                WHEN (select
                                        count(distinct e1.tipsrv)
                                    from bilfac   a1,
                                    cr            b1,
                                    instxproducto c1,
                                    insprd        d1,
                                    inssrv        e1
                                    where a1.idfaccxc = C.idfac
                                    and b1.idbilfac = a1.idbilfac
                                    and c1.idinstprod = b1.idinstprod
                                    and d1.pid = c1.pid
                                    and d1.flgprinc = 1
                                    and d1.codinssrv=e1.codinssrv
                                    and e1.tipsrv = '0062') > 0 THEN 3

                              ELSE
                               7
                            END

                      END campo_5, -- 5 Tipo de Servicio
                      
                      -- 6 Ciclo Facturacion - Inicio
                      CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN TO_CHAR(f.FECINI, 'YYYY-MM-DD')
                        WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                          (
                          SELECT TO_CHAR(F1.FECINI, 'YYYY-MM-DD') 
                          FROM COLLECTIONS.CXCTABFAC C1
                          LEFT JOIN BILLCOLPER.BILFAC F1
                            ON C1.IDFAC = F1.IDFACCXC
                          WHERE
                          C1.tipdoc = O.tipdoc_ori AND
                          C1.SERSUT = O.NUMSER_ORI AND
                          C1.NUMSUT = O.NUMSUT_ORI
                           )
                      END campo_6,
                      
                      -- 7 Ciclo Facturacion - Fin
                      CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN TO_CHAR(f.FECFIN, 'YYYY-MM-DD')
                        WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                          (
                          SELECT TO_CHAR(F1.FECFIN, 'YYYY-MM-DD') 
                          FROM COLLECTIONS.CXCTABFAC C1
                          LEFT JOIN BILLCOLPER.BILFAC F1
                            ON C1.IDFAC = F1.IDFACCXC
                          WHERE 
                          C1.tipdoc = O.tipdoc_ori AND 
                          C1.SERSUT = O.NUMSER_ORI AND
                          C1.NUMSUT = O.NUMSUT_ORI
                           )
                      END campo_7,
                      
                     -- 8 Tipo Doc
                     CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN                          
                            CASE f.TIPO_DOC_IDE
                              WHEN '000' THEN '0'
                              WHEN '002' THEN '1'
                              WHEN '004' THEN '4'
                              WHEN '001' THEN '6'
                              WHEN '006' THEN '7'
                              ELSE '0'
                            END                          
                        WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN                                                 
                            CASE (
                                  SELECT F1.TIPO_DOC_IDE
                                  FROM COLLECTIONS.CXCTABFAC C1
                                  LEFT JOIN BILLCOLPER.BILFAC F1
                                    ON C1.IDFAC = F1.IDFACCXC
                                  WHERE
                                  C1.tipdoc = O.tipdoc_ori AND
                                  C1.SERSUT = O.NUMSER_ORI AND
                                  C1.NUMSUT = O.NUMSUT_ORI
                                 )
                              WHEN '000' THEN '0'
                              WHEN '002' THEN '1'
                              WHEN '004' THEN '4'
                              WHEN '001' THEN '6'
                              WHEN '006' THEN '7'
                              ELSE '0'
                            END
                      END campo_8,
                                            
                      -- 9 Nro Doc
                      CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN TRIM(f.NRO_DOC_IDE)
                        WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                          (
                          SELECT TRIM(F1.NRO_DOC_IDE)
                          FROM COLLECTIONS.CXCTABFAC C1
                          LEFT JOIN BILLCOLPER.BILFAC F1
                            ON C1.IDFAC = F1.IDFACCXC
                          WHERE 
                          C1.tipdoc = O.tipdoc_ori AND 
                          C1.SERSUT = O.NUMSER_ORI AND
                          C1.NUMSUT = O.NUMSUT_ORI
                           )
                      END campo_9,
             
                      -- 10 Nombres
                      SUBSTR(
                      TRIM(
                               
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      TRANSLATE(UPPER(
                      c.NOMCLI
                      ), '|,°,¿,ª,º,/', 'N')
                      , '|', ' ')
                      , '  ', ' ')
                      , CHR(10), '')
                      , CHR(13), '')
                      , '  ', ' ')
                      , '    ', ' ')
                      , '   ', ' ')
                      , '  ', ' ')
                      , '  ', '')
                      , '  ', '')
                      , ' ', '')
                      , 'Ò', 'O')
                      , 'Ì', 'I')
                      , '^', '')
                      , '', '')
                      , '·', ' ')
                      , 'Ù', 'U')
                      , '\', ' ')
                      , 'Ã', 'A')
                      , 'Ç', 'C')
                      , '	', ' ')
                      , '  ', ' ')
                      
                      )
                      , 0, 1499)
                      campo_10,

                      '' campo_11, --11 Codigo de Ubigeo

                      -- 12 Direccion                      
                      SUBSTR(
                      TRIM(
                                  
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      TRANSLATE(UPPER(
                      c.DIRCLI
                      ), '|,°,¿,ª,º,/', 'N')
                      , '|', ' ')
                      , '  ', ' ')
                      , CHR(10), '')
                      , CHR(13), '')
                      , '  ', ' ')
                      , '    ', ' ')
                      , '   ', ' ')
                      , '  ', ' ')
                      , '  ', '')
                      , '  ', '')
                      , ' ', '')
                      , 'Ò', 'O')
                      , 'Ì', 'I')
                      , '^', '')
                      , '', '')
                      , '·', ' ')
                      , 'Ù', 'U')
                      , '\', ' ')
                      , 'Ã', 'A')
                      , 'Ç', 'C')
                      , '	', ' ')
                      , '  ', ' ')
                      
                      )
                      , 0, 199)
                      campo_12,
                                            
                      -- 13 Nro Telefono
                      REPLACE(
                      REPLACE(                     
                      REPLACE(
                      REPLACE(
                      TRANSLATE(
                      
                      CASE
                            SUBSTR(TRIM(
                            CASE
                              WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN TRIM(F.NOMABR)
                              WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                                (
                                SELECT TRIM(F1.NOMABR)
                                  FROM COLLECTIONS.CXCTABFAC C1
                                  LEFT JOIN BILLCOLPER.BILFAC F1
                                    ON C1.IDFAC = F1.IDFACCXC
                                 WHERE C1.tipdoc = O.tipdoc_ori
                                   AND C1.SERSUT = O.NUMSER_ORI
                                   AND C1.NUMSUT = O.NUMSUT_ORI
                                 )
                            END
                            ),1,3)
                            
                        WHEN 'CID' THEN '-'
                        WHEN 'SID' THEN '-'
                        WHEN '' THEN '-'
                        ELSE
                           CASE
                              WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN                              
                                    CASE
                                      WHEN F.NOMABR IS NULL THEN '-'
                                      ELSE TRIM(F.NOMABR)
                                    END
                              WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                                
                                    CASE
                                      WHEN (
                                            SELECT TRIM(F1.NOMABR)
                                              FROM COLLECTIONS.CXCTABFAC C1
                                              LEFT JOIN BILLCOLPER.BILFAC F1
                                                ON C1.IDFAC = F1.IDFACCXC
                                             WHERE C1.tipdoc = O.tipdoc_ori
                                               AND C1.SERSUT = O.NUMSER_ORI
                                               AND C1.NUMSUT = O.NUMSUT_ORI
                                             ) IS NULL THEN '-'
                                      ELSE (
                                            SELECT TRIM(F1.NOMABR)
                                              FROM COLLECTIONS.CXCTABFAC C1
                                              LEFT JOIN BILLCOLPER.BILFAC F1
                                                ON C1.IDFAC = F1.IDFACCXC
                                             WHERE C1.tipdoc = O.tipdoc_ori
                                               AND C1.SERSUT = O.NUMSER_ORI
                                               AND C1.NUMSUT = O.NUMSUT_ORI
                                             )
                                    END
                                
                            END
                        END
                      
                      , '|,°,¿,ª,º,/', 'N')
                      , '|', ' ')
                      , '  ', ' ')
                      , CHR(10), '')
                      , CHR(13), '')
                      campo_13,
                                            
                      -- 14 Recibo Multiple
                      CASE
                        WHEN (select count(distinct d1.pid)
                                from bilfac        a1,
                                     cr            b1,
                                     instxproducto c1,
                                     insprd        d1
                               where a1.idfaccxc = C.idfac
                                 and b1.idbilfac = a1.idbilfac
                                 and c1.idinstprod = b1.idinstprod
                                 and d1.pid = c1.pid
                                 and d1.flgprinc = 1) > 1 THEN
                         1
                        ELSE
                         0
                      END campo_14,
                                  
                      -- 15 Codigo de Cliente
                      CASE
                        WHEN c.tipdoc IN (V_TIPO_RECIBO) THEN TRIM(C.CODCLI)
                        WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                          (
                          SELECT TRIM(C1.CODCLI)
                          FROM COLLECTIONS.CXCTABFAC C1
                          LEFT JOIN BILLCOLPER.BILFAC F1
                            ON C1.IDFAC = F1.IDFACCXC
                          WHERE 
                          C1.tipdoc = O.tipdoc_ori AND 
                          C1.SERSUT = O.NUMSER_ORI AND
                          C1.NUMSUT = O.NUMSUT_ORI
                           )
                      END campo_15,
                      
                      '' campo_16, --16 Latitud
                      '' campo_17, --17 Longitud
                      '' campo_18, --18 Consumo Periodo
                      '' campo_19, --19 Codigo Tipo de Tarifa
                      TRIM(TO_CHAR(c.FECVEN, 'YYYY-MM-DD')) campo_20, --20 Fecha de Vencimiento
                     
                      -- Importes
                      TRIM(TO_CHAR('0', '9999990.99')) campo_21,  --21 Monto Inafecto
                      TRIM(TO_CHAR('0', '9999990.99')) campo_22,  --22 Monto Exonerado
                      TRIM(TO_CHAR(C.VALFAC - C.VALDSC, '9999990.99')) campo_23, --23 Monto Afecto al IGV
                      TRIM(TO_CHAR('0', '9999990.99')) campo_24, --24 Refacturacion
                      TRIM(TO_CHAR(C.VALIMP, '9999990.99')) campo_25, --25 IGV
                      '0.00' campo_26, -- 26 otros Tributos
                      '0.00' campo_27, -- 27 descuentos globales que afectan la base imponible del IGV
                      '0.00' campo_28, -- 28 cargos globales que afectan la base imponible del IGV
                      '0.00' campo_29, -- 29 descuentos que no afectan la base imponible del IGV
                      '0.00' campo_30, -- 30 cargos que no afectan la base imponible del IGV
                      TRIM(TO_CHAR(C.VALTOT - C.VALTOT_FCO, '9999990.99')) campo_31, -- 31 Monto Total
                      
                      CASE
                            WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                             CASE
                               WHEN o.tipdoc_ori IN (V_TIPO_RECIBO) THEN V_CODIGO_REC
                               WHEN o.tipdoc_ori IN (V_TIPO_NC) THEN V_CODIGO_NC
                               WHEN o.tipdoc_ori IN (V_TIPO_ND) THEN V_CODIGO_ND
                             END
                      END campo_32, -- 32 Tipo de comprobante de pago que modifica
                          
                      CASE
                            WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN o.NUMSER_ORI
                      END campo_33, -- 33 Serie del comprobante de pago que modifica
                      
                      CASE
                            WHEN c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) THEN
                             o.NUMSUT_ORI
                      END campo_34, -- 34 correlativo del comprobante de pago que modifica

                      V_RUC_EMISOR campo_35, -- 35 Ruc del Emisor
                      V_RS_EMISOR campo_36, -- 36 Razon Social del Emisor
                      TO_CHAR(C.FECEMI, 'YYYYMMDD') campo_37 --37 Fecha de Emision
                      
                FROM COLLECTIONS.CXCTABFAC C
                LEFT JOIN BILLCOLPER.BILFAC F
                  ON C.IDFAC = F.IDFACCXC
                LEFT JOIN COLLECTIONS.CXCFAC_ORI O
                  ON C.IDFAC = O.IDFAC
               WHERE 
                     C.FECEMI = PI_FECHA
                 AND C.TIPDOC IN ('REC', 'N/C', 'N/D')
                 AND C.ESTFAC NOT IN ('01')                 
                 AND SUBSTR(TRIM(C.SERSUT),1,1) IN (
                                                   SELECT CODIGOC
                                                    FROM OPERACION.opedd
                                                   WHERE DESCRIPCION = 'SERIES_PERMITIDAS'
                                                     AND TIPOPEDD = AN_TIPOPEDD
                                                   )
                 AND ROWNUM <= V_CANT_MAX_DOCS
                 AND TRIM(C.TIPDOC) || TRIM(C.SERSUT) || TRIM(C.NUMSUT) NOT IN
                     (SELECT ADJV_TIPDOC || ADJV_SERSUT || ADJV_NUMSUT
                        FROM OPERACION.SGAT_DOCS_ELECS
                       WHERE ADJC_TIPO_LOTE = V_COD_ARCHIVO)
                AND 
                (
                    (c.tipdoc IN (V_TIPO_RECIBO)) OR
                    (c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) AND o.NUMSUT_ORI IS NOT NULL
                     AND o.tipdoc_ori IN (V_TIPO_RECIBO, V_TIPO_NC, V_TIPO_ND)
                    )
                );
  
  BEGIN
  
    SELECT A.TIPOPEDD
      INTO AN_TIPOPEDD
      FROM OPERACION.TIPOPEDD A
     WHERE A.DESCRIPCION = 'PARAMETROS_DOCS_ELECT';
  
    --CONFIGURACION DE INFORMACION ENVIADA PARA SUNAT
    SELECT CODIGOC
      INTO V_CODIGO_REC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_RECIBO'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_CODIGO_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_NC'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_CODIGO_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ND'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_TIPO_RECIBO
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_RECIBO'
       AND TIPOPEDD = AN_TIPOPEDD; 
  
    SELECT CODIGOC
      INTO V_TIPO_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_NC'
       AND TIPOPEDD = AN_TIPOPEDD;

    SELECT CODIGOC
      INTO V_TIPO_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_ND'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    SELECT CODIGOC
      INTO V_RUC_EMISOR
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'RUC_CLARO'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_RS_EMISOR
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'RS_CLARO'
       AND TIPOPEDD = AN_TIPOPEDD;
       
    SELECT CODIGOC
      INTO V_SOLES
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'MONEDA_SOLES'
       AND TIPOPEDD = AN_TIPOPEDD;
           
    SELECT CODIGOC
      INTO V_DOLARES
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'MONEDA_DOLARES'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    SELECT CODIGOC
      INTO V_COD_ARCHIVO
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_EMISION'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    SELECT CODIGON
      INTO V_FLAG_ANEXO_1
      FROM OPERACION.opedd
     WHERE ABREVIACION = 'FLAG_ANEXO_1'
       AND TIPOPEDD = AN_TIPOPEDD;
            
    SELECT CODIGON
      INTO V_CANT_MAX_DOCS
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'NRO_DOCUMENTOS_MAX'
       AND TIPOPEDD = AN_TIPOPEDD;
              
      FOR registro IN TRAMA LOOP
        
          V_RESULTADO := registro.campo_1;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_2;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_3;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_4;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_5;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_6;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_7;

          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_8;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_9;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_10;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_11;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_12;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_13;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_14;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_15;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_16;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_17;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_18;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_19;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_20;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_21;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_22;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_23;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_24;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_25;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_26;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_27;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_28;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_29;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_30;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_31;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_32;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_33;
          V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_34;          
          
          IF V_FLAG_ANEXO_1 = 1 THEN
             V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_35;
             V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_36;
             V_RESULTADO := V_RESULTADO || V_CARAC_ESPECIAL || registro.campo_37;
          END IF;                
      
          DBMS_OUTPUT.PUT_LINE(V_RESULTADO);
          
      END LOOP;

    PO_COD_RESULTADO := '0';
    PO_MSG_RESULTADO := 'TRANSACCIÓN EXITOSA';
  
  END SGASS_GET_REC_PEND_ENVIO_EMI;

  PROCEDURE SGASS_COUNT_REC_PEND_ENV(PI_FECHA         IN DATE,
                                         PI_TIPO          IN CHAR,
                                         PO_DETALLE       OUT VARCHAR2,
                                         PO_COD_RESULTADO OUT VARCHAR2,
                                         PO_MSG_RESULTADO OUT VARCHAR2)
  
   IS
  
    AN_TIPOPEDD NUMBER;
  
    V_TOTAL_REG NUMBER := 0;
    V_MONTO     NUMBER := 0;
  
    V_COD_EMISION   CHAR(2);
    V_COD_ANULACION CHAR(2);
  
    V_TIPO CHAR(2);
    
    V_TIPO_RECIBO VARCHAR2(3);
    V_TIPO_NC VARCHAR2(3);
    V_TIPO_ND VARCHAR2(3);
  
  BEGIN
  
    SELECT A.TIPOPEDD
      INTO AN_TIPOPEDD
      FROM OPERACION.TIPOPEDD A
     WHERE A.DESCRIPCION = 'PARAMETROS_DOCS_ELECT';
  
    --SETEO DE PARAMETROS 
    SELECT CODIGOC
      INTO V_COD_EMISION
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_EMISION'
       AND TIPOPEDD = AN_TIPOPEDD;
    
    SELECT CODIGOC
      INTO V_COD_ANULACION
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_ANULACION'
       AND TIPOPEDD = AN_TIPOPEDD;

    SELECT CODIGOC
      INTO V_TIPO_RECIBO
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_RECIBO'
       AND TIPOPEDD = AN_TIPOPEDD; 
  
    SELECT CODIGOC
      INTO V_TIPO_NC
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_NC'
       AND TIPOPEDD = AN_TIPOPEDD;

    SELECT CODIGOC
      INTO V_TIPO_ND
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'TIPO_ND'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    IF PI_TIPO = V_COD_EMISION THEN
      V_TIPO := '02';
    ELSIF PI_TIPO = V_COD_ANULACION THEN
      V_TIPO := '06';
    END IF;
    
    --NUMERO DE DOCUMENTOS EMITIDOS           
    SELECT NVL(COUNT(1), '0')
      INTO V_TOTAL_REG
      FROM COLLECTIONS.CXCTABFAC C
      LEFT JOIN BILLCOLPER.BILFAC F
        ON C.IDFAC = F.IDFACCXC
      LEFT JOIN COLLECTIONS.CXCFAC_ORI O
        ON C.IDFAC = O.IDFAC
     WHERE C.FECEMI = PI_FECHA
       AND C.TIPDOC IN ('REC', 'N/C', 'N/D')
       AND C.ESTFAC = V_TIPO       
        AND SUBSTR(TRIM(C.SERSUT),1,1) IN (
                                       SELECT CODIGOC
                                        FROM OPERACION.opedd
                                       WHERE DESCRIPCION = 'SERIES_PERMITIDAS'
                                         AND TIPOPEDD = AN_TIPOPEDD
                                       )
       AND TRIM(C.TIPDOC) || TRIM(C.SERSUT) || TRIM(C.NUMSUT) NOT IN
           (SELECT ADJV_TIPDOC || ADJV_SERSUT || ADJV_NUMSUT
              FROM OPERACION.SGAT_DOCS_ELECS
             WHERE ADJC_TIPO_LOTE = PI_TIPO)
      AND 
      (
      (c.tipdoc IN (V_TIPO_RECIBO)) OR
      (c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) AND o.NUMSUT_ORI IS NOT NULL)
      );
            
  
    --MONTO DE DOCUMENTOS EMITIDOS   
    SELECT NVL(SUM(C.VALTOT), '0')
      INTO V_MONTO
      FROM COLLECTIONS.CXCTABFAC C
      LEFT JOIN BILLCOLPER.BILFAC F
        ON C.IDFAC = F.IDFACCXC
      LEFT JOIN COLLECTIONS.CXCFAC_ORI O
        ON C.IDFAC = O.IDFAC
     WHERE C.FECEMI = PI_FECHA
       AND C.TIPDOC IN ('REC', 'N/C', 'N/D')
       AND C.ESTFAC = V_TIPO       
        AND SUBSTR(TRIM(C.SERSUT),1,1) IN (
                                       SELECT CODIGOC
                                        FROM OPERACION.opedd
                                       WHERE DESCRIPCION = 'SERIES_PERMITIDAS'
                                         AND TIPOPEDD = AN_TIPOPEDD
                                       )
       AND TRIM(C.TIPDOC) || TRIM(C.SERSUT) || TRIM(C.NUMSUT) NOT IN
           (SELECT ADJV_TIPDOC || ADJV_SERSUT || ADJV_NUMSUT
              FROM OPERACION.SGAT_DOCS_ELECS
             WHERE ADJC_TIPO_LOTE = PI_TIPO)
      AND 
      (
      (c.tipdoc IN (V_TIPO_RECIBO)) OR
      (c.tipdoc IN (V_TIPO_NC, V_TIPO_ND) AND o.NUMSUT_ORI IS NOT NULL)
      );
  
    PO_COD_RESULTADO := '0';
    PO_MSG_RESULTADO := 'CONSULTA EXITOSA';
    PO_DETALLE       := V_TOTAL_REG || '|' || V_MONTO;
  
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
      
        ROLLBACK;
        PO_DETALLE       := '0|0.00';
        PO_COD_RESULTADO := '-99';
        PO_MSG_RESULTADO := 'ERROR: ' || SQLERRM;
      END;
    
  END SGASS_COUNT_REC_PEND_ENV;

  PROCEDURE SGASI_DOCS_ELECS(PI_TIPDOC      IN VARCHAR2,
                             PI_SERSUT      IN VARCHAR2,
                             PI_NUMSUT      IN VARCHAR2,
                             PI_NOMBRE_ARCH IN VARCHAR2,
                             PI_TIPO_LOTE   IN VARCHAR2,
                             PI_ESTADO      IN VARCHAR2,
                             PI_OBSERVACION IN VARCHAR2,                             
                             PI_USUARIO       IN VARCHAR2,
                             PO_COD_RESULTADO OUT VARCHAR2,
                             PO_MSG_RESULTADO OUT VARCHAR2) IS
  
    AN_TIPOPEDD NUMBER;  
    V_COD_EMISION   VARCHAR(2);
    V_COD_ANULACION VARCHAR(2);  
    V_TIPO_REC VARCHAR2(3);
    V_TIPO_NC  VARCHAR2(3);
    V_TIPO_ND  VARCHAR2(3);  
    V_CODIGO_REC VARCHAR2(2);
    V_CODIGO_NC  VARCHAR2(2);
    V_CODIGO_ND  VARCHAR2(2);  
    V_TIPDOC     VARCHAR2(3);
    V_ID_ARCHIVO NUMBER(15);
  
  BEGIN
  
    SELECT A.TIPOPEDD
      INTO AN_TIPOPEDD
      FROM OPERACION.TIPOPEDD A
     WHERE A.DESCRIPCION = 'PARAMETROS_DOCS_ELECT';
  
    SELECT CODIGOC
      INTO V_COD_EMISION
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_EMISION'
       AND TIPOPEDD = AN_TIPOPEDD;
    SELECT CODIGOC
      INTO V_COD_ANULACION
      FROM OPERACION.opedd
     WHERE DESCRIPCION = 'CODIGO_ARCHIVO_ANULACION'
       AND TIPOPEDD = AN_TIPOPEDD;
  
    IF PI_TIPO_LOTE = V_COD_EMISION OR PI_TIPO_LOTE = V_COD_ANULACION THEN
    
      --SETEO DE PARAMETROS
      SELECT CODIGOC
        INTO V_CODIGO_REC
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'CODIGO_RECIBO'
         AND TIPOPEDD = AN_TIPOPEDD;
      
      SELECT CODIGOC
        INTO V_CODIGO_NC
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'CODIGO_NC'
         AND TIPOPEDD = AN_TIPOPEDD;
      
      SELECT CODIGOC
        INTO V_CODIGO_ND
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'CODIGO_ND'
         AND TIPOPEDD = AN_TIPOPEDD;
    
      SELECT CODIGOC
        INTO V_TIPO_REC
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'TIPO_RECIBO'
         AND TIPOPEDD = AN_TIPOPEDD;
      
      SELECT CODIGOC
        INTO V_TIPO_NC
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'TIPO_NC'
         AND TIPOPEDD = AN_TIPOPEDD;
      
      SELECT CODIGOC
        INTO V_TIPO_ND
        FROM OPERACION.opedd
       WHERE DESCRIPCION = 'TIPO_ND'
         AND TIPOPEDD = AN_TIPOPEDD;
    
      IF PI_TIPDOC = V_CODIGO_REC THEN
        V_TIPDOC := V_TIPO_REC;
      ELSIF PI_TIPDOC = V_CODIGO_NC THEN
        V_TIPDOC := V_TIPO_NC;
      ELSIF PI_TIPDOC = V_CODIGO_ND THEN
        V_TIPDOC := V_TIPO_ND;
      END IF;
    
      SELECT OPERACION.SGAT_DOCS_ELECS_S.NEXTVAL
        INTO V_ID_ARCHIVO
        FROM DUAL;
    
      INSERT INTO OPERACION.SGAT_DOCS_ELECS E
        (ADJN_DOCUMENTO_ID,
         ADJV_TIPDOC,
         ADJV_SERSUT,
         ADJV_NUMSUT,
         ADJV_NOMBRE_ARCH,
         ADJC_TIPO_LOTE,
         ADJV_ESTADO,
         ADJV_OBSERVACION,
         ADJD_FECHA_REGISTRO,
         ADJV_USUARIO_REGISTRO)
      VALUES
        (V_ID_ARCHIVO,
         V_TIPDOC,
         PI_SERSUT,
         PI_NUMSUT,
         PI_NOMBRE_ARCH,
         PI_TIPO_LOTE,
         PI_ESTADO,
         PI_OBSERVACION,
         SYSDATE,
         PI_USUARIO);
    
    ELSIF PI_TIPO_LOTE = 'RL' THEN
      
      --ROLLBACK SI LA ACTUALIZACION DE DOCUMENTO A ENVIADO FALLA
      DELETE FROM OPERACION.SGAT_DOCS_ELECS
      WHERE ADJV_NOMBRE_ARCH = PI_NOMBRE_ARCH;
    
    END IF;
  
    PO_COD_RESULTADO := '0';
    PO_MSG_RESULTADO := 'TRANSACCION EXITOSA';
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
      
        ROLLBACK;
        
        PO_COD_RESULTADO := '-99';
        PO_MSG_RESULTADO := 'ERROR: SGASI_DOCS_ELECS - ' || SQLERRM;
      END;
    
  END SGASI_DOCS_ELECS;

END PKG_FACTURACION_ELECTRONICA;
/
