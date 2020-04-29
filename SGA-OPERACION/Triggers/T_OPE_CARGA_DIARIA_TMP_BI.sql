CREATE OR REPLACE TRIGGER OPERACION.T_OPE_CARGA_DIARIA_TMP_BI
  BEFORE INSERT ON OPERACION.OPE_CARGA_DIARIA_TMP
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

    /******************************************************************************
     NAME:       SALES.T_OPE_CARGA_INICIAL_TMP_BI
     Purpose:    Trigger
     Ver         Date        Author           Solicitado por     Description
     ---------  ----------  ---------------   --------------     ----------------------
     1.0        07/09/2011  Widmer Quispe     Jose Ramos         Versi�n Inicial
  *******************************************************************************/
DECLARE
  LN_ID NUMBER;
BEGIN

  IF :new.IDCARGADIARIA IS NULL THEN
    SELECT MAX(T.IDCARGADIARIA) INTO LN_ID FROM OPE_CARGA_DIARIA_TMP T;

    :new.IDCARGADIARIA := NVL(LN_ID, 0) + 1;

  END IF;

END;
/



