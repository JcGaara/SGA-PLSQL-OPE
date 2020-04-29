ALTER TABLE SALES.VTADETPTOENL DROP COLUMN IDCUENTA;
delete from opedd where tipopedd =  (select tipopedd from tipopedd where abrev = 'CLOUD');
delete from opedd where tipopedd =  (select tipopedd from tipopedd where abrev = 'MSJ_SGA');
delete from opedd where tipopedd =  (select tipopedd from tipopedd where abrev = 'ASOC_GRUP');
delete from tipopedd where abrev = 'CLOUD';
delete from tipopedd where abrev = 'MSJ_SGA';
delete from tipopedd where abrev = 'ASOC_GRUP';

Commit;

/
