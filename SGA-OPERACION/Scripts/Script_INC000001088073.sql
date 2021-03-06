-- INSERTS TABLA TIPOPEDD
INSERT INTO OPERACION.TIPOPEDD(DESCRIPCION, ABREV) VALUES ('VALORES DE STATUS DE CONTRATO','VAL_STATUS_CONTRAT'); 

-- INSERTS TABLA OPEDD
INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('d',5,'Contrato Desactivo y con pendiente','x',(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('d',4,'Contrato Desactivo y sin pendiente',null,(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('s',3,'Suspendido y con pendiente','x',(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('s',2,'Suspendido y sin pendiente',null,(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('a',1,'Activo y sin pendiente',null,(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('o',0,'Onhold y Activo con pendiente',null,(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

INSERT INTO OPERACION.OPEDD(CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX) 
VALUES ('a',0,'Onhold y Activo con pendiente','x',(SELECT TIPOPEDD FROM TIPOPEDD T WHERE T.ABREV = 'VAL_STATUS_CONTRAT'),0);

COMMIT;
