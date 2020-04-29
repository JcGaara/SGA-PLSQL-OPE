ALTER TABLE operacion.cfg_env_correo_contrata ADD QUERY2 VARCHAR2(4000);

UPDATE operacion.cfg_env_correo_contrata 
SET    QUERY2 = "QUERY";

COMMIT;

ALTER TABLE operacion.cfg_env_correo_contrata DROP COLUMN "QUERY";

ALTER TABLE  operacion.cfg_env_correo_contrata rename column QUERY2 to "QUERY";