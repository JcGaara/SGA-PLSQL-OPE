CREATE OR REPLACE TRIGGER OPERACION.SGATRU_SGAT_USU_DW
AFTER UPDATE ON OPERACION.SGAT_USU_DW
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

DECLARE
l_evento    AUDITORIA.SGAT_LOG_AUDIT.logv_evento%type;
l_nomevento AUDITORIA.SGAT_LOG_AUDIT.logv_nomevento%type;
l_modulo     AUDITORIA.SGAT_LOG_AUDIT.logv_modulo%type;
l_transac   AUDITORIA.SGAT_LOG_AUDIT.logc_transac%type;
l_estado	AUDITORIA.SGAT_LOG_AUDIT.LOGC_FLGESTADO%type;
l_msgerror	AUDITORIA.SGAT_LOG_AUDIT.LOGV_MSGERROR%type;

CURSOR c_temp IS SELECT COLUMN_NAME ,OWNER, TABLE_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='OPERACION' AND TABLE_NAME = 'SGAT_USU_DW';

BEGIN
	l_evento    := 'DW Dinamico';
	l_nomevento := 'Registro Modificado';
	l_transac   := 'UPDATE PK:'||:new.USUDV_USUARIO;
	l_modulo    := 'SGA Operaciones';
	l_estado    := 'C';
	l_msgerror  :='';
  
	IF :new.USUDV_USUARIO IS NULL THEN
		l_estado   :='F';
		l_msgerror :='Error en generar PK';
	END IF;

	FOR c IN c_temp LOOP

		IF (c.COLUMN_NAME = 'USUDV_USUARIO' AND UPDATING('USUDV_USUARIO')) THEN
			AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
				OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
			  c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.USUDV_USUARIO, l_estado, l_msgerror);
		END IF;

		IF (c.COLUMN_NAME = 'USUDN_ACTIVO' AND UPDATING('USUDN_ACTIVO')) THEN
			AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
				OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
				c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.USUDN_ACTIVO, l_estado, l_msgerror);
		END IF;

  END LOOP;

END;
/