CREATE OR REPLACE TRIGGER OPERACION.T_TARJETA_DECO_ASOC_BI
BEFORE INSERT
ON OPERACION.TARJETA_DECO_ASOC
REFERENCING OLD AS OLD NEW AS  NEW
FOR EACH ROW

/*------------------------------------------------------------------------------------------
    TRIGGER: OPERACION.T_TABEQUIPO_MATERIAL_BI
    MODIFICATION HISTORY
    Person        Date          Comments
    ---------     ----------   --------------------------------------------------------------
    Mauro Zegarra 14/11/2011   Creacion
-------------------------------------------------------------------------------------------*/

declare

begin
  if :new.ID_ASOC is null then
     SELECT OPERACION.SQ_TARJETA_DECO_ASOC.NEXTVAL
            INTO :new.ID_ASOC
      FROM DUAL;
  end if;
end;
/
