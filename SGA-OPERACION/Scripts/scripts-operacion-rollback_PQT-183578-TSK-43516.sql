  
alter table operacion.estsol
drop column  tipestoac;
 

BEGIN


delete opedd where ABREVIACION = 'MAXTEA';
delete tipopedd where ABREV= 'MAXTEA'  ;

COMMIT;
   
END; 
