-- Insert to OPEDD 'Días calendario de búsqueda de Proyectos Rechazados'
insert into opedd(codigon,descripcion,abreviacion,tipopedd,codigon_aux)
           values(90,'Días calendario de búsqueda de Proyectos Rechazados por Créditos','DIAS_CREDITO_RECH',(select tipopedd from tipopedd where abrev = 'CONSTANTES'),0);
commit;