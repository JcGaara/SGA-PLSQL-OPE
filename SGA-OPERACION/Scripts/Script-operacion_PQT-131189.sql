declare
  ln_contar   number;
  ln_contador number;
  ln_idgrupo  number;
  ln_tipope   number;
  cursor cur_cabecera is
    select * from OPERACION.OPE_MENSAJES_MAE;

  cursor cur_servicios is
    select * from OPERACION.ope_serviciomensaje_rel;

  cursor cur_comando is
    select * from operacion.ope_comando_rel;

  cursor cur_grupos is
    select * from operacion.ope_grupos_rel;

  cursor cur_grupo_mensajes is
    select * from OPE_GRUPO_MENSAJES_DET;

begin

  /* ****************************************************** */
  begin
    select max(tipopedd) into ln_tipope from operacion.tipopedd;
  
    insert into operacion.tipopedd
      (tipopedd, descripcion, abrev)
    values
      (ln_tipope + 1, 'Configura Portal Cautivo', 'CONF_PORTAL_CAUTIVO');
  
    insert into operacion.opedd
      (codigon, descripcion, abreviacion, tipopedd)
    values
      (1, 'Monto de portal cautivo', 'MONTO_PC', ln_tipope + 1);
  
    insert into operacion.opedd
      (codigoc, descripcion, abreviacion, tipopedd)
    values
      ('REC', 'Tipo de documento: Recibo', 'REC_PORTAL_C', ln_tipope + 1);
  
    insert into operacion.opedd
      (codigon, descripcion, abreviacion, tipopedd)
    values
      (0,
       '1: Cliente cuenta con cargo en cuenta / 0: Sin cargo en cuenta',
       'CARGO_CTA_PC',
       ln_tipope + 1);
  
    commit;
  
  exception
    when others then
      rollback;
  end;
  /* ****************************************************** */
  /*Cargamos la cabecera de mensajes*/
  insert into OPERACION.OPE_MENSAJES_MAE
    (MENSAJE,
     DESCRIPCION,
     APLICAXSEGMARK,
     ESTADO,
     CODTIPO,
     TRANSACCIONUNICA,
     SOBRETX,
     DIASPOSTERIORESTX,
     CODFECHA)
  values
    ('AVISO DE PAGO',
     'MENSAJE DE AVISO ANTES DE FIN DE FECHA DE VENCIMIENTO',
     1,
     1,
     1,
     '',
     'AVISO',
     -3,
     2);

  insert into OPERACION.OPE_MENSAJES_MAE
    (MENSAJE,
     DESCRIPCION,
     APLICAXSEGMARK,
     ESTADO,
     CODTIPO,
     TRANSACCIONUNICA,
     SOBRETX,
     DIASPOSTERIORESTX,
     CODFECHA)
  values
    ('AVISO ANTES SUSPENSION',
     'MENSAJE DE AVISO ANTES DE FECHA DE SUSPENSION',
     0,
     1,
     2,
     '',
     'SUSPENSION',
     -1,
     1);

  insert into OPERACION.OPE_MENSAJES_MAE
    (MENSAJE,
     DESCRIPCION,
     APLICAXSEGMARK,
     ESTADO,
     CODTIPO,
     TRANSACCIONUNICA,
     SOBRETX,
     DIASPOSTERIORESTX,
     CODFECHA)
  values
    ('AVISO SUSPENSION',
     'MENSAJE DE AVISO DESPUES DE FECHA DE SUSPENSION',
     0,
     1,
     3,
     '',
     'SUSPENSION',
     2,
     1);
  commit;

  for c_1 in cur_cabecera loop
    /*Cargamos el segmento de mercado*/
    insert into OPERACION.OPE_SEGMENTOMERCADO_REL
      (IDMENSAJE, CODSEGMARK, ESTADO)
    values
      (c_1.idmensaje, 24, 1);
  
    /*Cargamos el estado del servicio*/
    insert into OPERACION.ope_estadoservicio_rel
      (IDMENSAJE, ESTADO, USUREG, FECREG, USUMOD, FECMOD, DESCRIPCION)
    values
      (c_1.idmensaje, 1, USER, SYSDATE, USER, SYSDATE, 'ACTIVO');
  
    /*Cargamos el estado del servicio*/
    insert into OPERACION.ope_serviciomensaje_rel
      (IDMENSAJE, TIPSRV, DESCRIPCION)
    values
      (c_1.idmensaje, '0006', 'Acceso Dedicado a Internet');
    commit;
  
  end loop;

  for c_2 in cur_servicios loop
    /*Cargamos los comandos*/
    insert into OPERACION.OPE_COMANDO_REL
      (COMANDO, PROCEDIMIENTO, IDSERVMENS, ID_INTERFASE_BASE)
    values
      (628, 'PQ_OPE_AVISO', c_2.idservmens, '620');
    commit;
  end loop;

  update OPERACION.ope_parametros_det
     set valor = 'Aviso Vencimiento'
   where valor = 'CORTEPF';
  commit;

  /*Cargamos los parametros*/
  for c_3 in cur_comando loop
    insert into OPERACION.OPE_COMANDOPARAMETRO_REL
      (IDCOMANDO, IDPARAMETRO, VALOR, FLG_XML)
    values
      (c_3.idcomando, 2, 'Aviso Vencimiento', 1);
  
    insert into OPERACION.OPE_COMANDOPARAMETRO_REL
      (IDCOMANDO, IDPARAMETRO, VALOR, FLG_XML)
    values
      (c_3.idcomando, 1, '1', 0);
    commit;
  end loop;
  commit;
  /**************************************************************************/
  /*Configuración de Grupos de Gestión*/
  insert into OPERACION.OPE_GRUPOS_REL
    (DESCABR, DESCRIPCION, APLICASOLUCION, ESTADO)
  values
    ('INTERNET', 'Gestión de grupos de internet', 1, 1);
  commit;

  select r.idgrupo
    into ln_idgrupo
    from OPERACION.OPE_GRUPOS_REL r
   where r.descabr = 'INTERNET';

  /*Configuramos la solución 115*/
  insert into OPERACION.OPE_GRUPOMENSSOL_DET
    (IDGRUPO, IDSOLUCION)
  values
    (ln_idgrupo, 117);
  commit;

  /*Configuramos los mensajes*/
  for c_4 in cur_grupos loop
    ln_contador := 0;
    for c_1 in cur_cabecera loop
      ln_contador := ln_contador + 1;
      insert into OPERACION.OPE_GRUPO_MENSAJES_DET
        (IDGRUPO, IDMENSAJE, DIASUTILES, ORDEN, ESTADO, GRUPOEJECUCION)
      values
        (c_4.idgrupo, c_1.idmensaje, 1, ln_contador, 1, 61);
      commit;
    end loop;
  end loop;

  /*Configuramos los procesos*/
  ln_contador := 0;
  for c_5 in cur_grupo_mensajes loop
    insert into OPERACION.OPE_PROCESOS_REL
      (IDGRUPOMENSAJE, PROCESO, ORDEN, TIPOPROCESO, ESTADO)
    values
      (c_5.IDGRUPOMENSAJE, 'PQ_OPE_AVISO', ln_contador + 1, 'GEN', 1);
  
    insert into OPERACION.OPE_PROCESOS_REL
      (IDGRUPOMENSAJE, PROCESO, ORDEN, TIPOPROCESO, ESTADO)
    values
      (c_5.IDGRUPOMENSAJE, 'PQ_OPE_AVISO', ln_contador + 2, 'VAL', 1);
  
    insert into OPERACION.OPE_PROCESOS_REL
      (IDGRUPOMENSAJE, PROCESO, ORDEN, TIPOPROCESO, ESTADO)
    values
      (c_5.IDGRUPOMENSAJE, 'PQ_OPE_AVISO', ln_contador + 3, 'EJE', 1);
    commit;
  end loop;

  commit;
end;
/
