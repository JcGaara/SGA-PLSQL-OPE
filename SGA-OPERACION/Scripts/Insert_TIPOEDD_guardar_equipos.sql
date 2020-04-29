
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Aplicativo APP Instalador', 'APPI');

insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'TIPO : INSTALACION ALTAS', 'INSTALACION',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),1);

insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'ACTIVA : ', 'INSTALACION',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),1);
      
insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'ESTADO : TOA-INICIADO', 'INSTALACION',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),1);
      
insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'OBS : INSTALACION EJECUTADA', 'INSTALACION',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),1);

insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'TIPO : CAMBIO DE EQUIPO', 'CAMBIO',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),2);

insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'RETIRA : ', 'CAMBIO',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),2);

insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'ACTIVA :', 'CAMBIO',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),2);
      
insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'ESTADO : TOA-INICIADO', 'CAMBIO',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),2);
      
insert into OPERACION.OPEDD (descripcion,Abreviacion,tipopedd,CODIGON_AUX)
values ( 'OBS : CAMBIO DE EQUIPO EJECUTADO', 'CAMBIO',(select t.tipopedd from tipopedd t where t.abrev = 'APPI'),2);


COMMIT;

/