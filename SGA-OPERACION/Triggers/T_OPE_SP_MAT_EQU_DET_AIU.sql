create or replace trigger OPERACION.t_ope_sp_mat_equ_det_AIU
after insert or update on OPERACION.ope_sp_mat_equ_det
  referencing old as old new as new
  for each row
/************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       16/09/2011  Tommy Arakaki   REQ 159960 - Requisicion Materiels y Equipos
  ***********************************************************/
declare
o_mensaje2 varchar2(150);
o_resultado2 number;
vv_valor  varchar2(1);
ll_count number;
begin

    vv_valor := null;
    if inserting then
      operacion.pq_solicitud_pedido.p_inserta_sol_ped_det_imp(:new.IDSPDET,:new.IDSPCAB ,
                                  vv_valor  ,
                                  vv_valor ,
                                  vv_valor,
                                  vv_valor,
                                  vv_valor,
                                  vv_valor,
                                  vv_valor ,
                                  o_mensaje2,
                                  o_resultado2);
    elsif updating then

      select count(*) into ll_count
      from ope_sp_mat_equ_det_imp
      where IDSPCAB = :old.IDSPCAB and
            idspdet = :old.idspdet;

      if ll_count = 0 then
          operacion.pq_solicitud_pedido.p_inserta_sol_ped_det_imp(:old.IDSPDET,
                                  :old.IDSPCAB ,
                                  vv_valor  ,
                                  vv_valor ,
                                 vv_valor,
                                  vv_valor,
                                  vv_valor,
                                  vv_valor,
                                  vv_valor ,
                                  o_mensaje2,
                                  o_resultado2);

      end if;

    end if;



end;
/
