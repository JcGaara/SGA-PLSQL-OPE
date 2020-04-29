CREATE TABLE OPERACION.ESTTRANSFCO
(
  ESTTRANSFCO  NUMBER(8)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECREG       DATE                             DEFAULT SYSDATE               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECMOD       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ESTTRANSFCO IS 'tabla de estado de la transaccion';

COMMENT ON COLUMN OPERACION.ESTTRANSFCO.ESTTRANSFCO IS 'Estado de la solicitud';

COMMENT ON COLUMN OPERACION.ESTTRANSFCO.DESCRIPCION IS 'Descripcion del estado de la transaccion';


