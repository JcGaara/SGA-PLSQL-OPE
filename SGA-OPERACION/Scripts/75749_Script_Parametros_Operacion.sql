-- 2) Inserto de parametro de Cábecera para SOLOTPTOEQU
insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
VALUES ('Equipos LTE Telefonia', 'TIPEQU_LTE_TLF');

-- 3) Inserto de parametro de Detalle para SOLOTPTOEQU
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION,TIPOPEDD)
values ('3', 16308, 'SIM CARD LTE',(select tipopedd from operacion.tipopedd where ABREV = 'TIPEQU_LTE_TLF'));

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION,TIPOPEDD)
values ('4', 16939, 'ANTENA HUAWEI B2268S LTE TDD OUTDOOR',(select tipopedd from operacion.tipopedd where ABREV = 'TIPEQU_LTE_TLF'));

-- 4) Inserto el tipo de trabajo
insert into operacion.opedd
  (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values
  ((select tiptra
      from operacion.tiptrabajo
     where descripcion = 'INSTALACION 3 PLAY INALAMBRICO'),
   'VENTA SISACT WLL',
   'SISACT_WLL',
   (select tipopedd from tipopedd where abrev='TIPTRABAJO'));
Commit;

-- 5) Insertar informacion en OPEDD
insert into operacion.opedd(codigoc,codigon,descripcion,abreviacion,tipopedd) values 
('000000000004005623',647,'SIM CARD LTE','LTE',197);

insert into operacion.opedd(codigoc,codigon,descripcion,abreviacion,tipopedd) values 
('000000000004006171',647,'ANTENA HUAWEI B2268S LTE TDD OUTDOOR','LTE',197);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('000000000004005623', 'SIM CARD LTE', 'LTE', 380);

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('000000000004006171', 'ANTENA HUAWEI B2268S LTE TDD OUTDOOR', 'LTE', 380);
Commit;