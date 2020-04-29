DROP TABLE OPERACION.SGAT_ESTRATEGIA_LIB;

ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_nombre;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_direccion;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_distrito;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_tipo_proyecto;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_codigo_site;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_tipo_site;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_x;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_y;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_observacion;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_estado;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_ubigeo;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_idreqcab;
ALTER TABLE OPERACION.UBI_TECNICA DROP COLUMN ubitv_flag_nvl4;

delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT');

delete from operacion.tipopedd where abrev = 'CLAS_PROY_UBIT';

delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT');

delete from operacion.tipopedd where abrev = 'TIPO_SITE_UBIT';

DELETE FROM operacion.opedd WHERE abreviacion = 'REQ_REDMOVIL';

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='REQ_RED_MOVIL'); 

DELETE FROM operacion.tipopedd WHERE abrev = 'REQ_RED_MOVIL';

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE abrev='USU_REQ_RED_MOVIL'); 

DELETE FROM operacion.tipopedd WHERE abrev = 'USU_REQ_RED_MOVIL';

COMMIT;
/
