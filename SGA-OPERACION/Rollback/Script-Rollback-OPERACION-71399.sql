--eliminar tipo y estado razon
delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='RAZON_BSCS_BAJAS');
delete from tipopedd where upper(abrev) = 'RAZON_BSCS_BAJAS';
delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='TIP_TRABAJO');
delete from tipopedd where upper(abrev) = 'TIP_TRABAJO';
delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='CONFI_ALINEA');
delete from tipopedd where upper(abrev) = 'CONFI_ALINEA';
delete from opedd where tipopedd = (select MAX(tipopedd) from tipopedd where upper(abrev) ='DIA_MASIVO');
delete from tipopedd where upper(abrev) = 'DIA_MASIVO';
--eliminar el package body 
drop package body operacion.pq_anulacion_bscs;
--eliminar el package
drop package operacion.pq_anulacion_bscs;
commit; 