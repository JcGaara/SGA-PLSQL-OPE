CREATE TABLE OPERACION.PEX_OBSERVACION
(
  IDOBSERV     NUMBER(10)                       NOT NULL,
  CODSOLOT     NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10),
  OBSERVACION  VARCHAR2(4000 BYTE)              NOT NULL,
  OCURRENCIA   NUMBER(2)                        NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSUMOD    VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECUSUMOD    DATE                             DEFAULT SYSDATE               NOT NULL
);


