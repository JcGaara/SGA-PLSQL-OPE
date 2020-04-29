CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SRV_REGINST_SISACT_BI
BEFORE INSERT
ON OPERACION.OPE_SRV_REGINST_SISACT
REFERENCING OLD AS OLD NEW AS  NEW
FOR EACH ROW

/*------------------------------------------------------------------------------------------
    TRIGGER: OPERACION.T_TABEQUIPO_MATERIAL_BI
    MODIFICATION HISTORY
    Person        Date          Comments
    ---------     ----------   --------------------------------------------------------------
    Cristiam Vega 12/11/2012   Creacion
-------------------------------------------------------------------------------------------*/

declare

begin
  if :new.ID_SISACT is null then
     SELECT OPERACION.SQ_OPE_SRV_REGINST_SISACT.NEXTVAL
            INTO :new.ID_SISACT
      FROM DUAL;
  end if;
end;
/
