-- Actualizacion de tabla sga_ap_parametro

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='http://claro.com.pe/eai/ds/ws/ActivosPostpagoConvergenteWS'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=1
   and trim(sap.prmtv_descripcion)='Namespace'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='http://172.19.74.222:8903/ActivosPostpagoConvergenteWS/ebsActivosPostpagoConvergenteSB11'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=2
   and trim(sap.prmtv_descripcion)='Url'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='http://172.19.74.222:8903/eai/ebs/ws/ActivosPostpagoConvergenteWS/ejecutarActivacion'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=3
   and trim(sap.prmtv_descripcion)='Accion'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='<act:EjecutarActivacionRequest>
<act:auditRequest>
<act:idTransaccion>@idTransaccion</act:idTransaccion>
<act:ipAplicacion>@ipAplicacion</act:ipAplicacion>
<act:nombreAplicacion>@aplicacion</act:nombreAplicacion>
<act:usuarioAplicacion>@usuario</act:usuarioAplicacion>
</act:auditRequest>
<act:numeroAcuerdo>@numacuerdo</act:numeroAcuerdo>
<act:tipoProducto>@tipo_producto</act:tipoProducto>
<act:listaRequestOpcional>
</act:listaRequestOpcional>
</act:EjecutarActivacionRequest>'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=4
   and sap.prmtv_descripcion='Trama'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='//GenericoResponse/auditResponse/idTransaccion/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=5
   and sap.prmtv_descripcion='idTransaccion'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='//GenericoResponse/auditResponse/codigoRespuesta/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=6
   and sap.prmtv_descripcion='codRpta'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='//GenericoResponse/auditResponse/mensajeRespuesta/text()'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=7
   and sap.prmtv_descripcion='msgRpta'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='03',
       sap.prmtv_descripcion='TipoProducto'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=9
   and sap.prmtv_descripcion='Operacion'
   and sap.prmtc_estado='1';

update operacion.sga_ap_parametro sap
   set sap.prmtv_valor='USRSGA'
 where sap.prmtc_tipo_param='WSDTH'
   and sap.prmtn_correlativo=10
   and sap.prmtv_descripcion='Usuario'
   and sap.prmtc_estado='1';

-- Registro de Opedd
update operacion.opedd
   set descripcion='03',
       abreviacion='TIPOPRODUCTO'
 where trim(abreviacion)='SERVICIO'
   and codigon=3
   and tipopedd=(select tipopedd from operacion.tipopedd where abrev = 'WSDTH');

commit;
