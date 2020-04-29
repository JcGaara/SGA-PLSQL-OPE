CREATE OR REPLACE TRIGGER OPERACION.T_INT_OPECARGASRV_LOG_BI
  BEFORE INSERT ON INT_OPECARGASRV_LOG
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

    /******************************************************************************
     NAME:       T_INT_OPECARGASRV_LOG_BI
     Purpose:    Trigger
     Ver        Date        Author            Description
     ---------  ----------  ---------------   ------------------------------------
     1.0        04/10/2010  Ronal Corilloclla Versión Inicial RQ142944
  *******************************************************************************/
DECLARE
  num_id INT_OPECARGASRV_LOG.IDLOG%TYPE;
BEGIN

  IF :new.IDLOG IS NULL THEN
    select MAX(IDLOG) into num_id from INT_OPECARGASRV_LOG;

    :new.IDLOG := NVL(num_id, 0) + 1;
  END IF;

END;
/



