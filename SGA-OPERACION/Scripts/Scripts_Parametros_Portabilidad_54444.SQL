declare
v_tipopedd varchar2(50);
begin
  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Insertando Tipopedd
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  insert into operacion.tipopedd(descripcion,abrev) values('Parametros de Portabilidad MSV','PARAM_PORTA');
  ----------------------------------------------------------------------------------------------------------------------------------------------
  -- Parametros de Portabilidad
  ----------------------------------------------------------------------------------------------------------------------------------------------  
  -- Buscando Tipopedd para Insercion
  select t.tipopedd into v_tipopedd from operacion.tipopedd t where t.abrev='PARAM_PORTA';
  -- Insertando los Parametros de Portabilidad

  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('SP', 1, 'tipoMensaje SP', 'SP', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('PM1', 1, 'Portabilidad Fija Masiva - Alerta de SOT pendiente 1', 'ALER_PM1', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('0004', 1, 'Tipo de Servicio para portacion fija', 'MASIVO-TER', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('0061', 1, 'Tipo de Servicio para portacion Masiva', 'MASIVO-TIPSRV', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('VM', 1, 'cirineoj@globalhitss.com', 'Correo_Resp_Venc', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('PP', 2, 'tipoMensaje PP', 'PP', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('PM2', 2, 'Portabilidad Fija Masiva - Alerta de SOT por vencer 2', 'ALER_PM2', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('SOTE', 3, 'Sots Terminadas', 'ASUNTO_VENC', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 3, 'condorija@globalhitss.com; armasje@globalhitss.com; sucasacad@globalhitss.com', 'Correo_CProc', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 4, 'Portabilidad Masiva - Registros no Procesadas', 'Asunto_CProc', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 4, 'Periodo en dias hasta en que se guarda el log, luego se borra', 'DIAS_BORRADO', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 5, 'Tiempo de Envio Alerta 1 Masivos - ALTA', 'TE_Alerta1_ALTA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 7, 'Tiempo de Envio Alerta 1 Masivos - BAJA', 'TE_Alerta1_BAJA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 7, 'Tiempo de Envio Alerta 2 Masivos - ALTA', 'TE_Alerta2_ALTA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('PIM', 8, 'Longitud de Número telefonico', 'LNT', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 9, 'Tiempo de Envio Alerta 2 Masivos - BAJA', 'TE_Alerta2_BAJA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 10, 'Tiempo Estimado de Fin de instalación - ALTA', 'TE_FINST_ALTA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values (NULL, 12, 'Tiempo Estimado de Fin de instalación - BAJA', 'TE_FINST_BAJA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('IDtran', 123, 'idtransaccion', 'IdTransaccion',  v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('299', 299, 'Tareas de Activacion/Desactivacion de Servicios CORP/MAS', 'TareaAltaBaja', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('POM', 448, 'Trabajo para SOT de Baja para Portabilidad Masiva HFC', 'TWB', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('PIM', 658, 'Trabajo para SOT de Alta para Portabilidad Masiva HFC', 'TWA', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('833', 833, 'Tareas de Activacion/Desactivacion AUTO MASIVO', 'TareaAUTObaja', v_tipopedd);
  Insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD) Values ('DES_MAIL', NULL, 'Listado de SOT vencidas en dias', 'DETALLADO', v_tipopedd);
  COMMIT;
end;
/
