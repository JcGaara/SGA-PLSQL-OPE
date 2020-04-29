--Se aplica alter a la tabla OPERACION.PLANO

alter table OPERACION.PLANO add USUREV    VARCHAR2(30);
comment on column OPERACION.PLANO.USUREV  is 'Usuario de revisión';




