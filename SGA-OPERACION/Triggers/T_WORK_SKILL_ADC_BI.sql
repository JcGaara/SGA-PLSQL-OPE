CREATE OR REPLACE TRIGGER OPERACION.T_WORK_SKILL_ADC_BI
  BEFORE INSERT ON OPERACION.WORK_SKILL_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      06/05/2015   Steve Panduro         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/

/************************************************************************************************
  *Tipo               : Trigger
  *Descripci?n        : Obtiene El secuencial
  *Autor              : Steve Panduro
  *Proyecto o REQ     : PQT-235788-TSK-70790   Adm Manejo de Cuadrillas
  *Fecha de Creaci?n  : 06/05/2015
  ************************************************************************************************/

DECLARE
  ln_id_secuencial operacion.work_skill_adc.id_work_skill%type;
  lv_ip            operacion.work_skill_adc.ipcre%type;

BEGIN
  IF :new.id_work_skill  IS NULL THEN
    select operacion.seq_work_skill_adc.nextval
      into ln_id_secuencial
      from dual;
    :new.id_work_skill  := ln_id_secuencial;
  end if;

  if :new.ipcre IS NULL
    THEN SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
    :new.ipcre := lv_ip;
END IF;
END;
/
