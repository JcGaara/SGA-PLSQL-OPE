CREATE OR REPLACE PROCEDURE OPERACION.P_CONS_EQUIPOS_IW_SGA(a_codsolot in solot.codsolot%type,
                                               o_resultado out PQ_INTRAWAY.T_CURSOR)
  IS
  V_CURSOR PQ_INTRAWAY.T_CURSOR;
  BEGIN
  OPEN V_CURSOR FOR
    SELECT I.CODCLI, I.TIPO_SERVICIO, I.ID_PRODUCTO,
      CASE WHEN I.INTERFASE <> 2020 THEN I.MAC_ADDRESS
      ELSE I.SERIAL_NUMBER
      END CASE,
      I.profile_crm
      FROM OPERACION.TAB_EQUIPOS_IW I
     WHERE I.CODSOLOT = a_codsolot
      and I.ID_PRODUCTO IN (SELECT iw.id_producto
                             FROM intraway.int_servicio_intraway iw, solot s
                            WHERE iw.id_interfase in (620, 820, 2020)
                              and s.codsolot = iw.codsolot
                              and s.CODSOLOT = I.CODSOLOT);
  o_resultado := V_CURSOR;

  END P_CONS_EQUIPOS_IW_SGA;
/
