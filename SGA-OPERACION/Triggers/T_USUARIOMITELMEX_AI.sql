CREATE OR REPLACE TRIGGER OPERACION.T_USUARIOMITELMEX_AI
AFTER INSERT
ON OPERACION.USUARIOMITELMEX
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/******************************************************************************
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

ln_idusuario number;
ls_usuario varchar2(200);
ls_mensaje varchar2(2000);
ls_correo  varchar2(200);
ls_asunto varchar2(200);
ls_mensaje1 varchar2(200);
ls_mensaje2 varchar2(200);
ls_mensaje3 varchar2(200);
ls_mensaje4 varchar2(200);
ls_mensaje5 varchar2(200);
ls_telefono varchar2(200);

BEGIN

ln_idusuario:=:new.idusuario;
ls_usuario:= ' '||:new.appaterno|| ' ' ||:new.apmaterno|| ', '||:new.nombres;
ls_telefono:=:new.telefono;
ls_correo:=:new.correo;
  ls_asunto   := 'Confirmación de registro en MiClaro n° ' || to_char(ln_idusuario) || ' ';
  ls_mensaje1 := 'Estimado (a): ' || ls_usuario ;
  ls_mensaje2 := ' Los datos de tu registro son:' ;
  ls_mensaje3 := 'Teléfono : ' || ls_telefono;
  ls_mensaje4 := 'Correo : ' || ls_correo;
  ls_mensaje5 := 'Para cualquier duda o comentario en relación a tu registro, comunícaten al 0800-00-234, donde con gusto te atenderemos.';
  ls_mensaje :=ls_mensaje1||chr(10)||ls_mensaje2||chr(10)||ls_mensaje3||chr(10)||ls_mensaje4||chr(10)||ls_mensaje5 ;
  opewf.pq_send_mail_job.p_send_mail(ls_asunto,ls_correo,ls_mensaje,'infinitum.antivirus@claro.com.pe');--1.0
END;
/



