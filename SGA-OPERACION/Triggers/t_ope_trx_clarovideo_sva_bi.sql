create or replace trigger operacion.t_ope_trx_clarovideo_sva_bi
  before insert on operacion.ope_trx_clarovideo_sva
  referencing old as old new as new
  for each row
/*********************************************************************************************************************************
    NOMBRE:               t_ope_trx_clarovideo_sva_bi
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        16/05/2014  César Quispe      Hector Huaman     REQ-165004 Creación Interface de compra servicios SVA
  ***********************************************************************************************************************************/
declare
  ln_idregistro number(8);
begin
  if :new.idregistro is null then
    select max(idregistro)
      into ln_idregistro
      from operacion.ope_trx_clarovideo_sva;

    if ln_idregistro is null then
      ln_idregistro := 0;
    end if;
    :new.idregistro := ln_idregistro + 1;
  end if;
end;
/