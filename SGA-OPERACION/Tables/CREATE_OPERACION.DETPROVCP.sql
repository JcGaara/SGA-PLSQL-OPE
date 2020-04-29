-- Create table
create table OPERACION.DETPROVCP
(
  idseq            NUMBER(8) not null,
  iddet            NUMBER(8) not null,
  usercode         VARCHAR2(30) default user not null,
  userdate         DATE default sysdate not null,
  codaction        NUMBER(2),
  customer_id      VARCHAR2(15),
  ficha_origen     VARCHAR2(15),
  ficha_destino    VARCHAR2(15),
  service_id_old   VARCHAR2(50),
  service_id_new   VARCHAR2(50),
  service_type_old VARCHAR2(50),
  service_type_new VARCHAR2(50),
  sp_a_consumir    VARCHAR2(100),
  estado           NUMBER(2),
  codequcom        VARCHAR2(15),
  codsolot_old     NUMBER(15),
  codsolot_new     NUMBER(15)
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
alter table OPERACION.DETPROVCP
  add constraint PK_DETPROVCP primary key (IDSEQ)
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