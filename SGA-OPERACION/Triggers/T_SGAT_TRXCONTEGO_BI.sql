CREATE OR REPLACE TRIGGER OPERACION.T_SGAT_TRXCONTEGO_BI
  BEFORE INSERT ON OPERACION.SGAT_TRXCONTEGO
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /***************************************************************************************************
    NAME:       OPERACION.T_SGAT_TRXCONTEGO_BI
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------  --------------------------------------------------------
    1.0          17/08/2017  Jose Arriola   PROY-29955 Alineacion CONTEGO - Correlativo
***************************************************************************************************/
BEGIN
  IF :NEW.TRXN_IDTRANSACCION IS NULL THEN
    SELECT OPERACION.SGASEQ_CONTEGO.NEXTVAL INTO :NEW.TRXN_IDTRANSACCION FROM DUAL;
  END IF;
END;
/