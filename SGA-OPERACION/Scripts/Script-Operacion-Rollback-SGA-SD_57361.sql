-- Grant/Revoke object privileges 
revoke select, insert, update, delete on OPERACION.OPE_CAB_XML from WEBSERVICE;
revoke select, insert, update, delete on OPERACION.OPE_DET_XML from WEBSERVICE;
revoke execute on OPERACION.PQ_IW_SGA_BSCS from WEBSERVICE;
