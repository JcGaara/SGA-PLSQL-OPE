----------------------------------INICIO REFRESH----------------------------------------------------
declare
newidcab number;
newseq number;
begin
   select max(IDCAB)+1 into newidcab from OPERACION.OPE_cab_XML;
   --INSERT TABLA OPE_cab_XML
   insert into OPERACION.OPE_cab_XML (IDCAB, PROGRAMA, NOMBREXML,  TITULO, RFC, METODO, DESCRIPCION, XML, TARGET_URL, XMLCLOB)
    values (newidcab, 'refresh_equipo', 'Refresh','Refresh', null, 'PUT', 'REFRESH A EQUIPO DE INCÓGNITO', null, 'http://prov.restapi.incognito.claro.com.pe/SACRestApi/api/deviceoperations/identifier/@f_MAC_DEVICE', 
    '{
    "operation": "RESEND_ALL_PACKETS",
    "server": "dac6000",
    "parameters": [
      {
      }
    ]
  }');
    commit;
   --INSERT TABLA OPE_det_XML
    select max(IDSEQ)+1 into newseq from OPERACION.OPE_det_XML;
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq, 'f_MAC_DEVICE', null, 7, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+1, 'authorization', null, 3, 1, null, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+2, 'f_operation', 'RESEND_ALL_PACKETS', 4, 1, 1, null);
    insert into OPERACION.OPE_det_XML (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN, DESCRIPCION)
    values (newidcab, newseq+3, 'f_server', 'dac6000', 4, 1, 2, null);
    commit;
	
	insert into sgacrm.ft_tiptra_escenario(tiptra,tipsrv,idcab,escenario)
	values(658,'REFR',newidcab,3);
	commit;
end;
----------------------------------FIN-REFRESH----------------------------------------------------