CREATE OR REPLACE TRIGGER operacion.T_MATERIALES_SERVICIOS_ADC_BI
  BEFORE INSERT ON operacion.MATERIALES_SERVICIOS_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_MATERIALES_SERVICIOS_ADC_BI
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        03/03/2016  Lizbeth Portella  Lizbeth Portella  PROY-22818 IDEA-28605 Administración y manejo de cuadrillas - TOA Fase 2
  ***********************************************************************************************************************************/
DECLARE
ln_id_secuencial operacion.MATERIALES_SERVICIOS_ADC.id_mat_serv%type;
lv_ip            operacion.MATERIALES_SERVICIOS_ADC.ipcre%type;

BEGIN
    IF :new.id_mat_serv  IS NULL THEN
    select operacion.seq_materiales_servicios_adc.nextval
      into ln_id_secuencial
      from dual;
    :new.id_mat_serv  := ln_id_secuencial;
  end if;
  
  
  if :new.ipcre IS NULL
    THEN SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
    :new.ipcre := lv_ip;
END IF;

END;
/