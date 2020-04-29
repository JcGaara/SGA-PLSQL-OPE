insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from opedd),
   null,
   1494,
   'Plan 2 Play Internet -Telefono',
   'PLAN',
   (select MAX(tipopedd) from tipopedd where upper(abrev) = 'BSCS_CONTRATO'),
   1);


insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from opedd),
   null,
   1495,
   'Plan 2 Play Cable -Telefono',
   'PLAN',
   (select MAX(tipopedd) from tipopedd where upper(abrev) = 'BSCS_CONTRATO'),
   1);

insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from opedd),
   null,
   1497,
   'Plan 1 Play Telefonia',
   'PLAN',
   (select MAX(tipopedd) from tipopedd where upper(abrev) = 'BSCS_CONTRATO'),
   1);

insert into opedd
  (IDOPEDD,
   CODIGOC,
   CODIGON,
   DESCRIPCION,
   ABREVIACION,
   TIPOPEDD,
   CODIGON_AUX)
values
  ((select max(IDOPEDD) + 1 from opedd),
   null,
   1492,
   'Plan HFC 3PLay',
   'PLAN',
   (select MAX(tipopedd) from tipopedd where upper(abrev) = 'BSCS_CONTRATO'),
   1);
  
COMMIT;
