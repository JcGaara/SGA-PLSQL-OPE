insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values(
30,'Número de Ejecuciones en Paraleo','N_HILOS',(select tipopedd from operacion.tipopedd where abrev = 'CVE_CP'));

commit;
