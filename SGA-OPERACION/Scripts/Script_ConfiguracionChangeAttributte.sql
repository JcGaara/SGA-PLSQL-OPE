----------------------------------INICIO-CHANGE-ATTRIBUTE----------------------------------------------------
declare
 newidcab number;
 newseq number;
 begin
   select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
   --INSERT TABLA OPE_cab_XML
   insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'change_attribute_tv_tlf', 'change_attribute_tv_tlf','change_attribute_tv_tlf', null, 'PUT', 'CAMBIO DE ATRIBUTO TV_TELEFONIA', null, 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/services/@f_identifier/attributes', 
    '{
      "@f_atributo" : "@f_valor"
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
    values (newidcab, newseq+3, 'f_identifier', null, 7, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+4, 'f_atributo', null, 4, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+5, 'f_valor', null, 4, 1, 2, null);
    commit;
   --INSERT TABLA ft_tiptra_escenario
    insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
    values('613','TODO',newidcab,4);
    commit;
 end;
----------------------------------FIN-CHANGE-ATTRIBUTE----------------------------------------------------
