Delete from opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'CVE_CP')
and abreviacion = 'N_HILOS';
commit;
