﻿/*Modificado: 14/03/2019*/
/*
MODIFICACION EN SGA PARA LA FALLA  INC000001536547
*/
-- Aumento de longitud en el campo de Dirección Facturación
Alter table OPERACION.SHFCT_DET_TRAS_EXT MODIFY SHFCV_DIRECCION_FACTURACION varchar2(100);
Alter table OPERACION.SHFCT_DET_TRAS_EXT MODIFY SHFCV_NOTAS_DIRECCION varchar2(100)
/