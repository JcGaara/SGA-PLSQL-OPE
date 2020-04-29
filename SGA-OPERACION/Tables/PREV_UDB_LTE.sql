--
-- Create Tabla PREV_UDB_LTE
-- 

create table OPERACION.PREV_UDB_LTE
(
  c1        VARCHAR2(255),
  numero    NUMBER,
  c2        VARCHAR2(255),
  c3        VARCHAR2(255),
  num_modif NUMBER
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

  