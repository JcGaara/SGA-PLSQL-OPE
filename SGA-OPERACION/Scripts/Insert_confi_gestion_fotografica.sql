--- Configuracion Tipo Red
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIGURACION DE TIPO RED', 'TIPO_RED_APP');

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('1',1,'HFC', 'TIPO_RED_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_RED_APP'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '2',2,'FTTH', 'TIPO_RED_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_RED_APP'));
      
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '1,2',3,'HFC / FTTH', 'TIPO_RED_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_RED_APP'));

--- Configuracion Tipo Servico 
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIGURACION DE TIPO SERVICIO', 'TIPO_SERV_APP');

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('1',1,'Residencial', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '2',2,'Claro Empresas', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));
      
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '3',3,'Claro Empresas + IP', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));
      
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '4',4,'CATV Analogico', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '1,2,3,4',5,'Residencial / Claro Empresas / Claro Empresas + IP / CATV Analogico', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '1,2,3',6,'Residencial / Claro Empresas / Claro Empresas + IP', 'TIPO_SERV_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_SERV_APP'));

--- Configuracion Tipo Trabajo
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIGURACION DE TIPO TRABAJO', 'TIPO_TRAB_APP');

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ('1',1,'Instalacion', 'TIPO_TRAB_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_TRAB_APP'));

insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '2',2,'Mantenimiento', 'TIPO_TRAB_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_TRAB_APP'));
      
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '3',3,'Post Venta', 'TIPO_TRAB_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_TRAB_APP'));
      
insert into OPERACION.OPEDD (codigoc,codigon,descripcion,Abreviacion,tipopedd)
values ( '4',4,'Cambio de TAP', 'TIPO_TRAB_APP',(select t.tipopedd from tipopedd t where t.abrev = 'TIPO_TRAB_APP'));


COMMIT;
/