-- Create table
create table OPERACION.INT_TELEFONIA_LOG
(
  id               NUMBER(10) not null,
  int_telefonia_id NUMBER(10),
  plataforma       VARCHAR2(50),
  codinssrv        NUMBER(10),
  numero           VARCHAR2(20),
  pid              NUMBER(10),
  idtrans          NUMBER(8),
  idseq            NUMBER(8),
  tx_bscs          VARCHAR2(30),
  ws_envios        NUMBER(3),
  ws_error_id      NUMBER(1),
  ws_error_dsc     VARCHAR2(2000),
  sga_error_id     NUMBER(1),
  sga_error_dsc    VARCHAR2(2000),
  verificado       NUMBER(1) default 0,
  chg_estado_sot   NUMBER(3),
  usureg           VARCHAR2(30) default USER not null,
  fecreg           DATE default SYSDATE not null
);
-- Add comments to the columns 
comment on column OPERACION.INT_TELEFONIA_LOG.id
  is 'PK';
comment on column OPERACION.INT_TELEFONIA_LOG.int_telefonia_id
  is 'FK DE INT_TELEFONIA.ID';
comment on column OPERACION.INT_TELEFONIA_LOG.plataforma
  is 'JANUS/TELLIN/ABIERTA';
comment on column OPERACION.INT_TELEFONIA_LOG.codinssrv
  is 'ID INSTANCIA SERVICIO';
comment on column OPERACION.INT_TELEFONIA_LOG.numero
  is 'NUMERO TELEFONICO';
comment on column OPERACION.INT_TELEFONIA_LOG.pid
  is 'ID PRODUCTO';
comment on column OPERACION.INT_TELEFONIA_LOG.idtrans
  is 'FK OPERACION.INT_PLATAFORMA_BSCS.IDTRANS';
comment on column OPERACION.INT_TELEFONIA_LOG.idseq
  is 'FK OPERACION.INT_SERVICIO_PLATAFORMA.IDSEQ';
comment on column OPERACION.INT_TELEFONIA_LOG.tx_bscs
  is 'TRANSACCION BSCS';
comment on column OPERACION.INT_TELEFONIA_LOG.ws_envios
  is 'CANTIDAD DE ENVIOS AL WS';
comment on column OPERACION.INT_TELEFONIA_LOG.ws_error_id
  is 'ID ERROR DEL WS';
comment on column OPERACION.INT_TELEFONIA_LOG.ws_error_dsc
  is 'ERROR DEL WS';
comment on column OPERACION.INT_TELEFONIA_LOG.sga_error_id
  is 'ID ERROR SGA';
comment on column OPERACION.INT_TELEFONIA_LOG.sga_error_dsc
  is 'ERROR DEL SGA';
comment on column OPERACION.INT_TELEFONIA_LOG.verificado
  is 'INDICADOR DE TRANSACCION REALIZADA EN JANUS';
comment on column OPERACION.INT_TELEFONIA_LOG.chg_estado_sot
  is 'CAMBIO DE ESTADO DE SOT';
comment on column OPERACION.INT_TELEFONIA_LOG.usureg
  is 'USUARIO CREACION';
comment on column OPERACION.INT_TELEFONIA_LOG.fecreg
  is 'FECHA CREACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.INT_TELEFONIA_LOG
  add constraint PK_INT_TELEFONIA_LOG primary key (ID);
alter table OPERACION.INT_TELEFONIA_LOG
  add constraint FK_PLAT_TEL_JANUS foreign key (IDTRANS)
  references OPERACION.INT_PLATAFORMA_BSCS (IDTRANS);
alter table OPERACION.INT_TELEFONIA_LOG
  add constraint FK_PLAT_TEL_TELLIN foreign key (IDSEQ)
  references OPERACION.INT_SERVICIO_PLATAFORMA (IDSEQ);
