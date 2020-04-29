CREATE OR REPLACE TRIGGER OPERACION.T_OPE_TVSAT_ARCHIVO_CAB_BU
BEFORE UPDATE
ON OPERACION.OPE_TVSAT_ARCHIVO_CAB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TVSAT_ARCHIVO_CAB_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/06/2010  Mariela Aguirre  Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/



