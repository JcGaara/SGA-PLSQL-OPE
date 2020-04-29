
-- Add/modify columns 
alter table OPERACION.TIPTRABAJO add HORAS NUMBER;
alter table OPERACION.TIPTRABAJO add AGENDA NUMBER(1);
alter table OPERACION.TIPTRABAJO add HORA_INI VARCHAR2(15);
alter table OPERACION.TIPTRABAJO add HORA_FIN VARCHAR2(15);
alter table OPERACION.TIPTRABAJO add AGENDABLE NUMBER(1) default 0;
alter table OPERACION.TIPTRABAJO add NUM_REAGENDA NUMBER(1);
alter table OPERACION.TIPTRABAJO add HORAS_ANTES NUMBER(4);
-- Add comments to the columns 
comment on column OPERACION.TIPTRABAJO.HORAS
  is 'NUMERO DE HORAS A REALIZAR EL TRABAJO';
comment on column OPERACION.TIPTRABAJO.AGENDA
  is 'EL TIPO DE TRABAJO VA SER AGENDABLE';
comment on column OPERACION.TIPTRABAJO.HORA_INI
  is 'HORA DE INICIO';
comment on column OPERACION.TIPTRABAJO.HORA_FIN
  is 'HORA DE FIN';
comment on column OPERACION.TIPTRABAJO.AGENDABLE
  is 'AGENDABLE :1 NO AGENDABLE: 0';
comment on column OPERACION.TIPTRABAJO.NUM_REAGENDA
  is 'NUMERO DE VECES A REAGENDAR';
comment on column OPERACION.TIPTRABAJO.HORAS_ANTES
  is 'DIAS DE ANTICIPACIÓN PARA REAGENDAR';


/

insert into estagenda(estage,descripcion) 
values(22,'Reagendado');

/


-- Drop primary, unique and foreign key constraints 
alter table OPERACION.DISTRITOXCONTRATA
  drop constraint PK_DISTRITOXCONTRATA cascade;

-- Drop primary, unique and foreign key constraints 
alter table OPERACION.DISTRITOXCONTRATA
  drop constraint UK_PRIORIDAD cascade;

/

-- Add/modify columns 
alter table OPERACION.CONTRATA add PRIORIDAD number(1) default 1;
-- Add comments to the columns 
comment on column OPERACION.CONTRATA.PRIORIDAD
  is 'Prioridad de la contrata.';

/
