ALTER TABLE operacion.trs_ppto DROP COLUMN mensaje_sga;
ALTER TABLE operacion.trs_ppto DROP COLUMN idplano;
ALTER TABLE operacion.trs_ppto DROP COLUMN campo2;
ALTER TABLE operacion.trs_ppto DROP COLUMN campo3;
DROP INDEX operacion.idx_trs_ppto002;
DROP TRIGGER operacion.t_control_descarga_bi;
DROP SEQUENCE operacion.sq_control_descarga;
DROP TABLE operacion.control_descarga;