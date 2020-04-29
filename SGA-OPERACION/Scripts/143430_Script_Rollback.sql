-- Drop TRIGGER 
DROP TRIGGER OPERACION.T_OPE_EQU_IW_BI;
-- Drop columns 
alter table OPERACION.OPE_EQU_IW drop column ID_SEQ;
alter table OPERACION.OPE_EQU_IW drop column EVENTO;
alter table OPERACION.OPE_EQU_IW drop column ESTADO;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_EQU_IW
  add constraint PK_EQU_IW_OPE primary key (ID_PRODUCTO, ID_INTERFASE, ID_CLIENTE);

DROP SEQUENCE OPERACION.SQ_OPE_EQU_IW;
