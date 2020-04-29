CREATE OR REPLACE TRIGGER operacion.t_matriz_incidence_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.matriz_incidence_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:      t_matriz_incidence_adc_aiud
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        16/03/2016  Jorge Rivas       Nalda Arotinco    PROY-22818 Adm Manejo de Cuadrillas
  ***********************************************************************************************************************************/
DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);

BEGIN
	SELECT historico.seq_matriz_incidence_adc_log.nextval
	  INTO ln_id
	  FROM dual;

	SELECT MAX(osuser)
	  INTO lc_usuario_log
	  FROM v$session
	 WHERE audsid = (SELECT userenv('sessionid') FROM dummy_atc);

	lc_usuario_log := TRIM(rpad(USER || '-' || lc_usuario_log, 50));

	IF inserting OR updating THEN
	IF inserting THEN
	  lc_accion := 'i';
	ELSIF updating THEN
	  lc_accion := 'u';
	END IF;
		INSERT INTO historico.matriz_incidence_adc_log
		  (	idlog,
			codsubtype,
			codinctype,
			codincdescription,
			codchannel,
			codtypeservice,
			codcase,
			estado,
			feccre,
			usucre,
			fecmod,
			usumod,
			ipcre,
			ipmod,
			feclog,
			usulog,
			accion			 
		  )
		VALUES
		  (ln_id,
		   :new.codsubtype,
		   :new.codinctype,
		   :new.codincdescription,
		   :new.codchannel,
		   :new.codtypeservice,
		   :new.codcase,
		   :new.estado,
		   :new.feccre,
		   :new.usucre,
		   :new.fecmod,
		   :new.usumod,
		   :new.ipcre,
		   :new.ipmod,   
		   SYSDATE,
		   lc_usuario_log,
		   lc_accion);
	ELSIF deleting THEN
	  lc_accion := 'd';
		INSERT INTO historico.matriz_incidence_adc_log
		  (	idlog,
			codsubtype,
			codinctype,
			codincdescription,
			codchannel,
			codtypeservice,
			codcase,
			estado,
			feccre,
			usucre,
			fecmod,
			usumod,
			ipcre,
			ipmod,
			feclog,
			usulog,
			accion			 
		  )
		VALUES
		  (ln_id,
		   :old.codsubtype,
		   :old.codinctype,
		   :old.codincdescription,
		   :old.codchannel,
		   :old.codtypeservice,
		   :old.codcase,
		   :old.estado,
		   :old.feccre,
		   :old.usucre,
		   :old.fecmod,
		   :old.usumod,
		   :old.ipcre,
		   :old.ipmod,   
		   SYSDATE,
		   lc_usuario_log,
		   lc_accion);
	END IF;
END;
/