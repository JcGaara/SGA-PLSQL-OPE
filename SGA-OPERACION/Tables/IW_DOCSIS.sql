-- Create table
create table OPERACION.IW_DOCSIS
(
  IDTRANSACCION    NUMBER,
  IDSERVICIO       VARCHAR2(10),
  IDPRODUCTO       VARCHAR2(20),
  IDVENTA          VARCHAR2(10),
  IDSERVICIOPADRE  VARCHAR2(20),
  IDPRODUCTOPADRE  VARCHAR2(20),
  IDVENTAPADRE     VARCHAR2(20),
  HUB              VARCHAR2(50),
  NODO             VARCHAR2(50),
  MACADDRESS       VARCHAR2(50),
  DOCSISVERSION    VARCHAR2(10),
  CANTCPE          VARCHAR2(10),
  SERVICEPACKAGE   VARCHAR2(30),
  FECHAALTA        VARCHAR2(30),
  FECHAACTIVACION  VARCHAR2(30),
  MENSAJES         VARCHAR2(30),
  ACTIVO           VARCHAR2(30),
  ISPCM            VARCHAR2(30),
  ISPCPE           VARCHAR2(30),
  BANDPACKAGE      VARCHAR2(30),
  CODIGO           VARCHAR2(30),
  SERIALNUMBER     VARCHAR2(30),
  ACTCODEEXPDATE   VARCHAR2(30),
  ACTCODELASTUSAGE VARCHAR2(30),
  IPAPLICACION     VARCHAR2(50) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP       VARCHAR2(50) default USER,
  FECUSU           DATE default SYSDATE,
  PCAPLICACION     VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.IW_DOCSIS
  is 'Tabla de interface de Arreglo DOCSIS';
-- Add comments to the columns 
comment on column OPERACION.IW_DOCSIS.IDTRANSACCION
  is 'Ticket de IW';
comment on column OPERACION.IW_DOCSIS.IDSERVICIO
  is 'Id Servicio';
comment on column OPERACION.IW_DOCSIS.IDPRODUCTO
  is 'Id Producto';
comment on column OPERACION.IW_DOCSIS.IDVENTA
  is 'IDVENTA';
comment on column OPERACION.IW_DOCSIS.IDSERVICIOPADRE
  is 'IDSERVICIOPADRE';
comment on column OPERACION.IW_DOCSIS.IDPRODUCTOPADRE
  is 'IDPRODUCTOPADRE';
comment on column OPERACION.IW_DOCSIS.IDVENTAPADRE
  is 'IDVENTAPADRE';
comment on column OPERACION.IW_DOCSIS.HUB
  is 'HUB';
comment on column OPERACION.IW_DOCSIS.NODO
  is 'NODO';
comment on column OPERACION.IW_DOCSIS.MACADDRESS
  is 'Mac';
comment on column OPERACION.IW_DOCSIS.DOCSISVERSION
  is 'Doc Sis Version';
comment on column OPERACION.IW_DOCSIS.CANTCPE
  is 'Cant CPE';
comment on column OPERACION.IW_DOCSIS.SERVICEPACKAGE
  is 'Service Package';
comment on column OPERACION.IW_DOCSIS.FECHAALTA
  is 'Fecha Alta';
comment on column OPERACION.IW_DOCSIS.FECHAACTIVACION
  is 'Fecha Activacion';
comment on column OPERACION.IW_DOCSIS.MENSAJES
  is 'Mensajes';
comment on column OPERACION.IW_DOCSIS.ACTIVO
  is 'ACTIVO';
comment on column OPERACION.IW_DOCSIS.ISPCM
  is 'ISPCM';
comment on column OPERACION.IW_DOCSIS.ISPCPE
  is 'ISPCPE';
comment on column OPERACION.IW_DOCSIS.BANDPACKAGE
  is 'BANDPACKAGE';
comment on column OPERACION.IW_DOCSIS.CODIGO
  is 'Codigo';
comment on column OPERACION.IW_DOCSIS.SERIALNUMBER
  is 'Serial Number';
comment on column OPERACION.IW_DOCSIS.ACTCODEEXPDATE
  is 'Fec Exp Cod Act';
comment on column OPERACION.IW_DOCSIS.ACTCODELASTUSAGE
  is 'Fec Exp Ultimo uso';
comment on column OPERACION.IW_DOCSIS.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.IW_DOCSIS.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.IW_DOCSIS.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.IW_DOCSIS.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index OPERACION.IDX_IW_DOCSIS on OPERACION.IW_DOCSIS (IDTRANSACCION)
  tablespace OPERACION_DAT ;