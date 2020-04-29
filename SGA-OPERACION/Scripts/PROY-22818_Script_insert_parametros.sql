-------------------------------RF: 20 ESTADO DE AGENDADO REPROCESO ORDEN----------------------------
insert into operacion.parametro_cab_adc(descripcion, abreviatura, estado)  
       values('CONFIG. ESTADO DE REPROCESO ORDEN', 'EST_REPORDEN',1);
	   
insert into operacion.parametro_det_adc(id_parametro,codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'EST_REPORDEN'),
              1,
              'Generado',
              'Est_gen',
              1);
			  
insert into operacion.parametro_det_adc(id_parametro,codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'EST_REPORDEN'),
              16,
              'En Agenda',
              'Est_enage',
              1);         
              
------------------------------RF: 20 MENSAJE DE ERROR ----------------------------------------------
insert into operacion.parametro_cab_adc(descripcion, abreviatura, estado)  
       values('MENSAJES DE ERROR - REPROCESO ORDEN', 'MNS_REORDEN',1);    
	   
insert into operacion.parametro_det_adc(id_parametro,codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'MNS_REORDEN'),
              1,
              'Orden Reprocesada con Éxito',
              'ORD_EXISTO',
              1);  
			  
insert into operacion.parametro_det_adc(id_parametro,codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'MNS_REORDEN'),
              -1,
              'Error no se pudo reprocesar la Orden',
              'ORD_NOREPRO',
              1);     
			  
insert into operacion.parametro_det_adc(id_parametro,codigon, descripcion, abreviatura, estado)  
       values((select a.id_parametro
                 from operacion.parametro_cab_adc a
                where a.abreviatura = 'MNS_REORDEN'),
              -99,
              'Error no se pudo reprocesar la Orden',
              'ORD_NOREPRO',
              1);   

commit;