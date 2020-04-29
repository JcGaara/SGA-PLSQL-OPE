--FR1
--1.a
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (5,'Anulado',200);
update operacion.opedd set descripcion='En Contrata' where idopedd=1756; --codigon:2
update operacion.opedd set descripcion='Sp Generada' where idopedd=1757; --codigon:3
commit;
--2.a
insert into operacion.tipopedd (tipopedd, descripcion, abrev)
values ((select max(tipopedd)+1 from tipopedd),'OP - Areas Liquidación MO','OPE_AREAS_LIQUID');
commit;
--detalle
insert into operacion.opedd (codigoc,codigon, descripcion, tipopedd)
values ('DMC',1,'DIRECCION DE MERCADO CORPORATIVO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc,codigon, descripcion, tipopedd)
values ('DR',2,'DIRECCION DE RED',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc,codigon, descripcion, tipopedd)
values ('DL',3,'DIRECCION LEGAL',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc,codigon, descripcion, tipopedd)
values ('DMMA',4,'DIRECCION MERCADO MASIVO ALAMBRICO',(select max(tipopedd) from tipopedd));
commit;

--2.b
insert into operacion.tipopedd (tipopedd, descripcion, abrev)
values ((select max(tipopedd)+1 from tipopedd),'OP - Servicios Liquidación MO','OPE_SERV_LIQUID');
commit;
--detalle
--DIRECCION DE MERCADO CORPORATIVO
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',1,'CLARO CORPORACIONES - BAJAS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',2,'CLARO CORPORACIONES - INSTALACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',3,'CLARO CORPORACIONES - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',4,'CLARO CORPORACIONES - TRASLADOS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',5,'CLARO EMPRESAS - INSTALACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',6,'CLARO EMPRESAS - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',7,'CLARO EMPRESAS - MIGRACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',8,'DPL - INSTALACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',9,'PEXT - CLIENTES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',10,'PEXT - DISEÑO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',11,'PEXT - FACT',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',12,'PINT - DISEÑO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',13,'TP - DISEÑO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',14,'TP - FACT',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',15,'TPE - BAJAS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',16,'TPE - INSTALACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',17,'TPE - TRASLADOS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',18,'TPI - COAXIAL',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',19,'TPI - INSTALACIONES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',20,'TPI / CLARO EMPRESAS - BAJAS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMC',21,'3.5 / 5.8',(select max(tipopedd) from tipopedd));
--DIRECCION DE RED
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',22,'RED - DISEÑO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',23,'RED - FACT',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',24,'RED - IMPLEMENTACION',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',25,'RED - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',26,'RED - PEXT',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',27,'RED DISEÑO - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',28,'RED DPL - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',29,'RED PROVINCIAS - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',30,'RED TPE - MANTTO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DR',31,'RED TPI - MANTTO',(select max(tipopedd) from tipopedd));
--DIRECCION LEGAL
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DL',32,'PERMISOS - CLIENTES',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DL',33,'PERMISOS - EDIFICIOS',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DL',34,'PERMISOS - PEXT',(select max(tipopedd) from tipopedd));
--DIRECCION MERCADO MASIVO ALAMBRICO
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',35,'HFC - EXPLOTACION',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',36,'HFC - INSTALACIONES AREQUIPA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',37,'HFC - INSTALACIONES CHICLAYO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',38,'HFC - INSTALACIONES ICA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',39,'HFC - INSTALACIONES LIMA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',40,'HFC - INSTALACIONES PIURA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',41,'HFC - INSTALACIONES ANCASH',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',42,'HFC - INSTALACIONES TRUJILLO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',43,'HFC - MANTTO CLIENTES CHICLAYO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',44,'HFC - MANTTO CLIENTES LIMA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',45,'HFC - MANTTO CLIENTES PIURA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',46,'HFC - MANTTO CLIENTES TRUJILLO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',47,'HFC - MANTTO PEXT LIMA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',48,'HFC - MIGRACION',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',49,'HFC - SERVICIOS CHICLAYO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',50,'HFC - SERVICIOS LIMA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',51,'HFC - SERVICIOS PIURA',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',52,'HFC - SERVICIOS ANCASH',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',53,'HFC - SERVICIOS TRUJILLO',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',54,'HFC - TPI COAXIAL',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigoc, codigon, descripcion, tipopedd)
values ('DMMA',55,'HFC - INSTALACIONES CLARO EMPRESAS',(select max(tipopedd) from tipopedd));
commit;

--2.c
insert into operacion.tipopedd (tipopedd, descripcion, abrev)
values ((select max(tipopedd)+1 from tipopedd),'OP - Evaluación Liquidación MO','OPE_EVAL_LIQ_MO');
commit;
--detalle
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (1,'No aplica',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (2,'Excelente',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (3,'Bueno',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (4,'Regular',(select max(tipopedd) from tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd)
values (5,'Malo',(select max(tipopedd) from tipopedd));
commit;

--F2
-- Add/modify columns 
alter table OPEWF.USUARIOXAREAOPE add flg_supervxarea number default 0 not null;
-- Add comments to the columns 
comment on column OPEWF.USUARIOXAREAOPE.flg_supervxarea
  is 'flag supervisor x area para liquidacion MO 0:no supervisor 1: supervisor de area';

--F3
-- Add/modify columns 
alter table OPERACION.SOT_LIQUIDACION add FEC_PROP_CIERRE date;
alter table OPERACION.SOT_LIQUIDACION add FEC_RECIB_CONTRATA date;
alter table OPERACION.SOT_LIQUIDACION add NUM_PEDIDO_COMPRA number(12);
alter table OPERACION.SOT_LIQUIDACION add FEC_PEDIDO_COMPRA date;
alter table OPERACION.SOT_LIQUIDACION add NUM_DIAS number(3);
alter table OPERACION.SOT_LIQUIDACION add EVAL_TECNICA number(2);
alter table OPERACION.SOT_LIQUIDACION add EVAL_LIQUIDACION number(2);
alter table OPERACION.SOT_LIQUIDACION add SUPERV_SERVICIO varchar2(30);
alter table OPERACION.SOT_LIQUIDACION add ID_SERV_LIQUID number(10);
alter table OPERACION.SOT_LIQUIDACION add TOTA_VALORIZ NUMBER(12,2);
alter table OPERACION.SOT_LIQUIDACION modify ANALISTA VARCHAR2(30);
alter table OPERACION.SOT_LIQUIDACION modify SERVICIO VARCHAR2(100);
-- Add comments to the columns 
comment on column OPERACION.SOT_LIQUIDACION.FEC_PROP_CIERRE
  is 'Fecha de propuesta de cierre';
comment on column OPERACION.SOT_LIQUIDACION.FEC_RECIB_CONTRATA
  is 'Fecha en que recibio la contrata';
comment on column OPERACION.SOT_LIQUIDACION.NUM_PEDIDO_COMPRA
  is 'Numero de Pedido de Compra';
comment on column OPERACION.SOT_LIQUIDACION.FEC_PEDIDO_COMPRA
  is 'Fecha de Pedido de Compra';
comment on column OPERACION.SOT_LIQUIDACION.NUM_DIAS
  is 'Número de Días';
comment on column OPERACION.SOT_LIQUIDACION.EVAL_TECNICA
  is 'Evaluación Técnica';
comment on column OPERACION.SOT_LIQUIDACION.EVAL_LIQUIDACION
  is 'Evaluación de Liquidación';
comment on column OPERACION.SOT_LIQUIDACION.SUPERV_SERVICIO
  is 'Supervisor Servicio';
comment on column OPERACION.SOT_LIQUIDACION.ID_SERV_LIQUID
  is 'ID servicio liquidacion - tipos y estados ABREV:OPE_SERV_LIQUID';
comment on column OPERACION.SOT_LIQUIDACION.tota_valoriz
  is 'suma total entre cantidad y costo de liquidacion';
  
update operacion.sot_liquidacion set analista = codusu
where analista is null;
commit;
  
/
declare
  cursor cur_total is
    select idliq from operacion.sot_liquidacion;
begin
  for c_total in cur_total loop
    update operacion.sot_liquidacion
       set tota_valoriz = (select sum(t.canliq * t.cosliq)
                             from solotptoeta s, solotptoetaact t
                            where s.codsolot = t.codsolot
                              and s.orden = t.orden
                              and s.punto = t.punto
                              and s.idliq = c_total.idliq)
     where idliq = c_total.idliq;
  end loop;
  commit;
end;
/