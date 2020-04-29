-- Create table
create table OPERACION.OPE_WS_SGASAP
(
  idtrs         NUMBER not null,
  tipo          VARCHAR2(30),
  codsolot      NUMBER,
  id_ubitecnica NUMBER,
  respuestaxml  CLOB,
  esquemaxml    CLOB,
  resultado     NUMBER,
  numslc        VARCHAR2(10),
  error         VARCHAR2(400),
  ipapp         VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp    VARCHAR2(30) default USER,
  fecusu        DATE default SYSDATE,
  pcapp         VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
comment on table OPERACION.OPE_WS_SGASAP
  is 'Transacciones XML de servicios';
comment on column OPERACION.OPE_WS_SGASAP.idtrs
  is 'Id trs';
comment on column OPERACION.OPE_WS_SGASAP.tipo
  is 'Tipo';
comment on column OPERACION.OPE_WS_SGASAP.codsolot
  is 'SOLOT';
comment on column OPERACION.OPE_WS_SGASAP.id_ubitecnica
  is 'ID Ubicacion Tecnica';
comment on column OPERACION.OPE_WS_SGASAP.respuestaxml
  is 'Res XML';
comment on column OPERACION.OPE_WS_SGASAP.esquemaxml
  is 'Esq XML';
comment on column OPERACION.OPE_WS_SGASAP.resultado
  is 'RESULTADO';
comment on column OPERACION.OPE_WS_SGASAP.numslc
  is 'Proyecto SGA';
comment on column OPERACION.OPE_WS_SGASAP.error
  is 'Error';
comment on column OPERACION.OPE_WS_SGASAP.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.OPE_WS_SGASAP.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.OPE_WS_SGASAP.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.OPE_WS_SGASAP.pcapp
  is 'PC Aplicacion';
create index OPERACION.IK_OPE_WS_SGASAP001 on OPERACION.OPE_WS_SGASAP (TIPO)
  tablespace OPERACION_IDX;
alter table OPERACION.OPE_WS_SGASAP
  add constraint PK_OPE_WS_SGASAP primary key (IDTRS)
  using index 
  tablespace OPERACION_IDX;
