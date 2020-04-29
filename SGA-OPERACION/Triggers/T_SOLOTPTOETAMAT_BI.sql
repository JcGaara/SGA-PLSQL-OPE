CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOETAMAT_BI
BEFORE INSERT
ON OPERACION.SOLOTPTOETAMAT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /************************************************************
  Versión   Fecha      Autor              Descripción
  --------- ---------- ---------------    -----------------------
  1.0       08/05/2009  Hector Huaman M.  Se comenzo a utilizar la secuencia SEQ_SOLOTPTOETAMAT
  ***********************************************************/
BEGIN
   if :new.idmat is null then
      select SEQ_SOLOTPTOETAMAT.nextval into   :new.idmat  from   dual;
      --select nvl(max(idmat),0) + 1 into :new.idmat from solotptoetamat;--<1.0>
   end if;

exception
when others then
  RAISE_APPLICATION_ERROR(-20500,'No se ha creado el codigo de la tabla');
END;
/



