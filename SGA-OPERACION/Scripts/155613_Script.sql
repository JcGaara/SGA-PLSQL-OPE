-- Add/modify columns 
alter table OPERACION.SOLOTPTOEQU add CODMOTIVO_AVERIA VARCHAR2(10);
-- Add comments to the columns 
comment on column OPERACION.SOLOTPTOEQU.CODMOTIVO_AVERIA
  is 'Motivo de Averia';