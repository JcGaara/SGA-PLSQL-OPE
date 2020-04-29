-- Create table
create table OPERACION.ope_chgfechaservicio_his
(
  idchgfecserv number not null,
  codsolot     number(8) not null,
  fecservold   date,
  fecservnew   date,
  observacion  varchar2(200),
  usureg       varchar2(30) default user,
  fecreg       date default sysdate,
  usumod       varchar2(30) default user,
  fecmod       date default sysdate
)
;
-- Add comments to the columns 
comment on column OPERACION.ope_chgfechaservicio_his.idchgfecserv
  is 'ID correlativo';
comment on column OPERACION.ope_chgfechaservicio_his.codsolot
  is 'Numero de SOT';
comment on column OPERACION.ope_chgfechaservicio_his.fecservold
  is 'Fecha de activacion del servicio';
comment on column OPERACION.ope_chgfechaservicio_his.fecservnew
  is 'Nueva fecha de activacion del servicio';
comment on column OPERACION.ope_chgfechaservicio_his.observacion
  is 'Comenterio sobre cambio de fecha';
comment on column OPERACION.ope_chgfechaservicio_his.usureg
  is 'Usuario 	que 	insertó 	el registro';
comment on column OPERACION.ope_chgfechaservicio_his.fecreg
  is 'Fecha que inserto el registro';
comment on column OPERACION.ope_chgfechaservicio_his.usumod
  is 'Usuario 	que modificó 	el registro';
comment on column OPERACION.ope_chgfechaservicio_his.fecmod
  is 'Fecha 	que se 	modificó el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.ope_chgfechaservicio_his
  add constraint pk_ope_chgfechaservicio_his primary key (IDCHGFECSERV);