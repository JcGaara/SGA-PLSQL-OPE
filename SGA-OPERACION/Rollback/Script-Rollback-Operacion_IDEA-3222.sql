-- Drop sequence
DROP SEQUENCE OPERACION.SQ_PROC_ANULA_SOT_HFC_INST;

-- Drop columns 
alter table OPERACION.SOLOT drop column n_sec_proc_shell;

-- Delete Configuraciones
delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'TIPTRA_ANULA_SOT_INST_HFC');
delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'DIAS_ANULA_SOT_INST_HFC');
delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'EMAIL_ANULA_SOT_INST_HFC');
delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'UTL_FILE_ANULA_SOT_INST_HFC');

delete from tipopedd where abrev = 'TIPTRA_ANULA_SOT_INST_HFC';
delete from tipopedd where abrev = 'DIAS_ANULA_SOT_INST_HFC';
delete from tipopedd where abrev = 'EMAIL_ANULA_SOT_INST_HFC';
delete from tipopedd where abrev = 'UTL_FILE_ANULA_SOT_INST_HFC';

commit;
