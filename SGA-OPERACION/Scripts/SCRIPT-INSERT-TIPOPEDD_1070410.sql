insert into tipopedd (tipopedd,descripcion,abrev)
values ((select max(tipopedd) + 1 from operacion.tipopedd),'Envio de Recibo Fisico','INC_ENVRECFIS');
commit;
