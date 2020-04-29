
-- Script_operacion_INC000000892040
---------------------------------------------------------
-- parametros rechazadas caso 1
---------------------------------------------------------
insert into operacion.tipopedd ( descripcion, abrev) values ('CONFIGURACION SGA_ANULA_SOTS', 'SGA_ANULA_SOTS_RECHAZADAS_1');   

-- TIPTRA_1
insert into operacion.opedd (codigon, descripcion, tipopedd) values (658,'TIPTRA_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (678,'TIPTRA_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (676,'TIPTRA_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (427,'TIPTRA_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (695,'TIPTRA_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));

-- NRO_DIAS_1
insert into operacion.opedd (codigon, descripcion, tipopedd) values (30,'NRO_DIAS_1', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_1'));

---------------------------------------------------------
-- parametros rechazadas caso 2
---------------------------------------------------------
insert into operacion.tipopedd ( descripcion, abrev) values ('CONFIGURACION SGA_ANULA_SOTS', 'SGA_ANULA_SOTS_RECHAZADAS_2');   
 
-- ESTSOL_2
insert into operacion.opedd (codigon, descripcion, tipopedd) values (12,'ESTSOL_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (29,'ESTSOL_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));

-- TIPTRA_2
insert into operacion.opedd (codigon, descripcion, tipopedd) values (658,'TIPTRA_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (678,'TIPTRA_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (676,'TIPTRA_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (427,'TIPTRA_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (695,'TIPTRA_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));

-- NRO_DIAS_2
insert into operacion.opedd (codigon, descripcion, tipopedd) values (5,'NRO_DIAS_2', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_RECHAZADAS_2'));

---------------------------------------------------------
-- parametros aprobadas
---------------------------------------------------------
insert into operacion.tipopedd ( descripcion, abrev) values ('CONFIGURACION SGA_ANULA_SOTS', 'SGA_ANULA_SOTS_APROBADAS');   

-- ESTSOL_3
insert into operacion.opedd (codigon, descripcion, tipopedd) values (11,'ESTSOL_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));

-- TIPTRA_3
insert into operacion.opedd (codigon, descripcion, tipopedd) values (658,'TIPTRA_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (678,'TIPTRA_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (676,'TIPTRA_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (427,'TIPTRA_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));
insert into operacion.opedd (codigon, descripcion, tipopedd) values (695,'TIPTRA_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));

-- NRO_DIAS_3
insert into operacion.opedd (codigon, descripcion, tipopedd) values (30,'NRO_DIAS_3', (select tipopedd from operacion.tipopedd where abrev = 'SGA_ANULA_SOTS_APROBADAS'));

commit;

---------------------------------------------------------
-- configuracion wheres dinamicos
---------------------------------------------------------
-- ope_config_accion_janus 
       
-- RECHAZADAS_1_WHERE
insert into operacion.ope_config_accion_janus (tip_svr, estado, sentencia) values ('RECHAZADAS_1_WHERE','A','  WHERE s.estsol = e.estsol
         and e.tipestsol = 7       
         and s.cod_id is not null
         and s.customer_id is not null
         and s.tiptra in (SELECT o.codigon 
                            FROM operacion.opedd o
                           WHERE o.tipopedd =(SELECT t.tipopedd
                                                FROM operacion.tipopedd t
                                               WHERE t.abrev = ''SGA_ANULA_SOTS_RECHAZADAS_1'')
                             and o.descripcion = ''TIPTRA_1'')
         and (trunc(sysdate) - trunc(s.FECULTEST)) >= (SELECT o.codigon 
                                                         FROM operacion.opedd o
                                                        WHERE o.tipopedd = (SELECT t.tipopedd
                                                                              FROM operacion.tipopedd t
                                                                             WHERE t.abrev = ''SGA_ANULA_SOTS_RECHAZADAS_1'')
                                                                               and o.descripcion = ''NRO_DIAS_1'')   ');

-- RECHAZADAS_2_WHERE
insert into operacion.ope_config_accion_janus (tip_svr, estado, sentencia) values ('RECHAZADAS_2_WHERE','A',' WHERE s.estsol = e.estsol
         and e.tipestsol = 7   
         and exists (SELECT k.codsolot
                       FROM solot K
                      WHERE s.tiptra = k.tiptra
                        and s.customer_id = k.customer_id
                        and s.codsolot < k.codsolot 
                        and k.estsol in (SELECT o.codigon   
                                           FROM operacion.opedd o
                                          WHERE o.tipopedd = (SELECT t.tipopedd
                                                                FROM operacion.tipopedd t
                                                               WHERE t.abrev = ''SGA_ANULA_SOTS_RECHAZADAS_2'')
                                            and o.descripcion = ''ESTSOL_2''))
         and s.customer_id is not null
         and s.cod_id is not null
         and s.tiptra is not null
         and s.tiptra in (SELECT o.codigon   
                            FROM operacion.opedd o
                           WHERE o.tipopedd =  (SELECT t.tipopedd
                                                  FROM operacion.tipopedd t
                                                 WHERE t.abrev = ''SGA_ANULA_SOTS_RECHAZADAS_2'')
                             and o.descripcion = ''TIPTRA_2'')
         and (trunc(sysdate) - trunc(s.FECULTEST)) >=  (SELECT o.codigon   
                                                          FROM operacion.opedd o
                                                         WHERE o.tipopedd = (SELECT t.tipopedd
                                                                               FROM operacion.tipopedd t
                                                                              WHERE t.abrev = ''SGA_ANULA_SOTS_RECHAZADAS_2'')
                                                                                and o.descripcion = ''NRO_DIAS_2'')    ');

-- APROBADAS_WHERE
insert into operacion.ope_config_accion_janus (tip_svr, estado, sentencia) values ('APROBADAS_WHERE','A',' WHERE cod_id is null
         and customer_id is null
         and s.estsol in (SELECT o.codigon 
                            FROM operacion.opedd o
                           WHERE o.tipopedd =(SELECT t.tipopedd
                                                FROM operacion.tipopedd t
                                               WHERE t.abrev = ''SGA_ANULA_SOTS_APROBADAS'')
                             and o.descripcion = ''ESTSOL_3'')
         and s.tiptra in (SELECT o.codigon 
                            FROM operacion.opedd o
                           WHERE o.tipopedd =(SELECT t.tipopedd
                                                FROM operacion.tipopedd t
                                               WHERE t.abrev = ''SGA_ANULA_SOTS_APROBADAS'')
                             and o.descripcion = ''TIPTRA_3'')
         and (trunc(sysdate) - trunc(s.FECUSU)) >= (SELECT o.codigon 
                                                      FROM operacion.opedd o
                                                     WHERE o.tipopedd =  (SELECT t.tipopedd
                                                                            FROM operacion.tipopedd t
                                                                           WHERE t.abrev = ''SGA_ANULA_SOTS_APROBADAS'')
                                                       and o.descripcion = ''NRO_DIAS_3'')    ');

commit;
---------------------------------------------------------
              