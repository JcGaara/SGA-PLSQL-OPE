/*rolback*/
--F1
--1.a
delete from operacion.opedd where tipopedd=200 and codigon=5;
commit;
update operacion.opedd set descripcion='Derivado' where idopedd=1756; --codigon:2
update operacion.opedd set descripcion='Eliminado' where idopedd=1757; --codigon:3
commit;
--2.a
--detalle
delete from operacion.opedd where tipopedd = (select tipopedd from tipopedd where abrev='OPE_AREAS_LIQUID'); 
delete from operacion.tipopedd where abrev='OPE_AREAS_LIQUID';
commit;
--2.b
delete from operacion.opedd where tipopedd = (select tipopedd from tipopedd where abrev='OPE_SERV_LIQUID'); 
delete from operacion.tipopedd where abrev='OPE_SERV_LIQUID';
commit;
--2.c
delete from operacion.opedd where tipopedd = (select tipopedd from tipopedd where abrev='OPE_EVAL_LIQ_MO'); 
delete from operacion.tipopedd where abrev='OPE_EVAL_LIQ_MO';
commit;

--actualiza los analistas 
update operacion.sot_liquidacion set analista = null
where analista = codusu;
commit;

update operacion.sot_liquidacion set tota_valoriz = null;
commit;
--F2
-- Drop columns 
alter table OPEWF.USUARIOXAREAOPE drop column flg_supervxarea;

--F3
-- Drop columns 
alter table OPERACION.SOT_LIQUIDACION drop (FEC_PROP_CIERRE ,FEC_RECIB_CONTRATA,NUM_PEDIDO_COMPRA,FEC_PEDIDO_COMPRA,NUM_DIAS,EVAL_TECNICA,EVAL_LIQUIDACION,SUPERV_SERVICIO,ID_SERV_LIQUID,tota_valoriz);

drop index OPERACION.IDX_SOT_LIQUIDACION_01;
drop index OPERACION.IDX_SOLOTPTOETA_01;
drop index OPERACION.IDX_SOLOTPTOETAACT_01;