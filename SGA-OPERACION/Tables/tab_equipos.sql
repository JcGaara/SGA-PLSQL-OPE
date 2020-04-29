-- Create table
create table OPERACION.TAB_EQUIPOS
(
  idlote            NUMBER,
  ori_reg           VARCHAR2(50),
  co_id             NUMBER,
  tipo_serv         VARCHAR2(10),
  id_producto       NUMBER,
  id_producto_padre NUMBER,
  numero_serie      VARCHAR2(100),
  mac_address       VARCHAR2(100),
  modelo            VARCHAR2(100),
  codprov_iw        VARCHAR2(100),
  unit_address      VARCHAR2(100),
  reserva_act       DATE,
  instal_act        DATE,
  estado_recurso    VARCHAR2(2),
  codsolot          NUMBER,
  numero            VARCHAR2(20),
  data_n1           NUMBER,
  data_n2           NUMBER,
  data_n3           NUMBER,
  data_n4           NUMBER,
  data_n5           NUMBER,
  data_v1           VARCHAR2(500),
  data_v2           VARCHAR2(500),
  data_v3           VARCHAR2(1000),
  data_v4           VARCHAR2(4000),
  data_v5           VARCHAR2(4000),
  data_d1           DATE,
  data_d2           DATE,
  data_d3           DATE,
  fecusu            DATE default SYSDATE not null
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
