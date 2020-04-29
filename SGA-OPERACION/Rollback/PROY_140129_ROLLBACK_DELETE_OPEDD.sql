-- Eliminar detalle de parametros
DELETE from opedd where tipopedd = 
  (select tipopedd 
     from tipopedd
    where abrev = 'LIST_CONSULDIST');

COMMIT;
