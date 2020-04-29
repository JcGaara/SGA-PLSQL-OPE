-- Create table
create table OPERACION.SGAT_FAMILIA_TCRM
(
  idfamilia       NUMBER(4) not null,
  descripcion     VARCHAR2(100),
  tipo_tecnologia VARCHAR2(10),
  estado          NUMBER(1) default 0,
  ipcre           VARCHAR2(20) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  ipmod           VARCHAR2(20),
  fecre           DATE default sysdate,
  fecmod          DATE,
  usucre          VARCHAR2(30) default user,
  usumod          VARCHAR2(30)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 255
  maxtrans 255
  storage
  (
    initial 64K
    next 128K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPERACION.SGAT_FAMILIA_TCRM
  is 'Entidad guarda la configuraci�n de  familia servicios CRM';
-- Add comments to the columns 
comment on column OPERACION.SGAT_FAMILIA_TCRM.idfamilia
  is 'Identificador de familia CRM';
comment on column OPERACION.SGAT_FAMILIA_TCRM.descripcion
  is 'Descripci�n de la familia CRM';
comment on column OPERACION.SGAT_FAMILIA_TCRM.tipo_tecnologia
  is 'Tipo de tecnologia (HFC, DTH ... Otros )';
comment on column OPERACION.SGAT_FAMILIA_TCRM.estado
  is 'Estado';
comment on column OPERACION.SGAT_FAMILIA_TCRM.ipcre
  is 'IP creaci�n';
comment on column OPERACION.SGAT_FAMILIA_TCRM.ipmod
  is 'IP modificaci�n';
comment on column OPERACION.SGAT_FAMILIA_TCRM.fecre
  is 'Fecha de Creaci�n';
comment on column OPERACION.SGAT_FAMILIA_TCRM.fecmod
  is 'Fecha de modificaci�n';
comment on column OPERACION.SGAT_FAMILIA_TCRM.usucre
  is 'Usuario Creaci�n';
comment on column OPERACION.SGAT_FAMILIA_TCRM.usumod
  is 'Usuario Modificaci�n';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_FAMILIA_TCRM
  add constraint PK_FAMILIA primary key (IDFAMILIA)
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
