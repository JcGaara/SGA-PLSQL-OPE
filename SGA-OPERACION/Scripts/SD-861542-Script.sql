ALTER TABLE OPERACION.AGENDAMIENTO
ADD flg_relanzar  NUMBER(1) default 0;
COMMENT ON COLUMN OPERACION.AGENDAMIENTO.flg_relanzar  IS 'Flag que indica que la orden se relanzo';

UPDATE OPERACION.PARAMETRO_DET_ADC D
SET D.CODIGON = 1
 WHERE D.ESTADO = 1
   AND D.ID_PARAMETRO =
       (SELECT C.ID_PARAMETRO
          FROM OPERACION.PARAMETRO_CAB_ADC C
         WHERE C.ESTADO = 1
           AND C.ABREVIATURA = 'VALIDA_ORDEN_ADC');
commit;
/