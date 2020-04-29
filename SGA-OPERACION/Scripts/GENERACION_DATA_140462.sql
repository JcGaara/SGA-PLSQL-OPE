declare
  v_tipopedd operacion.tipopedd.tipopedd%type;
begin

  --CScripts de creacion de Estados Ajuste Masivo - Cabecera
  insert into operacion.tipopedd
    (descripcion, abrev)
  values
    ('Estados Ajuste Masivo-Cabecera', 'ajuste_masivo_cab')
  returning tipopedd into v_tipopedd;
  
  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('0', 'Inicio de registro', 'registrado', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('1', 'Fin de registro', 'procesado', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('2', 'Inicio validación Lote', 'validacion_lote', v_tipopedd);

  --Scripts de creacion de Estados Ajuste Masivo - Detalle
  insert into operacion.tipopedd
    (descripcion, abrev)
  values
    ('Estados Ajuste Masivo-Detalle', 'ajuste_masivo_det')
  returning tipopedd into v_tipopedd;
  
  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('0', 'Registrado', 'registrado', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('1', 'Validado en SGA', 'validado_sga', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('2', 'Validado en OAC', 'validado_oac', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('-2', 'Error de validacion en OAC', 'error_validado_oac', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('3', 'Procesado en SGA', 'ajuste_sga', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('-3', 'Error de Ajuste en SGA', 'error_ajuste_sga', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('4', 'Procesado en OAC', 'ajuste_oac', v_tipopedd);

  insert into operacion.opedd
    (codigoc, descripcion, abreviacion, tipopedd)
  values
    ('-4', 'Error de Ajuste en OAC', 'error_ajuste_oac', v_tipopedd);

  commit;
end;
/
