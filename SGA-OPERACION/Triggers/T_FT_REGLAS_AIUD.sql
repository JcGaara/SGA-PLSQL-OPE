CREATE OR REPLACE TRIGGER operacion.t_ft_reglas_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_reglas
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_reglas_aiud
    PROPOSITO : Genera log de sgacrm.ft_reglas
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_reglas_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_reglas_log
      (idseq,
       idregla,
       idtabla,
       idcampo,
       codigo,
       descripcion,
       estado,
       acc_log)
    VALUES
      (n_secuencial,
      :NEW.IDREGLA,
      :NEW.IDTABLA,
      :NEW.IDCAMPO,
      :NEW.CODIGO,
      :NEW.DESCRIPCION,
      :NEW.ESTADO,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_reglas_log
      (idseq,
       idregla,
       idtabla,
       idcampo,
       codigo,
       descripcion,
       estado,
       acc_log)
    VALUES
      (n_secuencial,
      :OLD.IDREGLA,
      :OLD.IDTABLA,
      :OLD.IDCAMPO,
      :OLD.CODIGO,
      :OLD.DESCRIPCION,
      :OLD.ESTADO,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_reglas_log
      (idseq,
       idregla,
       idtabla,
       idcampo,
       codigo,
       descripcion,
       estado,
       acc_log)
    VALUES
      (n_secuencial, 
      :OLD.IDREGLA,
      :OLD.IDTABLA,
      :OLD.IDCAMPO,
      :OLD.CODIGO,
      :OLD.DESCRIPCION,
      :OLD.ESTADO,
      'D');
  
  END IF;

END;
/
