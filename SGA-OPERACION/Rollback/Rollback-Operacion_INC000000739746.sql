-- Rollback
declare
  ln_tiptra   number;
  ln_tipopedd number;
begin

  select t.tiptra
    into ln_tiptra
    from tiptrabajo t
   where t.descripcion = 'WLL/LTE MIGRACION WIMAX - LTE';

  delete from tiptrabajo t where t.tiptra = ln_tiptra;

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

  if ln_tipopedd != 0 then
    delete from opedd o
     where o.tipopedd = ln_tipopedd
       and o.codigoc = 'LTE_WIMAX_FACT_SGA';
  
    delete from opedd o
     where o.tipopedd = ln_tipopedd
       and o.codigoc = 'LTE_WIMAX_TIPTRA_NEW';
  end if;
  
  commit;
end;
/
