
insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'ESTADOS EN CONSOLIDADO','ESTADOS-EN-CONSOLIDADO' from operacion.tipopedd t;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADOS-EN-CONSOLIDADO'),
 '0001'  , 1 , 'En Proceso' , 'EN_PROCESO' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADOS-EN-CONSOLIDADO'),
 '0002'  , 2 , 'Generado' , 'GENERADO' 
)  ;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADOS-EN-CONSOLIDADO'),
 '0003'  , 3 , 'Error' , 'ERROR' 
)  ;

COMMIT;
