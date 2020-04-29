-- Create table
create table OPERACION.SGAT_TIPTRA_TIPORD_PEP
(
  id_tipo_orden    NUMBER(10) not null,
  id_subtipo_orden VARCHAR2(10) not null,
  tiptra           VARCHAR2(10) not null,
  indproc          VARCHAR2(1),
  estado           NUMBER(1) default 0,
  ipcre            VARCHAR2(20),
  ipmod            VARCHAR2(20),
  fecre            DATE default sysdate,
  fecmod           DATE default sysdate,
  usucre           VARCHAR2(30) default user,
  usumod           VARCHAR2(30) default user
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
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.id_tipo_orden
  is 'codigo secuencial';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.id_subtipo_orden
  is 'codigo del tipo de orden';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.tiptra
  is 'Codigo del tipo de trabajo';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.indproc
  is 'Indicador de Proceso para actualizar SOT en tabla AGENLIQ.SGAT_AGENDAD(T:todos los agendamiento, U:ultimo agendamiento,P:Primer agendamiento)';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.estado
  is 'acitvo = 1 , inactivo = 0';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.ipcre
  is 'ip de la pc que creo';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.ipmod
  is 'ip de la pc que modifico';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.fecre
  is 'fecha de la pc que creo';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.fecmod
  is 'fecha de la pc que modifico';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.usucre
  is 'usuario de la pc que creo';
comment on column OPERACION.SGAT_TIPTRA_TIPORD_PEP.usumod
  is 'usuario de la pc que modifico';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_TIPTRA_TIPORD_PEP
  add constraint PK_SGAT_TIPTRA_TIPORD_PEP primary key (ID_TIPO_ORDEN, ID_SUBTIPO_ORDEN, TIPTRA)
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
