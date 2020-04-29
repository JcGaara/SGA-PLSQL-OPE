 delete operacion.opedd where abreviacion = 'CONFIGCP'; 
 delete operacion.opedd where abreviacion = 'INTERFASECP'; 
 delete operacion.opedd where abreviacion = 'TTRABCP'; 
 
  delete operacion.tipopedd where abrev = 'CONFIGCP'; 
  delete operacion.tipopedd where abrev = 'INTERFASECP'; 
  delete operacion.tipopedd where abrev = 'TTRABCP'; 
 
 commit;
