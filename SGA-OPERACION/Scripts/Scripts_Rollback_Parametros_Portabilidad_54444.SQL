declare
v_tipopedd varchar2(50);
begin
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PARAM_PORTA';
  
  delete from operacion.opedd where tipopedd=v_tipopedd;
  delete from operacion.tipopedd where tipopedd=v_tipopedd;
  Commit;
end;
/