CREATE TABLE OPERACION.NCOS
(
  NCOS            VARCHAR2(10 BYTE)             NOT NULL,
  IDTIPOBLOQUEO   VARCHAR2(20 BYTE),
  MNEMONICO       CHAR(3 BYTE),
  DESCRIPCION     VARCHAR2(100 BYTE),
  ESTADO          NUMBER(1)                     DEFAULT 0                     NOT NULL,
  TIPO            CHAR(1 BYTE)                  DEFAULT 'B'                   NOT NULL,
  CODSRV_MONEDA1  CHAR(4 BYTE),
  CODRV_MONEDA2   CHAR(4 BYTE)
);

COMMENT ON COLUMN OPERACION.NCOS.IDTIPOBLOQUEO IS 'Ingresar el IDTIPOBLOEQUEO MENOR primero';

COMMENT ON COLUMN OPERACION.NCOS.TIPO IS 'B=Bloqueo; C= Corte';


