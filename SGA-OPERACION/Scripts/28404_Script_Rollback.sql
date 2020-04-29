-- Drop tablas y Sequences
DROP TABLE OPERACION.MOTOTXTIPTRA;
DROP table HISTORICO.MOTOTXTIPTRA_LOG;
DROP sequence OPERACION.SQ_OPERACION_MOTOTXTIPTRA;

-- Drop Agendamiento
alter table OPERACION.AGENDAMIENTO drop column CID;
alter table OPERACION.AGENDAMIENTO drop column CODINSSRv;
alter table OPERACION.AGENDAMIENTO drop column NUMERO;

-- Drop Log de Agendamiento
alter table OPERACION.AGENDAMIENTO_LOG drop column CID;
alter table OPERACION.AGENDAMIENTO_LOG drop column CODINSSRV;
alter table OPERACION.AGENDAMIENTO_LOG drop column NUMERO;

-- Drop Columnas Tareawfdef
alter table OPEWF.TAREAWFDEF drop column REGLA_ASIG_CONTRATA;
alter table OPEWF.TAREAWFDEF drop column REGLA_ASIG_FECPROG;