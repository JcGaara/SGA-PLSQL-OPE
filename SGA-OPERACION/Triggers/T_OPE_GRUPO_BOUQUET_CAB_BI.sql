CREATE OR REPLACE TRIGGER OPERACION."T_OPE_GRUPO_BOUQUET_CAB_BI"
 BEFORE INSERT ON operacion.OPE_GRUPO_BOUQUET_CAB
FOR EACH ROW

  /******************************************************************************************
       REVISIONS:
       Ver        Date        Author          Solicitado por         Description
       --------  ----------  --------------   --------------  ------------------------
         1.0     22/03/2010  Joseph Asencios  REQ-106641        Creación
         2.0     28/10/2010  Alex Alamo                         Modificacioon de asignacion de id RQ142944
  *******************************************************************************************/
DECLARE
BEGIN
-- 2.0 Modificacioon de asignacion de id
   if :new.IDGRUPO is null then
     select nvl(max(IDGRUPO),0) + 1 into :new.IDGRUPO from ope_grupo_bouquet_cab;
   end if;
END;
/



