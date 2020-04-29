CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_EQUIPOS_IW(a_codsolot in solot.codsolot%type,
                                               o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN
  OPEN V_CURSOR FOR
    SELECT CUSTOMER_ID, COD_ID, TIPO_SERVICIO, ID_PRODUCTO,
      CASE WHEN INTERFASE <> 2020 THEN MAC_ADDRESS
      ELSE SERIAL_NUMBER
      END CASE,
      profile_crm
      FROM OPERACION.TAB_EQUIPOS_IW
     WHERE CODSOLOT = A_CODSOLOT
       AND ID_PRODUCTO IN (SELECT iw.id_producto
                             FROM OPERACION.TRS_INTERFACE_IW iw, solot s
                            WHERE iw.id_interfase in (620, 820, 2020)
                              and s.codsolot = iw.codsolot
                              and s.CODSOLOT = a_codsolot);
  o_resultado := V_CURSOR;

  END P_CONS_EQUIPOS_IW;
/
