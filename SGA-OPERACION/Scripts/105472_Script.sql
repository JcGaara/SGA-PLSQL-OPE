update operacion.ope_parametros_globales_aux set valorparametro=-100000 
where nombre_parametro = 'cortesyreconexiones.montoreconexionTPI';

commit;

drop procedure OPERACION.P_GENERA_REP_ACTIVOS_FULL;
drop procedure OPERACION.P_GENERA_REP_ACTIVOS;
