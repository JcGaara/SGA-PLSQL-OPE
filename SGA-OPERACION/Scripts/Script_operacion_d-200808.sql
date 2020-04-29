
INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADO_SOT'),
 ''  , 29 , 'Atendida' , '' )  ;
commit;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADO_SOT'),
 ''  , 12 , 'Cerrada' , '' )  ;
commit;


