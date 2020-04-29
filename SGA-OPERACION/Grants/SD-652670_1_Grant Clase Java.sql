grant execute any class to OPERACION;

begin
  dbms_java.grant_permission('OPERACION',
                             'SYS:java.net.SocketPermission','172.19.74.104:1521',
                             'connect,resolve');
end;
/