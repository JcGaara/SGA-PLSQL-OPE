alter table operacion.mototxtiptra add (TIPSERV NUMBER);
--internet
update operacion.mototxtiptra set TIPSERV = 1 where CODMOTOT in (141,142,143,144,146,148,145,149) and TIPTRA = 844;
--cable
update operacion.mototxtiptra set TIPSERV = 3 where CODMOTOT in (956,150,153,156,152,157,154,155,674,661) and TIPTRA = 844;
commit;
