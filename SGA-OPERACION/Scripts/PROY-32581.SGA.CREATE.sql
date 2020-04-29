/*****Creación de tablas*****/

-- Create table
create table OPERACION.SGA_VISITA_TECNICA_CE
(
  numslc_new   VARCHAR2(10),
  numslc_old   VARCHAR2(10),
  codcli       VARCHAR2(8),
  idpaq        NUMBER(10),
  iddet        NUMBER(10),
  codsrv       VARCHAR2(4),
  tipsrv       VARCHAR2(4),
  codequcom    VARCHAR2(4),
  codtipequ    VARCHAR2(15),
  tipequ       VARCHAR2(6),
  dscequ       VARCHAR2(100),
  tipmaterial  VARCHAR2(50),
  qtysold      NUMBER(10),
  bandwidth    NUMBER(10),
  tipproducto  VARCHAR2(50),
  tipservicio  VARCHAR2(50),
  tiptrx       VARCHAR2(50),
  tipslc       VARCHAR2(50),
  usureg       VARCHAR2(50) default user,
  fecreg       DATE default sysdate,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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

-- Create/Recreate indexes 
create index OPERACION.IDX_SGA_VISITA_TEC_CE on OPERACION.SGA_VISITA_TECNICA_CE (NUMSLC_NEW)
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

-- Create table
create table OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
(
  prorn_id                NUMBER not null,
  prorv_numslc_new        VARCHAR2(10),
  prorv_numslc_ori        VARCHAR2(10),
  prorv_codcli            VARCHAR2(8),
  prorv_codsuc            VARCHAR2(10),
  prorv_cod_tipo_orden    VARCHAR2(10),
  prorv_cod_subtipo_orden VARCHAR2(10),
  prorv_anotacion         VARCHAR2(500),
  prorv_telfcontacto      VARCHAR2(9),
  prorv_idplano           VARCHAR2(10),
  prord_fecprogram        DATE,
  prorv_usureg            VARCHAR2(50) default user not null,
  prord_fecreg            DATE default sysdate not null
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
comment on table OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
  is 'Tabla de registro de la asociación del nuevo proyecto con el proyecto origen';

-- Add comments to the columns 
comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorn_id
  is 'Identificador unico de la tabla';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_numslc_new
  is 'Numero de Proyecto nuevo';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_numslc_ori
  is 'Numero de Proyecto de origen';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_codcli
  is 'Codigo de cliente';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_codsuc
  is 'Codigo de sucursal';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_cod_tipo_orden
  is 'Codigo de tipo de orden';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_cod_subtipo_orden
  is 'Codigo de subtipo de orden';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_anotacion
  is 'Anotaciones';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_telfcontacto
  is 'Telefono de contacto';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_idplano
  is 'Id de plano';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prord_fecprogram
  is 'Fecha de programacion';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prorv_usureg
  is 'Usuario de creacion del registro';

comment on column OPERACION.SGAT_POSTV_PROYECTO_ORIGEN.prord_fecreg
  is 'Fecha de creacion del resgitro';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
  add constraint PK_SGAT_POSTV_PROYECTO_ORIGEN primary key (PRORN_ID)
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

-- Create table
create table OPERACION.SGAT_POSTVENTASCE_LOG
(
  postn_id           NUMBER not null,
  postv_numslc       VARCHAR2(10),
  postv_codcli       VARCHAR2(8),
  postv_proceso      VARCHAR2(100),
  postv_msgerror     VARCHAR2(4000),
  postv_usureg       VARCHAR2(50) default user not null,
  postd_fecreg       DATE default sysdate not null,
  postv_ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  postv_pcaplicacion VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
comment on table OPERACION.SGAT_POSTVENTASCE_LOG
  is 'Tabla de registro de log de errores Transacciones PostVenta de Claro Empresa';

-- Add comments to the columns 
comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postn_id
  is 'Identificador unico de la tabla';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_numslc
  is 'Numero de Proyecto';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_codcli
  is 'Codigo de cliente';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_msgerror
  is 'Texto descriptivo de error';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_usureg
  is 'Usuario de creacion del registro';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postd_fecreg
  is 'Fecha de creacion del resgitro';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_ipaplicacion
  is 'IP Aplicacion';

comment on column OPERACION.SGAT_POSTVENTASCE_LOG.postv_pcaplicacion
  is 'PC Aplicacion';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_POSTVENTASCE_LOG
  add constraint PK_POSTVENTASCE_LOG primary key (POSTN_ID)
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
