declare
  l_tipopedd tipopedd.tipopedd%type;
begin

  insert into tipopedd
    (descripcion, abrev)
  values
    ('tipos de traslados', 'tipo_traslados')
  returning tipopedd into l_tipopedd;

  --Tipos de Traslados
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 412, 'HFC - Traslado Externo', 'tipo_traslado', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 418, 'HFC - Traslado Interno', 'tipo_traslado', l_tipopedd);

  commit;
end;
/
