insert into operacion.parametro_cab_adc(descripcion,abreviatura,estado) values('Configuracion de Inventario','CONF_INV','1');
insert into operacion.parametro_det_adc
(codigon,descripcion,abreviatura,estado,id_parametro) 
values
(1,
 'Tipo de Flag para Cargar Inventario',
 'FLG_INV',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='CONF_INV'));
commit;

insert into operacion.parametro_cab_adc(descripcion,abreviatura,estado) values('Validacion de Long. de Inventario','VAL_L_INV','1');
commit;
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de DNI',
   8,
   'DNI',
   'LONG_DNI',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de UA',
   16,
   'DECO',
   'LONG_UA',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de Serie de Deco',
   12,
   'DECO',
   'LONG_SRD',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de Serie de EMTA',
   12,
   'EMTA',
   'LONG_SRE',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de MAC1',
   12,
   'EMTA',
   'LONG_MAC1',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
insert into operacion.parametro_det_adc
  (codigoc, codigon, descripcion, abreviatura, estado, id_parametro)
values
  ('Longitud de MAC2',
   12,
   'EMTA',
   'LONG_MAC2',
   '1',
   (select id_parametro
    from operacion.parametro_cab_adc
    where abreviatura = 'VAL_L_INV'));
commit;
-- Insercion de Mensajes
insert into operacion.parametro_cab_adc(descripcion,abreviatura,estado) values('Configuracion de Mensajes Inventario','CONF_M_INV','1');
-- Insercion de Mensajes
insert into operacion.parametro_det_adc
(codigoc,descripcion,abreviatura,estado,id_parametro) 
values 
('No se registro DNI en Oracle Field Service.',
 'Provider not found',
 'MSJ_DNI_OFS',
 '1',
 (select ID_PARAMETRO from operacion.parametro_cab_adc where abreviatura='CONF_M_INV'));
commit;