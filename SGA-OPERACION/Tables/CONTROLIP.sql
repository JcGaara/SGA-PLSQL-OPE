-- Create table
create table OPERACION.CONTROLIP
(
  idcontrol      NUMBER(8) not null,
  cod_cid        NUMBER(8) not null,
  cod_solot      NUMBER(8) not null,
  codinssrv      NUMBER(10),
  ip_cm          VARCHAR2(32),
  mac_address_cm VARCHAR2(32),
  num_serie      VARCHAR2(32),
  modelo         VARCHAR2(40),
  red_pc         VARCHAR2(20),
  id_servicio    NUMBER(10),
  id_producto    VARCHAR2(30),
  id_venta       VARCHAR2(30),
  ips_cpe_fija   VARCHAR2(32),
  mac_cpe_fija   VARCHAR2(32),
  dispositivo    VARCHAR2(50),
  cmts           VARCHAR2(40),
  fec_alta       DATE,
  fec_baja       DATE,
  codusu         VARCHAR2(30),
  fecusu         DATE,
  codusumod      VARCHAR2(30),
  fecusumod      DATE,
  estado         NUMBER(1) default 0
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 10M
    next 1M
    minextents 1
    maxextents unlimited
  );
