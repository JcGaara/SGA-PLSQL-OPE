CREATE OR REPLACE TRIGGER OPERACION.T_INT_OPERACION_TAREADEF_BU
 BEFORE UPDATE ON operacion.INT_OPERACION_TAREADEF
FOR EACH ROW
BEGIN
   :new.usumod := user;
   :new.fecmod := sysdate;

END;
/


