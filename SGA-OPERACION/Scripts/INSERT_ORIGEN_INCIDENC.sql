insert into operacion.tipopedd (tipopedd,descripcion,abrev) 
select nvl(max(t.tipopedd),0) + 1  ,'ORIGEN INCIDENCIA CONSOLIDADO','ORIGEN_INCIDEN_CONSOL' from operacion.tipopedd t;

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ORIGEN_INCIDEN_CONSOL'),
''  , 1 , 'Proceso Automatico' , 'Proc_Automatico');

INSERT INTO operacion.OPEDD (IDOPEDD,TIPOPEDD,CODIGOC,CODIGON,DESCRIPCION,ABREVIACION) 
values( 
(select nvl(max(oped.idopedd),0) + 1  from  operacion.opedd oped) ,
(SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ORIGEN_INCIDEN_CONSOL'),
''  , 2 , 'Proceso Shell' , 'Proc_Shell');

COMMIT;
