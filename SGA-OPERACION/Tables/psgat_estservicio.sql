-- Create table
create table OPERACION.PSGAT_ESTSERVICIO
(
  essev_cod_operacion VARCHAR2(15) not null,
  essen_cod_solot     NUMBER(8) not null,
  essev_customer_id   NUMBER not null,
  essen_co_id         NUMBER not null,
  essen_cod_cli       CHAR(8) not null,
  essev_mensaje       VARCHAR2(500),
  essev_descripcion   VARCHAR2(100) not null,
  essev_operacion     VARCHAR2(30) not null,
  essev_estado        VARCHAR2(20) not null,
  essen_n_reenvio     NUMBER not null,
  essen_n_reenvio_max NUMBER not null,
  essed_ult_fec_reenv DATE,
  essev_usuario_crea  VARCHAR2(30) default USER not null,
  essed_fecha_crea    DATE default SYSDATE not null,
  essev_usuario_modi  VARCHAR2(30),
  essed_fecha_modi    DATE
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
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_cod_operacion
  is 'Cod. de tipo de operacion  JN: Janus, IL: Instants Link, CX: Conax';
comment on column OPERACION.PSGAT_ESTSERVICIO.essen_cod_solot
  is 'Cod. SOT';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_customer_id
  is 'Cod. cliente sisact';
comment on column OPERACION.PSGAT_ESTSERVICIO.essen_co_id
  is 'Cod. contrato';
comment on column OPERACION.PSGAT_ESTSERVICIO.essen_cod_cli
  is 'Cod. cliente sga';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_mensaje
  is 'Mensaje';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_descripcion
  is 'Descripción del servicio';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_operacion
  is 'Descripción de la opción del sistema';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_estado
  is 'Estado del servicio';
comment on column OPERACION.PSGAT_ESTSERVICIO.essen_n_reenvio
  is 'Numero de reenvio';
comment on column OPERACION.PSGAT_ESTSERVICIO.essen_n_reenvio_max
  is 'Numero maximo de reenvio';
comment on column OPERACION.PSGAT_ESTSERVICIO.essed_ult_fec_reenv
  is 'Fecha de ultimo reenvio';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_usuario_crea
  is 'Usuario de creacion del registro';
comment on column OPERACION.PSGAT_ESTSERVICIO.essed_fecha_crea
  is 'Fecha de creacion del registro';
comment on column OPERACION.PSGAT_ESTSERVICIO.essev_usuario_modi
  is 'Usuario que hizo la  ultima modificacion del registro';
comment on column OPERACION.PSGAT_ESTSERVICIO.essed_fecha_modi
  is 'Fecha de modificacion de ultima del registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.PSGAT_ESTSERVICIO
  add constraint PK_PSGAT_ESTSERVICIO primary key (ESSEV_COD_OPERACION, ESSEN_COD_SOLOT)
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