CREATE OR REPLACE TRIGGER OPERACION.T_TRSINSSRV_BD
 BEFORE DELETE ON TRSINSSRV
FOR EACH ROW
BEGIN
   raise_application_error(-20500,'No se puede eliminar una transaccion');
END;
/



