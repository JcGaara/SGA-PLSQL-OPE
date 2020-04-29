CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_BUI
BEFORE INSERT OR UPDATE
ON OPERACION.SOLEFXAREA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
ls_texto varchar2(1000);
cursor cur_correo is
select a.email
from envcorreo a where a.area = :new.area and a.tipo = 4;
ln_num NUMBER;
ln_estef number;
lc_codcli vtatabcli.codcli%type;
lc_tipsrv vtatabslcfac.tipsrv%type;
ln_tipsolef vtatabslcfac.tipsolef%type;
lc_cliint vtatabslcfac.cliint%type;
ln_prioridad number(3);
ln_idlog number;
ln_codcon number;

ls_destino varchar2(1000);
l_cliente vtatabcli.nomcli%type;
l_tiposervicio tystipsrv.dsctipsrv%type;
l_area areaope.descripcion%type;

ls_codcli char(8); --JMAP

/******************************************************************************

Date        Author           Description
----------  ---------------  ------------------------------------
15/03/2005  Victor Valqui     Se controla un log cada vez que el EF de cada area se pase a generado.
12/06/2005  Victor Valqui     Se elimina la opcion para que no se considere al momento de actualizar
                  por ventas.
11/11/2006  Luis Olarte      Req 44386 Cambio de estado por contratista.
   1.0    06/10/2010                      REQ.139588 Cambio de Marca

******************************************************************************/

BEGIN
  If Updating then
   /********** temporal *********************************/
   if updating ('AREA') then
      if :old.area is null then
         return;
      end if;
/*      --JMAP
      update operacion.estsolef_dias_utiles set codarea = :new.area
      where codef = :old.codef and codarea = :old.area;
      --JMAP  */

   end if;

   if updating ('CODDPT') then
    select area into :new.area from areaope where coddpt = :new.coddpt;
     end if;
   /********** Fin temporal *********************************/


   --Registrar un log de cada area cada vez que se pase a Generado.
   if :new.estsolef = 1 and :old.estsolef in (2,3) then

    select nvl(max(id_log),0)+1 into ln_idlog from solefxarea_log;

     insert into solefxarea_log (id_log, codef, area, fecini, fecfin,
                        numdiapla, observacion, fecapr, numdiaval)
       values (ln_idlog, :old.codef, :old.area, :old.fecini, :old.fecfin,
           :old.numdiapla, :old.observacion, :old.fecapr, :old.numdiaval);
   end if;
   --Fin de codigo.

     if updating('ESTSOLEF') and updating('FECAPR') and updating('FECINI') and  nvl(:old.fecapr,sysdate) = nvl(:new.fecapr,sysdate) and not updating('FECFIN') and
        not updating('NUMDIAPLA') and not updating('OBSERVACION') and :new.estsolef = 1 then
        -- Se esta cambiando a Actualizar Datos, entonces se permite que se actualize
       return;
     end if;

     if updating('ESTSOLEF') and :new.estsolef = 1 then
        SELECT nvl(idprioridad,0)
     INTO ln_prioridad
     FROM vtatabslcfac
    WHERE numslc = :NEW.numslc;

    ls_texto := 'Fue Actualizado por '||user||' Fecha: '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||chr(13);
    ls_texto := ls_texto || 'Proyecto: '|| :new.numslc||CHR (13)||'PRIORIDAD '||ln_prioridad;
    for  ls_correo in cur_correo loop
     P_ENVIA_CORREO_DE_TEXTO_ATT('PRIORIDAD '||ln_prioridad||' Estudio de Factibilidad '||to_char(:new.CODEF), ls_correo.email, ls_texto);
    end  loop;
     end if;

     -- Cuando se tenga que actualizar el estudio
     if updating('ESTSOLEF') and not updating('FECINI')
     and not updating('FECFIN') and
        not updating('NUMDIAPLA') and not updating('OBSERVACION') and :new.estsolef = 1 then
        select estef into ln_estef from ef where numslc = :new.numslc;
        if ln_estef in (3,5) then  -- Se esta cambiando a Actualizar Datos, entonces se permite que se actualize
           return;
        end if;
     end if;

     select count(*) into ln_num from accusudpt
     where area = :new.area and codusu = user and tipo = 3 and aprob = 1;

--   if ln_num = 0 and :new.estsolef <> 6 then  -- Requerimiento 32804
     if ln_num = 0 and :new.estsolef <> 3 then  -- Requerimiento 39320
        raise_application_error(-20500,'No tiene privilegios para concluir el estudio');
     end if;

     --***********************Req 44386
     select max(codcon) into ln_codcon from   usuarioope u
     where u.usuario = trim (user);

     if (ln_codcon is not null and :new.estsolef <> 7) then
        ls_texto:= 'EF Concluido por Contrata: ' || to_char(:new.codef) || chr(13) || chr(10) || 'Proyecto: ' || :new.numslc || chr(13) || chr(10);
       ls_texto:= ls_texto || 'Cliente: ' || l_cliente  || chr(13) || chr(10) || 'Tipo de Servicio: ' || l_tiposervicio  || chr(13) || chr(10);
       ls_texto:= ls_texto || 'Observación indicada por el Contratista de ' || l_area  || ': ' || :new.observacion || chr(13) || chr(10);
       ls_destino:= 'william.ojeda@claro.com.pe';--1.0

       P_ENVIA_CORREO_DE_TEXTO_ATT('EF Concluido por Contrata: ' || to_char(:new.codef), ls_destino, ls_texto);
       opewf.pq_send_mail_job.p_send_mail ('EF Concluido por Contrata: ' || to_char(:new.codef), ls_destino, ls_texto, 'SGA@Sistema_de_Operaciones');

       raise_application_error(-20500,'El unico estado valido es Concluído por Contratista');
     end if;
     --************************

     -- Se actualiza la fecha en que se aprueba el estudio
     if updating('ESTSOLEF') then
        if :new.estsolef in ( 2, 4) then
           :new.fecapr := sysdate;
    elsif :new.estsolef = 3 then
       select cli.nomcli into l_cliente from vtatabcli cli, vtatabslcfac slc where cli.codcli = slc.codcli and slc.numslc = :new.numslc;
       select srv.dsctipsrv into l_tiposervicio from tystipsrv srv, vtatabslcfac slc where srv.tipsrv = slc.tipsrv and slc.numslc = :new.numslc;
       select descripcion into l_area from areaope where area = :new.area;

       ls_texto:= 'EF rechazado: ' || to_char(:new.codef) || chr(13) || chr(10) || 'Proyecto: ' || :new.numslc || chr(13) || chr(10);
       ls_texto:= ls_texto || 'Cliente: ' || l_cliente  || chr(13) || chr(10) || 'Tipo de Servicio: ' || l_tiposervicio  || chr(13) || chr(10);
     --  ls_texto:= ls_texto || 'Observación indicada por el Area de ' || l_area  || ': ' || :new.observacion || chr(13) || chr(10);
       ls_destino:= 'illich.izarra@claro.com.pe,william.ojeda@claro.com.pe';--1.0

       --P_ENVIA_CORREO_DE_TEXTO_ATT('EF rechazado: ' || to_char(:new.codef), ls_destino, ls_texto);
      -- opewf.pq_send_mail_job.p_send_mail ('EF rechazado: ' || to_char(:new.codef), ls_destino, ls_texto, 'SGA@Sistema_de_Operaciones');
        end if;

     end if;

 end if;
 If Inserting then
    /***************** Temporal *********************/
    -- se actualiza temporalmente el campo area para las OT


     if :new.area is null then
       select area into :new.area from areaope where coddpt = :new.coddpt;
     end if;
     /***************** fin Temporal *********************/

     select count(*) into ln_num from ef where numslc = :new.numslc or codef = :new.codef;
     if ln_num = 0 then
        --ln_num := F_GET_CLAVE_EF;
      select codcli, tipsrv, tipsolef , cliint into lc_codcli, lc_tipsrv, ln_tipsolef, lc_cliint from vtatabslcfac where numslc = :new.numslc;
      if lc_tipsrv is null or lc_tipsrv = '0000' then
         select max(tipsrv) into lc_tipsrv from vtatabpspcli where numslc = :new.numslc;
      end if;
        insert into ef (CODEF, NUMSLC, CODCLI, ESTEF, tipsrv, tipsolef, cliint)
        values ( :new.codef, :new.numslc, lc_codcli, 1, lc_tipsrv, ln_tipsolef, lc_cliint);

    --LLenado de Puntos Automatico al momento de generarse el EF
    P_ACT_EF_DE_SOL(:new.codef);

     end if;

   /*  --JMAP
     if :new.area <> :old.area  or :old.area is null  then
         select codcli into ls_codcli from vtatabslcfac where numslc = :new.numslc;
         insert into operacion.estsolef_dias_utiles(codef,codcli,codarea,estsolef,fechaini)
         values(:new.codef,ls_codcli,:new.area,:new.estsolef,sysdate);

     end if;
     --JMAP*/
 End if;


END;
/



