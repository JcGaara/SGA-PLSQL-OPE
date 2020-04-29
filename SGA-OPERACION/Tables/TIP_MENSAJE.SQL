-- Create table
create table OPERACION.TIP_MENSAJE
(
  idtipmens   NUMBER(2) not null,
  descripcion VARCHAR2(50) not null,
  fecusu      DATE default SYSDATE,
  codusu      VARCHAR2(30) default user not null,
  abrevi      CHAR(10) not null
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