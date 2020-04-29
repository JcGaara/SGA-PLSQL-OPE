CREATE OR REPLACE TRIGGER operacion.t_ft_campo_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_campo
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_campo_aiud
    PROPOSITO : Genera log de sgacrm.ft_campo
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_campo_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_campo_log
      (idseq,
       idcampo,
       idlista,
       iddocumento,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       cantidad,
       idcomponente,
       cantidadpid,
       valorcampo,
       tipo,
       flgvisible,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDCAMPO,
       :NEW.IDLISTA,
       :NEW.IDDOCUMENTO,
       :NEW.ETIQUETA,
       :NEW.FLGNECESARIO,
       :NEW.ESTADO,
       :NEW.ORDEN,
       :NEW.TAREADEF,
       :NEW.CANTIDAD,
       :NEW.IDCOMPONENTE,
       :NEW.CANTIDADPID,
       :NEW.VALORCAMPO,
       :NEW.TIPO,
       :NEW.FLGVISIBLE,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_campo_log
      (idseq,
       idcampo,
       idlista,
       iddocumento,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       cantidad,
       idcomponente,
       cantidadpid,
       valorcampo,
       tipo,
       flgvisible,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCAMPO,
       :OLD.IDLISTA,
       :OLD.IDDOCUMENTO,
       :OLD.ETIQUETA,
       :OLD.FLGNECESARIO,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.TAREADEF,
       :OLD.CANTIDAD,
       :OLD.IDCOMPONENTE,
       :OLD.CANTIDADPID,
       :OLD.VALORCAMPO,
       :OLD.TIPO,
       :OLD.FLGVISIBLE,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_campo_log
      (idseq,
       idcampo,
       idlista,
       iddocumento,
       etiqueta,
       flgnecesario,
       estado,
       orden,
       tareadef,
       cantidad,
       idcomponente,
       cantidadpid,
       valorcampo,
       tipo,
       flgvisible,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDCAMPO,
       :OLD.IDLISTA,
       :OLD.IDDOCUMENTO,
       :OLD.ETIQUETA,
       :OLD.FLGNECESARIO,
       :OLD.ESTADO,
       :OLD.ORDEN,
       :OLD.TAREADEF,
       :OLD.CANTIDAD,
       :OLD.IDCOMPONENTE,
       :OLD.CANTIDADPID,
       :OLD.VALORCAMPO,
       :OLD.TIPO,
       :OLD.FLGVISIBLE,
       'D');
  
  END IF;

END;
/
