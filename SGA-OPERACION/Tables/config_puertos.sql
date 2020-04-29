-- Create table

create table OPERACION.config_puertos
( 
  id_config       number(10) not null,                    
  idunico         VARCHAR2(20) null,
  id_servicio     varchar2(10) null,
  descripcion     VARCHAR2(350) null,  
  id_abrev    varchar2(5) null,
  estado          NUMBER(1) null,
  servicio_abrev VARCHAR2(50),
  usucre          VARCHAR2(30) default USER,
  usumod          VARCHAR2(30),
  feccre          DATE default SYSDATE,
  fecmod          date
);

-- Add comments to the columns 
comment on column OPERACION.CONFIG_PUERTOS.id_config
  is 'Codigo de Configuracion';
comment on column OPERACION.CONFIG_PUERTOS.idunico
  is 'Identificador Unico';
comment on column OPERACION.CONFIG_PUERTOS.id_servicio
  is 'Codigo de Servicio';
comment on column OPERACION.CONFIG_PUERTOS.descripcion
  is 'Descripcion del Servicio';
comment on column OPERACION.CONFIG_PUERTOS.id_abrev
  is 'Codigo de Abreviacion';
comment on column OPERACION.CONFIG_PUERTOS.estado
  is 'Estado (0 - Inactivo / 1 - Activo)';
comment on column OPERACION.CONFIG_PUERTOS.servicio_abrev
  is 'Codigo de Servicio y Codigo de Abreviacion';  
comment on column OPERACION.CONFIG_PUERTOS.usucre
  is 'Usuario creacion';
comment on column OPERACION.CONFIG_PUERTOS.usumod
  is 'Usuario modificacion';
comment on column OPERACION.CONFIG_PUERTOS.feccre
  is 'Fecha creacion';
comment on column OPERACION.CONFIG_PUERTOS.fecmod
  is 'Fecha modificacion';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CONFIG_PUERTOS
  add constraint PK_CONFIG_PUERTOS primary key (id_config)
;
