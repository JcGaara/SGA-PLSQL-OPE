-- Create table
create table OPERACION.THCODSOLOT
(
  idproceso  NUMBER not null,
  id_tarea   NUMBER not null,
  estado     NUMBER,
  codsolot   NUMBER not null,
  fecstart   TIMESTAMP(6),
  fecfinish  TIMESTAMP(6),
  fecusu     DATE default sysdate,
  ipapp      VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp VARCHAR2(30) default user,
  pcapp      VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
comment on column OPERACION.THCODSOLOT.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.THCODSOLOT.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.THCODSOLOT.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.THCODSOLOT.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.THCODSOLOT
  add constraint PK_THCODSOLOT primary key (IDPROCESO, ID_TAREA, CODSOLOT)
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

