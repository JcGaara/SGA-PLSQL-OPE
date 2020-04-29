
delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='REMARK_COBRO_OCC');
delete from tipopedd where upper(abrev) = 'REMARK_COBRO_OCC';		   

COMMIT;
/