-- Drop columns 
alter table OPERACION.SOLOTPTOEQUCMP drop column IDSPCAB;
-- Drop columns 
alter table OPERACION.EFPTOEQUCMP drop column IDSPCAB;

alter table OPERACION.OPE_SP_MAT_EQU_CAB modify ESTADO default 1;
-- Add/modify columns 
alter table OPERACION.OPE_SP_MAT_EQU_CAB modify SOLICITANTE default null;