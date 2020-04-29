create table OPERACION.ACTIVIDAD_SAP
( idactividad      NUMBER not null,
  idtareawf        NUMBER not null,
  numerografo      VARCHAR2(12),
  numerooperacion  VARCHAR2(4),
  clavecontrol     VARCHAR2(4),
  centro           VARCHAR2(4),
  descripcion      VARCHAR2(40),
  pep              VARCHAR2(24),
  clavecalculo     VARCHAR2(1),
  clavemodelo      VARCHAR2(7),
  prioridad        NUMBER,
  procesado        VARCHAR2(1) default 'N',
  idgrafo          NUMBER,
  numeroreferencia VARCHAR2(30),
  tipo             NUMBER default 1,
  tipoobjeto       VARCHAR2(30),
  metodo           VARCHAR2(30),
  estactividad     NUMBER default 1,
  ipaplicacion     VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion     VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu           VARCHAR2(30) default user,
  fecusu           DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.ACTIVIDAD_SAP
  is 'Actividades de Grafo SAP';
comment on column OPERACION.ACTIVIDAD_SAP.idactividad
  is 'ID Actividad SGA';
comment on column OPERACION.ACTIVIDAD_SAP.idtareawf
  is 'ID tareawf';
comment on column OPERACION.ACTIVIDAD_SAP.numerografo
  is 'Numero Grafo SAP';
comment on column OPERACION.ACTIVIDAD_SAP.numerooperacion
  is 'Numero Operacion/Actividad SAP';
comment on column OPERACION.ACTIVIDAD_SAP.clavecontrol
  is 'Clave de control';
comment on column OPERACION.ACTIVIDAD_SAP.centro
  is 'Centro';
comment on column OPERACION.ACTIVIDAD_SAP.descripcion
  is 'Descripcion Texto Breve';
comment on column OPERACION.ACTIVIDAD_SAP.pep
  is 'Elemento PEP';
comment on column OPERACION.ACTIVIDAD_SAP.clavecalculo
  is 'Clave de Calculo';
comment on column OPERACION.ACTIVIDAD_SAP.clavemodelo
  is 'Clave de Modelo';
comment on column OPERACION.ACTIVIDAD_SAP.prioridad
  is 'Prioridad';
comment on column OPERACION.ACTIVIDAD_SAP.procesado
  is 'Procesado';
comment on column OPERACION.ACTIVIDAD_SAP.idgrafo
  is 'Id Grafo';
comment on column OPERACION.ACTIVIDAD_SAP.numeroreferencia
  is 'Numero de Referencia';
comment on column OPERACION.ACTIVIDAD_SAP.tipo
  is '1: Actividad 2: Metodo';
comment on column OPERACION.ACTIVIDAD_SAP.tipoobjeto
  is 'Tipo de Objeto : NETWORKACTIVITY,etc';
comment on column OPERACION.ACTIVIDAD_SAP.metodo
  is 'Metodo SAVE';
comment on column OPERACION.ACTIVIDAD_SAP.estactividad
  is 'Estado de Actividad : 1 Generado  4 Cerrado';
comment on column OPERACION.ACTIVIDAD_SAP.ipaplicacion
  is 'IP Registro';
comment on column OPERACION.ACTIVIDAD_SAP.pcaplicacion
  is 'PC Registro';
comment on column OPERACION.ACTIVIDAD_SAP.codusu
  is 'Usuario Registro';
comment on column OPERACION.ACTIVIDAD_SAP.fecusu
  is 'Fecha Registro';
alter table OPERACION.ACTIVIDAD_SAP
  add constraint PK_ACTIVIDAD_SAP0001 primary key (IDACTIVIDAD)
  using index 
  tablespace OPERACION_DAT;