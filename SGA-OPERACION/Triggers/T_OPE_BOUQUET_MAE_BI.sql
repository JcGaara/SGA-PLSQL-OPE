CREATE OR REPLACE TRIGGER OPERACION.t_OPE_BOUQUET_MAE_bi
  before insert on operacion.OPE_BOUQUET_MAE
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     22/03/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
  if :new.IDBOUQUET is null then
      select SQ_OPE_BOUQUET_MAE_IDBOUQUET.nextval
             into :new.IDBOUQUET
      from operacion.dummy_ope;
  end if;
end;
/



