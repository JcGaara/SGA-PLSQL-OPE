CREATE OR REPLACE TRIGGER OPERACION.T_PREUBIETAMAT_BI
BEFORE INSERT
ON OPERACION.PREUBIETAMAT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.idmat is null then
      select SQ_PREUBIETAMAT.nextval into :new.idmat from dual;
   end if;

exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No hay tip de servicio');
END;
/



