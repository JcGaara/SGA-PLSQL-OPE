declare
  ln_max_tipopedd   number;
  ln_max_opedd      number;
begin
  select max(TIPOPEDD)into ln_max_tipopedd  from operacion.tipopedd ;
  select max(IDOPEDD)into ln_max_opedd  from operacion.opedd;

  
  insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values (ln_max_tipopedd+1, 'Tipo de ubicaciones-ZONA', 'TU_TIPO_ZONA');

  insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values (ln_max_tipopedd+2, 'Tipo de ubicaciones-INTERIOR', 'TU_TIPO_INTERIOR');

  insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values (ln_max_tipopedd+3, 'Tipo de ubicaciones-MANZANA', 'TU_TIPO_MANZANA');

  insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
  values (ln_max_tipopedd+4, 'Tipo de ubicaciones-PAISES', 'TU_TIPO_PAISES');
  commit;
  
  
  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+1, '1', 1, 'ETAPA', 'ETP', ln_max_tipopedd+1, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+2, '2', 1, 'SECTOR', 'SEC', ln_max_tipopedd+1, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+3, '3', 1, 'ZONA', 'ZON', ln_max_tipopedd+1, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+4, '1', 1, 'BLOCK', 'BLK', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+5, '2', 1, 'DEPARTAMENTO', 'DPT', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+6, '3', 1, 'INTERIOR', 'INT', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+7, '4', 1, 'NIVEL', 'NIV', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+8, '5', 1, 'OFICINA', 'OFI', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+9, '6', 1, 'PISO', 'PIS', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+10, '7', 1, 'SOTANO', 'SOT', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+11, '8', 1, 'STAND', 'STA', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+12, '9', 1, 'TIENDA', 'TIE', ln_max_tipopedd+2, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+13, '1', 1, 'BLOQUE', 'BK', ln_max_tipopedd+3, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+14, '2', 1, 'EDIFICIO', 'ED', ln_max_tipopedd+3, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+15, '3', 1, 'MANZANA', 'MZ', ln_max_tipopedd+3, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+16, '4', 1, 'PABELLON', 'PA', ln_max_tipopedd+3, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+17, '5', 1, 'TORRE', 'TO', ln_max_tipopedd+3, 0);

  insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values (ln_max_opedd+18, '51', 1, 'PERU', 'PE', ln_max_tipopedd+4, 0);
  commit;
end;
/