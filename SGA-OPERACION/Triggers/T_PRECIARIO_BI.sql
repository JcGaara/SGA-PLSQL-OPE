CREATE OR REPLACE TRIGGER OPERACION.T_PRECIARIO_BI
BEFORE INSERT ON PRECIARIO
 FOR EACH ROW
DECLARE
 ln_codprec NUMBER(6);
/*********************************************************************************
23-09-2004    Carmen Quilca     inserta el codigo de la tabla preciario
*********************************************************************************/

BEGIN
   IF :NEW.codprec IS NULL THEN
      :NEW.codprec := F_Get_Clave_Preciario;
   END IF;
EXCEPTION
WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20500,'ERROR AL GENERAR EL CODIGO DEL PRECIARIO');
END;
/



