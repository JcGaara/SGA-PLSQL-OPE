CREATE OR REPLACE TRIGGER OPERACION.SGATRI_MOTOTSUB
BEFORE INSERT ON OPERACION.SGAT_MOTOTSUB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************
PROPOSITO:      Trigger Before Insert en Tabla SGAT_MOTOTSUB
REVISIONES:
Versión       Fecha          Autor               Descripción
-------       ----------     --------------      --------------------------------
1.0           07/02/2019     Jesús Holguín       LOG DE AUDITORIA SGAT_MOTOTSUB

**********************************************************************************/
DECLARE
l_evento      AUDITORIA.SGAT_LOG_AUDIT.logv_evento%type;
l_nomevento   AUDITORIA.SGAT_LOG_AUDIT.logv_nomevento%type;
l_transac     AUDITORIA.SGAT_LOG_AUDIT.logc_transac%type;
l_modulo      AUDITORIA.SGAT_LOG_AUDIT.logv_modulo%type;
l_estado      AUDITORIA.SGAT_LOG_AUDIT.LOGC_FLGESTADO%type;
l_msgerror    AUDITORIA.SGAT_LOG_AUDIT.LOGV_MSGERROR%type;

CURSOR c_temp IS SELECT OWNER, TABLE_NAME, COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='OPERACION' AND TABLE_NAME = 'SGAT_MOTOTSUB';

BEGIN
       l_evento         :=     'Motivo y submotivo';
       l_nomevento      :=     'Registro Nuevo';
       l_transac        :=     'INSERT PK:'||:new.MOTON_SUBMOTOT;
       l_modulo         :=     'SGA Ventas';
       l_estado         :=     'C';
       l_msgerror       :=     '';

    IF :new.MOTON_SUBMOTOT IS NULL THEN
       select OPERACION.SGASEQ_MOTOTSUB.nextval into :new.MOTON_SUBMOTOT from dual;
    END IF;

    FOR c IN c_temp LOOP

         IF (c.COLUMN_NAME='MOTON_CODMOTOT')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODMOTOT, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTON_SUBMOTOT')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_SUBMOTOT, l_estado, l_msgerror);
         END IF;
         
         IF (c.COLUMN_NAME='MOTOV_CODGESTION')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_CODGESTION, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTOV_DESCRIPCION')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_DESCRIPCION, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTOV_DESCRIP_NOTAS')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTOV_DESCRIP_NOTAS, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTON_TIPTRS')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_TIPTRS, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTON_TIPTRA')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_TIPTRA, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTON_CODCASE')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODCASE, l_estado, l_msgerror);
         END IF;

         IF (c.COLUMN_NAME='MOTON_CODTYPEATENTION')  THEN
           AUDITORIA.PKG_log_auditoria.SGASI_LOG_AUDIT(l_evento, l_nomevento,
            OPERACION.PKG_SIGCORP.SGAFUN_USUARIOOPE(USER), l_modulo, c.OWNER,
            C.TABLE_NAME, c.COLUMN_NAME, l_transac, :new.MOTON_CODTYPEATENTION, l_estado, l_msgerror);
         END IF;

    END LOOP;
    
END;
/
