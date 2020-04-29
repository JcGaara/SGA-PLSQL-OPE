CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SRV_RECARGA_DET_AIUD_LOG
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_SRV_RECARGA_DET
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW

 /**************************************************************************
   NOMBRE:     T_OPE_SRV_RECARGA_DET_AIUD_LOG
   PROPOSITO:  Auditoria

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        03/02/2010  Antonio Lagos     Creacion. REQ.106908,registro auditoria
   2.0        24/03/2010  Antonio Lagos     Creacion. REQ.119998,aumento de campos
   3.0        05/05/2010  Antonio Lagos     REQ-119999,se cambia el nombre del trigger
                                            y referencias a tabla recargaxinssrv_log por nuevo nombre
   **************************************************************************/
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);
ID     NUMBER(18);
BEGIN

   SELECT MAX(osuser) INTO V_USUARIO_LOG
      FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dummy_ope);

  --SELECT HISTORICO.SQ_RECARGAXINSSRV_LOG.NEXTVAL INTO ID FROM dummy_ope; --3.0
  SELECT HISTORICO.SQ_OPE_SRV_RECARGA_DET_LOG.NEXTVAL INTO ID FROM dummy_ope;--3.0

   V_USUARIO_LOG := trim(RPAD(USER||'-'||V_USUARIO_LOG,50));

   IF INSERTING THEN
      V_ACCION := 'I';
      --INSERT INTO HISTORICO.RECARGAXINSSRV_LOG( --3.0
      INSERT INTO HISTORICO.OPE_SRV_RECARGA_DET_LOG( --3.0
         id,
         numregistro,
         codinssrv,
         tipsrv,
         codsrv,
         fecact,
         fecbaja,
         pid, --2.0
         estado, --2.0
         ulttareawf, --2.0
         usulog,
         feclog,
         acclog
      ) VALUES (
         ID,
         :NEW.numregistro,
         :NEW.codinssrv,
         :NEW.tipsrv,
         :NEW.codsrv,
         :NEW.fecact,
         :NEW.fecbaja,
         :NEW.pid, --2.0
         :NEW.estado, --2.0
         :NEW.ulttareawf, --2.0
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION);
   ELSIF UPDATING OR DELETING THEN
      IF UPDATING THEN
         V_ACCION := 'U';
      ELSIF DELETING THEN
         V_ACCION := 'D';
      END IF;
      --INSERT INTO HISTORICO.RECARGAXINSSRV_LOG( --3.0
      INSERT INTO HISTORICO.OPE_SRV_RECARGA_DET_LOG( --3.0
         id,
         numregistro,
         codinssrv,
         tipsrv,
         codsrv,
         fecact,
         fecbaja,
         pid, --2.0
         estado, --2.0
         ulttareawf, --2.0
         usulog,
         feclog,
         acclog
      ) VALUES (
         ID,
         :OLD.numregistro,
         :OLD.codinssrv,
         :OLD.tipsrv,
         :OLD.codsrv,
         :OLD.fecact,
         :OLD.fecbaja,
         :NEW.pid, --2.0
         :NEW.estado, --2.0
         :NEW.ulttareawf, --2.0
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION );
   END IF;
END;
/



