CREATE OR REPLACE TRIGGER OPERACION.T_OPE_AGENDA_MASIVA_REG_BU
  BEFORE UPDATE ON operacion.OPE_AGENDA_MASIVA_REG
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_OPE_AGENDA_MASIVA_REG_BU
   PROPOSITO:  Actualizar informacion de la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        29/04/2010  Antonio Lagos     Creacion. REQ.119999
   **************************************************************************/
DECLARE

BEGIN
  :new.usumod := user;
  :new.fecmod := sysdate;
END;
/



