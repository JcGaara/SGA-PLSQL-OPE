-- Drop Agendamiento
alter table OPERACION.AGENDAMIENTO drop column PRIORIZADO;

-- Drop Log de Agendamiento
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_INT ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_INTCAB ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_INTTEL ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_INTTELCAB ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_CAB ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_CABINT ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_TEL ;
alter table OPERACION.AGENDAMIENTO_LOG drop column MOTSOL_PEXT ;
alter table OPERACION.AGENDAMIENTO_LOG drop column PRIORIZADO ;
