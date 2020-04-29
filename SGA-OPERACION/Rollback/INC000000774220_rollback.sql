ALTER TABLE operacion.sgat_logaprovlte DROP COLUMN LOGAV_MENSAJE;

update operacion.opedd t
   set t.descripcion = 'Procensado'
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'EST_GEST_PROV')
  and t.abreviacion = 'PROC';
  
commit;
/