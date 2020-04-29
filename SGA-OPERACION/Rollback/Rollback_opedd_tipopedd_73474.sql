declare
 ln_var number;
begin 

  select TIPOPEDD into ln_var from OPERACION.TIPOPEDD
   where ABREV = 'TRASLADO_EXTERNO';

  delete from OPERACION.OPEDD 
  where TIPOPEDD = ln_var; 

  delete from OPERACION.TIPOPEDD 
  where TIPOPEDD = ln_var;

  COMMIT;

end;
/
