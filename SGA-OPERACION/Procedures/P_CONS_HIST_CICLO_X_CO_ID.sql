CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_HIST_CICLO_X_CO_ID(a_cod_id    in solot.cod_id%type,
                                                                o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN

  OPEN V_CURSOR FOR

    select bh.customer_id   customer_id,
           bh.old_billcycle ciclo_ant,
           bh.new_billcycle ciclo_new,
           bh.csmoddate     fecha_mod
      from billcycle_hist@dbl_bscs_bf bh,
           CUSTOMER_ALL@dbl_bscs_bf   ca,
           CONTRACT_ALL@dbl_bscs_bf   CO
     where bh.customer_id = ca.customer_id
       and ca.customer_id = co.customer_id
       and co.co_id = a_cod_id;

  o_resultado := V_CURSOR;

END P_CONS_HIST_CICLO_X_CO_ID;
/
