declare
li_tipopedd number;
begin

  begin
    select tipopedd into li_tipopedd from operacion.tipopedd
    where descripcion = 'TIPO DE EQUIPO A INSTALAR' and abrev = 'TYPEQUIPINSTALL';
  exception
   when no_data_found then
     li_tipopedd := 0;
   when others then
     li_tipopedd := 0;
  end;

 if li_tipopedd > 0 then

    delete from operacion.tipopedd where tipopedd = li_tipopedd;
    delete from operacion.opedd where tipopedd = li_tipopedd;
    
 end if; 

 commit;

end;
/