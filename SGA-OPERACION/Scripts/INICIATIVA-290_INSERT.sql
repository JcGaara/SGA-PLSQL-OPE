INSERT INTO operacion.tipopedd y (y.tipopedd, y.descripcion, y.abrev)
VALUES
  ((SELECT MAX(x.tipopedd) FROM operacion.tipopedd x) + 1,
   'Reglas Suma días de plazo EF',
   'REG_SUM_DIAPLA_EF');
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Ingenieria',
   70,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   1);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_cliente',
   21,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   1);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Gen_solped',
   470,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   2);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_cliente',
   21,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   2);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_cliente',
   21,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   3);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Adec_capac',
   468,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   3);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Adec_puer',
   469,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   4);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_cliente',
   21,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   4);

INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Pla_dis',
   11,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   5);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_redext',
   10,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   5);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Autor',
   12,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   5);
   
INSERT INTO operacion.opedd
  (idopedd,
   codigoc,
   codigon,
   descripcion,
   abreviacion,
   tipopedd,
   codigon_aux)
VALUES
  ((SELECT MAX(x.idopedd) FROM operacion.opedd x) + 1,
   'Inst_cliente',
   21,
   'Factor de regla para sumatoria de plazos EF',
   'REG_SUM_DIAPLA_EF',
   (SELECT tipopedd FROM tipopedd WHERE abrev = 'REG_SUM_DIAPLA_EF'),
   5);

commit;
