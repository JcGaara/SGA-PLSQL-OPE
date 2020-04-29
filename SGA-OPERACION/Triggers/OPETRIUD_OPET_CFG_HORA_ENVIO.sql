CREATE OR REPLACE TRIGGER "OPERACION"."OPETRIUD_OPET_CFG_HORA_ENVIO"
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.OPET_CFG_HORA_ENVIO REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/*'****************************************************************
'* Nombre SP         : OPETRIUD_OPET_CFG_HORA_ENVIO
'* Propósito         : Genera log de Tabla
'* Output            : Guarda informacion en la tabla log
'* Creado por        : Miriam Mandujano
'* Fec Creación      : 30/01/2013
'* Fec Actualización : 30/01/2013
'*****************************************************************/

DECLARE
v_accion varchar2(30);
BEGIN
  IF INSERTING THEN
     v_accion := 'I';
    INSERT INTO HISTORICO.OPET_CFG_HORA_ENVIO_LOG
    ( TIPO_ACC_LOG,
      CFGHN_IDCFGENV,
      CFGHN_IDCFG,
      CFGHD_HORAENV,
      CFGHN_ESTADO)
    VALUES
    ( v_accion,
      :NEW.CFGHN_IDCFGENV,
      :NEW.CFGHN_IDCFG,
      :NEW.CFGHD_HORAENV,
      :NEW.CFGHN_ESTADO);
  ELSIF UPDATING THEN
     v_accion := 'U';
    INSERT INTO HISTORICO.OPET_CFG_HORA_ENVIO_LOG
    ( TIPO_ACC_LOG,
      CFGHN_IDCFGENV,
      CFGHN_IDCFG,
      CFGHD_HORAENV,
      CFGHN_ESTADO)
    VALUES
    ( v_accion,
      :NEW.CFGHN_IDCFGENV,
      :NEW.CFGHN_IDCFG,
      :NEW.CFGHD_HORAENV,
      :NEW.CFGHN_ESTADO );
  ELSIF DELETING THEN
     v_accion := 'D';
    INSERT INTO HISTORICO.OPET_CFG_HORA_ENVIO_LOG
    ( TIPO_ACC_LOG,
      CFGHN_IDCFGENV,
      CFGHN_IDCFG,
      CFGHD_HORAENV,
      CFGHN_ESTADO)
    VALUES
    ( v_accion,
      :OLD.CFGHN_IDCFGENV,
      :OLD.CFGHN_IDCFG,
      :OLD.CFGHD_HORAENV,
      :OLD.CFGHN_ESTADO);
  END IF;
END;
/