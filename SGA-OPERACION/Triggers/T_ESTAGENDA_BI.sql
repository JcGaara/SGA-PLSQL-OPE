CREATE OR REPLACE TRIGGER OPERACION.T_ESTAGENDA_BI
  BEFORE INSERT ON OPERACION.ESTAGENDA
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************
  NOMBRE:            OPERACION.T_ESTAGENDA_BI
  PROPOSITO:
  REVISIONES:
  Ver        Fecha        Autor           Descripcion
  ---------  ----------  ---------------  -----------------------------------
  1.0        13/02/2012  Keila Carpio     Creacion REQ 161607  Agendamiento para Mantenimiento e Instalaciones de proveedores
  ****************************************************************************************************************************/

DECLARE
BEGIN
  IF :NEW.ESTAGE IS NULL OR :NEW.ESTAGE = 0 THEN
	select max(ESTAGE)+1
      	into :NEW.ESTAGE
      	from OPERACION.ESTAGENDA;
  END IF;
END;
/

