/*Se crea la tarea*/
insert into OPEWF.tareadef
  (tareadef, tipo, descripcion, pre_proc, pos_proc, flg_ft)
  SELECT MAX(t.tareadef) + 1,
         2,
         'Generacion de Transaccion IW',
         'intraway.pq_provision_itw.p_genera_xml_adc',
         null,
         0
    from OPEWF.tareadef t; 
  
   
/*****************************************************************************************/
/*creamos el workflow*/  
insert into wfdef (WFDEF, ESTADO, CLASEWF, DESCRIPCION)
values ((select max(wfdef) + 1 from wfdef), 1, 0, 'HFC/SIAC - PUERTO25');


  
insert into tareawfdef (TAREA, DESCRIPCION, ORDEN, TIPO, AREA, RESPONSABLE, WFDEF, TAREADEF, PRE_MAIL, POS_MAIL, PRE_TAREAS, 
POS_TAREAS, PLAZO, ESTADO, AREA_FACTIBILIDAD, AGRUPA, FRECUENCIA, FLGANULAR, FLGCONDICION, CONDICION, REGLA_ASIG_CONTRATA, 
REGLA_ASIG_FECPROG, AREA_DERIVA_CORREO, TIPO_AGENDA, FLG_ASIGNAAREA, F_ASIGNAAREA, FLG_OPC, SQL_CONDICION_TAREA)
values ((select max(tarea) + 1 from tareawfdef), 'Generacion de Transaccion IW', 0, 2, 
(select area from OPERACION.AREAOPE where descripcion = 'OPERACIONES HFC'), null, 
(select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25'), 
(select tareadef  from tareadef where descripcion = 'Generacion de Transaccion IW'
and pre_proc = 'intraway.pq_provision_itw.p_genera_xml_adc'), null, null, null, null, 1.00, 1, null, null, null, 0, 0, 
null, null, null, null, null, 0, null, 0, null);


  
insert into tareawfdef (TAREA, DESCRIPCION, ORDEN, TIPO, AREA, RESPONSABLE, WFDEF, TAREADEF, PRE_MAIL, POS_MAIL, 
PRE_TAREAS, POS_TAREAS, PLAZO, ESTADO, AREA_FACTIBILIDAD, AGRUPA, FRECUENCIA, FLGANULAR, FLGCONDICION, CONDICION, 
REGLA_ASIG_CONTRATA, REGLA_ASIG_FECPROG, AREA_DERIVA_CORREO, TIPO_AGENDA, FLG_ASIGNAAREA, F_ASIGNAAREA, FLG_OPC,
SQL_CONDICION_TAREA)
values ((select max(tarea) + 1 from tareawfdef), 'Configuración Intraway', 0, 0, 330, null, 
(select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25'), 1210, null, null, null, null, 1.00, 1,
null, null, null, 0, 0, null, null, null, null, null, 0, null, 0, null);


   
/**************************************************************************************************************************************/
--Actualizamos las pre y post tareas
update tareawfdef
set pos_tareas = (select tarea 
                  from tareawfdef 
                 where descripcion = 'Configuración Intraway'  
                   and wfdef = (select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25'))
where descripcion = 'Generacion de Transaccion IW'
and wfdef = (select wfdef from wfdef where descripcion = 'HFC/SIAC - PUERTO25'); 

 
 
/*****************************************************************************************/
/*creamos el workflow*/  
insert into wfdef (WFDEF, ESTADO, CLASEWF, DESCRIPCION)
values ((select max(wfdef) + 1 from wfdef), 1, 0, 'HFC/SIAC - IPFIJA CONFIGURACION');


  
insert into tareawfdef (TAREA, DESCRIPCION, ORDEN, TIPO, AREA, RESPONSABLE, WFDEF, TAREADEF, PRE_MAIL, POS_MAIL, PRE_TAREAS, 
POS_TAREAS, PLAZO, ESTADO, AREA_FACTIBILIDAD, AGRUPA, FRECUENCIA, FLGANULAR, FLGCONDICION, CONDICION, REGLA_ASIG_CONTRATA, 
REGLA_ASIG_FECPROG, AREA_DERIVA_CORREO, TIPO_AGENDA, FLG_ASIGNAAREA, F_ASIGNAAREA, FLG_OPC, SQL_CONDICION_TAREA)
values ((select max(tarea) + 1 from tareawfdef), 'Generacion de Transaccion IW', 0, 2, 
(select area from OPERACION.AREAOPE where descripcion = 'OPERACIONES HFC'), null, 
(select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION'), 
(select tareadef  from tareadef where descripcion = 'Generacion de Transaccion IW'
 and pre_proc = 'intraway.pq_provision_itw.p_genera_xml_adc'), null, null, null, null, 1.00, 1, null, null, null, 0, 0, 
 null, null, null, null, null, 0, null, 0, null);


  
insert into tareawfdef (TAREA, DESCRIPCION, ORDEN, TIPO, AREA, RESPONSABLE, WFDEF, TAREADEF, PRE_MAIL, POS_MAIL, 
PRE_TAREAS, POS_TAREAS, PLAZO, ESTADO, AREA_FACTIBILIDAD, AGRUPA, FRECUENCIA, FLGANULAR, FLGCONDICION, CONDICION, 
REGLA_ASIG_CONTRATA, REGLA_ASIG_FECPROG, AREA_DERIVA_CORREO, TIPO_AGENDA, FLG_ASIGNAAREA, F_ASIGNAAREA, FLG_OPC,
 SQL_CONDICION_TAREA)
values ((select max(tarea) + 1 from tareawfdef), 'Configuración Intraway', 0, 0, 330, null, 
(select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION'), 1210, null, null, null, null, 1.00, 1,
 null, null, null, 0, 0, null, null, null, null, null, 0, null, 0, null);
 
   
/**************************************************************************************************************************************/
--Actualizamos las pre y post tareas
update tareawfdef
   set pos_tareas = (select tarea 
                      from tareawfdef 
                     where descripcion = 'Configuración Intraway'  
                       and wfdef = (select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION'))
where descripcion = 'Generacion de Transaccion IW'
and wfdef = (select wfdef from wfdef where descripcion = 'HFC/SIAC - IPFIJA CONFIGURACION');
 
COMMIT;







