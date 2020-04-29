CREATE OR REPLACE TRIGGER OPERACION.T_CAB_INV_ADC_BU
BEFORE UPDATE ON  OPERACION.CAB_INVENTARIO_ENV_ADC
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Version     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   -------------------  -----------------    --------------------------------------
     1.0      03/10/2016   Justiniano Condori   Lizbeth Portella     
 **********************************************************************************************************/
DECLARE
lv_ip operacion.cab_inventario_env_adc.ipmod%type;
BEGIN
  SELECT sys_context('userenv','ip_address') into lv_ip from dual;

  :new.ipmod := lv_ip;
  :new.usumod := user;
  :new.fecmod  := sysdate;
END;
/