CREATE OR REPLACE TRIGGER operacion.t_parametro_det_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.parametro_det_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_PARAMETRO_DET_ADC_LOG_AIUD
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        18/08/2015  Jorge Rivas       Manuel Gallegos   PROY-17652 Adm Manejo de Cuadrillas
**********************************************************************************************************************************/
DECLARE
  lc_usuario_log VARCHAR2(100);
  lc_accion      CHAR(1);
  ln_id          NUMBER(20);
BEGIN
  SELECT historico.seq_parametro_det_adc_log.nextval INTO ln_id FROM dual;

  SELECT MAX(osuser) INTO lc_usuario_log 
    FROM v$session 
   WHERE audsid = (SELECT USERENV('sessionid') FROM dual);

  lc_usuario_log := TRIM(RPAD(USER || '-' || lc_usuario_log, 50));

  IF inserting THEN
     lc_accion := 'i';
     INSERT INTO historico.parametro_det_adc_log
      ( idlog,
        id_parametro,
        codigoc,
        codigon,
        descripcion,
        abreviatura,
        estado,
        feccre,
        usucre,
        fecmod,
        usumod,
        ipcre,
        ipmod,
        id_detalle,
        usulog,
        feclog,
        acclog)
     VALUES
      (ln_id,
       :new.id_parametro,
       :new.codigoc,
       :new.codigon,
       :new.descripcion,
       :new.abreviatura,
       :new.estado,
       :new.feccre,
       :new.usucre,
       :new.fecmod,
       :new.usumod,
	     :new.ipcre,
	     :new.ipmod,
	     :new.id_detalle,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF updating OR deleting THEN
     IF updating THEN
        lc_accion := 'u';
     ELSIF deleting THEN
        lc_accion := 'd';
     END IF;
  
     INSERT INTO historico.parametro_det_adc_log
      ( idlog,
        id_parametro,
        codigoc,
        codigon,
        descripcion,
        abreviatura,
        estado,
        feccre,
        usucre,
        fecmod,
        usumod,
        ipcre,
        ipmod,
        id_detalle,
        usulog,
        feclog,
        acclog)
     VALUES
      (ln_id,
       :old.id_parametro,
       :old.codigoc,
       :old.codigon,
       :old.descripcion,
       :old.abreviatura,
       :old.estado,
       :old.feccre,
       :old.usucre,
       :old.fecmod,
       :old.usumod,
	     :old.ipcre,
	     :old.ipmod,
	     :old.id_detalle,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  END IF;
END;
/
