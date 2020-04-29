declare
  PRESULTADO      INTEGER := 0;
  PMSGERR         VARCHAR2(100) := 'OK';

  CURSOR cur_1 IS
    select s.codsolot, s.cod_id, s.tiptra
      from solot s, OPERACION.SHFCT_DET_TRAS_EXT d
     where s.codsolot = d.shfcn_codsolot
       and s.tiptra in (693, 694)
       and s.estsol in (11, 17);
begin
  FOR rec_1 IN cur_1 LOOP
    SELECT COUNT(A.SHFCN_CODSOLOT)
      INTO PRESULTADO
      FROM OPERACION.SHFCT_DET_TRAS_EXT A
     WHERE A.SHFCN_CODSOLOT = rec_1.codsolot;
  
    IF PRESULTADO = 1 THEN 
      UPDATE OPERACION.SHFCT_DET_TRAS_EXT
         SET SHFCV_CODOCC         = '',
             SHFCV_FECVIG         = '',
             SHFCV_NUMERO_CUOTA   = '',
             SHFCV_MONTO          = '',
             SHFCV_OBSERVACION    = '',
             SHFCV_FLAG_COBRO_OCC = null,
             SHFCV_APLICACION     = '',
             SHFCV_USUARIO_ACT    = '',
             SHFCV_FECHA_ACT      = ''
       WHERE SHFCN_CODSOLOT = rec_1.codsolot;
    END IF;
  END LOOP;
commit;
EXCEPTION
  WHEN OTHERS THEN
    PRESULTADO := -1;
    PMSGERR    := SQLERRM;
End;
/