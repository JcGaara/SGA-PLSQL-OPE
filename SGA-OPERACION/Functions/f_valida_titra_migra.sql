create or replace function operacion.f_valida_titra_migra(an_titra in number)
  return number is
  Result number;
begin

  select count(*)
    into Result
    FROM tipopedd c, opedd d
   WHERE c.tipopedd = d.tipopedd
     and c.abrev = 'TIPTRABAJO'
     AND d.abreviacion = 'MIGRA'
     and d.codigon = an_titra;

  return(Result);
end f_valida_titra_migra;
/
