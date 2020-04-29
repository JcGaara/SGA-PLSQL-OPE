ALTER TABLE operacion.PARAMETRO_DET_ADC
   ADD CONSTRAINT fk_parm_cab_ref_parm_det FOREIGN KEY (id_parametro)
      REFERENCES operacion.parametro_cab_adc (id_parametro);
