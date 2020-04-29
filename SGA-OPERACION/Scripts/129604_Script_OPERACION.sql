-- Add/modify columns 
alter table OPERACION.CUADRILLAXCONTRATA add TIPO NUMBER default 1;
-- Add comments to the columns 
comment on column OPERACION.CUADRILLAXCONTRATA.TIPO
  is '1 Cuadrilla 2 Tecnico';

