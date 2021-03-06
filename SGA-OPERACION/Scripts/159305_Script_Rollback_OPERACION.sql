-- Drop columns 
alter table OPERACION.SOLOT drop column resumen;
alter table OPERACION.SOLOT drop column cod_id;
-- ELIMINAR SEQUENCE
DROP SEQUENCE OPERACION.SQ_TRS_INTERFACE_IW;
DROP SEQUENCE OPERACION.SQ_TRS_INTERFACE_IW_LOG;

-- ELIMINAR TABLA
DROP TABLE OPERACION.INT_PARAMETRO;
DROP TABLE OPERACION.OPE_RESERVAHFC_BSCS;
DROP TABLE OPERACION.TRS_INTERFACE_IW;
DROP TABLE OPERACION.LOG_TRS_INTERFACE_IW;
DROP TABLE OPERACION.TRS_INTERFACE_IW_DET;

-- Drop columns 
alter table OPERACION.SOLOTPTO drop column segment_name;
alter table OPERACION.SOLOTPTO drop column cell_id;

-- Drop columns 
alter table OPERACION.AGENDAMIENTO drop column CODMOTIVO_TC;
alter table OPERACION.AGENDAMIENTO drop column CODMOTIVO_CO;

drop package OPERACION.PQ_IW_SGA_BSCS;
commit;