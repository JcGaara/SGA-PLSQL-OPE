-- Create table
create table OPERACION.CIERRE_TAREA_AGENDA
( idseq   NUMBER not null,
  TAREADEF    NUMBER NOT NULL,
  esttarea number not null,
  USUREG          VARCHAR2(30) default user not null,
  FECREG          DATE default sysdate not null
) ;
-- Add comments to the table 
comment on table OPERACION.CIERRE_TAREA_AGENDA
  is 'Tabla de cierre de estados para los cambios de estado de agenda';
-- Add comments to the columns 
comment on column OPERACION.CIERRE_TAREA_AGENDA.idseq
  is 'idseq';
comment on column OPERACION.CIERRE_TAREA_AGENDA.TAREADEF
  is 'Afecta tareas del wf de la agenda';
comment on column OPERACION.CIERRE_TAREA_AGENDA.esttarea
  is 'estado tarea';
comment on column OPERACION.CIERRE_TAREA_AGENDA.USUREG
  is 'Usuario   que   insertó   el registro';
comment on column OPERACION.CIERRE_TAREA_AGENDA.FECREG
  is 'Fecha que inserto el registro';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CIERRE_TAREA_AGENDA
  add constraint pk_CIERRE_TAREA_AGENDA primary key (idseq , TAREADEF);