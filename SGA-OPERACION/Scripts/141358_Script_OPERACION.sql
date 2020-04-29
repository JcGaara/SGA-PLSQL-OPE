-- Add/modify columns 
alter table OPERACION.SOLOT add IDOAC number;
-- Add comments to the columns 
comment on column OPERACION.SOLOT.IDOAC
  is 'Id OAC';


-- Grant/Revoke object privileges 
grant select, insert, update, delete on OPERACION.TRSOAC to USREAISGA;
grant select, insert, update, delete on OPERACION.LOGTRSOAC to USREAISGA;
grant execute on OPERACION.PQ_SOLOT to USREAISGA;

