  
      DELETE FROM OPERACION.PARAMETRO_DET_ADC
       WHERE ID_PARAMETRO IN
             (SELECT A.ID_PARAMETRO
                FROM OPERACION.PARAMETRO_CAB_ADC A
               WHERE A.ABREVIATURA = 'ACTIVACION_ETA');
               
      DELETE FROM OPERACION.PARAMETRO_CAB_ADC A
       WHERE A.ABREVIATURA = 'ACTIVACION_ETA';
       commit;
/