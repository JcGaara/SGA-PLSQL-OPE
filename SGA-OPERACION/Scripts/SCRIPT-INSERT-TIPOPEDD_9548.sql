insert into tipopedd (tipopedd,descripcion,abrev)
values ((select max(tipopedd) + 1 from operacion.tipopedd),'Cambio Direccion Facturacion','INC_CAMDIRFAC');
commit;
/