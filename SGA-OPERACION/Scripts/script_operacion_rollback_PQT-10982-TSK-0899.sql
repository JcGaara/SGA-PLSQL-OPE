alter table OPERACION.TIPTRABAJO drop column HORAS;
alter table OPERACION.TIPTRABAJO drop column AGENDA;
alter table OPERACION.TIPTRABAJO drop column HORA_INI;
alter table OPERACION.TIPTRABAJO drop column HORA_FIN;
alter table OPERACION.TIPTRABAJO drop column AGENDABLE;
alter table OPERACION.TIPTRABAJO drop column NUM_REAGENDA;
alter table OPERACION.TIPTRABAJO drop column HORAS_ANTES;

ALTER TABLE ATCCORP.ATCINCIDENCEXSOLOT
drop CONSTRAINT IDX_ATCINCIDENCESOLOT;

drop sequence OPERACION.SQ_TECNICOSCONTRATA_REL;
drop sequence OPERACION.SQ_CUADRILLAHORA_REL;

drop trigger operacion.T_ope_cuadrillahora_rel_AIUD;
drop trigger operacion.T_ope_tecnicos_rel_AIUD;

drop trigger operacion.T_OPE_CUADRILLAHORA_REL_BI;
drop trigger operacion.T_OPE_TECNICOSCONTRATA_REL_BI;


drop table operacion.ope_cuadrillahora_rel;
drop table operacion.ope_tecnicoscontrata_rel;

drop table historico.ope_cuadrillahora_rel_log;
drop table historico.ope_tecnicoscontrata_rel_log;


alter table OPERACION.DISTRITOXCONTRATA
  add constraint PK_DISTRITOXCONTRATA primary key (CODCON, CODUBI, TIPTRA)
  using index 
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


alter table OPERACION.DISTRITOXCONTRATA
  add constraint UK_PRIORIDAD unique (CODUBI, TIPTRA, PRIORIDAD)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


delete from  estagenda where estage = 22;


ALTER TABLE OPERACION.CONTRATA DROP COLUMN PRIORIDAD ;

drop package atccorp.PQ_CUADRILLA;

