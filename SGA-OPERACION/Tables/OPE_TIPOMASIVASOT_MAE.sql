-- Create table
create table OPERACION.OPE_TIPOMASIVASOT_MAE
(
  IDTIPO      number(2) ,
  DESCRIPCION varchar2(30)  not null,
  USUREG      varchar2(30) default USER,
  FECREG      date default SYSDATE,
  USUMOD      varchar2(30) default USER,
  FECMOD      date default SYSDATE
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
comment on table OPERACION.OPE_TIPOMASIVASOT_MAE
  is 'Tipo de Proceso Masivo de SOT';
-- Add comments to the columns 
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.IDTIPO
  is 'Identificador de Tipo de Proceso Masivo SOT';
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.DESCRIPCION
  is 'Descripcion de Tipo de Proceso Masivo SOT';
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.USUREG
  is 'Usuario que inserto el registro';
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_TIPOMASIVASOT_MAE.FECMOD
  is 'Fecha que  se modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_TIPOMASIVASOT_MAE
  add constraint PK_TIPOMASIVASOT_MAE unique (IDTIPO)
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
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to atccorp;
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to billcolper;
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to contrato;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to inter_autodesk;
grant select, insert, update on OPERACION.OPE_TIPOMASIVASOT_MAE to inter_compulinux;
grant select, insert, update on OPERACION.OPE_TIPOMASIVASOT_MAE to inter_webpe01;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to intraway;
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to opemt;
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to opewf;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to opewf with grant option;
grant select, insert, update on OPERACION.OPE_TIPOMASIVASOT_MAE to r_antv;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to r_aseguramiento;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to r_dw_oper;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to r_ituser;
grant delete on OPERACION.OPE_TIPOMASIVASOT_MAE to r_prod;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to r_webuni;
grant references on OPERACION.OPE_TIPOMASIVASOT_MAE to sales;
grant select, update on OPERACION.OPE_TIPOMASIVASOT_MAE to soporte;
grant select on OPERACION.OPE_TIPOMASIVASOT_MAE to telefonia;
