CREATE OR REPLACE TRIGGER OPERACION.T_CONTRATAXAREA_AIUD
AFTER INSERT OR UPDATE OR DELETE on OPERACION.CONTRATAXAREA  
REFERENCING OLD AS OLD NEW AS NEW
for each row
/**************************************************************************
   NOMBRE:     T_CONTRATAXAREA_AIUD
   PROPOSITO:  Genera log de CONTRATAXAREA  

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        17/10/2014  Lady Curay      Se guardará el log de AREAOPE despues de insertar, actualizar o antes de borrar registro.
   **************************************************************************/

DECLARE
  nSecuencial NUMBER;
  l_action    VARCHAR2(1);
BEGIN
  SELECT HISTORICO.SQ_CONTRATAXAREA_LOG.NEXTVAL
    INTO nSecuencial
    FROM dummy_ope;

  IF INSERTING THEN
    l_action := 'I';
  
    INSERT INTO historico.CONTRATAXAREA_Log
      (codcon,
       area,
       codusu,
       fecusu,
       idlog,
       accion_log
      )
    VALUES
      (:NEW.CODCON,
       :NEW.AREA,
       :NEW.CODUSU,
       :NEW.FECUSU,
       nSecuencial,
       l_action
       );
  
  ELSIF UPDATING THEN
    l_action := 'U';
  INSERT INTO historico.CONTRATAXAREA_Log
      (codcon,
       area,
       codusu,
       fecusu,
       idlog,
       accion_log
      )
    VALUES
      (:NEW.CODCON,
       :NEW.AREA,
       :NEW.CODUSU,
       :NEW.FECUSU,
       nSecuencial,
       l_action
       );
  ELSIF DELETING THEN
    l_action := 'D';
    INSERT INTO historico.CONTRATAXAREA_Log
      (codcon,
       area,
       codusu,
       fecusu,
       idlog,
       accion_log
      )
    VALUES
      (:old.CODCON,
       :old.AREA,
       :old.CODUSU,
       :old.FECUSU,
       nSecuencial,
       l_action
       );
  END IF;
END;
/
