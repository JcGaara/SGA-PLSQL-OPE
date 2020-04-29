CREATE OR REPLACE TRIGGER OPERACION.T_OPE_RANGO_AIUD
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_RANGO
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       15/06/2012  Edilberto Astulle PROY_3433_AgendamientoenLineaOperaciones
  ***********************************************************/

DECLARE
  V_ACCION       CHAR(1);
  N_IDLOG          NUMBER;

  BEGIN

   SELECT HISTORICO.SQ_OPE_RANGO_LOG.NEXTVAL INTO N_IDLOG FROM dummy_ope;

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO HISTORICO.OPE_RANGO_log(
         ID_LOG,
  ID_RANGO   ,
  TIEMPO   ,
  TIPTRA   ,
  CODUBI   ,
  FLG_ACTIVO,
  ACC_LOG
      ) VALUES (
   N_IDLOG,
  :NEW.ID_RANGO   ,
  :NEW.TIEMPO   ,
  :NEW.TIPTRA   ,
  :NEW.CODUBI   ,
  :NEW.FLG_ACTIVO,
         V_ACCION);
   ELSIF UPDATING THEN
         V_ACCION := 'U';
         INSERT INTO HISTORICO.OPE_RANGO_log(
         ID_LOG,
  ID_RANGO   ,
  TIEMPO   ,
  TIPTRA   ,
  CODUBI   ,
  FLG_ACTIVO, ACC_LOG
      ) VALUES (
         N_IDLOG,
  :OLD.ID_RANGO   ,
  :OLD.TIEMPO   ,
  :OLD.TIPTRA   ,
  :OLD.CODUBI   ,
  :OLD.FLG_ACTIVO,
         V_ACCION);
    ELSIF DELETING THEN
         V_ACCION := 'D';
         INSERT INTO HISTORICO.OPE_RANGO_log(
         ID_LOG,
  ID_RANGO   ,
  TIEMPO   ,
  TIPTRA   ,
  CODUBI   ,
  FLG_ACTIVO,
  ACC_LOG
      ) VALUES (
         N_IDLOG,
  :OLD.ID_RANGO   ,
  :OLD.TIEMPO   ,
  :OLD.TIPTRA   ,
  :OLD.CODUBI   ,
  :OLD.FLG_ACTIVO,
         V_ACCION);

      END IF;
END;
/