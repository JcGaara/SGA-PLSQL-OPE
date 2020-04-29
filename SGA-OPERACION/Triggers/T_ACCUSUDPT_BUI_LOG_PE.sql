CREATE OR REPLACE TRIGGER OPERACION.T_ACCUSUDPT_BUI_LOG_PE
   BEFORE UPDATE OR INSERT ON OPERACION.ACCUSUDPT
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
/****************************************************************
   Descripcion: Actualiza las columnas de Auditoria
   - FECMOD = SYSDATE, USUMOD = USER-Usuario.OS

   Fecha       Autor            Descripcion
   ----------  ---------------  ---------------------------------
   23/12/2004  Sistemas Peru    Creacion
*****************************************************************/
   L_USUARIO_LOG VARCHAR2(100);
BEGIN
   SELECT MAX(osuser) INTO L_USUARIO_LOG FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dual);
   L_USUARIO_LOG := trim(RPAD(USER||'-'||L_USUARIO_LOG,50));
   IF UPDATING THEN
      :NEW.FECMOD := SYSDATE;
      :NEW.USUMOD := L_USUARIO_LOG;
   ELSIF INSERTING THEN
      :NEW.FECUSU := SYSDATE;
      :NEW.USUREG := L_USUARIO_LOG;
   END IF;
END;
/



