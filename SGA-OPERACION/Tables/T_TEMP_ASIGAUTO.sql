CREATE TABLE OPERACION.T_TEMP_ASIGAUTO
(
  CODPUERTO  NUMBER(8)                          NOT NULL,
  CID        NUMBER(10)                         NOT NULL,
  ESTADO     NUMBER(1)                          DEFAULT 1,
  CODUSU     VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECUSU     DATE                               DEFAULT sysdate               NOT NULL,
  CODUSUMOD  VARCHAR2(30 BYTE)                  DEFAULT user                  NOT NULL,
  FECUSUMOD  DATE                               DEFAULT sysdate               NOT NULL
);


