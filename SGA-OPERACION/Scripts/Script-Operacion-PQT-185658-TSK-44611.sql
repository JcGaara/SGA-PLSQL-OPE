--1.-CONFIGURACION DE NUMERO MAXIMO DE REINTENTO
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC',
   1,
   'SOAP_ENVELOPE',
   1,
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tran="@namespace"><soapenv:Header/><soapenv:Body>@trama</soapenv:Body></soapenv:Envelope>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC',
   2,
   'NAMESPACE',
   1,
   'http://claro.com.pe/eai/oac/transacciondisputas/');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC',
   3,
   'TRAMA',
   1,
   '<tran:crearDisputa><tran:txId>@trx_id_ws</tran:txId><tran:pCodAplicacion>@cod_aplicacion</tran:pCodAplicacion><tran:pUsuarioAplic>@usuario_aplicacion</tran:pUsuarioAplic><tran:pTipoServicio>@tipo_servicio</tran:pTipoServicio><tran:pCodCuenta>@cod_cuenta</tran:pCodCuenta><tran:pTipoOperacion>@tipo_operacion</tran:pTipoOperacion><tran:pIdReclamoOrigen>@id_reclamo_origen</tran:pIdReclamoOrigen><tran:pTipoDocReferencia>@tipo_doc_cxc_ref</tran:pTipoDocReferencia><tran:pNroDocReferencia>@nro_doc_cxc_ref</tran:pNroDocReferencia><tran:pMonedaDisputa>@moneda_disputa</tran:pMonedaDisputa><tran:pMontoDisputa>@monto_disputa</tran:pMontoDisputa><tran:pCodMotivoDisputa>@cod_motivo_disputa</tran:pCodMotivoDisputa><tran:pDescripDisputa>@descrip_disputa</tran:pDescripDisputa><tran:pFechaDisputa>@fecha_disputa</tran:pFechaDisputa></tran:crearDisputa>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC',
   4,
   'URL',
   1,
   'http://172.19.94.164:7903/OAC_Services/Transaction/TransaccionDisputas?wsdl');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC', 5, 'CODRSPTA', 1, 'errorCode');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSOAC', 6, 'MSGRSPTA', 1, 'errorMsg');
commit;