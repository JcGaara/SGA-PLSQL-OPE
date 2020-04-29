CREATE OR REPLACE TRIGGER OPERACION.T_OPE_INSPRD_LOG_BU
BEFORE UPDATE
ON OPERACION.OPE_INSPRD_LOG
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
  /*********************************************************************************************
  NOMBRE:            OPERACION.T_OPE_INSPRD_LOG_BU
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        07/07/2010  Alexander Yong   Creacion --Rq. 134083
  ***********************************************************************************************/
DECLARE

BEGIN
  :NEW.USUMOD := USER;
  :NEW.FECMOD := SYSDATE;
END;
/



