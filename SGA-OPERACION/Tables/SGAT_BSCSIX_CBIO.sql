create table OPERACION.SGAT_BSCSIX_CBIO
(
  codsolot		 NUMBER(8) not null,
  customer_id    INTEGER,
  co_id          INTEGER,
  customer_id_ix INTEGER not null,
  co_id_ix       INTEGER
);

comment on column OPERACION.SGAT_BSCSIX_CBIO.customer_id
  is 'Codigo de cliente de BSCS7';
comment on column OPERACION.SGAT_BSCSIX_CBIO.co_id
  is 'Codigo de contrato de BSCS7';
comment on column OPERACION.SGAT_BSCSIX_CBIO.customer_id_ix
  is 'Codigo de cliente de BSCSIX';
comment on column OPERACION.SGAT_BSCSIX_CBIO.co_id_ix
  is 'Codigo de contrato de BSCSIX';
  comment on column OPERACION.SGAT_BSCSIX_CBIO.codsolot
  is 'Codigo de solicitud';