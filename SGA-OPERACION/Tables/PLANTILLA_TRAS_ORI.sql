CREATE TABLE OPERACION.PLANTILLA_TRAS_ORI
(
  CODPERFIL    NUMBER,
  CENTRO_ORI   VARCHAR2(4 BYTE),
  ALMACEN_ORI  VARCHAR2(4 BYTE),
  ESTADO       NUMBER                           DEFAULT 1,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECREG       DATE                             DEFAULT sysdate               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECMOD       DATE                             DEFAULT sysdate               NOT NULL
);

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.CODPERFIL IS 'Perfil de Plantilla';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.CENTRO_ORI IS 'Centro Origen de Traslado';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.ALMACEN_ORI IS 'Almacen Origen de Traslado';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.USUREG IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.FECREG IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.USUMOD IS 'Codigo de Usuario modificador';

COMMENT ON COLUMN OPERACION.PLANTILLA_TRAS_ORI.FECMOD IS 'Fecha de modificación';


