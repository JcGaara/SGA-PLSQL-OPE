declare
  l_tipopedd tipopedd.tipopedd%type;
begin

  select t.tipopedd
    into l_tipopedd
    from tipopedd t
   where t.abrev = 'tpe';
  
   insert into opedd(codigon, descripcion, abreviacion, tipopedd)
   values((select t.idcampanha
                  from campanha t
                 where t.descripcion = 'TPE-HFC'),
                'TPE-HFC',
                'campanha_tpe',
                l_tipopedd);

  insert into opedd
    (codigon, descripcion, abreviacion, tipopedd)
  values
    (1, 'Habilita cambios tpe', 'esta_habilitado', l_tipopedd);

  commit;
end;
/
