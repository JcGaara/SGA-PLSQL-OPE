UPDATE OPERACION.SHFCT_DET_TRAS_EXT
SET SHFCV_DIRECCION_FACTURACION = (SUBSTR(SHFCV_DIRECCION_FACTURACION,0,40)),
SHFCV_NOTAS_DIRECCION = (SUBSTR(SHFCV_NOTAS_DIRECCION,0,40))
where length(SHFCV_DIRECCION_FACTURACION) > 40
or length(SHFCV_NOTAS_DIRECCION) > 40;
commit
/