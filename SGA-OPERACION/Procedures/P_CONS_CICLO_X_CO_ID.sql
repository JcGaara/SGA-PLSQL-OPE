CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_CICLO_X_CO_ID(a_cod_id    in solot.cod_id%type,
                                                           o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN

  OPEN V_CURSOR FOR
    SELECT CU.CUSTOMER_ID customer_id,
           cu.custcode,
           cu.csactivated,
           CO.CO_ID co_id,
           CU.BILLCYCLE ciclo,
           cu.lbc_date,
           cu.user_lastmod
      FROM CUSTOMER_ALL@dbl_bscs_bf CU,
           CONTRACT_ALL@dbl_bscs_bf CO
     WHERE CU.CUSTOMER_ID = CO.CUSTOMER_ID
       AND CO.CO_ID = a_cod_id;

  o_resultado := V_CURSOR;

END P_CONS_CICLO_X_CO_ID;
/
