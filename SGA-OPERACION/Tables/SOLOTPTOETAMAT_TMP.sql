CREATE TABLE OPERACION.SOLOTPTOETAMAT_TMP
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODMAT       CHAR(15 BYTE),
  CODCON       NUMBER(6),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  OBSERVACION  VARCHAR2(400 BYTE),
  CANDIS       NUMBER(8,2),
  COSDIS       NUMBER(10,2),
  FECFDIS      DATE,
  TRAN_SOLMAT  NUMBER,
  FLG_PROCESO  NUMBER(1)                        DEFAULT 0
);


