delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev = 'PERM_CHG_FECHSERV');
delete from operacion.tipopedd where abrev = 'PERM_CHG_FECHSERV';
delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev = 'EMAIL_PLAT_FIJA');
delete from operacion.tipopedd where abrev = 'EMAIL_PLAT_FIJA';

commit;

DROP TABLE OPERACION.ope_chgfechaservicio_his;

DROP SEQUENCE operacion.sq_ope_chgfechaservicio_his_id;