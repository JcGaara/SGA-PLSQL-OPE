-----------------------------------INICIO GET_ACCOUNT------------------------------
declare
newidcab number;
newseq number;
begin
   select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
   --INSERT TABLA OPE_cab_XML
    insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'get_account', 'get_account', 'get', null, 'GET', 'obtiene cliente incognito', null, 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/accounts/identifier/@f_CUSTOMERID', '{}');
    commit;
   --INSERT TABLA OPE_det_XML
    select max(IDSEQ)+1 into newseq from OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq, 'f_CUSTOMERID', null, 7, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+1, 'authorization', null, 3, 1, null, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+2, 'transactionId', 'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope', 3, 1, null, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+3, 'source', 'select sys_context(''USERENV'', ''MODULE'') from dummy_ope', 3, 1, null, null);
    commit;
end;
----------------------------------FIN GET_ACCOUNT------------------------------