
declare
 ln_var number;
begin 
  Insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
   Values ('Parametros Traslados Externos', 'TRASLADO_EXTERNO');
  COMMIT;

  select TIPOPEDD into ln_var from OPERACION.TIPOPEDD 
   where ABREV = 'TRASLADO_EXTERNO';

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (80, 'Traslados Externos', ln_var);
 
  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (412, 'Traslados Externos de Servicios Masivos', ln_var);

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (390, 'TRASLADO EXTERNO PAQUETES', ln_var);

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (393, 'TRASLADO EXTERNO PAQUETES TPI', ln_var);

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (420, 'Cambio Plan + Traslado Externo - Paquetes', ln_var);

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (341, 'TRASLADO EXTERNO WIRELESS', ln_var);

  Insert into OPERACION.OPEDD (CODIGON, DESCRIPCION, TIPOPEDD)
   Values (346, 'TRASLADO EXTERNO CON REFLEJO', ln_var);

 
  COMMIT;

end;
/  
