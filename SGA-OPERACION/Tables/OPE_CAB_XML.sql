-- Create table
create table OPERACION.OPE_CAB_XML
(
  idcab       NUMBER not null,
  programa    VARCHAR2(200),
  nombrexml   VARCHAR2(200),
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default USER,
  fecusu      DATE default SYSDATE,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  titulo      VARCHAR2(400),
  rfc         VARCHAR2(200),
  metodo      VARCHAR2(200),
  descripcion VARCHAR2(200),
  xml         VARCHAR2(4000),
  target_url  VARCHAR2(400)
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.OPE_CAB_XML.idcab
  is 'Id cabecera';
comment on column OPERACION.OPE_CAB_XML.programa
  is 'Programa';
comment on column OPERACION.OPE_CAB_XML.nombrexml
  is 'Nombre XML';
comment on column OPERACION.OPE_CAB_XML.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.OPE_CAB_XML.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.OPE_CAB_XML.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.OPE_CAB_XML.pcapp
  is 'PC Aplicacion';
comment on column OPERACION.OPE_CAB_XML.titulo
  is 'Titulo';
comment on column OPERACION.OPE_CAB_XML.rfc
  is 'RFC';
comment on column OPERACION.OPE_CAB_XML.metodo
  is 'Metodo';
comment on column OPERACION.OPE_CAB_XML.descripcion
  is 'Descripcion WS';
comment on column OPERACION.OPE_CAB_XML.xml
  is 'XML';
comment on column OPERACION.OPE_CAB_XML.target_url
  is 'URL de servicio';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_CAB_XML
  add constraint PKOPE_CAB_XML primary key (IDCAB)
  using index 
  tablespace OPERACION_DAT;
