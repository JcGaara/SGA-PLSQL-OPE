
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Val. del Instalador del Servicio Claro TV Inalambrico - CP'), 
        'Val. del Instalador del Servicio Claro TV Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Programacion Inalambrico - CP'), 
        'Programacion Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);		
		
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Carga Auto. Materiales y MO Inalambrico - CP'), 
        'Carga Auto. Materiales y MO Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);			
				
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Asignar Número Telefónico - CP'), 
        'Asignar Número Telefónico CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);		
		
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Registro de datos Inalambricos - CP'), 
        'Registro de datos Inalambricos - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);		
				
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Registro de Servicios en BSCS - CP'), 
        'Registro de Servicios en BSCS - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);	
				
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('PROV', 
	    (select tareadef from opewf.tareadef where descripcion = 'Activacion de Servicios Inalambricos - CP'), 
        'Activacion de Servicios Inalambricos - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);			
		
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('VAL', 
	    (select tareadef from opewf.tareadef where descripcion = 'Valid. de Instalacion de Serv. Inalambrico - CP'), 
        'Valid. de Instalacion de Serv. Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 4);		
				
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Liquidaciones Equ y MO - CP'), 
        'Liquidaciones Equ y MO - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);		
				
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Gestion fotos Inalambrico - CP'), 
        'Gestion fotos Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);		
						
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AUTO', 
	    (select tareadef from opewf.tareadef where descripcion = 'Gestion documentacion Inalambrico - CP'), 
        'Gestion documentacion Inalambrico - CP', 
		'LTE', 
		(SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_CP_CIERRE_SVT'), 8);		
		
COMMIT;
/		

