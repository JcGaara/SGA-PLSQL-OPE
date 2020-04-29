--SECUENCIA PARA CAMBIAR EL TIPO DE DATO

ALTER TABLE operacion.cfg_env_correo_contrata ADD QUERY2 CLOB;

UPDATE operacion.cfg_env_correo_contrata 
SET    QUERY2= QUERY;

COMMIT;

ALTER TABLE operacion.cfg_env_correo_contrata DROP COLUMN  "QUERY";

ALTER TABLE  operacion.cfg_env_correo_contrata rename column QUERY2 to "QUERY";

COMMENT ON COLUMN operacion.cfg_env_correo_contrata.query  IS 'Contenido del query';
