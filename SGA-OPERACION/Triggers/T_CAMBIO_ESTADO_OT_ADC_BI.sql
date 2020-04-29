CREATE OR REPLACE TRIGGER OPERACION.T_CAMBIO_ESTADO_OT_ADC_BI
  BEFORE INSERT ON OPERACION.CAMBIO_ESTADO_OT_ADC
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/**********************************************************************************************************
  REVISIONES:
   Versión     Fecha         Autor              Solicitado por             Descripcion
  ---------  -----------   ----------------     -----------------    ----------------------------------
     1.0      11/05/2015   Jorge Rivas         NALDA AROTINCO         PROY-17652 Adm Manejo de Cuadrillas
 **********************************************************************************************************/
DECLARE
  ln_secuencia   operacion.cambio_estado_ot_adc.secuencia%type;
BEGIN
  IF :new.secuencia IS NULL THEN
    SELECT operacion.seq_cambio_estado_ot_adc.nextval
      INTO ln_secuencia
      FROM dual;

    :new.secuencia := ln_secuencia;
  END IF;
END;
/
