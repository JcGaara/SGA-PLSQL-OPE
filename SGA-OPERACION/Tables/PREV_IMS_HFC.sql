--
-- Create Tabla PREV_IMS_HFC
-- 

create table OPERACION.PREV_IMS_HFC
(
  numero    NUMBER,
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
