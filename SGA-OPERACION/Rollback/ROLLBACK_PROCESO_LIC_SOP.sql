--Delete Sequence
DROP SEQUENCE OPERACION.SGASEQ_SGAT_CID_SERV_LICENCIA;
DROP SEQUENCE OPERACION.SGASEQ_SGAT_PROCESO_LIC_DET;
DROP SEQUENCE OPERACION.SGASEQ_SGAT_PROCESO_LIC_SOP;

--Delete Tables
DROP TABLE OPERACION.SGAT_PROCESO_LIC_SOP;
DROP TABLE OPERACION.SGAT_PROCESO_LIC_DET;
DROP TABLE OPERACION.SGAT_CID_SERV_LICENCIA;
DROP TABLE OPERACION.SGAT_PROCESO_LIC_CAB;

-- Delete rows
--Tipo: Licencias / Soporte

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'TIPO_LICENCIA_SOPORTE');
DELETE FROM operacion.tipopedd WHERE ABREV = 'TIPO_LICENCIA_SOPORTE';

--Ubicación del equipo

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'UBICACION_EQUIPO');
DELETE FROM operacion.tipopedd WHERE ABREV = 'UBICACION_EQUIPO';

--Estado de Licencia y Soporte
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'ESTADO_LICENCIA');
DELETE FROM operacion.tipopedd WHERE ABREV = 'ESTADO_LICENCIA';

--Configuración de Fechas
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'LICITACION_FECH_FIN');
DELETE FROM operacion.tipopedd WHERE ABREV = 'LICITACION_FECH_FIN';

--Proveedores
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'PROVEEDORES_LICENCIA_CID');
DELETE FROM operacion.tipopedd WHERE ABREV = 'PROVEEDORES_LICENCIA_CID';

--Servicios
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT tipopedd FROM operacion.tipopedd WHERE ABREV = 'TIPO_SERV_EQP_LIC_SOP');
DELETE FROM operacion.tipopedd WHERE ABREV = 'TIPO_SERV_EQP_LIC_SOP';

COMMIT;

/
