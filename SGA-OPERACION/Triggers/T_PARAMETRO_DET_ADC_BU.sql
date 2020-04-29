CREATE OR REPLACE TRIGGER OPERACION.T_PARAMETRO_DET_ADC_BU
BEFORE UPDATE ON  OPERACION.PARAMETRO_DET_ADC
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Version     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Jorge Rivas          NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
 **********************************************************************************************************/
DECLARE
lv_ip operacion.parametro_det_adc.ipmod%type;
BEGIN
  SELECT sys_context('userenv','ip_address') into lv_ip from dual;

  :new.ipmod := lv_ip;
  :new.usumod := user;
  :new.fecmod  := sysdate;
END;
/
