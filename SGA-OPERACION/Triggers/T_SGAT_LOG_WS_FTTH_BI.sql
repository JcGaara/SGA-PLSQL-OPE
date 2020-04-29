CREATE OR REPLACE TRIGGER OPERACION.T_SGAT_LOG_WS_FTTH_BI
  BEFORE INSERT ON OPERACION.SGAT_LOG_WS_FTTH
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Steve Panduro
  ************************************************************************/

/************************************************************************************************
  *Tipo               : Trigger
  *Descripci?n        : Obtiene El secuencial
  *Autor              : Steve Panduro

  ************************************************************************************************/

DECLARE
  ln_id_secuencial operacion.SGAT_LOG_WS_FTTH.sgatn_idtransaccion%type;
  lv_ip            operacion.SGAT_LOG_WS_FTTH.sgatv_ip%type;

BEGIN
  IF :new.sgatn_idtransaccion  IS NULL THEN
    select operacion.SEQ_SGAT_LOG_WS_FTTH.nextval
      into ln_id_secuencial
      from dual;
    :new.sgatn_idtransaccion  := ln_id_secuencial;
  end if;

  if :new.sgatv_ip IS NULL
    THEN SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
    :new.sgatv_ip := lv_ip;
END IF;
END;
/