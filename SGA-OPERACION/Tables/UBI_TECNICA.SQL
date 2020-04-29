create table OPERACION.UBI_TECNICA
(
  id_ubitecnica        NUMBER not null,
  codubired            NUMBER,
  abrev                VARCHAR2(50),
  cid                  NUMBER,
  numslc               VARCHAR2(10),
  codsolot             NUMBER,
  flag_instal_auto     VARCHAR2(1) default 'X',
  grupoautorizaciones  VARCHAR2(4),
  descripcion          VARCHAR2(40),
  sociedad             VARCHAR2(4),
  flagubicaciontecnica VARCHAR2(5),
  tipo                 VARCHAR2(1),
  montajeequipos       VARCHAR2(1) default 'X',
  procesado            VARCHAR2(1) default 'N',
  idplano              VARCHAR2(10),
  codsuc               VARCHAR2(10),
  claseproy            VARCHAR2(1),
  id_hub_sap           VARCHAR2(10),
  region_sap           VARCHAR2(1),
  tiproy_mas           VARCHAR2(3),
  idhub                NUMBER,
  tipo_sga             NUMBER,
  ipaplicacion         VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion         VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu               VARCHAR2(30) default user,
  fecusu               DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.UBI_TECNICA
  is 'Listado de Ubicaciones Tecnica';
comment on column OPERACION.UBI_TECNICA.codubired
  is 'Secuencial';
comment on column OPERACION.UBI_TECNICA.abrev
  is 'Abreviatura Ubicacion Tecnica Codigo Externo';
comment on column OPERACION.UBI_TECNICA.cid
  is 'CID';
comment on column OPERACION.UBI_TECNICA.numslc
  is 'Numero de Proyecto';
comment on column OPERACION.UBI_TECNICA.codsolot
  is 'SOT';
comment on column OPERACION.UBI_TECNICA.flag_instal_auto
  is 'Indicador de una posición. AUTOMATIC_INSTALL';
comment on column OPERACION.UBI_TECNICA.grupoautorizaciones
  is 'Grupo de autorizaciones para objeto técnico. AUTHGRP';
comment on column OPERACION.UBI_TECNICA.descripcion
  is 'Denominacion de la Ubicación Técnica. DESCRIPT';
comment on column OPERACION.UBI_TECNICA.sociedad
  is 'Sociedad. COMP_CODE';
comment on column OPERACION.UBI_TECNICA.flagubicaciontecnica
  is 'Indicador de Estructura de la Ubicación Técnica. STRIND';
comment on column OPERACION.UBI_TECNICA.tipo
  is 'Tipo de Ubicación Técnica. CATEGORY';
comment on column OPERACION.UBI_TECNICA.montajeequipos
  is 'Montaje de equipos permitido en Ubicación Técnica. EQINSTALL';
comment on column OPERACION.UBI_TECNICA.procesado
  is 'Procesado';
comment on column OPERACION.UBI_TECNICA.idplano
  is 'codigo postal (3 digitos) + correlativo por código postal (3 digitos)';
comment on column OPERACION.UBI_TECNICA.codsuc
  is 'Codigo Sucursal';
comment on column OPERACION.UBI_TECNICA.claseproy
  is 'Clase proyecto o Ubitec K:Corp  H:HFC/PLano F:Nodo';
comment on column OPERACION.UBI_TECNICA.id_hub_sap
  is 'ID Hub SAP';
comment on column OPERACION.UBI_TECNICA.region_sap
  is 'Codigo Ubigeo';
comment on column OPERACION.UBI_TECNICA.tiproy_mas
  is 'Tipo de Proyecto masivo asociado a la ubicacion Tecnica';
comment on column OPERACION.UBI_TECNICA.tipo_sga
  is '1: HUB 2:HFC 3 RadioBase 4 Clientes';
comment on column OPERACION.UBI_TECNICA.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.UBI_TECNICA.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.UBI_TECNICA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.UBI_TECNICA.fecusu
  is 'Fecha de creacion del resgitro';
alter table OPERACION.UBI_TECNICA
  add constraint PK_UBI_TECNICA_001 primary key (ID_UBITECNICA)
  using index 
  tablespace OPERACION_IDX;