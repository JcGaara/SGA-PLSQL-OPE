CREATE OR REPLACE TRIGGER OPERACION.T_LICENCIAANTIVIRUS_BU
BEFORE UPDATE
ON OPERACION.LICENCIAANTIVIRUS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/******************************************************************************
Version     Fecha       Autor            Descripción.
---------  ----------  ---------------   ------------------------------------
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/
DECLARE
lr_usuclaro usuariomitelmex%rowtype;
ls_usuario varchar2(2000);
ls_mensaje varchar2(2000);
ls_correo  varchar2(200);
ls_asunto varchar2(200);
ls_mensaje1 varchar2(200);
ls_mensaje2 varchar2(200);
ls_mensaje3 varchar2(200);
ls_mensaje4 varchar2(200);
ls_mensaje5 varchar2(200);


BEGIN
   --Estado Anulado
   IF :OLD.valido is null  then
      ls_correo:=:NEW.correo;
      select *  into lr_usuclaro from usuariomitelmex  where correo=ls_correo;

      ls_usuario:= lr_usuclaro.appaterno||''||lr_usuclaro.apmaterno||','||lr_usuclaro.nombres;
        ls_asunto   := 'Confirmación de Licencia Antivirus Panda ';
        ls_mensaje1 := 'Estimado (a): ' || ls_usuario ;
        ls_mensaje2 := ' Los datos de tu registro son:' ;
        ls_mensaje3 := 'Correo electrónico : ' || lr_usuclaro.correo;
        ls_mensaje4 := 'Licencia : ' || :OLD.licencia;
        ls_mensaje5 := 'Para cualquier duda o comentario en relación a tu registro, comunícate al 0800-00-333, donde con gusto te atenderemos.';
        ls_mensaje :=ls_mensaje1 ||chr(10)|| ls_mensaje2 ||chr(10)|| ls_mensaje3||chr(10)|| ls_mensaje4||chr(10)||ls_mensaje5 ;
        opewf.pq_send_mail_job.p_send_mail(ls_asunto,ls_correo,ls_mensaje,'infinitum.antivirus@claro.com.pe');--1.0
   END IF;
  exception
    when others then
      rollback;
END;
/



