create table OPERACION.TIPROY_SINERGIA
(
  tiproy            VARCHAR2(3) not null,
  pais              VARCHAR2(2),
  claseproy         VARCHAR2(1),
  rubroinv          VARCHAR2(2),
  plataforma        VARCHAR2(1),
  destiproy         VARCHAR2(100),
  tipored           VARCHAR2(2),
  tipoubitec        VARCHAR2(2),
  soc_co            VARCHAR2(4),
  soc_fi            VARCHAR2(4),
  ceco_res          VARCHAR2(10),
  perfilproy        VARCHAR2(7),
  segmento          VARCHAR2(3),
  perfilgrafo       VARCHAR2(7),
  clasegrafo        VARCHAR2(7),
  planif_nec        VARCHAR2(10),
  centrografo       VARCHAR2(10),
  flag_plano        NUMBER default 0,
  gruposervicio     VARCHAR2(2),
  clavecontrol      VARCHAR2(4),
  fabricante        VARCHAR2(10),
  crea_proyecto     VARCHAR2(1) default 1,
  ceco_sol          VARCHAR2(10),
  clase_activo      VARCHAR2(10),
  flag_masivo       NUMBER default 0,
  proy_int_sinergia NUMBER default 0,
  tiproy_sap        VARCHAR2(3),
  tiproy_pad        VARCHAR2(3),
  ipaplicacion      VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion      VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu            VARCHAR2(30) default user,
  fecusu            DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.TIPROY_SINERGIA
  is 'Maestro de tipos de proyectos';
comment on column OPERACION.TIPROY_SINERGIA.tiproy
  is 'Tipo Proyecto SINERGIA';
comment on column OPERACION.TIPROY_SINERGIA.pais
  is 'Pais';
comment on column OPERACION.TIPROY_SINERGIA.claseproy
  is 'Clase Proyecto SINERGIA';
comment on column OPERACION.TIPROY_SINERGIA.rubroinv
  is 'Rubro Inversion';
comment on column OPERACION.TIPROY_SINERGIA.plataforma
  is 'Plataforma F:HFC G:Fibra H:Wimax N:Satelital 0 No Aplica';
comment on column OPERACION.TIPROY_SINERGIA.destiproy
  is 'Descripcion tipo de proyecto';
comment on column OPERACION.TIPROY_SINERGIA.tipored
  is 'Tipo Red';
comment on column OPERACION.TIPROY_SINERGIA.tipoubitec
  is 'Tipo Ubicacion Tecnica';
comment on column OPERACION.TIPROY_SINERGIA.soc_co
  is 'Sociedad Costos se contabiliza en Dolares';
comment on column OPERACION.TIPROY_SINERGIA.soc_fi
  is 'Sociedad Financiera se contabiliza en Soles';
comment on column OPERACION.TIPROY_SINERGIA.ceco_res
  is 'CECO Responsable';
comment on column OPERACION.TIPROY_SINERGIA.perfilproy
  is 'Perfil Proyecto';
comment on column OPERACION.TIPROY_SINERGIA.perfilgrafo
  is 'Perfil Grafo';
comment on column OPERACION.TIPROY_SINERGIA.clasegrafo
  is 'Clase Grafo';
comment on column OPERACION.TIPROY_SINERGIA.planif_nec
  is 'Planificador Necesidad';
comment on column OPERACION.TIPROY_SINERGIA.centrografo
  is 'Centro Logístico  para Infraestructura P001';
comment on column OPERACION.TIPROY_SINERGIA.flag_plano
  is '0 No obliga a registrra Plano 1 : Plano Obligatorio';
comment on column OPERACION.TIPROY_SINERGIA.gruposervicio
  is '10 : Generales 21: Telefonia Publica';
comment on column OPERACION.TIPROY_SINERGIA.clavecontrol
  is 'Clave de Control para Grafos y Actividades';
comment on column OPERACION.TIPROY_SINERGIA.fabricante
  is 'Fabricante';
comment on column OPERACION.TIPROY_SINERGIA.crea_proyecto
  is 'Crea Proyecto en SAP 1: SI, 0 NO';
comment on column OPERACION.TIPROY_SINERGIA.ceco_sol
  is 'Centro de Costo Solicitante o Centro Costo Operativo';
comment on column OPERACION.TIPROY_SINERGIA.clase_activo
  is 'Clase de Activo Fijo';
comment on column OPERACION.TIPROY_SINERGIA.flag_masivo
  is 'Proyectos generan PEP Masivos';
comment on column OPERACION.TIPROY_SINERGIA.proy_int_sinergia
  is 'Tipos de Proyectos Internos de SINERGIA';
comment on column OPERACION.TIPROY_SINERGIA.tiproy_sap
  is 'Tipo de Proyecto para SAP';
comment on column OPERACION.TIPROY_SINERGIA.tiproy_pad
  is 'Tipo de Proyecto Padre';
comment on column OPERACION.TIPROY_SINERGIA.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.TIPROY_SINERGIA.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.TIPROY_SINERGIA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.TIPROY_SINERGIA.fecusu
  is 'Fecha de creacion del resgitro';
alter table OPERACION.TIPROY_SINERGIA
  add constraint PK_TIPROY_001 primary key (TIPROY)
  using index 
  tablespace OPERACION_DAT;
