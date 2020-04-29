CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_PROV_JANUS(a_cod_id    in solot.cod_id%type,
                                               o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN

  OPEN V_CURSOR FOR
    select  p.ord_id,
      p.ord_id_ant,
      p.action_id,
      p.customer_id,
      p.co_id,
      p.estado_prv,
      p.fecha_insert,
      p.valores,
      p.errmsg
  from tim.rp_prov_bscs_janus@dbl_bscs_bf p
  where p.co_id = a_cod_id;

  o_resultado := V_CURSOR;
  END P_CONS_PROV_JANUS;
/
