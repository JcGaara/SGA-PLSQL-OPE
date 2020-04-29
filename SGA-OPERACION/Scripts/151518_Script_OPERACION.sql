-- Add/modify columns 
alter table OPERACION.CFG_ENV_CORREO_CONTRATA add PUBLICA NUMBER default 0;
alter table OPERACION.CFG_ENV_CORREO_CONTRATA add TITULO VARCHAR2(100);
alter table OPERACION.CFG_ENV_CORREO_CONTRATA add DATAWINDOW VARCHAR2(100);
-- Add comments to the columns 
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.PUBLICA
  is 'Publica Reporte';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.TITULO
  is 'Titulo del Reporte';
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.DATAWINDOW
  is 'Datawindow';