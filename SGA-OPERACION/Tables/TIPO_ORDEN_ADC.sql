-- Create table
create table OPERACION.TIPO_ORDEN_ADC
(
  id_tipo_orden number(10),
  cod_tipo_orden varchar2(10),
  descripcion   varchar2(100),
  tipo_tecnologia	VARCHAR2(10),
  estado        NUMBER(1) default 0,
  tipo_servicio VARCHAR2(30),  
  ipcre         varchar2(20),
  ipmod         varchar2(20),
  fecre         DATE default sysdate,
  fecmod        DATE,
  usucre        VARCHAR2(30) default user,
  usumod        varchar2(30)
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
comment on column OPERACION.tipo_orden_adc.id_tipo_orden  is 'codigo secuencial';
comment on column OPERACION.tipo_orden_adc.cod_tipo_orden  is 'codigo del tipo de orden';
comment on column OPERACION.tipo_orden_adc.descripcion  is 'nombre del tipo de orden';
  comment on column OPERACION.tipo_orden_adc.tipo_tecnologia  is 'Tipo de tecnologia (HFC, DTH ... Otros )';
comment on column OPERACION.tipo_orden_adc.estado  is 'acitvo = 1 , inactivo = 0';
comment on column OPERACION.tipo_orden_adc.ipcre  is 'ip de la pc que creo el tipo de orden';
comment on column OPERACION.tipo_orden_adc.ipmod  is 'ip de la pc que modifico el tipo de orden';
comment on column OPERACION.tipo_orden_adc.fecre  is 'fecha de la pc que creo el tipo de orden';
comment on column OPERACION.tipo_orden_adc.fecmod  is 'fecha de la pc que modifico el tipo de orden';
comment on column OPERACION.tipo_orden_adc.usucre  is 'usuario de la pc que creo el tipo de orden';
comment on column OPERACION.tipo_orden_adc.usumod  is 'usuario de la pc que modifico el tipo de orden';
-- Create/Recreate primary, unique and foreign key constraints
