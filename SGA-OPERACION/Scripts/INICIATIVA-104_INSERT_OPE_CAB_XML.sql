insert into operacion.ope_cab_xml
  (idcab,
   programa,
   nombrexml,
   titulo,
   rfc,
   metodo,
   descripcion,
   xml,
   target_url,
   xmlclob)
values
  ((select max(idcab) + 1 from operacion.ope_cab_xml),
   'LiberarRecursos',
   'Liberar Recursos GIS',
   'LiberarRecursosGIS',
   'HTTP/1.1',
   'POST',
   'Liberar Recursos GIS',
   null,
   'http://172.17.55.86:8080/gss/web/services/WsLiberarRecursosESWService?wsdl',
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gis="http://www.claro.net.pe/gis">
   <soapenv:Header/>
   <soapenv:Body>
      <gis:PeticionLiberarRecursosESW-RQ>
         <gis:CodigoIntegracion>@CodigoIntegracion</gis:CodigoIntegracion>
         <gis:CodigoDireccion>@CodigoDireccion</gis:CodigoDireccion>
         <gis:CodigoSubDireccion>@CodigoSubDireccion</gis:CodigoSubDireccion>
         <gis:RFS>@RFS</gis:RFS>
      </gis:PeticionLiberarRecursosESW-RQ>
   </soapenv:Body>
</soapenv:Envelope>');

COMMIT;
/