create table OPERACION.PROYECTO_SAP
(
  idproyecto    NUMBER not null,
  codsolot      NUMBER,
  numslc        VARCHAR2(10),
  proyecto      VARCHAR2(24),
  descripcion   VARCHAR2(40),
  cebe          VARCHAR2(10),
  proyecto_1    VARCHAR2(24),
  descripcion_1 VARCHAR2(40),
  ceco_resp     VARCHAR2(10),
  ceco_solic    VARCHAR2(10),
  soc_fi        VARCHAR2(4),
  soc_co        VARCHAR2(4),
  ubitecnica    VARCHAR2(30),
  id_sitio_sap  VARCHAR2(30),
  id_sitio      VARCHAR2(20),
  id_ubitecnica NUMBER,
  fecini        VARCHAR2(8),
  fecfin        VARCHAR2(8),
  clase_activo  VARCHAR2(18),
  tipo_red      VARCHAR2(2),
  perfil        VARCHAR2(7),
  tiproy        VARCHAR2(5),
  anio          VARCHAR2(4),
  codcli        VARCHAR2(8),
  rubroinv      VARCHAR2(18),
  clase_proy    VARCHAR2(2),
  prioridad     NUMBER,
  ceco_pep      VARCHAR2(10),
  procesado     VARCHAR2(1) default 'N',
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate,
  tiproy_sap    VARCHAR2(5)
)
tablespace OPERACION_DAT;
comment on table OPERACION.PROYECTO_SAP
  is 'Listado de Proyectos SAP';
comment on column OPERACION.PROYECTO_SAP.idproyecto
  is 'ID Proyecto';
comment on column OPERACION.PROYECTO_SAP.codsolot
  is 'SOT';
comment on column OPERACION.PROYECTO_SAP.numslc
  is 'Proyecto SGA';
comment on column OPERACION.PROYECTO_SAP.proyecto
  is 'Definición del proyecto';
comment on column OPERACION.PROYECTO_SAP.descripcion
  is 'Descripción breve (primera línea de texto)';
comment on column OPERACION.PROYECTO_SAP.cebe
  is 'Centro de Beneficio';
comment on column OPERACION.PROYECTO_SAP.proyecto_1
  is 'Elemento del plan de estructura de proyecto (elemento PEP)';
comment on column OPERACION.PROYECTO_SAP.descripcion_1
  is 'PS: Descripción breve (primera línea de texto)';
comment on column OPERACION.PROYECTO_SAP.ceco_resp
  is 'Centro de coste responsable';
comment on column OPERACION.PROYECTO_SAP.ceco_solic
  is 'Centro de coste solicitante';
comment on column OPERACION.PROYECTO_SAP.soc_fi
  is 'Sociedad del proyecto';
comment on column OPERACION.PROYECTO_SAP.soc_co
  is 'Sociedad CO del elemento PEP';
comment on column OPERACION.PROYECTO_SAP.ubitecnica
  is 'Ubicacion Tecnica';
comment on column OPERACION.PROYECTO_SAP.id_sitio_sap
  is 'ID Equipo/Sitio SAP';
comment on column OPERACION.PROYECTO_SAP.id_sitio
  is 'ID Sitio';
comment on column OPERACION.PROYECTO_SAP.id_ubitecnica
  is 'ID Ubicacion Tecnica';
comment on column OPERACION.PROYECTO_SAP.fecini
  is 'Fecha Inicio';
comment on column OPERACION.PROYECTO_SAP.fecfin
  is 'Fecha Fin';
comment on column OPERACION.PROYECTO_SAP.clase_activo
  is 'Clase de Activo Fijo';
comment on column OPERACION.PROYECTO_SAP.tipo_red
  is 'ID tipo de red';
comment on column OPERACION.PROYECTO_SAP.perfil
  is 'Perfil de proyecto';
comment on column OPERACION.PROYECTO_SAP.tiproy
  is 'ID clasificación de tipo de proyecto';
comment on column OPERACION.PROYECTO_SAP.anio
  is 'Año presupuesto';
comment on column OPERACION.PROYECTO_SAP.codcli
  is 'Codigo Cliente SGA';
comment on column OPERACION.PROYECTO_SAP.rubroinv
  is 'Rubro de Inversion';
comment on column OPERACION.PROYECTO_SAP.clase_proy
  is 'Clase del proyecto';
comment on column OPERACION.PROYECTO_SAP.prioridad
  is 'Prioridad';
comment on column OPERACION.PROYECTO_SAP.ceco_pep
  is 'Sociedad FI del elemento PEP';
comment on column OPERACION.PROYECTO_SAP.procesado
  is 'Procesado';
comment on column OPERACION.PROYECTO_SAP.ipaplicacion
  is 'IP registro';
comment on column OPERACION.PROYECTO_SAP.pcaplicacion
  is 'PC Registro';
comment on column OPERACION.PROYECTO_SAP.codusu
  is 'Usuario Registro';
comment on column OPERACION.PROYECTO_SAP.fecusu
  is 'Fecha Registro';
comment on column OPERACION.PROYECTO_SAP.tiproy_sap
  is 'ID clasificación de tipo de proyecto de SAP'; 
alter table OPERACION.PROYECTO_SAP
  add constraint PK_SAP_PROYECTO1 primary key (IDPROYECTO)
  using index 
  tablespace OPERACION_DAT;