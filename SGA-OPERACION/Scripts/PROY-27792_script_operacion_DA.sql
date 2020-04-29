--Motivo para Baja Deco Adicional
insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (667, 'SOLICITUD DE INSTALACION - ALTA', 'SOLINSALTA', (SELECT t.tipopedd FROM operacion.tipopedd t where t.abrev = 'DECO_ADICIONAL'));

--Monto Baja Deco Adicional
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0', 'MONTO BAJA OCC - HFC/SIAC DECO ADICIONAL', 'MONTB_OCC', (SELECT t.tipopedd FROM operacion.tipopedd t where t.abrev = 'HFC_SIAC_DEC_ADICIONAL'));  


INSERT INTO operacion.mototxtiptra (tiptra, codmotot) VALUES (705, 667);
INSERT INTO operacion.mototxtiptra (tiptra, codmotot) VALUES (689, 667);

commit;
/