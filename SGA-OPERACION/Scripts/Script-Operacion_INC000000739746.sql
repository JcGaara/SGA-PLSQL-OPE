declare
  ln_tiptra   number;
  ln_tipopedd number;
begin

  select max(tiptra) + 1 into ln_tiptra from tiptrabajo;

  begin
    select distinct o.tipopedd
      into ln_tipopedd
      from tipopedd t, opedd o
     where t.tipopedd = o.tipopedd
       and t.abrev = 'NUM_LTE_REG_BSCS';
  exception
    when others then
      ln_tipopedd := 0;
  end;

  insert into tiptrabajo
    (tiptra, tiptrs, descripcion)
  values
    (ln_tiptra, 1, 'WLL/LTE MIGRACION WIMAX - LTE');

  if ln_tipopedd != 0 then
    insert into opedd
      (codigon, tipopedd, abreviacion, codigoc)
    values
      (1, ln_tipopedd, 'LTE_WIMAX_FACT_SGA', 'LTE_WIMAX_FACT_SGA');
  
    insert into opedd
      (codigon, tipopedd, abreviacion, codigoc)
    values
      (ln_tiptra,
       ln_tipopedd,
       'LTE_WIMAX_TIPTRA_NEW',
       'LTE_WIMAX_TIPTRA_NEW');
  end if;
  commit;
end;
/
