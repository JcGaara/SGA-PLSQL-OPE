-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO add porcentaje number;
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO.porcentaje
  is 'Porcentaje de avance';