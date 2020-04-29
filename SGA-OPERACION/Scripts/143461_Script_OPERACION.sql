-- Add/modify columns 
alter table OPERACION.OPE_EQU_IW add OBJETOIW VARCHAR2(4000);
alter table OPERACION.OPE_EQU_IW add ERROR VARCHAR2(400);
-- Add comments to the columns 
comment on column OPERACION.OPE_EQU_IW.OBJETOIW
  is 'Objeto IW';
comment on column OPERACION.OPE_EQU_IW.ERROR
  is 'Error del ws';
