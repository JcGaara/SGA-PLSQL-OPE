CREATE OR REPLACE TRIGGER OPERACION.T_OPE_PLANTILLASOT_BI
BEFORE INSERT
ON OPERACION.OPE_PLANTILLASOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            COLLECTIONS.T_OPE_PLANTILLASOT_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        20/04/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

begin

  IF :NEW.IDPLANSOT IS NULL THEN
    SELECT nvl(max(IDPLANSOT),0) + 1 INTO :NEW.IDPLANSOT FROM OPE_PLANTILLASOT;
  END IF;

END;
/



