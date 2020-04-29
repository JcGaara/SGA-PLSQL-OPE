-- Create table
create table OPERACION.BAJA_DTH_POS
(
  nro_tarjeta VARCHAR2(20),
  buquets     VARCHAR2(20),
  tipo        VARCHAR2(20),
  fecusu      DATE default sysdate,
  codusu      VARCHAR2(10) default user,
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcapp       VARCHAR2(30) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
-- Create/Recreate indexes 
create index OPERACION.IDX_NROTARJETA_BAJA_V1 on OPERACION.BAJA_DTH_POS (NRO_TARJETA)
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