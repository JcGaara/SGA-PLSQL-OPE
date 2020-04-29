CREATE OR REPLACE TRIGGER operacion.t_ft_valor_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_valor
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_valor_aiud
    PROPOSITO : Genera log de sgacrm.ft_valor
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_valor_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_valor_log
      (idseq,
       idvalor,
       idlista,
       valor,
       flgdef,
       estado,
       orden,
       valorp,
       idlistap,
       idvalorp,
       idint,
       idintp,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDVALOR,
       :NEW.IDLISTA,
       :NEW.VALOR,
       :NEW.FLGDEF,
       :NEW.ESTADO,
       :NEW.ORDEN,
       :NEW.VALORP,
       :NEW.IDLISTAP,
       :NEW.IDVALORP,
       :NEW.IDINT,
       :NEW.IDINTP,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_valor_log
      (idseq,
       idvalor,
       idlista,
       valor,
       flgdef,
       estado,
       orden,
       valorp,
       idlistap,
       idvalorp,
       idint,
       idintp,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDVALOR,
       :OLD.IDLISTA,
       :OLD.VALOR,
       :OLD.FLGDEF,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.VALORP,
       :OLD.IDLISTAP,
       :OLD.IDVALORP,
       :OLD.IDINT,
       :OLD.IDINTP,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_valor_log
      (idseq,
       idvalor,
       idlista,
       valor,
       flgdef,
       estado,
       orden,
       valorp,
       idlistap,
       idvalorp,
       idint,
       idintp,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDVALOR,
       :OLD.IDLISTA,
       :OLD.VALOR,
       :OLD.FLGDEF,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.VALORP,
       :OLD.IDLISTAP,
       :OLD.IDVALORP,
       :OLD.IDINT,
       :OLD.IDINTP,
       'D');
  
  END IF;

END;
/
