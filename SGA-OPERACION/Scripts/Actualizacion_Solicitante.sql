declare
  cursor solicitante is
    select t.codigoc
      from opedd t
     where t.tipopedd =
           (select t.tipopedd
              from tipopedd t
             where trim(t.abrev) = 'SINERGIA_SOLICITANTE')
       and t.codigoc in ('PREDESGT020U',
                         'PREDESGT018U',
                         'PREDESGT005U',
                         'PREDESGT004U',
                         'PREDESGT003U',
                         'PREDESGT010U',
                         'PREDESGT011U',
                         'PREDESGT009U',
                         'PREDESGT007U',
                         'PREDESGT008U',
                         'PREDESST016U',
                         'PREDESDT001U');

  l_codigoc operacion.opedd.codigoc%type;

begin
  for c_solicitante in solicitante loop
    l_codigoc := c_solicitante.codigoc;
  
    update operacion.opedd t
       set t.codigon_aux = 1
     where t.tipopedd =
           (select t.tipopedd
              from tipopedd t
             where trim(t.abrev) = 'SINERGIA_SOLICITANTE')
       and t.codigoc = l_codigoc;
  
  end loop;

  update operacion.opedd t
     set t.codigon = 2
   where t.tipopedd =
         (select t.tipopedd
            from tipopedd t
           where trim(t.abrev) = 'SINERGIA_IMPUTACION')
     and t.codigoc = 'K'
     and trim(t.descripcion) = 'SUMINISTRO';

  delete from operacion.opedd t
   where t.tipopedd =
         (select t.tipopedd
            from tipopedd t
           where trim(t.abrev) = 'SINERGIA_IMPUTACION')
     and t.codigoc = 'F'
     and t.codigon is null
     and trim(t.descripcion) = 'CENTRO DE COSTO';

  delete from operacion.opedd t
   where t.tipopedd =
         (select t.tipopedd
            from tipopedd t
           where trim(t.abrev) = 'SINERGIA_IMPUTACION')
     and t.codigoc = 'P'
     and t.codigon is null
     and trim(t.descripcion) = 'PROYECTO-SERVICIO';

  delete from operacion.opedd t
   where t.tipopedd =
         (select t.tipopedd
            from tipopedd t
           where trim(t.abrev) = 'SINERGIA_IMPUTACION')
     and t.codigoc = 'A'
     and t.codigon is null
     and trim(t.descripcion) = 'ACTIVO FIJO';

  delete from operacion.opedd t
   where t.tipopedd =
         (select t.tipopedd
            from tipopedd t
           where trim(t.abrev) = 'SINERGIA_IMPUTACION')
     and trim(t.codigoc) is null
     and t.codigon is null
     and trim(t.descripcion) = 'ALMACEN';

  commit;

end;
/
