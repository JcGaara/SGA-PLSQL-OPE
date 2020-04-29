delete from OPERACION.TIPROY_SINERGIA where tiproy in ('FTN','FTO','FT4');

delete from operacion.tiproy_sinergia_pep t where  TIPROY in( 'FTN' , 'FTO', 'FT4') ;

commit;
/
