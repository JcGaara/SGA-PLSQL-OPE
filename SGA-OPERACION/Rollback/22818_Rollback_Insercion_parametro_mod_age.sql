delete from operacion.parametro_det_adc where id_parametro=(select id_parametro from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG');
delete from operacion.parametro_cab_adc where abreviatura='M_FLG_AOBLG';
commit;

alter table operacion.matriz_tystipsrv_tiptra_adc
drop column flgaobliga;