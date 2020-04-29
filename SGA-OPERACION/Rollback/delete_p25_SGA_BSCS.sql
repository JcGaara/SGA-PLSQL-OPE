DELETE FROM operacion.opedd WHERE TIPOPEDD in
(SELECT TIPOPEDD FROM operacion.tipopedd WHERE ABREV = 'TAREADEF_SRB' AND DESCRIPCION='Tarea Baja, Suspension, Recone');

DELETE FROM operacion.tipopedd WHERE ABREV = 'TAREADEF_SRB' AND DESCRIPCION='Tarea Baja, Suspension, Recone';

commit;