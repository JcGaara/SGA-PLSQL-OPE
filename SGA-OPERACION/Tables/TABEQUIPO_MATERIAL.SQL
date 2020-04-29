-- Create table
create table OPERACION.TABEQUIPO_MATERIAL
(
  IDEQUIPO     NUMBER(11) not null,
  NUMERO_SERIE VARCHAR2(50) not null,
  IMEI_ESN_UA  VARCHAR2(50) not null,
  TIPO         NUMBER(11) not null,
  CODALMACEN   VARCHAR2(20) not null,
  ESTADO       NUMBER(1) not null,
  FEC_INGRESO  DATE not null,
  USUREG       VARCHAR2(30) default user not null,
  FECREG       DATE default sysdate not null,
  USUMOD       VARCHAR2(30) default user not null,
  FECMOD       DATE default sysdate not null
);
-- Add comments to the columns 
comment on column OPERACION.TABEQUIPO_MATERIAL.IDEQUIPO
  is 'correlativo';
comment on column OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE
  is 'Número de Serie del equipo';
comment on column OPERACION.TABEQUIPO_MATERIAL.IMEI_ESN_UA
  is 'unitaddress del deco';
comment on column OPERACION.TABEQUIPO_MATERIAL.TIPO
  is 'antena parabólica, control remoto, decodificador, lnb, tarjeta';
comment on column OPERACION.TABEQUIPO_MATERIAL.CODALMACEN
  is 'código del almacén';
comment on column OPERACION.TABEQUIPO_MATERIAL.ESTADO
  is 'activo/inactivo';
comment on column OPERACION.TABEQUIPO_MATERIAL.FEC_INGRESO
  is 'fecha de ingreso del equipo';
comment on column OPERACION.TABEQUIPO_MATERIAL.USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.TABEQUIPO_MATERIAL.FECREG
  is 'Fecha que insertó el registro';
comment on column OPERACION.TABEQUIPO_MATERIAL.USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.TABEQUIPO_MATERIAL.FECMOD
  is 'Fecha que se modificó el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TABEQUIPO_MATERIAL
  add constraint PK_TABEQUIPO_MATERIAL primary key (IDEQUIPO);
