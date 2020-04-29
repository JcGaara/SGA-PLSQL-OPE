-- Create table
create table OPERACION.JANUS_SOLOT_SEG
(
  codsolot    NUMBER,
  cod_id      NUMBER,
  customer_id NUMBER,
  accion      VARCHAR2(20),
  fecusu      DATE default sysdate,
  codusu      VARCHAR2(10) default user
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
-- Add comments to the table 
comment on table OPERACION.JANUS_SOLOT_SEG
  is 'Tabla de seguimiento de acciones en Contigencia para Llanos';
-- Create/Recreate indexes 
create index OPERACION.IDX_CODSOLOT_SEGJANUS on OPERACION.JANUS_SOLOT_SEG (CODSOLOT)
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
