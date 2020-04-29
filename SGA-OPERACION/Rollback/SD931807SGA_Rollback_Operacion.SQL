-- Eliminacion de Tipos y Estados
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_TAREAS_LTE' );
commit;
delete from tipopedd where abrev = 'CONF_TAREAS_LTE';
commit;

delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_LTE_JANUS' );
commit;
delete from tipopedd where abrev = 'CONF_LTE_JANUS';
commit;
/