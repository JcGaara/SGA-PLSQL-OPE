alter table OPERACION.TABEQUIPO_MATERIAL modify imei_esn_ua null;
create index OPERACION.IDX_SERIE on OPERACION.TABEQUIPO_MATERIAL (numero_serie, tipo);
create index OPERACION.IDX_MAC on OPERACION.TABEQUIPO_MATERIAL (imei_esn_ua, tipo);
