delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='CAMBIO_DIRECCION_TE');
delete from tipopedd where upper(abrev) = 'CAMBIO_DIRECCION_TE';

commit;
/