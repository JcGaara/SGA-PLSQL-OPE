CREATE OR REPLACE TRIGGER OPERACION.T_ZONA_ADC_BU
  BEFORE UPDATE ON OPERACION.ZONA_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/***********************************************************************
  REVISIONES:
   Versi?n     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      06/05/2015   Steve Panduro         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
  ************************************************************************/
declare
  lv_ip operacion.zona_adc.ipmod%type;

BEGIN
  SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;

  :new.ipmod  := lv_ip;
  :new.usumod := user;
  :new.fecmod := sysdate;
END;
/
