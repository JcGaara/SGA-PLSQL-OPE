declare
v_tipopedd varchar2(50);
v_tipopedd4 varchar2(50);
v_tipopedd5 varchar2(50);
v_tipopedd6 varchar2(50);
v_tipopedd7 varchar2(50);
begin
  -- Buscando Tipopedd para Eliminacion
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PARAM_ROTA_M';
  select t.tipopedd into v_tipopedd4 from operacion.tipopedd t where t.abrev='PARAM_ROTA_DEM';
  select t.tipopedd into v_tipopedd5 from operacion.tipopedd t where t.abrev='PARAM_ROTA_SOL';
  select t.tipopedd into v_tipopedd6 from operacion.tipopedd t where t.abrev='PARAM_ROTA_TARJ';
  select t.tipopedd into v_tipopedd7 from operacion.tipopedd t where t.abrev='PARAM_ROTA_TIPS';
  -- Eliminando Parametros

  delete from operacion.opedd where tipopedd=v_tipopedd;
  delete from operacion.opedd where tipopedd=v_tipopedd4;
  delete from operacion.opedd where tipopedd=v_tipopedd5;
  delete from operacion.opedd where tipopedd=v_tipopedd6;
  delete from operacion.opedd where tipopedd=v_tipopedd7;

  -- Eliminando Cabeceras
  delete from operacion.tipopedd where tipopedd=v_tipopedd;
  delete from operacion.tipopedd where tipopedd=v_tipopedd4;
  delete from operacion.tipopedd where tipopedd=v_tipopedd5;
  delete from operacion.tipopedd where tipopedd=v_tipopedd6;
  delete from operacion.tipopedd where tipopedd=v_tipopedd7;

  Commit;
end;
/