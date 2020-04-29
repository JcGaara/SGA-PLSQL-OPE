CREATE TABLE OPERACION.ACTXCONTRATAXPREC
(
  CODACT   NUMBER(5)                            NOT NULL,
  CODCON   NUMBER(6)                            NOT NULL,
  CODPREC  NUMBER(10)                           NOT NULL,
  COSTO    NUMBER(10,2)                         DEFAULT 0                     NOT NULL,
  CODUSU   VARCHAR2(30 BYTE)                    DEFAULT user                  NOT NULL,
  FECUSU   DATE                                 DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXCONTRATAXPREC IS 'Listado de actividades por contrata por Preciario';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.CODCON IS 'Codigo del contratista';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.CODPREC IS 'Codigo del Preciario';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.COSTO IS 'Costo de la actividad por contrata';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTXCONTRATAXPREC.FECUSU IS 'Fecha de registro';


