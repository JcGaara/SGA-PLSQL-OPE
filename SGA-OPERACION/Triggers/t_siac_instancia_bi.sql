CREATE OR REPLACE TRIGGER OPERACION.T_SIAC_INSTANCIA_BI 
BEFORE INSERT
ON OPERACION.SIAC_INSTANCIA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

  /*********************************************************************************************
  NOMBRE:            OPERACION.SIAC_INSTANCIA
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        09/10/2013  Eustaquio Gibaja     Creacion de instancia de SIAC
  ***********************************************************************************************/

DECLARE
  num_id NUMBER(27);

BEGIN
  IF :new.IDINSTANCIA IS NULL THEN
    SELECT OPERACION.SQ_SIAC_INSTANCIA.nextval INTO num_id FROM dual;

    :new.IDINSTANCIA := num_id;
  END IF;
END;
/