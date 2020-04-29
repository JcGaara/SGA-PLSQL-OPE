CREATE TABLE OPERACION.SOLOT_ADI
(
  CODSOLOT    NUMBER(8)                         NOT NULL,
  ANATEL      VARCHAR2(30 BYTE),
  DIVSOT      NUMBER(2),
  FLGEF       NUMBER(1),
  FLGSOT      NUMBER(1),
  FEC_FLGSOT  DATE
);

COMMENT ON TABLE OPERACION.SOLOT_ADI IS 'Datos adicionales de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.ANATEL IS 'Numero de anatel';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.DIVSOT IS 'Identicador de la solicitud (cliente, empresa)';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.FLGEF IS 'Indica si la solot ha sido revisada';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.FLGSOT IS 'Indica si la solot ha sido revisada';

COMMENT ON COLUMN OPERACION.SOLOT_ADI.FEC_FLGSOT IS 'Fecha de revision de la solot';


