create or replace procedure OPERACION.P_CONS_LINEA_JANUS_REG(an_codsolot in solot.codsolot%type,
                                                             o_resultado out PQ_INTRAWAY.T_CURSOR) is
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  l_count  number;
begin

  select count(1)
    into l_count
    from solot    s,
         solotpto pto,
         inssrv   ins
   where s.codsolot = pto.codsolot
     and pto.codinssrv = ins.codinssrv
     and ins.tipinssrv = 3
     and ins.numero is not null
     and s.codsolot = an_codsolot;

  if l_count > 0 then
    open V_CURSOR for
      select substr(c.connection_id_v, 5, 8) numero,
             pc.external_payer_id_v customer_id,
             pt.tariff_id_n codplan,
             tm.description_v producto,
             tm.tariff_type_v tipoplan,
             pt.start_date_dt fecini,
             p.payer_status_n flg_estado,
             decode(p.payer_status_n, '1', 'Registrado', '2', 'Activo', '3',
                    'Activo s/recargas', '4', 'Suspendido', '5', 'Terminado',
                    '???') estado,
             substr(pb.bill_cycle_n, 2, 2) ciclo
        from janus_prod_pe.connections@DBL_JANUS c,
             janus_prod_pe.connection_accounts@DBL_JANUS ca,
             janus_prod_pe.payer_tariffs@DBL_JANUS pt,
             janus_prod_pe.tariff_master@DBL_JANUS tm,
             janus_prod_pe.payers@DBL_JANUS p,
             janus_prod_pe.payers@DBL_JANUS pc,
             janus_prod_pe.payer_bill_cycle_details@DBL_JANUS pb,
             (select distinct '0051' || ins.numero numero
                from solot    s,
                     solotpto pto,
                     inssrv   ins
               where s.codsolot = pto.codsolot
                 and pto.codinssrv = ins.codinssrv
                 and ins.tipinssrv = 3
                 and ins.numero is not null
                 and s.codsolot = an_codsolot) xx
       where c.account_id_n = ca.account_id_n
         and c.start_date_dt =
             (select max(start_date_dt)
                from janus_prod_pe.connections@DBL_JANUS
               where connection_id_v = c.connection_id_v)
         and ca.start_date_dt =
             (select max(start_date_dt)
                from janus_prod_pe.connection_accounts@DBL_JANUS
               where account_id_n = ca.account_id_n)
         and ca.payer_id_0_n = p.payer_id_n
         and ca.payer_id_0_n = pt.payer_id_n
         and p.payer_id_n = pb.payer_id_n
         and pt.tariff_id_n = tm.tariff_id_n
         and pt.start_date_dt =
             (select max(start_date_dt)
                from janus_prod_pe.payer_tariffs@DBL_JANUS
               where tariff_id_n = pt.tariff_id_n
                 and payer_id_n = pt.payer_id_n)
         and pt.status_n = 1
         and ca.payer_id_3_n = pc.payer_id_n
         and c.connection_id_v = xx.numero;
  else
    open V_CURSOR for
      select null numero,
             null customer_id,
             null codplan,
             null producto,
             null tipoplan,
             null fecini,
             null flg_estado,
             null estado,
             null ciclo
        from dual;
  end if;

  o_resultado := V_CURSOR;

end P_CONS_LINEA_JANUS_REG;
/