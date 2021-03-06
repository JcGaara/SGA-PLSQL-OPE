CREATE OR REPLACE TRIGGER "OPERACION"."T_OPE_TIPOMASIVASOT_MAE_BI" 
BEFORE INSERT
ON OPERACION.OPE_TIPOMASIVASOT_MAE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TIPOMASIVASOT_MAE_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        08/11/2011  Keila Carpio     Creacion REQ 160732 Gestion de SOTs
  ***********************************************************************************************/
DECLARE

BEGIN
  IF :NEW.IDTIPO IS NULL OR :NEW.IDTIPO = 0 THEN
    select OPERACION.SQ_OPE_TIPOMASIVASOT_MAE.nextval into :NEW.IDTIPO from OPERACION.dummy_ope;
  END IF;
END;
/
