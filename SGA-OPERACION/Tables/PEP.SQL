create table OPERACION.PEP
(
  idPEP            NUMBER not null,
  proyecto         VARCHAR2(24),
  descripcion      VARCHAR2(40),
  PEP              VARCHAR2(40),
  nivel            NUMBER,
  idPEP_pad        NUMBER,
  id_seq           NUMBER,
  id_seq_pad       NUMBER,
  claseproy        VARCHAR2(1),
  tipo_red         VARCHAR2(5),
  elem_plan        VARCHAR2(1),
  elem_imputacion  VARCHAR2(1),
  codsolot         NUMBER,
  ubitecnica       VARCHAR2(30),
  id_sitio_sap     VARCHAR2(30),
  clase_activo     VARCHAR2(10),
  rubroinv         VARCHAR2(10),
  naturaleza_PEP   VARCHAR2(10),
  area             VARCHAR2(10),
  anio             NUMBER,
  ceco_solic       VARCHAR2(10),
  prioridad        NUMBER(1),
  clasif_obra      VARCHAR2(10),
  ceco_resp        VARCHAR2(10),
  procesado        VARCHAR2(1) default 'N',
  tipoproyecto     VARCHAR2(20),
  crea_grafo       NUMBER default 0,
  tiproy           VARCHAR2(5),
  cebe             VARCHAR2(10),
  asigna_sot_PEPn3 NUMBER default 0,
  ipaplicacion     VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion     VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu           VARCHAR2(30) default user,
  fecusu           DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.PEP
  is 'Transacciones OPERACION.PEP';
comment on column OPERACION.PEP.idPEP
  is 'Id Secuencial';
comment on column OPERACION.PEP.proyecto
  is 'Proyecto SAP';
comment on column OPERACION.PEP.descripcion
  is 'Descripcion';
comment on column OPERACION.PEP.PEP
  is 'OPERACION.PEP';
comment on column OPERACION.PEP.nivel
  is 'Nivel';
comment on column OPERACION.PEP.idPEP_pad
  is 'ID OPERACION.PEP Padre';
comment on column OPERACION.PEP.id_seq
  is 'Id Seq';
comment on column OPERACION.PEP.id_seq_pad
  is 'ID Secuencial Padre';
comment on column OPERACION.PEP.claseproy
  is 'Clase Proyecto SINERGIA';
comment on column OPERACION.PEP.tipo_red
  is 'Tipo de Red';
comment on column OPERACION.PEP.codsolot
  is 'SOT';
comment on column OPERACION.PEP.ubitecnica
  is 'Ubicacion Tecnica';
comment on column OPERACION.PEP.id_sitio_sap
  is 'ID Equipo/Sitio SAP';
comment on column OPERACION.PEP.clase_activo
  is 'Clase de Activo Fijo';
comment on column OPERACION.PEP.rubroinv
  is 'Rubro de Inversion';
comment on column OPERACION.PEP.naturaleza_PEP
  is 'Naturaleza OPERACION.PEP';
comment on column OPERACION.PEP.anio
  is 'Anho PPTO';
comment on column OPERACION.PEP.ceco_solic
  is 'Ceco Solicitante';
comment on column OPERACION.PEP.prioridad
  is 'Prioridad';
comment on column OPERACION.PEP.clasif_obra
  is 'Clasificador de Obra';
comment on column OPERACION.PEP.ceco_resp
  is 'CECO Responsable';
comment on column OPERACION.PEP.procesado
  is 'Procesado';
comment on column OPERACION.PEP.tipoproyecto
  is 'Tipo de Proyecto : PE-RF-HF-PEH';
comment on column OPERACION.PEP.crea_grafo
  is '1 : OPERACION.PEP asociado a grafo 0 PEP 3 no se asocia grafo';
comment on column OPERACION.PEP.tiproy
  is 'ID clasificación de tipo de proyecto';
comment on column OPERACION.PEP.cebe
  is 'Centro de Beneficio';
comment on column OPERACION.PEP.asigna_sot_PEPn3
  is 'Asigna la SOT al PEPN3 0 : No 1:Si';
comment on column OPERACION.PEP.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.PEP.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.PEP.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.PEP.fecusu
  is 'Fecha de creacion del resgitro';
create index OPERACION.IDX_PS_PEP2 on OPERACION.PEP (PROYECTO)
  tablespace OPERACION_IDX;
alter table OPERACION.PEP
  add constraint PK_PEP0001 primary key (IDPEP)
  using index 
  tablespace OPERACION_DAT; 