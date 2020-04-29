-- Add/modify columns 
alter table OPERACION.SOLOTPTO add segment_name VARCHAR2(15);
alter table OPERACION.SOLOTPTO add cell_id VARCHAR2(15);
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTO.segment_name
  is 'Segment Name';
comment on column OPERACION.SOLOTPTO.cell_id
  is 'Cell ID';

-- Add/modify columns 
alter table OPERACION.SOLOT add resumen VARCHAR2(100);
-- Add comments to the columns 
comment on column OPERACION.SOLOT.resumen
  is 'Codigo de abreviacion WIMAX';
-- Add/modify columns 
alter table OPERACION.SOLOT add cod_id number;
-- Add comments to the columns 
comment on column OPERACION.SOLOT.cod_id
  is 'CO ID SISACT';

-- Add/modify columns 
alter table OPERACION.AGENDAMIENTO add CODMOTIVO_TC VARCHAR2(3);
alter table OPERACION.AGENDAMIENTO add CODMOTIVO_CO VARCHAR2(3);
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTO.CODMOTIVO_TC
  is 'Codigo Motivo de Venta - Tipo de Cliente';
comment on column OPERACION.AGENDAMIENTO.CODMOTIVO_CO
  is 'Codigo Motivo de Venta - Competidor';

