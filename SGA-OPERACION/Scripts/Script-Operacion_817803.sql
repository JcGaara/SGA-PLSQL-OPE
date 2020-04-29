/*Insertamos parametros*/

INSERT INTO operacion.opedd
  (idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES
  ((SELECT MAX(idopedd) + 1 FROM opedd),
   480,
   'HFC - MANTENIMIENTO',
   'TIPTRA_VAL_OV',
   (select tipopedd from tipopedd where abrev = 'PRC_HFC_OPT_OV'),
   null);


INSERT INTO operacion.opedd
  (idopedd, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
VALUES
  ((SELECT MAX(idopedd) + 1 FROM opedd),
   610,
   'HFC - MANTENIMIENTO CLARO EMPRESAS',
   'TIPTRA_VAL_OV',
   (select tipopedd from tipopedd where abrev = 'PRC_HFC_OPT_OV'),
   null);

commit;
/