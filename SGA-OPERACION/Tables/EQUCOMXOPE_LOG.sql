CREATE TABLE OPERACION.EQUCOMXOPE_LOG
(
  CODEQUCOM    CHAR(4 BYTE)                     NOT NULL,
  CODTIPEQU    CHAR(15 BYTE),
  CANTIDAD     NUMBER(8,2)                      NOT NULL,
  ESPARTE      NUMBER(1)                        NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  USUARIO_LOG  VARCHAR2(50 BYTE)                DEFAULT user,
  DATE_LOG     DATE                             DEFAULT sysdate,
  ACAO_LOG     CHAR(3 BYTE)
);


