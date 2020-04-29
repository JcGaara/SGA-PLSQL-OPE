CREATE OR REPLACE TRIGGER OPERACION.T_OPE_TVSAT_SLTD_CAB_BU
BEFORE UPDATE
ON OPERACION.OPE_TVSAT_SLTD_CAB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TVSAT_SLTD_CAB_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        25/05/2010  Miguel Aro�e     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;

END;
/



