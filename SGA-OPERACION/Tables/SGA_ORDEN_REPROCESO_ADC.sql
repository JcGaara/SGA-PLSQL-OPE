-- Create table
create table OPERACION.SGA_ORDEN_REPROCESO_ADC
(
  soran_id_reproceso NUMBER not null,
  soran_secuencia    NUMBER not null,
  soran_id_solot     NUMBER not null,
  soran_archivo      VARCHAR2(500) not null,
  soran_flag_proceso CHAR(1),
  sorad_fecha_reg    DATE default SYSDATE not null,
  sorav_usu_reg      VARCHAR2(30) default USER not null,
  sorad_fecha_modi   DATE,
  sorav_usu_modi     VARCHAR2(30)
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
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.soran_id_reproceso
  is 'CODIGO ID PROCESO';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.soran_secuencia
  is 'CODIGO SECUENCIA';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.soran_id_solot
  is 'CODIGO ID SOT';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.soran_archivo
  is 'ARCHIVO A PROCESAR';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.soran_flag_proceso
  is 'FLAG DEL PROCESO';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.sorad_fecha_reg
  is 'FECHA DE REGISTRO ';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.sorav_usu_reg
  is 'USUARIO DE REGISTRO';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.sorad_fecha_modi
  is 'FECHA DE MODIFICACIÓN DEL REGISTRO';
comment on column OPERACION.SGA_ORDEN_REPROCESO_ADC.sorav_usu_modi
  is 'USUARIO DE MODIFICACIÓN';
