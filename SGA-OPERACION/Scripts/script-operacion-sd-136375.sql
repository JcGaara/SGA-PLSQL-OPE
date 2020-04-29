-- Add/modify columns 
alter table OPERACION.TRSBAMBAF add numero varchar2(20);
-- Add comments to the columns 
comment on column OPERACION.TRSBAMBAF.numero
  is 'numero';

