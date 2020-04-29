declare
  v_count     number;
  v_countn    number;
  v_tipopedd  operacion.tipopedd.tipopedd%type;
  v_estnumtel telefonia.estnumtel.estnumtel%type;
begin
  select count(1)
    into v_count
    from operacion.tipopedd
   where abrev = 'IND_ASIGNUMERO';

  select count(1)
    into v_countn
    from telefonia.estnumtel
   where abrev = 'UPL';

  if v_countn = 0 then
    select max(estnumtel)+1 into v_estnumtel from telefonia.estnumtel;
  
    insert into telefonia.estnumtel
      (estnumtel, descripcion, abrev)
    values
      (v_estnumtel, 'Usado en Plataforma', 'UPL');
  end if;

  if v_count = 0 then
    insert into operacion.tipopedd
      (descripcion, abrev)
    values
      ('Configuracion Asginación Nros', 'IND_ASIGNUMERO');
  
    select tipopedd
      into v_tipopedd
      from operacion.tipopedd
     where abrev = 'IND_ASIGNUMERO';
  
    insert into operacion.opedd
      (codigoc, codigon, descripcion, abreviacion, tipopedd)
    values
      (null,
       0,
       'Flag Para Activar Desactivar Validacion en Varias Plataformas',
       'FLG_NROTEL_NPLATAFORMA',
       v_tipopedd);
    insert into operacion.opedd
      (codigoc, codigon, descripcion, abreviacion, tipopedd)
    values
      (null,
       0,
       'Flag Para Activar Desactivar FOR UPDATE',
       'FLG_NROTEL_FORUDP',
       v_tipopedd);
  
    --ingresamos el estnumtel
    select estnumtel into v_estnumtel from estnumtel where abrev = 'UPL';
  
    insert into operacion.opedd
      (codigoc, codigon, descripcion, abreviacion, tipopedd)
    values
      (null,
       v_estnumtel,
       'Estado de la Numtel para Determinar que la validacion No fue Exitosa en las Plataformas',
       'FLG_ESTNUMTEL_NOVALIDO',
       v_tipopedd);
  end if;
COMMIT;
end;
/
