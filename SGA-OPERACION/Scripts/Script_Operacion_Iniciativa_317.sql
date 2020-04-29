DECLARE
  LN_CANT NUMBER;

BEGIN
  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML
   WHERE nombrexml =  'CreateRequestClienteAltaCBIO';
   
  IF LN_CANT = 0 THEN
      INSERT INTO OPERACION.OPE_CAB_XML (idcab ,programa, nombrexml, titulo, rfc ,metodo, descripcion, target_url, xmlclob, timeout)
      VALUES ((select max(idcab) +1 from OPERACION.OPE_CAB_XML), 'Creación de Cliente CBIO - Transaccion Alta', 'CreateRequestClienteAltaCBIO', 'Creación_Cliente_CBIO_Transaccion_Alta',(SELECT TAREADEF FROM TAREADEF WHERE DESCRIPCION =  'Creación de Cliente CBIO'), 'POST', 'Creación de Cliente en CBIO', 'http://172.17.51.94:24020/CON_SOAP_BSCSiX/CON_CUSTOMER_CREATE/Services/Exposition/CON_CUSTOMER_CREATE',  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cus="http://ericsson.com/services/ws_CIL_7/customercreate" xmlns:cus1="http://ericsson.com/services/ws_CIL_7/customernew" xmlns:mon="http://lhsgroup.com/lhsws/money" xmlns:pay="http://ericsson.com/services/ws_CIL_7/paymentarrangementwrite" xmlns:add="http://ericsson.com/services/ws_CIL_7/addresswrite" xmlns:cus2="http://ericsson.com/services/ws_CIL_7/customerinfowrite" xmlns:cus3="http://ericsson.com/services/ws_CIL_7/customerwrite" xmlns:ses="http://ericsson.com/services/ws_CIL_7/sessionchange">
   <soapenv:Header>
      <wsse:Security soap-env:actor="http://schemas.xmlsoap.org/soap/actor/next" soap-env:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
         <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
            <wsse:Username>@USERNAME</wsse:Username>
            <wsse:Password>@PASSWORD</wsse:Password>
         </wsse:UsernameToken>
      </wsse:Security>
   </soapenv:Header>
   <soapenv:Body>
      <cus:customerCreateRequest>
         <cus:inputAttributes>
            <cus:customerNew>
               <cus1:prgCode>@PRGCODE</cus1:prgCode>
               <cus1:rpcode>@RPCODE</cus1:rpcode>              
               <cus1:csBillcycle>@CSBILLCYCLE</cus1:csBillcycle>
               <cus1:partyType>@PARTYTYPE</cus1:partyType>
            </cus:customerNew>
            <cus:paymentArrangementWrite>
               <pay:cspPmntId>@CSPPMNTID</pay:cspPmntId>
            </cus:paymentArrangementWrite>
            <cus:addresses>
               <cus:item>
                  <cus:addressWrite>
                     <add:adrSeq>@ADRSEQ</add:adrSeq>                     
                     <add:ttlId>@TTLID</add:ttlId>                     
                     <add:adrLname>@ADRLNAME</add:adrLname>                     
                     <add:adrName>@ADRNAME</add:adrName>                   
                     <add:adrFname>@ADRFNAME</add:adrFname>
                     <add:adrStreet>@ADRSTREET</add:adrStreet>
                     <add:adrStreetno>@ADRSTREETNO</add:adrStreetno>
                     <add:adrJbdes>@ADRJBDES</add:adrJbdes>
                     <add:adrZip>@ADRZIP</add:adrZip>
                     <add:adrCity>@ADRCITY</add:adrCity>
                     <add:adrNote1>@ADRNOTE1</add:adrNote1>
                     <add:adrNote2>@ADRNOTE2</add:adrNote2>
                     <add:adrNote3>@ADRNOTE3</add:adrNote3>
                     <add:adrPhn1>@ADRPHN1</add:adrPhn1>
                     <add:adrEmail>@ADREMAIL</add:adrEmail>
                     <add:adrState>@ADRSTATE</add:adrState>
                     <add:adrCounty>@ADRCOUNTY</add:adrCounty>
                     <add:adrLocation1>@ADRLOCATION1</add:adrLocation1>
                     <add:idtypeCode>@IDTYPECODE</add:idtypeCode>
                     <add:adrIdno>@ADRIDNO</add:adrIdno>
                     <add:adrBirthdt>@ADRBIRTHDT</add:adrBirthdt>
                     <add:masCode>@MASCODE</add:masCode>
                     <add:adrNationality>@ADRNATIONALITY</add:adrNationality>
                     <add:countryIdPub>@COUNTRYIDPUB</add:countryIdPub>
                  </cus:addressWrite>
               </cus:item>
            </cus:addresses>
            <cus:customerWrite>
               <cus3:csStatus>@CSSTATUS</cus3:csStatus>
               <cus3:rsCode>@RSCODE</cus3:rsCode>
            </cus:customerWrite>
         </cus:inputAttributes>
         <cus:sessionChangeRequest>
            <ses:values>
               <ses:item>
                  <ses:key>@KEY</ses:key>
                  <ses:value>@VALUE</ses:value>
               </ses:item>
            </ses:values>
         </cus:sessionChangeRequest>
      </cus:customerCreateRequest>
   </soapenv:Body>
</soapenv:Envelope>',1800);
     COMMIT;
  END IF;

  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML CAB, SGACRM.FT_TIPTRA_ESCENARIO TIP
   WHERE CAB.IDCAB = TIP.IDCAB
     AND CAB.nombrexml =  'CreateRequestClienteAltaCBIO';
   
  IF LN_CANT = 0 THEN
     INSERT INTO SGACRM.FT_TIPTRA_ESCENARIO (tiptra,tipsrv,idcab,escenario,descripcion) VALUES (null,null,(SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),null, 'Creación de clientes en CBIO');
     COMMIT;
  END IF;

  SELECT COUNT(1)
    INTO LN_CANT
    FROM OPERACION.OPE_CAB_XML CAB, OPERACION.OPE_PARAM_XML DET
   WHERE CAB.IDCAB = DET.IDCAB
     AND CAB.nombrexml =  'CreateRequestClienteAltaCBIO';
  
  IF LN_CANT = 0 THEN
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),1,'Username','ADMX',1,1,'usuario');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'Password','ADMX',1,2,'contraseña');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'prgCode','2',1,3,'pricegroup of the customer/business partner');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'rpcode','1',1,4,'rateplan for other credits and charges of the customer');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'csBillcycle','select to_char(fecusu,''DD'') from solot where codsolot =:1 and nvl(:2,5) = 5',3,5,'billcycle of the customer');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'partyType','C',1,6,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'cspPmntId','-1',1,7,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrSeq','0',1,8,'Clave privada');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'ttlId','1',1,9,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrLname','select v.apepatcli || '' '' || v.apematcli from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,10,'Apellido de cliente');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrName','select v.nomcli from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,11,'Nombre de cliente');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrFname','select trim(substr(v.nomcli,1,instr(v.nomcli, v.apepatcli || '' '' || v.apematcli) - 1)) from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,12,'Primer nombre de cliente ');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrStreetno','select to_char(v.numvia) from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,13,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrStreet','select v.nomvia from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,14,'Calle de dirección postal');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrZip','select  v.codpos from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,15,'Código postal de la dirección postal');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrCity','select b.nompvc from vtatabpai d inner join vtatabest c on c.codpai = d.codpai inner join vtatabpvc b on b.codest = c.codest and b.codpai = c.codpai inner join vtatabdst a on a.codpai = b.codpai and a.codest = b.codest and a.codpvc = b.codpvc inner join vtatabcli v on v.codubi = a.codubi where v.codcli in (select codcli from solot where codsolot = :1) and nvl(:2, 5) = 5',3,16,'Ciudad de dirección postal');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrNote2','',1,17,'Departamento u oficina');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrNote1','select p.dsargu from vtatabcli v inner join pertbex02 p on v.tipviap = p.cdargu and p.cdtabl = ''TV'' where v.codcli in (select codcli from solot where codsolot =:1)  and nvl(:2,5) = 5',3,18,'Tipo de calle, avenida');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrNote3','',1,19,'Numero departamento u oficina (opcional)');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrPhn1','select  v.telefono1 from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,20,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrEmail','select  v.mail from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,21,'Dirección de correo eletrónico');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrState','select c.nomest from vtatabpai d inner join vtatabest c on c.codpai = d.codpai inner join vtatabpvc b on b.codest = c.codest and b.codpai = c.codpai inner join vtatabdst a on a.codpai = b.codpai and a.codest = b.codest and a.codpvc = b.codpvc inner join vtatabcli v on v.codubi = a.codubi where v.codcli in (select codcli from solot where codsolot = :1) and nvl(:2, 5) = 5',3,22,'Estado de dirección postal');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrCounty','select a.nomdst from vtatabpai d inner join vtatabest c on c.codpai = d.codpai inner join vtatabpvc b on b.codest = c.codest and b.codpai = c.codpai inner join vtatabdst a on a.codpai = b.codpai and a.codest = b.codest and a.codpvc = b.codpvc inner join vtatabcli v on v.codubi = a.codubi where v.codcli in (select codcli from solot where codsolot = :1) and nvl(:2, 5) = 5',3,23,'Distrito');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrLocation1','0',1,24,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'idtypeCode','select case v.tipdide when ''006'' then 1 when ''002'' then 2 when ''004'' then 4 when ''005'' then 5 when ''001'' then 6 when ''013'' then 7 when ''012'' then 8 when ''014'' then 9 when ''015'' then 10 end from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,25,'Tipo de documento');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrIdno','select v.ntdide from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,26,'Número de documento');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrBirthdt','select nvl(to_char(v.fecnac,''yyyy-mm-dd''),'''') from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,27,'Fecha de nacimiento');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'masCode','select case v.idestcivil when ''1'' then 1 when ''2'' then 2 when ''4'' then 3 when ''3'' then 4 else -1 end from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,28,'Estado civil');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrNationality','',1,29,'Nacionalidad');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'countryIdPub','PER',1,30,'Clave pública del país');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'csStatus','a',1,31,'status of the customer / business partner, for business partner only state interested and active are supported.');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'rsCode','1',1,32,'reason for the status change');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'key','BU_ID',1,33,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'value','2',1,34,'');
	INSERT INTO OPERACION.OPE_PARAM_XML (idcab, idseq, campo, valor, tipo, orden, descripcion) VALUES ((SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO'),(select max(idseq)+1 from OPERACION.OPE_PARAM_XML  where idcab = (SELECT IDCAB FROM OPERACION.OPE_CAB_XML WHERE NOMBREXML =  'CreateRequestClienteAltaCBIO')),'adrJbdes','select v.referencia from vtatabcli v where v.codcli in (select codcli from solot where codsolot =:1) and nvl(:2,5) = 5',3,35,'');
   COMMIT;
  END IF;
  
  SELECT count(1)
    INTO LN_CANT
    FROM TIPOPEDD
   WHERE UPPER(ABREV) = 'TRANS_TIPTRA_APIS_CBIOS';
  
  IF LN_CANT = 0 THEN
    
      INSERT INTO TIPOPEDD
        (TIPOPEDD, DESCRIPCION, ABREV)
      VALUES
        ((SELECT MAX(TIPOPEDD) + 1 FROM TIPOPEDD),
         'TRANSACCIÓN CONSUMO APIS CBIOS',
         'TRANS_TIPTRA_APIS_CBIOS');  
      COMMIT;  
   END IF;           
END;
    
/
