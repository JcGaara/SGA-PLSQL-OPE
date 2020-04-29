CREATE OR REPLACE TRIGGER OPERACION.T_CONFIG_PUERTOS_BI
  BEFORE INSERT ON OPERACION.CONFIG_PUERTOS
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

DECLARE
  ln_id_config   operacion.CONFIG_PUERTOS.id_config%type;
BEGIN
  IF :new.id_config IS NULL THEN
    SELECT operacion.seq_config_puertos.nextval
      INTO ln_id_config
      FROM dual;

     :new.id_config := ln_id_config;

  END IF;
END;
/