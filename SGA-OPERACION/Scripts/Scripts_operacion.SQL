declare
  PCODSOLOT       NUMBER;
  PCUSTOMER_ID    INTEGER;
  PFECVIG         DATE;
  PMONTO          VARCHAR2(20);
  fMONTO          number;
  POBSERVACION    VARCHAR2(100);
  PFLAG_COBRO_OCC INTEGER;
  PAPLICACION     VARCHAR2(100);
  PUSUARIO_ACT    VARCHAR2(100);
  PFECHA_ACT      DATE;
  PCOD_ID         char(10);
  PRESULTADO      INTEGER := 0;
  PMSGERR         VARCHAR2(100) := 'OK';
  ln_tmcode       integer;
  lv_plan         varchar2(100);
  lv_periodo      integer;
  lv_concepto_id  integer;
  lv_mes          VARCHAR2(10);
  lv_anio         VARCHAR2(10);
  lv_dia          VARCHAR2(10);

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
     if  rec_1.tiptra = 693 then
        --TE
        Select tmcode
        into ln_tmcode
        from contract_all@dbl_bscs_bf
       where plcode = 1000
         and sccode = 6
         and co_id = rec_1.cod_id;
    
      select valor4
        into lv_plan
        from tim.tim_parametros@dbl_bscs_bf
       where upper(campo) like upper('%HFC_MASIVO%')
         and cast(valor1 as int) = ln_tmcode;
         
        Select Concepto_id, Periodo, MONTO
          into lv_concepto_id, lv_periodo, PMONTO
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) like
               upper('%traslado%' || '%' || lv_plan || '%')
           and TIPO_SERVICIO = 'HFC';
           
            POBSERVACION := 'Cobro por Traslado Externo';
      elsif  rec_1.tiptra = 694 then
        Select Concepto_id, Periodo, MONTO
          into lv_concepto_id, lv_periodo, PMONTO
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) = upper('Traslado Interno') 
         and TIPO_SERVICIO = 'HFC';
         
          POBSERVACION := 'Cobro por Traslado Interno';
      end if;
    
      fMONTO := to_number(PMONTO,'9999.99');
      fMONTO := fMONTO + (fMONTO * 0.18);
       
      UPDATE OPERACION.SHFCT_DET_TRAS_EXT
         SET SHFCV_CODOCC         = lv_concepto_id,
             SHFCV_FECVIG         = sysdate,
             SHFCV_NUMERO_CUOTA   = lv_periodo,
             SHFCV_MONTO          = fMONTO,
             SHFCV_OBSERVACION    = POBSERVACION,
             SHFCV_FLAG_COBRO_OCC = 1,
             SHFCV_APLICACION     = 'HFCPOST',
             SHFCV_USUARIO_ACT    = user,
             SHFCV_FECHA_ACT      = sysdate
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