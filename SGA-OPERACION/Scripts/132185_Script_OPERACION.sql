-- Add/modify columns 
alter table OPERACION.MOT_SOLUCIONXTIPTRA add aplica_contrata NUMBER default 1;
-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXTIPTRA.aplica_contrata
  is '1:Visualiza Contrata 0:No visualiza Contrata';
-- Add/modify columns 
alter table OPERACION.MOT_SOLUCIONXTIPTRA add aplica_pext NUMBER default 0;
-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXTIPTRA.aplica_pext
  is '1:Visualiza PEXT 0:No visualiza PEXT';

-- Add/modify columns 
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA add APLICA_PEXT number default 0;
-- Add comments to the columns 
comment on column OPERACION.SECUENCIA_ESTADOS_AGENDA.APLICA_PEXT
  is '1:Visualiza PEXT 0:No visualiza PEXT';

-- Add/modify columns 
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA add IDSEQ number;
-- Add comments to the columns 
comment on column OPERACION.SECUENCIA_ESTADOS_AGENDA.IDSEQ
  is 'Secuencial';
