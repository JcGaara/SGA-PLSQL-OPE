INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CANH'), 'HFCBD','DESCONEXIÓN - ACOMETIDA HFC','15','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'BACT'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CAND'), 'DTHBR','RETIRO EQUIPOS DTH','15','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'BARD'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CANH'), 'HFCBR','RETIRO EQUIPOS HFC','20','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'BART'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHI'), 'DTHI2','MENOR IGUAL 2 DECOS','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHI'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHI'), 'DTHI3','MAYOR 2 DECOS','240','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHI'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHM'), 'DTHMM','MANTENIMIENTO DTH','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHM'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHP'), 'DTHPP','POST VENTA PREPAGO','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHP'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHP'), 'DTHNR','NO RETIRO DE EQUIPOS','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHP'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'DTHP'), 'DTHRE','RETIRO EQUIPOS','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHP'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC01','3PLAY 1 CABLE (MENOR IGUAL 2 DECOS)','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC02','3PLAY 1 CABLE (MAYOR A 2 DECOS)','180','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC03','3PLAY 1 INTERNET','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC04','3PLAY 1 TELEFONÍA FIJA','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC05','3PLAY 2 CABLE INTERNET (MENOR IGUAL 2 DECOS)','150','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC06','3PLAY 2 CABLE INTERNET (MAYOR A 2 DECOS)','210','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC07','3PLAY 2 CABLE TELÉFONO (MENOR IGUAL 2 DECOS)','150','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC09','3PLAY 2 INTERNET TELÉFONO','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC10','3PLAY 3 CABLE INTERNET TELÉFONO (MENOR IGUAL 2 DECOS)','150','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCM'), 'HFCMM','MANTENIMIENTO HFC','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCM'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'ANAB'), 'ANBAD','DESCONEXIÓN - ACOMETIDA ANALÓGICA','15','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'BACA'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'ANAI'), 'ANINI','INSTALACIÓN ANALÓGICA','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'ANAIJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'ANAP'), 'ANPOR','RECONEXIÓN ANALÓGICA','30','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'ANAIJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC08','3PLAY 2 CABLE TELÉFONO (MAYOR A 2 DECOS)','210','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CANT'), 'TPIBR','RETIRO EQUIPOS TPI','20','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHI'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'TPII'), 'TPIII','INSTALACIÓN TPI','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'TPII'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'TPIM'), 'TPIMM','MANTENIMIENTO TPI','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'TPIM'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'TPIP'), 'TPIPP','POST VENTA TPI','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'TPIP'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CAND'), 'DTHBD','DESCONEXIÓN - ACOMETIDA DTH','20','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'BACD'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ2','POSTVENTA HFC - INSTALAR INTERNET','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ3','POSTVENTA HFC - INSTALAR TELEFONÍA','90','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ4','POSTVENTA HFC - DECOS ADICIONALES','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ5','POSTVENTA HFC - VENTA COMPLEMENTARIA','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ6','POSTVENTA HFC - RETIRO DECODIFICADORES','30','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ7','POSTVENTA HFC - TRASLADOS','120','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPS'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CANT'), 'TPIBD','DESCONEXIÓN - ACOMETIDA TPI','20','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'DTHI'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCP'), 'HFCJ1','POST-VENTA HFC','60','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCPJ'), NULL );
INSERT INTO operacion.subtipo_orden_adc
(id_tipo_orden, cod_subtipo_orden, descripcion, tiempo_min, estado, id_work_skill, grado_dificultad)
VALUES ((SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'HFCI'), 'HFC11','3PLAY 3 CABLE INTERNET TELÉFONO (MAYOR A 2 DECOS)','210','0',(select id_work_skill from  operacion.work_skill_adc   where cod_work_skill = 'HFCIS'), NULL );

commit;