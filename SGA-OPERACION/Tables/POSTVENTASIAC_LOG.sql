-- Create table
create table OPERACION.POSTVENTASIAC_LOG
(
  idlog        NUMBER not null,
  co_id        NUMBER,
  customer_id  NUMBER,
  proceso      VARCHAR2(100),
  msgerror     varchar2(4000),
  usureg       VARCHAR2(50) default user not null,
  fecreg       DATE default sysdate not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
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
comment on table OPERACION.POSTVENTASIAC_LOG
  is 'Tabla de registro de log de errores Transacciones PostVenta';
-- Add comments to the columns 
comment on column OPERACION.POSTVENTASIAC_LOG.idlog
  is 'Identificador unico de la tabla';
comment on column OPERACION.POSTVENTASIAC_LOG.customer_id
  is 'Customer_ID';
comment on column OPERACION.POSTVENTASIAC_LOG.co_id
  is 'Contrato';
comment on column OPERACION.POSTVENTASIAC_LOG.msgerror
  is 'Texto descriptivo de error';
comment on column OPERACION.POSTVENTASIAC_LOG.usureg
  is 'Usuario de creacion del registro';
comment on column OPERACION.POSTVENTASIAC_LOG.fecreg
  is 'Fecha de creacion del resgitro';
comment on column OPERACION.POSTVENTASIAC_LOG.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.POSTVENTASIAC_LOG.pcaplicacion
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.POSTVENTASIAC_LOG
  add constraint PK_POSTVENTASIAC_LOG primary key (IDLOG)
  using index 
  tablespace OPERACION_DAT
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
-- Grant/Revoke object privileges 
grant select, insert, update, delete on OPERACION.POSTVENTASIAC_LOG to USREAISGA;
