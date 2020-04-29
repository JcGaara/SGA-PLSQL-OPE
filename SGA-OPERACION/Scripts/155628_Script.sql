-- Add/modify columns 
alter table OPERACION.OPE_SP_MAT_EQU_CAB add FECPROCESO date;
alter table OPERACION.OPE_SP_MAT_EQU_CAB add FECAPROBADO date;
alter table OPERACION.OPE_SP_MAT_EQU_CAB add FECCONCLUIDO date;
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECPROCESO
  is 'Fecha en Proceso';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECAPROBADO
  is 'Fecha Aprobado';
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECCONCLUIDO
  is 'Fecha Concluido';