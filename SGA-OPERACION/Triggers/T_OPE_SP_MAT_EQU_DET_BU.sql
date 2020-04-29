create or replace trigger operacion.t_ope_sp_mat_equ_det_bu
/*********************************************************************************************************************************
    NOMBRE:               t_ope_sp_mat_equ_det_bu
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        15/09/2011  Tommy Arakaki     Edilberto Astulle  REQ 159960
  ***********************************************************************************************************************************/
  before update on OPERACION.OPE_SP_MAT_EQU_DET
  referencing old as old new as new
  for each row
declare
begin
  :new.usumod := user;
  :new.fecmod := sysdate;
end;
/
