CREATE OR REPLACE TRIGGER OPERACION.T_OPE_CARGASRV_AUX_BI
BEFORE INSERT
ON OPE_CARGASRV_AUX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

  /******************************************************************************
     NAME:       T_OPE_CARGASRV_AUX_BI
     Purpose:    Trigger
     Ver        Date        Author            Description
     ---------  ----------  ---------------   ------------------------------------
     1.0        28/09/2010  Ronal Corilloclla Versión Inicial: RQ142944
  *******************************************************************************/
DECLARE

  LN_ID NUMBER;

BEGIN
  if :new.IDDET is null then
    select MAX(D.IDDET)
      INTO LN_ID
      FROM OPE_CARGASRV_AUX D
     WHERE D.IDLOTE = :NEW.IDLOTE;

    :NEW.IDDET := NVL(LN_ID, 0) + 1;
  end if;

  :new.TRAMA := :NEW.CODINSSRV || '|' || :NEW.NROTARJETA || '|' ||
                :NEW.NTDIDE || '|' || :NEW.IDMOTIVO || '|' || :NEW.TIPOSOL || '|' ||
                :NEW.IDGRUPO || '|' || :NEW.USUARIO;

END;
/



