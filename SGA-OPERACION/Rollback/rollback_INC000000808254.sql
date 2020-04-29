-- Drop registro 
DELETE 
  FROM OPERACION.CONSTANTE c
WHERE c.constante = 'MONEDA' AND c.descripcion ='GENERACION SOT';
 commit;