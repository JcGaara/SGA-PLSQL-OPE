-- Grant/Revoke object privileges 
revoke select, insert, update, delete on OPERACION.OPE_EQU_IW from USREAISGA;
revoke execute on OPERACION.PQ_IW_OPE from USREAISGA;
revoke select, insert, update, delete on OPERACION.SOLOTPTOEQU from USREAISGA;

revoke execute on OPERACION.ARR_DAC from USREAISGA;
revoke execute on OPERACION.ARR_PACKETCABLEREPORT from USREAISGA;
revoke execute on OPERACION.ARR_DOCSISREPORT from USREAISGA;
revoke execute on OPERACION.ARR_REPORTOBJOUTPUT from USREAISGA;
