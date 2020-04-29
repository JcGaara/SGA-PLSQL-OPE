-- Create table
create table OPERACION.PIVOT_SOT_DESPACHO_HIST
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
  MSG_RPTA            VARCHAR2(255) not null
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
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.ID_LOTE
  is 'Id (correlativo) del LOTE de proceso de despacho � descarga masiva de materiales y equipos 3play a SAP.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.ID_ITEM
  is 'Secuencial del material � serie dentro del LOTE.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.FEC_REG
  is 'Fecha de registro del lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.USU_REG
  is 'Usuario que registra el lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.FEC_MOD
  is 'Fecha de modificacion del lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.USU_MOD
  is 'Usuario que modifica el registro en el lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.NRO_GUIA_REM
  is 'Numero de guia de remision.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.NRO_MATERIAL
  is 'Numero � Codigo de Material.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.NRO_SERIE
  is 'Numero de serie del equipo.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.FEC_CONTABILIZACION
  is 'Fecha de contabilizacion.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.FEC_DOCUMENTO
  is 'Fecha de documento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.CABECERA_DOCUMENTO
  is 'Texto � glosa del documento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.CANT_NECESARIA
  is 'Cantidad despachada del material � equipo.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.CENTRO
  is 'Codigo del centro.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.ALMACEN
  is 'Codigo del almacen.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.LOTE
  is 'Descriptivo del lote.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.CLASE_VAL
  is 'Clase de valoracion � movimiento.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.NRO_RESERVA
  is 'Numero de Reserva.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.NRO_POS_RESERVA
  is 'Numero de Posicion de Reserva.';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.ELEMENTO_PEP
  is 'Elemento del Plan de Estructura de Proyecto (PEP)';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.ESTADO
  is 'Estado del registro de despacho � descarga.
1: Pendiente.
3: Procesado OK.
4: Procesado con Error.
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.COD_RPTA
  is '0: �xito
1: Error
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST.MSG_RPTA
  is '"Item despachado correctamente".
�No registra serie en  Intraway / Incognito�
�Serie no existe en SAP�
�Registro no cuenta con presupuesto�
�Sin stock�
�C�digo SAP errado�
�Error con la conexi�n o errores no controlados en SAP�
�Super� el n�mero m�ximo de reintentos�
�Otros�
';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.PIVOT_SOT_DESPACHO_HIST
  add constraint PK_PIVOT_HIST_LOTE_ITEM primary key (ID_LOTE, ID_ITEM)
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
