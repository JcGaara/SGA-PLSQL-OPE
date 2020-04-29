DROP TRIGGER operacion.sgat_act_incognito_log_bi;
DROP TABLE operacion.sgat_act_incognito_log;

DECLARE
  li_tipopedd NUMBER;
BEGIN
  BEGIN
    SELECT tipopedd
      INTO li_tipopedd
      FROM operacion.tipopedd
     WHERE descripcion = 'Tarea Prediagnotico'
       AND abrev = 'TASKPREDIAG';
  EXCEPTION
    WHEN no_data_found THEN
      li_tipopedd := 0;
    WHEN OTHERS THEN
      li_tipopedd := 0;
  END;
  IF li_tipopedd > 0 THEN
    DELETE FROM operacion.tipopedd WHERE tipopedd = li_tipopedd;
    DELETE FROM operacion.opedd WHERE tipopedd = li_tipopedd;
  END IF;
  COMMIT;
END;
/

ALTER TABLE operacion.sgat_importacion_masiva_det
DROP COLUMN impdn_idzona
/