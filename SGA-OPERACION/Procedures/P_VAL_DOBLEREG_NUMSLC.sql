CREATE OR REPLACE PROCEDURE OPERACION.P_VAL_DOBLEREG_NUMSLC(a_numslc in operacion.solot.numslc%TYPE,
                                                            a_solot  out VARCHAR2) IS
  /************************************************************
  NOMBRE:   P_INSERT_NUMSLC_ORI
  PROPOSITO: Valida si Existe alguna SOT en estado "En Ejecucion" donde se esten usando
             los mismo Servicios Identificados por NUMSLC
  PROGRAMADO EN JOB: NO

  REVISIONES:
  Version   Fecha           Autor               Descripcisn
  --------- ----------      ---------------     ------------------------
  1.0       24/11/2016      Jose Varillas       Alertas Transfer Billing
  ***********************************************************/
  ln_val NUMBER;

  Cursor c_solot is
    SELECT s.CODSOLOT
      FROM solot S
     WHERE EXISTS (SELECT 1
              FROM OPEDD O, TIPOPEDD T
             WHERE O.TIPOPEDD = T.TIPOPEDD
               AND T.ABREV = 'TRANS_BILL'
               AND O.ABREVIACION = 'TIPTRA_SOT'
               AND O.CODIGON = S.TIPTRA)
       AND EXISTS (SELECT 1
              FROM OPEDD O, TIPOPEDD T
             WHERE O.TIPOPEDD = T.TIPOPEDD
               AND T.ABREV = 'TRANS_BILL'
               AND O.ABREVIACION = 'ESTSOL_SOT'
               AND O.CODIGON = S.estsol)
       AND EXISTS (SELECT 1
              FROM OPEDD O, TIPOPEDD T
             WHERE O.TIPOPEDD = T.TIPOPEDD
               AND T.ABREV = 'TRANS_BILL'
               AND O.ABREVIACION = 'TIPSRV_SOT'
               AND O.CODIGOC = S.TIPSRV)
       AND EXISTS (SELECT 1
              FROM SOLOTPTO     PTO,
                   VTADETPTOENL VTA,
                   INSPRD       PD
                     WHERE PTO.PID_OLD = VTA.PID_OLD
                       AND PD.PID = VTA.PID_OLD
               AND PTO.CODSOLOT = S.CODSOLOT
               AND VTA.NUMSLC = a_numslc);

BEGIN
  SELECT COUNT(1)
    INTO ln_val
    FROM OPEDD O, TIPOPEDD T
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND T.ABREV = 'TRANS_BILL'
     AND O.ABREVIACION = 'P_VAL_DOBLEREG_NUMSLC'
     AND O.CODIGOC = '1';

  a_solot := ' ';
  IF ln_val > 0 THEN
    For lc_solot in c_solot Loop
      a_solot := a_solot || 'Sot : ' || lc_solot.codsolot || chr(13);
    End Loop;
  END IF;
END;
/