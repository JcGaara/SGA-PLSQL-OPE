insert into opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (325, 'AREA DE OPERACIONES', 'AREA_CPLAN', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_WLLSIAC_CP'));

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('0', 'Act/Desact de Cambios CP-HFC/LTE', 'ACT_CPLAN2', (SELECT tipopedd FROM operacion.tipopedd b where B.ABREV ='CONF_WLLSIAC_CP'), null);

UPDATE opewf.tareadef
   SET pre_proc = 'operacion.pq_siac_cambio_plan.SGASI_REGISTRO_JANUS'
 WHERE tareadef = (SELECT tareadef
                     FROM tareadef
                    WHERE descripcion = 'Cambio de Plan JANUS');

commit;
/