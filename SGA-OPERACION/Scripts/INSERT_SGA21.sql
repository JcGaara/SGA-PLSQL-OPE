declare
li_tipopedd number;
begin

 insert into operacion.tipopedd (descripcion, abrev)
 values ('Tipo de trabajo para SISACT','SISACT_TIPTRA'); 

  begin
    select tipopedd into li_tipopedd from operacion.tipopedd
    where descripcion = 'Tipo de trabajo para SISACT' and abrev = 'SISACT_TIPTRA';
  exception
   when no_data_found then
     li_tipopedd := 0;
   when others then
     li_tipopedd := 0;
  end;

 if li_tipopedd > 0 then

 	insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
	values ('S', 744, 'Venta Sisact', 'TIPTRA_VENTA_SISACT', li_tipopedd, 1);
	insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
	values ('S', 756, 'Deco Adicional', 'TIPTRA_DECO_ADICI', li_tipopedd, 1);
	insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
	values ('N', 817, 'Cambio Equipo', 'TIPTRA_CAMBIO_EQUIPO', li_tipopedd, 0);
	insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
	values ('N', 818, 'Baja Deco Adicional', 'TIPTRA_BAJA_DECO_ADI', li_tipopedd, 0);
	insert into operacion.opedd (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
	values ('S', 819, 'Mixto Deco Adicional', 'TIPTRA_MIXTO_DECO_ADI', li_tipopedd, 0);

 end if;

 commit;

end;
/
 	