CREATE OR REPLACE TRIGGER OPERACION.T_EFAUTOMATICO_AD
AFTER DELETE
ON EFAUTOMATICO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
   -- Se elimina los registro que tengan los idef eliminado.
   DELETE FROM EFAUTOXAREA WHERE IDEF = :OLD.ID;
END;
/


