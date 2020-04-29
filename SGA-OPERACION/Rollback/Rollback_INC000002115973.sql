-- tabla OPERACION.EFPTO
alter table OPERACION.EFPTO add nrolineas_bk NUMBER(4);
alter trigger OPERACION.T_EFPTO_BU disable;
update OPERACION.EFPTO set nrolineas_bk = to_number(nrolineas);
COMMIT;
update OPERACION.EFPTO set nrolineas = NULL;
COMMIT;
alter table OPERACION.EFPTO modify nrolineas NUMBER(3);
update OPERACION.EFPTO set nrolineas = nrolineas_bk;
COMMIT;
alter table OPERACION.EFPTO drop column nrolineas_bk;
alter trigger OPERACION.T_EFPTO_BU enable;
/
