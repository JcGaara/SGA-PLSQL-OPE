insert into operacion.tipopedd (descripcion, abrev)
values ('Modificadores fecha servicio', 'PERM_CHG_FECHSERV');
commit;
/*
insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (1, 'EASTULLE', (select max(tipopedd) from operacion.tipopedd));
commit;
*/
insert into operacion.tipopedd (descripcion, abrev)
values ('Email soporte plataforma fija', 'EMAIL_PLAT_FIJA');
commit;

insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (1, 'ti-soporteplataformafija@claro.com.pe', (select max(tipopedd) from operacion.tipopedd));
commit;
