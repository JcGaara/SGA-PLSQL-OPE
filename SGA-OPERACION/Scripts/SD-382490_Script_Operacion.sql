alter table OPERACION.PLANO add AREA NUMBER(2);
alter table OPERACION.PLANO add FECREC DATE default SYSDATE;
alter table OPERACION.PLANO add STAPLANO number(2);
alter table OPERACION.PLANO add PNI NUMBER(2);
alter table OPERACION.PLANO add FECINGPNI DATE;
alter table OPERACION.PLANO add FECENT DATE;
alter table OPERACION.PLANO add FECREV DATE;
alter table OPERACION.PLANO add IDENTIFICADOR number(2);
alter table OPERACION.PLANO add ESTREV    NUMBER(1);
alter table OPERACION.PLANO add USUREC    VARCHAR2(30) default USER;
alter table OPERACION.PLANO add PAQUETE   VARCHAR2(20);
alter table OPERACION.PLANO add FECING    DATE;
alter table OPERACION.PLANO add FECRECING DATE;
alter table OPERACION.PLANO add USUOPEGIS VARCHAR2(30);
alter table OPERACION.PLANO add OPENIV NUMBER(1);
alter table OPERACION.PLANO add STACONTROL NUMBER(1);
alter table OPERACION.PLANO add USUSUPERV VARCHAR2(30);
alter table OPERACION.PLANO add CODSOLOTORI  NUMBER(8);

comment on column OPERACION.PLANO.AREA  is 'Area';
comment on column OPERACION.PLANO.FECREC   is 'Fecha de recepción';
comment on column OPERACION.PLANO.STAPLANO   is 'Estatus de Plano';
comment on column OPERACION.PLANO.PNI  is 'PNI';
comment on column OPERACION.PLANO.FECINGPNI  is 'Fecha de ingreso PNI';
comment on column OPERACION.PLANO.FECENT  is 'Fecha de entrega';
comment on column OPERACION.PLANO.FECREV  is 'Fecha de revisión';
comment on column OPERACION.PLANO.IDENTIFICADOR  is 'Identificador';
comment on column OPERACION.PLANO.USUREV  is 'Usuario de revisión';
comment on column OPERACION.PLANO.ESTREV  is 'Estado de revisión';
comment on column OPERACION.PLANO.USUREC  is 'Usuario que recepciona';
comment on column OPERACION.PLANO.PAQUETE  is 'Paquete';
comment on column OPERACION.PLANO.FECING  is 'Fecha de ingreso';
comment on column OPERACION.PLANO.FECRECING  is 'Fecha de recepción de ingreso';
comment on column OPERACION.PLANO.USUOPEGIS  is 'Usuario de Operacion GIS';
comment on column OPERACION.PLANO.OPENIV  is 'Nivel de operación';
comment on column OPERACION.PLANO.STACONTROL  is 'Estado de control';
comment on column OPERACION.PLANO.USUSUPERV  is 'Usuario supervisor';
comment on column OPERACION.PLANO.CODSOLOTORI  is 'Solicitud de trabajo de origen';

--insert

insert into operacion.tipopedd (descripcion, abrev) values ('COP-GIS- AREA','CPAREA');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'REC','CPAREA',(select tipopedd from operacion.tipopedd where abrev='CPAREA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'PEC','CPAREA',(select tipopedd from operacion.tipopedd where abrev='CPAREA'));
insert into operacion.tipopedd (descripcion, abrev) values ('OP-GIS- STATUS PLANO','CPSPLA');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'Consolidado','CPSPLA',(select tipopedd from operacion.tipopedd where abrev='CPSPLA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'Ninguno','CPSPLA',(select tipopedd from operacion.tipopedd where abrev='CPSPLA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (3,'Pendiente','CPSPLA',(select tipopedd from operacion.tipopedd where abrev='CPSPLA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (4,'Por Recepcionar','CPSPLA',(select tipopedd from operacion.tipopedd where abrev='CPSPLA'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (5,'Recibido por Consolidado','CPSPLA',(select tipopedd from operacion.tipopedd where abrev='CPSPLA'));
insert into operacion.tipopedd (descripcion, abrev) values ('COP-GIS- IDENTIFICADOR','CPIDENT');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'CU','CPIDENT',(select tipopedd from operacion.tipopedd where abrev='CPIDENT'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'FO','CPIDENT',(select tipopedd from operacion.tipopedd where abrev='CPIDENT'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (3,'HFC','CPIDENT',(select tipopedd from operacion.tipopedd where abrev='CPIDENT'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (4,'MOVIL','CPIDENT',(select tipopedd from operacion.tipopedd where abrev='CPIDENT'));
insert into operacion.tipopedd (descripcion, abrev) values ('OP-GIS- PNI','CPPNI');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'Aplica','CPPNI',(select tipopedd from operacion.tipopedd where abrev='CPPNI'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'No Aplica','CPPNI',(select tipopedd from operacion.tipopedd where abrev='CPPNI'));
insert into operacion.tipopedd (descripcion, abrev) values ('OP-GIS- OPEGIS','CPOPENIV');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'Grave','CPOPENIV',(select tipopedd from operacion.tipopedd where abrev='CPOPENIV'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'Leve','CPOPENIV',(select tipopedd from operacion.tipopedd where abrev='CPOPENIV'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (3,'Medio','CPOPENIV',(select tipopedd from operacion.tipopedd where abrev='CPOPENIV'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (7,'Eliminado','',231);
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (8,'Observado','',231);
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (9,'Pendiente','',231);
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (10,'Rechazado','',231);
insert into operacion.tipopedd (descripcion, abrev) values ('OP-GIS- STATUS REVISION','CPSREV');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (1,'Ok','CPSREV',(select tipopedd from operacion.tipopedd where abrev='CPSREV'));
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (2,'Rechazado','CPSREV',(select tipopedd from operacion.tipopedd where abrev='CPSREV'));
insert into operacion.tipopedd (descripcion, abrev) values ('OP-GIS-ETAPAS DISEÑO','CPEDIS');
insert into operacion.opedd(CODIGON,descripcion,abreviacion,tipopedd) values (637,'CLIENTE- DISEÑO','CPEDIS',(select tipopedd from operacion.tipopedd where abrev='CPEDIS'));

commit;


