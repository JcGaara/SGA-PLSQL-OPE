CREATE OR REPLACE TRIGGER OPERACION.T_TRANSACCION_WS_INV_ADC_BI
  BEFORE INSERT ON OPERACION.TRANSACCION_WS_INV_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/******************************************************************************************************
  REVISIONES:
   Version     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   -------------------  -----------------    ----------------------------------
     1.0      10/10/2016   Justiniano Condori   Lizbeth Portella     
  *****************************************************************************************************/

DECLARE
  ln_id_secuencial operacion.transaccion_ws_inv_adc.idtransaccion%type;
  lv_ip            operacion.transaccion_ws_inv_adc.ip%type;

BEGIN
  IF :new.idtransaccion  IS NULL THEN
    select operacion.sq_id_trs_inv_adc.nextval
      into ln_id_secuencial
      from dual;
    :new.idtransaccion  := ln_id_secuencial;
  end if;

  if :new.ip IS NULL
    THEN SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
    :new.ip := lv_ip;
END IF;
END;
/