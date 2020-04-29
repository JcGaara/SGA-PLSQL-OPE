CREATE OR REPLACE TRIGGER OPERACION.T_OPE_CARGA_INICIAL_TMP_BI
  BEFORE INSERT ON OPERACION.OPE_CARGA_INICIAL_TMP
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

    /******************************************************************************
     NAME:       SALES.T_OPE_CARGA_INICIAL_TMP_BI
     Purpose:    Trigger
     Ver         Date        Author           Solicitado por     Description
     ---------  ----------  ---------------   --------------     ----------------------
     1.0        07/09/2011  Widmer Quispe     Jose Ramos         Versión Inicial
  *******************************************************************************/
DECLARE
  LN_ID NUMBER;
BEGIN

  IF :new.IDCARGAINICIAL IS NULL THEN
    SELECT MAX(T.IDCARGAINICIAL) INTO LN_ID FROM OPE_CARGA_INICIAL_TMP T;

    :new.IDCARGAINICIAL := NVL(LN_ID, 0) + 1;

  END IF;

END;
/



