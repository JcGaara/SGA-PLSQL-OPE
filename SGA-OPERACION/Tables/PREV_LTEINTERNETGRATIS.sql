--
-- Create Tabla PREV_LTEINTERNETGRATIS
-- 

create table OPERACION.PREV_LTEINTERNETGRATIS
(
  ciclo        NUMBER,
  co_id        NUMBER,
  dn_num       NUMBER,
  customer_id  NUMBER,
  ch_status    VARCHAR2(1),
  ch_validfrom DATE
)
tablespace operacion_dat
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

