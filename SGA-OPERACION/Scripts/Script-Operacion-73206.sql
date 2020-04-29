declare
  l_tipopedd tipopedd.tipopedd%type;
begin

  insert into tipopedd
    (descripcion, abrev)
  values
    ('Registro de Reclamo', 'registro_reclamo')
  returning tipopedd into l_tipopedd;

  --Tipo Incidencia
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 1, 'Reclamo-Cliente', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 3, 'Reporte Previo-Averia de red', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 5, 'Reporte Previo-Prepago', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 6, 'Reporte Previo-Prepago Masivo', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 9, 'Reclamo-Multicarrier', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     12,
     'Reporte Previo TP-Telefonia Publica',
     'tipo_incidencia',
     l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 16, 'Reporte Previo-Calidad', 'tipo_incidencia', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 20, 'Reporte-Reporte Equipos', 'tipo_incidencia', l_tipopedd);

  --Estados_Inssrv
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 1, 'Activo', 'estados_inssrv', l_tipopedd);

  --Tipo Incidencia
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null,
     (select codregulartype from atccorp.regular_type where description = 'SARA'),
     'SARA',
     'proceso_incidencia',
     l_tipopedd);

  commit;
end;
/
