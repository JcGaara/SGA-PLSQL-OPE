-- Create table
create table OPERACION.SGAT_ASIG_HIS
(
  codquery NUMBER(8) not null,
  area     NUMBER(4) not null,
  tipo     NUMBER(1) not null,
  filtro   VARCHAR2(4000),
  codusu   VARCHAR2(30) default user not null,
  fecusu   DATE default SYSDATE not null
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