INSERT INTO operacion.parametro_cab_adc (DESCRIPCION,ABREVIATURA,ESTADO)
  VALUES('VALIDACION DE FRANJAS','VAL_FRA','1');
  
INSERT INTO  operacion.parametro_det_adc d (ID_PARAMETRO,CODIGOC,CODIGON,DESCRIPCION,ABREVIATURA,ESTADO)
VALUES((select id_parametro from operacion.parametro_cab_adc where  abreviatura='VAL_FRA'), 'NUMFRA',2,'CANTIDAD DE FRANJAS','CAN_FRA','1');

insert into operacion.parametro_cab_adc (DESCRIPCION, ABREVIATURA, ESTADO)
values ('REGLAS DE FRANJA HORARIA POR TIPO TRABAJO Y MODULO', 'REGLA_FRANJA_HORARIA', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 489, 'HFC RETENCIÓN', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'O', 660, 'HFC - BAJA DECO ALQUILER', 'SISACT', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'O', 448, 'HFC - BAJA TODO CLARO TOTAL', 'SISACT', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 480, 'HFC - MANTENIMIENTO ', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 407, 'HFC - RECLAMO', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 671, 'HFC - FIDELIZACION', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 770, 'HFC-ATENCION PREVENTIVA', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 610, 'HFC - MANTENIMIENTO CLARO EMPRESAS', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 612, 'DTH - RETENCION', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'M', 724, 'CE HFC - SERVICIOS MENORES', 'DIA_SIGUIENTE', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'M', 418, 'HFC - TRASLADO INTERNO', 'DIA_SIGUIENTE', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'M', 620, 'CLARO EMPRESAS HFC - SERVICIOS MENORES', 'DIA_SIGUIENTE', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'N', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'SISACT', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'M', 412, 'TRASLADO EXTERNO', 'SISACT', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 727, 'DTH - RECLAMO', 'MANTTOS', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'A', 448, 'HFC - BAJA TODO CLARO TOTAL', 'SISACT', '1');

insert into operacion.parametro_det_adc (ID_PARAMETRO, CODIGOC, CODIGON, DESCRIPCION, ABREVIATURA, ESTADO)
values ((select id_parametro from operacion.parametro_cab_adc where abreviatura = 'REGLA_FRANJA_HORARIA'), 'O', 489, 'HFC RETENCIÓN', 'MANTTOS', '1');

commit;
/
