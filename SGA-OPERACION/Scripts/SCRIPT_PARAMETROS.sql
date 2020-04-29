--TIPO: LICENCIA O SOPORTE

insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'Tipo Licencia o Soporte', 'TIPO_LICENCIA_SOPORTE');

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      1,
      'Licencia', 
    'LIC',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_LICENCIA_SOPORTE'),
    null);

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      2,
      'Soporte', 
    'SOP',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_LICENCIA_SOPORTE'),
    null);

--UBICACION DEL EQUIPO

insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'Ubicacion del equipo', 'UBICACION_EQUIPO');

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      0,
      'Almacen Claro', 
    'ALM',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='UBICACION_EQUIPO'),
    null);
    
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      1,
      'Cliente', 
    'CLI',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='UBICACION_EQUIPO'),
    null);  

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      2,
      'Proveedor', 
    'PROV',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='UBICACION_EQUIPO'),
    null);

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      3,
      'Marca', 
    'MARC',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='UBICACION_EQUIPO'),
    null);    


--TIPO DE SERVICIO DEL Inicio/Spare/RMA/NoEquipo

insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'Tipo de serv. del eqp/lic/sop', 'TIPO_SERV_EQP_LIC_SOP');

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      0,
      'Inicio', 
    'INI',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_SERV_EQP_LIC_SOP'),
    null);

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      1,
      'Spare', 
    'SPR',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_SERV_EQP_LIC_SOP'),
    null);
    
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      2,
      'RMA', 
    'RMA',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_SERV_EQP_LIC_SOP'),
    null);

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      3,
      'NO EQUIPO', 
    'NOEQP',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='TIPO_SERV_EQP_LIC_SOP'),
    null);
    
--ESTADO DE EQUIPO
--0: Activo, 1: Vencido

insert into OPERACION.tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from OPERACION.tipopedd), 'Estado de Licencia', 'ESTADO_LICENCIA');

insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      0,
      'Activo', 
    'ACTV',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='ESTADO_LICENCIA'),
    null);
    
insert into OPERACION.opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (
    (select max(IDOPEDD) + 1 from OPERACION.opedd), 
    NULL,
      1,
      'Vencido', 
    'VENCD',
    (select MAX(tipopedd) from OPERACION.tipopedd where upper(abrev)='ESTADO_LICENCIA'),
    null); 
    
--CALCULO DE FECHA FIN (MES O DIA)
-- CODIGON_AUX| 1:MESES, 2:DIA
insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'Calcular FECFIN de licitacion', 'LICITACION_FECH_FIN');
      
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), null, 1 ,'Calculo de fecha en meses', null,
    (select MAX(tipopedd) from tipopedd where upper(abrev)='LICITACION_FECH_FIN'),1); 

insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), null, 0 ,'Calculo de fecha en dias', null,
    (select MAX(tipopedd) from tipopedd where upper(abrev)='LICITACION_FECH_FIN'),2);   

-- PROVEEDORES

insert into tipopedd (TIPOPEDD, DESCRIPCION, ABREV)
      values ((select max(TIPOPEDD) + 1 from tipopedd), 'Proveedores Licencia', 'PROVEEDORES_LICENCIA_CID');
      
insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
      values ((select max(IDOPEDD) + 1 from opedd), null, 1 ,'CONTRATISTA MANTO CLIENTE CORP', null,
    (select MAX(tipopedd) from tipopedd where upper(abrev)='PROVEEDORES_LICENCIA_CID'),1); 

COMMIT;
