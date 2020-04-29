-- Configuración del opedd
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('', 3, 'Nivel Servicio', 'SERVICIO', (select tipopedd from tipopedd where abrev = 'TIP_CONF_CORTE'));


-- Configuración Plantilla de SOT

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (46, 'Local IP Data - Suspension del Servicio por Falta de Pago', 3, 13, '0005', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (47, 'Local IP Data - Corte del Servicio por Falta de Pago', 349, 13, '0005', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (48, 'Local IP Data - Baja del Servicio por Falta de Pago', 5, 37, '0005', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (49, 'Local IP Data - Reconexion por Suspension Falta de Pago', 4, 126, '0005', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 10:55:30', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (50, 'Local IP Data - Reconexion por Corte Falta de Pago', 4, 126, '0005', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (51, 'Acceso Dedicado a Internet - Suspension del Servicio por Falta de Pago', 3, 13, '0006', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (52, 'Acceso Dedicado a Internet - Corte del Servicio por Falta de Pago', 349, 13, '0006', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (53, 'Acceso Dedicado a Internet - Baja del Servicio por Falta de Pago', 5, 37, '0006', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:04:26', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (54, 'Acceso Dedicado a Internet - Reconexion por Suspension de Falta de Pago', 4, 126, '0006', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (55, 'Acceso Dedicado a Internet - Reconexion por Corte de Falta de Pago', 4, 126, '0006', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (56, 'Domestic IP Data - Suspension del Servicio por Falta de Pago', 3, 13, '0014', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (57, 'Domestic IP Data - Corte del Servicio por Falta de Pago', 349, 13, '0014', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (58, 'Domestic IP Data - Baja del Servicio por Falta de Pago', 5, 37, '0014', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (59, 'Domestic IP Data - Reconexion por Suspension por Falta de Pago', 4, 126, '0014', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:13:58', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (60, 'Domestic IP Data - Reconexion por Corte por Falta de Pago', 4, 126, '0014', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:18:20', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:18:20', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (61, 'Hosting - Suspension del Servicio por Falta de Pago', 3, 13, '0018', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (62, 'Hosting - Corte del Servicio por Falta de Pago', 349, 13, '0018', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (63, 'Hosting - Baja del Servicio por Falta de Pago', 5, 37, '0018', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (64, 'Hosting - Reconexion por Suspension de Falta de Pago', 4, 126, '0018', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (65, 'Hosting - Reconexion por Corte de Falta de Pago', 4, 126, '0018', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:25:52', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (66, 'International IP Data - Suspension del Servicio por Falta de Pago', 3, 13, '0019', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 11:39:15', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:39:15', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (67, 'International IP Data - Corte del Servicio por Falta de Pago', 349, 13, '0019', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 11:43:05', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:43:05', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (68, 'International IP Data - Baja del Servicio por Falta de Pago', 5, 37, '0019', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (69, 'International IP Data - Reconexion por Suspension de Falta de Pago', 4, 126, '0019', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (70, 'International IP Data - Reconexion por Corte de Falta de Pago', 4, 126, '0019', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (71, 'International Private Lines - Suspension del Servicio por Falta de Pago', 3, 13, '0022', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:49:04', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (72, 'International Private Lines - Corte del Servicio por Falta de Pago', 349, 13, '0022', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (73, 'International Private Lines - Baja del Servicio por Falta de Pago', 5, 37, '0022', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (74, 'International Private Lines - Reconexion por Suspension de Falta de Pago', 4, 126, '0022', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (75, 'International Private Lines - Reconexion por Corte de Falta de Pago', 4, 126, '0022', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 11:54:17', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (76, 'Local Private Lines - Suspension del Servicio por Falta de Pago', 3, 13, '0036', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (77, 'Local Private Lines - Corte del Servicio por Falta de Pago', 349, 13, '0036', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (78, 'Local Private Lines - Baja del Servicio por Falta de Pago', 5, 37, '0036', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (79, 'Local Private Lines - Reconexion por Suspension de Falta de Pago', 4, 126, '0036', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (80, 'Local Private Lines - Reconexion por Corte de Falta de Pago', 4, 126, '0036', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:04:12', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (81, 'Red Privada Virtual International - Suspension del Servicio por Falta de Pago', 3, 13, '0049', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (82, 'Red Privada Virtual International - Corte del Servicio por Falta de Pago', 349, 13, '0049', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (83, 'Red Privada Virtual International - Baja del Servicio por Falta de Pago', 5, 37, '0049', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (84, 'Red Privada Virtual International - Reconexion por Suspension de Falta de Pago', 4, 126, '0049', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (85, 'Red Privada Virtual International - Reconexion por Corte de Falta de Pago', 4, 126, '0049', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:10:19', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (86, 'Red Privada Virtual Local - Suspension del Servicio por Falta de Pago', 3, 13, '0052', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (87, 'Red Privada Virtual Local - Corte del Servicio por Falta de Pago', 349, 13, '0052', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (88, 'Red Privada Virtual Local - Baja del Servicio por Falta de Pago', 5, 37, '0052', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (89, 'Red Privada Virtual Local - Reconexion por Suspension de Falta de Pago', 4, 126, '0052', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (90, 'Red Privada Virtual Local - Reconexion por Corte de Falta de Pago', 4, 126, '0052', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:16:21', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (91, 'Red Privada Virtual Nacional - Suspension del Servicio por Falta de Pago', 3, 13, '0053', 0, 201, '3', 1, 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (92, 'Red Privada Virtual Nacional - Corte del Servicio por Falta de Pago', 349, 13, '0053', 0, 201, '349', 1, 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (93, 'Red Privada Virtual Nacional - Baja del Servicio por Falta de Pago', 5, 37, '0053', 0, 201, '5', 1, 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (94, 'Red Privada Virtual Nacional - Reconexion por Suspension de Falta de Pago', 4, 126, '0053', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss')); 

insert into OPE_PLANTILLASOT (IDPLANSOT, DESCRIPCION, TIPTRA, MOTOT, TIPSRV, DIASFECCOM, AREASOL, TIPTRAMAN, ESTADO, USUREG, FECREG, USUMOD, FECMOD )
values (95, 'Red Privada Virtual Nacional - Reconexion por Corte de Falta de Pago', 4, 126, '0053', 0, 201, '126', 1, 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss'), 'EASTULLE', to_date('07-05-2012 12:23:43', 'dd-mm-yyyy hh24:mi:ss')); 


COMMIT;