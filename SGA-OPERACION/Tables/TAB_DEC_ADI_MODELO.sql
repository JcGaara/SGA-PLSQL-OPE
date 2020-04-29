-- Create table
create table OPERACION.TAB_DEC_ADI_MODELO
(
  modelo      VARCHAR2(30),
  cod_sga     CHAR(4),
  cod_siac    CHAR(4),
  fecusu      DATE default SYSDATE,
  codusu      VARCHAR2(30) default USER,
  estado      NUMBER default 1
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