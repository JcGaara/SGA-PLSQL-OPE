CREATE OR REPLACE TRIGGER operacion.t_ft_lista_aiud
  AFTER INSERT OR UPDATE OR DELETE ON sgacrm.ft_lista
  FOR EACH ROW

  /***************************************************************************
    NOMBRE    : t_ft_lista_aiud
    PROPOSITO : Genera log de sgacrm.ft_lista
    
    REVISIONES:
    Ver.    Fecha       Autor                 Descripción 
    ------  ----------  --------------------  ------------------------------
    1.0     25/10/2019  Janpierre Benito      Creación de Trigger
	2.0     22/11/2019  Janpierre Benito      Guardar el valor :OLD al actualizar
  ***************************************************************************/

DECLARE
  n_secuencial NUMBER;
BEGIN

  SELECT operacion.sq_ft_lista_log.NEXTVAL
    INTO n_secuencial
    FROM dummy_ope;

  IF INSERTING THEN
  
    INSERT INTO historico.ft_lista_log
      (idseq,
       idlista,
       idtipoobjeto,
       descripcion,
       estado,
       idlistap,
       idseleccion,
       query,
       actualizar,
       filtro,
       editar,
       acc_log)
    VALUES
      (n_secuencial,
       :NEW.IDLISTA,
       :NEW.IDTIPOOBJETO,
       :NEW.DESCRIPCION,
       :NEW.ESTADO,
       :NEW.IDLISTAP,
       :NEW.IDSELECCION,
       :NEW.QUERY,
       :NEW.ACTUALIZAR,
       :NEW.FILTRO,
       :NEW.EDITAR,
       'I');
  
  ELSIF UPDATING THEN -- 2.0
  
    INSERT INTO historico.ft_lista_log
      (idseq,
       idlista,
       idtipoobjeto,
       descripcion,
       estado,
       idlistap,
       idseleccion,
       query,
       actualizar,
       filtro,
       editar,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDLISTA,
       :OLD.IDTIPOOBJETO,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.IDLISTAP,
       :OLD.IDSELECCION,
       :OLD.QUERY,
       :OLD.ACTUALIZAR,
       :OLD.FILTRO,
       :OLD.EDITAR,
       'U');
  
  ELSIF DELETING THEN
  
    INSERT INTO historico.ft_lista_log
      (idseq,
       idlista,
       idtipoobjeto,
       descripcion,
       estado,
       idlistap,
       idseleccion,
       query,
       actualizar,
       filtro,
       editar,
       acc_log)
    VALUES
      (n_secuencial,
       :OLD.IDLISTA,
       :OLD.IDTIPOOBJETO,
       :OLD.DESCRIPCION,
       :OLD.ESTADO,
       :OLD.IDLISTAP,
       :OLD.IDSELECCION,
       :OLD.QUERY,
       :OLD.ACTUALIZAR,
       :OLD.FILTRO,
       :OLD.EDITAR,
       'D');
  
  END IF;

END;
/
