update operacion.opedd
   set descripcion='10.136.123.140'
 where tipopedd=(select tipopedd from operacion.tipopedd where abrev='PARAM_DTH')
   and codigoc='Host';
commit;
call dbms_java.grant_permission('OPERACION','SYS:java.net.SocketPermission','10.136.123.140:22','connect,resolve');
