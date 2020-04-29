
Delete from opedd
where tipopedd = (select tipopedd from tipopedd where descripcion = 'SERVICIOS DE ALINEACION');

Delete from opedd
where tipopedd = (select tipopedd from tipopedd where descripcion = 'DIAS LISTADO DE ALINEACION');

Delete from tipopedd
where descripcion = 'SERVICIOS DE ALINEACION';

Delete from tipopedd
where descripcion = 'DIAS LISTADO DE ALINEACION';
commit;
/