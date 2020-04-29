-- Registro de Tipos de Trabajo para Registros de Agendamiento
insert into operacion.tipopedd(descripcion,abrev) values('Parm. de Registro de Agenda','PARAM_REG_AGE');
commit;

insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',402,'INSTALACION PAQUETES TPI - COAXIAL',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',404,'HFC - INSTALACION PAQUETES',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',424,'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',427,'HFC - CAMBIO DE PLAN',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',439,'HFC - MIGRACIÓN A HFC',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',658,'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('ALTA',676,'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
insert into operacion.opedd(codigoc,codigon,descripcion,tipopedd) values ('BAJA',448,'HFC - BAJA TODO CLARO TOTAL',(select tipopedd from tipopedd where abrev='PARAM_REG_AGE'));
commit;