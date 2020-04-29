        
declare
  ln_max_tipopedd   number;
  ln_max_opedd      number;
begin
	select max(TIPOPEDD) + 1 into ln_max_tipopedd  from operacion.tipopedd ;

	insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
	values (ln_max_tipopedd, 'Tip. Escenario Prov. Ingonito', 'TIPESCPARCTOTAL');
	commit;

	select max(IDOPEDD) + 1 into ln_max_opedd  from operacion.opedd;

	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd, null, 2, 'Tipo de Escenario Prov Incognito: CustomerID(1) o ServicesID(2) -Total (0) o Parcial(1)', 'TIPESCPARCTOTAL', ln_max_tipopedd, 1);
	commit;
end;
/