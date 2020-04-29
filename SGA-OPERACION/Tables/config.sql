-- Create table
create table OPERACION.CONFIG
(
  idconf      NUMBER not null,
  key_master  VARCHAR2(30) not null,
  description VARCHAR2(100) not null
);
-- Add comments to the columns 
comment on column OPERACION.CONFIG.idconf
  is 'Identificador de Configuracion';
comment on column OPERACION.CONFIG.key_master
  is 'Cabecera';
comment on column OPERACION.CONFIG.description
  is 'Descripcion de la Cabecera';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CONFIG
  add constraint CONFIG_PK primary key (IDCONF);
alter table OPERACION.CONFIG
  add constraint UN_CONFIG unique (KEY_MASTER);
