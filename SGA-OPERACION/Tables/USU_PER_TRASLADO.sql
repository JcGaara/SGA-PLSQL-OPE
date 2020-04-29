CREATE TABLE OPERACION.USU_PER_TRASLADO
(
  USUARIO    VARCHAR2(30 BYTE)                  NOT NULL,
  CODPERFIL  NUMBER                             NOT NULL,
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECREG     DATE                               DEFAULT sysdate,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECMOD     DATE                               DEFAULT sysdate               NOT NULL,
  ESTADO     NUMBER                             DEFAULT 0
);

COMMENT ON TABLE OPERACION.USU_PER_TRASLADO IS 'Tabla de usuarios por perfil de traslado';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.USUARIO IS 'Usuario';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.CODPERFIL IS 'Perfil de Traslado';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.USUREG IS 'Fecha de Registro';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.FECREG IS 'Usuario de Registro';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.USUMOD IS 'Usuario modificador de Registro';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.FECMOD IS 'Fecha de modificación de Registro';

COMMENT ON COLUMN OPERACION.USU_PER_TRASLADO.ESTADO IS 'Estado del registro ';


