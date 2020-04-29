-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO add instalador2 VARCHAR2(50);
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO.instalador2
  is 'Nombre del instalador 2';


-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO_LOG add instalador2 VARCHAR2(50);
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO_LOG.instalador2
  is 'Nombre del instalador 2';