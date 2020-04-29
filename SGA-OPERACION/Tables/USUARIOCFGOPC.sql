-- Create table
create table OPERACION.USUARIOCFGOPC
(
  usuario      VARCHAR2(30) default USER not null,
  flag1        NUMBER(1) default 0,
  flag2        NUMBER(1) default 0,
  flag3        NUMBER(1) default 0,
  flag4        NUMBER(1) default 0,
  flag5        NUMBER(1) default 0,
  flag6        NUMBER(1) default 0,
  flag7        NUMBER(1) default 0,
  flag8        NUMBER(1) default 0,
  flag9        NUMBER(1) default 0,
  flag10       NUMBER(1) default 0,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp   VARCHAR2(30) default USER,
  fecusu       DATE default SYSDATE,
  pcaplicacion VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.USUARIOCFGOPC.usuario
  is 'Usuario SGA';
comment on column OPERACION.USUARIOCFGOPC.flag1
  is 'Carga de Columnas directa en control de tareas';
comment on column OPERACION.USUARIOCFGOPC.flag2
  is 'Flag 2';
comment on column OPERACION.USUARIOCFGOPC.flag3
  is 'Flag 3';
comment on column OPERACION.USUARIOCFGOPC.flag4
  is 'Flag 4';
comment on column OPERACION.USUARIOCFGOPC.flag5
  is 'Flag 5';
comment on column OPERACION.USUARIOCFGOPC.flag6
  is 'Flag 6';
comment on column OPERACION.USUARIOCFGOPC.flag7
  is 'Flag 7';
comment on column OPERACION.USUARIOCFGOPC.flag8
  is 'Flag 8';
comment on column OPERACION.USUARIOCFGOPC.flag9
  is 'Flag 9';
comment on column OPERACION.USUARIOCFGOPC.flag10
  is 'Flag 10';
comment on column OPERACION.USUARIOCFGOPC.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.USUARIOCFGOPC.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.USUARIOCFGOPC.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.USUARIOCFGOPC.pcaplicacion
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.USUARIOCFGOPC
  add constraint PK_USUARIOCFGOPC01 primary key (USUARIO)
  using index 
  tablespace OPERACION_DAT;
