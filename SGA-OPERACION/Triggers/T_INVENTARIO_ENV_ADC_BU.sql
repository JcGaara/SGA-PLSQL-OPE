CREATE OR REPLACE TRIGGER operacion.T_INVENTARIO_ENV_ADC_BU
  BEFORE UPDATE ON operacion.inventario_env_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE       t_inventario_env_adc_bu
    REVISIONES
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        15062015  Luis Polo        NALDA AROTINCO        REQ-00000-Administración Manejo de Cuadrillas (EtaDirect)
***********************************************************************************************************************************/

  

BEGIN
  :new.fecmod := SYSDATE;
  :new.usumod := USER;
END;
/