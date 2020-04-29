-- Create table
create table OPERACION.SHFCT_DET_TRAS_EXT
(
  shfcn_codsolot              NUMBER(8) not null,
  shfci_customer_id           INTEGER,
  shfcv_direccion_facturacion VARCHAR2(40),
  shfcv_notas_direccion       VARCHAR2(40),
  shfcv_distrito              VARCHAR2(40),
  shfcv_provincia             VARCHAR2(70),
  shfcv_codigo_postal         VARCHAR2(15),
  shfcv_departamento          VARCHAR2(40),
  shfcv_pais                  VARCHAR2(40),
  shfcv_codocc                INTEGER,
  shfcv_fecvig                DATE,
  shfcv_numero_cuota          INTEGER,
  shfcv_monto                 FLOAT,
  shfcv_observacion           VARCHAR2(2000),
  shfcv_flag_direcc_fact      NUMBER(1),
  shfcv_flag_cobro_occ        NUMBER(1),
  shfcv_aplicacion            VARCHAR2(20),
  shfcv_usuario_reg           VARCHAR2(50),
  shfcv_fecha_reg             DATE,
  shfcv_usuario_act           VARCHAR2(50),
  shfcv_fecha_act             DATE
)
tablespace OPERACION_DAT;

-- Add comments to the columns 
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcn_codsolot
  is 'Codigo Solot';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfci_customer_id
  is 'Customer Id';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_direccion_facturacion
  is 'Direccion de Facturacion';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_notas_direccion
  is 'Notas';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_distrito
  is 'Distrito';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_provincia
  is 'Provincia';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_codigo_postal
  is 'Codigo Postal';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_departamento
  is 'Departamento';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_pais
  is 'Pais';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_codocc
  is 'Codigo OCC';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_fecvig
  is 'Fecha Vigencia';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_numero_cuota
  is 'Numero de cuotas';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_monto
  is 'Monto';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_observacion
  is 'Observacion';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_flag_direcc_fact
  is 'Flag Actualiza Direccion de Facturacion';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_flag_cobro_occ
  is 'Flag cobro OCC';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_aplicacion
  is 'Aplicacion';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_usuario_reg
  is 'Usuario registra';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_fecha_reg
  is 'Fecha Registro';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_usuario_act
  is 'Usuario Actualiza';
comment on column OPERACION.SHFCT_DET_TRAS_EXT.shfcv_fecha_act
  is 'Fecha Actualizacion';
