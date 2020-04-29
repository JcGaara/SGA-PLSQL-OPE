-- Eliminar Nuevo Tipo de Trabajo Agregado.
delete
  from operacion.opedd 
 where tipopedd = ( select tp.tipopedd 
                      from operacion.tipopedd tp 
                     where tp.abrev = 'PARAM_PORTA')
   and abreviacion ='TWA'
   and codigon     = 658;