--1.- Eliminar configuracion de estados de incidencia
delete operacion.sga_ap_parametro where prmtc_tipo_param = 'WSOAC';
commit;