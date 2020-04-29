CREATE OR REPLACE TRIGGER operacion.T_MATERIALES_SERVICIOS_ADC_BU
  BEFORE UPDATE ON operacion.MATERIALES_SERVICIOS_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE       T_MATERIALES_SERVICIOS_ADC_BU
    REVISIONES
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        03032016  Lizbeth Portella     Lizbeth Portella   PROY-22818 IDEA-28605 Administración y manejo de cuadrillas - TOA Fase 2 
***********************************************************************************************************************************/

DECLARE
lv_ip operacion.MATERIALES_SERVICIOS_ADC.ipmod%type;
 
BEGIN
  SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;
  :new.ipmod  := lv_ip;
  :new.fecmod := SYSDATE;
  :new.usumod := USER;
END;
/