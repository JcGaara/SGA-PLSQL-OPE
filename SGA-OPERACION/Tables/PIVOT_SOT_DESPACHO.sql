-- Create table
create table OPERACION.PIVOT_SOT_DESPACHO
(
  ID_LOTE             NUMBER(15) not null,
  ID_ITEM             NUMBER(5) not null,
  FEC_REG             DATE not null,
  USU_REG             VARCHAR2(30) not null,
  FEC_MOD             DATE not null,
  USU_MOD             VARCHAR2(30) not null,
  NRO_GUIA_REM        VARCHAR2(16) not null,
  NRO_MATERIAL        VARCHAR2(18),
  NRO_SERIE           VARCHAR2(30),
  FEC_CONTABILIZACION DATE not null,
  FEC_DOCUMENTO       DATE not null,
  CABECERA_DOCUMENTO  VARCHAR2(25) not null,
  CANT_NECESARIA      NUMBER(13) not null,
  CENTRO              VARCHAR2(4) not null,
  ALMACEN             VARCHAR2(4) not null,
  LOTE                VARCHAR2(4) not null,
  CLASE_VAL           VARCHAR2(30) not null,
  NRO_RESERVA         NUMBER(10),
  NRO_POS_RESERVA     NUMBER(4),
  ELEMENTO_PEP        VARCHAR2(24) not null,
  ESTADO              VARCHAR2(20) not null,
  COD_RPTA            VARCHAR2(1) not null,
  MSG_RPTA            VARCHAR2(255) not null,
  NRO_REINTENTOS      NUMBER default 0 not null
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
comment on column OPERACION.PIVOT_SOT_DESPACHO.ID_LOTE
  is 'Id (correlativo) del LOTE de proceso de despacho ó descarga masiva de materiales y equipos 3play a SAP.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.ID_ITEM
  is 'Secuencial del material ó serie dentro del LOTE.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.FEC_REG
  is 'Fecha de registro del lote de proceso.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.USU_REG
  is 'Usuario que registra el lote de proceso.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.FEC_MOD
  is 'Fecha de modificacion del lote de proceso.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.USU_MOD
  is 'Usuario que modifica el registro en el lote de proceso.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_GUIA_REM
  is 'Numero de guia de remision.
Este valor se forma concatenando los valores: CODSOLOT+SEQUENCIAL';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_MATERIAL
  is 'Numero ó Codigo de Material.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_SERIE
  is 'Numero de serie del equipo.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.FEC_CONTABILIZACION
  is 'Fecha de contabilizacion.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.FEC_DOCUMENTO
  is 'Fecha de documento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.CABECERA_DOCUMENTO
  is 'Texto ó glosa del documento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.CANT_NECESARIA
  is 'Cantidad despachada del material ó equipo.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.CENTRO
  is 'Codigo del centro.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.ALMACEN
  is 'Codigo del almacen.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.LOTE
  is 'Descriptivo del lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.CLASE_VAL
  is 'Clase de valoracion ó movimiento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_RESERVA
  is 'Numero de Reserva.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_POS_RESERVA
  is 'Numero de Posicion de Reserva.';
comment on column OPERACION.PIVOT_SOT_DESPACHO.ELEMENTO_PEP
  is 'Elemento del Plan de Estructura de Proyecto (PEP)';
comment on column OPERACION.PIVOT_SOT_DESPACHO.ESTADO
  is 'Estado del registro de despacho ó descarga.
1: Pendiente.
3: Procesado OK.
4: Procesado con Error.
';
comment on column OPERACION.PIVOT_SOT_DESPACHO.COD_RPTA
  is '0: Éxito
1: Error
';
comment on column OPERACION.PIVOT_SOT_DESPACHO.MSG_RPTA
  is '"Item despachado correctamente".
¿No registra serie en  Intraway / Incognito¿
¿Serie no existe en SAP¿
¿Registro no cuenta con presupuesto¿
¿Sin stock¿
¿Código SAP errado¿
¿Error con la conexión o errores no controlados en SAP¿
¿Superó el número máximo de reintentos¿
¿Otros¿
';
comment on column OPERACION.PIVOT_SOT_DESPACHO.NRO_REINTENTOS
  is 'Numero de Reintentos';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.PIVOT_SOT_DESPACHO
  add constraint PK_PIVOT_DESP_LOTE_ITEM primary key (ID_LOTE, ID_ITEM)
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
