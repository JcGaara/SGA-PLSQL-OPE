-- Create table
create table OPERACION.CONTRACT_BAJA_DTH_POST
(
  co_id       INTEGER,
  nro_tarjeta VARCHAR2(50),
  bouquetes   VARCHAR2(500),
  idsol       NUMBER(20),
  idlote      NUMBER(10),
  estado      NUMBER default 0,
  fecusu      DATE default SYSDATE,
  codusu      VARCHAR2(30) default USER
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
-- Add comments to the columns 
comment on column OPERACION.CONTRACT_BAJA_DTH_POST.idsol
  is 'Identificador de la solicitud de suspension/reconexion al conax';
comment on column OPERACION.CONTRACT_BAJA_DTH_POST.idlote
  is 'Identificar del lote dentro del cual sea procesada la solicitud';
comment on column OPERACION.CONTRACT_BAJA_DTH_POST.estado
  is '0: por porcesar, 1: Procesado';