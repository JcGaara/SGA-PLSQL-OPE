alter table OPERACION.SOLOT drop column IDOAC ;
DROP table operacion.TRSOAC;
DROP table OPERACION.LOGTRSOAC;
drop sequence operacion.SQ_IDTRSOAC;
drop sequence operacion.SQ_IDLOGTRSOAC;

-- Grant/Revoke object privileges 
revoke execute on OPERACION.PQ_SOLOT from USREAISGA;