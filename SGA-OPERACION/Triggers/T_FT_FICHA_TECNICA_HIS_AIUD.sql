CREATE OR REPLACE TRIGGER operacion.t_ft_ficha_tecnica_his_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_ficha_tecnica_his
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_ficha_tecnica_his_aiud
    PROPOSITO : Genera log de sgacrm.ft_ficha_tecnica_his
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_ficha_tecnica_his_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_ficha_tecnica_his_log
      (idseqlog,
       idseq,
       idficha,
       orden,
       observacion,
       fecha,
       columna,
       usuario,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDSEQ,
       :NEW.IDFICHA,
       :NEW.ORDEN,
       :NEW.OBSERVACION,
       :NEW.FECHA,
       :NEW.COLUMNA,
       :NEW.USUARIO,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_ficha_tecnica_his_log
      (idseqlog,
       idseq,
       idficha,
       orden,
       observacion,
       fecha,
       columna,
       usuario,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDSEQ,
       :OLD.IDFICHA,
       :OLD.ORDEN,
       :OLD.OBSERVACION,
       :OLD.FECHA,
       :OLD.COLUMNA,
       :OLD.USUARIO,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_ficha_tecnica_his_log
      (idseqlog,
       idseq,
       idficha,
       orden,
       observacion,
       fecha,
       columna,
       usuario,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDSEQ,
       :OLD.IDFICHA,
       :OLD.ORDEN,
       :OLD.OBSERVACION,
       :OLD.FECHA,
       :OLD.COLUMNA,
       :OLD.USUARIO,
       'D');
  
  END IF;

END;
/
