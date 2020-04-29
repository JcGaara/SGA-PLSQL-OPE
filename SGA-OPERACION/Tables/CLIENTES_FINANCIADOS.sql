CREATE TABLE OPERACION.CLIENTES_FINANCIADOS
(
  CODCLI      VARCHAR2(10 BYTE)                 NOT NULL,
  FLG_ACTIVO  NUMBER(1)                         DEFAULT 0
);

COMMENT ON COLUMN OPERACION.CLIENTES_FINANCIADOS.CODCLI IS 'Código del cliente financiado manualmente';

COMMENT ON COLUMN OPERACION.CLIENTES_FINANCIADOS.FLG_ACTIVO IS 'Si el cliente esta con solicitud de financiamiento manual';


