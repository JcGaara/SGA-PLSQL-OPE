-- Create table
create table OPERACION.IW_REPORT
(
  IDTRANSACCION    NUMBER,
  IDEMPRESACRM     VARCHAR2(10),
  IDCLIENTECRM     VARCHAR2(10),
  IDTIPOCLIENTE    VARCHAR2(30),
  EMPRESA          VARCHAR2(50),
  TIPOCLIENTE      VARCHAR2(30),
  NOMBRE           VARCHAR2(200),
  USERNAME         VARCHAR2(30),
  PASSWORD         VARCHAR2(30),
  FECHAALTA        VARCHAR2(30),
  EMAILNOTICIAS    VARCHAR2(50),
  CICLOFACTURACION VARCHAR2(30),
  COM21            VARCHAR2(30),
  IPAPLICACION     VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP       VARCHAR2(30) default USER,
  FECUSU           DATE default SYSDATE,
  PCAPLICACION     VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the table 
comment on table OPERACION.IW_REPORT
  is 'Tabla de interface de Arreglo REPORT';
-- Add comments to the columns 
comment on column OPERACION.IW_REPORT.IDTRANSACCION
  is 'Ticket de IW';
comment on column OPERACION.IW_REPORT.IDEMPRESACRM
  is 'Id Empresa';
comment on column OPERACION.IW_REPORT.IDCLIENTECRM
  is 'id Cliente';
comment on column OPERACION.IW_REPORT.IDTIPOCLIENTE
  is 'Tipo Cliente';
comment on column OPERACION.IW_REPORT.EMPRESA
  is 'Empresa';
comment on column OPERACION.IW_REPORT.TIPOCLIENTE
  is 'Tipo de Cliente';
comment on column OPERACION.IW_REPORT.NOMBRE
  is 'Nombre';
comment on column OPERACION.IW_REPORT.USERNAME
  is 'Usuario';
comment on column OPERACION.IW_REPORT.PASSWORD
  is 'Pwd';
comment on column OPERACION.IW_REPORT.FECHAALTA
  is 'Fec Alta';
comment on column OPERACION.IW_REPORT.EMAILNOTICIAS
  is 'Email';
comment on column OPERACION.IW_REPORT.CICLOFACTURACION
  is 'Ciclo Facturacion';
comment on column OPERACION.IW_REPORT.COM21
  is 'Com21';
comment on column OPERACION.IW_REPORT.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.IW_REPORT.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.IW_REPORT.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.IW_REPORT.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index OPERACION.IDK_IW_REPORT_XML on OPERACION.IW_REPORT (IDTRANSACCION)
  tablespace OPERACION_DAT ;
