
ALTER TABLE OPERACION.CFG_ENV_CORREO_CONTRATA ADD TIPOFORMATO  VARCHAR2(4);
ALTER TABLE OPERACION.CFG_ENV_CORREO_CONTRATA ADD CONDICION1  VARCHAR2(400);
ALTER TABLE OPERACION.CFG_ENV_CORREO_CONTRATA ADD CAMPOFECHA  VARCHAR2(50);
ALTER TABLE OPERACION.CFG_ENV_CORREO_CONTRATA ADD CAMPOSOT    VARCHAR2(50);
ALTER TABLE OPERACION.CFG_ENV_CORREO_CONTRATA ADD CAMPOPROY   VARCHAR2(50);

COMMENT ON COLUMN OPERACION.CFG_ENV_CORREO_CONTRATA.TIPOFORMATO IS 'Tipo de Formato';
COMMENT ON COLUMN OPERACION.CFG_ENV_CORREO_CONTRATA.CONDICION1  IS 'Query para agregar filtros adicionales';
COMMENT ON COLUMN OPERACION.CFG_ENV_CORREO_CONTRATA.CAMPOFECHA  IS 'Nombre del campo para busqueda: Fecha de envio Tabla.Campo';
COMMENT ON COLUMN OPERACION.CFG_ENV_CORREO_CONTRATA.CAMPOSOT    IS 'Nombre del campo para busqueda: N�mero de SOT Tabla.Campo';
COMMENT ON COLUMN OPERACION.CFG_ENV_CORREO_CONTRATA.CAMPOPROY   IS 'Nombre del campo para busqueda: N�mero de Proyecto Tabla.Campo';

