insert into operacion.opedd
  (tipopedd, codigon, descripcion, abreviacion)
values
  ((select tipopedd
     from operacion.tipopedd t
    where t.descripcion = 'OPE-Config TPI - GSM'),
   17,
   'TPI GSM - Plan Numeracion',
   'TPIGSM/codplan');

COMMIT;

