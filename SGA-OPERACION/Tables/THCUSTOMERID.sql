-- Create table
create table OPERACION.THCUSTOMERID
(
  idproceso   NUMBER not null,
  id_tarea    NUMBER not null,
  estado      NUMBER,
  customer_id NUMBER not null,
  fecstart    TIMESTAMP(6),
  fecfinish   TIMESTAMP(6),
  fecusu      DATE default SYSDATE,
  usuarioapp  VARCHAR2(30) default user,
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
-- Add comments to the columns 
comment on column OPERACION.THCUSTOMERID.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.THCUSTOMERID.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.THCUSTOMERID.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.THCUSTOMERID.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.THCUSTOMERID
  add constraint PK_THCUSTOMERID primary key (IDPROCESO, ID_TAREA, CUSTOMER_ID)
  using index 
  tablespace OPERACION_DAT
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
