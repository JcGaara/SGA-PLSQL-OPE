CREATE OR REPLACE TRIGGER OPERACION.T_OPE_TVSAT_SLTD_DET_BI
BEFORE INSERT
ON OPERACION.OPE_TVSAT_SLTD_DET
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_TVSAT_SLTD_DET_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        15/07/2010  Mariela Aguirre     Creacion REQ 114326
  ***********************************************************************************************/
DECLARE

BEGIN

  IF :NEW.IDSOLDET IS NULL THEN
    SELECT SQ_OPE_TVSAT_SLTD_DET_IDSOLDET.nextval INTO :NEW.IDSOLDET FROM DUMMY_OPE;
  END IF;

END;
/



