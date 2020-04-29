CREATE OR REPLACE TRIGGER OPERACION.T_TRANSACCION_WS_ADC_BI
  BEFORE INSERT ON OPERACION.TRANSACCION_WS_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Steve Panduro         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/

/************************************************************************************************
  *Tipo               : Trigger
  *Descripci?n        : Obtiene El secuencial
  *Autor              : Steve Panduro
  *Proyecto o REQ     : PQT-235788-TSK-70790   Adm Manejo de Cuadrillas
  *Fecha de Creaci?n  : 06/05/2015
  ************************************************************************************************/

DECLARE
  ln_id_secuencial operacion.transaccion_ws_adc.idtransaccion%type;
  lv_ip            operacion.transaccion_ws_adc.ip%type;

BEGIN
  IF :new.idtransaccion  IS NULL THEN
    select operacion.seq_transaccion_ws_adc.nextval
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

