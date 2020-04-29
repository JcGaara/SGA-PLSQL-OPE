create table OPERACION.CONFIG_EQUCOM_CP
(
  id            NUMBER,
  codequcom_new VARCHAR2(4),
  codequcom_old VARCHAR2(4),
  flag_aplica   CHAR(1),
  usureg        VARCHAR2(30) default user,
  fecreg        DATE default sysdate,
  usumod        VARCHAR2(30) default user,
  fecmod        DATE default sysdate
)
tablespace OPERACION_DAT;