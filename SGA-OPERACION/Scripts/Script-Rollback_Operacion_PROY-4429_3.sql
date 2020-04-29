--Eliminar Packages
drop package operacion.pq_siac_postventa;
drop package operacion.pq_siac_cambio_plan;
drop package operacion.pq_siac_traslado_externo;

-- Eliminar sequence 
drop sequence operacion.sq_config;
drop sequence operacion.sq_siac_instancia;
drop sequence operacion.sq_siac_negocio_regla;
drop sequence operacion.sq_siac_postventa_proceso;

--Eliminar tablas

drop table  operacion.config_det;
drop table  operacion.config;
drop table  operacion.siac_instancia;
drop table  operacion.siac_negocio;
drop table  operacion.siac_negocio_err;
drop table  operacion.siac_negocio_regla;
drop table  operacion.siac_postventa_proceso;

COMMIT;
