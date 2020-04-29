CREATE OR REPLACE TRIGGER operacion.t_zona_adc_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.zona_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_ZONA_ADC_AIUD
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
  SELECT historico.seq_zona_adc_log.nextval INTO ln_id FROM dual;

  SELECT MAX(osuser) INTO lc_usuario_log 
    FROM v$session 
   WHERE audsid = (SELECT USERENV('sessionid') FROM dual);

  lc_usuario_log := TRIM(RPAD(USER || '-' || lc_usuario_log, 50));

  IF inserting THEN
     lc_accion := 'i';
     INSERT INTO historico.zona_adc_log
      ( idlog,
        idzona,
        codzona,
        descripcion,
        estado,
        ipcre,
        ipmod,
        feccre,
        fecmod,
        usucre,
        usumod,
        usulog,
        feclog,
        acclog)
     VALUES
      (ln_id,
       :new.idzona,
       :new.codzona,
       :new.descripcion,
       :new.estado,
       :new.ipcre,
       :new.ipmod,
       :new.feccre,
       :new.fecmod,
       :new.usucre,
       :new.usumod,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  ELSIF updating OR deleting THEN
     IF updating THEN
        lc_accion := 'u';
     ELSIF deleting THEN
        lc_accion := 'd';
     END IF;
  
     INSERT INTO historico.zona_adc_log
     ( idlog,
        idzona,
        codzona,
        descripcion,
        estado,
        ipcre,
        ipmod,
        feccre,
        fecmod,
        usucre,
        usumod,
        usulog,
        feclog,
        acclog)
     VALUES
      (ln_id,
       :old.idzona,
       :old.codzona,
       :old.descripcion,
       :old.estado,
       :old.ipcre,
       :old.ipmod,
       :old.feccre,
       :old.fecmod,
       :old.usucre,
       :old.usumod,
       lc_usuario_log,
       SYSDATE,
       lc_accion);
  END IF;
END;
/
