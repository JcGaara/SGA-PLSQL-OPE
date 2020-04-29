----------------------------------------RU01-RF02 ESTADOS DE LA PROVISION----------------------------------------------
insert into operacion.tipopedd(descripcion, abrev)
      values('EST PROVISION (CONAX,IL,JANUS)','EST_GEST_PROV');
      
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'NPRV','No Solicitado','NPRV');
             
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'NPRV1','No Solicitado','NPRV1');        
             
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'PROC','Procensado','PROC');                  
             
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'RPRO','Reprocesando','RPRO');     
              
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'EPLA','Enviando a Plataforma','EPLA');       
             
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'ERRO','Error','ERRO');    
             
insert into operacion.opedd(tipopedd,codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'EST_GEST_PROV'),
             null,'PROV','Provisionado','PROV');     

----------------------------------------RU01-RF02 MENSAJE DE ERROR JANUS----------------------------------------------
insert into operacion.tipopedd(descripcion, abrev)
      values('MSJ. ERROR PROVISION DE JANUS','MSJ_PROJAN');
      
insert into operacion.opedd(tipopedd, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'MSJ_PROJAN'),
             'No se pudo provisionar Janus, en la tarea de Validación se realizará el reproceso','MSJ_JANUS');			 
				 				 
              
-------------------------------------- RU01-RF 02: CONFIGURACION DE TIEMPO -------------------------------------------
insert into operacion.tipopedd(descripcion, abrev)
      values('CONF. TIEMPO ACT/REENVIO PROV','CONFG_TIP_PROV');
      
insert into operacion.opedd(tipopedd, codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONFG_TIP_PROV'),
             5, 'SEG', 'Tiempo de Act. de Estados','ACTEST');
             
insert into operacion.opedd(tipopedd, codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONFG_TIP_PROV'),
             0, 'MIN', 'Tiempo de Reenvio','TIEREE');     
             
insert into operacion.opedd(tipopedd, codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONFG_TIP_PROV'),
             3, null, 'Numero de Reenvio','NUMREE');   

insert into operacion.opedd(tipopedd, codigon, codigoc, descripcion, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONFG_TIP_PROV'),
             60, 'SEG', 'Numero de Espera Janus','TIMJNES');   
                                   
----------------------------------------RU01-RF05 ENVIO DE CORREO -----------------------------------------------                     
insert into operacion.tipopedd(descripcion, abrev)
      values('CONF. ENVIO CORREO ATU - LTE','CONF_EMAIL_PROV');
      
insert into operacion.opedd(tipopedd, codigon, descripcion, codigoc, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONF_EMAIL_PROV'),
             1, 'Problema con la provision de LTE', 'Asunto','CASUNT');
             
insert into operacion.opedd(tipopedd, codigon, descripcion, codigoc, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONF_EMAIL_PROV'),
             2, 'Problema con la provision de LTE (JANUS, IL, DTH)', 'Mensaje','CMENSJ');   
             
insert into operacion.opedd(tipopedd, codigon, descripcion, codigoc, abreviacion)
      values((select a.tipopedd
                from operacion.tipopedd a
               where a.abrev = 'CONF_EMAIL_PROV'),
             3, 'juan.rivas@claro.com.pe;jhoan.angeles@claro.com.pe;mcampost@claro.com.pe', 'Lista de correos','LISTMAIL');                                                        

update operacion.opedd
   set codigon=null
where tipopedd=260
   and descripcion='INSTALACION 3 PLAY INALAMBRICO';

commit;
/