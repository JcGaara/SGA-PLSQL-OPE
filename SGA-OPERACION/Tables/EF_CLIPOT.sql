CREATE TABLE OPERACION.EF_CLIPOT
(
  CODEF    NUMBER(8)                            NOT NULL,
  ORDEN    NUMBER(8)                            NOT NULL,
  CODCLI   CHAR(8 BYTE),
  NOMBRE   VARCHAR2(150 BYTE),
  OBSERV   VARCHAR2(1000 BYTE),
  FECUSU   DATE                                 DEFAULT SYSDATE               NOT NULL,
  CODUSU   VARCHAR2(30 BYTE)                    DEFAULT user                  NOT NULL,
  PROBVTA  NUMBER(3)
);

COMMENT ON TABLE OPERACION.EF_CLIPOT IS 'Clientes potenciales del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.PROBVTA IS 'Probabilidad de compra';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.ORDEN IS 'Orden de la tabla por cada ef';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.NOMBRE IS 'Nombre del cliente';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.OBSERV IS 'Observacion';

COMMENT ON COLUMN OPERACION.EF_CLIPOT.FECUSU IS 'Fecha de registro';


