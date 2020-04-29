declare
newidcab number;
newseq number;
begin
    select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
    insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'registra_usuario_cab', 'Registra Usuario Cabecera','registra_usuario_cab', null, 'POST', 'CABECERA DE REGISTRA USUARIO', null, 'http://172.17.51.148:20000/claro-postventa-nocliente-resource/api/post/v1.0.0/nocliente/registrar_sucursal', 
    '{
        "productoClienteRequest": {
                        "idCardValue": "@f_idCardValue",
                        "customerDocType": "@f_customerDocType",
                        "customerId": "@f_customerId",
                        "coId": "@f_coId",
                        "email": "@f_email",
                        "productos": [
                            @f_xml_dinamico
                        ]
            }
}');
    select max(IDSEQ)+1 into newseq from OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq, 'f_idCardValue', null, 4, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+1, 'f_customerDocType', null, 4, 1, 2, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+2, 'f_customerId', null, 4, 1, 3, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+3, 'f_coId', null, 4, 1, 4, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+4, 'f_email', null, 4, 1, 5, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+5, 'f_xml_dinamico', null, 4, 1, 6, null);
	
	insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+6, 'idTransaccion', 'select sys_guid() from dummy_ope', 3, 1, null, null);
	insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+7, 'msgid', 'select sys_guid() from dummy_ope', 3, 1, null, null);
	insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+8, 'userId', 'USREAI', 3, 1, null, null);
	insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+9, 'timestamp', 'select to_char(sysdate, ''YYYY-MM-DD HH24:MI:SS'') from dummy_ope', 3, 1, null, null);
	insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+10, 'accept', 'application/json', 3, 1, null, null);
end;
/

declare
newidcab number;
newseq number;
begin
    select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
    insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'registra_usuario_det', 'Registra Usuario Detalle','registra_usuario_det', null, 'POST', 'DETALLE DE REGISTRA USUARIO', null, 'http://172.17.51.148:20000/claro-postventa-nocliente-resource/api/post/v1.0.0/nocliente/registrar_sucursal', 
    '{
                               "productNumber": "@f_productNumber",
                               "productPlatform": "@f_productPlatform",
                               "productType": "@f_productType",
                               "prodOfferName": "@f_prodOfferName"
                            }');
    select max(IDSEQ)+1 into newseq from OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq, 'f_productNumber', null, 4, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+1, 'f_productPlatform', null, 4, 1, 2, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+2, 'f_productType', null, 4, 1, 3, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+3, 'f_prodOfferName', null, 4, 1, 4, null);
end;
/
