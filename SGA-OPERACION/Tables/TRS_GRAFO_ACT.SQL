create table OPERACION.TRS_GRAFO_ACT
(
  idtrsgrafoact   NUMBER not null,
  idproceso       NUMBER,
  numerografo     VARCHAR2(12),
  numerooperacion VARCHAR2(4),
  idgrafo         NUMBER,
  estado          VARCHAR2(30),
  tipo            NUMBER,
  ipaplicacion    VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion    VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu          VARCHAR2(30) default user,
  fecusu          DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.TRS_GRAFO_ACT
  is 'Transacciones Grafos';
comment on column OPERACION.TRS_GRAFO_ACT.idtrsgrafoact
  is 'Secuencial';
comment on column OPERACION.TRS_GRAFO_ACT.idproceso
  is 'Proceso';
comment on column OPERACION.TRS_GRAFO_ACT.numerografo
  is 'Numero de grafo';
comment on column OPERACION.TRS_GRAFO_ACT.numerooperacion
  is 'numero de actividad';
comment on column OPERACION.TRS_GRAFO_ACT.idgrafo
  is 'id grafo';
comment on column OPERACION.TRS_GRAFO_ACT.estado
  is 'Estado';
comment on column OPERACION.TRS_GRAFO_ACT.tipo
  is 'Tipo';
comment on column OPERACION.TRS_GRAFO_ACT.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.TRS_GRAFO_ACT.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.TRS_GRAFO_ACT.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.TRS_GRAFO_ACT.fecusu
  is 'Fecha de creacion del resgitro';
alter table OPERACION.TRS_GRAFO_ACT
  add constraint PK_GRAFO_ACT_TRS primary key (IDTRSGRAFOACT)
  using index 
  tablespace OPERACION_DAT;