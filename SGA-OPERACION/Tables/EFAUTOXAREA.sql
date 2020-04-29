CREATE TABLE OPERACION.EFAUTOXAREA
(
  IDAREA       NUMBER(6)                        NOT NULL,
  IDEF         NUMBER(6),
  AREA         NUMBER(4),
  RESPONSABLE  INTEGER                          DEFAULT 0,
  ZONA         INTEGER                          DEFAULT 0,
  DIAPLAZO     NUMBER,
  DIAVALIDEZ   NUMBER,
  AMBITO       VARCHAR2(30 BYTE),
  ACTIVO       NUMBER
);


