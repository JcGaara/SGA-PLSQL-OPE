create or replace package body operacion.sftp
as
function enviarArchivo(usuario varchar2,
                       clave varchar2,
                       host varchar2,
                       puerto number,
                       know_host varchar2,
                       rutArchivOrigen varchar2,
                       rutArchivDestino varchar2) return varchar2 as
language java name 'ope.sftp.ope_sftp.enviarArchivo(java.lang.String,java.lang.String,java.lang.String,int,java.lang.String,java.lang.String,java.lang.String) return java.lang.String';

function renomArchivo(usuario varchar2,
                      clave varchar2,
                      host varchar2,
                      puerto number,
                      know_host varchar2,
                      ArchivoAnt varchar2,
                      ArchivNuev varchar2
                      ) return varchar2 as 
language java name 'ope.sftp.ope_sftp.renomArchivo(java.lang.String,java.lang.String,java.lang.String,int,java.lang.String,java.lang.String,java.lang.String) return java.lang.String';

function eliminArchivo(usuario varchar2,
                       clave varchar2,
                       host varchar2,
                       puerto number,
                       know_host varchar2,
                       rutArchivo varchar2) return varchar2 as 
language java name 'ope.sftp.ope_sftp.eliminArchivo(java.lang.String,java.lang.String,java.lang.String,int,java.lang.String,java.lang.String) return java.lang.String';

function verifArchivo(usuario varchar2,
                      clave varchar2,
                      host varchar2,
                      puerto number,
                      know_host varchar2,
                      rutArchivo varchar2) return varchar2 as
language java name 'ope.sftp.ope_sftp.verifArchivo(java.lang.String,java.lang.String,java.lang.String,int,java.lang.String,java.lang.String) return java.lang.String';

end;
/
