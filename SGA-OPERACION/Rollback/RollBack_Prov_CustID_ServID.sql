
delete from  operacion.opedd 
where upper(ABREVIACION) = upper('TIPESCPARCTOTAL');

delete from  operacion.tipopedd 
where upper(ABREV) = upper('TIPESCPARCTOTAL');
commit;
/