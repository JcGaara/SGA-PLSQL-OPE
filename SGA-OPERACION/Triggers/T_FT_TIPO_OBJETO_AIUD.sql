CREATE OR REPLACE TRIGGER operacion.t_ft_tipo_objeto_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_tipo_objeto
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_tipo_objeto_aiud
    PROPOSITO : Genera log de sgacrm.ft_tipo_objeto
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_tipo_objeto_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_tipo_objeto_log
      (idseq,
       idtipoobjeto,
       descripcion,
       flgedicion,
       estado,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDTIPOOBJETO,
       :NEW.DESCRIPCION,
       :NEW.FLGEDICION,
       :NEW.ESTADO,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_tipo_objeto_log
      (idseq,
       idtipoobjeto,
       descripcion,
       flgedicion,
       estado,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDTIPOOBJETO,
       :OLD.DESCRIPCION,
       :OLD.FLGEDICION,
       :OLD.ESTADO,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_tipo_objeto_log
      (idseq,
       idtipoobjeto,
       descripcion,
       flgedicion,
       estado,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDTIPOOBJETO,
       :OLD.DESCRIPCION,
       :OLD.FLGEDICION,
       :OLD.ESTADO,
       'D');
  
  END IF;

END;
/
