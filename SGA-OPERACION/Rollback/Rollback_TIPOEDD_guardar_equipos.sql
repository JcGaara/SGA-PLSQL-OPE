
  DELETE FROM OPERACION.OPEDD D WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD  FROM OPERACION.TIPOPEDD T
													WHERE T.ABREV = 'APPI');
  
  DELETE FROM OPERACION.TIPOPEDD D WHERE D.ABREV = 'APPI'; 
	
  
  COMMIT;
/