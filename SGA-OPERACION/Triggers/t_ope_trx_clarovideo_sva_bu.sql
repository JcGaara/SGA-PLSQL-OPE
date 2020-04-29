create or replace trigger operacion.t_ope_trx_clarovideo_sva_bu
  before update on operacion.ope_trx_clarovideo_sva
  referencing old as old new as new
  for each row
/*********************************************************************************************************************************
    NOMBRE:               t_ope_trx_clarovideo_sva_bu
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        24/03/2014  César Quispe      Hector Huaman     REQ-165004 Creación de Interface de compra de servicios SVA
  ***********************************************************************************************************************************/

begin
  :new.fecmod := sysdate;
  :new.usumod := user;
end;
/