CREATE OR REPLACE TRIGGER OPERACION.T_MATOPE_BI
 BEFORE INSERT ON OPERACION.MATOPE
FOR EACH ROW
DECLARE
--ini 2.0
--tmpVar NUMBER;
--fin 2.0
/******************************************************************************
NAME:       T_MATOPE_BI
PURPOSE:    Copia el codigo del Oracle

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        12/10/2004
2.0        26/10/2010  Antonio Lagos    Req.146363, replicar equipos de almtabmat
                                        hacia tipequ y matope
******************************************************************************/
BEGIN
   --ini 2.0
   if :NEW.CAMPO1 is null then
   --fin 2.0
     SELECT  TRIM(ITEM_SEGMENT1)||'.'||TRIM(ITEM_SEGMENT2)||'.'||TRIM(ITEM_SEGMENT3)
     INTO :NEW.CAMPO1
     FROM ALMTABMAT WHERE TRIM(CODMAT) = TRIM(:NEW.codmat);
   --ini 2.0
   end if;
   --fin 2.0
END T_MATOPE_BI;
/



