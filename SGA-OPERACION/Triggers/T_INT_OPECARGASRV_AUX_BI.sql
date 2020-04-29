CREATE OR REPLACE TRIGGER OPERACION.T_INT_OPECARGASRV_AUX_BI
BEFORE INSERT
ON INT_OPECARGASRV_AUX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

  /******************************************************************************
     NAME:       T_INT_OPECARGASRV_AUX_BI
     Purpose:    Trigger
     Ver        Date        Author            Description
     ---------  ----------  ---------------   ------------------------------------
     1.0        29/09/2010  Ronal Corilloclla Versión Inicial: RQ142944
  *******************************************************************************/
DECLARE

  LN_ID NUMBER;

BEGIN
  if :new.IDDET is null then
    select MAX(D.IDDET) INTO LN_ID FROM INT_OPECARGASRV_AUX D;

    :NEW.IDDET := NVL(LN_ID, 0) + 1;
  end if;

END;
/



