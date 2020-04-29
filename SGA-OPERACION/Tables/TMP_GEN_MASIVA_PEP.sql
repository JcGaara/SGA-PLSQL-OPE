CREATE TABLE OPERACION.TMP_GEN_MASIVA_PEP
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  NUMSLC       CHAR(10 BYTE)                    NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ESTADO       CHAR(1 BYTE)                     DEFAULT 0                     NOT NULL,
  TRANSACCION  NUMBER
);


