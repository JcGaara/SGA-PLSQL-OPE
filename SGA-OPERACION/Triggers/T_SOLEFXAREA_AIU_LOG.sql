CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_AIU_LOG
   AFTER INSERT OR UPDATE
   ON OPERACION.SOLEFXAREA
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);

BEGIN
   SELECT MAX(osuser) INTO V_USUARIO_LOG
      FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dual);

   V_USUARIO_LOG := trim(RPAD(USER||'-'||V_USUARIO_LOG,50));

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO OPERACION.SOLEFXAREA_AUTO_LOG(
         codef,
         area,
         numslc,
         estsolef,
         esresponsable,
         usulog,
         feclog,
         acclog
      ) VALUES (
         :NEW.codef,
         :NEW.area,
         :NEW.numslc,
         :NEW.estsolef,
         :NEW.esresponsable,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION );
   ELSIF UPDATING THEN
      IF UPDATING THEN
         V_ACCION := 'U';
      END IF;
      INSERT INTO OPERACION.SOLEFXAREA_AUTO_LOG(
         codef,
         area,
         numslc,
         estsolef,
         esresponsable,
         usulog,
         feclog,
         acclog
      ) VALUES (
         :NEW.codef,
         :NEW.area,
         :NEW.numslc,
         :NEW.estsolef,
         :NEW.esresponsable,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION );
   END IF;
END;
/



