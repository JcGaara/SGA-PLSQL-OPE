CREATE TABLE OPERACION.ACCUSUETA
(
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  CODDPT  CHAR(6 BYTE)                          NOT NULL,
  CODETA  NUMBER(5)                             NOT NULL,
  FECUSU  DATE                                  DEFAULT sysdate               NOT NULL
);

COMMENT ON TABLE OPERACION.ACCUSUETA IS 'No es usada - Acceso de usuarios a la visualizacion de etapas';

COMMENT ON COLUMN OPERACION.ACCUSUETA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACCUSUETA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.ACCUSUETA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.ACCUSUETA.FECUSU IS 'Fecha de registro';


