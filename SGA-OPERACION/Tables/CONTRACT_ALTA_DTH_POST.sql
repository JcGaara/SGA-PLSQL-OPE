-- Create table
create table OPERACION.CONTRACT_ALTA_DTH_POST
(
  co_id       INTEGER,
  nro_tarjeta VARCHAR2(50),
  bouquetes   VARCHAR2(500),
  idsol       NUMBER(20),
  idlote      NUMBER(10),
  fecusu      DATE default SYSDATE,
  codusu      VARCHAR2(30) default USER,
  estado      NUMBER default 0
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
comment on column OPERACION.CONTRACT_ALTA_DTH_POST.idsol
  is 'Identificador de la solicitud de suspension/reconexion al conax';
comment on column OPERACION.CONTRACT_ALTA_DTH_POST.idlote
  is 'Identificar del lote dentro del cual sea procesada la solicitud';
comment on column OPERACION.CONTRACT_ALTA_DTH_POST.estado
  is '0: por porcesar, 1: Procesado';
-- Create/Recreate indexes 
create index OPERACION.INDX_DTH_VV002 on OPERACION.CONTRACT_ALTA_DTH_POST (NRO_TARJETA)
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