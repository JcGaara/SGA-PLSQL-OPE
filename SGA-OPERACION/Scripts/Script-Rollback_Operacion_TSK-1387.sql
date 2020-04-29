alter table operacion.trssolot drop column idtipenv;
alter table operacion.trssolot drop column codemail;
alter table operacion.trssolot drop column feccodemail;

delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev='INC_TABGRUPO_MAIL');
delete from operacion.tipopedd where abrev='INC_TABGRUPO_MAIL';

delete from constante where constante = 'FAM_PYME';
delete from constante where constante = 'AFIL_PYME';
delete from constante where constante = 'AFIL_MAS';
delete from constante where constante = 'DIR_AFIL';

commit;