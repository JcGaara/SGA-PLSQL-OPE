declare
v_tipopedd varchar2(50);
begin
  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Borrando datos
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  begin
    delete from operacion.opedd where tipopedd in (select tipopedd from tipopedd 
       where abrev in ('PARAM_PORTA','PR-CORP-WF','PR-CORP-ALER','PR-CORP-MAIL','PR_CORP_CONF','PR-CORP-WS'));

    delete from operacion.tipopedd where abrev in ('PARAM_PORTA','PR-CORP-WF','PR-CORP-ALER','PR-CORP-MAIL','PR_CORP_CONF','PR-CORP-WS');
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Insertando Tipopedd
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  begin
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('Parametros de Portabilidad', 'PARAM_PORTA');
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('PR_PORT_CORP_WF', 'PR-CORP-WF');
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('PR_PORT_CORP_ALERTAS', 'PR-CORP-ALER');
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('PR_PORT_CORP_MAIL', 'PR-CORP-MAIL');
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('PR_PORT_CORP_CONF', 'PR_CORP_CONF');
    insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('PR_PORT_CORP_WS', 'PR-CORP-WS');
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Parametros de Portabilidad
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  -- Buscando Tipopedd para Insercion
  begin
    select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PARAM_PORTA';
    -- Insertando los Parametros de Portabilidad
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 1107, 'Workflow de Baja', 'WB', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('299', 299, 'Tareas de Activacion/Desactivacion de Servicios CORP/MAS', 'TareaAltaBaja', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('En Agenda', 16, 'Estado de Agendamiento', 'EA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 17, 'Id. de Plataforma', 'IP', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('SP', 1, 'tipoMensaje SP', 'SP', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PM1', 1, 'Portabilidad Fija Masiva - Alerta de SOT pendiente 1', 'ALER_PM1', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0004', 1, 'Tipo de Servicio para portacion fija', 'MASIVO-TER', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0061', 1, 'Tipo de Servicio para portacion Masiva', 'MASIVO-TIPSRV', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PP', 2, 'tipoMensaje PP', 'PP', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PM2', 2, 'Portabilidad Fija Masiva - Alerta de SOT por vencer 2', 'ALER_PM2', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('SOTE', 3, 'Sots Terminadas', 'ASUNTO_VENC', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('CorreoVP', 3, 'condorija@globalhitss.com;armasje@globalhitss.com', 'Correo_CProc', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('AsuntoVP', 4, 'Portabilidad Masiva - Registros no Procesadas', 'Asunto_CProc', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 5, 'Tiempo de Envio Alerta 1 Masivos - ALTA', 'TE_Alerta1_ALTA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 7, 'Tiempo de Envio Alerta 1 Masivos - BAJA', 'TE_Alerta1_BAJA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 7, 'Tiempo de Envio Alerta 2 Masivos - ALTA', 'TE_Alerta2_ALTA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PIM', 8, 'Longitud de Número telefonico', 'LNT', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 9, 'Tiempo de Envio Alerta 2 Masivos - BAJA', 'TE_Alerta2_BAJA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 10, 'Tiempo Estimado de Fin de instalación - ALTA', 'TE_FINST_ALTA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 12, 'Tiempo Estimado de Fin de instalación - BAJA', 'TE_FINST_BAJA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('IDtran', 123, 'idtransaccion', 'IdTransaccion', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('POM', 448, 'Trabajo para SOT de Baja para Portabilidad Masiva HFC', 'TWB', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PIM', 658, 'Trabajo para SOT de Alta para Portabilidad Masiva HFC', 'TWA', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('DES_MAIL', null, 'Listado de SOT vencidas en dias', 'DETALLADO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('VM', 1, 'cirineoj@globalhitss.com', 'Correo_Resp_Venc', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 4, 'Periodo en dias hasta en que se guarda el log, luego se borra', 'DIAS_BORRADO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('833', 833, 'Tareas de Activacion/Desactivacion AUTO MASIVO', 'TareaAUTObaja', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;

  -- Buscando Tipopedd para Insercion
  begin
    select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PR-CORP-WF';
    -- Insertando los Parametros de Portabilidad
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0004', 5, 'Telefonia Fija', 'BAJA-AUTO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0044', 5, 'Servicio 0800', 'BAJA-AUTO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0056', 5, 'Servicio 0801', 'BAJA-AUTO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0058', 5, 'Paquetes Pymes e Inmobiliario', 'BAJA-AUTO', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0073', 5, 'Paquetes Pymes en HFC', 'BAJA-AUTO', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;

  -- Buscando Tipopedd para Insercion
  begin
    select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PR-CORP-ALER';
    -- Insertando los Parametros de Portabilidad
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0004', 1, 'Telefonia Fija', 'PR-CORP-TERM', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0004', 1, 'Telefonia Fija', 'PR-CORP-PEND', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0044', 1, 'Servicio 0800', 'PR-CORP-PEND', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0044', 1, 'Servicio 0800', 'PR-CORP-TERM', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0056', 1, 'Servicio 0801', 'PR-CORP-PEND', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0056', 1, 'Servicio 0801', 'PR-CORP-TERM', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0058', 1, 'Paquetes Pymes e Inmobiliario', 'PR-CORP-TERM', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0058', 1, 'Paquetes Pymes e Inmobiliario', 'PR-CORP-PEND', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0073', 1, 'Paquetes Pymes en HFC', 'PR-CORP-TERM', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0073', 1, 'Paquetes Pymes en HFC', 'PR-CORP-PEND', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;

  begin
    -- Buscando Tipopedd para Insercion
    select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PR-CORP-MAIL';
    -- Insertando los Parametros de Portabilidad
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'sucasacad@globalhitss.com', 'PR-MAIL_PEN', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'Portabilidad Numerica Fija (flujo corporativo): ALERTAS: SOT Pendientes', 'PR-ASUNTO_PEN', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'Se envia Listado de SOT que se Acercan a la Fecha de Compromiso', 'PR-DETALLE_PEN', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'sucasacad@globalhitss.com', 'PR-MAIL_VEN', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'Portabilidad Numerica Fija (flujo corporativo): ALERTAS: SOT Vencidas', 'PR-ASUNTO_VEN', v_tipopedd);
    insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, null, 'Se envia Listado de SOT que se Encuentran con Fecha de Activacion Mayor a la Fecha de Compromiso', 'PR-DETALLE_VEN', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;

  begin
  -- Buscando Tipopedd para Insercion
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PR_CORP_CONF';
  -- Insertando los Parametros de Portabilidad
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0073', 1, 'Paquetes Pymes en HFC', 'TIPSRV', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0044', 0, 'Servicio 0800', 'TIPSRV', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0056', 0, 'Servicio 0801', 'TIPSRV', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0004', 0, 'Telefonia Fija', 'TIPSRV', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('0058', 1, 'Paquetes Pymes e Inmobiliario', 'TIPSRV', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('299', 299, 'Activación/Desactivación del servicio', 'TAREAACT', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('424', null, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'TIPTRAPLAY', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('424', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'TIPTRA_ALTA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('368', 368, 'INSTALACION PAQUETES', 'TIPTRA_ALTA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('131', 131, 'CONFIGURACION', 'TIPTRA_ALTA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('1', 1, 'INSTALACION', 'TIPTRA_ALTA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('448', 448, 'HFC - BAJA TODO CLARO TOTAL', 'TIPTRA_BAJA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('5', 5, 'BAJA TOTAL DEL SERVICIO', 'TIPTRA_BAJA', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 111, 'Gestion de Programacion Portabilidad CORP IN', 'TAREAPORT', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values (null, 10057, 'Validación de instalación de servicio', 'TAREAPORTMC', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;
  
  begin
  -- Buscando Tipopedd para Insercion
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PR-CORP-WS';
  -- Insertando los Parametros de Portabilidad
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('PP', null, 'TIPO MENSAJE', 'WS_PP_MS', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('21', null, 'REMITENTE', 'WS_PP_RE', v_tipopedd);
  insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) values ('00', null, 'DESTINATARIO', 'WS_PP_DE', v_tipopedd);
    commit;
  exception
    when others then
      rollback;
  end;

exception
  when others then
    rollback;
end;
/