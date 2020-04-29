--
-- Create Tabla PREV_LTEACTSUS
-- 

create table OPERACION.PREV_LTEACTSUS
(
  co_id        NUMBER,
  customer_id  NUMBER,
  tmcode       NUMBER,
  ch_status    VARCHAR2(100),
  ch_validfrom DATE,
  numero       NUMBER,
  ch_pending   VARCHAR2(1)
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

  