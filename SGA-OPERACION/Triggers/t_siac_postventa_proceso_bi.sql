CREATE OR REPLACE TRIGGER OPERACION.T_SIAC_POSTVENTA_PROCESO_BI
  BEFORE INSERT ON OPERACION.SIAC_POSTVENTA_PROCESO
  REFERENCING OLD AS OLD NEW AS NEW 
  FOR EACH ROW 
  /***************************************************************************************************
    NAME:       OPERACION.T_CONFIG_BI
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          10/10/2013  Carlos Chamache  Req 164619 Proyecto Post venta HFC en SIAC
***************************************************************************************************/
BEGIN
  IF :NEW.IDPROCESS IS NULL THEN
    SELECT OPERACION.SQ_SIAC_POSTVENTA_PROCESO.NEXTVAL INTO :NEW.IDPROCESS FROM dual;
  END IF;
END;
/