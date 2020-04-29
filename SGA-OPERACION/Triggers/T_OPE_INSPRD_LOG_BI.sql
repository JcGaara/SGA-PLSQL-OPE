CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INSPRD_LOG_BI
BEFORE INSERT
ON OPERACION.OPE_INSPRD_LOG
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_INSPRD_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        05/07/2010  Alexander Yong   Creacion --Rq. 134083
  ***********************************************************************************************/
DECLARE

BEGIN

  IF :NEW.IDLOG IS NULL THEN
    SELECT SQ_OPE_INSPRD_LOG_IDLOG.nextval INTO :NEW.idlog FROM DUMMY_OPE;
  END IF;

END;
/



