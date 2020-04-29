CREATE OR REPLACE TRIGGER "OPERACION"."T_OPE_TIPOMASIVASOT_MAE_BU"
  BEFORE UPDATE ON OPERACION.OPE_TIPOMASIVASOT_MAE
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TIPOMASIVASOT_MAE_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        08/11/2011  Keila Carpio     Creacion REQ 160732 Gestion de SOTs
  ***********************************************************************************************/

DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/
