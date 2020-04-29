
DECLARE 
 LN_CODETA NUMBER;
 LN_EFESN_ID OPERACION.SGAT_EF_ETAPA_SRVC.EFESN_ID%TYPE;
BEGIN
  LN_CODETA:=0;
--  LN_EFESN_ID:=0;
  /*ETAPA 1*/
  SELECT ET.CODETA
  INTO LN_CODETA
  FROM OPERACION.ETAPA ET 
  WHERE UPPER(ET.DESCRIPCION) = 'CLIENTE-INSTALACION DE ACCESO PEX-MANO DE OBRA-TENDIDO';
  
  INSERT INTO OPERACION.SGAT_EF_ETAPA_SRVC (EFESN_CODETA, EFESC_TIPPRC, EFESV_MODNEG, EFESN_ESTADO, EFESV_USUREG, EFESD_FECREG, EFESV_USUMOD, EFESD_FECMOD)
  VALUES (LN_CODETA, 'N', 'SA', 1, 'EASTULLE', SYSDATE, NULL, NULL);
  LN_CODETA:=0;
  /*ETAPA 2*/
  SELECT ET.CODETA
  INTO LN_CODETA
  FROM OPERACION.ETAPA ET 
  WHERE UPPER(ET.DESCRIPCION) = 'CLIENTE-INSTALACION DE ACCESO PEX -FIBRA';
  
  INSERT INTO OPERACION.SGAT_EF_ETAPA_SRVC (EFESN_CODETA, EFESC_TIPPRC, EFESV_MODNEG, EFESN_ESTADO, EFESV_USUREG, EFESD_FECREG, EFESV_USUMOD, EFESD_FECMOD)
  VALUES (LN_CODETA, 'N', 'SA', 1, 'EASTULLE', SYSDATE, NULL, NULL);
  LN_CODETA:=0;
  /*Etapa 3*/
  SELECT ET.CODETA
  INTO LN_CODETA
  FROM OPERACION.ETAPA ET 
  WHERE UPPER(ET.DESCRIPCION) = 'CLIENTE-INSTALACION DE ACCESO PEX-MATERIAL';
  
  INSERT INTO OPERACION.SGAT_EF_ETAPA_SRVC (EFESN_CODETA, EFESC_TIPPRC, EFESV_MODNEG, EFESN_ESTADO, EFESV_USUREG, EFESD_FECREG, EFESV_USUMOD, EFESD_FECMOD)
  VALUES (LN_CODETA, 'N', 'SA', 1, 'EASTULLE', SYSDATE, NULL, NULL);
  LN_CODETA:=0;
  /*Etapa 4*/
  SELECT ET.CODETA
  INTO LN_CODETA
  FROM OPERACION.ETAPA ET 
  WHERE UPPER(ET.DESCRIPCION) = 'CLIENTE-INSTALACION DE EQUIPOS-MANO DE OBRA';
  
  INSERT INTO OPERACION.SGAT_EF_ETAPA_SRVC (EFESN_CODETA, EFESC_TIPPRC, EFESV_MODNEG, EFESN_ESTADO, EFESV_USUREG, EFESD_FECREG, EFESV_USUMOD, EFESD_FECMOD)
  VALUES (LN_CODETA, 'N', 'SA', 1, 'EASTULLE', SYSDATE, NULL, NULL);

  commit;	
END;
/
