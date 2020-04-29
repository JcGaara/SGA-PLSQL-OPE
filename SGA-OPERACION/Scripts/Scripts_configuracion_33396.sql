declare

  v_tipopedd operacion.tipopedd.tipopedd%type;

begin
  insert into operacion.tipopedd
    (DESCRIPCION, ABREV)
  values
    ('Migracion Plano', 'migracion_plano')
  returning tipopedd into v_tipopedd;

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1218, 'SIAC CAMBIO DE PLAN V2', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1049, 'CATV Instalaciones Analogicas', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1129, 'HFC-TRASLADO EXTERNO', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1052, 'CATV Traslado Interno v2', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1073, 'INSTALACION CE EN HFC v2', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1024, 'INSTALACION HFC', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1200, 'HFC - PUNTOS ADICIONALES', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1195, 'HFC - DECOADICIONAL', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1212,
     'INSTALACION HFC SISACT copia pruebas',
     'wf_migracion_plano',
     v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1095,
     'INSTALACION CE EN HFC SERV MENOR',
     'wf_migracion_plano',
     v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1223, 'HFC - CAMBIO DE PLAN CE', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1197, 'HFC - CAMBIO DE PLAN SISACT', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1195,
     'HFC - PORTABILIDAD INSTALACIONES',
     'wf_migracion_plano',
     v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1054, 'MANTENIMIENTO HFC v2', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (1069, 'HFC Retencion v2', 'wf_migracion_plano', v_tipopedd);

  insert into operacion.opedd
    (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
  values
    (885, 'Mantenimiento HFC', 'wf_migracion_plano', v_tipopedd);

  update opewf.tareadef t
     set t.pos_proc = 'intraway.PKG_PLANOSHFC_SGA.SGASU_UPDATE_SUCURSAL'
   where t.tareadef in (1023, 756);

  commit;

end;
/
