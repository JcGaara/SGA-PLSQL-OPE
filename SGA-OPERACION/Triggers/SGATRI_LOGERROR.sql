CREATE OR REPLACE TRIGGER OPERACION.SGATRI_LOGERROR
  BEFORE INSERT on OPERACION.SGAT_LOGERR
  for each row
/***************************************************************************************************
      NAME:       OPERACION.SGATRI_LOGERROR
      REVISIONS:
      Ver          Date         Author          Description
      ---------    ----------  -------------  --------------------------------------------------------
      1.0          21/08/2017  Jose Arriola   PROY-29955 Alineacion CONTEGO - LOG
  ***************************************************************************************************/
DECLARE
  LN_LOGERRN_IDLOG NUMBER;
BEGIN
  IF :NEW.LOGERRN_IDLOG IS NULL THEN
    SELECT OPERACION.SGASEQ_LOGERR.NEXTVAL
      INTO LN_LOGERRN_IDLOG
      FROM DUMMY_OPE;
    :NEW.LOGERRN_IDLOG := LN_LOGERRN_IDLOG;
  END IF;
END;
/
