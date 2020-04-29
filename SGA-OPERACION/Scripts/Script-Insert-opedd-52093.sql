INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'richard.medina@claro.com.pe',
	NULL,
	'Correo SOAP DTH',
	'SOAP_DTH',
	(SELECT tipopedd from tipopedd where abrev = 'MAIL_DTH'),
	NULL);

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	NULL, 
	67, 
	'TV Satelital', 
	'TV_SAT',
	(SELECT tipopedd from tipopedd where abrev = 'TV_DTH'),
	NULL);

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'SUSPENSION',
	NULL,
	'SUSPENSION DTH',
	'SUSP_DTH',
	(SELECT tipopedd from tipopedd where abrev = 'OPE_DTH'),
	NULL);

INSERT INTO operacion.opedd ( 
  idopedd,
  codigoc, 
  codigon, 
  descripcion, 
  abreviacion, 
  tipopedd, 
  codigon_aux)
VALUES (
	(select max(operacion.opedd.idopedd) + 1 from operacion.opedd),
	'FVIG',
	NULL,
	'FIN DE VIGENCIA',
	'FVIG_DTH',
	(SELECT tipopedd from tipopedd where abrev = 'OPE_DTH'),
	NULL);

COMMIT;
/
