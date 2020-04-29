INSERT INTO operacion.ope_cab_xml c (c.idcab,c.programa,c.metodo, c.descripcion, c.xml,c.target_url)
values((select max(a.idcab)+1 from operacion.ope_cab_xml a),'Valida_Numero_C',  'Valida_Numero_C',  'Valida_Numero_C',
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://pe/com/claro/esb/services/identificaoperador/ws" xmlns:oper="http://pe/com/claro/identificaOperador/schemas/operador">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:buscarOperadorLineas>
         <oper:IdentificadorOperadorRequest>
            @body
         </oper:IdentificadorOperadorRequest>
      </ws:buscarOperadorLineas>
   </soapenv:Body>
</soapenv:Envelope>', 
'http://172.19.95.4:7903/IdentificaOperadorWS/EbsIdentificaOperador?WSDL');
commit;
INSERT INTO operacion.ope_cab_xml c (c.idcab,c.programa,c.metodo, c.descripcion, c.xml,c.target_url)
values((select max(a.idcab)+1 from operacion.ope_cab_xml a),'actualizarAfiliacion',  'actualizarAfiliacionDEAUT',  'Actualiza Afiliacion en OAC',
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ws/enterprise/transaccionesafiliacionesdeauws/types" xmlns:bas="http://claro.com.pe/eai/ws/baseschema">
   <soapenv:Header/>
   <soapenv:Body>
      <typ:actualizarAfiliacionDEAUTRequest>
         <typ:auditRequest>
            <bas:idTransaccion>?</bas:idTransaccion>
            <bas:ipAplicacion>?</bas:ipAplicacion>
            <bas:nombreAplicacion>?</bas:nombreAplicacion>
            <bas:usuarioAplicacion>?</bas:usuarioAplicacion>
         </typ:auditRequest>
         @body
         <typ:listaRequestOpcional>
            <!--1 or more repetitions:-->
            <bas:objetoOpcional campo="?" valor="?"/>
         </typ:listaRequestOpcional>
      </typ:actualizarAfiliacionDEAUTRequest>
   </soapenv:Body>
</soapenv:Envelope>',
'http://172.16.119.100:7903/TransaccionesAfiliacionesDeauWS/ebsTransaccionesAfiliacionesDeauSB11?WSDL');
commit;
INSERT INTO operacion.ope_cab_xml c (c.idcab,c.programa,c.metodo, c.descripcion, c.xml,c.target_url)
values((select max(a.idcab)+1 from operacion.ope_cab_xml a),'RegistrarAfiliacion',  'registrarAfiliacionDEAUT',  'Registrar Afiliacion',
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ws/enterprise/transaccionesafiliacionesdeauws/types" xmlns:bas="http://claro.com.pe/eai/ws/baseschema">
   <soapenv:Header/>
   <soapenv:Body>
      <typ:registrarAfiliacionDEAUTRequest>
         <typ:auditRequest>
            <bas:idTransaccion></bas:idTransaccion>
            <bas:ipAplicacion></bas:ipAplicacion>
            <bas:nombreAplicacion></bas:nombreAplicacion>
            <bas:usuarioAplicacion></bas:usuarioAplicacion>
         </typ:auditRequest>
         @body
         <typ:listaRequestOpcional>
            <!--1 or more repetitions:-->
            <bas:objetoOpcional campo="?" valor="?"/>
         </typ:listaRequestOpcional>
      </typ:registrarAfiliacionDEAUTRequest>
   </soapenv:Body>
</soapenv:Envelope>',
'http://172.16.119.100:7903/TransaccionesAfiliacionesDeauWS/ebsTransaccionesAfiliacionesDeauSB11?WSDL');
commit;
INSERT INTO operacion.ope_cab_xml c (c.idcab,c.programa,c.metodo, c.descripcion, c.xml,c.target_url)
values((select max(a.idcab)+1 from operacion.ope_cab_xml a),'actualizarEstadoAfiliacion',  'actualizarEstadoAfiliacion',  'Actualizar el estado de la afiliacion',
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ws/enterprise/transaccionesafiliacionesdeauws/types" xmlns:bas="http://claro.com.pe/eai/ws/baseschema">
   <soapenv:Header/>
   <soapenv:Body>
      <typ:actualizarEstadoAfiliacionDEAUTRequest>
         <typ:auditRequest>
            <bas:idTransaccion>?</bas:idTransaccion>
            <bas:ipAplicacion>?</bas:ipAplicacion>
            <bas:nombreAplicacion>?</bas:nombreAplicacion>
            <bas:usuarioAplicacion>?</bas:usuarioAplicacion>
         </typ:auditRequest>
         @body
         <typ:listaRequestOpcional>
            <!--1 or more repetitions:-->
            <bas:objetoOpcional campo="?" valor="?"/>
         </typ:listaRequestOpcional>
      </typ:actualizarEstadoAfiliacionDEAUTRequest>
   </soapenv:Body>
</soapenv:Envelope>',
'http://172.16.119.100:7903/TransaccionesAfiliacionesDeauWS/ebsTransaccionesAfiliacionesDeauSB11?WSDL');
commit;