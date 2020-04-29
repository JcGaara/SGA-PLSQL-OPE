CREATE OR REPLACE TRIGGER OPERACION.T_INT_PRYOPE_BI  
 BEFORE INSERT ON INT_PRYOPE  
FOR EACH ROW
BEGIN  
   if :new.idseq is null then  
      Select SQ_ID_INT_PRYOPE.NextVal into :new.idseq from dual;  
   end if;  
END;
/



