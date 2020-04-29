-- Create table
create table OPERACION.MENSAJE_DTH_DET
(
  idarch  NUMBER not null,
  codtarj VARCHAR2(50) not null,
  flgagp  NUMBER(10),
  flgval  NUMBER(1),
  codfile NUMBER
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