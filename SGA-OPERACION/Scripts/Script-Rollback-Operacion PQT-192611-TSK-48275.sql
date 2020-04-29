--1.- ROLLBACK CONFIGURACIÓN DE WEBSERVICE
delete operacion.sga_ap_parametro where prmtc_tipo_param = 'WSACV';
delete operacion.sga_ap_parametro where prmtc_tipo_param = 'WSBCV';
commit;

--2.- ROLLBACK CONF. LISTA DE CORREOS
delete from operacion.opedd
 where tipopedd = (select t.tipopedd
                     from operacion.tipopedd t
                    where t.abrev = 'SVA_LISTA_EMAIL');
delete from operacion.tipopedd where abrev = 'SVA_LISTA_EMAIL';
--3.- ROLLBACK CONF. MAXIMO DE REINTENTOS
delete from operacion.opedd
 where tipopedd = (select t.tipopedd
                     from operacion.tipopedd t
                    where t.abrev = 'SVA_MAX_INTENTO');
delete from operacion.tipopedd where abrev = 'SVA_MAX_INTENTO';
commit;

--4.- Eliminar Trigger
drop trigger operacion.t_ope_trx_clarovideo_sva_aiud;
drop trigger operacion.t_ope_trx_clarovideo_sva_bi;
drop trigger operacion.t_ope_trx_clarovideo_sva_bu;
--5.- Eliminar Table
drop table operacion.ope_trx_clarovideo_sva;
