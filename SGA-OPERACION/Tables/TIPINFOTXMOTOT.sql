CREATE TABLE OPERACION.TIPINFOTXMOTOT
(
  CODMOTOT  NUMBER(3)                           NOT NULL,
  TIPINFOT  NUMBER(5)                           NOT NULL
);

COMMENT ON TABLE OPERACION.TIPINFOTXMOTOT IS 'Tipos de informe de la ot asociada a los motivos de la ot';

COMMENT ON COLUMN OPERACION.TIPINFOTXMOTOT.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.TIPINFOTXMOTOT.TIPINFOT IS 'Tipo de instancia de servicio';


