-- Agregar Columnas tabla Agendamiento
alter table OPERACION.AGENDAMIENTO add PRIORIZADO number;
-- Comentarios campos tabla Agendamiento
comment on column OPERACION.AGENDAMIENTO.PRIORIZADO  is '1 : Agenda Priorizada';

-- Agregar Columnas Log
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_INT NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_INTCAB NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_INTTEL NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_INTTELCAB NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_CAB NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_CABINT NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_TEL NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add MOTSOL_PEXT NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add PRIORIZADO NUMBER;

-- Comentarios Columnas Log
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_INT is 'Motivo Solucion Internet';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_INTCAB is 'Motivo Solucion Internet Cable';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_INTTEL is 'Motivo Solucion Internet Telefonia';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_INTTELCAB is 'Motivo Solucion Internet Telefonia Cable';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_CAB is 'Motivo Solucion Cable';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_CABINT is 'Motivo Solucion Cable Telefono';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_TEL is 'Motivo Solucion Telefonia';
comment on column OPERACION.AGENDAMIENTO_LOG.MOTSOL_PEXT is 'Motivo Solucion Planta Externa';
comment on column OPERACION.AGENDAMIENTO_LOG.PRIORIZADO is '1 : Agenda Priorizada';
