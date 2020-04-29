CREATE OR REPLACE TRIGGER OPERACION.T_OPE_HORAXCUADRILLA_DET_AIUD
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_HORAXCUADRILLA_DET
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

   SELECT HISTORICO.SQ_OPE_HORAXCUADRILLA_DET_LOG.NEXTVAL INTO N_IDLOG FROM dummy_ope;

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO HISTORICO.OPE_HORAXCUADRILLA_DET_LOG(
         ID_LOG,
  ID_OPE_CUADRILLAXDISTRITO_DET ,
  DIA  ,
  HORA ,
  ACTIVO ,
  ACC_LOG
      ) VALUES (
         N_IDLOG,
  :new.ID_OPE_CUADRILLAXDISTRITO_DET ,
  :new.DIA  ,
  :new.HORA ,
  :new.ACTIVO ,
         V_ACCION);
   ELSIF UPDATING THEN
         V_ACCION := 'U';
         INSERT INTO HISTORICO.OPE_HORAXCUADRILLA_DET_LOG(
         ID_LOG,
  ID_OPE_CUADRILLAXDISTRITO_DET ,
  DIA  ,
  HORA ,
  ACTIVO ,
  ACC_LOG
      ) VALUES (
         N_IDLOG,
         :OLD.ID_OPE_CUADRILLAXDISTRITO_DET,
         :OLD.dia,
         :OLD.HORA,
         :OLD.ACTIVO,
         V_ACCION);
    ELSIF DELETING THEN
         V_ACCION := 'D';
         INSERT INTO HISTORICO.OPE_HORAXCUADRILLA_DET_LOG(
         ID_LOG,
  ID_OPE_CUADRILLAXDISTRITO_DET ,
  DIA  ,
  HORA ,
  ACTIVO ,
  ACC_LOG
      ) VALUES (
         N_IDLOG,
         :OLD.ID_OPE_CUADRILLAXDISTRITO_DET,
         :OLD.dia,
         :OLD.HORA,
         :OLD.ACTIVO,
         V_ACCION);

      END IF;
END;
/