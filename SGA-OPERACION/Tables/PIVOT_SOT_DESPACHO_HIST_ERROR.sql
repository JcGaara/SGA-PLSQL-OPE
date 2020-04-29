-- Create table
create table OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
(
  ID_SEC_HIS          NUMBER(15) not null,
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
  FLG_CORRECCION      VARCHAR2(1) not null,
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
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ID_SEC_HIS
  is 'Id (correlativo) del historico de errores en los despachos. Esto implica que un material ó serie puede tener varios items de error en un proceso de envio.
Ejm: 127445
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ID_LOTE
  is 'Id (correlativo) del LOTE de proceso de despacho ó descarga masiva de materiales y equipos 3play a SAP.
Ejm: 1838
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ID_ITEM
  is 'Secuencial del material ó serie dentro del LOTE.
Ejm: 12
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.FEC_REG
  is 'Fecha de registro del lote.
Ejm: 08/11/2016 03:23
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.USU_REG
  is 'Usuario que registra el lote.
Ejm: USRSGA
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.FEC_MOD
  is 'Fecha de modificacion del lote.
Ejm: 08/11/2016 04:18
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.USU_MOD
  is 'Usuario que modifica el registro en el lote.
Ejm: USRSGA
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.NRO_GUIA_REM
  is 'Numero de guia de remision.
Este valor se forma concatenando los valores: CODSOLOT+<SECUENCIAL>.
Ejm: 21144500-310083.
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.NRO_MATERIAL
  is 'Numero ó Codigo de Material.
Ejm: 4008638
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.NRO_SERIE
  is 'Numero de serie del equipo.
Ejm: M1507EW00237
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.FEC_CONTABILIZACION
  is 'Fecha de contabilizacion.
Ejm: 08/11/2016
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.FEC_DOCUMENTO
  is 'Fecha de documento.
Ejm: 08/11/2016
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.CABECERA_DOCUMENTO
  is 'Texto ó glosa del documento.
Ejm: WRK_HFCINST_2016
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.CANT_NECESARIA
  is 'Cantidad despachada del material ó equipo.
Ejm: 1 (default).
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.CENTRO
  is 'Codigo del centro.
Ejm: P039
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ALMACEN
  is 'Codigo del almacen.
Ejm: A031
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.LOTE
  is 'Descriptivo del lote.
Ejm: VALORADO (default)
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.CLASE_VAL
  is 'Clase de valoracion ó movimiento.
Ejm: 221 (default)
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.NRO_RESERVA
  is 'Numero de Reserva.
Ejm: null (default)
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.NRO_POS_RESERVA
  is 'Numero de Posicion de Reserva.
Ejm: null (default)
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ELEMENTO_PEP
  is 'Elemento del Plan de Estructura de Proyecto (PEP)
Ejm: RF-PE02AH160498-CV-CHFEQ
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.FLG_CORRECCION
  is 'Flag que indica si el error reportado ha sido corregido. Ejm:
Null: Pendiente de correccion.
1: Corregido.
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.ESTADO
  is 'Estado del registro de despacho ó descarga.
1: Pendiente.
3: Procesado OK.
4: Procesado con Error.
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.COD_RPTA
  is '0: Éxito
1: Error
';
comment on column OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR.MSG_RPTA
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.PIVOT_SOT_DESPACHO_HIST_ERROR
  add constraint PK_PIVOT_ERROR_ID_SEC_HIS primary key (ID_SEC_HIS)
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
