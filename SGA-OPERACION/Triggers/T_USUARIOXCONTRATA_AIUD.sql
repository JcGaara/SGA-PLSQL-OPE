CREATE OR REPLACE TRIGGER OPERACION.T_USUARIOXCONTRATA_AIUD
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.USUARIOXCONTRATA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/**************************************************************************
   NOMBRE:     T_ACCUSUDPT_AIUD
   PROPOSITO:  Genera log de USUARIOXCONTRATA

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        17/10/14    Lady Curay     Se guardará el log de USUARIOXCONTRATA despues de insertar, actualizar o borrar registro.
   **************************************************************************/

DECLARE
  nSecuencial NUMBER;
  l_action    VARCHAR2(1);
BEGIN
  SELECT HISTORICO.SQ_USUARIOXCONTRATA_LOG.NEXTVAL
    INTO nSecuencial
    FROM dummy_ope;

  IF INSERTING THEN
    l_action := 'I';
  
    INSERT INTO HISTORICO.USUARIOXCONTRATA_LOG
      (USUARIO, CODCON, CODUSU, IDLOG, ACCION_LOG)
    VALUES
      (:new.Usuario, :New.Codcon, :new.Codusu, nSecuencial, l_action);
  
  ELSIF UPDATING THEN
    l_action := 'U';
    INSERT INTO HISTORICO.USUARIOXCONTRATA_LOG
      (USUARIO, CODCON, CODUSU, IDLOG, ACCION_LOG)
    VALUES
      (:NEW.USUARIO, :New.Codcon, :new.Codusu, nSecuencial, l_action);
  
  ELSIF DELETING THEN
    l_action := 'D';
    INSERT INTO HISTORICO.USUARIOXCONTRATA_LOG
      (USUARIO, CODCON, CODUSU, IDLOG, ACCION_LOG)
    VALUES
      (:old.Usuario, :old.Codcon, :old.Codusu, nSecuencial, l_action);
  
  END IF;
END;
/
