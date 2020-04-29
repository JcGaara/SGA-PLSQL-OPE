CREATE OR REPLACE TRIGGER OPERACION.T_solotptodoc_AD 
AFTER DELETE ON operacion.solotptodoc
FOR EACH ROW
DECLARE
BEGIN
  IF :OLD.tipdoc = 7 then
    raise_application_error(-20500,'No esta permitido eliminar este tipo de Archivos, solo esta permitido adicionar.');
  END IF;
END T_solotptodoc_AD;
/