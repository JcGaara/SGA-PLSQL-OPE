CREATE OR REPLACE TRIGGER OPERACION.T_TABEQUIPO_MATERIAL_BI
BEFORE INSERT
ON OPERACION.TABEQUIPO_MATERIAL
REFERENCING OLD AS OLD NEW AS  NEW
FOR EACH ROW

/*------------------------------------------------------------------------------------------
    TRIGGER: OPERACION.T_TABEQUIPO_MATERIAL_BI
    MODIFICATION HISTORY
    Person        Date          Comments
    ---------     ----------   --------------------------------------------------------------
    Mauro Zegarra 31/10/2011   Creacion
-------------------------------------------------------------------------------------------*/

declare

begin
  if :new.IDEQUIPO is null then
	   SELECT OPERACION.SQ_TABEQUIPO_MATERIAL.NEXTVAL
            INTO :new.IDEQUIPO
      FROM DUAL;
  end if;
end;
/
