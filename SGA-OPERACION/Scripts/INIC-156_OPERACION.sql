-- Insert to OPEDD 'D�as calendario de b�squeda de Proyectos Rechazados'
insert into opedd(codigon,descripcion,abreviacion,tipopedd,codigon_aux)
           values(90,'D�as calendario de b�squeda de Proyectos Rechazados por Cr�ditos','DIAS_CREDITO_RECH',(select tipopedd from tipopedd where abrev = 'CONSTANTES'),0);
commit;