create table OPERACION.GRAFO
(  idGRAFO      NUMBER not null,
  codsolot     NUMBER not null,
  idwf         NUMBER not null,
  numeroGRAFO  VARCHAR2(12),
  clase        VARCHAR2(4),
  perfil       VARCHAR2(7),
  planificador VARCHAR2(3),
  descripcion  VARCHAR2(60),
  fecini       DATE,
  fecfin       DATE,
  proyecto     VARCHAR2(24) not null,
  pep          VARCHAR2(24) not null,
  procesado    VARCHAR2(1) default 'N',
  pospedido    VARCHAR2(10),
  division     VARCHAR2(4),
  cebe         VARCHAR2(10),
  prioridad    NUMBER,
  centro       VARCHAR2(4),
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate,
  estado       VARCHAR2(30)
)
tablespace OPERACION_DAT;
comment on table OPERACION.GRAFO
  is 'Tabla de OPERACION.GRAFOs';
comment on column OPERACION.GRAFO.idGRAFO
  is 'Id OPERACION.GRAFO';
comment on column OPERACION.GRAFO.codsolot
  is 'SOT';
comment on column OPERACION.GRAFO.idwf
  is 'ID WF SGA';
comment on column OPERACION.GRAFO.numeroGRAFO
  is 'Numero OPERACION.GRAFO SAP';
comment on column OPERACION.GRAFO.clase
  is 'Clase OPERACION.GRAFO';
comment on column OPERACION.GRAFO.perfil
  is 'Perfil OPERACION.GRAFO';
comment on column OPERACION.GRAFO.planificador
  is 'Planificador';
comment on column OPERACION.GRAFO.descripcion
  is 'Descripcion Texto Breve';
comment on column OPERACION.GRAFO.fecini
  is 'Fecha Inicio';
comment on column OPERACION.GRAFO.fecfin
  is 'Fecha Fin';
comment on column OPERACION.GRAFO.proyecto
  is 'Proyecto SAP';
comment on column OPERACION.GRAFO.pep
  is 'Elemento PEP';
comment on column OPERACION.GRAFO.procesado
  is 'Procesado';
comment on column OPERACION.GRAFO.pospedido
  is 'Posicion de Pedido';
comment on column OPERACION.GRAFO.division
  is 'Division';
comment on column OPERACION.GRAFO.cebe
  is 'Centro de Beneficio';
comment on column OPERACION.GRAFO.prioridad
  is 'Prioridad';
comment on column OPERACION.GRAFO.centro
  is 'Centro';
comment on column OPERACION.GRAFO.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.GRAFO.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.GRAFO.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.GRAFO.fecusu
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.GRAFO.estado
  is 'Estado del OPERACION.GRAFO CLSD Cerrado';
create index OPERACION.IDK_GRAFO01 on OPERACION.GRAFO (IDWF)
  tablespace OPERACION_DAT;
alter table OPERACION.GRAFO
  add constraint PK_GRAFO01 primary key (IDGRAFO)
  using index 
  tablespace OPERACION_DAT;
