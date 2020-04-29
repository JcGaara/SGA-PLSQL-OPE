CREATE OR REPLACE TRIGGER OPERACION.T_OPE_TVSAT_ERROR_CONAX_MAE_BU
BEFORE UPDATE
ON OPERACION.OPE_TVSAT_ERROR_CONAX_MAE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TVSAT_ERROR_CONAX_MAE_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        10/08/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/



