
delete from opedd where tipopedd = ( select tipopedd from tipopedd where abrev='CONF_EMAIL_GENE');
delete from tipopedd where abrev='CONF_EMAIL_GENE';

delete from opedd where tipopedd = ( SELECT tipopedd FROM tipopedd where abrev = 'CODIGOS_GENERICOS');
delete from tipopedd where abrev='CODIGOS_GENERICOS';

Commit;
/
