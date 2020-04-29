-- Rollback_operacion_INC000000892040
---------------------------------------------------------

-- Eliminamos parametros 
  
delete from operacion.opedd    where TIPOPEDD = 
            (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1');
			
delete from operacion.opedd    where TIPOPEDD = 
            (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2');
            			
delete from operacion.opedd    where TIPOPEDD = 
            (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS');
		
delete operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1';
delete operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2';
delete operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS';
		
commit;

delete from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'RECHAZADAS_1_WHERE';
delete from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'RECHAZADAS_2_WHERE';
delete from operacion.OPE_CONFIG_ACCION_JANUS where TIP_SVR = 'APROBADAS_WHERE';

commit;

-- Drop Package
DROP PACKAGE OPERACION.PKG_SGA_WA;


