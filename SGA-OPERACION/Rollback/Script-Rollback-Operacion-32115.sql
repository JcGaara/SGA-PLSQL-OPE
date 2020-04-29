-- Eliminar detalle de parametros
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_DESCSERVICIO');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_TIPSER_CE');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_DIFERENCIAL');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_ESTADO');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONSOLIDA_MAIL');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
   where upper(abrev) = 'CONSOLIDA_GENHISEST');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
   where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
  where upper(abrev) = 'CONSOLIDA_TIPOSDIFERENCIAL');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
  where upper(abrev) = 'CONSOLIDA_ACCESO');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
  where upper(abrev) = 'CONSOLIDA_PTACENTRAL');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
  where upper(abrev) = 'CONSOLIDA_CAMPOSFIJOS');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONS_MODIF_CONS_VENT_CLARO');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONS_N_CANALES_TRAB_UPGRADE');
delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd
    where upper(abrev) = 'CONVEN_TIPVTA_F2_RF2');
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd 
    WHERE upper(abrev) = 'CONSOLIDA_SERVICIO_CLOUD');
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE upper(abrev) = 'CONSOLIDADO_VTA_PRDCTO');
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE upper(abrev) = 'CONSOLIDADO_VERDW');
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE abrev = 'SEGMENTODIFERENCIAL');    
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE abrev = 'METRICASUGIS');  
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE abrev = 'PROYECTOSINTERNET');  
DELETE FROM operacion.opedd WHERE tipopedd = 
  (SELECT tipopedd FROM operacion.tipopedd  
    WHERE abrev = 'PROYECTOSRPV');      

update operacion.opedd
set abreviacion = null, codigon_aux = null, DESCRIPCION = 'Id de Producto'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '503'
  and ABREVIACION = '0058';
  
update operacion.opedd
set abreviacion = null, codigon_aux = null, DESCRIPCION = 'Id de Producto'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '758';

update operacion.opedd
set abreviacion = null, codigon_aux = null, DESCRIPCION = 'Id de Producto'
where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
  and codigoc = '852';

delete operacion.opedd 
 where tipopedd = (Select TIPOPEDD from TIPOPEDD where upper(abrev) = 'CONVEN_LINANALOGICA')
   and codigoc = '503'
   and ABREVIACION = '0004';
   
update operacion.opedd 
set abreviacion = null, descripcion = 'Id del Producto'
where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd where abrev = 'CONVEN_CANAL')
and codigoc = '504';

delete from operacion.opedd where tipopedd = 
  (select operacion.tipopedd.tipopedd from operacion.tipopedd where abrev = 'CONVEN_CANAL')
and codigoc = '905';
  
-- Eliminar cabecera de parametros
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_GENHISEST';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_DESCSERVICIO';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_TRA';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_DIFERENCIAL_GER';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_TIPSER_CE';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_DIFERENCIAL';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_TIPOS_TRAB_FIJOS';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_TIPSER_FIBRA';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_ESTADO';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_MAIL';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_EQUIVALENCIAS';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONSOLIDA_TIPOSDIFERENCIAL';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONS_MODIF_CONS_VENT_CLARO';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONS_N_CANALES_TRAB_UPGRADE';
delete from operacion.tipopedd 
  where upper(abrev) = 'CONVEN_TIPVTA_F2_RF2';
delete from operacion.tipopedd 
 where upper(abrev) = 'CONSOLIDA_ACCESO';
delete from operacion.tipopedd 
 where upper(abrev) = 'CONSOLIDA_PTACENTRAL';  
delete from operacion.tipopedd 
 where upper(abrev) = 'CONSOLIDA_CAMPOSFIJOS'; 
DELETE FROM operacion.tipopedd 
 WHERE upper(abrev) = 'CONSOLIDA_SERVICIO_CLOUD';
DELETE FROM operacion.tipopedd 
 WHERE upper(abrev) = 'CONSOLIDADO_VTA_PRDCTO';
DELETE FROM operacion.tipopedd 
 WHERE upper(abrev) = 'CONSOLIDADO_VERDW';
DELETE FROM operacion.tipopedd 
 WHERE abrev = 'SEGMENTODIFERENCIAL';
DELETE FROM operacion.tipopedd
WHERE abrev = 'METRICASUGIS';
DELETE FROM operacion.tipopedd
WHERE abrev = 'PROYECTOSINTERNET';
DELETE FROM operacion.tipopedd
WHERE abrev = 'PROYECTOSRPV';
       
commit;