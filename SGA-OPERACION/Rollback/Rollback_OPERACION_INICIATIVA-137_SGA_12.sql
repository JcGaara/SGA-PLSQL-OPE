ALTER TABLE operacion.trs_ppto DROP COLUMN fecactsrv;
ALTER TABLE operacion.formula DROP COLUMN tipo;
ALTER TABLE operacion.formula DROP COLUMN codmot_solucion;
ALTER TABLE operacion.formula DROP COLUMN id_subtipo_orden;
DROP TRIGGER operacion.t_almacenxcontrata_aiud;
DROP SEQUENCE operacion.sq_almacenxcontrata_log;
DROP TABLE operacion.almacenxcontrata;