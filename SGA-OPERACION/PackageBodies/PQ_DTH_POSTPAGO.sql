create or replace package body operacion.PQ_DTH_POSTPAGO is

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_DTH_POSTPAGO
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
   1.0     06/07/2015  Luis Flores Osorio                     SD-417723
   2.0     21/12/2017  Jose Arriola        Carlos Lazarte     PROY_29955.INC000001017267
  *******************************************************************************************************/
  procedure p_request_get(a_hora    in varchar2,
                          o_mensaje out varchar2,
                          o_error   out number) is
    cursor CUR_R is
      select M.REQUEST
        from MDSRRTAB@DBL_BSCS_BF M
       where M.STATUS not in (7, 9)
         and M.ACTION_DATE <=
             TO_DATE((TO_CHAR(sysdate, 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24') --09AM HORAS
         and exists (select 1
                from CONTRACT_ALL@DBL_BSCS_BF CA
               where CA.CO_ID = M.CO_ID
                 and CA.TMCODE = 200) --DTH
         and M.PLCODE <> 1000;
  begin

    delete from OPERACION.REQUEST_ALTA_DTH_POST;
    commit;

    --setear a estado 11 e instersar en la tabla temporal los registros a finalizar.
    for L in CUR_R loop
      begin
        update MDSRRTAB@DBL_BSCS_BF M
           set M.STATUS = 11
         where M.REQUEST = L.REQUEST;

        insert into OPERACION.REQUEST_ALTA_DTH_POST
          (REQUEST)
        values
          (L.REQUEST);

      exception
        when others then
          o_error   := -1;
          o_mensaje := 'OBTENER REQUEST DTH: Revisar REQUEST ' || L.REQUEST;
      end;

    end loop;
    o_error   := 0;
    o_mensaje := 'OBTENER REQUEST DTH: Se ejecuto proceso satisfactoriamente';

  end p_request_get;

  procedure p_finalizar_request(o_mensaje  out varchar2,
                                o_error    out number,
                                o_contador out number) is
    cursor C is
      select a.REQUEST, b.status
        from OPERACION.REQUEST_ALTA_DTH_POST a, MDSRRTAB@DBL_BSCS_BF b
       where a.request = b.request
         and b.status = 11;
  begin
    for L in C loop
      begin
        CONTRACT.FINISH_REQUEST@DBL_BSCS_BF(L.REQUEST);
        update MDSRRTAB@DBL_BSCS_BF
           set STATUS = 7
         where REQUEST = L.REQUEST;
      exception
        when others then
          o_error   := -1;
          o_mensaje := 'FINALIZAR REQUEST DTH: Revisar REQUEST ' ||
                       L.REQUEST;
      end;
    end loop;

    o_error   := 0;
    o_mensaje := 'FINALIZAR REQUEST DTH: Se ejecuto proceso satisfactoriamente';

    select count(1)
      into o_contador
      from OPERACION.REQUEST_ALTA_DTH_POST a, MDSRRTAB@DBL_BSCS_BF b
     where a.request = b.request
       and b.status = 11;

  end p_finalizar_request;

  procedure p_request_contract_list(a_hora    in varchar2,
                                    o_mensaje out varchar2,
                                    o_error   out number) is
    v_valor number;
    v_action number;
  cursor CUR_C(ln_valor number) is
      select GR.CO_ID
        from MDSRRTAB@DBL_BSCS_BF       GR,
             CONTRACT_ALL@DBL_BSCS_BF   CA,
             CURR_CO_STATUS@DBL_BSCS_BF CO
       where GR.CO_ID = CA.CO_ID
         and CA.CO_ID = CO.CO_ID
         and CO.CH_STATUS = 'a'
         and GR.ACTION_ID in (3, 1, 2000, 8)
         and CA.TMCODE = 200
         and GR.ACTION_DATE >= TRUNC(sysdate) - ln_valor
         and GR.ACTION_DATE <=
             TO_DATE((TO_CHAR(TRUNC(sysdate), 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24') --09AM HORAS
      union all
      select GR.CO_ID
        from GMD_REQUEST_HISTORY@DBL_BSCS_BF GR,
             CONTRACT_ALL@DBL_BSCS_BF        CA,
             CURR_CO_STATUS@DBL_BSCS_BF      CO
       where GR.CO_ID = CA.CO_ID
         and CA.CO_ID = CO.CO_ID
         and CO.CH_STATUS = 'a'
         and GR.ACTION_ID in (3, 1, 2000, 8)
         and CA.TMCODE = 200
         and GR.ACTION_DATE >= TRUNC(sysdate) - ln_valor
         and GR.ACTION_DATE <=
             TO_DATE((TO_CHAR(TRUNC(sysdate), 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24');

    cursor CUR_B(AN_COD_ID INTEGER) is
      select SSH.CO_ID, TAR.NRO_TARJETA, BU.COD_BUQUET, SSH.REQUEST_ID
        from PR_SERV_STATUS_HIST@DBL_BSCS_BF SSH
       inner join TIM.PP_DTH_PROV@DBL_BSCS_BF PR
          on PR.CO_ID = SSH.CO_ID
       inner join TIM.PP_DTH_TARJETA@DBL_BSCS_BF TAR
          on TAR.ID_TARJETA = PR.ID_TARJETA
       inner join TIM.PP_GMD_BUQUET@DBL_BSCS_BF BU
          on BU.SNCODE = SSH.SNCODE
       where HISTNO = (select STATUS_HISTNO
                         from PROFILE_SERVICE@DBL_BSCS_BF
                        where CO_ID = SSH.CO_ID
                          and SNCODE = SSH.SNCODE)
         and SSH.STATUS = 'A'
         and SSH.CO_ID = AN_COD_ID
         and TAR.NRO_TARJETA is not null;
  begin
  select to_number(valor) into v_valor  from constante a where a.constante='DIASDTHPOSALTA';
       --Cargamos todos los contratos
    for L in CUR_C(v_valor) loop
      --obtener lista de tarjeta y bouquest por contrato.
      for c_tar in CUR_B(L.CO_ID) loop
        v_action := f_obt_action(c_tar.co_id, c_tar.request_id, 0);
        insert into OPERACION.CONTRACT_ALTA_DTH_POST
          (CO_ID, NRO_TARJETA, BOUQUETES, ACTIONID)
        values
          (c_tar.CO_ID, c_tar.NRO_TARJETA, c_tar.COD_BUQUET, v_action);

      end loop;
    end loop;

    o_error   := 0;
    o_mensaje := 'OBTENER LISTA CONTRATO: Se ejecuto proceso satisfactoriamente';
  end p_request_contract_list;

  procedure p_planos_get(o_mensaje out varchar2, o_error out number) is

    lv_sql     varchar2(1000);
    lv_bouquet varchar2(20);
    ln_x       number;
  V_BOUQ VARCHAR2(250);

    cursor c_tarjeta is
      select DISTINCT NRO_TARJETA, BOUQUETES, ACTIONID
        from OPERACION.CONTRACT_ALTA_DTH_POST
       WHERE IDSOL IS NULL
         AND ESTADO = 0;

  begin

    lv_sql := ' delete from OPERACION.RECONEXION_DTH_POS ';
    execute immediate lv_sql;
    commit;

    for x1 in c_tarjeta loop
      lv_bouquet := null;
      ln_x       := 1;

    -- 14/02/2019 [I]-- SE VALIDA SI TIENE MAS DE 1 BOUQUET
      SELECT INSTR(X1.BOUQUETES, ',') INTO V_BOUQ FROM DUAL;
      IF V_BOUQ > 0 THEN
          LOOP
            IF SUBSTR(X1.BOUQUETES, LN_X, 1) != ',' THEN
              LV_BOUQUET := LV_BOUQUET || SUBSTR(X1.BOUQUETES, LN_X, 1);
            ELSE
              BEGIN
                INSERT INTO OPERACION.RECONEXION_DTH_POS
                  (NRO_TARJETA, BUQUETS, TIPO, ACTION)
                VALUES
                  (X1.NRO_TARJETA, LV_BOUQUET, 'ALTA', X1.ACTIONID);
                LV_BOUQUET := NULL;
              END;
            END IF;
            LN_X := LN_X + 1;
            EXIT WHEN LN_X > LENGTH(X1.BOUQUETES);
          END LOOP;
      ELSE
        INSERT INTO OPERACION.RECONEXION_DTH_POS (NRO_TARJETA, BUQUETS, TIPO, ACTION)
                      VALUES (X1.NRO_TARJETA, X1.BOUQUETES, 'ALTA', X1.ACTIONID);
     END IF;
 END LOOP;
     --[F] 14/02/2019
    commit;
    o_error   := 0;
    o_mensaje := NULL;
  exception
    when others then
      o_error   := -1;
      o_mensaje := 'ERROR al separar bouquet : ' || to_char(sqlerrm);
  end p_planos_get;

  procedure p_ejecuta_alta_dthpost(o_mensaje out varchar2,
                                   o_error   out number)

   is
    a_hora      varchar2(10);
    ln_contador number;
    ln_idsol    number;
    ln_intento  number;

    cursor c_dthpostpago is
      select distinct d.nro_tarjeta--, d.action
        from OPERACION.RECONEXION_DTH_POS d
       where d.tipo = 'ALTA';

    cursor c_dthpost_detalle(av_tarjeta varchar2) is
      select distinct d.nro_tarjeta, lpad(d.buquets, 8, 0) bouquet
        from OPERACION.RECONEXION_DTH_POS d
       where d.tipo = 'ALTA'
         and d.nro_tarjeta = av_tarjeta;

  begin

    a_hora      := to_char(sysdate, 'HH24');
    ln_contador := 0;
    ln_intento  := 0;

    p_request_get(a_hora, o_mensaje, o_error);

    loop
      p_finalizar_request(o_mensaje, o_error, ln_contador);
      ln_intento := ln_intento + 1;
      if ln_contador = 0 then
        ln_intento := 3;
      end if;
      exit when ln_intento = 3;
    end loop;

    --commit;
    p_request_contract_list(a_hora, o_mensaje, o_error);

    -- Cargamos todas las tarjetas y bouquet
    p_planos_get(o_mensaje, o_error);

    SELECT sq_ope_tvsat_sltd_cab_idsol.nextval
      INTO ln_idsol
      FROM DUMMY_OPE;

    -- Insertamos en la Cabecera de Lotes
    insert into ope_tvsat_sltd_cab
      (tiposolicitud, estado, flg_recarga, idsol)
    values
      ('6', 1, 1, ln_idsol); -- No recargable

    -- Cargamos las Tarjetas
    for c_dth in c_dthpostpago loop

      insert into ope_tvsat_sltd_det
        (idsol, serie/*, action_id*/)
      values
        (ln_idsol, c_dth.nro_tarjeta/*, c_dth.action*/);

      update operacion.contract_alta_dth_post dt
         set dt.idsol = ln_idsol
       where dt.nro_tarjeta = c_dth.nro_tarjeta
         and dt.idsol is null;

      for c_d in c_dthpost_detalle(c_dth.nro_tarjeta) loop
        insert into ope_tvsat_sltd_bouquete_det
          (idsol, serie, bouquete, tipo)
        values
          (ln_idsol, c_d.nro_tarjeta, c_d.bouquet, 6);
      end loop;
    end loop;

    o_mensaje := null;
    o_error   := 0;

    commit;

  exception
    when others then
      o_mensaje := 'Error Proceso DTH Postpago : ' || to_char(sqlerrm);
      o_error   := -1;
  end;

  -- Procedimiento de DTH Baja
  procedure p_request_get_baja(a_hora    in varchar2,
                               o_mensaje out varchar2,
                               o_error   out number) is
    cursor CUR_R is
      SELECT M.REQUEST
        FROM MDSRRTAB@DBL_BSCS_BF M
       WHERE M.STATUS NOT IN (7, 9)
         AND M.ACTION_DATE <=
             TO_DATE((TO_CHAR(SYSDATE, 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24') --09AM HORAS
         AND EXISTS (SELECT 1
                FROM CONTRACT_ALL@DBL_BSCS_BF CA
               WHERE CA.CO_ID = M.CO_ID
                 AND CA.TMCODE = 200) --DTH
         AND M.PLCODE <> 1000 --EXONERAR HFC
      ;
  begin

    delete from OPERACION.REQUEST_BAJA_DTH_POST;
    commit;

    --setear a estado 11 e instersar en la tabla temporal los registros a finalizar.
    for L in CUR_R loop
      begin
        update MDSRRTAB@DBL_BSCS_BF M
           set M.STATUS = 11
         where M.REQUEST = L.REQUEST;

        insert into OPERACION.REQUEST_BAJA_DTH_POST
          (REQUEST)
        values
          (L.REQUEST);

      exception
        when others then
          o_error   := -1;
          o_mensaje := 'OBTENER REQUEST DTH: Revisar REQUEST ' || L.REQUEST;
      end;

    end loop;
    o_error   := 0;
    o_mensaje := 'OBTENER REQUEST DTH: Se ejecuto proceso satisfactoriamente';

  end p_request_get_baja;

  procedure p_finalizar_request_baja(o_mensaje  out varchar2,
                                     o_error    out number,
                                     o_contador out number) is
    cursor C is
      select a.REQUEST, b.status
        from OPERACION.REQUEST_BAJA_DTH_POST a, MDSRRTAB@DBL_BSCS_BF b
       where a.request = b.request
         and b.status = 11;
  begin
    for L in C loop
      begin
        CONTRACT.FINISH_REQUEST@DBL_BSCS_BF(L.REQUEST);
        update MDSRRTAB@DBL_BSCS_BF
           set STATUS = 7
         where REQUEST = L.REQUEST;
      exception
        when others then
          o_error   := -1;
          o_mensaje := 'FINALIZAR REQUEST DTH: Revisar REQUEST ' ||
                       L.REQUEST;
      end;
    end loop;

    o_error   := 0;
    o_mensaje := 'FINALIZAR REQUEST DTH: Se ejecuto proceso satisfactoriamente';

    select count(1)
      into o_contador
      from OPERACION.REQUEST_BAJA_DTH_POST a, MDSRRTAB@DBL_BSCS_BF b
     where a.request = b.request
       and b.status = 11;

  end p_finalizar_request_baja;

  procedure p_request_contract_list_baja(a_hora    in varchar2,
                                         o_mensaje out varchar2,
                                         o_error   out number) is

  v_valor number;
  v_action number;--v2.0

  cursor CUR_C(ln_valor number) is
      SELECT GR.CO_ID
        FROM MDSRRTAB@DBL_BSCS_BF       GR,
             CONTRACT_ALL@DBL_BSCS_BF   CA,
             CURR_CO_STATUS@DBL_BSCS_BF CO
       WHERE GR.CO_ID = CA.CO_ID
         AND CA.CO_ID = CO.CO_ID
         AND CO.CH_STATUS in ('s', 'd')
         AND GR.ACTION_ID in (4, 5)
         AND CA.TMCODE = 200
         AND GR.ACTION_DATE >= TRUNC(SYSDATE) - ln_valor
         AND GR.ACTION_DATE <=
             TO_DATE((TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24')
      UNION ALL
      SELECT GR.CO_ID
        FROM GMD_REQUEST_HISTORY@DBL_BSCS_BF GR,
             CONTRACT_ALL@DBL_BSCS_BF        CA,
             CURR_CO_STATUS@DBL_BSCS_BF      CO
       WHERE GR.CO_ID = CA.CO_ID
         AND CA.CO_ID = CO.CO_ID
         AND CO.CH_STATUS in ('s', 'd')
         AND GR.ACTION_ID in (4, 5)
         AND CA.TMCODE = 200
         AND GR.ACTION_DATE >= TRUNC(SYSDATE) - ln_valor
         AND GR.ACTION_DATE <=
             TO_DATE((TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY') || a_hora),
                     'DD/MM/YYYY HH24');

    cursor CUR_B(AN_COD_ID INTEGER) is

      SELECT SSH.CO_ID, TAR.NRO_TARJETA, BU.COD_BUQUET,
             SSH.REQUEST_ID --v2.0
        FROM PR_SERV_STATUS_HIST@DBL_BSCS_BF SSH
       INNER JOIN TIM.PP_DTH_PROV@DBL_BSCS_BF PR
          ON PR.CO_ID = SSH.CO_ID
       INNER JOIN TIM.PP_DTH_TARJETA@DBL_BSCS_BF TAR
          ON TAR.ID_TARJETA = PR.ID_TARJETA
       INNER JOIN TIM.PP_GMD_BUQUET@DBL_BSCS_BF BU
          ON BU.SNCODE = SSH.SNCODE
       WHERE HISTNO = (SELECT STATUS_HISTNO
                         FROM PROFILE_SERVICE@DBL_BSCS_BF
                        WHERE CO_ID = SSH.CO_ID
                          AND SNCODE = SSH.SNCODE)
         AND SSH.STATUS IN ('S', 'D')
         AND SSH.CO_ID = AN_COD_ID
         AND TAR.NRO_TARJETA IS NOT NULL;

  begin

    select to_number(valor) into v_valor from constante a where a.constante='DIASDTHPOSBAJA';

    --Cargamos todos los contratos
    for L in CUR_C(v_valor) loop
      --obtener lista de tarjeta y bouquest por contrato.
      for c_tar in CUR_B(L.CO_ID) loop
        --ini v2.0
        v_action := f_obt_action(c_tar.co_id, c_tar.request_id, 1);
        --fin v2.0
        insert into OPERACION.CONTRACT_BAJA_DTH_POST
          (CO_ID, NRO_TARJETA, BOUQUETES,
           ACTIONID)--v2.0
        values
          (c_tar.CO_ID, c_tar.NRO_TARJETA, c_tar.COD_BUQUET,
           v_action);--v2.0

      end loop;
    end loop;

    o_error   := 0;
    o_mensaje := 'OBTENER LISTA CONTRATO: Se ejecuto proceso satisfactoriamente';
  end p_request_contract_list_baja;

  procedure p_planos_get_baja(o_mensaje out varchar2, o_error out number) is

    lv_sql     varchar2(1000);
    lv_bouquet varchar2(20);
    ln_x       number;
  V_BOUQ VARCHAR2(250);

    cursor c_tarjeta is
      select DISTINCT NRO_TARJETA, BOUQUETES, ACTIONID
        from OPERACION.CONTRACT_BAJA_DTH_POST
       WHERE IDSOL IS NULL
         AND ESTADO = 0;

  begin

    lv_sql := ' delete from OPERACION.BAJA_DTH_POS ';
    execute immediate lv_sql;
    commit;

  for x1 in c_tarjeta loop
      lv_bouquet := null;
      ln_x       := 1;

    -- 14/02/2019 [I]-- SE VALIDA SI TIENE MAS DE 1 BOUQUET
      SELECT INSTR(X1.BOUQUETES, ',') INTO V_BOUQ FROM DUAL;
      IF V_BOUQ > 0 THEN
          LOOP
            IF SUBSTR(X1.BOUQUETES, LN_X, 1) != ',' THEN
              LV_BOUQUET := LV_BOUQUET || SUBSTR(X1.BOUQUETES, LN_X, 1);
            ELSE
              BEGIN
                INSERT INTO OPERACION.BAJA_DTH_POS
                  (NRO_TARJETA, BUQUETS, TIPO, ACTION)
                VALUES
                  (X1.NRO_TARJETA, LV_BOUQUET, 'BAJA', X1.ACTIONID);
                LV_BOUQUET := NULL;
              END;
            END IF;
            LN_X := LN_X + 1;
            EXIT WHEN LN_X > LENGTH(X1.BOUQUETES);
          END LOOP;
      ELSE
        INSERT INTO OPERACION.BAJA_DTH_POS (NRO_TARJETA, BUQUETS, TIPO, ACTION)
                      VALUES (X1.NRO_TARJETA, X1.BOUQUETES, 'BAJA', X1.ACTIONID);
     END IF;
 END LOOP;

    o_error   := 0;
    o_mensaje := NULL;
    commit;
  exception
    when others then
      o_error   := -1;
      o_mensaje := 'ERROR al separar bouquet : ' || to_char(sqlerrm);

  end p_planos_get_baja;

  procedure p_ejecuta_baja_dthpost(o_mensaje out varchar2,
                                   o_error   out number)

   is
    a_hora      varchar2(10);
    ln_contador number;
    ln_idsol    number;
    ln_intento  number;

    cursor c_dthpostpago is
      select distinct d.nro_tarjeta--, d.action
        from OPERACION.BAJA_DTH_POS d
       where d.tipo = 'BAJA';

    cursor c_dthpost_detalle(av_tarjeta varchar2) is
      select distinct d.nro_tarjeta, lpad(d.buquets, 8, 0) bouquet
        from OPERACION.BAJA_DTH_POS d
       where d.tipo = 'BAJA'
         and d.nro_tarjeta = av_tarjeta;

  begin
    a_hora      := to_char(sysdate, 'HH24');
    ln_contador := 0;
    ln_intento  := 0;

    p_request_get_baja(a_hora, o_mensaje, o_error);

    loop
      p_finalizar_request_baja(o_mensaje, o_error, ln_contador);
      ln_intento := ln_intento + 1;
      if ln_contador = 0 then
        ln_intento := 3;
      end if;
      exit when ln_intento = 3;
    end loop;

    p_request_contract_list_baja(a_hora, o_mensaje, o_error);

    -- Cargamos todas las tarjetas y bouquet
    p_planos_get_baja(o_mensaje, o_error);

    SELECT sq_ope_tvsat_sltd_cab_idsol.nextval
      INTO ln_idsol
      FROM DUMMY_OPE;

    -- Insertamos en la Cabecera de Lotes
    insert into ope_tvsat_sltd_cab
      (tiposolicitud, estado, flg_recarga, idsol)
    values
      ('7', 1, 1, ln_idsol); -- No recargable

    -- Cargamos las Tarjetas
    for c_dth in c_dthpostpago loop

      insert into ope_tvsat_sltd_det
        (idsol, serie/*, action_id*/)
      values
        (ln_idsol, c_dth.nro_tarjeta/*, c_dth.action*/);

      update operacion.contract_baja_dth_post dt
         set dt.idsol = ln_idsol
       where dt.nro_tarjeta = c_dth.nro_tarjeta
         and dt.idsol is null;

      for c_d in c_dthpost_detalle(c_dth.nro_tarjeta) loop
        insert into ope_tvsat_sltd_bouquete_det
          (idsol, serie, bouquete, tipo)
        values
          (ln_idsol, c_d.nro_tarjeta, c_d.bouquet, 7);
      end loop;
    end loop;

    o_mensaje := null;
    o_error   := 0;

    commit;

  exception
    when others then
      o_mensaje := 'Error Proceso DTH Postpago : ' || to_char(sqlerrm);
      o_error   := -1;
  end;
  --ini v2.0
FUNCTION F_OBT_ACTION(P_CO_ID NUMBER, P_REQUEST NUMBER, P_FLAG NUMBER)
  RETURN NUMBER IS
  LC_ACTION NUMBER;
BEGIN

  IF P_FLAG = 0 THEN
    SELECT ACTION_ID
      INTO LC_ACTION
      FROM (SELECT GR.ACTION_ID
              FROM MDSRRTAB@DBL_BSCS_BF       GR,
                   CONTRACT_ALL@DBL_BSCS_BF   CA,
                   CURR_CO_STATUS@DBL_BSCS_BF CO
             WHERE GR.CO_ID = CA.CO_ID
               AND CA.CO_ID = CO.CO_ID
               AND CO.CH_STATUS IN ('a')
               AND GR.ACTION_ID IN (3, 1, 2000, 8)
               AND CA.TMCODE = 200
               AND GR.CO_ID = P_CO_ID
               AND GR.REQUEST = P_REQUEST
            UNION ALL
            SELECT GR.ACTION_ID
              FROM GMD_REQUEST_HISTORY@DBL_BSCS_BF GR,
                   CONTRACT_ALL@DBL_BSCS_BF        CA,
                   CURR_CO_STATUS@DBL_BSCS_BF      CO
             WHERE GR.CO_ID = CA.CO_ID
               AND CA.CO_ID = CO.CO_ID
               AND CO.CH_STATUS IN ('a')
               AND GR.ACTION_ID IN (3, 1, 2000, 8)
               AND CA.TMCODE = 200
               AND GR.CO_ID = P_CO_ID
               AND GR.REQUEST = P_REQUEST)
     WHERE ROWNUM < 2;
  ELSIF P_FLAG = 1 THEN
    SELECT ACTION_ID
      INTO LC_ACTION
      FROM (SELECT GR.ACTION_ID
              FROM MDSRRTAB@DBL_BSCS_BF       GR,
                   CONTRACT_ALL@DBL_BSCS_BF   CA,
                   CURR_CO_STATUS@DBL_BSCS_BF CO
             WHERE GR.CO_ID = CA.CO_ID
               AND CA.CO_ID = CO.CO_ID
               AND CO.CH_STATUS IN ('s', 'd')
               AND GR.ACTION_ID IN (4, 5)
               AND CA.TMCODE = 200
               AND GR.CO_ID = P_CO_ID
               AND GR.REQUEST = P_REQUEST
            UNION ALL
            SELECT GR.ACTION_ID
              FROM GMD_REQUEST_HISTORY@DBL_BSCS_BF GR,
                   CONTRACT_ALL@DBL_BSCS_BF        CA,
                   CURR_CO_STATUS@DBL_BSCS_BF      CO
             WHERE GR.CO_ID = CA.CO_ID
               AND CA.CO_ID = CO.CO_ID
               AND CO.CH_STATUS IN ('s', 'd')
               AND GR.ACTION_ID IN (4, 5)
               AND CA.TMCODE = 200
               AND GR.CO_ID = P_CO_ID
               AND GR.REQUEST = P_REQUEST)
     WHERE ROWNUM < 2;
  END IF;
  RETURN LC_ACTION;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
  WHEN OTHERS THEN
    RETURN 0;
END;
  --fin v2.0
end PQ_DTH_POSTPAGO;
/