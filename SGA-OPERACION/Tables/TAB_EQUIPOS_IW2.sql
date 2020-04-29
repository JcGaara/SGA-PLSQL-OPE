-- Create table
create table OPERACION.TAB_EQUIPOS_IW2
(
  id_ticket     NUMBER,
  codsolot      NUMBER,
  customer_id   NUMBER,
  cod_id        NUMBER,
  tipo_servicio VARCHAR2(5),
  interfase     NUMBER,
  id_producto   VARCHAR2(10),
  modelo        VARCHAR2(30),
  mac_address   VARCHAR2(100),
  serial_number VARCHAR2(100),
  unit_address  VARCHAR2(100),
  stbtypecrmid  VARCHAR2(100),
  codusu        VARCHAR2(20) default USER,
  fecusu        DATE default SYSDATE,
  profile_crm   VARCHAR2(100),
  origen        NUMBER default 0
)
tablespace OPERACION_IDX
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
-- Create/Recreate indexes 
create index OPERACION.IDX_TAB_EQUIPOS_IW2_01 on OPERACION.TAB_EQUIPOS_IW2 (CODSOLOT)
  tablespace OPERACION_IDX
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
create index OPERACION.IDX_TAB_EQUIPOS_IW2_02 on OPERACION.TAB_EQUIPOS_IW2 (COD_ID)
  tablespace OPERACION_IDX
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
create index OPERACION.IDX_TAB_EQUIPOS_IW2_03 on OPERACION.TAB_EQUIPOS_IW2 (ID_PRODUCTO)
  tablespace OPERACION_IDX
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
create index OPERACION.IDX_TAB_EQUIPOS_IW2_04 on OPERACION.TAB_EQUIPOS_IW2 (ID_TICKET)
  tablespace OPERACION_IDX
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
