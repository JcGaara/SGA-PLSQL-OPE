insert into opedd(idopedd,codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
values((select max(idopedd) + 1 from opedd), '731', 731,'Recibo envio fisico','INC_ENVRECFIS',(SELECT tipopedd from tipopedd where abrev = 'INC_ENVRECFIS'),NULL);
COMMIT; 



