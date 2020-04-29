
delete from  operacion.OPEDD  where TIPOPEDD= (SELECT op.TIPOPEDD FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADO_SOT')  ;
commit;


delete  FROM operacion.TIPOPEDD op  WHERE op.ABREV='ESTADO_SOT';
commit;

