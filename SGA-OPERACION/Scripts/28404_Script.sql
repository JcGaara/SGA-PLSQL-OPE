INSERT INTO OPERACION.MOTOTXTIPTRA(idmotxtip,TIPTRA,CODMOTOT)
SELECT rownum,TIPTRA,0 FROM TIPTRABAJO;
COMMIT;
/


-- Agregar Columnas tabla Agendamiento
alter table OPERACION.AGENDAMIENTO add CID number;
alter table OPERACION.AGENDAMIENTO add CODINSSRV NUMBER(10);
alter table OPERACION.AGENDAMIENTO add NUMERO varchar2(20);
-- Comentarios campos tabla Agendamiento
comment on column OPERACION.AGENDAMIENTO.CID  is 'Numero de Circuito';
comment on column OPERACION.AGENDAMIENTO.CODINSSRV  is 'Codigo de Instancia de Servicio';
comment on column OPERACION.AGENDAMIENTO.NUMERO  is 'Numero de Servicio';

-- Agregar Columnas tabla Tareawfdef
alter table OPEWF.TAREAWFDEF add REGLA_ASIG_CONTRATA NUMBER;
alter table OPEWF.TAREAWFDEF add REGLA_ASIG_FECPROG NUMBER;
-- Comentarios campos tabla Tareawfdef
comment on column OPEWF.TAREAWFDEF.REGLA_ASIG_CONTRATA  is 'Regla de asignacion de Contrata : Distrito, Plano, Cuadrilla Propia';
comment on column OPEWF.TAREAWFDEF.REGLA_ASIG_FECPROG  is 'Regla de asignacion de Fecha de Programacion :  Nula, FecCompromisoSOT';

-- Agregar Columnas Log
alter table OPERACION.AGENDAMIENTO_LOG add CID NUMBER;
alter table OPERACION.AGENDAMIENTO_LOG add CODINSSRV NUMBER(10);
alter table OPERACION.AGENDAMIENTO_LOG add NUMERO varchar2(20);
-- Comentarios campos tabla Tareawfdef
comment on column OPERACION.AGENDAMIENTO_LOG.CID is 'Numero de Circuito';
comment on column OPERACION.AGENDAMIENTO_LOG.CODINSSRV is 'Codigo de Instancia de Servicio';
comment on column OPERACION.AGENDAMIENTO_LOG.NUMERO is 'Numero de Servicio';