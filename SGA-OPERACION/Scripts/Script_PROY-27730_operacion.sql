insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Visualizar Numeros de Contacto', 'VIS_NROCONTACT');

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (0, 'Activar Cambios - Contactos Cliente', 'ACT_COMCNT', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'VIS_NROCONTACT'));

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (1, 'Activar Cambios - Listar Cliente', 'LST_COMCNT', (SELECT t.tipopedd FROM tipopedd t WHERE t.abrev = 'VIS_NROCONTACT'));

commit;
/