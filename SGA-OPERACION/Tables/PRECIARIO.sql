CREATE TABLE OPERACION.PRECIARIO
(
  CODPREC      NUMBER(8)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  FLG_VALIDO   CHAR(1 BYTE)                     DEFAULT 1                     NOT NULL,
  FLG_DEFAULT  CHAR(1 BYTE)                     DEFAULT 0                     NOT NULL,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECREG       DATE                             DEFAULT SYSDATE               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECMOD       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.PRECIARIO IS 'Preciarios de actividades';

COMMENT ON COLUMN OPERACION.PRECIARIO.CODPREC IS 'codigo del preciario';

COMMENT ON COLUMN OPERACION.PRECIARIO.DESCRIPCION IS 'descripcion del preciario';

COMMENT ON COLUMN OPERACION.PRECIARIO.FLG_VALIDO IS 'Indica si se puede visualizar o no';

COMMENT ON COLUMN OPERACION.PRECIARIO.FLG_DEFAULT IS 'preciario defaul solo puede haber uno marcado';


