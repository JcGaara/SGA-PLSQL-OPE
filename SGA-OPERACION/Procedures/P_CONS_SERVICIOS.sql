CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_SERVICIOS(a_cod_id    in solot.cod_id%type,
                                                       o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN

  
  OPEN V_CURSOR FOR
    select distinct
                p.customer_id  AS customer_id,
                p.co_id,
                tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(p.co_id) tn,
                serv.desc_plan,
                serv.desc_serv,
                serv.status,
                serv.tipo_servicio,
                cu.billcycle -- SD-412773
    from CONTRACT_all@DBL_BSCS_BF p,
        CUSTOMER_ALL@DBL_BSCS_BF cu,-- SD-412773
       (select ssh.co_id,
               rp.des     desc_plan,
               ssh.sncode,
               sn.des     desc_serv,
               ssh.status,
               OPERACION.PQ_CONT_REGULARIZACION.f_val_tipo_servicio_bscs(ssh.sncode) Tipo_Servicio
          from pr_serv_status_hist@DBL_BSCS_BF ssh,
               mpusntab@DBL_BSCS_BF            sn,
               contract_all@DBL_BSCS_BF        ca,
               rateplan@DBL_BSCS_BF            rp,
               profile_service@dbl_bscs_bf     ps -- INC000000840907
        where ssh.sncode = sn.sncode
           and ssh.co_id = ca.co_id
           and ps.sncode = ssh.sncode			-- INC000000840907
           and ps.status_histno = ssh.histno	-- INC000000840907
           and ps.co_id = ca.co_id				-- INC000000840907
           and ca.tmcode = rp.tmcode
           and sn.sncode not in
               (select o.codigon  from tipopedd t, opedd o  
               where t.tipopedd =  o.tipopedd  and t.abrev = 'SNCODENOHFC_BSCS')) serv
    where p.co_id = serv.co_id
    and cu.customer_id = p.customer_id -- SD-412773
    and p.co_id = a_cod_id;

  o_resultado := V_CURSOR;
  END P_CONS_SERVICIOS;
/
