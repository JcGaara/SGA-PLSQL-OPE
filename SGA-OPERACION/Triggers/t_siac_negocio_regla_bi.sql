CREATE OR REPLACE TRIGGER OPERACION.T_SIAC_NEGOCIO_REGLA_BI
  BEFORE INSERT ON OPERACION.SIAC_NEGOCIO_REGLA
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
  IF :NEW.IDREGLA IS NULL THEN
    SELECT OPERACION.SQ_SIAC_NEGOCIO_REGLA.NEXTVAL INTO :NEW.IDREGLA FROM dual;
  END IF;
END;
/