-- Create table
create table OPERACION.TRSCDMA
(
  IDCDMA        NUMBER not null,
  CODINSSRV     NUMBER(10),
  TIPTRS        NUMBER,
  FECPROG       DATE,
  FECEJE        DATE,
  EST_ENVIO     NUMBER default 0,
  ID_MENSAJE    VARCHAR2(300),
  CABECERA_XML  VARCHAR2(4000),
  TIPTRA        NUMBER,
  FECUSU        DATE default SYSDATE,
  CODUSU        VARCHAR2(30) default USER,
  SEQ_LOTE_CDMA NUMBER,
  CODSOLOT      NUMBER,
  FECACT        DATE,
  ID_CONEXION   NUMBER,
  ID_ERROR      NUMBER,
  N_REINTENTOS  NUMBER default 0,
  AUD_PC        VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  AUD_IP        VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  IMSI          NUMBER,
  CODNUMTEL     NUMBER,
  NUMEROSERIE   VARCHAR2(100),
  AKEY          VARCHAR2(100)
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
comment on column OPERACION.TRSCDMA.IDCDMA
  is 'ID correlativo de la peticion para sincronizar los planes BAF y BAM';
comment on column OPERACION.TRSCDMA.CODINSSRV
  is 'SID SGA';
comment on column OPERACION.TRSCDMA.TIPTRS
  is 'Identifica el tipo de petición en plan BAF 1Activacion,2Upgrade,3Suspension,4Reconexion,5Cancelacion,6Creacion,7Suspensión LC,8Reconexión LC,9Activacion - No Factura';
comment on column OPERACION.TRSCDMA.FECPROG
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de programación de la petición de activación, suspensión, cancelación ó reconexion. Este valor permite realizar peticiones a futuro';
comment on column OPERACION.TRSCDMA.FECEJE
  is 'De acuerdo al tipo de transacción, este valor representa la fecha de registro de la petición de activación, suspensión, cancelación ó reconexion';
comment on column OPERACION.TRSCDMA.EST_ENVIO
  is 'Estado de la petición 1 Pendiente, 2 En Ejecucion, 3 Terminado OK, 4 Terminado con error';
comment on column OPERACION.TRSCDMA.ID_MENSAJE
  is 'Mensaje de error que se retorna al intentar ejecutar la peticion';
comment on column OPERACION.TRSCDMA.TIPTRA
  is 'Indica el tipo de trabajo para plan BAF';
comment on column OPERACION.TRSCDMA.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.TRSCDMA.CODUSU
  is 'Usuario de Registro';
comment on column OPERACION.TRSCDMA.SEQ_LOTE_CDMA
  is 'Secuencial que permite lotizar las transacciones de envio a BSCS';
comment on column OPERACION.TRSCDMA.CODSOLOT
  is 'sot';
comment on column OPERACION.TRSCDMA.FECACT
  is 'Fecha de actualizacion';
comment on column OPERACION.TRSCDMA.ID_CONEXION
  is 'Id de conexion';
comment on column OPERACION.TRSCDMA.ID_ERROR
  is 'ID de Mensaje de error BSCS';
comment on column OPERACION.TRSCDMA.N_REINTENTOS
  is 'Indica el numero de reintentos que una petición puede esperar para que se ejecute correctamente';
comment on column OPERACION.TRSCDMA.AUD_PC
  is 'Es el nombre de la PC donde se registro la petición';
comment on column OPERACION.TRSCDMA.AUD_IP
  is 'Es la direccion IP de la PC donde se registro la petición';
comment on column OPERACION.TRSCDMA.IMSI
  is 'IMSI';
comment on column OPERACION.TRSCDMA.CODNUMTEL
  is 'Codigo numero telefonico';
-- CreateRecreate primary, unique and foreign key constraints 
alter table OPERACION.TRSCDMA
  add constraint TRSCDMA_PK primary key (IDCDMA)
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