CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIA_CORREO_SOT_ATENDIDA(an_opcion number,
                                                                  an_codsolot number,                                         
                                                                  o_resultado      out number,
                                                                  o_mensaje        out varchar2) is



    ls_mensaje         varchar2(1000);
    ls_subject         varchar2(200);
    v_resultado        number;
    v_mensaje          varchar2(3000);
    ls_codcli          varchar2(200);
    ln_estado          number;
    ls_nomcli          varchar2(200);
    ls_descripcion     varchar2(200);
    ls_observacion     varchar2(200);
    ls_email           varchar2(200);
    ls_codusu          varchar2(200);
    --CURSOR CON USUARIOS APROBADORES

  begin
    v_resultado := 0;
    v_mensaje   := 'OK';
    --OBTENER DATOS
    begin

      
         
      
      select s.codcli,
             s.estsol,
             s.codusu
      into  ls_codcli,
            ln_estado,
            ls_codusu
      from OPERACION.solot s
      where s.codsolot = an_codsolot;

      SELECT NVL(observacion, '<Null>')
        INTO ls_observacion
        FROM solotchgest
       WHERE codsolot = an_codsolot
         AND idseq = (SELECT MAX(idseq)
                        FROM solotchgest
                       WHERE codsolot = an_codsolot);

       select nomcli
         into ls_nomcli
         from MARKETING.VTATABCLI
        where codcli = ls_codcli;



        ls_email := null ;
        begin
          select email into ls_email from usuarioope
          where usuario = ls_codusu;
        exception
          when others then
            ls_email :=NULL;
        end;
                

        select t.descripcion
          into ls_descripcion
        from operacion.estsol t
        where t.estsol = ln_estado;



    exception
      when others then
        v_resultado := -1;
        v_mensaje   := 'Problemas al obtener datos de la solicitud de ot.';
    end;
    --ASUNTO DE LA NOTIFICACION
    ls_subject := ' Detalle de cambio de estado de la SOT: ' ||
                  to_char(an_codsolot) || ' . ' ;
    --ARMAR NOTIFICACION 

      ls_mensaje := 'Cliente             : ' ||
                    to_char(ls_nomcli) || chr(13);
      ls_mensaje := ls_mensaje || 
                    '=================================================';             
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Nro. SOT                   : ' ||
                    to_char(an_codsolot);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Estado                     : ' ||
                    to_char(ls_descripcion);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Observacion                : ' ||
                    to_char(ls_observacion);
      ls_mensaje := ls_mensaje || chr(13);
      
      ls_mensaje := ls_mensaje ||
                    '==================================================';
      ls_mensaje := ls_mensaje || chr(13);


      
      begin
      IF   ls_email IS NOT NULL THEN
        opewf.pq_send_mail_job.p_send_mail(ls_subject,
                                           ls_email,
                                           ls_mensaje,
                                           'SGA');
       END IF;                                    
      exception
        when others then
          v_resultado := -1;
          v_mensaje   := 'Problemas al ENVIAR CORREO.';
      end;

    o_resultado := v_resultado;
    o_mensaje   := v_mensaje;



end;
/
