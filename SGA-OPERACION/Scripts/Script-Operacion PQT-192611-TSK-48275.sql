declare 
ln_tipopedd_new number(8);
ln_idopedd number(8);

begin
  --MÁXIMO NRO DE REINTENTOS DE ENVÍO A CLARO VIDEO
  select nvl(max(tipopedd), 0) + 1 into ln_tipopedd_new from tipopedd;
  insert into tipopedd
    (tipopedd, descripcion, abrev)
  values
    (ln_tipopedd_new, 'Máximo Reintentos Claro Video', 'SVA_MAX_INTENTO');

  select nvl(max(idopedd), 0) + 1 into ln_idopedd from opedd;
  insert into opedd
    (idopedd, codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (ln_idopedd,
     'SVA_MAX_INTENTO',
     1,
     'Configuración de máximo de reintentos permitidos para el envío a claro video',
     'SVA_MAX_INTENTO',
     ln_tipopedd_new,
     5);
     
  --LISTA DE CORREOS DE NOTIFICACIÓN AL SUPERAR EL MÁXIMO DE REINTENTOS
  select nvl(max(tipopedd), 0) + 1 into ln_tipopedd_new from tipopedd;
  insert into tipopedd
    (tipopedd, descripcion, abrev)
  values
    (ln_tipopedd_new, 'LISTA DE EMAIL CLARO VIDEO', 'SVA_LISTA_EMAIL');

  select nvl(max(idopedd), 0) + 1 into ln_idopedd from opedd;
  insert into opedd
    (idopedd, codigoc, descripcion, tipopedd)
  values
    (ln_idopedd,
     'CC_MAIL',
     'juan.ramos@globalhitss.com',
     ln_tipopedd_new);
  
  select nvl(max(idopedd), 0) + 1 into ln_idopedd from opedd;
  insert into opedd
    (idopedd, codigoc, descripcion, tipopedd)
  values
    (ln_idopedd,
     'TO_MAIL',
     'quispec@globalhitss.com',
     ln_tipopedd_new);
  commit;
end;
/

--1.-PARÁMETROS DEL WEB SERVICE DE ACTUALIZACIÓN DE CLARO VIDEO
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV',
   1,
   'SOAP_ENVELOPE',
   1,
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebs="@namespace"><soapenv:Header/><soapenv:Body>@trama</soapenv:Body></soapenv:Envelope>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV',
   2,
   'NAMESPACE',
   1,
   'http://claro.com.pe/ebsGestionaSVA/');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV',
   3,
   'TRAMA',
   1,
   '<ebs:reasignarRequest><ebs:idTransaccion>@idtransaccion</ebs:idTransaccion><ebs:aplicacion>@aplicacion</ebs:aplicacion><ebs:ipAplicacion>@ipAplicacion</ebs:ipAplicacion><ebs:usrAplicacion>@usrAplicacion</ebs:usrAplicacion><ebs:criterio>@criterio</ebs:criterio><ebs:valorAntiguo>@valorAntiguo</ebs:valorAntiguo><ebs:valorNuevo>@valorNuevo</ebs:valorNuevo><ebs:listaOpcionalRequest><ebs:RequestOpcional><ebs:clave></ebs:clave><ebs:valor></ebs:valor></ebs:RequestOpcional></ebs:listaOpcionalRequest></ebs:reasignarRequest>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV',
   4,
   'URL',
   1,
   'http://172.19.74.109:6909/GestionaSVAWS/ebsGestionaSVA?WSDL');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV', 5, 'CODRSPTA', 1, 'codigoRespuesta');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSACV', 6, 'MSGRSPTA', 1, 'mensajeRespuesta');
  
--1.-PARÁMETROS DEL WEB SERVICE DE BAJA DE CLARO VIDEO
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV',
   1,
   'SOAP_ENVELOPE',
   1,
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebs="@namespace"><soapenv:Header/><soapenv:Body>@trama</soapenv:Body></soapenv:Envelope>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV',
   2,
   'NAMESPACE',
   1,
   'http://claro.com.pe/ebsGestionaSVA/');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV',
   3,
   'TRAMA',
   1,
   '<ebs:desactivarRequest><ebs:idTransaccion>@idtransaccion</ebs:idTransaccion><ebs:aplicacion>@aplicacion</ebs:aplicacion><ebs:ipAplicacion>@ipAplicacion</ebs:ipAplicacion><ebs:usrAplicacion>@usrAplicacion</ebs:usrAplicacion><ebs:criterio>@criterio</ebs:criterio><ebs:valorCriterio>@valorCriterio</ebs:valorCriterio><ebs:listaOpcionalRequest><ebs:RequestOpcional><ebs:clave></ebs:clave><ebs:valor></ebs:valor></ebs:RequestOpcional></ebs:listaOpcionalRequest></ebs:desactivarRequest>');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV',
   4,
   'URL',
   1,
   'http://172.19.74.109:6909/GestionaSVAWS/ebsGestionaSVA?WSDL');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV', 5, 'CODRSPTA', 1, 'codigoRespuesta');
insert into operacion.sga_ap_parametro
  (prmtc_tipo_param,
   prmtn_codigo_param,
   prmtv_descripcion,
   prmtc_estado,
   prmtv_valor)
values
  ('WSBCV', 6, 'MSGRSPTA', 1, 'mensajeRespuesta');
commit;
