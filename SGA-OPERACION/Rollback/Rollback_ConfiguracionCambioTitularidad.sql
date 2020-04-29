DECLARE
  lv_json VARCHAR2(2000);
  ln_json NUMBER;
  lc_json CLOB;
  
  ln_idcab NUMBER;
  ln_idseq NUMBER;
BEGIN

  -- Cabecera
  
  SELECT idcab
    INTO ln_idcab
    FROM operacion.ope_cab_xml
   WHERE programa = 'change_ownership';

  UPDATE operacion.ope_cab_xml
     SET target_url = 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/subscribers/identifier/@f_CUSTOMERID',
         xmlclob    = '{}'
   WHERE programa = 'change_ownership';

  COMMIT;

  lv_json := '{
  "firstName":"@f_firstName",
  "lastName":"@f_lastName"
}';

  ln_json := LENGTH(lv_json);

  SELECT xmlclob
    INTO lc_json
    FROM operacion.ope_cab_xml
   WHERE programa = 'change_ownership'
     FOR UPDATE;

  dbms_lob.write(lc_json, ln_json, 1, lv_json);

  COMMIT;

  --Rollback tiptra_escenario
	DELETE FROM sgacrm.ft_tiptra_escenario
	WHERE tiptra=611 AND tipsrv='TODO' AND idcab=ln_idcab AND escenario=1;
	COMMIT;
	
  --Rollback ope_det_xml
  DELETE FROM operacion.ope_det_xml 
  WHERE idcab=ln_idcab AND campo='X-Internal' 
  AND nombrecampo='SELECT ''TRUE'' FROM dummy_ope' AND tipo=3 AND estado=1;
  COMMIT;

  DELETE FROM operacion.ope_det_xml
  WHERE idcab=ln_idcab AND campo='f_old_customerID' AND tipo=4 AND estado=1 AND orden=1;
  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 7, orden = 1
   WHERE idcab = ln_idcab
     AND campo = 'f_CUSTOMERID';
  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 4, orden = 2
   WHERE idcab = ln_idcab
     AND campo = 'f_firstName';
  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 4, orden = 3
   WHERE idcab = ln_idcab
     AND campo = 'f_lastName';
  COMMIT;
  
END;
