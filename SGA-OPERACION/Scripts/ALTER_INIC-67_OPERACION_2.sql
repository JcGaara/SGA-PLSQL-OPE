-- Cargos por niveles
insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'Plantilla AR - Niveles','FLUJO_APROB_CARGOS_NIVEL' from operacion.tipopedd t;

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values((SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op WHERE op.ABREV='FLUJO_APROB_CARGOS_NIVEL'),
 '', 1, '4291,3900,1122,2023,6900,790,2204,3027,2757,786', 'Nivel Aprobacion 1');

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values((SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op WHERE op.ABREV='FLUJO_APROB_CARGOS_NIVEL'),
 '', 2, '5683,3274,3461,6127,4018,5677,5665,5690', 'Nivel Aprobacion 2');

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values((SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op WHERE op.ABREV='FLUJO_APROB_CARGOS_NIVEL'),
 '', 3, '5630,3028', 'Nivel Aprobacion 3');

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values((SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op WHERE op.ABREV='FLUJO_APROB_CARGOS_NIVEL'),
 '', 4, '3086,3083,3084', 'Nivel Aprobacion 4');

 -- Direcciones
insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'Plantilla AR - Direcciones','FLUJO_APROB_DIRECCIONES' from operacion.tipopedd t;

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='FLUJO_APROB_DIRECCIONES'),
 ''  , 336 , 'Regional del Norte' , 'REGION_NORTE' )  ;

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='FLUJO_APROB_DIRECCIONES'),
 ''  , 385 , 'Regional del Sur' , 'REGION_SUR' )  ;

INSERT INTO operacion.OPEDD (TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='FLUJO_APROB_DIRECCIONES'),
 ''  , 515 , 'Mercado Corporativo' , 'MERCADO_CORPORATIVO' )  ;

commit;
