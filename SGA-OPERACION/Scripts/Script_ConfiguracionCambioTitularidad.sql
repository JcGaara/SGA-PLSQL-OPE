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
     SET target_url = 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/accounts',
         xmlclob    = '{}'
   WHERE programa = 'change_ownership';

  COMMIT;

  lv_json := '{
	"from":
	{
		"identifier":"@f_old_customerID",
		"subscribers": 
		[
			{
				"identifier":"@f_old_customerID"
			}
		]
	},
	
	"to":
	{
		"identifier": "@f_customerID",
		"subscribers": 
		[
			{
				"firstName":"@f_firstName",
				"identifier":"@f_customerID",
				"lastName":"@f_lastName"
			}
		]
	}
}';

  ln_json := LENGTH(lv_json);

  SELECT xmlclob
    INTO lc_json
    FROM operacion.ope_cab_xml
   WHERE programa = 'change_ownership'
     FOR UPDATE;

  dbms_lob.write(lc_json, ln_json, 1, lv_json);

  COMMIT;

  -- Detalle

  SELECT MAX(idseq) + 1 INTO ln_idseq FROM operacion.ope_det_xml;

  INSERT INTO operacion.ope_det_xml
    (idcab, idseq, campo, nombrecampo, tipo, estado, orden, descripcion)
  VALUES
    (ln_idcab,
     ln_idseq,
     'X-Internal',
     'SELECT ''TRUE'' FROM dummy_ope',
     3,
     1,
     NULL,
     NULL);

  COMMIT;

  SELECT MAX(idseq) + 1 INTO ln_idseq FROM operacion.ope_det_xml;

  INSERT INTO operacion.ope_det_xml
    (idcab, idseq, campo, nombrecampo, tipo, estado, orden, descripcion)
  VALUES
    (ln_idcab, ln_idseq, 'f_old_customerID', NULL, 4, 1, 1, NULL);

  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 4, orden = 2
   WHERE idcab = ln_idcab
     AND campo = 'f_CUSTOMERID';

  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 4, orden = 3
   WHERE idcab = ln_idcab
     AND campo = 'f_firstName';

  COMMIT;

  UPDATE operacion.ope_det_xml
     SET tipo = 4, orden = 4
   WHERE idcab = ln_idcab
     AND campo = 'f_lastName';

  COMMIT;
	--cambio de titularidad
	insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
	values(611,'TODO',ln_idcab,1);
  COMMIT;
END;
