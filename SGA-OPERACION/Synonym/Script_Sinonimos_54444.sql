--------------------------------------------------
--ejecutar desde esquema 'OPERACION'
--------------------------------------------------
--select * from all_objects@DBL_SISACT where object_name = 'SISACT_PKG_PORTABILIDAD_CORP'
CREATE SYNONYM telefonia.SISACT_PKG_PORTABILIDAD_CORP FOR USRPVU.SISACT_PKG_PORTABILIDAD_CORP@DBL_PVUDB;
