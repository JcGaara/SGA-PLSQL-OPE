CREATE OR REPLACE TRIGGER "OPERACION"."T_OPE_MASIVASOT_CAB_BI"
  BEFORE INSERT ON OPERACION.OPE_MASIVASOT_CAB
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_MASIVASOT_CAB_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        08/11/2011  Keila Carpio     Creacion REQ 160732 Gestion de SOTs
  ***********************************************************************************************/

DECLARE
BEGIN
  IF :NEW.IDMASIVA IS NULL OR :NEW.IDMASIVA = 0 THEN
	select OPERACION.SQ_OPE_MASIVASOT_CAB.nextval
      	into :NEW.IDMASIVA
      	from OPERACION.dummy_ope;
  END IF;
END;
/
