CREATE OR REPLACE TRIGGER operacion.t_ft_condicion_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_condicion
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_condicion_aiud
    PROPOSITO : Genera log de sgacrm.ft_condicion
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_condicion_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_condicion_log
      (idseq,
       idcondicion,
       iddocumento,
       idparametro,
       valor,
       descripcion,
       flg_todo,
       estado,
       acc_log)
    VALUES
      (n_secuencial, 
      :NEW.IDCONDICION, 
      :NEW.IDDOCUMENTO,
      :NEW.IDPARAMETRO, 
      :NEW.VALOR,
      :NEW.DESCRIPCION,
      :NEW.FLG_TODO,
      :NEW.ESTADO,
      'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_condicion_log
      (idseq,
       idcondicion,
       iddocumento,
       idparametro,
       valor,
       descripcion,
       flg_todo,
       estado,
       acc_log)
    VALUES
      (n_secuencial, 
      :OLD.IDCONDICION, 
      :OLD.IDDOCUMENTO,
      :OLD.IDPARAMETRO, 
      :OLD.VALOR,
      :OLD.DESCRIPCION,
      :OLD.FLG_TODO,
      :OLD.ESTADO,
      'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_condicion_log
      (idseq,
       idcondicion,
       iddocumento,
       idparametro,
       valor,
       descripcion,
       flg_todo,
       estado,
       acc_log)
    VALUES
      (n_secuencial, 
      :OLD.IDCONDICION, 
      :OLD.IDDOCUMENTO,
      :OLD.IDPARAMETRO, 
      :OLD.VALOR,
      :OLD.DESCRIPCION,
      :OLD.FLG_TODO,
      :OLD.ESTADO,
      'D');
  
  END IF;

END;
/
