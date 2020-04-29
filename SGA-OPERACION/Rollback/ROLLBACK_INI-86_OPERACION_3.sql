--- delete
delete OPERACION.OPEDD
 where TIPOPEDD = (select TIPOPEDD
                     from OPERACION.TIPOPEDD
                    where ABREV = 'FLUJO_APROB_CARGOS_NIVEL');
commit;
--- insert
insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   2,
   '88,5683,3274,3461,6127,4018,5677,5665,5690',
   'Nivel Aprobacion 2',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   1,
   '138,4291,3900,1122,2023,6900,790,2204,3027,2757,786',
   'Nivel Aprobacion 1',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   3,
   '5630,3028',
   'Nivel Aprobacion 3',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  (null,
   4,
   '3086,3083,3084',
   'Nivel Aprobacion 4',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);
commit;