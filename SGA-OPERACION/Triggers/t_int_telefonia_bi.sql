CREATE OR REPLACE TRIGGER OPERACION.T_INT_TELEFONIA_BI
  BEFORE INSERT ON OPERACION.INT_TELEFONIA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_INT_TELEFONIA_BI
  PROPOSITO:         
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        09/10/2013  Mauro Zegarra     Creacion de instancia de int_telefonia
  ***********************************************************************************************/
BEGIN
  IF :NEW.id IS NULL THEN
    SELECT operacion.sq_int_telefonia.NEXTVAL INTO :NEW.id FROM DUAL;
  END IF;
END;
/
