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

  if ln_count_val = 1 then
    delete from operacion.opedd
     where codigoc = 'CONAX_SRV'
       and codigon = (select tareadef
                        from opewf.tareadef
                       where descripcion = 'Validacion Activacion/Desactivacion Adicionales')
       and descripcion = 'Validacion TRX SRV ADIC'
       and abreviacion = 'POST'
       and tipopedd = (select tipopedd 
                         from operacion.tipopedd 
                        where abrev = 'CONF_TAREAS_LTE');
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
  if ln_count_val = 1 then
    update operacion.opedd
       set descripcion = 'Reconexion Postpago LTE'
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

  if ln_count_val = 1 then
    update operacion.opedd
       set descripcion = 'Suspension Postpago LTE'
     where codigoc = '9'
       and tipopedd = (select tipopedd
                         from operacion.tipopedd
                        where abrev = 'TIPO_SLTD_ENV_CONAX');
  end if;
  commit;
end;
/