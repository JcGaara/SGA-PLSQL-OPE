CREATE OR REPLACE TRIGGER OPERACION.T_CFG_ENV_CONTRATA_DET_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.CFG_ENV_CORREO_CONTRATA_DET REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_CFG_ENV_CONTRATA_DET_AIUD
   PROPOSITO:  Genera log de Tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/04/2012  Edilberto Astulle
   **************************************************************************/

DECLARE
v_accion varchar2(30);
BEGIN
  IF INSERTING THEN
     v_accion := 'I';
    INSERT INTO HISTORICO.CFG_ENV_CONTRATA_DET_LOG
     ( IDCFGDET,
    IDCFGCON,
    CORREO,
    ESTADO,
    FECUSU,
    CODUSU,
    TIPO_ACC_LOG)
    VALUES
     (:NEW.IDCFGDET,
    :NEW.IDCFGCON,
    :NEW.CORREO,
    :NEW.ESTADO,
    :NEW.FECUSU,
    :NEW.CODUSU,
      v_accion);
  ELSIF UPDATING THEN
     v_accion := 'U';
    INSERT INTO HISTORICO.CFG_ENV_CONTRATA_DET_LOG
    ( IDCFGDET,
    IDCFGCON,
    CORREO,
    ESTADO,
    FECUSU,
    CODUSU,
    TIPO_ACC_LOG)
    VALUES
     (:NEW.IDCFGDET,
    :NEW.IDCFGCON,
    :NEW.CORREO,
    :NEW.ESTADO,
    :NEW.FECUSU,
    :NEW.CODUSU,
      v_accion);  
  ELSIF DELETING THEN
     v_accion := 'D';
    INSERT INTO HISTORICO.CFG_ENV_CONTRATA_DET_LOG
    ( IDCFGDET,
    IDCFGCON,
    CORREO,
    ESTADO,
    FECUSU,
    CODUSU,
    TIPO_ACC_LOG)
    VALUES
     (:OLD.IDCFGDET,
    :OLD.IDCFGCON,
    :OLD.CORREO,
    :OLD.ESTADO,
    :OLD.FECUSU,
    :OLD.CODUSU,
      v_accion);  
  END IF;
END;
/
