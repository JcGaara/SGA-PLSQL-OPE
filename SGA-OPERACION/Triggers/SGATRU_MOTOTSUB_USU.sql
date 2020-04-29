CREATE OR REPLACE TRIGGER OPERACION.SGATRU_MOTOTSUB_USU
AFTER UPDATE ON OPERACION.SGAT_MOTOTSUB_USUARIO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger After Update en Tabla SGAT_MOTOTSUB
REVISIONES:
Versión       Fecha          Autor               Descripción
-------       ----------     --------------      --------------------------------
1.0           16/08/2019     Wilfredo Argote       LOG DE AUDITORIA SGAT_MOTOTSUB_USUARIO

**********************************************************************************/
DECLARE
l_evento      AUDITORIA.SGAT_LOG_AUDIT.logv_evento%type;
l_nomevento   AUDITORIA.SGAT_LOG_AUDIT.logv_nomevento%type;
l_transac     AUDITORIA.SGAT_LOG_AUDIT.logc_transac%type;
l_modulo      AUDITORIA.SGAT_LOG_AUDIT.logv_modulo%type;
l_estado      AUDITORIA.SGAT_LOG_AUDIT.logc_flgestado%type;
l_msgerror    AUDITORIA.SGAT_LOG_AUDIT.logv_msgerror%type;

CURSOR c_temp IS SELECT OWNER, TABLE_NAME, COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER = 'OPERACION' AND TABLE_NAME = 'SGAT_MOTOTSUB_USUARIO';

BEGIN
  l_evento    := 'Motivo y submotivo';
  l_nomevento := 'Registro Modificado';
  l_transac   := 'UPDATE PK:'||:new.MOTUN_SUBMOTOT;
  l_modulo    := 'SGA Ventas';
  l_estado    := 'C';
  l_msgerror  := '';

 /* IF :new.MOTON_SUBMOTOT IS NULL THEN
    l_estado  :='F';
    l_msgerror:='Error en general PK';
  END IF;*/

    FOR c IN c_Temp LOOP
      IF (c.COLUMN_NAME = 'MOTUV_REGION' AND UPDATING('MOTUV_REGION')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUV_REGION, l_estado, l_msgerror);
      END IF;
      IF (c.COLUMN_NAME = 'MOTUN_CODMOTOT' AND UPDATING('MOTUN_CODMOTOT')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUN_CODMOTOT, l_estado, l_msgerror);
      END IF;

      IF (c.COLUMN_NAME = 'MOTUN_SUBMOTOT' AND UPDATING('MOTUN_SUBMOTOT')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUN_SUBMOTOT, l_estado, l_msgerror);
      END IF;
      IF (c.COLUMN_NAME = 'MOTUV_USUREG' AND UPDATING('MOTUV_USUREG')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUV_USUREG, l_estado, l_msgerror);
      END IF;

      IF (c.COLUMN_NAME = 'MOTUD_FECREG' AND UPDATING('MOTUD_FECREG')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUD_FECREG, l_estado, l_msgerror);
      END IF;

      IF (c.COLUMN_NAME = 'MOTUV_USUMOD' AND UPDATING('MOTUV_USUMOD')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUV_USUMOD, l_estado, l_msgerror);
      END IF;

      IF (c.COLUMN_NAME = 'MOTUD_FECMOD' AND UPDATING('MOTUD_FECMOD')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTUD_FECMOD, l_estado, l_msgerror);
      END IF;
     END LOOP;
END;
/
