--
-- Create Tabla PREV_DIFPCRF
-- 

create table operacion.PREV_DIFPCRF
(
	ciclo           VARCHAR2(2),
	co_id           INTEGER , 
	dn_num          VARCHAR2(63),
	customer_id     INTEGER, 
	ch_status       VARCHAR2(1), 
	ch_validfrom    DATE,
	linea  			VARCHAR2(63), 
	billingcycleday VARCHAR2(255)
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
  

