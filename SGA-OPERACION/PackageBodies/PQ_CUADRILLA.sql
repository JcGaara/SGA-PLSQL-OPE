create or replace package body atccorp.PQ_CUADRILLA is

/***********************************************************************************************
    NOMBRE:     ATCCORP.PQ_CUADRILLA
    PROPOSITO:  Realizar toda la funcionalidad de Agendamiento de cuadrilla de Perú
    PROGRAMADO EN JOB:  NO

    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        25/10/2011  Alfonso Pérez        Elver Ramirez         REQ-159092: Se crea el paquete pq_cuadrilla
  **********************************************************************************************/


procedure p_actualizacuadrilla(an_codincidence in number,
                               a_fecccom       in varchar) is


an_cantidad number;
an_hora    number;
an_var number;
ad_horaini varchar2(15);
ad_horafin varchar2(15);
ad_fecha varchar2(15);
an_codsolot number;

begin

an_var := 1;

       select codsolot
         into an_codsolot
         from atcincidencexsolot
        where CODINCIDENCE = an_codincidence ;

       update agendamiento
          set fecha_instalacion = a_fecccom ,
              fecagenda = a_fecccom
        where CODSOLOT = an_codsolot  ;


end p_actualizacuadrilla;


procedure p_agendacuadrilla(a_fecccom       in varchar2,
                                    an_tiptra       in number,
                                    an_codincidence in number,
                                    as_codcli       in varchar2,
                                    an_resultado    out number) is


an_cantidad number;
an_hora    number;
an_var number;
ad_horaini varchar2(15);
ad_horafin varchar2(15);
ad_fecha varchar2(15);
ad_horaini_var varchar2(15);
ad_horafin_var varchar2(15);

cursor c_cuadrilla(an_tiptra number, ac_codcli varchar2) is
select a.tiptra,
a.descripcion,
b.codubi,
b.codcon,
b.prioridad prio1,
c.codcuadrilla
from tiptrabajo a ,
distritoxcontrata b ,
CUADRILLAXCONTRATA c
where a.tiptra = an_tiptra
and b.codubi = (select codubi
                from vtatabcli
                where codcli = as_codcli)
and a.tiptra = b.tiptra
and b.codcon = c.codcon
and c.estado = 1
order by prio1 asc;

i number;
j number;
num number;

begin

an_var := 1;
j := 1 ;

   for c_reg in c_cuadrilla(an_tiptra,as_codcli) loop

    if (an_var = 1) then

       select horas
         into an_hora
         from tiptrabajo
        where tiptra = an_tiptra;

        select to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss'),
                  'dd/mm/yyyy'),
               to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss'),
                  'hh24:mi:ss'),
               to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss') +
                  an_hora / 24 ,
                  'hh24:mi:ss'),
               to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss')-
                   1 / 24 ,
                  'hh24:mi:ss'),
               to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss') +
                  an_hora / 24 - 1 / 24,
                  'hh24:mi:ss')
          into ad_fecha,
               ad_horaini,
               ad_horafin,
               ad_horaini_var,
               ad_horafin_var
          from dummy_ope;

       select count(1)
         into an_cantidad
         from OPERACION.OPE_CUADRILLAHORA_REL
        where codcuadrilla = c_reg.codcuadrilla
          and hora_ini= ad_horaini
          and fecha_trabajo = ad_fecha
          and estado <> 3;

       if an_cantidad = 0 then

             an_var := 0;

              insert into operacion.ope_cuadrillahora_rel(codcuadrilla,
                          estado,
                          codincidence,
                          tiptra,
                          codcli,
                          hora_ini,
                          hora_fin,
                          hora_ini_var,
                          hora_fin_var,
                          horas,
                          fecha_trabajo)
                   values(c_reg.codcuadrilla,
                          1,
                          an_codincidence,
                          an_tiptra,
                          as_codcli,
                          ad_horaini,
                          ad_horafin,
                          ad_horaini_var,
                          ad_horafin_var,
                          an_hora,
                          ad_fecha);

                   commit;

        end if;
     end if;
   end loop;

   an_resultado := an_var;

end p_agendacuadrilla;


procedure p_cancelaragenda (an_codincidence in number,
                            an_res          out number) is


an_cantidad number;
an_hora    number;
an_var number;
ad_horaini varchar2(15);
ad_horafin varchar2(15);
ad_fecha varchar2(15);
an_estado number;
an_idagenda  number;
an_estage number;
ln_seq number;

begin

      select estado
        into an_estado
        from operacion.ope_cuadrillahora_rel
       where CODINCIDENCE =an_codincidence;

       if an_estado = 0 or an_estado = 3 then

            an_res := 0 ;-- ok

       else

           update operacion.ope_cuadrillahora_rel
              set estado = 3
            where CODINCIDENCE = an_codincidence;

            select idagenda ,
                   estage
              into an_idagenda ,
                   an_estage
              from agendamiento
             where fecreg = (select max(fecreg) from agendamiento where codincidence = an_codincidence);

            pq_agendamiento.p_chg_est_agendamiento(an_idagenda,5,an_estage,'Cancelamiento');

            select max(codsequence)
              into ln_seq
            from  incidence_sequence where codincidence = an_codincidence ;

             UPDATE incidence_sequence
                SET CODSTATUS = 5
              where codincidence = an_codincidence
                and codsequence = ln_seq ;

             UPDATE INCIDENCE
                SET CODSTATUS = 5
              where codincidence = an_codincidence ;


            an_res := 1;

       end if;


end p_cancelaragenda;


procedure p_envia_correocancela(an_codincidence number,
                                o_resultado     out number,
                                o_mensaje       out varchar2) is


    ls_mensaje         varchar2(1000);
    ls_subject         varchar2(200);
    ld_codincidence    incidence.codincidence%type;
    ld_ticket          incidence.nticket%type;
    ls_tipo_incidencia varchar2(200);
    ld_dias            atc_evaluar_ampliacion_cab.dias%type;
    ld_monto           atc_evaluar_ampliacion_cab.monto%type;
    ls_cliente         vtatabcli.nomcli%type;
    ls_servicio        varchar2(200);
    ls_desc_servicio   tystabsrv.dscsrv%type;
    ls_usuario_sol     atc_evaluar_ampliacion_cab.usureg%type;
    ls_observaciones   atc_evaluar_ampliacion_cab.observacion%type;
    v_resultado        number;
    v_mensaje          varchar2(3000);
    ln_tiptra          number;
    ls_fechatrabajo    varchar2(200);
    ls_codcuadrilla    varchar2(200);
    ls_codcli          varchar2(200);
    ln_idagenda        number;
    ls_codsolot        varchar2(200);
    ln_estado          number;
    ls_codubi          varchar2(200);
    ls_nomcli          varchar2(200);
    ln_codcon          number;
    ls_nombre          varchar2(200);
    ls_descripcion     varchar2(200);
    ls_distrito        varchar2(200);
    ls_nomtrabajo      varchar2(200);
    ls_observacion     varchar2(200);
    ls_email           varchar2(200);
    ln_codsolot        number;
    ls_dircli          varchar2(480);
    ls_hora            varchar2(15);
    ls_codsuc          varchar2(10);
    ls_plano           varchar2(10);

  begin
    v_resultado := 0;
    v_mensaje   := 'OK';
    --OBTENER DATOS
    begin

      select tiptra,
             fecha_trabajo,
             codcuadrilla,
             codcli,
             hora_ini
        into ln_tiptra,
             ls_fechatrabajo,
             ls_codcuadrilla,
             ls_codcli,
             ls_hora
        from operacion.ope_cuadrillahora_rel
       where codincidence = an_codincidence ;


      select codsolot
        into ln_codsolot
        from atcincidencexsolot
       where CODINCIDENCE = an_codincidence;

      select observacion
        into ls_observacion
        from atcincidencexsolot
       where codincidence = an_codincidence;


       select distinct codcli,
              codsolot,
              codubi
         into ls_codcli,
              ls_codsolot,
              ls_codubi
         from agendamiento
        where codincidence = an_codincidence
     group by (codcli,
               codsolot,
              codubi) ;

       select nomcli,dircli
         into ls_nomcli,ls_dircli
         from vtatabcli
        where codcli = ls_codcli;

        select descripcion
          into ls_email
          from OPEDD
         where abreviacion = 'CORREOS_CANCELA';

       select descripcion
         into ls_nomtrabajo
         from tiptrabajo
        where tiptra = ln_tiptra;

      select distinct(v_ubicaciones.distrito_desc)
         into ls_distrito
        from distritoxcontrata, v_ubicaciones
       where distritoxcontrata.codubi = v_ubicaciones.codubi(+)
         and distritoxcontrata.codubi =  ls_codubi;

      select distinct d.codsuc
        into ls_codsuc
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = ln_codsolot
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+);

      select idplano
        into ls_plano
        from vtasuccli
       where codcli = ls_codcli and codsuc = ls_codsuc ;

    exception
      when others then
        v_resultado := -1;
        v_mensaje   := 'Problemas al obtener datos de la solicitud de cancelación.';
    end;
    --ASUNTO DE LA NOTIFICACION
    ls_subject := ' CANCELACION AGENDA Nº SOT :' || to_char(ln_codsolot) || ' Distrito: '|| to_char(ls_distrito) || '.' ;

    --ARMAR NOTIFICACION Y ENVIAR A CADA APROBADOR

      ls_mensaje := '' ;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje ||
                    'Mediante este medio le informamos que se ha solicitado la cancelación de la agenda  ' ||
                    '. ';
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      ls_mensaje := ls_mensaje ||
                    'Los datos son los siguientes: ';
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      ls_mensaje := ls_mensaje || 'SOT                 : ' ||
                    to_char(ls_codsolot);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Incidencia          : ' ||
                    to_char(an_codincidence);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Código              : ' ||
                    to_char(ls_codcli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Nombre del Cliente  : ' ||
                    to_char(ls_nomcli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Dirección           : ' ||
                    to_char(ls_dircli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Plano               : ' ||
                    to_char(ls_plano);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Distrito            : ' ||
                    ls_distrito;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Fecha y Hora Agenda : ' ||
                    to_char(ls_fechatrabajo) ||' ' || to_char(ls_hora) ;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Observaciones       : ' ||
                    to_char(ls_observacion);
      ls_mensaje := ls_mensaje || chr(13);

      ls_mensaje := ls_mensaje ||
                    '==================================================';
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      begin
        opewf.pq_send_mail_job.p_send_mail(ls_subject,
                                           ls_email,
                                           ls_mensaje,
                                           'SGA');
      exception
        when others then
          v_resultado := -1;
          v_mensaje   := 'Problemas al enviar correo de Cancelamiento.';
      end;

    o_resultado := v_resultado;
    o_mensaje   := v_mensaje;

    if v_resultado <> -1 then
       commit ;
    end if;


end p_envia_correocancela;


procedure p_envia_correoreagenda(an_codincidence number,
                                 o_resultado      out number,
                                 o_mensaje        out varchar2) is

    ls_mensaje         varchar2(1000);
    ls_subject         varchar2(200);
    ld_codincidence    incidence.codincidence%type;
    ld_ticket          incidence.nticket%type;
    ls_tipo_incidencia varchar2(200);
    ld_dias            atc_evaluar_ampliacion_cab.dias%type;
    ld_monto           atc_evaluar_ampliacion_cab.monto%type;
    ls_cliente         vtatabcli.nomcli%type;
    ls_servicio        varchar2(200);
    ls_desc_servicio   tystabsrv.dscsrv%type;
    ls_usuario_sol     atc_evaluar_ampliacion_cab.usureg%type;
    ls_observaciones   atc_evaluar_ampliacion_cab.observacion%type;
    v_resultado        number;
    v_mensaje          varchar2(3000);
    ln_tiptra          number;
    ls_fechatrabajo    varchar2(200);
    ls_codcuadrilla    varchar2(200);
    ls_codcli          varchar2(200);
    ln_idagenda        number;
    ls_codsolot        varchar2(200);
    ln_estado          number;
    ls_codubi          varchar2(200);
    ls_nomcli          varchar2(200);
    ln_codcon          number;
    ls_nombre          varchar2(200);
    ls_descripcion     varchar2(200);
    ls_distrito        varchar2(200);
    ls_nomtrabajo      varchar2(200);
    ls_observacion     varchar2(200);
    ls_email           varchar2(200);
    ln_codsolot        number;
    ls_dircli          varchar2(200);
    ls_hora_ant        varchar2(15);
    ls_fecha_ant       varchar2(15);
    ls_hora            varchar2(15);
    ls_codsuc          varchar2(10);
    ls_plano           varchar2(10);
    --CURSOR CON USUARIOS APROBADORES

  begin
    v_resultado := 0;
    v_mensaje   := 'OK';
    --OBTENER DATOS
    begin

         select tiptra,
             fecha_trabajo,
             codcuadrilla,
             hora_ini
        into ln_tiptra,
             ls_fechatrabajo,
             ls_codcuadrilla,
             ls_hora
        from operacion.ope_cuadrillahora_rel
       where codincidence = an_codincidence ;

      select codsolot
        into ln_codsolot
        from atcincidencexsolot
       where CODINCIDENCE = an_codincidence;

      select observacion
        into ls_observacion
        from atcincidencexsolot
       where codincidence = an_codincidence;

       select distinct codcli,
              codsolot,
              codubi,
              estage
         into ls_codcli,
              ls_codsolot,
              ls_codubi,
              ln_estado
         from agendamiento
        where codincidence = an_codincidence
     group by (codcli,
               codsolot,
               codubi,
               estage) ;

      select distinct d.codsuc
        into ls_codsuc
        from solot a, vtatabcli b, solotpto c, inssrv d, vtasuccli e
       where a.codsolot = ln_codsolot
         and a.codcli = b.codcli(+)
         and a.codsolot = c.codsolot(+)
         and c.codinssrv = d.codinssrv(+)
         and d.codsuc = e.codsuc(+);

      select idplano
        into ls_plano
        from vtasuccli
       where codcli = ls_codcli and codsuc = ls_codsuc ;

       select nomcli, dircli
         into ls_nomcli ,ls_dircli
         from vtatabcli
        where codcli = ls_codcli;

       select descripcion
         into ls_email
         from OPEDD
        where abreviacion = 'CORREOS_REAGENDA';

       select descripcion
         into ls_descripcion
         from estagenda
        where estage = ln_estado;

       select descripcion
         into ls_nomtrabajo
         from tiptrabajo
        where tiptra = ln_tiptra;

      select distinct(v_ubicaciones.distrito_desc)
         into ls_distrito
        from distritoxcontrata, v_ubicaciones
       where distritoxcontrata.codubi = v_ubicaciones.codubi(+)
         and distritoxcontrata.codubi =  ls_codubi;

      select hora_ini ,
             fecha_trabajo
        into ls_hora_ant,
             ls_fecha_ant
        from HISTORICO.OPE_CUADRILLAHORA_REL_LOG
       where fecreg =(select max(fecreg) from HISTORICO.OPE_CUADRILLAHORA_REL_LOG where codincidence = an_codincidence);

    exception
      when others then
        v_resultado := -1;
        v_mensaje   := 'Problemas al obtener datos de la solicitud de Reagenda.';
    end;

    --ASUNTO DE LA NOTIFICACION
    ls_subject := ' Reagenda Nº SOT: ' || to_char(ln_codsolot) || ' Distrito: '|| ls_distrito || '.' ;
    --ARMAR NOTIFICACION Y ENVIAR A CADA APROBADOR
      ls_mensaje := '' ;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje ||
                    'Mediante este medio le informamos que se ha solicitado la Reagenda de la agenda  ' ||
                    '. ';
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      ls_mensaje := ls_mensaje ||
                    'Los datos son los siguientes: ';
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      ls_mensaje := ls_mensaje || 'SOT                        : ' ||
                    to_char(ls_codsolot);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Incidencia                 : ' ||
                    to_char(an_codincidence);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Código                     : ' ||
                    to_char(ls_codcli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Nombre del Cliente         : ' ||
                    to_char(ls_nomcli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Dirección                  : ' ||
                    to_char(ls_dircli);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Plano                      : ' ||
                    to_char(ls_plano);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Distrito                   : ' ||
                    ls_distrito;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Fecha y Hora Nueva Agenda  : ' ||
                    to_char(ls_fechatrabajo) ||' ' || to_char(ls_hora) ;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Fecha y Hora Antigua Agenda: ' ||
                    to_char(ls_fecha_ant) || ' ' ||to_char(ls_hora_ant) ;
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || 'Observaciones              : ' ||
                    to_char(ls_observacion);
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje ||
                    '==================================================';
      ls_mensaje := ls_mensaje || chr(13);
      ls_mensaje := ls_mensaje || chr(13) || chr(13);
      begin
        opewf.pq_send_mail_job.p_send_mail(ls_subject,
                                           ls_email,
                                           ls_mensaje,
                                           'SGA');
      exception
        when others then
          v_resultado := -1;
          v_mensaje   := 'Problemas al ENVIAR CORREO.';
      end;

    o_resultado := v_resultado;
    o_mensaje   := v_mensaje;

    if v_resultado <> -1 then
       commit ;
    end if;

end p_envia_correoreagenda;



procedure p_reagendacuadrilla(a_fecccom       in varchar2,
                              an_codincidence in number,
                              an_tiptra       in number,
                              as_observacion  in varchar2,
                              an_res          out number ) is


as_codcuadrilla  varchar2(5);
an_verifica      number;
an_cantidad      number;
an_hora          number;
an_var           number;
ad_horaini       varchar2(15);
ad_horafin       varchar2(15);
ad_horaini_var   varchar2(15);
ad_horafin_var   varchar2(15);
ad_fecha         varchar2(15);
an_estado        number;
an_fechatrabajo  varchar2(15);
an_codsolot      number;
ad_fechareagenda varchar2(25);
an_numero        number;
an_reagendas     number;
an_numeroactual  number;
an_transferencia number;
an_idagenda      number;
num              number;
i                number;
j                number;
as_codcli        varchar2(8);

cursor c_cuadrilla(an_tiptra number, as_codcli varchar2,ad_horas varchar2, ad_fechas varchar2) is
select a.tiptra,
a.descripcion,
b.codubi,
b.codcon,
b.prioridad prio1,
c.codcuadrilla
from tiptrabajo a ,
distritoxcontrata b ,
CUADRILLAXCONTRATA c
where a.tiptra = an_tiptra
and b.codubi = (select codubi
                from vtatabcli
                where codcli = as_codcli)
and a.tiptra = b.tiptra
and b.codcon = c.codcon
and c.estado = 1
and c.codcuadrilla not in (
select c.codcuadrilla
from operacion.tiptrabajo a ,
     operacion.distritoxcontrata b ,
     operacion.CUADRILLAXCONTRATA c ,
     operacion.ope_cuadrillahora_rel d
where a.tiptra = an_tiptra
  and c.codcuadrilla = d.codcuadrilla
  and b.codubi = (select codubi
                    from vtatabcli
                   where codcli = as_codcli)
  and a.tiptra = b.tiptra
  and b.codcon = c.codcon
  and c.estado = 1
  and d.estado <> 3
  and d.hora_ini = ad_horas
  and d.fecha_trabajo = ad_fechas) ;

begin

   select count(1)
     into an_cantidad
     from operacion.ope_cuadrillahora_rel
    where CODINCIDENCE =an_codincidence;

         if an_cantidad > 0 then

            select num_reagenda
              into an_numero
            from tiptrabajo
            where tiptra = an_tiptra;


            select estado,
                   fecha_trabajo,
                   numeroveces,
                   transferencia,
                   codcuadrilla,
                   codcli
              into an_estado,
                   an_fechatrabajo,
                   an_reagendas,
                   an_transferencia,
                   as_codcuadrilla,
                   as_codcli
              from operacion.ope_cuadrillahora_rel
             where CODINCIDENCE = an_codincidence;

             if (an_estado = 1) or (an_estado = 2 and an_transferencia = 1) then

                  select horas
                   into an_hora
                   from tiptrabajo
                  where TIPTRA = an_tiptra;

                 select  to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss'),
                            'dd/mm/yyyy hh24:mi:ss'),
                         to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss'),
                            'dd/mm/yyyy'),
                         to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss'),
                            'hh24:mi:ss'),
                         to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss') +
                            an_hora / 24 ,
                            'hh24:mi:ss'),
                         to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss')-
                             1 / 24 ,
                            'hh24:mi:ss'),
                         to_char(to_date(a_fecccom, 'dd/mm/yyyy hh24:mi:ss') +
                            an_hora / 24 - 1 / 24,
                            'hh24:mi:ss')
                    into ad_fechareagenda,
                         ad_fecha,
                         ad_horaini,
                         ad_horafin,
                         ad_horaini_var,
                         ad_horafin_var
                    from dummy_ope;

                 an_numeroactual := an_reagendas + 1;

                select num_reagenda
                  into an_numero
                from tiptrabajo
                where tiptra = an_tiptra;

                an_verifica := 0;

              for c_reg in c_cuadrilla(an_tiptra,as_codcli,ad_horaini,ad_fecha) loop

                  if an_verifica = 0 then

                     if an_numero = an_numeroactual then

                         update operacion.ope_cuadrillahora_rel
                            set hora_ini = ad_horaini,
                                hora_fin= ad_horafin,
                                hora_ini_var = ad_horaini_var,
                                hora_fin_var= ad_horafin_var,
                                horas= an_hora,
                                fecha_trabajo = ad_fecha,
                                estado = 2,
                                transferencia = 2,
                                NUMEROVECES = an_numeroactual,
                                codcuadrilla = c_reg.codcuadrilla
                          where CODINCIDENCE = an_codincidence;

                      else

                         update operacion.ope_cuadrillahora_rel
                            set hora_ini = ad_horaini,
                                hora_fin= ad_horafin,
                                hora_ini_var = ad_horaini_var,
                                hora_fin_var= ad_horafin_var,
                                horas= an_hora,
                                fecha_trabajo = ad_fecha,
                                NUMEROVECES = an_numeroactual,
                                estado = 2,
                                codcuadrilla = c_reg.codcuadrilla
                          where CODINCIDENCE = an_codincidence;

                      end if;
                          an_verifica := 1   ;
                      commit;

                      select codsolot
                        into an_codsolot
                        from atcincidencexsolot
                       where CODINCIDENCE = an_codincidence;

                      update atcincidencexsolot
                         set observacion = as_observacion
                       where CODINCIDENCE = an_codincidence;

                       update agendamiento
                          set fecagenda = ad_fechareagenda,
                              estage = 22
                        where CODINCIDENCE = an_codincidence;

                        update solot
                           set feccom = ad_fechareagenda
                         where codsolot = an_codsolot;

                         select idagenda
                           into an_idagenda
                           from agendamiento
                          where CODINCIDENCE = an_codincidence;


                        insert into agendamientochgest
                          (idagenda, tipo, estado, observacion)
                        values
                          (an_idagenda, 1, 22,'Reagendado' );

                         an_res := 1 ;-- ok

                 end if;

             end loop;


             end if;

             if an_verifica = 0 then
                  an_res := 9 ; -- no se ha registrado correctamente
             end if;



             if an_estado = 0 then
                  an_res := 2 ; -- no se ha registrado correctamente
             end if;

             if an_estado = 2 and an_transferencia = 2 then
                 an_res := 3; -- no es `posible reagendar mas de una vez
             end if;

             if an_estado = 3 then
                  an_res := 4 ; -- Se encuentra Cancelada
             end if;


         else

             an_res := 5; -- no se encontro registro en la tabla

         end if;

end p_reagendacuadrilla;


function f_verificahora(a_fecccom   in varchar2,
                        an_tiptra   in number)
return varchar2 is

an_cantidad number;
an_hora    number;
an_var number;
ad_horaini varchar2(15);
ad_horafin varchar2(15);
ad_fecha varchar2(15);
ad_horaini_var varchar2(15);
ad_horafin_var varchar2(15);
an_horasantes number;
as_horaverificar varchar2(20);
as_fechaactual varchar2(20);
ad_horaverificar date;
ad_fechaactual date;
ls_yy varchar2(20);
ls_mm varchar2(20);
ls_dd varchar2(20);
ls_yy_c varchar2(20);
ls_mm_c varchar2(20);
ls_dd_c varchar2(20);
as_hora varchar2(20);
ll_evalua number;


begin

         ll_evalua := 1;

         select (horas_antes)/ 24
           into an_horasantes
           from tiptrabajo
          where tiptra = an_tiptra;

         select to_char(to_date(a_fecccom, 'dd/mm/yyyy') -
                  an_horasantes ,'dd/mm/yyyy')
           into as_horaverificar
           from dummy_ope;


         return(as_horaverificar);

end;

function f_obtiene_cuadrilla(as_codcli in varchar2, an_tiptra in number)
return number is

an_cantidad number;

begin
  select count(1)
    into an_cantidad
  from tiptrabajo a ,
  distritoxcontrata b ,
  CUADRILLAXCONTRATA c
  where a.tiptra = an_tiptra
  and b.codubi = (select codubi
             from vtatabcli
             where codcli = as_codcli)
  and a.tiptra = b.tiptra
  and b.codcon = c.codcon
  and c.estado = 1;


  return(an_cantidad);

end;

end PQ_CUADRILLA;
/