--
-- Create Tabla PREV_PCRF
-- 

create table OPERACION.PREV_PCRF
(
  subscriberidentifier VARCHAR2(255),
  msisdn               VARCHAR2(255),
  homesrvzone          VARCHAR2(255),
  paidtype             VARCHAR2(255),
  category             VARCHAR2(255),
  station              VARCHAR2(255),
  masteridentifier     VARCHAR2(255),
  billingcycleday      VARCHAR2(255),
  servicename          VARCHAR2(255),
  subscribedatetime    VARCHAR2(255),
  validfromdatetime    VARCHAR2(255),
  expireddatetime      VARCHAR2(255),
  quotaname            VARCHAR2(255),
  initialvalue         VARCHAR2(255),
  balance              VARCHAR2(255),
  consumption          VARCHAR2(255),
  status               VARCHAR2(255),
  linea                NUMBER
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
  
