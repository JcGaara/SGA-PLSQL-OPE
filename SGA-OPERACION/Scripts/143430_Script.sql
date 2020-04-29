-- Add/modify columns 
alter table OPERACION.OPE_EQU_IW add ID_SEQ number;
comment on column OPERACION.OPE_EQU_IW.ID_SEQ is 'Secuencial';

alter table OPERACION.OPE_EQU_IW add EVENTO VARCHAR2(3);
comment on column OPERACION.OPE_EQU_IW.EVENTO is 'Evento';

alter table OPERACION.OPE_EQU_IW add ESTADO number default 0;
comment on column OPERACION.OPE_EQU_IW.ESTADO is '0 : No procesado 1 : Procesado';

-- Drop primary, unique and foreign key constraints 
alter table OPERACION.OPE_EQU_IW
  drop constraint PK_EQU_IW_OPE cascade;

update OPERACION.OPE_EQU_IW set id_seq=rownum;
/
commit;

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_EQU_IW
  add constraint PK_EQU_IW_OPE_001 primary key (ID_SEQ);


