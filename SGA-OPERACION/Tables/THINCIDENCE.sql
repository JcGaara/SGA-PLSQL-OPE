-- Create table
create table OPERACION.THINCIDENCE
(
  idproceso    NUMBER not null,
  id_tarea     NUMBER not null,
  estado       NUMBER,
  codincidence NUMBER not null,
  fecusu       DATE default SYSDATE,
  usuarioapp   VARCHAR2(30) default user,
  ipapp        VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcapp        VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
comment on column OPERACION.THINCIDENCE.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.THINCIDENCE.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.THINCIDENCE.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.THINCIDENCE.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.THINCIDENCE
  add constraint PK_THINCIDENCE primary key (IDPROCESO, ID_TAREA, CODINCIDENCE)
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

