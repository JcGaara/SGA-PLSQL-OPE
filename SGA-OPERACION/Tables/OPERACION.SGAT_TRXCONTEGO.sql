-- Create table
create table OPERACION.SGAT_TRXCONTEGO
(
  trxn_idtransaccion NUMBER not null,
  trxn_codsolot      NUMBER,
  trxn_action_id     NUMBER,
  trxv_tipo          VARCHAR2(15),
  trxv_serie_tarjeta VARCHAR2(30),
  trxv_serie_deco    VARCHAR2(30),
  trxv_bouquet       VARCHAR2(1000),
  trxd_fecini        DATE,
  trxd_fecfin        DATE,
  txtv_message       VARCHAR2(150),
  trxv_duration      VARCHAR2(15),
  trxn_msgseqnum     NUMBER,
  trxc_estado        CHAR(1),
  trxv_msj_err       VARCHAR2(250),
  trxv_idcontego     VARCHAR2(30),
  trxn_idlote        NUMBER,
  trxn_prioridad     NUMBER,
  trxn_idsol         NUMBER,
  trxc_reintentos    CHAR(1) default 0,
  trxd_fecusu        DATE default SYSDATE,
  trxv_codusu        VARCHAR2(30) default USER,
  trxd_fecmod        DATE,
  trxv_usumod        VARCHAR2(30)
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
-- Add comments to the columns 
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_idtransaccion
  is 'ID PRINCIPAL';
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_codsolot
  is 'CODIGO DE SOLOT';
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_action_id
  is 'ACTION ID ';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_tipo
  is 'TIPO DE OPERACION: PAREO / DESPAREO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_serie_tarjeta
  is 'SERIE DE TARJETA';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_serie_deco
  is 'SERIE DE DECODIFICADOR';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_bouquet
  is 'BOUQUET';
comment on column OPERACION.SGAT_TRXCONTEGO.trxd_fecini
  is 'FECHA DE INICIO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxd_fecfin
  is 'FECHA DE FIN';
comment on column OPERACION.SGAT_TRXCONTEGO.trxc_estado
  is 'ESTADO 1:GENERADO, 2: ENVIADO, 3:PROCESADO, 4:ERROR, 5:ERROR PENDIENTE REVISION, 6: CANCELADO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_msj_err
  is 'DETALLE DE ERROR RELACIONADO AL ESTADO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxc_reintentos
  is 'REINTENTOS';
comment on column OPERACION.SGAT_TRXCONTEGO.trxd_fecusu
  is 'FECHA DE REGISTRO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_codusu
  is 'USUARIO QUE REALIZO EL REGISTRO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxd_fecmod
  is 'FECHA DE MODIFICACION';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_usumod
  is 'USUARIO QUE REALIZO LA MODIFICACION';
comment on column OPERACION.SGAT_TRXCONTEGO.trxv_idcontego
  is 'ID TRANSACTION CONTEGO';
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_idlote
  is 'ID LOTE';
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_prioridad
  is 'PRIORIDAD RELACIONADO A LA PROVISION';
comment on column OPERACION.SGAT_TRXCONTEGO.trxn_idsol
  is 'ID SOLICITUD DE LA TABLA OPERACION.OPE_TVSAT_SLTD_CAB';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_TRXCONTEGO
  add constraint PK_SGAT_TRXCONTEGO primary key (TRXN_IDTRANSACCION)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table OPERACION.SGAT_TRXCONTEGO
  add constraint FK_SGAT_TRXCONTEGO_CODSOLOT foreign key (TRXN_CODSOLOT)
  references OPERACION.SOLOT (CODSOLOT)
  novalidate;
