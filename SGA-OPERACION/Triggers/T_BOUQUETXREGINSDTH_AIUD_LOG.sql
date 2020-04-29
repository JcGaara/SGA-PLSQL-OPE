CREATE OR REPLACE TRIGGER OPERACION.T_BOUQUETXREGINSDTH_AIUD_LOG
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.BOUQUETXREGINSDTH
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       01/08/2012  Hector Huaman   SD-117369, registro en log
  ***********************************************************/
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);
ID     NUMBER(18);
BEGIN

   SELECT MAX(osuser) INTO V_USUARIO_LOG
      FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dummy_ope);

   SELECT HISTORICO.SQ_BOUQUETXREGINSDTH_LOG.NEXTVAL INTO ID FROM dummy_ope;

   V_USUARIO_LOG := trim(RPAD(USER||'-'||V_USUARIO_LOG,50));

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO HISTORICO.BOUQUETXREGINSDTH_LOG(
         id,
         NUMREGISTRO,
         CODSRV,
         BOUQUETS,
         TIPO,
         ESTADO,
         CODUSU,
         FECUSU,
         FLG_TRANSFERIR,
         FECULTENV,
         USUMOD,
         FECMOD,
         FECHA_INICIO_VIGENCIA,
         FECHA_FIN_VIGENCIA,
         IDCUPON,
         FLG_INSTANTANEA,
         IDGRUPO,
         PID,
         USULOG,
         FECLOG,
         ACCLOG
      ) VALUES (
         ID,
         :NEW.NUMREGISTRO,
         :NEW.CODSRV,
         :NEW.BOUQUETS,
         :NEW.TIPO,
         :NEW.ESTADO,
         :NEW.CODUSU,
         :NEW.FECUSU,
         :NEW.FLG_TRANSFERIR,
         :NEW.FECULTENV,
         :NEW.USUMOD,
         :NEW.FECMOD,
         :NEW.FECHA_INICIO_VIGENCIA,
         :NEW.FECHA_FIN_VIGENCIA,
         :NEW.IDCUPON,
         :NEW.FLG_INSTANTANEA,
         :NEW.IDGRUPO,
         :NEW.PID,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION
         );
   ELSIF UPDATING OR DELETING THEN
      IF UPDATING THEN
         V_ACCION := 'U';
      ELSIF DELETING THEN
         V_ACCION := 'D';
      END IF;
      INSERT INTO HISTORICO.BOUQUETXREGINSDTH_LOG(
         id,
         NUMREGISTRO,
         CODSRV,
         BOUQUETS,
         TIPO,
         ESTADO,
         CODUSU,
         FECUSU,
         FLG_TRANSFERIR,
         FECULTENV,
         USUMOD,
         FECMOD,
         FECHA_INICIO_VIGENCIA,
         FECHA_FIN_VIGENCIA,
         IDCUPON,
         FLG_INSTANTANEA,
         IDGRUPO,
         PID,
         USULOG,
         FECLOG,
         ACCLOG
      ) VALUES (
         ID,
         :OLD.NUMREGISTRO,
         :OLD.CODSRV,
         :OLD.BOUQUETS,
         :OLD.TIPO,
         :OLD.ESTADO,
         :OLD.CODUSU,
         :OLD.FECUSU,
         :OLD.FLG_TRANSFERIR,
         :OLD.FECULTENV,
         :OLD.USUMOD,
         :OLD.FECMOD,
         :OLD.FECHA_INICIO_VIGENCIA,
         :OLD.FECHA_FIN_VIGENCIA,
         :OLD.IDCUPON,
         :OLD.FLG_INSTANTANEA,
         :OLD.IDGRUPO,
         :OLD.PID,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION
         );
   END IF;
END;
/
