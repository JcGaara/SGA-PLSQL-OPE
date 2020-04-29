CREATE TABLE operacion.cambio_estado_ot_adc
(
  secuencia NUMBER NOT NULL,
  codsolot  NUMBER NOT NULL,
  idagenda  NUMBER NOT NULL,
  origen    VARCHAR2(30) NOT NULL,
  id_estado NUMBER NOT NULL,
  motivo    VARCHAR2(50),
  feccre    DATE DEFAULT SYSDATE,
  usuario   VARCHAR2(30) DEFAULT USER
)
TABLESPACE operacion_dat;

COMMENT ON COLUMN operacion.cambio_estado_ot_adc.secuencia IS 'Secuencia';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.codsolot  IS 'Solicitud de trabajo';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.idagenda  IS 'Id de la agenda';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.origen    IS 'Origen';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.id_estado IS 'Estado';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.motivo    IS 'Motivo del Cambio de Estado';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.feccre    IS 'Fecha de creacion';
COMMENT ON COLUMN operacion.cambio_estado_ot_adc.usuario   IS 'IP que modifico';