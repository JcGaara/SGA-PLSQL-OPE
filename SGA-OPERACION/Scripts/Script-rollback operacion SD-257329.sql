alter table OPERACION.TABEQUIPO_MATERIAL modify imei_esn_ua not null;
drop index OPERACION.IDX_MAC;
drop index OPERACION.IDX_SERIE;