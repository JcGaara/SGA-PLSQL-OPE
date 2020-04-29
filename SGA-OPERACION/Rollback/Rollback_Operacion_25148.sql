-----------------------------------------------------------------------------------
-- eliminar columnas a la Tabla OPERACION.PARAMETRO_VTA_PVTA_ADC
ALTER TABLE OPERACION.PARAMETRO_VTA_PVTA_ADC
      DROP COLUMN PVPAC_FLAG_SOL_CLI;
      
COMMIT;      
-----------------------------------------------------------------------------------
-- delete parametros etadirect
DELETE from opedd o
where o.tipopedd = (select tipopedd from tipopedd where abrev = 'etadirect')
and o.abreviacion = 'mensaje_agen_default';

DELETE from opedd o
where o.tipopedd = (select tipopedd from tipopedd where abrev = 'etadirect')
and o.abreviacion = 'estado_agen_default';

DELETE from opedd o
where o.tipopedd = (select tipopedd from tipopedd where abrev = 'etadirect')
and o.abreviacion = 'mensaje_reagen_default';

DELETE from opedd o
where o.tipopedd = (select tipopedd from tipopedd where abrev = 'etadirect')
and o.abreviacion = 'Time_slot_franja';

COMMIT;
-----------------------------------------------------------------------------------
-- delete de parametros tipo, subtipo, skill
DELETE FROM operacion.tipo_orden_adc t
WHERE t.id_tipo_orden =
      (SELECT t.id_tipo_orden
       FROM operacion.tipo_orden_adc t
       WHERE t.cod_tipo_orden = 'HFCME'
       AND t.descripcion = 'HFC MANTENIMIENTO ESPECIAL');

DELETE FROM operacion.work_skill_adc t
WHERE t.id_work_skill =
      (SELECT t.id_work_skill
       FROM operacion.work_skill_adc t
       WHERE t.cod_work_skill = 'HFCME'
       AND t.descripcion = 'HFC - MANTENIMIENTO ESPECIAL');
       
DELETE FROM operacion.subtipo_orden_adc t
WHERE t.cod_subtipo_orden = 'HFCME'
AND t.descripcion = 'MANTENIMIENTO HFC ESPECIAL';

DELETE FROM operacion.franja_horaria WHERE codigo = 'PM4';

COMMIT;
