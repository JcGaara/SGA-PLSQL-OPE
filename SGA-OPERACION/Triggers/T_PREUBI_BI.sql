CREATE OR REPLACE TRIGGER OPERACION.T_PREUBI_BI
BEFORE INSERT
ON OPERACION.PREUBI
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.idubi is null then
      select SQ_PREUBI.nextval into :new.idubi from dual;
   end if;

   if :new.codsolot is null then
   	select codsolot into :new.codsolot from presupuesto where codpre = :new.codpre;
   end if;


exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No hay tip de servicio');
END;
/



