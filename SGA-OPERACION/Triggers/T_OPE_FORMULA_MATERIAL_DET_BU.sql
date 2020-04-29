CREATE OR REPLACE TRIGGER OPERACION.T_OPE_FORMULA_MATERIAL_DET_BU
  BEFORE UPDATE ON operacion.OPE_FORMULA_MATERIAL_DET
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_OPE_FORMULA_MATERIAL_DET_BU
   PROPOSITO:  Actualizar informacion de la tabla

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        03/05/2010  Antonio Lagos     Creacion. REQ.119999
   **************************************************************************/
DECLARE

BEGIN
  :new.usumod := user;
  :new.fecmod := sysdate;
END;
/



