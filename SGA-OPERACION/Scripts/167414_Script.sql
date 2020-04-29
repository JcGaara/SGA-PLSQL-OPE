alter table OPERACION.CFG_ENV_CORREO_CONTRATA add syntaxdw long;
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.syntaxdw
  is 'Sintaxis DW';
alter table OPERACION.SOT_LIQUIDACION add neto_val NUMBER(10,2) default 0;
comment on column OPERACION.SOT_LIQUIDACION.neto_val
  is 'Neto Valorizacion';

create index OPERACION.IDX_SOLOT_22 on OPERACION.SOLOT (CUSTOMER_ID);
