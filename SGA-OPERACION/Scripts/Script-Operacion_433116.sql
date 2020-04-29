declare
  l_tipopedd tipopedd.tipopedd%type;
begin

  insert into tipopedd
    (descripcion, abrev)
  values
    ('Datos de Suspension', 'suspension')
  returning tipopedd into l_tipopedd;

  --Datos Suspension y Reconexion
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 667, 'Codigo Motivo', 'codigoMotivo', l_tipopedd);  

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('09:00', null, 'Franja Horaria', 'franjaHoraria', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 731, 'Tipo de Trabajo', 'tiptra_sp', l_tipopedd);
    
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    (null, 732, 'Tipo de Trabajo', 'tiptra_rx', l_tipopedd);
    
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('2800', null, 'Codigo de Generacion de OCC', 'generacion_occ', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('20150923', null, 'Fecha Vigencia de OCC', 'fecha_vig_occ', l_tipopedd);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd)
  values
    ('1', null, 'Numero de Cuota de OCC', 'num_cuota_occ', l_tipopedd);

  --Constantes
  insert into constante
    (constante, descripcion, tipo, valor)
  values
    ('DATESUSSIACINI',
     'Fecha de inicio de Suspension HFC desde SIAC',
     'C',
     '24/09/2001');

  insert into constante
    (constante, descripcion, tipo, valor)
  values
    ('DATERECSIACINI',
     'Fecha de inicio de Reconexion HFC desde SIAC',
     'C',
     '24/09/2001');

  commit;
end;
/
