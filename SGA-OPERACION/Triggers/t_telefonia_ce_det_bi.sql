CREATE OR REPLACE TRIGGER OPERACION.T_TELEFONIA_CE_DET_BI
  BEFORE INSERT ON OPERACION.TELEFONIA_CE_DET
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_TELEFONIA_CE_DET_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        26/06/2014  Eustaquio Gibaja    Creacion de instancia de telefonia_ce_det
  ***********************************************************************************************/
BEGIN
  IF :NEW.id_telefonia_ce_det IS NULL THEN
    SELECT operacion.sq_telefonia_ce_det.NEXTVAL INTO :NEW.id_telefonia_ce_det FROM DUAL;
  END IF;
END;
/
