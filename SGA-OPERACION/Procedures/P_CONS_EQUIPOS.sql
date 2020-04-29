CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_EQUIPOS(a_cod_id in solot.cod_id%type,
                                             o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN
  OPEN V_CURSOR FOR
      select distinct
      (select customer_id from   contract_all@DBL_BSCS_BF  where co_id = ccs.co_id) AS customer_id,
                    ccs.CO_ID,
                    serv.tipo_serv,
                    serv.id_producto,
                    serv.serie_mac,
                    serv.estado
      from curr_co_status@DBL_BSCS_BF ccs,
           (SELECT DS.CO_ID,
                   DS.TIPO_SERV,
                   DS.ESTADO,
                   DECODE(DS.TIPO_SERV, 'INT',
                          (SELECT id_producto
                              FROM tim.pf_hfc_internet@DBL_BSCS_BF
                             WHERE CO_ID = DS.CO_ID
                               and estado_recurso <> 'RI'), 'TLF',
                          (SELECT id_producto
                              FROM tim.pf_hfc_telefonia@DBL_BSCS_BF
                             WHERE CO_ID = DS.CO_ID
                               and estado_recurso <> 'RI')) id_producto,
                   DECODE(DS.TIPO_SERV, 'INT',
                          (SELECT mac_address
                              FROM tim.pf_hfc_internet@DBL_BSCS_BF
                             WHERE CO_ID = DS.CO_ID
                               and estado_recurso <> 'RI'), 'TLF',
                          (SELECT mac_address
                              FROM tim.pf_hfc_telefonia@DBL_BSCS_BF
                             WHERE CO_ID = DS.CO_ID
                               and estado_recurso <> 'RI')) SERIE_MAC
              FROM TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF DS
             WHERE DS.tipo_serv in ('INT', 'TLF')
            union
            select dd.CO_ID,
                   dd.TIPO_SERV,
                   dd.estado,
                   dd.id_producto,
                   tv.serial_number SERIE_MAC
              from TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF dd,
                   tim.pf_hfc_cable_tv@DBL_BSCS_BF   tv
             WHERE dd.co_id = tv.co_id
               and tv.estado_recurso <> 'RI'
               and dd.id_producto = tv.id_producto
               and dd.tipo_serv = 'CTV'
               and dd.estado <> 'RI'
           ) SERV
      where ccs.CO_ID = serv.co_id(+)
       and ccs.CO_ID in (a_cod_id)
      order by id_producto;

      o_resultado := V_CURSOR;
  END P_CONS_EQUIPOS;
/
