/*Rollback WF WIMAX*/

declare
ln_tipopedd number;

begin

  select TIPOPEDD into ln_tipopedd  from operacion.TIPOPEDD t   where trim(t.descripcion) = 'OP-Asig Flujo Automaticos';

  delete operacion.OPEDD o
  where o.tipopedd = ln_tipopedd and o.descripcion = 'INSTALACION WIMAX';
  commit;
  
end;

/*Procedure*/
drop procedure operacion.p_ejecuta_cambio_est_solot;
/