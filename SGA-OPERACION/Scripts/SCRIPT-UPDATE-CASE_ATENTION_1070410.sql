update atccorp.case_atention ca 
   set ca.description = 'RECIBO POR ENVIO FISICO',
       ca.active = 1,
       ca.codincmotive = 2,
       ca.groupallocation = 1
where codcase = 731 ;
commit;
