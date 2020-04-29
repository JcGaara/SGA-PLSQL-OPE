CREATE OR REPLACE PROCEDURE OPERACION.SGA_CLIENTES_HFC_EN_BSCS(p_fecha IN DATE) IS
  v_estado      CHAR(1);
  v_estado_new  CHAR(1);
  v_cod_id      NUMBER;
  v_customer_id NUMBER;
  v_totalreg    NUMBER;

  CURSOR c_solot IS
    SELECT s.codsolot,
           s.tiptra,
           s.codcli,
           s.cod_id,
           s.customer_id,
           s.fecultest
      FROM solot s
     WHERE s.tiptra = 729
       AND s.estsol IN (12, 29)
       AND trunc(s.fecultest) = trunc(p_fecha);
BEGIN
  v_totalreg := 0;

  FOR i_solot IN c_solot
  LOOP
    BEGIN

      SELECT c.ch_status
        INTO v_estado
        FROM contract_history@DBL_BSCS_BF c
       WHERE c.co_id = (i_solot.cod_id)
         AND c.ch_seqno = (SELECT MAX(ch_seqno)
                             FROM contract_history@DBL_BSCS_BF
                            WHERE co_id = c.co_id);

      SELECT s.cod_id, s.customer_id
        INTO v_cod_id, v_customer_id
        FROM solot s
       WHERE s.codsolot IN (SELECT MAX(s.codsolot)
                              FROM solot s
                             WHERE s.codcli = i_solot.codcli
                               AND s.tiptra IN (658)
                               AND s.estsol IN (12, 29));
      SELECT c.ch_status
        INTO v_estado_new
        FROM contract_history@DBL_BSCS_BF c
       WHERE c.co_id = (v_cod_id)
         AND c.ch_seqno = (SELECT MAX(ch_seqno)
                             FROM contract_history@DBL_BSCS_BF
                            WHERE co_id = c.co_id);

      IF upper(TRIM(v_estado_new)) = 'A' THEN
        dbms_output.put_line(i_solot.customer_id || '|' || v_customer_id || '|' ||
                             i_solot.fecultest);

        v_totalreg := v_totalreg + 1;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
  IF v_totalreg = 0 THEN
    dbms_output.put_line('ORA-000  DesError: LA CONSULTA NO TRAJO REGISTROS');
  END IF;
END SGA_CLIENTES_HFC_EN_BSCS;
/