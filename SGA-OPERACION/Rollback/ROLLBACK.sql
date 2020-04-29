--- ROLLBACK

delete from operacion.tipopedd tp
 where tp.descripcion = 'Conversion de MB a KB'
   and tp.abrev = 'CON_MB_KB';

delete from operacion.opedd op
 where op.descripcion = 'Valor de equivalencia en Kb'
   and op.abreviacion = 'Valor Kb'
   and op.codigon_aux = 0;

 
--Configuración
DELETE FROM operacion.parametro_det_adc WHERE ID_DETALLE = '288';

ALTER TABLE OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
drop column prorv_correo;

ALTER TABLE OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
drop column prorv_tpo_altas;

ALTER TABLE OPERACION.SGAT_POSTV_PROYECTO_ORIGEN
drop column PRORV_COD_MOTIVO;

DELETE FROM operacion.opedd O
 WHERE O.TIPOPEDD =
	   (select tipopedd
		  from operacion.tipopedd
		 where descripcion = 'IW Proceso automatico WS')
   AND O.ABREVIACION = 'HFC_CP';
   
DROP PACKAGE OPERACION.PKG_ACTIVACION_SERVICIOS;

alter table SALES.SISACT_POSTVENTA_DET_SERV_LTE modify flag_accion VARCHAR2(1);

   COMMIT
/
