-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO add TIPO VARCHAR2(30);
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO.TIPO
  is 'Tipo de Agenda';

-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO_LOG add TIPO VARCHAR2(30);
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO_LOG.TIPO
  is 'Tipo de Agenda';