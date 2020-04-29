CREATE OR REPLACE TRIGGER OPERACION.T_CAB_INV_ADC_BI
BEFORE INSERT ON  OPERACION.CAB_INVENTARIO_ENV_ADC
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Version     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   -------------------  -----------------    --------------------------------------
     1.0      03/10/2016   Justiniano Condori   Lizbeth Portella     
 **********************************************************************************************************/
DECLARE
lv_ip operacion.cab_inventario_env_adc.ipreg%type;
BEGIN
  SELECT sys_context('userenv','ip_address') into lv_ip from dual;

  :new.ipreg := lv_ip;
  :new.usureg := user;
  :new.fecreg  := sysdate;
END;
/