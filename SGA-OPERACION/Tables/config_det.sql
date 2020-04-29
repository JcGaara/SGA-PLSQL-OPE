-- Create table
create table OPERACION.CONFIG_DET
(
  idconf      NUMBER not null,
  key_detail  VARCHAR2(30) not null,
  value       VARCHAR2(4000),
  description VARCHAR2(100),
  status      NUMBER
);
-- Add comments to the columns 
comment on column OPERACION.CONFIG_DET.idconf
  is 'Identificador de Configuracion';
comment on column OPERACION.CONFIG_DET.key_detail
  is 'Detalle';
comment on column OPERACION.CONFIG_DET.value
  is 'Valor del Detalle';
comment on column OPERACION.CONFIG_DET.description
  is 'Descripcion del Detalle';
comment on column OPERACION.CONFIG_DET.status
  is '1:Activo; 0: Inactivo';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CONFIG_DET
  add constraint CONFIG_DET_PK primary key (IDCONF, KEY_DETAIL);
alter table OPERACION.CONFIG_DET
  add constraint CONFIG_DET_FK foreign key (IDCONF)
  references OPERACION.CONFIG (IDCONF);
