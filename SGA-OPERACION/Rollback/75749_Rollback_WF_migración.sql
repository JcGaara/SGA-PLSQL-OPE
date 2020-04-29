declare
  l_wfdef    opewf.wfdef.wfdef%type;

begin
  begin
    select t.wfdef
      into l_wfdef
      from opewf.wfdef t
     where descripcion = 'INSTALACION 3 PLAY INALAMBRICO - MIGRACION';
  exception
    when no_data_found then
      l_wfdef := 0;
  end;

  delete from opewf.tareawfdef t where t.wfdef = l_wfdef;

  delete from opewf.wfdef t where t.wfdef = l_wfdef;

  delete from operacion.tiptrabajo t
   where t.descripcion = 'INSTALACION 3 PLAY INALAMBRICO - MIGRACION';

  delete from operacion.opedd t
   where t.tipopedd =
         (select t.tipopedd from operacion.tipopedd t where t.abrev = 'dth_migracion');

  delete from operacion.opedd t
   where t.descripcion = 'INSTALACION 3 PLAY INALAMBRICO - MIGRACION'
     and t.tipopedd = 260;

  delete from operacion.tipopedd t where t.abrev = 'dth_migracion';

  commit;
end;
/
