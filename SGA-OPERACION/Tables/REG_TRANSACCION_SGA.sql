-- Create table
create table OPERACION.REG_TRANSACCION_SGA
(
  idlog                 NUMBER not null,
  proceso_descripcion   VARCHAR2(100),
  procedure_descripcion VARCHAR2(100),
  cantidad_registros    NUMBER,
  registros_correctos   NUMBER,
  registros_incorrectos NUMBER,
  codusu                VARCHAR2(30) default user,
  fecusu                DATE default sysdate,
  idproceso             NUMBER,
  ipapp                 VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp            VARCHAR2(30) default user,
  pcapp                 VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPERACION.REG_TRANSACCION_SGA
  is 'Tabla de registro de transacciones del SGA';
-- Add comments to the columns 
comment on column OPERACION.REG_TRANSACCION_SGA.idlog
  is 'Identificador unico de la tabla';
comment on column OPERACION.REG_TRANSACCION_SGA.proceso_descripcion
  is ' Descripcion del Proceso del SGA ';
comment on column OPERACION.REG_TRANSACCION_SGA.procedure_descripcion
  is ' Descripcion del procedure del SGA ';
comment on column OPERACION.REG_TRANSACCION_SGA.cantidad_registros
  is ' Cantidad de Registros Procesados ';
comment on column OPERACION.REG_TRANSACCION_SGA.registros_correctos
  is ' Cantidad de Registros Procesados Correctamente ';
comment on column OPERACION.REG_TRANSACCION_SGA.registros_incorrectos
  is ' Cantidad de Registros Procesados con Error ';
comment on column OPERACION.REG_TRANSACCION_SGA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.REG_TRANSACCION_SGA.fecusu
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.REG_TRANSACCION_SGA.idproceso
  is 'ID de proceso';
comment on column OPERACION.REG_TRANSACCION_SGA.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.REG_TRANSACCION_SGA.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.REG_TRANSACCION_SGA.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.REG_TRANSACCION_SGA
  add constraint REG_TRANSACCION_SGA_PK primary key (IDLOG)
  using index 
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );