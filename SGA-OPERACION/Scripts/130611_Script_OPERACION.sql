-- Add/modify columns 
alter table MARKETING.VTATABGEOREF add fecalta date ;
-- Add comments to the columns 
comment on column MARKETING.VTATABGEOREF.fecalta
  is 'Fecha de Alta del Plano';


-- Add/modify columns 
alter table MARKETING.VTATABGEOREF add USUALTA varchar2(30);
-- Add comments to the columns 
comment on column MARKETING.VTATABGEOREF.USUALTA
  is 'Usuario Libero Plano';


-- Add/modify columns 
alter table OPERACION.OPE_SP_MAT_EQU_CAB add FECPENDIENTE date;
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.FECPENDIENTE
  is 'Fecha de cambio de estado a Pendiente';
