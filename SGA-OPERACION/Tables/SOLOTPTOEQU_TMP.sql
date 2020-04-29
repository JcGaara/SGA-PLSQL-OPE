CREATE TABLE OPERACION.SOLOTPTOEQU_TMP
(
  CODSOLOT     NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  TIPPRP       NUMBER(2)                        NOT NULL,
  COSTO        NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  NUMSERIE     VARCHAR2(2000 BYTE),
  FECINS       DATE,
  ESTADO       NUMBER(2),
  CODEQUCOM    CHAR(4 BYTE),
  TIPO         NUMBER(2),
  TIPCOMPRA    NUMBER(2),
  OBSERVACION  VARCHAR2(240 BYTE),
  FLGSOL       NUMBER(3)                        DEFAULT 0                     NOT NULL,
  FLGREQ       NUMBER(3)                        DEFAULT 0                     NOT NULL,
  CODETA       NUMBER(5),
  CODALMACEN   NUMBER(10),
  FECFINS      DATE,
  FECFDIS      DATE,
  TRAN_SOLMAT  NUMBER,
  FLG_PROCESO  NUMBER(1)                        DEFAULT 0
);


