insert into opedd(idopedd,codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
values((select max(idopedd) + 1 from opedd), '471',471,'Cambio direccion facturacion','INC_CAMDIRFAC',(SELECT tipopedd from tipopedd where abrev = 'INC_CAMDIRFAC'),NULL);
COMMIT;
/
