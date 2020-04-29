CREATE OR REPLACE PACKAGE BODY OPERACION.pq_alerta_bod is

PROCEDURE p_alerta_tarea_generada_bod_am
IS
  /************************************************************
   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   1.0        27/04/2009  Joseph Asencios  REQ 90269: Envio de correo de alerta de activación(ó Desactivación) de Servicio BoD que se envia en la mañana.
   2.0        06/10/2010                      REQ.139588 Cambio de Marca

  *************************************************************/

   ln_can_lineas number;
   ls_direccion   varchar2(480);
   ls_contacto varchar2(80);
   ls_telefono varchar2(50);
   ls_email varchar2(100);
   ls_nomcli      varchar2(200);
   ls_linea       varchar2(500);
   ls_linea_srv   varchar2(500);
   ls_nomect      varchar2(200);
   ls_correo_para varchar2(2000);
   ls_cuerpo      varchar2(8000);
   ls_asunto      varchar2(150);
   a_correos       DBMS_SQL.varchar2s;

  cursor c_serv_bod  is
  select * from solot
  where tiptra = 367 and
  codsolot in (select codsolot from wf where idwf
  in (select idwf from tareawf where esttarea = 1));


  cursor c_sot(p_codsolot in varchar2) is
  select b.descripcion,trunc(a.feccom) feccom, to_char(a.feccom,'hh24:mi:ss') horacom,
         nvl(a.responsable,c.descripcion) responsable, a.observacion
        from tareawf a , tareadef b, areaope c, wf d
        where a.tareadef = b.tareadef and
              a.idwf = d.idwf and
              a.esttarea = 1 and
              a.area = c.area and
              d.codsolot = p_codsolot;

  cursor c_srv(p_codsolot in varchar2) is
  select i.codinssrv, i.codcli,i.cid, t.dscsrv, i.direccion
  from inssrv i, solotpto s, tystabsrv t
  where i.codinssrv = s.codinssrv and
        i.codsrv = t.codsrv and
        s.codsolot = p_codsolot ;

BEGIN

   --Correo de Alerta de Activación / Desactivación
   select descripcion into ls_correo_para  from opedd where tipopedd = 208 and codigon = 1;

   for c_bod in c_serv_bod loop
     --Asunto del  Correo
       ls_asunto:= 'SOT: ' || c_bod.codsolot || ', Activación (ó Desactivación) de Servicio BoD - CNS';
        --Formación del cuerpo del correo

        for c_solot in c_sot(c_bod.codsolot) loop
            ls_cuerpo := 'Detalle de la Solicitud BoD a ejecutarse el día de hoy ' || chr(13);
            ls_cuerpo := ls_cuerpo || chr(13);
            ls_cuerpo := ls_cuerpo || '[Detalle de la Solicitud de Orden de Trabajo]' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Tarea: ' || c_solot.descripcion ||  chr(13);
            ls_cuerpo := ls_cuerpo || 'Nro SOT: ' || c_bod.codsolot  || chr(13);
            ls_cuerpo := ls_cuerpo || 'Estado: Generada' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Fecha de Ejecución: ' || c_solot.feccom  || chr(13);
            ls_cuerpo := ls_cuerpo || 'Hora Programada: ' || c_solot.horacom || chr(13);
            ls_cuerpo := ls_cuerpo || 'Área: CNS(NOC)' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Responsable: ' || c_solot.responsable || chr(13);
            ls_cuerpo := ls_cuerpo || 'Observación: ' || c_solot.observacion || chr(13);
        end loop;

        ls_cuerpo := ls_cuerpo || chr(13);

        select nomcli into ls_nomcli from marketing.vtatabcli where codcli = c_bod.codcli;

        ls_cuerpo := ls_cuerpo || '[Datos del Usuario Solicitante - Cliente]' || chr(13);

        select nomcnt,telefono1,email into ls_contacto, ls_telefono, ls_email from incidence_bod
        where userdate = ( select max(userdate) from incidence_bod where codsolot = c_bod.codsolot);

        ls_cuerpo := ls_cuerpo || 'Cliente: ' || ls_nomcli  || chr(13);
        ls_cuerpo := ls_cuerpo || 'Usuario Solicitante: ' || ls_contacto ||  chr(13);
        ls_cuerpo := ls_cuerpo || 'Teléfono del Solicitante: ' || ls_telefono ||  chr(13);
        ls_cuerpo := ls_cuerpo || 'e-mail Solicitante: ' || ls_email || chr(13);

        ls_cuerpo := ls_cuerpo || chr(13) || chr(13);

        select rpad('CID',20,' ') || rpad('Servicio',60,' ') || rpad('Dirección',70,' ') || chr(13) ||
        rpad('-',15,'-') || rpad(' ',5,' ') || rpad('-',55,'-') || rpad(' ',5,' ') ||  rpad('-',70,'-')
        into ls_linea
        from dual;

        ls_cuerpo := ls_cuerpo || ls_linea || chr(13);

        for c_servicios in c_srv(c_bod.codsolot) loop

              if length(trim(c_servicios.direccion)) <= 70 then
                 ls_linea_srv := rpad(trim(c_servicios.cid),20,' ') || rpad(trim(c_servicios.dscsrv),60,' ') || rpad(trim(c_servicios.direccion),70,' ');

              else
                 ln_can_lineas := ceil(length(trim(c_servicios.direccion))/70) - 1;

                 ls_direccion := trim(c_servicios.direccion);

                 ls_linea_srv := rpad(trim(c_servicios.cid),20,' ') || rpad(trim(c_servicios.dscsrv),60,' ') || substr(ls_direccion,1,70) || chr(13);

                 for i in 1..ln_can_lineas loop

                      ls_linea_srv := ls_linea_srv || lpad(' ',80,' ') || substr(ls_direccion,i*70 + 1,70) || chr(13);

                 end loop;

              end if;

              ls_cuerpo := ls_cuerpo || ls_linea_srv || chr(13);
        end loop;

        ls_cuerpo := ls_cuerpo || chr(13);

        ls_cuerpo := ls_cuerpo || '[Datos del Asesor de Servicios]' || chr(13);

        /************************************************
        Asesor de Servicios de la Instalación de Internet
        *************************************************/

        select nomect into ls_nomect from vtatabect
        where codect in (select codsol from vtatabslcfac
                          where numslc in (select numslc from inssrv
                                           where codinssrv in (select distinct codinssrv from solotpto
                                                                      where codsolot = c_bod.codsolot)))
        and rownum = 1;

        ls_cuerpo := ls_cuerpo || 'Asesor de Servicios: ' || ls_nomect || chr(13);


        /**************************************************
         Se separan los correos configurados
        ***************************************************/
        a_correos.delete;
        PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_para,a_correos,c_separador);

        for i in 0.. (a_correos.count-1) loop

          --Aca va la lista de correos "DL-PE-CNSActivaciones"--2.0
          produccion.p_envia_correo_de_texto_att(as_subject => ls_asunto,
                                                 as_destino => a_correos(i),
                                                 as_cuerpo => ls_cuerpo);


        end loop;
  end loop;
  commit;
END;

PROCEDURE p_alerta_tarea_generada_bod_pm
IS
  /************************************************************
   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   1.0        27/04/2009  Joseph Asencios  REQ 90269: Envio de correo de alerta de activación(ó Desactivación) de Servicio BoD, enviado en la noche.

  *************************************************************/

   ln_can_lineas number;
   ls_direccion   varchar2(480);
   ls_contacto varchar2(80);
   ls_telefono varchar2(50);
   ls_email varchar2(100);
   ls_nomcli      varchar2(200);
   ls_linea       varchar2(500);
   ls_linea_srv   varchar2(500);
   ls_nomect      varchar2(200);
   ls_correo_para varchar2(2000);
   ls_cuerpo      varchar2(8000);
   ls_asunto      varchar2(150);
   a_correos       DBMS_SQL.varchar2s;

  cursor c_serv_bod  is
  select * from solot
  where tiptra = 367 and
  codsolot in (select codsolot from wf where idwf
  in (select idwf from tareawf where esttarea = 1))
  /*and codsolot = 106913*/ ; -- filtro de prueba


  cursor c_sot(p_codsolot in varchar2) is
  select b.descripcion,trunc(a.feccom) feccom, to_char(a.feccom,'hh24:mi:ss') horacom,
         nvl(a.responsable,c.descripcion) responsable, a.observacion
        from tareawf a , tareadef b, areaope c, wf d
        where a.tareadef = b.tareadef and
              a.idwf = d.idwf and
              a.esttarea = 1 and
              a.area = c.area and
              d.codsolot = p_codsolot;

  cursor c_srv(p_codsolot in varchar2) is
  select i.codinssrv, i.codcli,i.cid, t.dscsrv, i.direccion
  from inssrv i, solotpto s, tystabsrv t
  where i.codinssrv = s.codinssrv and
        i.codsrv = t.codsrv and
        s.codsolot = p_codsolot ;

BEGIN

   --Correo de Alerta de Activación / Desactivación
   select descripcion into ls_correo_para  from opedd where tipopedd = 208 and codigon = 1;

   for c_bod in c_serv_bod loop
     --Asunto del  Correo
       ls_asunto:= 'SOT: ' || c_bod.codsolot || ', Alerta Activación (ó Desactivación) de Servicio BoD - CNS';

        --Formación del cuerpo del correo
        for c_solot in c_sot(c_bod.codsolot) loop
            ls_cuerpo := 'Alerta - Detalle de la Solicitud BoD' || chr(13);
            ls_cuerpo := ls_cuerpo || chr(13);
            ls_cuerpo := ls_cuerpo || '[Detalle de la Solicitud de Orden de Trabajo]' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Tarea: ' || c_solot.descripcion ||  chr(13);
            ls_cuerpo := ls_cuerpo || 'Nro SOT: ' || c_bod.codsolot  || chr(13);
            ls_cuerpo := ls_cuerpo || 'Estado: Generada' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Fecha de Ejecución: ' || c_solot.feccom  || chr(13);
            ls_cuerpo := ls_cuerpo || 'Hora Programada: ' || c_solot.horacom || chr(13);
            ls_cuerpo := ls_cuerpo || 'Área: CNS(NOC)' || chr(13);
            ls_cuerpo := ls_cuerpo || 'Responsable: ' || c_solot.responsable || chr(13);
            ls_cuerpo := ls_cuerpo || 'Observación: ' || c_solot.observacion || chr(13);
        end loop;

        ls_cuerpo := ls_cuerpo || chr(13);

        select nomcli into ls_nomcli from marketing.vtatabcli where codcli = c_bod.codcli;

        ls_cuerpo := ls_cuerpo || '[Datos del Usuario Solicitante - Cliente]' || chr(13);

        select nomcnt,telefono1,email into ls_contacto, ls_telefono, ls_email from incidence_bod
        where userdate = ( select max(userdate) from incidence_bod where codsolot = c_bod.codsolot);

        ls_cuerpo := ls_cuerpo || 'Cliente: ' || ls_nomcli  || chr(13);
        ls_cuerpo := ls_cuerpo || 'Usuario Solicitante: ' || ls_contacto ||  chr(13);
        ls_cuerpo := ls_cuerpo || 'Teléfono del Solicitante: ' || ls_telefono ||  chr(13);
        ls_cuerpo := ls_cuerpo || 'e-mail Solicitante: ' || ls_email || chr(13);

        ls_cuerpo := ls_cuerpo || chr(13) || chr(13);

        select rpad('CID',20,' ') || rpad('Servicio',60,' ') || rpad('Dirección',70,' ') || chr(13) ||
        rpad('-',15,'-') || rpad(' ',5,' ') || rpad('-',55,'-') || rpad(' ',5,' ') ||  rpad('-',70,'-')
        into ls_linea
        from dual;

        ls_cuerpo := ls_cuerpo || ls_linea || chr(13);

        for c_servicios in c_srv(c_bod.codsolot) loop

              if length(trim(c_servicios.direccion)) <= 70 then
                 ls_linea_srv := rpad(trim(c_servicios.cid),20,' ') || rpad(trim(c_servicios.dscsrv),60,' ') || rpad(trim(c_servicios.direccion),70,' ');
              else
                 ln_can_lineas := ceil(length(trim(c_servicios.direccion))/70) - 1;

                 ls_direccion := trim(c_servicios.direccion);

                 ls_linea_srv := rpad(trim(c_servicios.cid),20,' ') || rpad(trim(c_servicios.dscsrv),60,' ') || substr(ls_direccion,1,70) || chr(13);

                 for i in 1..ln_can_lineas loop

                      ls_linea_srv := ls_linea_srv || lpad(' ',80,' ') || substr(ls_direccion,i*70 + 1,70) || chr(13);

                 end loop;


              end if;

              ls_cuerpo := ls_cuerpo || ls_linea_srv || chr(13);
        end loop;

        ls_cuerpo := ls_cuerpo || chr(13);

        ls_cuerpo := ls_cuerpo || '[Datos del Asesor de Servicios]' || chr(13);

        /************************************************
        Asesor de Servicios de la Instalación de Internet
        *************************************************/

        select nomect into ls_nomect from vtatabect
        where codect in (select codsol from vtatabslcfac
                          where numslc in (select numslc from inssrv
                                           where codinssrv in (select distinct codinssrv from solotpto
                                                                      where codsolot = c_bod.codsolot)))
        and rownum = 1;

        ls_cuerpo := ls_cuerpo || 'Asesor de Servicios: ' || ls_nomect || chr(13);


        /**************************************************
         Se separan los correos configurados
        ***************************************************/
        a_correos.delete;
        PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_para,a_correos,c_separador);

        for i in 0.. (a_correos.count-1) loop

          --Aca va la lista de correos "DL-PE-CNSActivaciones"--2.0
          produccion.p_envia_correo_de_texto_att(as_subject => ls_asunto,
                                                 as_destino => a_correos(i),
                                                 as_cuerpo => ls_cuerpo);


        end loop;
  end loop;
 commit;
END;

procedure p_alerta_cierre_tarea_up_bod( a_idtareawf in number,
                                        a_idwf      in number,
                                        a_tarea     in number,
                                        a_tareadef  in number)
                                        is

l_codsolot      solot.codsolot%type;
l_codcli        vtatabcli.codcli%type;
ls_asunto       varchar2(150);
ls_cuerpo       varchar2(8000);
ls_cuerpo_error varchar2(8000);
ls_correo_cliente  varchar2(2000);
ls_correo_claro   varchar2(2000);--2.0
ls_correo_error    varchar2(2000);
a_correos       DBMS_SQL.varchar2s;

begin
    select codsolot into l_codsolot from wf where idwf = a_idwf;

    ls_asunto:= 'Activación de su servicio BoD - Solicitud: ' || l_codsolot ;


    ls_cuerpo := 'Estimado Cliente:' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'Gracias por usar el servicio de Ancho de Banda en Demanda de Claro, le' || chr(13) ;--2.0

    ls_cuerpo :=  ls_cuerpo || 'comunicamos que se ha activado su servicio BoD, realizándose el upgrade respectivo.' || chr(13) || chr(13);

    ls_cuerpo :=  ls_cuerpo || 'Agradecemos nuevamente su confianza y preferencia.' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'Saludos cordiales,' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'CLARO';--2.0

    --Envio a Correo particular del Cliente

    select codcli into l_codcli  from solot where codsolot = l_codsolot;

    --Correo Cierre de Tarea de Activación / Desactivación
    select descripcion into ls_correo_claro  from opedd where tipopedd = 208 and codigon = 2;--2.0

    begin
      select numcomcli into ls_correo_cliente from vtamedcomcli where codcli = l_codcli and idmedcom = '008';

      produccion.p_envia_correo_de_texto_att(  as_subject => ls_asunto,
                                               as_destino => ls_correo_cliente,
                                               as_cuerpo => ls_cuerpo);

      /**************************************************
         Se separan los correos configurados
      ***************************************************/
      a_correos.delete;
      PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_claro,a_correos,c_separador);--2.0

      for i in 0.. (a_correos.count-1) loop

        --Aca va la lista de correos "DL-PE-Teleasistencia"--2.0
        produccion.p_envia_correo_de_texto_att(  as_subject => ls_asunto,
                                                 as_destino => a_correos(i),
                                                 as_cuerpo => ls_cuerpo);

      end loop;

    exception
      when no_data_found then

        select descripcion into ls_correo_error  from opedd where tipopedd = 208 and codigon = 3;

        ls_cuerpo_error := 'Nro. SOT: ' || l_codsolot || chr(13);
        ls_cuerpo_error := ls_cuerpo_error ||  'No se ha podido enviar correo de aviso de Activación del servicio de Ancho de Banda en Demanda al cliente con código: ' || l_codcli || ', ya que no tiene registrado email particular, por favor solicitar su registro en el Módulo de Marketing.' ||  chr(13) ;

        /**************************************************
         Se separan los correos configurados
        ***************************************************/
        a_correos.delete;
        PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_error,a_correos,c_separador);

        for i in 0.. (a_correos.count-1) loop
         produccion.p_envia_correo_de_texto_att(  as_subject => 'Cliente BoD sin email particular registrado',
                                                  as_destino => a_correos(i),
                                                  as_cuerpo => ls_cuerpo_error);

        end loop;

    end;

   commit;
end;

procedure p_alerta_cierre_tarea_down_bod( a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number)
                                          is

l_codsolot      solot.codsolot%type;
l_codcli        vtatabcli.codcli%type;
ls_asunto       varchar2(150);
ls_cuerpo       varchar2(8000);
ls_cuerpo_error varchar2(8000);
ls_correo_cliente  varchar2(2000);
ls_correo_claro   varchar2(2000);--2.0
ls_correo_error    varchar2(2000);
a_correos       DBMS_SQL.varchar2s;

begin

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    ls_asunto:= 'Desactivación de su servicio BoD - Solicitud: ' || l_codsolot;


    ls_cuerpo := 'Estimado Cliente:' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'Gracias por usar el servicio de Ancho de Banda en Demanda de Claro, le' || chr(13) ;--2.0

    ls_cuerpo :=  ls_cuerpo || 'comunicamos que se ha desactivado su servicio BoD, realizándose el downgrade respectivo.' || chr(13) || chr(13);

    ls_cuerpo :=  ls_cuerpo || 'Agradecemos nuevamente su confianza y preferencia.' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'Saludos cordiales,' || chr(13) || chr(13) ;

    ls_cuerpo :=  ls_cuerpo || 'CLARO';--2.0


    --Envio a Correo particular del Cliente

    select codcli into l_codcli  from solot where codsolot = l_codsolot;



    --Correo Cierre de Tarea de Activación / Desactivación
    select descripcion into ls_correo_claro  from opedd where tipopedd = 208 and codigon = 2;--2.0

   begin
      select numcomcli into ls_correo_cliente from vtamedcomcli where codcli = l_codcli and idmedcom = '008';

      produccion.p_envia_correo_de_texto_att(  as_subject => ls_asunto,
                                               as_destino => ls_correo_cliente,
                                               as_cuerpo => ls_cuerpo);


      /**************************************************
         Se separan los correos configurados
      ***************************************************/
      a_correos.delete;
      PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_claro,a_correos,c_separador);--2.0

      for i in 0.. (a_correos.count-1) loop

        --Aca va la lista de correos "DL-PE-Teleasistencia"--2.0
        produccion.p_envia_correo_de_texto_att(  as_subject => ls_asunto,
                                                 as_destino => a_correos(i),
                                                 as_cuerpo => ls_cuerpo);


        --soporte.send_mail_att('DL-PE-Dba',ls_correo_telmex,ls_asunto,ls_cuerpo);--2.0
      end loop;

    exception
      when no_data_found then
        select descripcion into ls_correo_error  from opedd where tipopedd = 208 and codigon = 3;

        ls_cuerpo_error := 'Nro. SOT: ' || l_codsolot || chr(13);
        ls_cuerpo_error := ls_cuerpo_error ||  'No se ha podido enviar correo de aviso de Desactivación del servicio de Ancho de Banda en Demanda al cliente con código: ' || l_codcli || ', ya que no tiene registrado email particular, por favor solicitar su registro en el Módulo de Marketing.' ||  chr(13) ;

        /**************************************************
         Se separan los correos configurados
        ***************************************************/
        a_correos.delete;
        PQ_FND_UTILITARIO_INTERFAZ.prc_dividir_linea(ls_correo_error,a_correos,c_separador);

        for i in 0.. (a_correos.count-1) loop
         produccion.p_envia_correo_de_texto_att(  as_subject => 'Cliente BoD sin email particular registrado',
                                                  as_destino => a_correos(i),
                                                  as_cuerpo => ls_cuerpo_error);

        end loop;

    end;
  commit;
 end;

end;
/


