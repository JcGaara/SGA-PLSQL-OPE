-- Rollback_operacion_cosnt_INC000000892040
---------------------------------------------------------
-- Eliminamos constante 
---------------------------------------------------------
delete from constante where constante = 'SGA_WA_RECHAZAD';

 commit;
 
 