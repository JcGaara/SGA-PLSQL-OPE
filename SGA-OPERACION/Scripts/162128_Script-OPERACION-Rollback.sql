delete from operacion.tiptraxarea where area = 54 and tiptra in (select tiptra  from operacion.tiptrabajo where descripcion like 'CAMBIO RECAUDACION TPI%');
--- solo se puede eliminar si no se creo ningun proyecto
--- delete from operacion.tiptrabajo where descripcion like 'CAMBIO RECAUDACION TPI%';

delete from opedd where descripcion like 'CAMBIO RECAUDACION TPI%';
delete from wfdef where descripcion like 'CAMBIO RECAUDACION TPI%';

commit;

