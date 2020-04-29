CREATE OR REPLACE TRIGGER operacion.t_ft_componente_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_componente
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_componente_aiud
    PROPOSITO : Genera log de sgacrm.ft_componente
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_componente_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_componente_log
      (idseq, idcomponente, descripcion, estado, idcab, acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDCOMPONENTE,
       :NEW.DESCRIPCION,
       :NEW.ESTADO,
       :NEW.IDCAB,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_componente_log
      (idseq, idcomponente, descripcion, estado, idcab, acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCOMPONENTE,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.IDCAB,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_componente_log
      (idseq, idcomponente, descripcion, estado, idcab, acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCOMPONENTE,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.IDCAB,
       'D');
  
  END IF;

END;
/
