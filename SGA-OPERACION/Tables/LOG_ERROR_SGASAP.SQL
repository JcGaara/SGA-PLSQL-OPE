-- Create table
create table OPERACION.LOG_ERROR_SGASAP
(
  idlog          NUMBER not null,
  numslc         VARCHAR2(10),
  codsolot       NUMBER,
  id_requisicion NUMBER,
  id_ubitecnica  NUMBER,
  proceso        VARCHAR2(50),
  error          NUMBER,
  texto          VARCHAR2(4000),
  id_grafo       NUMBER,
  codusu         VARCHAR2(30) default user,
  fecusu         DATE default sysdate,
  ipaplicacion   VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion   VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
comment on table OPERACION.LOG_ERROR_SGASAP
  is 'Tabla Log Errores transacciones SINERGIA';
comment on column OPERACION.LOG_ERROR_SGASAP.idlog
  is 'Id Log';
comment on column OPERACION.LOG_ERROR_SGASAP.numslc
  is 'Proyecto';
comment on column OPERACION.LOG_ERROR_SGASAP.codsolot
  is 'SOT';
comment on column OPERACION.LOG_ERROR_SGASAP.id_requisicion
  is 'Id Requisicion Reserva';
comment on column OPERACION.LOG_ERROR_SGASAP.id_ubitecnica
  is 'Id Ubitecnica';
comment on column OPERACION.LOG_ERROR_SGASAP.proceso
  is 'Proceso';
comment on column OPERACION.LOG_ERROR_SGASAP.error
  is 'Error';
comment on column OPERACION.LOG_ERROR_SGASAP.texto
  is 'Texto del error';
comment on column OPERACION.LOG_ERROR_SGASAP.id_grafo
  is 'Identificador de Grafo';
comment on column OPERACION.LOG_ERROR_SGASAP.codusu
  is 'Usuario Registro';
comment on column OPERACION.LOG_ERROR_SGASAP.fecusu
  is 'Fecua registro';
comment on column OPERACION.LOG_ERROR_SGASAP.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LOG_ERROR_SGASAP.pcaplicacion
  is 'PC Aplicacion';
alter table OPERACION.LOG_ERROR_SGASAP
  add constraint PK_LOGSGASAP001 primary key (IDLOG)
  using index 
  tablespace OPERACION_IDX;

