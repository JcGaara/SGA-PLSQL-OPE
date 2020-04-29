-- Create table
create table OPERACION.SGA_LOG_REPROCESO
(
  slren_id_reproceso NUMBER not null,
  slren_secuencia    NUMBER not null,
  slren_id_solot     NUMBER not null,
  slren_id_agenda    NUMBER,
  slrev_des_error    VARCHAR2(1000),
  slrev_archivo      VARCHAR2(500),
  slrev_log_error    VARCHAR2(1000),
  soran_flag_proceso CHAR(1),
  sorad_fecha_reg    DATE default SYSDATE not null,
  sorav_usu_reg      VARCHAR2(30) default USER not null
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
comment on column OPERACION.SGA_LOG_REPROCESO.slren_id_reproceso
  is 'CODIGO REPROCESO DE LA TABLA';
comment on column OPERACION.SGA_LOG_REPROCESO.slren_secuencia
  is 'CODIGO SECUENCIAL';
comment on column OPERACION.SGA_LOG_REPROCESO.slren_id_solot
  is 'ID SOLOT';
comment on column OPERACION.SGA_LOG_REPROCESO.slren_id_agenda
  is 'ID AGENDA';
comment on column OPERACION.SGA_LOG_REPROCESO.slrev_des_error
  is 'DESCRIPCION DEL ERROR';
comment on column OPERACION.SGA_LOG_REPROCESO.slrev_archivo
  is 'DESCRIPCION DEL ARCHIVO';
comment on column OPERACION.SGA_LOG_REPROCESO.slrev_log_error
  is 'LOG DEL ERROR';
comment on column OPERACION.SGA_LOG_REPROCESO.soran_flag_proceso
  is 'FLAG DEL PROCESO';
comment on column OPERACION.SGA_LOG_REPROCESO.sorad_fecha_reg
  is 'FECHA DE REGISTRO ';
comment on column OPERACION.SGA_LOG_REPROCESO.sorav_usu_reg
  is 'USUARIO DE REGISTRO';

  