------------------------- RF 14: ACTUALIZACION CANTIDAD DE DECOS--------------------------------------------------------
INSERT INTO operacion.parametro_cab_adc
  (descripcion, abreviatura, estado)
VALUES
  ('HFC ORDEN SERVICIOS', 'HFC_ORDEN_SERVICIOS', '1');
------------------------------------------------------------------------------------------------------------------------
INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   5,
   'CABLE - TELEFONIA',
   'CTV-TLF',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   6,
   'INTERNET - TELEFONIA',
   'INT-TLF',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   7,
   'CABLE - INTERNET - TELEFONIA',
   'CTV-INT-TLF',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   1,
   'CABLE',
   'CTV',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   2,
   'INTERNET',
   'INT',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   3,
   'TELEFONIA',
   'TLF',
   '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFC_ORDEN_SERVICIOS'),
   NULL,
   4,
   'CABLE - INTERNET',
   'CTV-INT',
   '1');
------------------------------------------------------------------------------------------------------------------------  
INSERT INTO operacion.parametro_cab_adc
  (descripcion, abreviatura, estado)
VALUES
  ('HFCI ORDEN DECOS', 'HFCI_ORDEN_DECOS', '1');
------------------------------------------------------------------------------------------------------------------------   
INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFCI_ORDEN_DECOS'), NULL, 1, 'MENOR IGUAL A 2', 'MENOR_IGUAL_2', '1');

INSERT INTO operacion.parametro_det_adc
  (id_parametro, codigoc, codigon, descripcion, abreviatura, estado)
VALUES
  ((SELECT id_parametro
     FROM operacion.parametro_cab_adc
    WHERE abreviatura = 'HFCI_ORDEN_DECOS'), NULL, 2, 'MAYOR A 2', 'MAYOR_2', '1');
------------------------------------------------------------------------------------------------------------------------ 
UPDATE operacion.subtipo_orden_adc SET decos = 1 WHERE cod_subtipo_orden = 'DTHI2';
UPDATE operacion.subtipo_orden_adc SET decos = 2 WHERE cod_subtipo_orden = 'DTHI3';
					
INSERT INTO operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES
  (NULL,
   67,
   'Servicio a agendar',
   'masivo_analogico',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'etadirect'),
   1);
					
COMMIT;
/