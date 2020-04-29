update atccorp.case_atention ca 
   set ca.description = 'VOLUMEN BAJO',
       ca.active = 0,
       ca.codincmotive = 0,
       ca.groupallocation = 0
where codcase = 731 ;
commit;
