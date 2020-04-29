alter table operacion.estagenda
modify estage number;
 
alter table operacion.agendamiento
modify estage number;
 
alter table operacion.agenda_tareas
modify estage number;
 
alter table operacion.agenda_tareas_log
modify estage number;
 
alter table operacion.agendamiento_log
modify estage number;
 
alter table operacion.secuencia_estados_agenda
modify estagendaini number;
 
alter table operacion.secuencia_estados_agenda
modify estagendafin number;

