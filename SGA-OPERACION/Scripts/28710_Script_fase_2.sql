INSERT INTO operacion.tipopedd (descripcion, abrev) VALUES ('SERVICIOS DE ALINEACION', 'SERV_ALI');
INSERT INTO operacion.tipopedd (descripcion, abrev) VALUES ('DIAS LISTADO DE ALINEACION', 'DIAS_ALI');

INSERT INTO operacion.opedd (codigon, descripcion, abreviacion, tipopedd, codigon_aux) VALUES (2, 'SERVICIOS DE ALINEACION', 'SERV_ALI', 
       (SELECT a.tipopedd FROM operacion.tipopedd a WHERE a.abrev = 'SERV_ALI'), 1);
INSERT INTO operacion.opedd (codigon, descripcion, abreviacion, tipopedd, codigon_aux) VALUES (4, 'SERVICIOS DE ALINEACION', 'SERV_ALI', 
       (SELECT a.tipopedd FROM operacion.tipopedd a WHERE a.abrev = 'SERV_ALI'), 1);
INSERT INTO operacion.opedd (codigon, descripcion, abreviacion, tipopedd, codigon_aux) VALUES (5, 'SERVICIOS DE ALINEACION', 'SERV_ALI', 
       (SELECT a.tipopedd FROM operacion.tipopedd a WHERE a.abrev = 'SERV_ALI'), 1);

INSERT INTO operacion.opedd (codigon, descripcion, abreviacion, tipopedd) VALUES (100, 'DIAS LISTADO DE ALINEACION EAI', 'DIAS_ALI_EAI', 
       (SELECT a.tipopedd FROM operacion.tipopedd a WHERE a.abrev = 'DIAS_ALI'));
INSERT INTO operacion.opedd (codigon, descripcion, abreviacion, tipopedd) VALUES (100, 'DIAS LISTADO DE ALINEACION BSCS', 'DIAS_ALI_BSCS', 
       (SELECT a.tipopedd FROM operacion.tipopedd a WHERE a.abrev = 'DIAS_ALI'));
COMMIT;
/