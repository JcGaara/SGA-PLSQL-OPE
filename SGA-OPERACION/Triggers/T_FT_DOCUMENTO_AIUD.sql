CREATE OR REPLACE TRIGGER operacion.t_ft_documento_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_documento
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_documento_aiud
    PROPOSITO : Genera log de sgacrm.ft_documento
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_documento_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_documento_log
      (idseq,
       iddocumento,
       idtipodoc,
       descripcion,
       estado,
       flgaut,
       idtec,
       agrupa,
       cantidadagrupa,
       iddocumento_pad,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDDOCUMENTO,
       :NEW.IDTIPODOC,
       :NEW.DESCRIPCION,
       :NEW.ESTADO,
       :NEW.FLGAUT,
       :NEW.IDTEC,
       :NEW.AGRUPA,
       :NEW.CANTIDADAGRUPA,
       :NEW.IDDOCUMENTO_PAD,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_documento_log
      (idseq,
       iddocumento,
       idtipodoc,
       descripcion,
       estado,
       flgaut,
       idtec,
       agrupa,
       cantidadagrupa,
       iddocumento_pad,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDDOCUMENTO,
       :OLD.IDTIPODOC,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.FLGAUT,
       :OLD.IDTEC,
       :OLD.AGRUPA,
       :OLD.CANTIDADAGRUPA,
       :OLD.IDDOCUMENTO_PAD,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_documento_log
      (idseq,
       iddocumento,
       idtipodoc,
       descripcion,
       estado,
       flgaut,
       idtec,
       agrupa,
       cantidadagrupa,
       iddocumento_pad,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDDOCUMENTO,
       :OLD.IDTIPODOC,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.FLGAUT,
       :OLD.IDTEC,
       :OLD.AGRUPA,
       :OLD.CANTIDADAGRUPA,
       :OLD.IDDOCUMENTO_PAD,
       'D');
  
  END IF;

END;
/
