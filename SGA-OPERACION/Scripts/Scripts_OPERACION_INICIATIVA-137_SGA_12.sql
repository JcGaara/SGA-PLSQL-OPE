ALTER TABLE operacion.trs_ppto ADD fecactsrv DATE;
COMMENT ON COLUMN operacion.trs_ppto.fecactsrv
  IS 'Fecha de activacion del servicio';
ALTER TABLE operacion.formula ADD tipo NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN operacion.formula.tipo
  IS '1: x motivo de solucion 2: Sub tipo de orden';
ALTER TABLE operacion.formula ADD codmot_solucion NUMBER;
COMMENT ON COLUMN operacion.formula.codmot_solucion
  IS 'Codigo de motivo de solucion';
ALTER TABLE operacion.formula ADD id_subtipo_orden NUMBER;
COMMENT ON COLUMN operacion.formula.id_subtipo_orden
  IS 'Codigo de sub tipo de orden';