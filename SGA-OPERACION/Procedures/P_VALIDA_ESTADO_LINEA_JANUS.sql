CREATE OR REPLACE PROCEDURE OPERACION.P_VALIDA_ESTADO_LINEA_JANUS(
                                 v_error   out number,
                                 v_message out varchar2) IS

    l_co_id contract_all.co_id@DBL_BSCS_BF%type;
    l_solot solot.codsolot%type;
    av_output VARCHAR2(4000);
    an_error  NUMBER;
    av_error  VARCHAR2(4000);

    cursor c1 is
      SELECT dn_num,
       co_id         contrato,
       tmcode        cod_plan,
       customer_id   cliente,
       tipo_producto,
       billcycle     ciclo,
       ch_status     estado_contrato,
       ch_seqno,
       ch_validfrom  fecha_Activacion,
       ch_pending,
       linea
        FROM (SELECT dn_num,
                     a.co_id,
                     a.tmcode,
                     a.customer_id,
                     a.tipo_producto,
                     c.billcycle,
                     b.ch_status,
                     b.ch_seqno,
                     b.ch_validfrom,
                     '51' || e.dn_num linea,
                     b.ch_pending
                FROM (SELECT co_id,
                             tmcode,
                             customer_id,
                             DECODE(ca.tmcode,
                                    1477,'TFI',
                                    1476,'TFI',
                                    1472,'TFI',
                                    1974,'TFI',
                                    1558,'TFI',
                                    1473,'TFI',
                                    1847,'TFI',
                                    1613,'TFI',
                                    1628,'TFI',
                                    1973,'TFI',
                                    1468,'TFI',
                                    1492,'HFC',
                                    1494,'HFC',
                                    1495,'HFC',
                                    1497,'HFC',
                                   1817,'LTE',
                                    1291,'TPI',
                                    1290,'TPI',
                                    1489,'TPI',
                                    1625,'TFI',
                                    1626,'TFI',
                                    1627,'TFI',
                                    1740,'TFI',
                                    1972,'TFI',
                                    ca.tmcode) tipo_producto
                        FROM contract_all@DBL_BSCS_BF ca
                       WHERE ca.SCCODE IN (6)
                         AND CA.PLCODE = 1000) a,
                     contract_history@DBL_BSCS_BF b,
                     customer_all@DBL_BSCS_BF c,
                     contr_services_cap@DBL_BSCS_BF d,
                     directory_number@DBL_BSCS_BF e
               WHERE a.co_id = b.co_id
                 AND TRUNC(ch_validfrom) < trunc(SYSDATE-1) --MODIFICAR fecha A D -2
                 AND b.ch_status IN ('a', 's')
                 AND b.ch_seqno = (SELECT MAX(ch_seqno)
                                     FROM contract_history@DBL_BSCS_BF
                                    WHERE co_id = a.co_id)
                 AND a.customer_id = c.customer_id
                 AND a.co_id = d.co_id
                 AND d.dn_id = e.dn_id
                 AND D.SEQNO = (select max(seqno)
                                  FROM contr_services_cap@DBL_BSCS_BF
                                 WHERE CO_ID = A.CO_ID)

              ) BSCS
        LEFT  outer JOIN (SELECT DISTINCT (c.msisdn) ---, c.start_date_dt fechajanus, ca.start_date_dt fechContrAct, p.external_payer_id_v
                           FROM DWS.SA_W_CONNECTIONS@DBL_DWO C ---modificar particion AL D-1
                          WHERE C.FECHA_CARGA = TRUNC(SYSDATE-1)
                            AND c.status_n = 1
                            AND LENGTH(c.msisdn) = 10 -- 10:Fija(HFC+LTE+TFI+CEHFC); 11:movil
                         --and  c.msisdn  = '5144539510'
                         ) JANUS
          ON BSCS.linea = JANUS.msisdn
      WHERE JANUS.msisdn IS NULL
      union all
      SELECT dn_num,
             co_id         contrato,
             tmcode        cod_plan,
             customer_id   cliente,
             tipo_producto,
             billcycle     ciclo,
             ch_status     estado_contrato,
             ch_seqno,
             ch_validfrom  fecha_Activacion,
             ch_pending,
             linea
        FROM (SELECT dn_num,
                     a.co_id,
                     a.tmcode,
                     a.customer_id,
                     a.tipo_producto,
                     c.billcycle,
                     b.ch_status,
                     b.ch_seqno,
                     b.ch_validfrom,
                     '51' || e.dn_num linea,
                     b.ch_pending
                FROM (SELECT co_id,
                             tmcode,
                             customer_id,
                             DECODE(ca.tmcode,
                                    1477,'TFI',
                                    1476,'TFI',
                                    1472,'TFI',
                                    1974,'TFI',
                                    1558,'TFI',
                                    1473,'TFI',
                                    1847,'TFI',
                                    1613,'TFI',
                                    1628,'TFI',
                                    1973,'TFI',
                                    1468,'TFI',
                                    1492,'HFC',
                                    1494,'HFC',
                                    1495,'HFC',
                                    1497,'HFC',
                                    1817,'LTE',
                                   1291,'TPI',
                                    1290,'TPI',
                                    1489,'TPI',
                                    1625,'TFI',
                                    1626,'TFI',
                                    1627,'TFI',
                                    1740,'TFI',
                                    1972,'TFI',
                                    ca.tmcode) tipo_producto
                        FROM contract_all@DBL_BSCS_BF ca
                       WHERE ca.tmcode IN (1817)
                         AND CA.PLCODE = 79) a,
                     contract_history@DBL_BSCS_BF b,
                     customer_all@DBL_BSCS_BF c,
                     contr_services_cap@DBL_BSCS_BF d,
                     directory_number@DBL_BSCS_BF e
               WHERE a.co_id = b.co_id
                 AND TRUNC(ch_validfrom) < trunc(SYSDATE-1) --MODIFICAR fecha A D -2
                 AND b.ch_status IN ('a', 's')
                 AND b.ch_seqno = (SELECT MAX(ch_seqno)
                                     FROM contract_history@DBL_BSCS_BF
                                    WHERE co_id = a.co_id)
                 AND a.customer_id = c.customer_id
                 AND a.co_id = d.co_id
                 AND d.dn_id = e.dn_id
                 AND D.SEQNO = (select max(seqno)
                                  FROM contr_services_cap@DBL_BSCS_BF
                                 WHERE CO_ID = A.CO_ID)

              ) BSCS
        LEFT  outer JOIN (SELECT DISTINCT (c.msisdn) ---, c.start_date_dt fechajanus, ca.start_date_dt fechContrAct, p.external_payer_id_v
                           FROM DWS.SA_W_CONNECTIONS@DBL_DWO C ---modificar particion AL D-1
                          WHERE C.FECHA_CARGA = TRUNC(SYSDATE-1)
                            AND c.status_n = 1
                            AND LENGTH(c.msisdn) = 10 -- 10:Fija(HFC+LTE+TFI+CEHFC); 11:movil
                         --and  c.msisdn  = '5144539510'
                         ) JANUS
          ON BSCS.linea = JANUS.msisdn
      WHERE JANUS.msisdn IS NULL;
       cursor c2 is
        select
         (select g.codsolot
            from solot g
           where g.codsolot = t_base.sot_alta) sot_alta
          from (select a.co_id,
                       (select max(s.codsolot) codsolot
                          from solot s
                         inner join estsol e
                            on (s.estsol = e.estsol)
                         where s.tiptra in
                               (select tiptra
                                  from tiptrabajo
                                 where tiptrs in (1, 3, 4, 5))
                           and s.cod_id = to_number(a.co_id)) sot_max,
                       (select max(s.codsolot) codsolot
                          from solot s
                         inner join estsol e
                            on (s.estsol = e.estsol)
                         where s.tiptra in
                               (select tiptra
                                  from tiptrabajo
                                 where tiptrs in (1, 3, 4, 5))
                           and e.tipestsol not in (5, 7)
                           and s.cod_id = to_number(a.co_id)) sot_val,
                       (select max(s.codsolot) codsolot
                          from solot s
                         inner join estsol e
                            on (s.estsol = e.estsol)
                         where s.tiptra in
                               (select tiptra
                                  from tiptrabajo
                                 where tiptrs in (1)
                                   and tiptra not in (764, 809, 754, 755))
                           and e.tipestsol not in (5, 7)
                           and s.cod_id = to_number(a.co_id)) sot_alta,
                       (select max(d.nro_sot)
                          from usrpvu.sisact_ap_contrato_det@dbl_pvudb c
                         inner join usrpvu.sisact_info_venta_sga@dbl_pvudb d
                            on (c.id_contrato = d.id_contrato)
                         where c.co_id = a.co_id) sot_pvu,
                       (select max(c.ch_seqno)
                          from contract_history@DBL_BSCS_BF c
                         where c.co_id = a.co_id) coid_seqno
                  from contract_all@dbl_bscs_bf a
                 where a.co_id in (l_co_id)) t_base;

  begin
    av_output := '';
    dbms_output.put('|' || RPAD('SOT', 10));
    dbms_output.put('|' || RPAD('Error', 5));
    dbms_output.put_line('|' || RPAD('Mensaje', 200) || '|');

    for cur1 in c1 loop
      l_co_id := cur1.contrato;
      for cur2 in c2 loop
        l_solot := cur2.sot_alta;
        av_output := '';
        an_error  := 0;
        av_error  := '';

        OPERACION.pq_sga_janus.p_valida_linea_bscs_sga(l_solot,
                                             'INIFAC',
                                             an_error,
                                           av_error);

      av_output := '|' || RPAD(l_solot,10) || '|' || RPAD(an_error, 5) || '|' ||
                   RPAD(av_error, 175);
      dbms_output.put_line(av_output);
     
      end loop;
    end loop;
    v_error   := 0;
    v_message :='OK';
  EXCEPTION
    WHEN OTHERS THEN
      v_message := 'Error en el procedimiento OPERACION.P_VALIDA_ESTADO_LINEA_JANUS : ' || SQLERRM;
      v_error := sqlcode;
      DBMS_OUTPUT.put_line(an_error||' '||av_error);

END P_VALIDA_ESTADO_LINEA_JANUS;
/

