CREATE OR REPLACE TRIGGER OPERACION.T_PARAMETRO_DET_ADC_BI
  BEFORE INSERT ON OPERACION.PARAMETRO_DET_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Jorge Rivas         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
 **********************************************************************************************************/
DECLARE
  ln_id_detalle   operacion.parametro_det_adc.id_detalle%type;
  lv_ip           operacion.parametro_det_adc.ipcre%type;
BEGIN
  IF :new.id_detalle IS NULL THEN
    SELECT operacion.seq_parametro_det_adc.nextval
      INTO ln_id_detalle
      FROM dual;
      
    SELECT sys_context('userenv', 'ip_address') 
      INTO lv_ip 
      FROM dual;

    :new.id_detalle := ln_id_detalle;
    :new.ipcre := lv_ip;
  END IF;
END;
/
