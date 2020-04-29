CREATE OR REPLACE TRIGGER OPERACION.T_INT_PARAMETRO_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.INT_PARAMETRO REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_INT_PARAMETRO_AIUD
   PROPOSITO:  Genera log
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/09/2013  Edilberto Astulle Creacion
   **************************************************************************/
DECLARE
nSecuencial number;
BEGIN
  SELECT SQ_AGENDAMIENTO_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO historico.INT_PARAMETRO_log
     (accion,ID_INTERFACE,ID_PARAMETRO,ID_VALOR)
     VALUES
     ('I',:new.ID_INTERFACE,:new.ID_PARAMETRO,:new.ID_VALOR);
  ELSIF UPDATING THEN
     INSERT INTO historico.INT_PARAMETRO_log
     (accion,ID_INTERFACE,ID_PARAMETRO,ID_VALOR)
     VALUES
     ('U',:old.ID_INTERFACE,:old.ID_PARAMETRO,:old.ID_VALOR);
  ELSIF DELETING THEN
     INSERT INTO historico.INT_PARAMETRO_log
     (accion,ID_INTERFACE,ID_PARAMETRO,ID_VALOR)
     VALUES
     ('D',:old.ID_INTERFACE,:old.ID_PARAMETRO,:old.ID_VALOR);
  END IF;
END;
/