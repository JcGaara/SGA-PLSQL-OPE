CREATE OR REPLACE TRIGGER OPERACION.T_OPE_TVSAT_SLTD_CAB_BI
BEFORE INSERT
ON OPERACION.OPE_TVSAT_SLTD_CAB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TVSAT_SLTD_CAB_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        25/05/2010  Miguel Aroñe     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  IF :NEW.IDSOL IS NULL THEN
    SELECT sq_ope_tvsat_sltd_cab_idsol.nextval INTO :NEW.IDSOL FROM DUMMY_OPE;
  END IF;

END;
/



