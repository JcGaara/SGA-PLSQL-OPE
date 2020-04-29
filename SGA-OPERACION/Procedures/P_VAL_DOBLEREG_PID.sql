CREATE OR REPLACE PROCEDURE OPERACION.P_VAL_DOBLEREG_PID(a_pid   in operacion.solotpto.pid_old%TYPE,
                                                         a_solot out VARCHAR2) IS
  /************************************************************
  NOMBRE:   P_INSERT_NUMSLC_ORI
  PROPOSITO: Valida si Existe alguna SOT en estado "En Ejecucion" donde se esten usando 
             los mismo Servicios Identificados por PID
  PROGRAMADO EN JOB: NO
  
  REVISIONES:
  Version   Fecha           Autor               Descripcisn
  --------- ----------      ---------------     ------------------------
  1.0       24/11/2016      Jose Varillas       Alertas Transfer Billing
  ***********************************************************/
  ln_val NUMBER;

  Cursor c_solot is
    SELECT codsolot
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
       AND EXISTS
     (SELECT 1
              FROM OPEDD O, TIPOPEDD T
             WHERE O.TIPOPEDD = T.TIPOPEDD
               AND T.ABREV = 'TRANS_BILL'
               AND O.ABREVIACION = 'TIPSRV_SOT'
               AND O.CODIGOC = S.Tipsrv)
       AND EXISTS (SELECT 1 FROM SOLOTPTO WHERE CODSOLOT = S.CODSOLOT AND PID_OLD = a_pid);
       
BEGIN

  SELECT COUNT(1)
    INTO ln_val
    FROM OPEDD O, TIPOPEDD T
   WHERE O.TIPOPEDD = T.TIPOPEDD
     AND T.ABREV = 'TRANS_BILL'
     AND O.ABREVIACION = 'P_VAL_DOBLEREG_PID'
     AND O.CODIGOC = '1';

  a_solot := ' ';
  IF ln_val > 0 THEN
    For lc_solot in c_solot Loop
      a_solot := a_solot || 'Sot : ' ||lc_solot.codsolot || chr(13);
    End Loop;
  END IF;
END;
/