insert into OPERACION.TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
values ((select max(tipopedd) + 1 from TIPOPEDD), 'Parametros Plataforma JANUS.', 'PAR_PLATAF_JANUS');

INSERT INTO OPERACION.OPEDD (tipopedd , CODIGOC, ABREVIACION,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 'IMSI', 'P_IMSI','Parametro del IMSI'); 

INSERT INTO OPERACION.OPEDD (tipopedd , CODIGOC, ABREVIACION,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 'HCTR', 'P_HCTR','Parametro del HCTR');  

INSERT INTO OPERACION.OPEDD (tipopedd , CODIGOC, ABREVIACION,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 'HCON', 'P_HCON','Parametro del HCON'); 

INSERT INTO OPERACION.OPEDD (tipopedd , CODIGOC, ABREVIACION,DESCRIPCION) 
VALUES ((select max(tipopedd) from TIPOPEDD), 'HCCD', 'P_HCCD','Parametro del HCCD'); 

commit;
