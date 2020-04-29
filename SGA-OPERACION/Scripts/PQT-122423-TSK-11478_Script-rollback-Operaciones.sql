--Eliminar Parametros de Asunto y Cuerpo de Correo
delete operacion.ope_parametros_globales_aux where nombre_parametro = 'portal_atc.primerafase.email.asunto';
delete operacion.ope_parametros_globales_aux where nombre_parametro = 'portal_atc.primerafase.email.cuerpo_correo';
delete operacion.ope_parametros_globales_aux where nombre_parametro = 'portal_atc.cambiofase.email.asunto';
delete operacion.ope_parametros_globales_aux where nombre_parametro = 'portal_atc.cambiofase.email.cuerpo_correo';
commit;