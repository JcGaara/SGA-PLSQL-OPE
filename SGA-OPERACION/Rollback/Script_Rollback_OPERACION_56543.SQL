
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='anhos_tabla');
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='conexiones');
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev ='envio_dth_parametros');
commit;

delete from tipopedd where abrev ='anhos_tabla';
delete from tipopedd where abrev ='conexiones';
delete from tipopedd where abrev ='envio_dth_parametros';
COMMIT;

DELETE FROM OPERACION.TIP_MENSAJE;
DELETE FROM OPERACION.TAB_ARCH_TMP;
DELETE FROM OPERACION.TAB_ARCH_MSG_DTH;
DELETE FROM OPERACION.MENSAJE_DTH_DET;
DELETE FROM OPERACION.MENSAJE_DTH_CAB;
COMMIT;

DROP TABLE OPERACION.TIP_MENSAJE;
DROP TABLE OPERACION.TAB_ARCH_TMP;
DROP TABLE OPERACION.TAB_ARCH_MSG_DTH;
DROP TABLE OPERACION.MENSAJE_DTH_DET;
DROP TABLE OPERACION.MENSAJE_DTH_CAB;
COMMIT;

--eliminar sequence

DROP SEQUENCE OPERACION.SQ_SEQ_ENVIO;
DROP SEQUENCE OPERACION.SQ_IDCODIGO; 

---Eliminar Type
DROP TYPE OPERACION.CLIENTE_DTH_TBL;
DROP TYPE OPERACION.TARJETA_CLIENTE_DTH_TBL;
DROP TYPE OPERACION.TY_IENVDTH_TBL;
DROP TYPE OPERACION.CLIENTE_DTH;
DROP TYPE OPERACION.TARJETA_CLIENTE_DTH;
DROP TYPE OPERACION.TY_ENVDTH;
COMMIT;

DROP PACKAGE OPERACION.PQ_DTH_MSG_CONAX; 
COMMIT;