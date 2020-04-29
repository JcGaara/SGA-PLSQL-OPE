CREATE TABLE OPERACION.MATRIZPRECIO
(
  CODIGO                NUMBER(8)               NOT NULL,
  TIPO                  NUMBER(2)               NOT NULL,
  CODSRV                CHAR(4 BYTE)            NOT NULL,
  SERVICIO_CODSRV       CHAR(4 BYTE)            NOT NULL,
  SERVICIO_COSTO        NUMBER(12,4)            DEFAULT 0,
  SERVICIO_INSTALACION  NUMBER(12,4)            DEFAULT 0,
  CODUSU                VARCHAR2(30 BYTE)       DEFAULT user,
  FECUSU                DATE                    DEFAULT sysdate,
  CODUSUMOD             VARCHAR2(30 BYTE)       DEFAULT user,
  FECUSUMOD             DATE                    DEFAULT sysdate
);


