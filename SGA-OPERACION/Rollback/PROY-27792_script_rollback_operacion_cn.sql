-- MOTIVO
DELETE FROM operacion.mototxtiptra WHERE tiptra IN (SELECT tiptra FROM OPERACION.tiptrabajo WHERE descripcion IN('WLL/SIAC – CAMBIO DE NUMERO','HFC/SIAC – CAMBIO DE NUMERO'));

DELETE FROM OPERACION.motot WHERE descripcion = 'WLL – A solicitud del cliente';


-- Tipo de Trabajo
DELETE OPERACION.tiptrabajo WHERE Descripcion IN ('WLL/SIAC – CAMBIO DE NUMERO','HFC/SIAC – CAMBIO DE NUMERO');

-- Configuracion
delete from OPERACION.opedd where tipopedd = (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev) ='CAMBIO_NUMERO_SIAC_UNICO');
delete from OPERACION.tipopedd where upper(abrev) = 'CAMBIO_NUMERO_SIAC_UNICO';

delete from OPERACION.opedd where tipopedd = (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev) ='LOCUCION_SIAC_CAMBIONUMERO');
delete from OPERACION.tipopedd where upper(abrev) = 'LOCUCION_SIAC_CAMBIONUMERO';
-- Configuracion de los tipos de trabajo
delete from OPERACION.opedd
 where tipopedd = (select MAX(tipopedd)
                     from OPERACION.tipopedd
                    where upper(abrev) = 'TIPO_TRANS_SIAC')
   AND ABREVIACION = 'HFC_SIAC_CAMBIO_NUMERO';

delete from OPERACION.opedd
 where tipopedd = (select MAX(tipopedd)
                     from OPERACION.tipopedd
                    where upper(abrev) = 'TIPO_TRANS_SIAC')
   AND ABREVIACION = 'WLL_SIAC_CAMBIO_NUMERO';  
   
-- Configuracion de la WF 
delete from OPERACION.opedd
 where tipopedd = (select MAX(tipopedd)
                     from OPERACION.tipopedd
                    where upper(abrev) = 'ASIGNARWFBSCS')
   AND ABREVIACION = 'WLL_SIAC_CAMBIO_NUMERO'; 
   
delete from OPERACION.opedd
 where tipopedd = (select MAX(tipopedd)
                     from OPERACION.tipopedd
                    where upper(abrev) = 'ASIGNARWFBSCS')
   AND ABREVIACION = 'HFC_SIAC_CAMBIO_NUMERO'; 
--CONFIGURACION DE LOS MOTIVOS
delete from OPERACION.opedd where tipopedd = (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev) ='MOTIVO_CAMBIO_NUMERO');
delete from OPERACION.tipopedd where upper(abrev) = 'MOTIVO_CAMBIO_NUMERO';


DROP TABLE OPERACION.SGA_TRAZABILIDAD_LOG;

--eliminar el package y package body 
drop package OPERACION.PKG_SIAC_CAMBIO_NUMERO;
drop package OPERACION.PKG_SIAC_POSTVENTA;

commit;
/