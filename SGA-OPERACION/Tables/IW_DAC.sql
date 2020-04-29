-- Create table
create table OPERACION.IW_DAC
(
  IDTRANSACCION   NUMBER,
  IDSERVICIO      VARCHAR2(20),
  IDPRODUCTO      VARCHAR2(20),
  IDVENTA         VARCHAR2(10),
  IDSERVICIOPADRE VARCHAR2(10),
  IDPRODUCTOPADRE VARCHAR2(10),
  IDVENTAPADRE    VARCHAR2(10),
  SERIALNUMBER    VARCHAR2(40),
  UNITADDRESS     VARCHAR2(40),
  CONVERTERTYPE   VARCHAR2(30),
  HEADEND         VARCHAR2(30),
  CHANNELMAP      VARCHAR2(30),
  CONTROLLER      VARCHAR2(30),
  DEFAULTSERVICE  VARCHAR2(30),
  DEFAULTCONFIG   VARCHAR2(30),
  DISABLED        VARCHAR2(10),
  PPVENABLED      VARCHAR2(30),
  NVODENABLED     VARCHAR2(30),
  PACENABLED      VARCHAR2(30),
  FECHAALTA       VARCHAR2(20),
  FECHAMODIF      VARCHAR2(20),
  FECHAACTIVACION VARCHAR2(20),
  CODIGO          VARCHAR2(20),
  ACTCODEEXPDATE  VARCHAR2(20),
  ACTCODELASTUSE  VARCHAR2(20),
  IPAPLICACION    VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP      VARCHAR2(30) default USER,
  FECUSU          DATE default SYSDATE,
  PCAPLICACION    VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.IW_DAC
  is 'Tabla de interface de Arreglo DAC';
-- Add comments to the columns 
comment on column OPERACION.IW_DAC.IDTRANSACCION
  is 'Ticket de IW';
comment on column OPERACION.IW_DAC.IDSERVICIO
  is 'Id Servicio';
comment on column OPERACION.IW_DAC.IDPRODUCTO
  is 'Id Producto';
comment on column OPERACION.IW_DAC.IDVENTA
  is 'IDVENTA';
comment on column OPERACION.IW_DAC.IDSERVICIOPADRE
  is 'Srv Padre';
comment on column OPERACION.IW_DAC.IDPRODUCTOPADRE
  is 'Prd Padre';
comment on column OPERACION.IW_DAC.IDVENTAPADRE
  is 'Vta Padre';
comment on column OPERACION.IW_DAC.SERIALNUMBER
  is 'Nro Serie';
comment on column OPERACION.IW_DAC.UNITADDRESS
  is 'MAC';
comment on column OPERACION.IW_DAC.CONVERTERTYPE
  is 'CONVERTERTYPE';
comment on column OPERACION.IW_DAC.HEADEND
  is 'HEADEND';
comment on column OPERACION.IW_DAC.CHANNELMAP
  is 'Channel Map';
comment on column OPERACION.IW_DAC.CONTROLLER
  is 'Controladore';
comment on column OPERACION.IW_DAC.DEFAULTSERVICE
  is 'Default Service';
comment on column OPERACION.IW_DAC.DEFAULTCONFIG
  is 'Default Config';
comment on column OPERACION.IW_DAC.DISABLED
  is 'Disable';
comment on column OPERACION.IW_DAC.PPVENABLED
  is 'PPV';
comment on column OPERACION.IW_DAC.NVODENABLED
  is 'NVOD';
comment on column OPERACION.IW_DAC.PACENABLED
  is 'PAC';
comment on column OPERACION.IW_DAC.FECHAALTA
  is 'Fecha Alta';
comment on column OPERACION.IW_DAC.FECHAMODIF
  is 'Fecha Modificacion';
comment on column OPERACION.IW_DAC.FECHAACTIVACION
  is 'Fecha Activacion';
comment on column OPERACION.IW_DAC.CODIGO
  is 'Codigo';
comment on column OPERACION.IW_DAC.ACTCODEEXPDATE
  is 'Fec Exp Codigo';
comment on column OPERACION.IW_DAC.ACTCODELASTUSE
  is 'FecCodUso';
comment on column OPERACION.IW_DAC.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.IW_DAC.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.IW_DAC.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.IW_DAC.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index OPERACION.IDX_IW_DAC on OPERACION.IW_DAC (IDTRANSACCION )
  tablespace OPERACION_DAT;