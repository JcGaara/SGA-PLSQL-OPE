DELETE operacion.opedd op
 WHERE op.abreviacion IN ('AREA_CPLAN','ACT_CPLAN2')
   AND op.tipopedd = (SELECT tipopedd
                        FROM operacion.tipopedd b
                       WHERE B.ABREV = 'CONF_WLLSIAC_CP');
					   
UPDATE opewf.tareadef
   SET pre_proc = ''
 WHERE tareadef = (SELECT tareadef
                     FROM tareadef
                    WHERE descripcion = 'Cambio de Plan JANUS');

commit;
/