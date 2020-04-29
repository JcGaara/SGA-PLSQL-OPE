create or replace procedure OPERACION.P_CONT_EST(a_cod_id    in solot.cod_id%type,
                                                 o_resultado out PQ_INTRAWAY.T_CURSOR) is
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
begin
  open V_CURSOR for
    select co_id,
           ch_status,
           ch_pending,
           ch_validfrom
      from contract_history@DBL_BSCS_BF
     where co_id in (a_cod_id)
     order by ch_seqno asc;

  o_resultado := V_CURSOR;
end P_CONT_EST;
/