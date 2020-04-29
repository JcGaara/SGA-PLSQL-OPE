-- Add/modify columns 
alter table SGACRM.FT_CAMPO add CANTIDADPID NUMBER default 0;
-- Add comments to the columns 
comment on column SGACRM.FT_CAMPO.CANTIDADPID
  is 'Para FT de PID se asignara la cantidad del pid en la FT';