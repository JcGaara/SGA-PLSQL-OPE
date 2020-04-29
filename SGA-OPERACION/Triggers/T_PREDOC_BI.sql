CREATE OR REPLACE TRIGGER OPERACION.T_PREDOC_BI
 BEFORE INSERT ON OPERACION.PREDOC
FOR EACH ROW
DECLARE
tmpVar NUMBER;

BEGIN
 if :new.iddoc is null then
    select nvl(max(iddoc),0) + 1 into :new.iddoc from predoc;
    --Select SQ_PREDOC.NextVal into :new.iddoc from dual;
   end if;

   if :new.codot is null then
    begin
       select ot.codot into :new.codot from ot, presupuesto p
         where p.codpre = :new.codpre and ot.codsolot = p.codsolot and ot.area = 11;
      exception
       when others then
          null;
      end;
   end if;
   if :new.coddoc is null then
    :new.coddoc := 1;
   end if;

END;
/



