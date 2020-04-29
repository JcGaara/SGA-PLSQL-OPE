CREATE OR REPLACE TRIGGER OPERACION.SGATRU_MOTOTSUB
AFTER UPDATE ON OPERACION.SGAT_MOTOTSUB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger After Update en Tabla SGAT_MOTOTSUB
REVISIONES:
Versión       Fecha          Autor               Descripción
-------       ----------     --------------      --------------------------------
1.0           07/02/2019     Jesús Holguin       LOG DE AUDITORIA SGAT_MOTOTSUB

**********************************************************************************/
DECLARE
l_evento      AUDITORIA.SGAT_LOG_AUDIT.logv_evento%type;
l_nomevento   AUDITORIA.SGAT_LOG_AUDIT.logv_nomevento%type;
l_transac     AUDITORIA.SGAT_LOG_AUDIT.logc_transac%type;
l_modulo      AUDITORIA.SGAT_LOG_AUDIT.logv_modulo%type;
l_estado      AUDITORIA.SGAT_LOG_AUDIT.logc_flgestado%type;
l_msgerror    AUDITORIA.SGAT_LOG_AUDIT.logv_msgerror%type;

CURSOR c_temp IS SELECT OWNER, TABLE_NAME, COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER = 'OPERACION' AND TABLE_NAME = 'SGAT_MOTOTSUB';

BEGIN
  l_evento    := 'Motivo y submotivo';
  l_nomevento := 'Registro Modificado';
  l_transac   := 'UPDATE PK:'||:new.MOTON_SUBMOTOT;
  l_modulo    := 'SGA Ventas';
  l_estado    := 'C';
  l_msgerror  := '';
  
  IF :new.MOTON_SUBMOTOT IS NULL THEN
    l_estado  :='F';
    l_msgerror:='Error en general PK';
  END IF;
  
    FOR c IN c_Temp LOOP
        
      IF (c.COLUMN_NAME = 'MOTON_SUBMOTOT' AND UPDATING('MOTON_SUBMOTOT')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_SUBMOTOT, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTON_CODMOTOT' AND UPDATING('MOTON_CODMOTOT')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODMOTOT, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOV_CODGESTION' AND UPDATING('MOTOV_CODGESTION')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_CODGESTION, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOV_DESCRIPCION' AND UPDATING('MOTOV_DESCRIPCION')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_DESCRIPCION, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOV_DESCRIP_NOTAS' AND UPDATING('MOTOV_DESCRIP_NOTAS')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_DESCRIP_NOTAS, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTON_TIPTRS' AND UPDATING('MOTON_TIPTRS')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_TIPTRS, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOV_USUREG' AND UPDATING('MOTOV_USUREG')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_USUREG, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOD_FECREG' AND UPDATING('MOTOD_FECREG')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOD_FECREG, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOV_USUMOD' AND UPDATING('MOTOV_USUMOD')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_USUMOD, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTOD_FECMOD' AND UPDATING('MOTOD_FECMOD')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOD_FECMOD, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTON_TIPTRA' AND UPDATING('MOTON_TIPTRA')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_TIPTRA, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTON_CODCASE' AND UPDATING('MOTON_CODCASE')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODCASE, l_estado, l_msgerror);
      END IF;
      
      IF (c.COLUMN_NAME = 'MOTON_CODTYPEATENTION' AND UPDATING('MOTON_CODTYPEATENTION')) THEN
         AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
         OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
         c.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODTYPEATENTION, l_estado, l_msgerror);
      END IF;
      
 	  END LOOP;
    
END;

/

