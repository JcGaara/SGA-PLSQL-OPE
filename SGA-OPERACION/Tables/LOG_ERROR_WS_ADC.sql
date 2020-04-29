-- Create table
create table OPERACION.LOG_ERROR_WS_ADC
(
  tipo_trs     VARCHAR2(30),
  idagenda     NUMBER(8),
  iderror      VARCHAR2(6),
  mensajeerror VARCHAR2(2000),
  ip           VARCHAR2(30),
  feccrea      DATE default sysdate,
  usucrea      VARCHAR2(30) default user
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
comment on column OPERACION.LOG_ERROR_WS_ADC.tipo_trs
  is 'Tipo de Transaccion';
comment on column OPERACION.LOG_ERROR_WS_ADC.idagenda
  is 'Código de Agenda';
comment on column OPERACION.LOG_ERROR_WS_ADC.iderror
  is 'Indicador de Error';
comment on column OPERACION.LOG_ERROR_WS_ADC.mensajeerror
  is 'Mensaje de Error';
comment on column OPERACION.LOG_ERROR_WS_ADC.ip
  is 'Ip';
comment on column OPERACION.LOG_ERROR_WS_ADC.feccrea
  is 'Fecha Creacion';
comment on column OPERACION.LOG_ERROR_WS_ADC.usucrea
  is 'Usuario Creacion';