drop package body OPERACION.PKG_VALIDA_INCOGNITO_IMS;
drop package OPERACION.PKG_VALIDA_INCOGNITO_IMS;

drop table OPERACION.T_DATA_INCOGNITO;
drop table OPERACION.T_DATA_IMS;

delete OPERACION.OPEDD where tipopedd = 1 and descripcion = 'ID_SERVICIO_INCOGNITO';

commit

/

