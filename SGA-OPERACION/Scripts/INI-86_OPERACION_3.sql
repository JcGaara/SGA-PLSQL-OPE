--- delete OPERACION.OPEDD
delete OPERACION.OPEDD
 where TIPOPEDD = (select TIPOPEDD
                     from OPERACION.TIPOPEDD
                    where ABREV = 'FLUJO_APROB_CARGOS_NIVEL');
commit;

--- insert OPERACION.OPEDD
insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('4291',
   1,
   'Jefe Corp. Zonal - Cusco / M.Dios / Ap',
   'JEFE_ZONAL_1',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3900',
   1,
   'Jefe Corporativo Zonal - Moquegua/Tacna',
   'JEFE_ZONAL_2',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('1122',
   1,
   'Jefe de Cuentas Estratégicas',
   'JEFE_ESTRATEGICAS',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('2023',
   1,
   'Jefe de Grandes Cuentas Norte',
   'JEFE_NORTE',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('6900',
   1,
   'Jefe de Grandes Cuentas Sur',
   'JEFE_SUR',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('790',
   1,
   'Jefe de Ventas Cuentas Mayores 1',
   'JEFE_MAYORES_1',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('2204',
   1,
   'Jefe de Ventas Cuentas Mayores 2',
   'JEFE_MAYORES_2',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3027',
   1,
   'Jefe de Ventas Cuentas Mayores 3',
   'JEFE_MAYORES_3',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('2757',
   1,
   'Jefe de Ventas Cuentas Mayores 4',
   'JEFE_MAYORES_4',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('786',
   1,
   'Jefe de Ventas Cuentas Mayores 5',
   'JEFE_MAYORES_5',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('5683',
   2,
   'Gerente Banca y Finanzas',
   'GERENTE_B_F',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3274',
   2,
   'Gerente de Cuentas Mayores',
   'GERENTE_MAYORES',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3461',
   2,
   'Gerente de Grandes Cuentas Centro',
   'GERENTE _CENTRO',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('6127',
   2,
   'Gerente de Grandes Cuentas Región Norte',
   'GERENTE_NORTE',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('4018',
   2,
   'Gerente de Grandes Cuentas Región Sur',
   'GERENTE_SUR',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('5677',
   2,
   'Gerente Sector Gobierno',
   'GERENTE_GOBIERNO',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('5665',
   2,
   'Gerente Sector Industria',
   'GERENTE_INDUSTRIA',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('5690',
   2,
   'Gerente Sector Servicios',
   'GERENTE_SERVICIOS',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('5630',
   3,
   'Sub Director de Mercado Empresarial',
   'SUB_DIRECTOR_EMPRESARIAL',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3028',
   3,
   'Sub Director de Mercado Negocios',
   'SUB_DIRECTOR_NEGOCIOS',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3086',
   4,
   'Director de Mercado Corporativo',
   'DIRECTOR_CORPORATIVO',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3083',
   4,
   'Director Regional del Norte',
   'DIRECTOR_NORTE',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);

insert into OPERACION.OPEDD
  (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values
  ('3084',
   4,
   'Director Regional del Sur',
   'DIRECTOR_SUR',
   (select TIPOPEDD
      from OPERACION.TIPOPEDD
     where ABREV = 'FLUJO_APROB_CARGOS_NIVEL'),
   null);
commit;
