create table OPERACION.SGAT_RESERVA_TOA
(
  RESTV_NRO_ORDEN       VARCHAR2(30),
  RESTN_ID_ETA          NUMBER(20),
  RESTN_NRO_SOLOT       NUMBER(10),
  RESTN_ID_CONSULTA     NUMBER(10), 
  RESTV_FRANJA          VARCHAR2(10),
  RESTD_DIA_RESERVA     DATE,
  RESTV_ID_BUCKET       VARCHAR2(40),
  RESTV_COD_ZONA        VARCHAR2(10),
  RESTV_COD_PLANO       VARCHAR2(20),
  RESTV_TIPO_ORDEN      VARCHAR2(10),
  RESTV_SUB_TIPO_ORDEN  VARCHAR2(20),
  RESTN_ESTADO          NUMBER(2),
  RESTN_SECUENCIA       NUMBER(30),
  RESTD_FECHA_GENERADA  DATE default sysdate,
  RESTV_usureg          VARCHAR2(50) default user,
  RESTD_fecreg          DATE default sysdate,
  RESTV_usumod          VARCHAR2(50),
  RESTD_fecmod          DATE,
  RESTV_ipaplicacion    VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  RESTV_pcaplicacion    VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_NRO_ORDEN is 'Nro de orden en TOA';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTN_ID_ETA is 'Id de transaccion de la orden en TOA';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTN_NRO_SOLOT is 'Nro de sot';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTN_ID_CONSULTA is 'Id consulta que se obtiene al generar las franjas';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_FRANJA is 'Franja horaria seleccionada para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTD_DIA_RESERVA is 'Dia seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_ID_BUCKET is 'Bucket seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_COD_ZONA is 'Zona seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_COD_PLANO is 'Plano o ubigeo seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_TIPO_ORDEN is 'Tipo de orden seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_SUB_TIPO_ORDEN is 'Subtipo de orden seleccionado para la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTN_ESTADO is 'Estado de la reserva';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTN_SECUENCIA is 'Secuencia del correlativo para generar el Nro de orden';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTD_FECHA_GENERADA is 'Fecha generada para lograr su anulacion';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_usureg is 'Usuario de creacion';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTD_fecreg is 'Fecha de creacion';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTV_usumod is 'Usuario de modificacion';
comment on column OPERACION.SGAT_RESERVA_TOA.RESTD_fecmod is 'Fecha de modificacion';

