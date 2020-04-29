CREATE OR REPLACE TRIGGER "OPERACION"."T_OPE_MASIVASOT_DET_BI"
  BEFORE INSERT ON OPERACION.OPE_MASIVASOT_DET
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_MASIVASOT_DET_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        08/11/2011  Keila Carpio     Creacion REQ 160732 Gestion de SOTs
  ***********************************************************************************************/

DECLARE

BEGIN
  IF :NEW.IDDETMASIVA IS NULL OR :NEW.IDDETMASIVA = 0 THEN
	select OPERACION.SQ_OPE_MASIVASOT_DET.nextval
      	into :NEW.IDDETMASIVA
      	from OPERACION.dummy_ope;
  END IF;
END;
/
