CREATE OR REPLACE TRIGGER OPERACION.T_OTCNTAVERIA_BI
  BEFORE INSERT
  on OTCNTAVERIA
  for each row
BEGIN
   if :new.idcntavr is null then
      Select nvl(max(idcntavr),0)+1
        into :new.idcntavr
        from OTCNTAVERIA
       where codot = :new.codot;
   end if;
END;
/



