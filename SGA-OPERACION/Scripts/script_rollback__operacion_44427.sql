
delete from opedd where tipopedd in ( select tipopedd 
				     from tipopedd 
				     where abrev='TPI_GSM_LIBERACION');
commit;

Delete from tipopedd where abrev='TPI_GSM_LIBERACION';
commit;

-- delete tipo de trabajo
DELETE FROM OPEDD
 WHERE TIPOPEDD IN
       (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'Tiptrabajo_TPIGSM');
commit;


DELETE FROM TIPOPEDD WHERE ABREV = 'Tiptrabajo_TPIGSM';
commit;

-- delete del wfdef
DELETE FROM OPEDD
 WHERE TIPOPEDD IN
       (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'WF_TPI_GSM');
commit;


DELETE FROM TIPOPEDD WHERE ABREV = 'WF_TPI_GSM';
commit;

