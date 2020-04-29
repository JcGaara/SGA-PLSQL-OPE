CREATE OR REPLACE TRIGGER OPERACION.T_OT_BD
 BEFORE DELETE ON OT
FOR EACH ROW
DECLARE
fec_actual date;
BEGIN
   --Estado Anulado
   IF :OLD.ESTOT = 5 then
      raise_application_error(-20500, 'No se pudo modificar una OT que ya ha sido anulada.');
   END IF;
   -- Estado Ejecutado
   IF :OLD.ESTOT = 4 then
      raise_application_error(-20500, 'No se pudo modificar una OT que ya ha sido concluida.');
   END IF;
   delete docblob where docid = :old.docid;
   delete docesthis where docid = :old.docid;
   delete doc where docid = :old.docid;
END;
/



