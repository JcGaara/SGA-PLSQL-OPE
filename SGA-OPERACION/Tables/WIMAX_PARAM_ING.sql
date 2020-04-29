-- Create table
create table OPERACION.WIMAX_PARAM_ING
(
  COD_PARA   NUMBER(5) not null,
  CAMPO_PARA VARCHAR2(50),
  POSI_PARA  NUMBER(3),
  COD_ESCE   NUMBER(5),
  TECNOL     CHAR(1),
  COD_OPE    NUMBER,
  FECUSU     DATE default SYSDATE not null,
  CODUSU     VARCHAR2(30) default user not null
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.WIMAX_PARAM_ING
  add constraint WIMAX_PARAM_ING_PK primary key (COD_PARA)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );