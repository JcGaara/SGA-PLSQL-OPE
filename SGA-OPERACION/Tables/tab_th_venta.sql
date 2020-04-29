-- Create table
create table OPERACION.TAB_TH_VENTA
(
  idproceso   NUMBER not null,
  id_tarea    NUMBER not null,
  estado      NUMBER default 0,
  id_contrato NUMBER not null,
  fecstart    TIMESTAMP(6),
  fecfinish   TIMESTAMP(6),
  fecusu      DATE default sysdate,
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default user,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  flg_min     NUMBER,
  flg_max     NUMBER,
  data_n1     NUMBER,
  data_n2     NUMBER,
  data_n3     NUMBER,
  data_v1     VARCHAR2(500),
  data_v2     VARCHAR2(1000),
  data_v3     VARCHAR2(4000),
  data_d1     DATE,
  data_d2     DATE,
  data_d3     DATE
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
-- Add comments to the columns 
comment on column OPERACION.TAB_TH_VENTA.estado
  is '0= Pendiente 1=Procesado';
comment on column OPERACION.TAB_TH_VENTA.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.TAB_TH_VENTA.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.TAB_TH_VENTA.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.TAB_TH_VENTA.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TAB_TH_VENTA
  add constraint PK_TAB_TH_VENTA primary key (IDPROCESO, ID_TAREA, ID_CONTRATO)
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

