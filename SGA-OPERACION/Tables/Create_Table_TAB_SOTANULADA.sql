-- Create table
create table OPERACION.TAB_SOTANULADA
(
  ESTADO      INTEGER,
  CODSOLOT    VARCHAR2(20),
  OBSERVACION VARCHAR2(50)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

