-- script PARAMETROS

-- TIPOPEDD
insert into operacion.tipopedd ( descripcion, abrev) values ('CFG VALIDA ESTADO CONTRATO', 'SGA_VAL_ESTADO_CONTRATO');   

-- OPEDD 
insert into operacion.opedd (codigon, descripcion, tipopedd) values (0,'Contrato Pendiente de inicio de facturación', (select tipopedd from operacion.tipopedd where abrev = 'SGA_VAL_ESTADO_CONTRATO'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (4,'El Contrato esta Desactivado, verificar',     (select tipopedd from operacion.tipopedd where abrev = 'SGA_VAL_ESTADO_CONTRATO'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (5,'El Contrato esta Desactivado, verificar',     (select tipopedd from operacion.tipopedd where abrev = 'SGA_VAL_ESTADO_CONTRATO'));

commit;
