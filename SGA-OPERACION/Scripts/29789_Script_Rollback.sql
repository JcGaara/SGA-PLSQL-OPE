
-- drop trigger
drop trigger OPERACION.T_ESTAGENDA_BI;

-- Eliminar columnas
alter table OPERACION.agendamientochgest drop column FECHAEJECUTADO;
alter table OPERACION.TIPTRABAJO drop column CORPORATIVO;
alter table HISTORICO.TIPTRABAJO_LOG drop column CORPORATIVO;

