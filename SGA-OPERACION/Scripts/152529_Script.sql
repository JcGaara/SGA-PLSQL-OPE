alter table OPERACION.OPE_GRUPO_BOUQUET_CAB add FLG_VISIBLE NUMBER(1) default 1;
comment on column OPERACION.OPE_GRUPO_BOUQUET_CAB.FLG_VISIBLE
  is 'Visible en la activacion de bouquets';

