----------------------------------INICIO-VOD----------------------------------------------------
declare
 newidcab number;
 newseq number;
 begin
   select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
   --INSERT TABLA OPE_cab_XML
   insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'tv_adicional_vod', 'tv_adicional_vod','tv_adicional_vod', null, 'POST', 'TV ADICIONAL VOD', null, 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/services', 
    '{
        "identifier": "@f_identifier",
        "subscriberIdentifier": "@f_customerId",
        "serviceType": "@f_serviceType",
        "attributes": [
          {
            "CAS_PRODUCT_ID" : "@f_CAS_PRODUCT_ID",
            "CREDIT_LIMIT": "@f_CREDIT_LIMIT"
          }
        ],
        "device": {
          "identifier": "@f_serialNumber",
          "type": "@f_Model_STB",
          "attributes": [
            {
            "HOST_UNIT_ADDRESS": "@f_HOST_UNIT_ADDRESS"
            }
          ]
        }
      }');
    commit;
   --INSERT TABLA OPE_det_XML
    select max(IDSEQ)+1 into newseq from OPERACION.OPE_det_XML;
  
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq, 'authorization', null, 3, 1, null, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+1, 'transactionId', 'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope', 3, 1, null, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+2, 'source', 'select sys_context(''USERENV'', ''MODULE'') from dummy_ope', 3, 1, null, null);
    
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+3, 'f_identifier', null, 4, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+4, 'f_customerId', null, 4, 1, 2, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+5, 'f_serviceType', null, 4, 1, 3, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+6, 'f_CAS_PRODUCT_ID', null, 4, 1, 4, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+7, 'f_CREDIT_LIMIT', null, 4, 1, 5, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+8, 'f_serialNumber', null, 4, 1, 6, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+9, 'f_Model_STB', null, 4, 1, 7, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+10, 'f_HOST_UNIT_ADDRESS', null, 4, 1, 8, null);
    commit;
   --INSERT TABLA ft_tiptra_escenario
    insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
    values('658','0062',newidcab,5);
    commit;
 end;
----------------------------------FIN-VOD----------------------------------------------------
