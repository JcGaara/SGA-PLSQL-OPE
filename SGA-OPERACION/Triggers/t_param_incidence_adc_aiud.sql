CREATE OR REPLACE TRIGGER operacion.t_param_incidence_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.parametro_incidence_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:      t_param_incidence_adc_aiud
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
	SELECT historico.seq_param_incidence_adc_log.nextval
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
		INSERT INTO historico.parametro_incidence_adc_log
		  (	idlog,
			codincidence,
			subtipo_orden, 
			fecha_programacion,
			franja, 
			idbucket, 
			plano, 
			feccre,
			usucre,
			ipcre,
			usulog,
			feclog,
			accion)
		VALUES
		  (ln_id,
		   :new.codincidence,
		   :new.subtipo_orden, 
		   :new.fecha_programacion,
		   :new.franja, 
		   :new.idbucket, 
		   :new.plano, 
		   :new.feccre,
		   :new.usucre,
		   :new.ipcre,
		   lc_usuario_log,
		   SYSDATE,
		   lc_accion);

	ELSIF deleting THEN
		lc_accion := 'd';
		INSERT INTO historico.parametro_incidence_adc_log
		  (	idlog,
			codincidence,
			subtipo_orden, 
			fecha_programacion,
			franja, 
			idbucket, 
			plano, 
			feccre,
			usucre,
			ipcre,
			usulog,
			feclog,
			accion)
		VALUES
		  (ln_id,
		   :old.codincidence,
		   :old.subtipo_orden, 
		   :old.fecha_programacion,
		   :old.franja, 
		   :old.idbucket, 
		   :old.plano, 
		   :old.feccre,
		   :old.usucre,
		   :old.ipcre,
		   lc_usuario_log,
		   SYSDATE,
		   lc_accion);
	END IF;
END;
/