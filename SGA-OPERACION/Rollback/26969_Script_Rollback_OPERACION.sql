/*****************************************************************
Propósito          : Script para realizar la limpieza de la base de datos 
Creado por         : QSoftGroup 
Fec. Creación      : 07/04/2017
Fec. Actualización : -
*****************************************************************/

DROP PACKAGE BODY OPERACION.PKG_IP6;
DROP PACKAGE OPERACION.PKG_IP6;

DROP SEQUENCE OPERACION.SQ_SGAT_IPXCLASEC6;

DELETE OPERACION.OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'IP6');
DELETE OPERACION.TIPOPEDD WHERE ABREV = 'IP6';

COMMIT;
