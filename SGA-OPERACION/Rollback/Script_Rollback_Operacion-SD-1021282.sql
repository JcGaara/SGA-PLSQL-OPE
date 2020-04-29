delete from opedd where tipopedd IN (SELECT t.tipopedd from tipopedd t where abrev = 'GC_CONF_SOT_RX');
delete from tipopedd where abrev = 'GC_CONF_SOT_RX';
commit;
