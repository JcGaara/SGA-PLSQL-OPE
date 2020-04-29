-- Create table
create table OPERACION.TELEFONIA_CE_DET
(
  id_telefonia_ce_det NUMBER(10) not null,
  id_telefonia_ce     NUMBER(10),
  codinssrv           NUMBER(10),
  numero              VARCHAR2(20),
  pid                 NUMBER(10),
  idtrans             NUMBER(8),
  action_id           NUMBER(2),
  ws_envios           NUMBER(3) default 0,
  id_ws_error         NUMBER(1),
  ws_error_dsc        VARCHAR2(2000),
  id_sga_error        NUMBER(1),
  sga_error_dsc       VARCHAR2(2000),
  verificado          NUMBER(1) default 0,
  ws_xml              VARCHAR2(4000),
  usureg              VARCHAR2(30) default USER not null,
  fecreg              DATE default SYSDATE not null,
  usumod              VARCHAR2(30) default USER not null,
  fecmod              DATE default SYSDATE not null
);
-- Add comments to the columns 
comment on column OPERACION.TELEFONIA_CE_DET.id_telefonia_ce_det
  is 'ID de la tabla';
comment on column OPERACION.TELEFONIA_CE_DET.id_telefonia_ce
  is 'FK de int_telefonia.id_telefonia_ce';
comment on column OPERACION.TELEFONIA_CE_DET.codinssrv
  is 'ID INSTANCIA SERVICIO';
comment on column OPERACION.TELEFONIA_CE_DET.numero
  is 'NUMERO TELEFONICO';
comment on column OPERACION.TELEFONIA_CE_DET.pid
  is 'ID PRODUCTO';
comment on column OPERACION.TELEFONIA_CE_DET.idtrans
  is 'FK OPERACION.INT_PLATAFORMA_BSCS.IDTRANS';
comment on column OPERACION.TELEFONIA_CE_DET.action_id
  is 'Transaccion BSCS';
comment on column OPERACION.TELEFONIA_CE_DET.ws_envios
  is 'Cantidad de envios al WS';
comment on column OPERACION.TELEFONIA_CE_DET.ws_error_dsc
  is 'ERROR DEL WS';
comment on column OPERACION.TELEFONIA_CE_DET.sga_error_dsc
  is 'ERROR DEL SGA';
comment on column OPERACION.TELEFONIA_CE_DET.verificado
  is 'INDICADOR DE TRANSACCION REALIZADA EN JANUS';
comment on column OPERACION.TELEFONIA_CE_DET.ws_xml
  is 'XML DE ENVIO WS';
comment on column OPERACION.TELEFONIA_CE_DET.usureg
  is 'USUARIO CREACION';
comment on column OPERACION.TELEFONIA_CE_DET.fecreg
  is 'FECHA CREACION';
comment on column OPERACION.TELEFONIA_CE_DET.id_ws_error
  is 'ID ERROR DEL WS';
comment on column OPERACION.TELEFONIA_CE_DET.id_sga_error
  is 'ID ERROR SGA';
comment on column OPERACION.TELEFONIA_CE_DET.usumod
  is 'USUARIO MODIFICACION';
comment on column OPERACION.TELEFONIA_CE_DET.fecmod
  is 'FECHA MODIFICACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TELEFONIA_CE_DET
  add constraint PK_TELEFONIA_CE_DET primary key (ID_TELEFONIA_CE_DET);
alter table OPERACION.TELEFONIA_CE_DET
  add constraint FK_TELEFONIA_CE_DET foreign key (ID_TELEFONIA_CE)
  references OPERACION.TELEFONIA_CE (ID_TELEFONIA_CE);
