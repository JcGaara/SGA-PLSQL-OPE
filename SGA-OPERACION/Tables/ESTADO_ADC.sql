create table operacion.estado_adc
(
  id_estado     NUMBER(8) NOT NULL,
  desc_corta    VARCHAR2(100),
  desc_larga    VARCHAR2(100),
  estado        CHAR(1) DEFAULT 1,
  ipcre         VARCHAR2(20),
  ipmod         VARCHAR2(20),
  feccre        DATE DEFAULT SYSDATE,
  fecmod        DATE DEFAULT SYSDATE,
  usucre        VARCHAR2(30) DEFAULT USER,
  usumod        VARCHAR2(30) DEFAULT USER
)
TABLESPACE OPERACION_DAT;

COMMENT ON COLUMN operacion.estado_adc.id_estado   IS 'codigo del estado etadirect';
COMMENT ON COLUMN operacion.estado_adc.desc_corta  IS 'descripcion corta del estado';
COMMENT ON COLUMN operacion.estado_adc.desc_larga  IS 'descripcion larga del estado';
COMMENT ON COLUMN operacion.estado_adc.estado  	   IS 'indica si esta activo o inactivo';
COMMENT ON COLUMN operacion.estado_adc.ipcre       IS 'IP que registro';
COMMENT ON COLUMN operacion.estado_adc.ipmod       IS 'IP que modifico';
COMMENT ON COLUMN operacion.estado_adc.feccre      IS 'fecha de creacion';
COMMENT ON COLUMN operacion.estado_adc.fecmod      IS 'fecha de modificacion';
COMMENT ON COLUMN operacion.estado_adc.usucre      IS 'usuario que creo';
COMMENT ON COLUMN operacion.estado_adc.usumod      IS 'usuario que modifico';
