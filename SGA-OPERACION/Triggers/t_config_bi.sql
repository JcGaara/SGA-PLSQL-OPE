CREATE OR REPLACE TRIGGER OPERACION.T_CONFIG_BI
  BEFORE INSERT ON OPERACION.CONFIG
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***************************************************************************************************
    NAME:       OPERACION.T_CONFIG_BI
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          18/09/2013  Carlos Chamache  Req 164619 Proyecto Post venta HFC en SIAC
***************************************************************************************************/
DECLARE
  id     number(15);
BEGIN
  SELECT OPERACION.SQ_CONFIG.NEXTVAL INTO id FROM dual;
  :new.IDCONF := id;
END;
/