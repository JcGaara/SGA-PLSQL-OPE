CREATE OR REPLACE TRIGGER operacion.t_tipopedd_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.tipopedd
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_tipopedd_aiud
    PROPOSITO : Genera log de operacion.tipopedd
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/11/2019  Janpierre Benito      Creación de Trigger
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT historico.sq_tipopedd_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.tipopedd_log
      (idseq, tipopedd, descripcion, abrev, acc_log)
    VALUES
      (n_secuencial, :NEW.TIPOPEDD, :NEW.DESCRIPCION, :NEW.ABREV, 'I');
  
  ELSIF UPDATING THEN
  
    INSERT INTO historico.tipopedd_log
      (idseq, tipopedd, descripcion, abrev, acc_log)
    VALUES
      (n_secuencial, :OLD.TIPOPEDD, :OLD.DESCRIPCION, :OLD.ABREV, 'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.tipopedd_log
      (idseq, tipopedd, descripcion, abrev, acc_log)
    VALUES
      (n_secuencial, :OLD.TIPOPEDD, :OLD.DESCRIPCION, :OLD.ABREV, 'D');
  
  END IF;

END;
/
