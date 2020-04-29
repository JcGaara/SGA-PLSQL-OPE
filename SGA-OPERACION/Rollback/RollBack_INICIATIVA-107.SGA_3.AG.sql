delete from  operacion.opedd 
where upper(ABREVIACION) = upper('INTERNET') and CODIGOC = 'HFC' and CODIGON = '10';

delete from  operacion.opedd 
where upper(ABREVIACION) = upper('TELEFONIA') and CODIGOC = 'HFC' and CODIGON = '11';

delete from  operacion.opedd 
where upper(ABREVIACION) = upper('CABLE') and CODIGOC = 'HFC' and CODIGON = '12';

delete from  operacion.tipopedd 
where upper(ABREV) = upper('ALTA_PROV');
commit;
/