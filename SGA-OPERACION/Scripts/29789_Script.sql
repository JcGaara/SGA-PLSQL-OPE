-- Agregar Campo
alter table OPERACION.agendamientochgest add FECHAEJECUTADO DATE;
comment on column OPERACION.agendamientochgest.FECHAEJECUTADO
  is 'Fecha Ejecutado agendamiento';

-- Agregar Campo
alter table OPERACION.TIPTRABAJO add CORPORATIVO number default 0;
comment on column OPERACION.TIPTRABAJO.CORPORATIVO
  is '1: Para mantenimientos corporativos';

-- Agregar Campo
alter table HISTORICO.TIPTRABAJO_LOG add CORPORATIVO number default 0;
comment on column HISTORICO.TIPTRABAJO_LOG.CORPORATIVO
  is '1: Para mantenimientos corporativos';
