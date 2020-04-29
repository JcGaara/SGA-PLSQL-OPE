insert into opedd
(codigoc,descripcion, abreviacion, tipopedd)
values('01','CICLO', 'CICLO', (Select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE'));
   
COMMIT;
