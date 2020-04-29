----------------------------------------RU01-RF02 ESTADOS DE LA PROVISION----------------------------------------------
delete from operacion.opedd t
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'EST_GEST_PROV');
         
delete from operacion.tipopedd t
 where t.abrev = 'EST_GEST_PROV';       

----------------------------------------RU01-RF02 MENSAJE DE ERROR JANUS----------------------------------------------
delete from operacion.opedd t
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'MSJ_PROJAN');

delete from operacion.tipopedd t
 where t.abrev = 'MSJ_PROJAN';              
         
-------------------------------------- RU01-RF 02: CONFIGURACION DE TIEMPO -------------------------------------------
delete from operacion.opedd t
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'CONFG_TIP_PROV');

delete from operacion.tipopedd t
 where t.abrev = 'CONFG_TIP_PROV';  
                                   
----------------------------------------RU01-RF05 ENVIO DE CORREO -----------------------------------------------                     
delete from operacion.opedd t
 where t.tipopedd in  (select a.tipopedd
						 from operacion.tipopedd a
						where a.abrev = 'CONF_EMAIL_PROV');
         
delete from operacion.tipopedd t
 where t.abrev = 'CONF_EMAIL_PROV';          

update operacion.opedd
   set codigon=1237
where tipopedd=260
   and descripcion='INSTALACION 3 PLAY INALAMBRICO';
                                                               

commit;

drop sequence OPERACION.PSGASEQ_LOGAPROVLTE;

drop table OPERACION.PSGAT_ESTSERVICIO;

drop table OPERACION.SGAT_LOGAPROVLTE;
/