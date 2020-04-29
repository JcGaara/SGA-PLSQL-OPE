CREATE OR REPLACE PROCEDURE OPERACION.P_INSERT_NUMSLC_ORI(a_numslc_ori  in operacion.solot.numslc%TYPE,
                                                          a_numslc_dest in operacion.solot.numslc%TYPE,
                                                          a_codsuc_dest in sales.vtadetptoenl.codsuc%TYPE,
                                                          a_rpt         out NUMBER) IS
  /************************************************************
  NOMBRE:   P_INSERT_NUMSLC_ORI
  PROPOSITO: Genera registro del Proyecto Destino y Origen en la Tabla REGVTAMENTAB
  PROGRAMADO EN JOB: NO
  
  REVISIONES:
  Version   Fecha           Autor               Descripcisn
  --------- ----------      ---------------     ------------------------
  1.0       24/11/2016      Jose Varillas       Alertas Transfer Billing
  ***********************************************************/
  ln_val NUMBER;
  Cursor c_codsuc is
    select distinct codsuc
      from inssrv
     where codinssrv in (select codinssrv_tras
                           from vtadetptoenl
                          where numslc = a_numslc_dest);
BEGIN
  BEGIN
    SELECT COUNT(1)
      INTO ln_val
      FROM OPEDD O, TIPOPEDD T
     WHERE O.TIPOPEDD = T.TIPOPEDD
       AND T.ABREV = 'TRANS_BILL'
       AND O.ABREVIACION = 'P_INSERT_NUMSLC_ORI'
       AND O.CODIGOC = '1';
  
    IF ln_val > 0 THEN
    
      SELECT COUNT(1)
        into ln_val
        FROM sales.regvtamentab
       WHERE numslc = a_numslc_dest
         and numslc_ori = a_numslc_ori;
      IF ln_val > 0 THEN
        Delete from sales.regvtamentab
         where numslc = a_numslc_dest
           and numslc_ori = a_numslc_ori;
      END IF;
    
      Select count(1)
        into ln_val
        from sales.vtadetptoenl
       where numslc = a_numslc_dest
         and codinssrv_tras is not null;
      if ln_val = 0 then
        INSERT INTO sales.regvtamentab
          (numslc, numslc_ori, codsucdes, codsucori)
        VALUES
          (a_numslc_dest, a_numslc_ori, a_codsuc_dest, a_codsuc_dest);
      Else
        For lc_codsuc in c_codsuc Loop
          INSERT INTO sales.regvtamentab
            (numslc, numslc_ori, codsucdes, codsucori)
          VALUES
            (a_numslc_dest, a_numslc_ori, a_codsuc_dest, lc_codsuc.codsuc);
        End Loop;
      End If;
    END IF;
    a_rpt := 1;
  EXCEPTION
    WHEN OTHERS THEN
      a_rpt := 0;
  END;
  COMMIT;
END;
/
