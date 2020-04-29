-- Add/modify columns 
alter table OPERACION.SOLOTPTOEQUCMP add IDSPCAB NUMBER;
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTOEQUCMP.IDSPCAB
  is 'ID de Solicitud de Pedidos';

-- Add/modify columns 
alter table OPERACION.EFPTOEQUCMP add IDSPCAB NUMBER;
-- Add comments to the columns 
comment on column OPERACION.EFPTOEQUCMP.IDSPCAB
  is 'ID de Solicitud de Pedidos';


alter table OPERACION.OPE_SP_MAT_EQU_CAB modify ESTADO default 0;
alter table OPERACION.OPE_SP_MAT_EQU_CAB modify SOLICITANTE default USER;

