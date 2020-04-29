CREATE OR REPLACE TRIGGER OPERACION.t_OPE_LISTA_FILTROS_TMP_bi
  before insert on operacion.OPE_LISTA_FILTROS_TMP
  referencing old as old new as new
  for each row
/********************************************************************************************
     Ver     Fecha          Autor                Solicitado por          Descripcion
    ------  ----------  --------------------    ---------------    ------------------------
     1.0     27/04/2010  Joseph Asencios         REQ-106641        Creación
 ********************************************************************************************/
declare
begin
  if :new.IDVALOR is null then
      select SQ_OPE_LISTA_FILTROS_TMP.nextval
             into :new.IDVALOR
      from operacion.dummy_ope;
  end if;
end;
/



