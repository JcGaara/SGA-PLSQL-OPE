ALTER TABLE operacion.trs_ppto ADD mensaje_sga VARCHAR2(400);
COMMENT ON COLUMN operacion.trs_ppto.mensaje_sga IS 'Mensaje de error SGA';
ALTER TABLE operacion.trs_ppto ADD idplano VARCHAR2(10);
COMMENT ON COLUMN operacion.trs_ppto.idplano IS 'ID plano';
ALTER TABLE operacion.trs_ppto ADD campo2 VARCHAR2(40);
COMMENT ON COLUMN operacion.trs_ppto.campo2 IS 'Campo1';
ALTER TABLE operacion.trs_ppto ADD campo3 VARCHAR2(40);
COMMENT ON COLUMN operacion.trs_ppto.campo3 IS 'Campo1';