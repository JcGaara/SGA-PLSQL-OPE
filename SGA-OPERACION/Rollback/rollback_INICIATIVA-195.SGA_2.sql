-- Eliminar Indices
DROP INDEX OPERACION.IDX_RESTV_NRO_ORDEN;
DROP INDEX OPERACION.IDX_RESTN_ID_ETA;
DROP INDEX OPERACION.IDX_RESTN_NRO_SOLOT;
DROP INDEX OPERACION.IDX_RESTN_ID_CONSULTA;
DROP INDEX OPERACION.IDX_RESTN_ESTADO;
DROP INDEX OPERACION.IDX_RESTD_FECHA_GENERADA;
DROP INDEX OPERACION.IDX_RESTN_NUM_SEC;
--
UPDATE OPERACION.SGAT_RESERVA_TOA SET  RESTN_ID_ETA=NULL WHERE RESTN_ID_ETA=0;
ALTER TABLE OPERACION.SGAT_RESERVA_TOA DROP COLUMN RESTN_NUM_SEC;
ALTER TABLE OPERACION.SGAT_RESERVA_TOA modify RESTN_ID_ETA NUMBER(20) null;
ALTER TABLE OPERACION.SGAT_RESERVA_TOA modify RESTV_NRO_ORDEN VARCHAR2(30) null;

COMMENT ON COLUMN OPERACION.SGAT_RESERVA_TOA.RESTN_ESTADO IS 'Estado de la reserva';
REVOKE EXECUTE ON OPERACION.PKG_RESERVA_TOA FROM USRSISACT;
commit;
\