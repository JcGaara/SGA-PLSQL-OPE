alter table operacion.sgat_logaprovlte ADD LOGAV_MENSAJE VARCHAR2(500);

update operacion.opedd t
   set t.descripcion = 'Procesando'
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'EST_GEST_PROV')
  and t.abreviacion = 'PROC';
  
commit;
/