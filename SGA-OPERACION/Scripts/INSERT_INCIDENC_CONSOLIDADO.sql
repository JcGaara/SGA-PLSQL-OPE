

insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'INCIDEN CONSOLIDAR FIBRA CORP','INCIDEN-AL-CONSOLIDAR_FIBRA_C' from operacion.tipopedd t;


INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'1'  , 1 , 'No se encontraron datos en F_VERIFICA_PROYECTO_PYMES' , 'E' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'1'  , 2 , 'ERROR ORACLE' , 'E' 
)  ;


INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'1'  , 3 , 'No se encontraron datos de Tipo de Servicio del Proyecto' , 'E' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 4 , 'Proyecto no Consolidado por motivo de que el periodo actual y anterior no se encuentran registrados' , 'E' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'1'  , 8 , 'Error en consulta de Periodo' , 'E' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 9 , 'El Proyecto tiene Doble Moneda, verificar. No se realizan los Calculos' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 10 , 'El Proyecto no tiene Moneda, verificar. No se realizan los Calculos' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 11 , 'El Proyecto tiene como Proyecto Anterior a otro con Doble Moneda. No se realizan los Calculos!' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 12 , 'El Proyecto tiene como Proyecto Anterior a otro que no contiene Moneda. No se realizan los Calculos!' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 13 , 'El Proyecto tuvo errores en generacion de calculos. Montos Nulos!. No se realizan los Calculos!' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 15 , 'El Servicio no tiene un Reporte Asociado. No se visualizará en el Reporte de Consolidados de Venta.' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 16 , 'Proyecto se Consolido con el periodo anterior' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 17 , 'No existe Data en tablas de Procesos Anteriores' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
'3'  , 18 , 'No consolido el Proyecto' , 'C' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='INCIDEN-AL-CONSOLIDAR_FIBRA_C'),
 '3'  , 19 , 'Esta registrado el periodo anterior, el actual no existe' , 'C' 
)  ;

commit;

