CREATE OR REPLACE TRIGGER OPERACION.T_MATRIZ_TYSTIPSRV_TIPTRA_BU
  BEFORE UPDATE ON OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC
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
  *Proyecto o REQ     : PQT-235788-TSK-70790 Adm Manejo de Cuadrillas
  *Fecha de Creaci?n  : 06/05/2015
  ************************************************************************************************/
declare
  lv_ip operacion.matriz_tystipsrv_tiptra_adc.ipmod%type;

BEGIN
  SELECT sys_context('userenv', 'ip_address') into lv_ip from dual;

  :new.ipmod  := lv_ip;
  :new.usumod := user;
  :new.fecmod := sysdate;
END;
/
