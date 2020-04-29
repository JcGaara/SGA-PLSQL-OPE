CREATE OR REPLACE TRIGGER OPERACION.T_TELEFONIA_CE_DET_BU
  BEFORE UPDATE ON OPERACION.TELEFONIA_CE_DET
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
 /*********************************************************************************************
  NOMBRE:            OPERACION.T_TELEFONIA_CE_DET_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        30/06/2014  César Quispe    Creacion de instancia de telefonia_ce_det
  ***********************************************************************************************/

BEGIN
  SELECT SYSDATE, USER INTO :NEW.FECMOD, :NEW.USUMOD FROM DUAL;
END;
/
