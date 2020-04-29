/*Se crea la cabecera de los parametros en la tipopedd*/
insert into tipopedd (DESCRIPCION, ABREV)
values ('ESTADO SOLICITUD - DECO ADI', 'EST_SOL_DEC_ADI');
                                

/*Se crea los parametros en la tabla opedd*/
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 12, 'ESTADO DE LA SOT - CERRADO', 'EST_SOL', (select tipopedd 
                               from tipopedd 
                              where abrev = 'EST_SOL_DEC_ADI'),null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 29, 'ESTADO DE LA SOT - ATENDIDO', 'EST_SOL', (select tipopedd 
                               from tipopedd 
                              where abrev = 'EST_SOL_DEC_ADI'),null); 
                              
commit; 

/* Agregar default a OPERACION.SOLOT.areasol */
alter table OPERACION.SOLOT modify areasol default 200;
