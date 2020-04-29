-- Add/modify columns 
alter table OPERACION.AGENDAMIENTOCHGEST add CODMOT_SOLUCION number;
-- Add comments to the columns 
comment on column OPERACION.AGENDAMIENTOCHGEST.CODMOT_SOLUCION
  is 'Motivo de Solucion';

-- Add/modify columns 
alter table OPERACION.FORMULA add FLG_MOTSOL NUMBER default 0;
-- Add comments to the columns 
comment on column OPERACION.FORMULA.FLG_MOTSOL
  is 'Motivos Solucion';
-- Add/modify columns 
alter table OPERACION.SOLOTPTO add CODINCIDENCE number;
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTO.CODINCIDENCE
  is 'Codigo de Incidencia';

