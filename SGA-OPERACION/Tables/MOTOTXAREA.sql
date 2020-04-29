CREATE TABLE OPERACION.MOTOTXAREA
(
  CODMOTOT  NUMBER(3)                           NOT NULL,
  CODDPT    CHAR(6 BYTE)                        NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  AREA      NUMBER(4)                           NOT NULL
);

COMMENT ON TABLE OPERACION.MOTOTXAREA IS 'Motivos de la OT por cada area';

COMMENT ON COLUMN OPERACION.MOTOTXAREA.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.MOTOTXAREA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.MOTOTXAREA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.MOTOTXAREA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MOTOTXAREA.AREA IS 'Codigo de area';


