CREATE TABLE OPERACION.MOTOT
(
  CODMOTOT     NUMBER(3)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE)               NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FLGCOM       NUMBER(1)                        DEFAULT 0                     NOT NULL,
  GRUPODESC    VARCHAR2(100 BYTE),
  TIPMOTOT     NUMBER(4)
);

COMMENT ON TABLE OPERACION.MOTOT IS 'Motivo de la Orden de Trabajo';

COMMENT ON COLUMN OPERACION.MOTOT.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.MOTOT.DESCRIPCION IS 'Descripcion del motivo de la ot';

COMMENT ON COLUMN OPERACION.MOTOT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.MOTOT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MOTOT.FLGCOM IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.MOTOT.GRUPODESC IS 'Descripcion del grupo';


