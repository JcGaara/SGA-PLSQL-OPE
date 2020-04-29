-- Eliminamos el campo creado
update OPERACION.SECUENCIA_ESTADOS_AGENDA
   set tipo = null 
 where tipo is not null;

commit;

alter table operacion.SECUENCIA_ESTADOS_AGENDA drop column tipo;
