CREATE OR REPLACE TRIGGER operacion.t_ft_seldatos_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_seldatos
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_seldatos_aiud
    PROPOSITO : Genera log de sgacrm.ft_seldatos
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripci�n 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creaci�n de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_seldatos_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_seldatos_log
      (idseq, idseleccion, tabla, estado, acc_log)
    VALUES
      (n_secuencial, :NEW.IDSELECCION, :NEW.TABLA, :NEW.ESTADO, 'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_seldatos_log
      (idseq, idseleccion, tabla, estado, acc_log)
    VALUES
      (n_secuencial, :OLD.IDSELECCION, :OLD.TABLA, :OLD.ESTADO, 'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_seldatos_log
      (idseq, idseleccion, tabla, estado, acc_log)
    VALUES
      (n_secuencial, :OLD.IDSELECCION, :OLD.TABLA, :OLD.ESTADO, 'D');
  
  END IF;

END;
/
