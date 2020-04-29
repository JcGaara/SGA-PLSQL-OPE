create table operacion.ope_sot_masiva_log
(
  id_log      NUMBER(10) not null,
  numslc      CHAR(10) not null,
  codsolot    NUMBER(8) not null,
  observacion VARCHAR2(2000) not null,
  usureg      VARCHAR2(30) default USER,
  fecreg      DATE default SYSDATE
)
tablespace OPERACION_DAT;
