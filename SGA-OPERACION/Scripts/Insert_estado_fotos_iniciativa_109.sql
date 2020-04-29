insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('CONFIGURACION DE ESTADOS FOTOS', 'ESTADO_FOTO');

insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values (1,'ATENDIDO', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));

insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values ( 2,'RECHAZADO DP01', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));
      
insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values ( 3,'EN PROCESO', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));
      
insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values ( 4,'RECHAZADO', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));

insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values ( 5,'PENDIENTE', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));

insert into OPERACION.OPEDD (codigon,descripcion,Abreviacion,tipopedd)
values ( 6,'REENVIA', 'ESTADO_FOTO',(select t.tipopedd from tipopedd t where t.abrev = 'ESTADO_FOTO'));

COMMIT;
/