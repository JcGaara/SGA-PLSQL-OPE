CREATE OR REPLACE PROCEDURE OPERACION.P_CONTR_LINEA_JANUS(
                                 v_error   out number,
                                 v_message out varchar2) IS
  av_output              varchar2(4000);           
  l_co_id                contract_all.co_id@DBL_BSCS_BF%type;
  l_dn_num               directory_number.dn_num@DBL_BSCS_BF%type;
  l_cod_plan             contract_all.tmcode@DBL_BSCS_BF%type;     
  l_cliente              contract_all.customer_id@DBL_BSCS_BF%type;
  l_tipo_producto        char(4);
  l_ciclo                customer_all.billcycle@DBL_BSCS_BF%type;
  l_est_contrato         contract_history.ch_status@DBL_BSCS_BF%type;
  l_ch_seqno             contract_history.ch_seqno@DBL_BSCS_BF%type;
  l_fecha_activacion     contract_history.ch_validfrom@DBL_BSCS_BF%type;
  l_ch_pending           contract_history.ch_pending@DBL_BSCS_BF%type;
  l_linea                varchar2(65);

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
                                     WHERE CO_ID = A.CO_ID)) BSCS
          LEFT  outer JOIN (SELECT DISTINCT (c.msisdn) ---, c.start_date_dt fechajanus, ca.start_date_dt fechContrAct, p.external_payer_id_v
                               FROM DWS.SA_W_CONNECTIONS@DBL_DWO C ---modificar particion AL D-1
                              WHERE C.FECHA_CARGA = TRUNC(SYSDATE-1)
                                AND c.status_n = 1
                                AND LENGTH(c.msisdn) = 10 -- 10:Fija(HFC+LTE+TFI+CEHFC); 11:movil
                             --and  c.msisdn  = '5144539510'
                             ) JANUS
              ON BSCS.linea = JANUS.msisdn
          WHERE JANUS.msisdn IS NULL
    UNION ALL
    SELECT dn_num,
          co_id contrato,
          tmcode cod_plan,
          customer_id cliente,
          tipo_producto,
          billcycle ciclo,
          ch_status estado_contrato,
          ch_seqno,
          ch_validfrom fecha_Activacion,
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
                                     WHERE CO_ID = A.CO_ID)) BSCS
            LEFT  outer JOIN (SELECT DISTINCT (c.msisdn) ---, c.start_date_dt fechajanus, ca.start_date_dt fechContrAct, p.external_payer_id_v
                               FROM DWS.SA_W_CONNECTIONS@DBL_DWO C ---modificar particion AL D-1
                              WHERE C.FECHA_CARGA = TRUNC(SYSDATE-1)
                                AND c.status_n = 1
                                AND LENGTH(c.msisdn) = 10 -- 10:Fija(HFC+LTE+TFI+CEHFC); 11:movil
                             --and  c.msisdn  = '5144539510'
                             ) JANUS
              ON BSCS.linea = JANUS.msisdn
          WHERE JANUS.msisdn IS NULL;

          
BEGIN
  DBMS_OUTPUT.enable(NULL);
  av_output           := '';
  DBMS_OUTPUT.put_line(RPAD('dn_num',30)||','||RPAD('Contrato',13)||','||RPAD('cod_plan',8)||','||RPAD('cliente',15)||','||RPAD('tipo_producto',13)||','||RPAD('ciclo',5)||','
               ||RPAD('estado_contrato',16)||','||RPAD('ch_seqno',8)||','||RPAD('fecha_Activacion',25)||','||RPAD('ch_pending',12)||','||RPAD('linea',32));
  
  for cur1 in c1 loop
    av_output           := '';
    l_co_id             := cur1.contrato;
    l_dn_num            := cur1.dn_num;
    l_cod_plan          := cur1.cod_plan;    
    l_cliente           := cur1.cliente;
    l_tipo_producto     := cur1.tipo_producto;
    l_ciclo             := cur1.ciclo;
    l_est_contrato      := cur1.estado_contrato;
    l_ch_seqno          := cur1.ch_seqno;
    l_fecha_activacion  := cur1.fecha_Activacion;
    l_ch_pending        := cur1.ch_pending;
    l_linea             := cur1.linea;
    
    av_output :=RPAD(l_dn_num,30)||','||RPAD(l_co_id,13)||','||RPAD(l_cod_plan,8)||','||RPAD(l_cliente,15)||','||RPAD(l_tipo_producto,13)||','||RPAD(l_ciclo,5)||','
               ||RPAD(l_est_contrato,16)||','||RPAD(l_ch_seqno,8)||','||RPAD(l_fecha_activacion,25)||','||RPAD(l_ch_pending,12)||','||RPAD(l_linea,32);
    DBMS_OUTPUT.put_line(av_output);
  end loop;
  v_error := 0;
  v_message := 'OK';
EXCEPTION
    WHEN OTHERS THEN
      v_message := 'Error en el procedimiento OPERACION.P_CONTR_LINEA_JANUS : ' || SQLERRM;
      v_error := sqlcode;
      DBMS_OUTPUT.put_line(v_message||' '||v_error);

END P_CONTR_LINEA_JANUS;
/
