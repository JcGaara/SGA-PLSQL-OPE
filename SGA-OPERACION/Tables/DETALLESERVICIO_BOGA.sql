CREATE TABLE OPERACION.DETALLESERVICIO_BOGA
(
  CODCLI        VARCHAR2(8 BYTE),
  LINEA         NUMBER(3),
  MONEDA        NUMBER(1),
  TARIFA        NUMBER(4),
  DESTARIFA     VARCHAR2(40 BYTE),
  MONTO         NUMBER,
  PERIODICIDAD  NUMBER(1),
  CANTIDAD      NUMBER(5),
  CODCLI_ANT    VARCHAR2(8 BYTE)
);

