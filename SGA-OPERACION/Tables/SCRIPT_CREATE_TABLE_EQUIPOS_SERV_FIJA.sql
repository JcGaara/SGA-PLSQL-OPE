-- Create table 
create table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA
(
  SGAN_ID                 NUMBER NOT NULL,
  SGAN_CO_ID              NUMBER,
  SGAN_CUSTOMER_ID        NUMBER,
  SGAV_CODCLI             VARCHAR2(10),
  SGAN_CODSOLOT           NUMBER,
  SGAN_CODSOLOT_B_CE      NUMBER,
  SGAV_NUMEROSERIE        VARCHAR(50),
  SGAV_IMEI_ESN_UA        VARCHAR2(50),
  SGAV_TECNOLOGIA         VARCHAR2(10),
  SGAN_CODINSSRV          NUMBER,
  SGAN_PID                NUMBER,
  SGAV_TIPSRV             VARCHAR2(10),
  SGAV_CODEQUCOM          VARCHAR2(10),
  SGAN_TIPEQU             NUMBER,
  SGAV_TIPO_EQUIPO        VARCHAR2(50),
  SGAV_CODTIPEQU          VARCHAR2(20),
  SGAV_ESTADO             VARCHAR2(50),
  SGAV_USUREG             VARCHAR2(50) DEFAULT USER NOT NULL,
  SGAD_FECREG             DATE DEFAULT SYSDATE NOT NULL,
  SGAV_USUMOD             VARCHAR2(50) DEFAULT USER NOT NULL,
  SGAD_FECMOD             DATE DEFAULT SYSDATE NOT NULL
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
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAN_ID
  is 'Secuencial';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAN_CO_ID
  is 'Contrato Asociado al Equipo';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAN_CUSTOMER_ID
  is 'CUSTOMER Asociado al Equipo';  
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_CODCLI
  is 'Codigo de Cliente del SGA';   
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAN_CODSOLOT
  is 'SOT Con la que se activo el equipo'; 
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAN_CODSOLOT_B_CE
  is 'SOT con el que se desactivo o cambio el equipo';  
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_NUMEROSERIE
  is 'Número de Serie del equipo';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_IMEI_ESN_UA
  is 'Unitaddress del Deco';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_TECNOLOGIA
  is 'Tecnologia del Equipo (LTE/DTH/HFC u otro)';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_TIPO_EQUIPO
  is 'Tipo de Equipo (DECODIFICADOR/SIMCARD/TARJETA/ROUTER)';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_ESTADO
  is 'Estado del Equipo (ACTIVO/INACTIVO)';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAD_FECREG
  is 'Fecha que insertó el registro';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAV_USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.SGAT_EQUIPO_SERVICIO_FIJA.SGAD_FECMOD
  is 'Fecha que se modificó el registro';
-- Create/Recreate indexes

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_EQUIPO_SERVICIO_FIJA
  add constraint PK_SGAT_EQUIPO_SERVICIO_FIJA primary key (SGAN_ID)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 19M
    next 1M
    minextents 1
    maxextents unlimited
  );
