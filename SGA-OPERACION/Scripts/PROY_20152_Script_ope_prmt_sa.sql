declare
  ln_count_val number;
begin
  -- Agregando comentario en tabla
  -- validando la insercion del parametro del shell de cierre de sot
  select count(1)
    into ln_count_val
    from operacion.opedd
   where codigoc = 'CONAX_SRV'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'CONF_TAREAS_LTE');

  if ln_count_val = 0 then
    insert into operacion.opedd
      (codigoc, codigon, descripcion, abreviacion, tipopedd)
    values
      ('CONAX_SRV',
       (select tareadef
          from opewf.tareadef
         where descripcion =
               'Validacion Activacion/Desactivacion Adicionales'),
       'Validacion TRX SRV ADIC',
       'POST',
       (select tipopedd from operacion.tipopedd where abrev = 'CONF_TAREAS_LTE'));
  end if;
  commit;
  
  -- validando la insercion del parametro de tipo de solicitud 8
  select count(1)
    into ln_count_val
    from operacion.opedd
   where codigoc = '8'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_SLTD_ENV_CONAX');
  if ln_count_val = 0 then
    insert into operacion.opedd
      (codigoc, descripcion, tipopedd)
    values
      ('8',
       'Alta Canal Adicional',
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'TIPO_SLTD_ENV_CONAX'));
  else
    update operacion.opedd
       set descripcion = 'Alta Canal Adicional'
     where codigoc = '8'
       and tipopedd = (select tipopedd
                         from operacion.tipopedd
                        where abrev = 'TIPO_SLTD_ENV_CONAX');
  end if;
  -- validando la insercion del parametro de tipo de solicitud 9
  select count(1)
    into ln_count_val
    from operacion.opedd
   where codigoc = '9'
     and tipopedd = (select tipopedd
                       from operacion.tipopedd
                      where abrev = 'TIPO_SLTD_ENV_CONAX');

  if ln_count_val = 0 then
    insert into operacion.opedd
      (codigoc, descripcion, tipopedd)
    values
      ('9',
       'Baja Canal Adicional',
       (select tipopedd
          from operacion.tipopedd
         where abrev = 'TIPO_SLTD_ENV_CONAX'));
  else
    update operacion.opedd
       set descripcion = 'Baja Canal Adicional'
     where codigoc = '9'
       and tipopedd = (select tipopedd
                         from operacion.tipopedd
                        where abrev = 'TIPO_SLTD_ENV_CONAX');
  end if;
  commit;
end;
/