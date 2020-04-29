-- Actualizacion de tabla sga_ap_parametro

update operacion.sga_ap_parametro f_activarDTH_vcsap
   set sap.prmtv_valor='http://claro.com.pe/eai/ActivacionmientoDTH'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=1
   and trim(sap.prmtv_descripcion)='Namespace'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='http://172.19.67.73:7909/ActivacionDTHWS/EbsActivacionDTHSoapPort'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=2
   and trim(sap.prmtv_descripcion)='Url'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='http://claro.com.pe/eai/ActivacionDTH/ejecutaActivacionDTH'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=3
   and trim(sap.prmtv_descripcion)='Accion'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='<act:ActivacionDTHRequest xmlns:act="@namespace"><act:idTransaccion>@idTransaccion</act:idTransaccion><act:ipAplicacion>@ipAplicacion</act:ipAplicacion><act:aplicacion>@aplicacion</act:aplicacion><act:contrato>@contrato</act:contrato><act:servicio>@servicio</act:servicio><act:usuario>@usuario</act:usuario></act:ActivacionDTHRequest>'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=4
   and sap.prmtv_descripcion='Trama'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='/ActivacionDTHResponse/idTransaccion/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=5
   and sap.prmtv_descripcion='idTransaccion'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='/ActivacionDTHResponse/codRpta/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=6
   and sap.prmtv_descripcion='codRpta'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='/ActivacionDTHResponse/msgRpta/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=7
   and sap.prmtv_descripcion='msgRpta'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='S_PVU_ACTIVACION_DTH',
       sap.prmtv_descripcion='Operacion'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=9
   and sap.prmtv_descripcion='TipoProducto'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='SISACT'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=10
   and sap.prmtv_descripcion='Usuario'
   and sap.prmtc_estado='1';

-- Registro de Opedd
update operacion.opedd
   set descripcion='S_PVU_ACTIVACION_DTH',
       abreviacion='SERVICIO'
 where trim(abreviacion)='TIPOPRODUCTO'
   and codigon=3
   and tipopedd=(select tipopedd from operacion.tipopedd where abrev = 'WSDTH');

commit;
