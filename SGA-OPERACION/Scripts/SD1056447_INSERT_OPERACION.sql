insert into OPERACION.CONSTANTE
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('IND_OPC_AGENDA',
   'Parametro para deshabilitar opciones de agendamiento en control de tareas segun usuario de contrata',
   'N',
   SUBSTR(USER, 1, 30) ,
   SYSDATE,
   '1',
   null);
commit
/