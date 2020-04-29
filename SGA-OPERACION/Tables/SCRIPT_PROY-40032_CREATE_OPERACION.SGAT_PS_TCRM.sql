-- Create table
create table OPERACION.SGAT_PS_TCRM
(
  idps            NUMBER(4) not null,
  codps           VARCHAR2(30),
  idfamillia      NUMBER(4),
  descripcion     VARCHAR2(100),
  principal       CHAR(1) default '1',
  tipsrv          VARCHAR2(4),
  idgrupo_sisact  VARCHAR2(4),
  codsrv          VARCHAR2(4),
  estado          NUMBER(1) default 0,
  ipcre           VARCHAR2(20) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  ipmod           VARCHAR2(20),
  fecre           DATE default sysdate,
  fecmod          DATE,
  usucre          VARCHAR2(30) default user,
  usumod          VARCHAR2(30),
  tipo_tecnologia VARCHAR2(10) not null
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
comment on table OPERACION.SGAT_PS_TCRM
  is 'Entidad guarda la configuracion de las PS configuradas en el Catalogo de Ericsson y su equivalencia con SGA';
-- Add comments to the columns 
comment on column OPERACION.SGAT_PS_TCRM.idps
  is 'Identificador de PS';
comment on column OPERACION.SGAT_PS_TCRM.codps
  is 'Código de PS enviado por CRM';
comment on column OPERACION.SGAT_PS_TCRM.idfamillia
  is 'Identificador de familia CRM';
comment on column OPERACION.SGAT_PS_TCRM.descripcion
  is 'Descripción de PS';
comment on column OPERACION.SGAT_PS_TCRM.principal
  is 'Indicador de Principal (0:No Prinicipal / 1:Principal )';
comment on column OPERACION.SGAT_PS_TCRM.tipsrv
  is 'Tipo de Servicio';
comment on column OPERACION.SGAT_PS_TCRM.idgrupo_sisact
  is 'Indicador de Grupo SISACT';
comment on column OPERACION.SGAT_PS_TCRM.codsrv
  is 'Codigo de Servicio asociado';
comment on column OPERACION.SGAT_PS_TCRM.estado
  is 'Estado';
comment on column OPERACION.SGAT_PS_TCRM.ipcre
  is 'IP creación';
comment on column OPERACION.SGAT_PS_TCRM.ipmod
  is 'IP modificación';
comment on column OPERACION.SGAT_PS_TCRM.fecre
  is 'Fecha de Creación';
comment on column OPERACION.SGAT_PS_TCRM.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.SGAT_PS_TCRM.usucre
  is 'Usuario Creación';
comment on column OPERACION.SGAT_PS_TCRM.usumod
  is 'Usuario Modificación';
comment on column OPERACION.SGAT_PS_TCRM.tipo_tecnologia
  is 'Tipo de tecnologia (HFC, DTH ... Otros )';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_PS_TCRM
  add constraint PK_PS primary key (IDPS, TIPO_TECNOLOGIA)
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
