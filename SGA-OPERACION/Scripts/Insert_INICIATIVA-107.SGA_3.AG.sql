declare
  ln_max_tipopedd   number;
  ln_max_opedd      number;
begin
	select max(TIPOPEDD) + 1 into ln_max_tipopedd  from operacion.tipopedd ;

	insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
	values (ln_max_tipopedd, 'Documentos para provisión', 'ALTA_PROV');
	commit;

	select max(IDOPEDD) + 1 into ln_max_opedd  from operacion.opedd;

	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd, 'HFC', 10, 'HFC_INTERNET', 'INTERNET', ln_max_tipopedd, 0);
	commit;
	
	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd+1, 'HFC', 11, 'HFC_TELEFONIA', 'TELEFONIA', ln_max_tipopedd, 0);
	commit;
	
	insert into operacion.opedd(IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
	values ( ln_max_opedd+2, 'HFC', 12, 'HFC_CABLE', 'CABLE', ln_max_tipopedd, 0);
	commit;
end;
/