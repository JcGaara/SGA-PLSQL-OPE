CREATE OR REPLACE TRIGGER OPERACION.T_ZONA_ADC_BI
  BEFORE INSERT ON OPERACION.ZONA_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      06/05/2015   Steve Panduro         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/

DECLARE
  ln_id_secuencial operacion.zona_adc.idzona %type;
  lv_ip            operacion.zona_adc.ipcre%type;

BEGIN
  IF :new.idzona  IS NULL THEN
    select operacion.seq_id_zona_adc.nextval 
      into ln_id_secuencial
      from dual;
	  
    :new.idzona  := ln_id_secuencial;
  end if;

  if :new.ipcre IS NULL THEN 
    SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
    :new.ipcre := lv_ip;
  END IF;
END;
/
