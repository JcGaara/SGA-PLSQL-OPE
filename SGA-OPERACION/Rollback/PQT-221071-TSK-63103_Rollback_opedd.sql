declare
n_seq number;
begin
  update operacion.opedd
     set descripcion='10.245.23.41'
   where tipopedd=(select tipopedd from operacion.tipopedd where abrev='PARAM_DTH')
     and codigoc='Host';
  commit;
  select seq
    into n_seq
    from sys.dba_java_policy d
   where d.grantee = 'OPERACION'
     and type_name = 'java.net.SocketPermission'
     and name = '10.136.123.140:22'
     and action = 'connect,resolve';
dbms_java.revoke_permission('OPERACION','SYS:java.net.SocketPermission','10.136.123.140:22','connect,resolve');
dbms_java.delete_permission(n_seq);
end;
/