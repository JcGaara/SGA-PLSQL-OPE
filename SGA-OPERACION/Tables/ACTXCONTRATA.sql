CREATE TABLE OPERACION.ACTXCONTRATA
(
  CODACT  NUMBER(5)                             NOT NULL,
  CODCON  NUMBER(6)                             NOT NULL,
  COSTO   NUMBER(10,2)                          DEFAULT 0                     NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXCONTRATA IS 'Listado de actividades por contrata';

COMMENT ON COLUMN OPERACION.ACTXCONTRATA.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXCONTRATA.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.ACTXCONTRATA.COSTO IS 'Costo de la actividad por contrata';

COMMENT ON COLUMN OPERACION.ACTXCONTRATA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTXCONTRATA.FECUSU IS 'Fecha de registro';


