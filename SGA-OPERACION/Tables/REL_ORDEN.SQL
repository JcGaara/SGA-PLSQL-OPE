create table OPERACION.REL_ORDEN
(
  idrelacion          NUMBER not null,
  numerografo_pre     VARCHAR2(12),
  numerografo_pos     VARCHAR2(12),
  numerooperacion_pre VARCHAR2(4),
  numerooperacion_pos VARCHAR2(4),
  tipo_relacion       VARCHAR2(4),
  tipoobjeto          VARCHAR2(30),
  metodo              VARCHAR2(30),
  tipo                NUMBER default 1,
  numeroreferencia    VARCHAR2(30),
  idgrafo             NUMBER,
  ipaplicacion        VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion        VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu              VARCHAR2(30) default user,
  fecusu              DATE default sysdate
)
tablespace OPERACION_DAT;
comment on table OPERACION.REL_ORDEN
  is 'Tabla que contiene lista de relaciones de Actividades';
comment on column OPERACION.REL_ORDEN.idrelacion
  is 'Correlativo de relaciones de actividad';
comment on column OPERACION.REL_ORDEN.numerografo_pre
  is 'Número de operación Predecesora';
comment on column OPERACION.REL_ORDEN.numerografo_pos
  is 'Número de operación sucesora';
comment on column OPERACION.REL_ORDEN.numerooperacion_pre
  is 'Número de grafo predecesor';
comment on column OPERACION.REL_ORDEN.numerooperacion_pos
  is 'Número de grafo sucesor';
comment on column OPERACION.REL_ORDEN.tipo_relacion
  is 'Número de relaciones FI';
comment on column OPERACION.REL_ORDEN.tipoobjeto
  is 'Tipo de Objeto : NETWORKACTIVITY,etc';
comment on column OPERACION.REL_ORDEN.metodo
  is 'Metodo SAVE';
comment on column OPERACION.REL_ORDEN.tipo
  is '1: Actividad 2: Metodo';
comment on column OPERACION.REL_ORDEN.numeroreferencia
  is 'Numero de referencia';
comment on column OPERACION.REL_ORDEN.idgrafo
  is 'Id grafo';
comment on column OPERACION.REL_ORDEN.ipaplicacion
  is 'IP aplicación';
comment on column OPERACION.REL_ORDEN.pcaplicacion
  is 'PC de la aplicación';
comment on column OPERACION.REL_ORDEN.codusu
  is 'Usuario que insertó el registro';
comment on column OPERACION.REL_ORDEN.fecusu
  is 'Fecha que inserto el registro';
alter table OPERACION.REL_ORDEN
  add constraint PK_REL_ORDEN001 primary key (IDRELACION)
  using index 
  tablespace OPERACION_DAT;