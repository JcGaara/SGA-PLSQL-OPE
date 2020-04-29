insert into OPERACION.OPE_CAB_XML (IDCAB, PROGRAMA, NOMBREXML, METODO, DESCRIPCION, XML, TARGET_URL)
values ((select max(IDCAB) + 1 from OPERACION.OPE_CAB_XML ), 
'ConsultarNumSerieTelef_FTTH', 
'CONSULTARNUMSERIE_FTTH',
 'consultaSerie', 
 'consultaSerie', 
 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ws/operaciones/consultasserieftthws/types" xmlns:bas="http://claro.com.pe/eai/ws/baseschema">
   <soapenv:Header/>
   <soapenv:Body>
      <typ:consultaSerieRequest>
         <typ:auditRequest>
            <bas:idTransaccion>@f_idTransaccion</bas:idTransaccion>
            <bas:ipAplicacion>@f_ipApplicacion</bas:ipAplicacion>
            <bas:nombreAplicacion>@f_nombreAplicacion</bas:nombreAplicacion>
            <bas:usuarioAplicacion>@f_usuarioAplicacion</bas:usuarioAplicacion>
         </typ:auditRequest>
         <typ:nroSerie>@f_nroSerie</typ:nroSerie>
         <typ:listaRequestOpcional>
            <!--1 or more repetitions:-->
            <bas:objetoOpcional campo="?" valor="?"/>
         </typ:listaRequestOpcional>
      </typ:consultaSerieRequest>
   </soapenv:Body>
</soapenv:Envelope>', 
'http://172.17.26.37:20000/ConsultasSerieFtthWS/ebsConsultasSerieFtthSB11?WSDL');
commit;
/