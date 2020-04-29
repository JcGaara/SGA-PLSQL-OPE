create table OPERACION.ID_SITIO
(
  ID_SITIO      NUMBER not null,
  id_ubitecnica NUMBER not null,
  valid_date    DATE,
  equicatgry    VARCHAR2(1),
  objecttype    VARCHAR2(10),
  manfacture    VARCHAR2(30),
  manparno      VARCHAR2(30),
  descript      VARCHAR2(40),
  comp_code     VARCHAR2(4),
  procesado     VARCHAR2(1) default 'N',
  ID_SITIO_sap  VARCHAR2(30),
  estado        VARCHAR2(30) default 'E0001',
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.ID_SITIO
  is 'Listado de Sitios';
comment on column OPERACION.ID_SITIO.ID_SITIO
  is 'Id Sitio Secuencial';
comment on column OPERACION.ID_SITIO.id_ubitecnica
  is 'ID Ubicacion Tecnica';
comment on column OPERACION.ID_SITIO.valid_date
  is 'Fecha de Validez del Objeto Técnico';
comment on column OPERACION.ID_SITIO.equicatgry
  is 'Tipo de Equipo';
comment on column OPERACION.ID_SITIO.objecttype
  is 'Tipo de Objeto Tecnico';
comment on column OPERACION.ID_SITIO.manfacture
  is 'Nombre del ID de Sitio';
comment on column OPERACION.ID_SITIO.manparno
  is 'Código ID de Sitio';
comment on column OPERACION.ID_SITIO.descript
  is 'Nombre del Equipo ID de Sitio';
comment on column OPERACION.ID_SITIO.comp_code
  is 'Sociedad';
comment on column OPERACION.ID_SITIO.procesado
  is 'Procesado';
comment on column OPERACION.ID_SITIO.ID_SITIO_sap
  is 'ID Equipo/Sitio SAP';
comment on column OPERACION.ID_SITIO.estado
  is 'Estado SITIO';
comment on column OPERACION.ID_SITIO.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.ID_SITIO.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.ID_SITIO.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.ID_SITIO.fecusu
  is 'Fecha de creacion del resgitro';
alter table OPERACION.ID_SITIO
  add constraint PK_ID_SITIO001 primary key (ID_SITIO)
  using index 
  tablespace OPERACION_DAT;
