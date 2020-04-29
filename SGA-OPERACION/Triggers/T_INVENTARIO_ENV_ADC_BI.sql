CREATE OR REPLACE TRIGGER operacion.T_INVENTARIO_ENV_ADC_BI
  BEFORE INSERT ON operacion.inventario_env_adc
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       t_inventario_env_adc_bi
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        15/06/2015  Luis Polo        NALDA AROTINCO        REQ-00000-Administración Manejo de Cuadrillas (EtaDirect)
  ***********************************************************************************************************************************/

BEGIN
  IF :new.id_inventario IS NULL THEN
    SELECT operacion.sq_inventario_env_adc.nextval
      INTO :new.id_inventario
      FROM dummy_atc;
  END IF;
END;
/