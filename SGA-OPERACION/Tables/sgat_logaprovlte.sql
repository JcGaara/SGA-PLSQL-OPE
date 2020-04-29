-- Create table
create table OPERACION.SGAT_LOGAPROVLTE
(
  logan_id           NUMBER not null,
  logan_cod_id       NUMBER not null,
  logad_fecha_reg    DATE not null,
  logad_fecha_ejec   DATE,
  logav_estado       VARCHAR2(20) not null,
  logan_estado_solot NUMBER not null,
  logan_codsolot     NUMBER(8) not null,
  logav_descripcion  VARCHAR2(200),
  logav_tipo_trans   VARCHAR2(10) not null,
  logav_est_log      CHAR(1) default 0,
  logav_usuario_crea VARCHAR2(30) default USER not null,
  logad_fecha_crea   DATE default SYSDATE not null,
  logav_usuario_modi VARCHAR2(30),
  logad_fecha_modi   DATE
)
partition by range (LOGAD_FECHA_CREA)
(
  partition P_LOGPROLTE_201611 values less than (TO_DATE(' 2016-12-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
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
    ),
  partition P_LOGPROLTE_201612 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
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
    )
);
-- Add comments to the columns 
comment on column OPERACION.SGAT_LOGAPROVLTE.logan_id
  is 'Cod. secuencial ';
comment on column OPERACION.SGAT_LOGAPROVLTE.logan_cod_id
  is 'Cod. contrato';
comment on column OPERACION.SGAT_LOGAPROVLTE.logad_fecha_reg
  is 'Fecha de registro';
comment on column OPERACION.SGAT_LOGAPROVLTE.logad_fecha_ejec
  is 'Fecha ejecucion';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_estado
  is 'Estado del servicio';
comment on column OPERACION.SGAT_LOGAPROVLTE.logan_estado_solot
  is 'Estado de solot ';
comment on column OPERACION.SGAT_LOGAPROVLTE.logan_codsolot
  is 'Cod. SOT';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_descripcion
  is 'Descripcion del log';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_tipo_trans
  is 'Tipo de Transacción';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_usuario_crea
  is 'Usuario que realizo la creacion del registro';
comment on column OPERACION.SGAT_LOGAPROVLTE.logad_fecha_crea
  is 'Fecha de creacion del registro';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_usuario_modi
  is 'Usuario que realizo la modificacion del registro';
comment on column OPERACION.SGAT_LOGAPROVLTE.logad_fecha_modi
  is 'Fecha de modificacion del registro';
comment on column OPERACION.SGAT_LOGAPROVLTE.logav_est_log
  is 'Estado del Log:  1: Activo y 0 :Inactivo';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_LOGAPROVLTE
  add constraint PK_SGAT_LOGAPROVLTE primary key (LOGAN_ID)
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