CREATE OR REPLACE TRIGGER OPERACION.T_OPE_PARAMETROS_GLOBALES_BU
BEFORE UPDATE
ON OPERACION.OPE_PARAMETROS_GLOBALES_AUX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.OPE_PARAMETROS_GLOBALES_AUX
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        27/05/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/



