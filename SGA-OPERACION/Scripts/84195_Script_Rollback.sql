--Eliminar Tabla
DROP TABLE OPERACION.CFG_ENV_CORREO_CONTRATA;
DROP TABLE OPERACION.CFG_ENV_CORREO_CONTRATA_DET;
DROP TABLE OPERACION.CFG_ENV_CORREO_CONTRATA_CON;
DROP TABLE HISTORICO.CFG_ENV_CORREO_CONTRATA_LOG;
DROP TABLE HISTORICO.CFG_ENV_CONTRATA_CON_LOG;
DROP TABLE HISTORICO.CFG_ENV_CONTRATA_DET_LOG;


--Eliminar Secuencial
DROP SEQUENCE OPERACION.SQ_CFG_ENV_CONTRATA;
DROP SEQUENCE OPERACION.SQ_CFG_ENV_CONTRATA_CON;
DROP SEQUENCE OPERACION.SQ_CFG_ENV_CONTRATA_DET;


-- Drop columns 
alter table OPERACION.DISTRITOXCONTRATA drop column CODCON_TPI;

UPDATE PAQUETE_vENTA SET DESC_OPERATIVA = NULL;

COMMIT;