-- Add/modify columns 
alter table OPERACION.EFAUTOMATICO drop column preproc;
alter table OPERACION.EFAUTOMATICO add preproc CLOB;