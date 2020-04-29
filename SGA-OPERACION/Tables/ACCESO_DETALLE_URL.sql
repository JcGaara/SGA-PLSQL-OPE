CREATE TABLE OPERACION.ACCESO_DETALLE_URL
(
  URL_ID           NUMBER                       NOT NULL,
  CID              NUMBER                       NOT NULL,
  URL_TYPE_CODE    NUMBER                       NOT NULL,
  URL_DESCRIPTION  VARCHAR2(254 BYTE),
  URL_TEXT         VARCHAR2(200 BYTE)           NOT NULL
);

COMMENT ON TABLE OPERACION.ACCESO_DETALLE_URL IS 'Tabla que almacena los urls asignados a cada circuito';

COMMENT ON COLUMN OPERACION.ACCESO_DETALLE_URL.URL_ID IS 'Identificador del detalle de urls el cual se alimenta del secuencial acceso_detalle_url_s';

COMMENT ON COLUMN OPERACION.ACCESO_DETALLE_URL.CID IS 'Identificador de circuito';

COMMENT ON COLUMN OPERACION.ACCESO_DETALLE_URL.URL_TYPE_CODE IS 'Usa la tabla de maestros de tipos: ACCESO_DETALLE_URL_TYPES';

COMMENT ON COLUMN OPERACION.ACCESO_DETALLE_URL.URL_DESCRIPTION IS 'Descripción de la ruta url';

COMMENT ON COLUMN OPERACION.ACCESO_DETALLE_URL.URL_TEXT IS 'URL';


