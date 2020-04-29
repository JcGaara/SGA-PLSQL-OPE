CREATE OR REPLACE TRIGGER OPERACION.T_PARAMETRO_CAB_ADC_BI
  BEFORE INSERT ON OPERACION.PARAMETRO_CAB_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Jorge Rivas         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
 **********************************************************************************************************/
DECLARE
  ln_id_parametro operacion.parametro_cab_adc.id_parametro%type;
  lv_ip           operacion.parametro_cab_adc.ipcre%type;
BEGIN
  IF :new.id_parametro IS NULL THEN
    SELECT operacion.seq_parametro_cab_ADC.nextval
      INTO ln_id_parametro
      FROM dual;
      
    SELECT sys_context('userenv', 'ip_address') 
      INTO lv_ip 
      FROM dual;

    :new.id_parametro := ln_id_parametro;
    :new.ipcre := lv_ip;
  END IF;
END;
/
