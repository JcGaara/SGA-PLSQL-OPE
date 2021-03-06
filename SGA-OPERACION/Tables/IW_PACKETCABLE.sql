-- Create table
create table OPERACION.IW_PACKETCABLE
(
  IDTRANSACCION   NUMBER,
  IDSERVICIO      VARCHAR2(10),
  IDPRODUCTO      VARCHAR2(20),
  IDVENTA         VARCHAR2(10),
  IDSERVICIOPADRE VARCHAR2(20),
  IDPRODUCTOPADRE VARCHAR2(20),
  IDVENTAPADRE    VARCHAR2(20),
  MACADDRESS      VARCHAR2(40),
  LINESQTY        VARCHAR2(30),
  FECHAALTA       VARCHAR2(30),
  FECHAACTIVACION VARCHAR2(30),
  ACTIVO          VARCHAR2(10),
  ISPMTA          VARCHAR2(30),
  MTAPROFILE      VARCHAR2(30),
  MTAMODEL        VARCHAR2(100),
  CODIGO          VARCHAR2(20),
  ACTCODEEXPDATE  VARCHAR2(30),
  ACTCODELASTUSE  VARCHAR2(30),
  IPAPLICACION    VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP      VARCHAR2(30) default USER,
  FECUSU          DATE default SYSDATE,
  PCAPLICACION    VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.IW_PACKETCABLE
  is 'Tabla de interface de Arreglo PACKETCABLE';
-- Add comments to the columns 
comment on column OPERACION.IW_PACKETCABLE.IDTRANSACCION
  is 'Ticket de IW';
comment on column OPERACION.IW_PACKETCABLE.IDSERVICIO
  is 'Id Servicio';
comment on column OPERACION.IW_PACKETCABLE.IDPRODUCTO
  is 'Id Producto';
comment on column OPERACION.IW_PACKETCABLE.IDVENTA
  is 'IDVENTA';
comment on column OPERACION.IW_PACKETCABLE.IDSERVICIOPADRE
  is 'Srv Padre';
comment on column OPERACION.IW_PACKETCABLE.IDPRODUCTOPADRE
  is 'Prd Padre';
comment on column OPERACION.IW_PACKETCABLE.IDVENTAPADRE
  is 'Vta Padre';
comment on column OPERACION.IW_PACKETCABLE.MACADDRESS
  is 'MAC';
comment on column OPERACION.IW_PACKETCABLE.LINESQTY
  is 'Lines QTY';
comment on column OPERACION.IW_PACKETCABLE.FECHAALTA
  is 'Fecha Alta';
comment on column OPERACION.IW_PACKETCABLE.FECHAACTIVACION
  is 'Fec Act';
comment on column OPERACION.IW_PACKETCABLE.ACTIVO
  is 'Activo';
comment on column OPERACION.IW_PACKETCABLE.ISPMTA
  is 'ISP';
comment on column OPERACION.IW_PACKETCABLE.MTAPROFILE
  is 'MTA Profile';
comment on column OPERACION.IW_PACKETCABLE.MTAMODEL
  is 'MTA Modelo';
comment on column OPERACION.IW_PACKETCABLE.CODIGO
  is 'Codigo';
comment on column OPERACION.IW_PACKETCABLE.ACTCODEEXPDATE
  is 'Fec Exp Codigo';
comment on column OPERACION.IW_PACKETCABLE.ACTCODELASTUSE
  is 'FecCodUso';
comment on column OPERACION.IW_PACKETCABLE.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.IW_PACKETCABLE.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.IW_PACKETCABLE.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.IW_PACKETCABLE.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index OPERACION.IDX_IW_PACKETCABLE on OPERACION.IW_PACKETCABLE (IDTRANSACCION)
  tablespace OPERACION_DAT ;