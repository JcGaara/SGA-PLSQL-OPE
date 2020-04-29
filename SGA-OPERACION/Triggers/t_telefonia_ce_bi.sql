CREATE OR REPLACE TRIGGER OPERACION.T_TELEFONIA_CE_BI
  BEFORE INSERT ON OPERACION.TELEFONIA_CE
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_TELEFONIA_CE_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        26/06/2014  Eustaquio Gibaja    Creacion de instancia de telefonia_ce
  ***********************************************************************************************/
BEGIN
  IF :NEW.id_telefonia_ce IS NULL THEN
    SELECT operacion.sq_telefonia_ce.NEXTVAL INTO :NEW.id_telefonia_ce FROM DUAL;
  END IF;
END;
/
