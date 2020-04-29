-- CREATE TABLE
CREATE TABLE OPERACION.SGAT_PROVSGA
(
  ESPRV_COD_OPERACION VARCHAR2(15) NOT NULL,
  ESPRN_COD_SOLOT     NUMBER(8) NOT NULL,
  ESPRC_COD_CLI       CHAR(8) NOT NULL,
  ESPRN_ESTADO        NUMBER DEFAULT 1,
  ESPRV_MENSAJE       VARCHAR2(500),
  ESPRV_DESCRIPCION   VARCHAR2(100),
  ESPRV_REQUESTID     VARCHAR2(10),
  ESPRN_N_REENVIO     NUMBER,
  ESPRN_N_REENVIO_MAX NUMBER,
  ESPRD_ULT_FEC_REENV DATE,
  ESPRV_USUARIO_CREA  VARCHAR2(30) DEFAULT USER NOT NULL,
  ESPRD_FECHA_CREA    DATE DEFAULT SYSDATE NOT NULL,
  ESPRV_USUARIO_MODI  VARCHAR2(30),
  ESPRD_FECHA_MODI    DATE,
  ESPRV_ORDERNO       VARCHAR2(20),
  ESPRN_TIPTRA        NUMBER
)
TABLESPACE OPERACION_DAT
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
-- Add comments to the columns 
comment on column OPERACION.SGAT_PROVSGA.esprv_cod_operacion
  is 'CODIGO OPERACION';
comment on column OPERACION.SGAT_PROVSGA.esprn_cod_solot
  is 'CODIGO DE SOT';
comment on column OPERACION.SGAT_PROVSGA.esprc_cod_cli
  is 'CODIGO CLIENTE';
comment on column OPERACION.SGAT_PROVSGA.esprn_estado
  is 'ESTADO DE PROVISION 1: GENERADO, 2: EN PROCESO, 3: PROVISIONADO, 4: ERROR, 5: CANCELADO';
comment on column OPERACION.SGAT_PROVSGA.esprv_mensaje
  is 'MENSAJE DE SERVICIO';
comment on column OPERACION.SGAT_PROVSGA.esprv_descripcion
  is 'DESCRIPCION DE SERVICIO';
comment on column OPERACION.SGAT_PROVSGA.esprv_requestid
  is 'REQUEST ID';
comment on column OPERACION.SGAT_PROVSGA.esprn_n_reenvio
  is 'NUMERO DE REENVIO';
comment on column OPERACION.SGAT_PROVSGA.esprn_n_reenvio_max
  is 'MAXIMA CANTIDA DE REENVIO';
comment on column OPERACION.SGAT_PROVSGA.esprd_ult_fec_reenv
  is 'ULTIMA FECHA DE REENVIO';
comment on column OPERACION.SGAT_PROVSGA.esprv_usuario_crea
  is 'USUARIO CREADOR DEL REGISTRO';
comment on column OPERACION.SGAT_PROVSGA.esprd_fecha_crea
  is 'FECHA DE CREACION DEL REGISTRO';
comment on column OPERACION.SGAT_PROVSGA.esprv_usuario_modi
  is 'USUARIO MODIFICADOR DEL REGISTRO';
comment on column OPERACION.SGAT_PROVSGA.esprd_fecha_modi
  is 'FECHA DE MODIFICACION DEL REGISTRO';
comment on column OPERACION.SGAT_PROVSGA.esprv_orderno
  is 'ORDERNO';
comment on column OPERACION.SGAT_PROVSGA.esprn_tiptra
  is 'TIPO DE TRABAJO';
-- Create/Recreate indexes 
create index OPERACION.IDX_PROVSGA_ID_SOLOT on OPERACION.SGAT_PROVSGA (ESPRN_COD_SOLOT)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 8K
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_PROVSGA
  add constraint PK_SGAT_PROVSGA primary key (ESPRV_COD_OPERACION, ESPRN_COD_SOLOT)
  using index 
  tablespace OPERACION_IDX
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
