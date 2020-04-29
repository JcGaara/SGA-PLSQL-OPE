insert into tipopedd 
(DESCRIPCION, ABREV)
values ('MIGRACION SGA A BSCS', 'MIGR_SGA_BSCS');

COMMIT;

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'SUSPENSI%N DEL SERVICIO'), 
'SUSPENSIÓN DEL SERVICIO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'SUSPENSI%N DEL SERVICIO PAQUETES'), 
'SUSPENSION DEL SERVICIO PAQUETES', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'HFC - SUSPENSI%N DEL SERVICIO') , 
'HFC - SUSPENSIÓN DEL SERVICIO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) = 'CORTE DEL SERVICIO') , 
'CORTE DEL SERVICIO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) = 'HFC - CORTE POR FALTA DE PAGO') , 
'HFC - CORTE POR FALTA DE PAGO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) = 'BAJA TOTAL DEL SERVICIO') , 
'BAJA TOTAL DEL SERVICIO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) = 'HFC - BAJA TOTAL DE SERVICIO') , 
'HFC - BAJA TOTAL DE SERVICIO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));  

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) = 'HFC - MANTENIMIENTO')  , 
'HFC - MANTENIMIENTO', 'TSOTS_VALIDA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS')); 

commit;

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'RECONEXI%N')  ,'RECONEXION', 'TSOTS_CERRADA', 
(Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS')); 

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'RECONEXI%N DEL SERVICIO PAQUETES'), 
'RECONEXION DEL SERVICIO PAQUETES', 'TSOTS_CERRADA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));    

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from tiptrabajo where upper(trim(descripcion)) like 'HFC - RECONEXI%N DE SERVICIO') , 
'HFC - RECONEXION DE SERVICIO', 'TSOTS_CERRADA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));     

COMMIT;

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( (select estsol from estsol where upper(trim(descripcion)) = 'CERRADA') , 
'Cerrada', 'ESTADO_SOT_EVAL', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));    

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select estsol from estsol where upper(trim(descripcion)) = 'APROBADO') , 
'Aprobado', 'ESTADO_SOT_APROB', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));  

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select estsol from estsol where upper(trim(descripcion)) = 'GENERADA') , 
'Generada', 'ESTADO_SOT_GEN', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select estsol from estsol where upper(trim(descripcion)) like 'EN EJECUCI%N') , 
'En Ejecucion', 'ESTADO_SOT_EJEC', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

COMMIT;

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select estinssrv from estinssrv where upper(trim(descripcion)) = 'ACTIVO') , 
'Activo', 'ESTADO_INSSRV', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));    

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select estinssrv from estinssrv where upper(trim(descripcion)) = 'SUSPENDIDO') , 
'Suspendido', 'ESTADO_INSSRV', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tipsrv from tystipsrv where upper(trim(dsctipsrv)) like 'TELEFON%A FIJA') , 
'Telefonia Fija', 'TIPOS_SERV', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tipsrv from tystipsrv where upper(trim(dsctipsrv)) = 'ACCESO DEDICADO A INTERNET') , 
'Acceso Dedicado a Internet', 'TIPOS_SERV', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tipsrv from tystipsrv where upper(trim(dsctipsrv)) = 'CABLE') , 
'Cable', 'TIPOS_SERV', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));
 
insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tipestsol from tipestsol where upper(trim(DESCRIPCION)) = 'RECHAZADA') , 
'Rechazada', 'TIPOS_EST_SOT', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tipestsol from tipestsol where upper(trim(DESCRIPCION)) = 'ANULADA') , 
'Anulada', 'TIPOS_EST_SOT', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  2 , 'Masivo SGA', 'TIPO_CLIENTE', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select tiptra from TIPTRABAJO where upper(trim(descripcion)) = 'HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT') , 
'HFC - BAJA ADMINISTRATIVA MIGRACION A SISACT', 'TIPO_BAJA_ADM', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS')); 

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (  (select codmotot from MOTOT where upper(trim(descripcion)) = 'HFC - BAJA ADMINISTRATIVA POR MIGRACION') , 
'HFC - BAJA ADMINISTRATIVA POR MIGRACION', 'MOTIVO_BAJA_ADM', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS')); 

COMMIT;

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (  (select tareadef from tareadef where upper(trim(descripcion)) = 'LIBERAR RECURSOS ASIGNADOS') , 
'Liberar recursos asignados', 'TAREAS_WF', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'),1);

insert into opedd (  CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (  (select tareadef from tareadef where upper(trim(descripcion)) like 'LIBERAR N%MEROS TELEF%NICOS') , 
'Liberar Numeros Telefonicos', 'TAREAS_WF', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'),2);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( '1', (select tareadef from tareadef where upper(trim(descripcion)) like 'ACTIVACI%N/DESACTIVACI%N DEL SERVICIO') , 
'Activacion/Desactivacion del servicio', 'TAREAS_WF', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'),3);


COMMIT;

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '1', (select t.tiptra from  tiptrabajo t where t.descripcion =  'HFC/SIAC MIGRACION SGA BSCS VISITA'),
'TIPTRA MIGRACION SGA BSCS VISITA', 'MIG_TIPTRA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '2', (select t.tiptra from  tiptrabajo t where t.descripcion =  'HFC/SIAC MIGRACION SGA BSCS SISTEMA'),
'TIPTRA MIGRACION SGA BSCS SISTEMA', 'MIG_TIPTRA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '1', 1147,'WF MIGRACION SGA BSCS VISITA', 'MIG_WF', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '2', (select t.wfdef from  wfdef t where t.descripcion = 'HFC/SIAC MIGRACION SGA BSCS SISTEMA'),
'WF MIGRACION SGA BSCS SISTEMA', 'MIG_WF', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( null, 4, 'ESTADO TAREA: CERRADA', 'PAR_ESTTAREA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( '5', null, 'TIPO INDICADOR MIGRACION SGA BSCS', 'TIP_INDMIGRA', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));


COMMIT; 

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6115', null, 'Paquete HBO (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5716', null, 'Paquete HBO Sat (II)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5715', null, 'Paquete HBO Sat (I)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AASB', null, 'Paquete HBO HD Plus', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7532', null, 'Paquete HBO + Moviecity + Adulto', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APSQ', null, 'Paquete HBO (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APQW', null, 'Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APQE', null, 'Mini Paquete HBO Max', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8069', null, 'CE Paquete HBO - Pack 2 (HD 10 Soles)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6749', null, 'Paquete HBO Referidos', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7483', null, 'CE Paquete HBO - Pack (MC + HD)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7480', null, 'Paquete HBO - Pack (HBO + MC)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9887', null, 'CE: Paquete HBO Básico', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQEA', null, 'Paquete HBO Max HD', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQDZ', null, 'Mini Paquete HBO Max', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APNY', null, 'Paquete HBO por Fidelización', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQAF', null, 'Mini Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APZD', null, 'Paquete HBO max hd', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APSY', null, 'Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9420', null, 'CE Mini Paquete HBO 2 (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9419', null, 'CE: Paquete HBO 2 (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9418', null, 'CE: Mini Paquete HBO  (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6963', null, 'Paquete HBO - 6', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6962', null, 'Paquete HBO - 3', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9906', null, 'CE: Paquete HBO Max', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8065', null, 'Paquete HBO - Pack 2 (HD 10 Soles)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6888', null, 'CE Paquete HBO (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9369', null, 'Mini Paquete HBO Max', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9368', null, 'Paquete HBO Max HD', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9367', null, 'Mini Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9758', null, 'Paquete HBO Navidad (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9362', null, 'MiniPaquete HBO 3Play', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0254', null, 'Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('0252', null, 'Mini Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9759', null, 'Paquete HBO Navidad 2 (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6155', null, 'Paquete HBO Colaborador', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APMY', null, 'Paquete HBO (Claro Club)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APNE', null, 'Paquete HBO (Claro Club)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APWP', null, 'Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AASX', null, 'Paquete HBO (Claro Club)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AEES', null, 'Mini Paquete HBO Max', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AEFH', null, 'Paquete HBO MAX', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AEJR', null, 'Paquete HBO (Single)', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AGAT', null, 'Mini Paquete HBO', 'CABLE_HBO', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AASW', null, 'Paquete FOX+ (Claro Club)', 'CABLE_FOX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9915', null, 'CE: Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7485', null, 'CE Paquete HD - Pack (MC+ HD)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8062', null, 'Paquete HD - Pack 2 (HD 10 soles)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9896', null, 'CE: Paquete HD Básico', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9008', null, 'Paquete HD Junio', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9009', null, 'CE Paquete HD Junio ', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6997', null, 'Paquete HD Colaborador', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APYZ', null, 'Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6971', null, 'Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8067', null, 'CE Paquete HD - Pack 2 (HD 10 Soles)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7482', null, 'Paquete HD - Pack (HBO + MC)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APQO', null, 'Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6989', null, 'CE Paquete HD (Single)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APSN', null, 'Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7836', null, 'Paquete HD 6', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7837', null, 'Paquete HD - Pack 6', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7838', null, 'CE Paquete HD 6', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('7839', null, 'CE Paquete HD - Pack 6', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AASC', null, 'Paquete HD Max Plus', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8306', null, 'Paquete HD Navidad', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8307', null, 'CE: Paquete HD Navidad', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APND', null, 'Paquete HD (Claro Club)', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APWQ', null, 'Paquete HD Max', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AEFC', null, 'Paquete HD Max
', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AOBY', null, 'Fidelizacion Paquete HD
', 'CABLE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9616', null, 'Servicio VOD - Retencion', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APZE', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9327', null, 'Servicio VOD Colab', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQDT', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8644', null, 'Servicios VOD gratuitos', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8645', null, 'Servicios VOD pago evento por evento ', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9270', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APQR', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APSO', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('8646', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APWR', null, 'Servicio VOD', 'CABLE_VOD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5161', null, 'Claro TV Max Digital (5 decos) 3Play', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6138', null, 'Claro TV Max Digital (2 decos) Colaborador', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6334', null, 'Up grade de Prime a Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5695', null, 'Claro TV Max Digital (5 decos) 3Play Colaborador', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5555', null, 'Claro TV - Upgrade a Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5847', null, 'Claro TV Max Digital (5 decos) 3Play Upgrade', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5894', null, 'Claro TV Max Digital (3 decos) 3Play', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5146', null, 'Claro TV Max Digital (5 decos)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5147', null, 'Claro TV Max Digital (3 decos)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5148', null, 'Claro TV Max Digital (2 decos)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5152', null, 'Claro TV Max Digital (5 decos) - Pack', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5153', null, 'Claro TV Max Digital (3 decos) - Pack', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5240', null, 'Claro TV Max Digital (5 decos) Colaborador', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5154', null, 'Claro TV Max Digital (2 decos) - Pack', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9914', null, 'CE: Paquete Max Digital HD', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9384', null, 'Paquete Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9911', null, 'CE: Max Digital HD (84 - 120)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9912', null, 'CE: Max Digital HD (124 - 200)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9913', null, 'CE: Max Digital HD (204 - 260)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9897', null, 'CE: Max Digital (8 - 20)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9898', null, 'CE: Max Digital (24 - 40)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9899', null, 'CE: Max Digital (44 - 80)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9900', null, 'CE: Max Digital (84 - 120)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9901', null, 'CE: Max Digital (124 - 200)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9902', null, 'CE: Max Digital (204 - 260)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9903', null, 'CE: Paquete Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9908', null, 'CE: Max Digital HD (8 - 20)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9909', null, 'CE: Max Digital HD (24 - 40)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9910', null, 'CE: Max Digital HD (44 - 80)', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('9407', null, 'CE:Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APWU', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APYO', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5920', null, 'Claro TV Max Digital (3 decos) Colaborador', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APQI', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQDU', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AQDV', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('5880', null, 'Claro TV Max Digital (3 decos) 3 Play upgrade', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('6940', null, 'CE Up grade de Prime a Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APSP', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APVQ', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APWA', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('APXV', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ('AEEW', null, 'Max Digital', 'CABLE_MAX', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 26, 'INTERNET Y CINE HD DIGITAL', 'SISACT_CINE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 34, 'TELEFONIA FIJA INTERNET Y CINE HD DIGITAL', 'SISACT_CINE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 21, 'CINE HD DIGITAL', 'SISACT_CINE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (25, 'TELEFONIA FIJA Y CINE HD DIGITAL', 'SISACT_CINE_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 12, 'FULL HD DIGITAL', 'SISACT_FULL_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (17, 'INTERNET Y FULL HD DIGITAL DE 4 MB A 60 MB', 'SISACT_FULL_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

insert into opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 18, 'TELEFONIA Y FULL HD DIGITAL', 'SISACT_FULL_HD', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

COMMIT;

insert into opedd ( CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( null,  'Servicio 1', 'MIGRA_SERVICIOS', (Select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS'));

COMMIT;

insert into opedd (CODIGON, DESCRIPCION, TIPOPEDD)
values (1147, 'INSTALACION HFC SISACT', 260);

insert into opedd (CODIGON, DESCRIPCION, TIPOPEDD)
values ((select t.wfdef from  wfdef t where t.descripcion = 'HFC/SIAC MIGRACION SGA BSCS SISTEMA'), 'HFC/SIAC MIGRACION SGA BSCS SISTEMA', 260);

COMMIT;