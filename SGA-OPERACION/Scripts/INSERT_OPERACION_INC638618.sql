DECLARE

  N_IDVENTANA number(6);

BEGIN

  INSERT INTO SGACRM.INV_VENTANA V
    (V.IDVENTANA,
     V.NOMBRE,
     V.DESCRIPCION,
     V.ESTADO,
     V.FECUSU,
     V.CODUSU,
     V.FECUSUMOD,
     V.CODUSUMOD,
     V.CODVENTANA,
     V.TIPO,
     V.VENTANA_HFC,
     V.VEN_SQL,
     V.FLAG_VEN_SQL,
     V.VERSION)
  VALUES
    ((SELECT MAX(I.IDVENTANA) + 1 FROM SGACRM.INV_VENTANA I),
     'w_md_sga_act_lte',
     'ALTA Y BAJA JANUS LTE',
     1,
     SYSDATE,
     SUBSTR(USER,1,30),
     SYSDATE,
     SUBSTR(USER,1,30),
     NULL,
     1,
     NULL,
     NULL,
     0,
     NULL);

  SELECT I.IDVENTANA
    INTO N_IDVENTANA
    FROM SGACRM.INV_VENTANA I
   WHERE I.NOMBRE = 'w_md_sga_act_lte';

  INSERT INTO OPEWF.TAREADEFVENTANA T
    (T.TAREADEF,
     T.ORDEN,
     T.IDVENTANA,
     T.TITULO,
     T.FECUSU,
     T.CODUSU,
     T.FECUSUMOD,
     T.CODUSUMOD)
  VALUES
    (12026,--Validacion del instalador del servicio 
     1,
     N_IDVENTANA,
     'Alta y Baja Janus LTE',
     SYSDATE,
     SUBSTR(USER,1,30),
     SYSDATE,
     SUBSTR(USER,1,30));

INSERT INTO SGACRM.INV_VENTANAXPAR P
  (P.IDVENTANA,
   P.IDSTPAR,
   P.VALORWF,
   P.TIPODATOWF,
   P.VALORINT,
   P.TIPODATOINT,
   P.ESTADO,
   P.FECUSU,
   P.CODUSU,
   P.FECUSUMOD,
   P.CODUSUMOD)
VALUES
  (N_IDVENTANA,
   6,
   'F_GET_IDTAREAWF',
   4,
   null,
   null,
   1,
   SYSDATE,
   SUBSTR(USER,1,30),
   SYSDATE,
   SUBSTR(USER,1,30));

insert into SGACRM.INV_VENTANAXPAR P
  (P.IDVENTANA,
   P.IDSTPAR,
   P.VALORWF,
   P.TIPODATOWF,
   P.VALORINT,
   P.TIPODATOINT,
   P.ESTADO,
   P.FECUSU,
   P.CODUSU,
   P.FECUSUMOD,
   P.CODUSUMOD)
values
  (N_IDVENTANA,
   5,
   'F_GET_CODSOLOT',
   4,
   null,
   null,
   1,
   SYSDATE,
   SUBSTR(USER,1,30),
   SYSDATE,
   SUBSTR(USER,1,30));

   INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'Exception al invocar WS connectionManagementServiceControl.activateSpendGroupDetails()','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set  p.estado_prv = 2,
      p.fecha_rpt_eai=null,
      p.errcode=null,
      p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''Exception al invocar WS connectionManagementServiceControl.activateSpendGroupDetails()''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'Exception al invocar WS PayerManagementServiceControl.getPayerDetails()','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set  p.estado_prv = 2, 
   p.fecha_rpt_eai=null,
   p.errcode=null,
   p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''Exception al invocar WS PayerManagementServiceControl.getPayerDetails()''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'Error al invocar el provisioningManagementServiceControl.activateSubscriber()','update tim.rp_prov_ctrl_janus @DBL_BSCS_BF p
       set  p.estado_prv = 2, 
   p.fecha_rpt_eai=null,
   p.errcode=null,
   p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''Error al invocar el provisioningManagementServiceControl.activateSubscriber()''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'Exception al invocar el servicio BROKER consultaEntidad.consultarDetalleEntidad','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv = 2, 
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''Exception al invocar el servicio BROKER consultaEntidad.consultarDetalleEntidad''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'PAYER ALREADY EXISTS','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
       where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''PAYER ALREADY EXISTS''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'getBalance no retorno walledId para el tariffId indicado [10690].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [10690].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'getBalance no retorno walledId para el tariffId indicado [10710].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [10710].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'getBalance no retorno walledId para el tariffId indicado [10730].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 ,
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [10730].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'getBalance no retorno walledId para el tariffId indicado [11311].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
        p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [11311].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'No se encontro: [BROKER-Consultas-Linea]','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
   p.fecha_rpt_eai=null,
   p.errcode=null,
   p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''No se encontro: [BROKER-Consultas-Linea]''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'No se encontro: [BROKER-Consultas-Recargas]','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''No se encontro: [BROKER-Consultas-Recargas]''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'No se encontro PayerManagement','       update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
        p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''No se encontro PayerManagement]''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'Exception al Invocar el servicio BROKER transaccionesEntidad.actualizarSaldoMinimo','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =2 , 
     p.fecha_rpt_eai=null,
     p.errcode=null,
     p.errmsg=null
       where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''Exception al Invocar el servicio BROKER transaccionesEntidad.actualizarSaldoMinimo''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE.','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5 , 
   p.fecha_rpt_eai=null,
   p.errcode=null,
   p.errmsg=''GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE.''
       where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE.''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'PAYER TARIFF IS ALREADY TERMINATED','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''PAYER TARIFF IS ALREADY TERMINATED''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'La Operación getRealtionShipDetails es nula','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''La Operación getRealtionShipDetails es nula''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','2',209,'','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''2''
       and trim(p.errmsg) = ''''','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'PAYER TARIFF IS ALREADY ACTIVE','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''PAYER TARIFF IS ALREADY ACTIVE''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'PAYER TARIFF IS ALREADY ACTIVE','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''PAYER TARIFF IS ALREADY ACTIVE''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','2',500,'','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''2''
       and trim(p.errmsg) = ''''','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'success','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''succes''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'NO Todos los registros se ejecutaron con éxito','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''NO Todos los registros se ejecutaron con éxito''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'NO Todos los registros se ejecutaron con éxito','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''NO Todos los registros se ejecutaron con éxito''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'getBalance no retorno walledId para el tariffId indicado [10690].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [10690].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'getBalance no retorno walledId para el tariffId indicado [10690].','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 500
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''getBalance no retorno walledId para el tariffId indicado [10690].''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'CONNECTION NOT FOUND','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 509
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''CONNECTION NOT FOUND''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',2,'PAYER NOT FOUND','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 2
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''PAYER NOT FOUND''))','A','hfc_ce');
 INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'CONNECTION NOT FOUND','update tim.rp_prov_ctrl_janus@DBL_BSCS_BF p
       set p.estado_prv =5
       where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = upper(trim(''CONNECTION NOT FOUND''))','A','hfc_ce');
	   
 --2
 
  INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'PAYER ALREADY EXISTS','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.tarea = 4, p.intentos = 5, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''PAYER ALREADY EXISTS'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'CONNECTION NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.intentos = 0, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''CONNECTION NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',1,'SPEND GROUP DETAILS ALREADY EXISTS','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.tarea = 5, p.intentos = 5, p.estado_prv = 2
     where p.action_id = 1
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) =
           trim(''SPEND GROUP DETAILS ALREADY EXISTS'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',2,'BOTH OLD AND NEW PAYER STATUS ARE SAME','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 2
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) =
           trim(''BOTH OLD AND NEW PAYER STATUS ARE SAME'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',2,'PAYER NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 2
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''PAYER NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'CONNECTION NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.intentos = 0, p.estado_prv = 2
     where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''CONNECTION NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE. ','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) =
           trim(''GIVEN MINIMUM BALANCE IS SAME AS PREVIOUS MINIMUM BALANCE. '')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'CONNECTION NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''CONNECTION NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',505,'CONNECTION ALREADY TERMINATED','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 505
       and p.estado_prv = ''6''
       and upper(trim(p.errmsg)) = trim(''CONNECTION ALREADY TERMINATED'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',500,'','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 500
       and p.estado_prv = ''6''','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',509,'','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.action_id = 509
       and p.estado_prv = ''6''','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',3,'BOTH OLD AND NEW PAYER STATUS ARE SAME','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.estado_prv = ''6''
       and p.action_id = 3
       and upper(trim(p.errmsg)) =
           trim(''BOTH OLD AND NEW PAYER STATUS ARE SAME'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',3,'PAYER NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 5
     where p.estado_prv = ''6''
       and p.action_id = 3
       and upper(trim(p.errmsg)) = trim(''PAYER NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',3,'OCURRIO UNA EXCEPCIÓN AL INVOCAR EL SERVICIO - CHANGEPAYERSTATUS','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set p.estado_prv = 2,
           p.intentos   = 1,
           p.errcode    = null,
           p.errmsg     = null
     where p.estado_prv = ''6''
       and p.action_id = 3
       and upper(trim(p.errmsg)) =
           trim(''OCURRIO UNA EXCEPCIÓN AL INVOCAR EL SERVICIO - CHANGEPAYERSTATUS'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',4,'PAYER NOT FOUND','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set estado_prv = 5
     where p.estado_prv = ''6''
       and p.action_id = 4
       and upper(trim(p.errmsg)) = trim(''PAYER NOT FOUND'')','A','hfc_sisact');
INSERT INTO OPERACION.OPE_CONFIG_ACCION_JANUS (TIPO_ACCION,EST_PROV,ACTION_ID,MENSAJE,SENTENCIA,ESTADO,TIP_SVR) VALUES ('U','6',4,'BOTH OLD AND NEW PAYER STATUS ARE SAME','update tim.rp_prov_bscs_janus@DBL_BSCS_BF p
       set estado_prv = 5
     where p.estado_prv = ''6''
       and p.action_id = 4
       and upper(trim(p.errmsg)) =
           trim(''BOTH OLD AND NEW PAYER STATUS ARE SAME'')','A','hfc_sisact');

insert into OPERACION.CONSTANTE
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('IND_COD_ID_LTE',
   'Parametro para llamar a la busqqueda en Bscs los datos de SGA',
   'N',
   SUBSTR(USER, 1, 30) ,
   SYSDATE,
   '1',
   null);		   
commit; 
END;
/
