CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_PROV_HIST_JANUS_SGA(an_codsolot in solot.codsolot%type,
                                                                 o_resultado out PQ_INTRAWAY.T_CURSOR) IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
BEGIN

  OPEN V_CURSOR FOR
    select  p.ord_id,
      p.ord_id_ant,
      p.action_id,
      to_char(p.customer_id),
      p.co_id,
      p.estado_prv,
      p.fecha_insert,
      p.valores,
      p.errmsg
  from tim.rp_prov_bscs_janus_hist@dbl_bscs_bf p
  where exists  (select 1 from solot s where s.codsolot = an_codsolot and s.cod_id = p.co_id)
  and trunc(p.fecha_insert) > trunc(sysdate - 10)
  union all
  select p.ord_id,
           p.ord_id_ant,
           p.action_id,
           p.customer_id,
           p.co_id,
           p.estado_prv,
           p.fecha_insert,
           p.valores,
           p.errmsg
      from tim.rp_prov_ctrl_janus@dbl_bscs_bf p
     where p.co_id in (select distinct pto.codinssrv
                         from solotpto pto, inssrv ins
                        where pto.codinssrv = ins.codinssrv
                          and ins.tipinssrv = 3
                          and pto.codsolot = an_codsolot)
       and p.estado_prv = 5
       and trunc(p.fecha_insert) > trunc(sysdate - 10)
   union all
   select  p.ord_id,
      p.ord_id_ant,
      p.action_id,
      to_char(p.customer_id),
      p.co_id,
      p.estado_prv,
      p.fecha_insert,
      p.valores,
      p.errmsg
  from tim.rp_prov_bscs_janus_hist@dbl_bscs_bf p
  where p.co_id in (select distinct pto.codinssrv
                         from solotpto pto, inssrv ins
                        where pto.codinssrv = ins.codinssrv
                          and ins.tipinssrv = 3
                          and pto.codsolot = an_codsolot)
  and trunc(p.fecha_insert) > trunc(sysdate - 10)
  union all
  select p.ord_id,
           p.ord_id_ant,
           p.action_id,
           p.customer_id,
           p.co_id,
           p.estado_prv,
           p.fecha_insert,
           p.valores,
           p.errmsg
      from tim.rp_prov_ctrl_janus@dbl_bscs_bf p
     where exists  (select 1 from solot s where s.codsolot = an_codsolot and s.cod_id = p.co_id)
       and p.estado_prv = 5
       and trunc(p.fecha_insert) > trunc(sysdate - 10);

  o_resultado := V_CURSOR;

END P_CONS_PROV_HIST_JANUS_SGA;
/
