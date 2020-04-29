CREATE OR REPLACE TRIGGER OPERACION.t_trssolot_bu
   BEFORE UPDATE
   ON trssolot
   FOR EACH ROW
DECLARE
   l_tipcon   CHAR (2);
BEGIN
   IF :OLD.esttrs IN (3) THEN
      raise_application_error (-20500, 'No se puede modificar una transaccion anulada');
   END IF;

   -- Ejecutado o anulado
   IF UPDATING ('ESTTRS') AND :OLD.esttrs <> :NEW.esttrs AND :NEW.esttrs IN (2, 3) THEN
      :NEW.feceje := SYSDATE;
      :NEW.codusueje := USER;

      IF :NEW.fectrs IS NULL THEN
         :NEW.fectrs := :NEW.feceje;
      END IF;
   END IF;

   IF :NEW.esttrs = 1 THEN
      :NEW.fectrs := NULL;
      :NEW.codusueje := NULL;
      :NEW.feceje := NULL;
   END IF;
END;
/



