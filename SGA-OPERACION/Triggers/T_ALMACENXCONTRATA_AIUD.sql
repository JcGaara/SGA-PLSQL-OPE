CREATE OR REPLACE TRIGGER operacion.t_almacenxcontrata_aiud
  AFTER INSERT OR UPDATE OR DELETE ON operacion.almacenxcontrata
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_almacenxcontrata_aiud
    PROPOSITO : Genera log de operacion.almacenxcontrata
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     12/11/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_almacenxcontrata_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.almacenxcontrata_log
      (idseq,
       tipo,
       codest,
       codpvc,
       codcon,
       centro,
       almacen,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.TIPO,
       :NEW.CODEST,
       :NEW.CODPVC,
       :NEW.CODCON,
       :NEW.CENTRO,
       :NEW.ALMACEN,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.almacenxcontrata_log
      (idseq,
       tipo,
       codest,
       codpvc,
       codcon,
       centro,
       almacen,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.TIPO,
       :OLD.CODEST,
       :OLD.CODPVC,
       :OLD.CODCON,
       :OLD.CENTRO,
       :OLD.ALMACEN,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.almacenxcontrata_log
      (idseq,
       tipo,
       codest,
       codpvc,
       codcon,
       centro,
       almacen,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.TIPO,
       :OLD.CODEST,
       :OLD.CODPVC,
       :OLD.CODCON,
       :OLD.CENTRO,
       :OLD.ALMACEN,
       'D');
  
  END IF;

END;
/
