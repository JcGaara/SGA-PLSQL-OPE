declare
v_tipopedd varchar2(50);
v_tipopedd4 varchar2(50);
v_tipopedd5 varchar2(50);
v_tipopedd6 varchar2(50);
v_tipopedd7 varchar2(50);
begin
  -- Insertando Cabeceras de Parametros
  insert into operacion.tipopedd (descripcion,abrev) values ('Parametros de Rotac. Manual','PARAM_ROTA_M');
  insert into operacion.tipopedd (descripcion,abrev) values ('Clientes para Demos','PARAM_ROTA_DEM');
  insert into operacion.tipopedd (descripcion,abrev) values ('Soluciones DTH para Rotacion','PARAM_ROTA_SOL');
  insert into operacion.tipopedd (descripcion,abrev) values ('Cod. Tipo de Equipo de Tarjeta','PARAM_ROTA_TARJ');
  insert into operacion.tipopedd (descripcion,abrev) values ('Cod. Tipo de Equipo de Tarjeta','PARAM_ROTA_TIPS');
  commit;
  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Parametros
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  -- Buscando Tipopedd para Insercion
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PARAM_ROTA_M';
  select t.tipopedd into v_tipopedd4 from operacion.tipopedd t where t.abrev='PARAM_ROTA_DEM';
  select t.tipopedd into v_tipopedd5 from operacion.tipopedd t where t.abrev='PARAM_ROTA_SOL';
  select t.tipopedd into v_tipopedd6 from operacion.tipopedd t where t.abrev='PARAM_ROTA_TARJ';
  select t.tipopedd into v_tipopedd7 from operacion.tipopedd t where t.abrev='PARAM_ROTA_TIPS';
  -- Insertando los Parametros
  -- Dias de recibos sin emitir
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (60,'Dias sin emitir Recibo','DIA_RSE',v_tipopedd);
  -- Area para Proceso Manual por Paquete
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (140,'Area para Proceso Act/Desac por Paquete','AREA_PQT',v_tipopedd);
  -- Area para Proceso Manual por Bouquet
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('LPONCE','Usuario para Proceso Act/Desac por Bouquet','USUA_BQT',v_tipopedd);
  -- Tipo de Proceso
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('1','Activación','TIP_PROC',v_tipopedd);
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('2','Corte','TIP_PROC',v_tipopedd);
  -- Tipo de Cliente  
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('1','Pre-Pago','TIP_CLI',v_tipopedd);
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('2','Post-Pago','TIP_CLI',v_tipopedd);  
  -- Validaciones
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('11','Longitud','VAL_LON',v_tipopedd);
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('0','Inicio','VAL_INI',v_tipopedd);
  -- Correo de informe de errores de Rotacion
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('1','luis.ponce@claro.com.pe','MAILR',v_tipopedd);
  -- Titulo de mensaje de correo
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('2','Error Proceso Rotación: Tarjetas No procesadas','MAILT',v_tipopedd);
  -- Estados de Proceso
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (1,'En Proceso','EST_P',v_tipopedd);
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (2,'Enviado Ok','EST_P',v_tipopedd);  
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (3,'Enviado con Error','EST_P',v_tipopedd);
  -- Estados de Archivo
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('1','Generado','EST_A',v_tipopedd);
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('2','Enviado','EST_A',v_tipopedd);  
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('3','Ok','EST_A',v_tipopedd);
  insert into operacion.opedd(codigoc,descripcion,abreviacion,tipopedd) values ('4','Error','EST_A',v_tipopedd);

  -- Parametros para la rotacion
  -- Codigos de clientes para los demos
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('AMERICA MOVIL PERU SAC','CLARO',v_tipopedd4);
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('CLIENTE DEMO DTH','CLARO',v_tipopedd4);
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('AMERICA MOVIL PERU S.A.C.','CLARO',v_tipopedd4);
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('PLAN MINEDU COLEGIO','MINEDU',v_tipopedd4);
  -- Soluciones para la rotacion
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (67,'TV Satelital','TV_SAT',v_tipopedd5);
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (119,'TV Sat Empresas','TV_SATE',v_tipopedd5);
  -- Tipos de equipo de tarjeta para la rotacion
  insert into operacion.opedd(codigon,descripcion,abreviacion,tipopedd) values (7242,'Tipo de Equipo de Tarjeta','TIP_DTH',v_tipopedd6);
  -- Tipos de Servicios DTH
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('0062','CABLE',v_tipopedd7);
  insert into operacion.opedd(descripcion,abreviacion,tipopedd) values ('0077','PQTI',v_tipopedd7);
  Commit;
end;
/