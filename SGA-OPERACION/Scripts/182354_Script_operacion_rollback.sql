delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'MANT_IWAY_HFC');

delete from tipopedd where abrev = 'MANT_IWAY_HFC';

delete from operacion.estsol where DESCRIPCION = 'Rechazado por Sistemas';

commit;
/
