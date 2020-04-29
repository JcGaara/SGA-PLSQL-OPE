CREATE OR REPLACE TRIGGER OPERACION.T_INT_TELEFONIA_LOG_BI
  BEFORE INSERT ON OPERACION.INT_TELEFONIA_LOG
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_INT_TELEFONIA_LOG_BI
  PROPOSITO:         
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        09/10/2013  Mauro Zegarra     Creacion de instancia de int_telefonia_log
  ***********************************************************************************************/
DECLARE
  l_id NUMBER;

BEGIN
  IF :NEW.id IS NULL THEN
    SELECT operacion.sq_int_telefonia_log.NEXTVAL INTO l_id FROM DUAL;
    :NEW.id := l_id;
  END IF;
END;
/
