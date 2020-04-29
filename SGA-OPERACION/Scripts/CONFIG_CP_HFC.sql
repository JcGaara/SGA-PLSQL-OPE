insert into operacion.tipopedd (descripcion, abrev)
values('Confi de Cambio de Plan', 'CONFIGCP');

insert into operacion.tipopedd (descripcion, abrev)
values('Interfase Cambio de Plan', 'INTERFASECP' );

insert into operacion.tipopedd (descripcion, abrev)
values('Tip Trabajo de Cambio de Plan','TTRABCP');

 insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
 values('',1,'Configuracion de Cambio de Plan','CONFIGCP',(select tipopedd from operacion.tipopedd where abrev = 'CONFIGCP'),1);
 
 insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
 values('',2020,'Interfase Cambio de Plan','INTERFASECP',(select tipopedd from operacion.tipopedd where abrev = 'INTERFASECP'),1);
  insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
 values('',620,'Interfase Cambio de Plan','INTERFASECP',(select tipopedd from operacion.tipopedd where abrev = 'INTERFASECP'),1);
  insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
 values('',820,'Interfase Cambio de Plan','INTERFASECP',(select tipopedd from operacion.tipopedd where abrev = 'INTERFASECP'),1);
 
  insert into operacion.opedd (codigoc,codigon,descripcion,abreviacion,tipopedd,codigon_aux)
 values('',695,'Tipo de Trabajo de Cambio de Plan','TTRABCP',(select tipopedd from operacion.tipopedd where abrev = 'TTRABCP'),1); 

commit;



