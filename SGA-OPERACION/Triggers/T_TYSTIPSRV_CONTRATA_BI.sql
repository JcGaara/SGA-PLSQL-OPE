CREATE OR REPLACE TRIGGER OPERACION.T_TYSTIPSRV_CONTRATA_BI
BEFORE INSERT
ON OPERACION.TYSTIPSRV_CONTRATA REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
BEGIN
   if :new.idtc is null then
      select nvl(max(idtc),0) + 1 into :new.idtc  from TYSTIPSRV_CONTRATA;
   end if;
END;
/


