create table OPERACION.OPE_MASIVASOT_CAB
(
  IDMASIVA      number(10) not null,
  IDTIPO        number(2)  not null,
  TOTAL         number(10) default 0,
  TOTERR        number(10) default 0,
  USUREG        varchar2(30) default USER,
  FECREG        date default SYSDATE,
  USUMOD        varchar2(30) default USER,
  FECMOD        date default SYSDATE
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 10720K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPERACION.OPE_MASIVASOT_CAB
  is 'Cabecera Proceso Masivo de SOT';
-- Add comments to the columns 

comment on column OPERACION.OPE_MASIVASOT_CAB.IDMASIVA
  is 'Identificador de Proceso Masivo SOT';
comment on column OPERACION.OPE_MASIVASOT_CAB.IDTIPO
  is 'Identificador de Tipo de Proceso Masivo SOT';
comment on column OPERACION.OPE_MASIVASOT_CAB.TOTAL
  is 'Total de Procesos Masivos SOT';
comment on column OPERACION.OPE_MASIVASOT_CAB.TOTERR
  is 'Total de Procesos Masivos SOT con Error';  
comment on column OPERACION.OPE_MASIVASOT_CAB.USUREG
  is 'Usuario que inserto el registro';
comment on column OPERACION.OPE_MASIVASOT_CAB.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_MASIVASOT_CAB.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_MASIVASOT_CAB.FECMOD
  is 'Fecha que  se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_MASIVASOT_CAB
  add constraint PK_MASIVASOT_CAB unique (IDMASIVA)
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
grant references on OPERACION.OPE_MASIVASOT_CAB to atccorp;
grant references on OPERACION.OPE_MASIVASOT_CAB to billcolper;
grant references on OPERACION.OPE_MASIVASOT_CAB to contrato;
grant select on OPERACION.OPE_MASIVASOT_CAB to inter_autodesk;
grant select, insert, update on OPERACION.OPE_MASIVASOT_CAB to inter_compulinux;
grant select, insert, update on OPERACION.OPE_MASIVASOT_CAB to inter_webpe01;
grant select on OPERACION.OPE_MASIVASOT_CAB to intraway;
grant references on OPERACION.OPE_MASIVASOT_CAB to opemt;
grant references on OPERACION.OPE_MASIVASOT_CAB to opewf;
grant select on OPERACION.OPE_MASIVASOT_CAB to opewf with grant option;
grant select, insert, update on OPERACION.OPE_MASIVASOT_CAB to r_antv;
grant select on OPERACION.OPE_MASIVASOT_CAB to r_aseguramiento;
grant select on OPERACION.OPE_MASIVASOT_CAB to r_dw_oper;
grant select on OPERACION.OPE_MASIVASOT_CAB to r_ituser;
grant delete on OPERACION.OPE_MASIVASOT_CAB to r_prod;
grant select on OPERACION.OPE_MASIVASOT_CAB to r_webuni;
grant references on OPERACION.OPE_MASIVASOT_CAB to sales;
grant select, update on OPERACION.OPE_MASIVASOT_CAB to soporte;
grant select on OPERACION.OPE_MASIVASOT_CAB to telefonia;