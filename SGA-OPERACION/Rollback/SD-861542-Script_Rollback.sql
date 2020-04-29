drop table OPERACION.LOG_INST_EQUIPO_HFC;
ALTER TABLE  OPERACION.AGENDAMIENTO DROP COLUMN flg_relanzar;   
  
UPDATE OPERACION.PARAMETRO_DET_ADC D
SET D.CODIGON = 0
 WHERE D.ESTADO = 1
   AND D.ID_PARAMETRO =
       (SELECT C.ID_PARAMETRO
          FROM OPERACION.PARAMETRO_CAB_ADC C
         WHERE C.ESTADO = 1
           AND C.ABREVIATURA = 'VALIDA_ORDEN_ADC');
commit;
/