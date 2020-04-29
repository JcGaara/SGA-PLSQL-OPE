insert into OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Tipo de Aplicacion', 'TIPOS_UPGRADE');
INSERT INTO OPERACION.OPEDD (tipopedd , CODIGON,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 0,'No Aplica');
INSERT INTO OPERACION.OPEDD (tipopedd , CODIGON,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 1,'Mes Completo');
INSERT INTO OPERACION.OPEDD (tipopedd , CODIGON,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 2,'Mes Completo + Prorrateo');
commit;




