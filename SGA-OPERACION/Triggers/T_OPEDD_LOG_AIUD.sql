CREATE OR REPLACE TRIGGER operacion.t_opedd_log_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.opedd
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_opedd_log_aiud
    PROPOSITO : Genera log de operacion.opedd
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/11/2019  Janpierre Benito      Creación de Trigger
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT historico.sq_opedd_log.NEXTVAL INTO n_secuencial FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.opedd_log
      (idseq,
       idopedd,
       codigoc,
       codigon,
       descripcion,
       abreviacion,
       tipopedd,
       codigon_aux,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDOPEDD,
       :NEW.CODIGOC,
       :NEW.CODIGON,
       :NEW.DESCRIPCION,
       :NEW.ABREVIACION,
       :NEW.TIPOPEDD,
       :NEW.CODIGON_AUX,
       'I');
  
  ELSIF UPDATING THEN
  
    INSERT INTO historico.opedd_log
      (idseq,
       idopedd,
       codigoc,
       codigon,
       descripcion,
       abreviacion,
       tipopedd,
       codigon_aux,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDOPEDD,
       :OLD.CODIGOC,
       :OLD.CODIGON,
       :OLD.DESCRIPCION,
       :OLD.ABREVIACION,
       :OLD.TIPOPEDD,
       :OLD.CODIGON_AUX,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.opedd_log
      (idseq,
       idopedd,
       codigoc,
       codigon,
       descripcion,
       abreviacion,
       tipopedd,
       codigon_aux,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDOPEDD,
       :OLD.CODIGOC,
       :OLD.CODIGON,
       :OLD.DESCRIPCION,
       :OLD.ABREVIACION,
       :OLD.TIPOPEDD,
       :OLD.CODIGON_AUX,
       'D');
  
  END IF;

END;
/
