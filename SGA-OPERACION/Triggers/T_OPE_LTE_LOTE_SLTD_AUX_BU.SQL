CREATE OR REPLACE TRIGGER OPERACION."T_OPE_LTE_LOTE_SLTD_AUX_BU"
BEFORE UPDATE
ON OPERACION.OPE_LTE_LOTE_SLTD_AUX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_LTE_LOTE_SLTD_AUX_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        10/06/2016  Dorian Sucasaca  SGA-SD-794552 	
  ***********************************************************************************************/

DECLARE

BEGIN
  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;
END;
/