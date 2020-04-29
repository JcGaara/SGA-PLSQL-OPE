create table OPERACION.OPE_MASIVASOT_DET
(
  IDDETMASIVA   number(10) not null,
  IDMASIVA      number(10)  not null,
  CODSOLOT      number(10)  not null,
  DATO          number(10)  default 0,
  FLG_ERR       number(1) default 0,
  OBSERVACION   varchar2(2000),
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
comment on table OPERACION.OPE_MASIVASOT_DET
  is 'Detalle Proceso Masivo de SOT';
-- Add comments to the columns 

comment on column OPERACION.OPE_MASIVASOT_DET.IDDETMASIVA
  is 'Identificador de Detalle del Proceso Masivo SOT';
comment on column OPERACION.OPE_MASIVASOT_DET.IDMASIVA
  is 'Identificador de Proceso Masivo SOT';
comment on column OPERACION.OPE_MASIVASOT_DET.CODSOLOT
  is 'Identificador de SOT';
comment on column OPERACION.OPE_MASIVASOT_DET.DATO
  is 'Dato actual de la SOT, Puede ser de Estado o Workflow';
comment on column OPERACION.OPE_MASIVASOT_DET.FLG_ERR
  is 'Flag de Error del Proceso Masivo de SOT';
comment on column OPERACION.OPE_MASIVASOT_DET.OBSERVACION
  is 'Observacion dle Error del Proceso Masivo de SOT';
comment on column OPERACION.OPE_MASIVASOT_DET.USUREG
  is 'Usuario que inserto el registro';
comment on column OPERACION.OPE_MASIVASOT_DET.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_MASIVASOT_DET.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_MASIVASOT_DET.FECMOD
  is 'Fecha que  se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_MASIVASOT_DET
  add constraint PK_MASIVASOT_DET unique (IDDETMASIVA)
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
grant references on OPERACION.OPE_MASIVASOT_DET to atccorp;
grant references on OPERACION.OPE_MASIVASOT_DET to billcolper;
grant references on OPERACION.OPE_MASIVASOT_DET to contrato;
grant select on OPERACION.OPE_MASIVASOT_DET to inter_autodesk;
grant select, insert, update on OPERACION.OPE_MASIVASOT_DET to inter_compulinux;
grant select, insert, update on OPERACION.OPE_MASIVASOT_DET to inter_webpe01;
grant select on OPERACION.OPE_MASIVASOT_DET to intraway;
grant references on OPERACION.OPE_MASIVASOT_DET to opemt;
grant references on OPERACION.OPE_MASIVASOT_DET to opewf;
grant select on OPERACION.OPE_MASIVASOT_DET to opewf with grant option;
grant select, insert, update on OPERACION.OPE_MASIVASOT_DET to r_antv;
grant select on OPERACION.OPE_MASIVASOT_DET to r_aseguramiento;
grant select on OPERACION.OPE_MASIVASOT_DET to r_dw_oper;
grant select on OPERACION.OPE_MASIVASOT_DET to r_ituser;
grant delete on OPERACION.OPE_MASIVASOT_DET to r_prod;
grant select on OPERACION.OPE_MASIVASOT_DET to r_webuni;
grant references on OPERACION.OPE_MASIVASOT_DET to sales;
grant select, update on OPERACION.OPE_MASIVASOT_DET to soporte;
grant select on OPERACION.OPE_MASIVASOT_DET to telefonia;
