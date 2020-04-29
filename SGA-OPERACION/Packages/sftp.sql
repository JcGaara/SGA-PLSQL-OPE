create or replace package operacion.sftp
as

function enviarArchivo(usuario varchar2,
                       clave varchar2,
                       host varchar2,
                       puerto number,
                       know_host varchar2,
                       rutArchivOrigen varchar2,
                       rutArchivDestino varchar2
                      ) return varchar2;

function renomArchivo(usuario varchar2,
                      clave varchar2,
                      host varchar2,
                      puerto number,
                      know_host varchar2,
                      ArchivoAnt varchar2,
                      ArchivNuev varchar2
                      ) return varchar2;

function eliminArchivo(usuario varchar2,
                       clave varchar2,
                       host varchar2,
                       puerto number,
                       know_host varchar2,
                       rutArchivo varchar2
                      ) return varchar2;

function verifArchivo(usuario varchar2,
                      clave varchar2,
                      host varchar2,
                      puerto number,
                      know_host varchar2,
                      rutArchivo varchar2
                      ) return varchar2;

end sftp;
/
