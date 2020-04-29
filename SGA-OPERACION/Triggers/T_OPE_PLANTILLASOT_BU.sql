CREATE OR REPLACE TRIGGER OPERACION.T_OPE_PLANTILLASOT_BU
BEFORE UPDATE
ON OPERACION.OPE_PLANTILLASOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            COLLECTIONS.T_OPE_PLANTILLASOT_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        20/04/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/



