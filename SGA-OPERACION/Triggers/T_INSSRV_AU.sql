CREATE OR REPLACE TRIGGER OPERACION.T_INSSRV_AU
AFTER UPDATE
ON OPERACION.INSSRV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/*
08/04/03 Se actualiza el CAMPO1 en SOLOTPTO_ID.NROSERVICIOMT
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
   2.0    12/10/2011    Edilberto Astulle                  REQ.160769 48626 SGA - Inconveniente con el job de cierre de tareas 3PLAY - JOB 43244
*/
DECLARE
  vpais             varchar2(3);
  lv_texto          varchar2(500);
  ls_constante_pais constante.valor%type;
  ls_numero         VARCHAR2(20);
  ls_numero_old     VARCHAR2(20);
  ls_codcli         char(8);
  ls_nomcli         VARCHAR2(150);
  lv_destino        VARCHAR2(1500);
  l_cont            number;
  l_ide             number;
  l_totinsrv        number;

BEGIN
  -- 10/12/2002 10:20 --
  -- Actualiza en la tabla TYSTIPSRV_ATENTION
  IF updating('ESTINSSRV') THEN
    UPDATE INSSRV_ATENTION
       SET CODSTATUS = :NEW.ESTINSSRV
     WHERE CODINSSRV = :new.CODINSSRV;

  END IF;

  IF UPDATING('CAMPO1') then
    if :new.campo1 is not null then
      update SOLOTPTO_ID i
         set NROSERVICIOMT = :new.campo1
       where exists (select *
                from solotpto s
               where s.codsolot = i.codsolot
                 and s.punto = i.punto
                 and s.codinssrv = :new.codinssrv)
         and NROSERVICIOMT = :old.campo1;
    end if;
  end if;

  --BAJA EL ACCESO CUANDO EL SERVICIO ES CANCELADO
  IF UPDATING('ESTINSSRV') then
    if :new.estinssrv = 3 then
      update acceso a set estado = 0 where codinssrv = :new.codinssrv;
    end if;
  end if;

  --Cambio para enviar correo
  IF UPDATING('ESTINSSRV') then
    ls_constante_pais := rtrim(ltrim(pq_constantes.F_GET_CFG));
    if (ls_constante_pais = 'PER') THEN
      IF :new.estinssrv = 1 and :old.estinssrv = 4 AND :new.tipinssrv = 3 AND
         :old.tipsrv != '0043' then
         /*02/05/2007 se agrego filtro para que no envme correo si es publica CNAJARRO*/
        ls_numero := :new.numero;
        ls_codcli := :new.codcli;
        select nomcli
          into ls_nomcli
          from vtatabcli
         where codcli = ls_codcli;
        lv_texto   := 'Se ha generado el numero de Cabecera: Nro.' ||
                      ls_numero || chr(13) || 'Cliente: ' || ls_nomcli ||
                      chr(13);
        lv_texto   := lv_texto || 'Codigo de Cliente: ' || ls_codcli;
        lv_texto   := lv_texto || chr(13) || 'Caso : Hunting Creado.';
        lv_destino := 'DL-PE-MarketingIntelligence';
--1.0
/*        select count(*)
          into l_cont
          from hunting
         where codnumtel in
               (select codnumtel from numtel where numero = :new.numero);
        if l_cont = 1 then
          OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('Aviso de Creacisn y/o Actualizacion de Telefonos',
                                             lv_destino,
                                             lv_texto,
                                             'SGA-Telefonia');
        end if;*/
      end if;
    END IF;
  end if;

 -- Actualiza el estado en Puertoxequipo EMELENDEZ 17/06/2008
     -- estinsrv = 1 ---> puertoxequipo.estado = 1
     -- estinsrv = 2 ---> puertoxequipo.estado = 3
     -- estinsrv = 3 ---> puertoxequipo.estado = 0

  IF UPDATING('ESTINSSRV') then
    IF :new.estinssrv = 1 Or :new.estinssrv = 2 Or :new.estinssrv = 3 Then
       Begin
       Select Ide Into l_ide From cidxide Where cid = :old.cid and rownum = 1 ;
       Exception
         When NO_DATA_FOUND Then
            l_ide := 0;
       End;

       if l_ide > 0 then--2.0
         If :new.estinssrv = 1 Then  -- Activo, sólo basta un servicio activo
            Update puertoxequipo Set estado = 1 Where Ide = l_ide;
         End If;
         If :new.estinssrv = 2 Then  -- Suspendido
            Select Count(*) into l_totinsrv from
                inssrv_atention where cid in
                ( Select cid from cidxide where IDE = l_ide); -- Total Servicios
            Select Count(*) into l_cont from
                inssrv_atention where codstatus = 2 And cid in
                ( Select cid from cidxide where IDE = l_ide); -- Total Suspendidos *\
            If l_totinsrv = l_cont then
               Update puertoxequipo Set estado = 3 Where Ide = l_ide;
            end if;
         End If;
         If :new.estinssrv = 3 Then  -- Cancelado
            Select Count(*) into l_totinsrv from
                inssrv_atention where cid in
                ( Select cid from cidxide where IDE = l_ide); -- Total Servicios
            Select Count(*) into l_cont from
                inssrv_atention where codstatus = 3 And cid in
                ( Select cid from cidxide where IDE = l_ide); -- Total Cancelados *\
            If l_totinsrv = l_cont then
               Update puertoxequipo Set estado = 0 Where Ide = l_ide;
            End if;
         End If;
       End If;--2.0
    End If;
  End If;
END;
/



