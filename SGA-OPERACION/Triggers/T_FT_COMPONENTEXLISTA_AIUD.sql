CREATE OR REPLACE TRIGGER operacion.t_ft_componentexlista_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_componentexlista
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_componentexlista_aiud
    PROPOSITO : Genera log de sgacrm.ft_componentexlista
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_componentexlista_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_componentexlista_log
      (idseq,
       idcomponente,
       idlista,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDCOMPONENTE,
       :NEW.IDLISTA,
       :NEW.ETIQUETA,
       :NEW.FLGNECESARIO,
       :NEW.ESTADO,
       :NEW.ORDEN,
       :NEW.TAREADEF,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_componentexlista_log
      (idseq,
       idcomponente,
       idlista,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCOMPONENTE,
       :OLD.IDLISTA,
       :OLD.ETIQUETA,
       :OLD.FLGNECESARIO,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.TAREADEF,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_componentexlista_log
      (idseq,
       idcomponente,
       idlista,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCOMPONENTE,
       :OLD.IDLISTA,
       :OLD.ETIQUETA,
       :OLD.FLGNECESARIO,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.TAREADEF,
       'D');
  
  END IF;

END;
/
