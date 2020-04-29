CREATE OR REPLACE TRIGGER OPERACION.MATOPE_BU
  BEFORE UPDATE ON OPERACION.MATOPE
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

  /*****************************************************************************************************************
   NAME:       MATOPE_BU
   REVISIONS:
   Ver        Date        Author                             Description
   ---------  ----------  ---------------                   ------------------------------------
   1.0        25/02/2014  Ricardo Crisostomo Quisiverde     RQM 164859 IDEA-12941 Precios Materiales SGAOperaciones
  ******************************************************************************************************************/
DECLARE

BEGIN

  IF UPDATING('COSTO') THEN
    IF :new.COSTO = 0 THEN
    
      :new.COSTO := :OLD.COSTO;
    END IF;
  END IF;
END;
/
