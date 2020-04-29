------
-- Create table
create table OPERACION.TRSOACSGAWF
(
 idtrswf number not null,
 idtrs number,
 proceso varchar2(50),
 estado varchar2(50),
 codusu varchar2(50) default user,
 fecusu date default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table
comment on table OPERACION.TRSOACSGAWF
 is 'Tabla de estados de ejecucion de las tareas del WF SGAOAC';
-- Add comments to the columns
comment on column OPERACION.TRSOACSGAWF.idtrswf
 is 'Proceso ejecutado.';
comment on column OPERACION.TRSOACSGAWF.idtrs
 is 'Codigo de Error.';
comment on column OPERACION.TRSOACSGAWF.proceso
 is 'Descripcion del Error.';
comment on column OPERACION.TRSOACSGAWF.estado
 is 'Descripcion del Error.';
comment on column OPERACION.TRSOACSGAWF.codusu
 is 'Descripcion del Error.';
comment on column OPERACION.TRSOACSGAWF.fecusu
 is 'Descripcion del Error.';
-- Create/Recreate indexes
create index OPERACION.IDX_TRSOACSGAWFIDTRS on OPERACION.TRSOACSGAWF(idtrs)
 tablespace OPERACION_IDX;
-- Create/Recreate primary, unique and foreign key constraints
alter table OPERACION.TRSOACSGAWF
 add constraint PK_TRSOACSGAWF primary key (idtrswf)
 using index
 tablespace OPERACION_DAT;
alter table OPERACION.TRSOACSGAWF
 add constraint FK_TRSOACSGAWF_TRSOACSGA foreign key (IDTRS)
 references OPERACION.TRSOACSGA (IDTRS);
