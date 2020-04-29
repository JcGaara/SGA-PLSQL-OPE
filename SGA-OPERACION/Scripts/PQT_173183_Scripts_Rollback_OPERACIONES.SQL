
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_FID' );
delete from tipopedd where abrev = 'CONF_FID';
delete from tiptrabajo where descripcion = 'HFC - UPGRADE/DOWNGRADE INTERNET FIDELIZACION';

commit;