INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'consultaCapacidadSGA',
   'Adminitracion de Cuadrillas',
   'consultaCapacidadSGA',
   'Adminitracion de Cuadrillas',
   '<soapenv:Envelope
                        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                        xmlns:ws="http://claro.com.pe/eai/ebs/services/capacity/etadirect/ws">
              <soapenv:Header/>
              <soapenv:Body>
              <@consultarrequest>
              <@request>@body</@request>
              </@consultarrequest>
               </soapenv:Body>
              </soapenv:Envelope>',
   'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_Capacity/ebsADMCUAD_CapacitySB11?WSDL');
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'cancelarOrdenSGA_ADC',
   'Administracion de Cuadrillas',
   'cancelarOrdenSGA',
   'Administracion de Cuadrillas',
   '<soapenv:Envelope 
  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
  xmlns:typ="http://claro.com.pe/ebsADMCUAD/Inbound/types">
  <soapenv:Header/>
  <soapenv:Body>
    <@consultarrequest>
      <@request>
        @body
      </@request>
    </@consultarrequest>
  </soapenv:Body>
</soapenv:Envelope>',
   'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_InboundWS/ebsADMCUAD_InboundSB11?WSDL');
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'XAServices_ToInstall',
   'Administracion de Cuadrillas',
   'XAServices_ToInstall',
   'Administracion de Cuadrillas',
   '<![CDATA[
  <XA_Services_ToInstall>
    @ServiceToInstall
  </XA_Services_ToInstall>
  ]]>',
   NULL);
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'Services_ToInstall',
   'Administracion de Cuadrillas',
   'Services_ToInstall',
   'Administracion de Cuadrillas',
   '  <ServiceToInstall>
    <PID>@Pid</PID>
    <NroServicio>@NroServicio</NroServicio>
    <Tipo>@Tipo</Tipo>
    <Servicio>@Servicio</Servicio>
    <IPPrincipal>@IPPrincipal</IPPrincipal>
    <Cantidad>@Cantidad</Cantidad>
  </ServiceToInstall>
  ',
   NULL);
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'gestionarOrdenSGA_ADC',
   'Administracion de Cuadrillas',
   'gestionarOrdenSGA',
   'Administracion de Cuadrillas',
   '<soapenv:Envelope
  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:typ="http://claro.com.pe/ebsADMCUAD/Inbound/types">
  <soapenv:Header/>
  <soapenv:Body>
    <typ:gestionarOrdenSGARequest>
      <typ:cadenaRequest>
        @body
      </typ:cadenaRequest>
    </typ:gestionarOrdenSGARequest>
  </soapenv:Body>
</soapenv:Envelope>',
   'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_InboundWS/ebsADMCUAD_InboundSB11?WSDL');
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'cargarInventarioTotalSGA_ADC',
   'Administracion de Cuadrillas',
   'cargarInventarioTotalSGA',
   'Administracion de Cuadrillas',
   '<soapenv:Envelope
  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:typ="http://claro.com.pe/ebsADMCUAD/Inbound/types">
  <soapenv:Header/>
  <soapenv:Body>
    <typ:cargarInventarioTotalSGARequest>
      <typ:cadenaRequest>
        @body
      </typ:cadenaRequest>
    </typ:cargarInventarioTotalSGARequest>
  </soapenv:Body>
</soapenv:Envelope>',
   'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_InboundWS/ebsADMCUAD_InboundSB11?WSDL');
INSERT INTO operacion.ope_cab_xml
  (idcab, programa, rfc, metodo, descripcion, xml, target_url)
VALUES
  ((SELECT MAX(a.idcab) + 1 FROM operacion.ope_cab_xml a),
   'cargarInventarioIncrementalSGA_ADC',
   'Administracion de Cuadrillas',
   'cargarInventarioIncrementalSGA',
   'Administracion de Cuadrillas',
   '<soapenv:Envelope
  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:typ="http://claro.com.pe/ebsADMCUAD/Inbound/types">
  <soapenv:Header/>
  <soapenv:Body>
    <typ:cargarInventarioIncrementalSGARequest>
      <typ:cadenaRequest>
        @body
      </typ:cadenaRequest>
    </typ:cargarInventarioIncrementalSGARequest>
  </soapenv:Body>
</soapenv:Envelope>',
   'http://limdeseaiv27.tim.com.pe:8903/ebsADMCUAD_InboundWS/ebsADMCUAD_InboundSB11?WSDL');
COMMIT;
/