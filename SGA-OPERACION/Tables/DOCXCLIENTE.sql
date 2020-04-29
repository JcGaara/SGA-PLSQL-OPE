CREATE TABLE OPERACION.DOCXCLIENTE
(
  CODCLI       CHAR(8 BYTE)                     NOT NULL,
  ESTDOCXCLI   NUMBER(2)                        NOT NULL,
  OBSERVACION  VARCHAR2(500 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  CODUSUMOD    VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  FECUSUMOD    DATE                             DEFAULT sysdate               NOT NULL
);

COMMENT ON TABLE OPERACION.DOCXCLIENTE IS 'No es usada';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.ESTDOCXCLI IS 'Estado del documento';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.CODUSUMOD IS 'Registra el usuario que modifica un dato';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.DOCXCLIENTE.FECUSUMOD IS 'Fecha de modificacion';

