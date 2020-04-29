CREATE OR REPLACE TRIGGER operacion.t_ft_campoxtareadef_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_campoxtareadef
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_campoxtareadef_aiud
    PROPOSITO : Genera log de sgacrm.ft_campoxtareadef
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_campoxtareadef_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_campoxtareadef_log
      (idseq, idcampo, tareadef, acc_log)
    VALUES
      (n_secuencial, :NEW.IDCAMPO, :NEW.TAREADEF, 'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_campoxtareadef_log
      (idseq, idcampo, tareadef, acc_log)
    VALUES
      (n_secuencial, :OLD.IDCAMPO, :OLD.TAREADEF, 'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_campoxtareadef_log
      (idseq, idcampo, tareadef, acc_log)
    VALUES
      (n_secuencial, :OLD.IDCAMPO, :OLD.TAREADEF, 'D');
  
  END IF;

END;
/
