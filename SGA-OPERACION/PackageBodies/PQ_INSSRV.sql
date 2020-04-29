CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_INSSRV  AS
/******************************************************************************
   NAME:       PQ_INSSRV
   PURPOSE:    SP para control de INSSRV

   REVISIONS:
   Ver        Date        Author           Solicitado por            Description
   ---------  ----------  ---------------  --------------            ----------------------
   1.0        16/10/2000  Carlos Corrales                            1 version
   2.0        16/10/2002  Carlos Corrales                            Modificaciones Brasil
              01/09/2003  Carlos Corrales                            Se hizo las modificaciones para soportar DEMOs
   3.0        01/09/2008  Victor Valqui                              Cambios por Primesys (idinssla)
   4.0        25/08/2010  Joseph Asencios                            REQ-137046: Se modificó el procedimiento p_valida_est_inssrv
   5.0        31/05/2010  Widmer Quispe    Edilberto Astulle         Req: 123054 y 123052, Asignación de Plataforma
   6.0        10/11/2011  Ivan Untiveros   Guillermo Salcedo         REQ-161199 DTH Postpago RF02
   7.0        04/07/2012  Mauro Zegarra    Hector Huaman             REQ-162820 Sincronización de proceso de ventas HFC (SISACT - SGA) - Etapa 1
******************************************************************************/
PROCEDURE trs_activacion ( a_codinssrv in number, a_fectrs in date, a_codsrv in char, a_bw in number ) IS
BEGIN
   update inssrv set
      fecini = decode(fecini, null, a_fectrs, fecini),
      fecactsrv = a_fectrs,
    codsrv = a_codsrv,
    bw = a_bw,
      estinssrv = 1
      where codinssrv = a_codinssrv;
END;
PROCEDURE trs_upgrade ( a_codinssrv in number, a_fectrs in date, a_codsrv in char, a_bw in number ) IS
BEGIN
   update inssrv set
    fecini = decode(fecini, null, a_fectrs, fecini),
      fecactsrv = a_fectrs,
    codsrv = a_codsrv,
    bw = a_bw,
      estinssrv = 1
      where codinssrv = a_codinssrv;
END;
PROCEDURE trs_suspension ( a_codinssrv in number, a_fectrs in date ) IS
BEGIN
   update inssrv set
      fecactsrv = a_fectrs,
      estinssrv = 2
      where codinssrv = a_codinssrv;
END;
PROCEDURE trs_reconexion ( a_codinssrv in number, a_fectrs in date ) IS
BEGIN
   update inssrv set
      fecactsrv = a_fectrs,
      estinssrv = 1
      where codinssrv = a_codinssrv;
END;
PROCEDURE trs_cancelacion ( a_codinssrv in number, a_fectrs in date ) IS
BEGIN
   update inssrv set
      fecactsrv = a_fectrs,
    fecfin = a_fectrs,
      estinssrv = 3
      where codinssrv = a_codinssrv;
END;
PROCEDURE trs_creacion ( a_codinssrv in number, a_fectrs in date ) IS
BEGIN
   null;
END;
/**********************************************************************
Crea un SID desde un numero de proyecto y numpto
Crea el PID principal
**********************************************************************/
procedure p_crear_inssrv(
   a_numslc in char,
   a_numpto in char,
   a_codinssrv out number,
   a_pid out number
)
is
r_det vtadetptoenl%rowtype;
r_inssrv inssrv%rowtype;
r_pry vtatabslcfac%rowtype;
r_ser tystabsrv%rowtype;
l_tipinssrv tipinssrv.tipinssrv%type;
l_codinssrv inssrv.codinssrv%type;
ls_num varchar2(20);--6.0
ls_telefonom2 sales.int_vtacliente_aux.telefonom2%TYPE; -- 7.0
begin
   select * into r_det from vtadetptoenl where numslc = a_numslc and numpto = a_numpto;
   /* se crea el SID solosi no existe */
   if r_det.codinssrv is not null then
      l_codinssrv := r_det.codinssrv;
   else
      if r_det.numpto_orig is null and r_det.numpto_dest is  null and
         r_det.codinssrv_orig is null and r_det.numpto_orig is  null then
         l_tipinssrv := 1; -- tipo acceso
      else
         l_tipinssrv := 2; -- enlace
      end if;
      select * into r_pry from vtatabslcfac where numslc = a_numslc ;
      select * into r_ser from tystabsrv where codsrv = r_det.codsrv;
      --r_inssrv.codinssrv :=  r_det.codinssrv;
      r_inssrv.codcli :=  r_pry.codcli;
      r_inssrv.codsrv :=  r_det.codsrv;
      r_inssrv.estinssrv :=  4;
      r_inssrv.tipinssrv :=  l_tipinssrv;
      r_inssrv.descripcion :=  r_det.descpto;
      r_inssrv.direccion :=  r_det.dirpto;
      --Ini 6.0
      --Validando si viene por venta normal/webuni o por SIACT
      /*r_inssrv.numero :=  null;*/
      if sales.pq_dth_postventa.f_obt_facturable_dth(a_numslc)=1 then
        begin
         select TELEFONOM2 into ls_num from INT_VTACLIENTE_AUX c
         where c.iddet in (select v.iddet from INT_VTAREGVENTA_AUX v where v.o_numslc=a_numslc);
         r_inssrv.numero :=ls_num;
         exception--Mientras no se bloquee por SGA no utilizar idsolucion PostPago DTH
         when others then
              r_inssrv.numero :=  null;
         end;
      else
      r_inssrv.numero :=  null;
      end if;
      --Fin 6.0
      -- ini 7.0
      IF sales.pq_dth_postventa.f_is_hfc(a_numslc) = 1 THEN
        BEGIN
         SELECT c.telefonom2 INTO ls_telefonom2 FROM SALES.int_vtacliente_aux c
         WHERE c.iddet IN (SELECT v.iddet FROM INT_VTAREGVENTA_AUX v WHERE v.o_numslc = a_numslc);
         r_inssrv.numsec := TO_NUMBER(ls_telefonom2);
         EXCEPTION
         WHEN OTHERS THEN
              r_inssrv.numsec :=  NULL;
         END;
      ELSE
         r_inssrv.numsec :=  NULL;
      END IF;
      -- fin 7.0
      r_inssrv.codsuc :=  r_det.codsuc;
      r_inssrv.bw :=  r_det.banwid;
      r_inssrv.numslc :=  r_det.numslc;
      r_inssrv.numpto :=  r_det.numpto;
      r_inssrv.codubi :=  r_det.ubipto;
      r_inssrv.tipsrv :=  r_ser.tipsrv;
      r_inssrv.codinssrv_ori :=  r_det.codinssrv_orig;
      r_inssrv.codinssrv_des :=  r_det.codinssrv_dest;
      r_inssrv.idplataforma  := r_det.idplataforma; --5.0
      p_insert_inssrv ( r_inssrv, l_codinssrv );
   end if;
   a_codinssrv := l_codinssrv;
   /* se crea el PID */
end;
/**********************************************************************
Inserta un registro en INSSRV
**********************************************************************/
procedure p_insert_inssrv(
   ar_inssrv  in inssrv%rowtype,
   a_codinssrv out number
)
is
l_codinssrv inssrv.codinssrv%type;
l_tipinssrv inssrv.tipinssrv%type;
l_codinssrv_pad inssrv.codinssrv%type;
l_cont number;
begin
   if ar_inssrv.codinssrv is null then
      l_codinssrv := F_GET_CLAVE_SID;
   else
      l_codinssrv := ar_inssrv.codinssrv;
   end if;
   if ar_inssrv.tipinssrv = 2 and (ar_inssrv.codinssrv_ori is null or ar_inssrv.codinssrv_des is null ) then
      raise_application_error(-20500,'Un enlace requiere un origen y un destino.');
   end if;
   if ar_inssrv.tipinssrv <> 2 and (ar_inssrv.codinssrv_ori is not null or ar_inssrv.codinssrv_des is not null ) then
      raise_application_error(-20500,'Solo un enlace requiere un origen y un destino.');
   end if;
   if ar_inssrv.codinssrv_ori is not null then
      select tipinssrv into l_tipinssrv from inssrv where codinssrv = ar_inssrv.codinssrv_ori;
      if l_tipinssrv <> 1 then
         raise_application_error(-20500,'El origen debe ser de tipo acceso.');
      end if;
   end if;
   if ar_inssrv.codinssrv_des is not null then
      select tipinssrv into l_tipinssrv from inssrv where codinssrv = ar_inssrv.codinssrv_des;
      if l_tipinssrv <> 1 then
         raise_application_error(-20500,'El destino debe ser de tipo acceso.');
      end if;
   end if;
   if ar_inssrv.codinssrv_des =  ar_inssrv.codinssrv_ori then
      raise_application_error(-20500,'El origen y destino no pueden ser iguales.');
   end if;
   -- Valida la IS Maestro
   if ar_inssrv.tipinssrv = 4 then
      l_codinssrv_pad := null;
   else
      select count(*) into l_cont from tystabsrv s, producto p
         where s.codsrv = ar_inssrv.codsrv and s.idproducto = p.idproducto
         and p.flgismst = 0;
      if l_cont > 0 then
         l_codinssrv_pad := null;
      else
         l_codinssrv_pad :=  ar_inssrv.codinssrv_pad;
      end if;
   end if;
   insert into inssrv (
   codinssrv,
   codcli,
   codsrv,
   estinssrv,
   tipinssrv,
   descripcion,
   direccion,
   fecini,
   fecactsrv,
   fecfin,
   numero,
   codsuc,
   bw,
   pop,
   numslc,
   numpto,
   observacion,
   fecusu,
   codusu,
   codelered,
   codequpop,
   interface,
   codubi,
   tipsrv,
   cid,
   codinssrv_ori,
   codinssrv_des,
   codinssrv_pad,
   codpostal,
   campo1,
   idpaq,
   idplataforma, -- 5.0
   numsec -- 7.0
    ) values (
   l_codinssrv,
   ar_inssrv.codcli,
   ar_inssrv.codsrv,
   ar_inssrv.estinssrv,
   ar_inssrv.tipinssrv,
   ar_inssrv.descripcion,
   ar_inssrv.direccion,
   ar_inssrv.fecini,
   ar_inssrv.fecactsrv,
   ar_inssrv.fecfin,
   ar_inssrv.numero,
   ar_inssrv.codsuc,
   ar_inssrv.bw,
   ar_inssrv.pop,
   ar_inssrv.numslc,
   ar_inssrv.numpto,
   ar_inssrv.observacion,
   ar_inssrv.fecusu,
   ar_inssrv.codusu,
   ar_inssrv.codelered,
   ar_inssrv.codequpop,
   ar_inssrv.interface,
   ar_inssrv.codubi,
   ar_inssrv.tipsrv,
   ar_inssrv.cid,
   ar_inssrv.codinssrv_ori,
   ar_inssrv.codinssrv_des,
   l_codinssrv_pad,
   ar_inssrv.codpostal,
   ar_inssrv.campo1,
   ar_inssrv.idpaq,
   ar_inssrv.idplataforma, --5.0
   ar_inssrv.numsec -- 7.0
    );
   a_codinssrv := l_codinssrv;
end;
/**********************************************************************
Inserta un registro en INSPRD
**********************************************************************/
procedure p_insert_insprd(
   ar_insprd  in insprd%rowtype,
   a_pid out number
)
is
l_pid insprd.pid%type;
begin
   if ar_insprd.pid is null then
      l_pid:=  F_GET_ID_INSPRD;
   else
      l_pid := ar_insprd.pid;
   end if;
   insert into insprd (
      pid,
      descripcion,
      estinsprd,
      codsrv,
      codequcom,
      codinssrv,
      fecini,
      fecfin,
      cantidad,
      flgprinc,
      numslc,
      numpto,
      tipcon,
      iddet,
      idplataforma --5.0
       ) values (
      l_pid,
      ar_insprd.descripcion,
      ar_insprd.estinsprd,
      ar_insprd.codsrv,
      ar_insprd.codequcom,
      ar_insprd.codinssrv,
      ar_insprd.fecini,
      ar_insprd.fecfin,
      ar_insprd.cantidad,
      decode(ar_insprd.flgprinc,null,0,ar_insprd.flgprinc),
      ar_insprd.numslc,
      ar_insprd.numpto,
      ar_insprd.tipcon,
      ar_insprd.iddet,
      ar_insprd.idplataforma --5.0
         ) ;
   a_pid := l_pid;
end;

procedure p_valida_est_inssrv(
   a_codinssrv in inssrv.codinssrv%type, a_codmotinssrv in inssrv.codmotinssrv%type
) is
/**********************************************************************
Actualiza el estado de la IS, en base al de la IPs
Actualiza el Servicio (CODSRV) y el BW
**********************************************************************/
l_cont number;
l_act number;
l_sus number;
l_can number;
l_sin number;
l_est estinssrv.estinssrv%type;
l_est_old estinssrv.estinssrv%type;
cursor cur_ip is
   select codsrv from insprd
   where codinssrv = a_codinssrv
   and estinsprd not in (3,4)
   and tipcon = 0
   and flgprinc = 1
   order by  FLGPRINC desc ,estinsprd asc;
l_codsrv inssrv.codsrv%type;
l_tipinssrv inssrv.tipinssrv%type;
l_codinssrv_pad inssrv.codinssrv%type;
l_bw number;
l_fecini date;
l_fectrs date;
begin
   select
      count(*),
      sum(decode(estinsprd, 1, 1, 0)),
      sum(decode(estinsprd, 2, 1, 0)),
      sum(decode(estinsprd, 3, 1, 0)),
      sum(decode(estinsprd, 4, 1, 0))
   into
      l_cont,
      l_act,
      l_sus,
      l_can,
      l_sin
   from insprd where codinssrv  = a_codinssrv and tipcon = 0;
   --1  Activo
   if    l_act > 0 then
      l_est := 1;
   --2  Suspendido
   --ini 4.0
   --elsif l_cont = (l_sus + l_can) and l_sus > 0 then
   elsif l_cont = (l_sus + l_can + l_sin) and l_sus > 0 then
   --fin 4.0
      l_est := 2;
   --3  Cancelado
   elsif l_cont = l_can then
      l_est := 3;
   --4  Sin Activar
   else
      l_est := 4;
   end if;
   select estinssrv, codinssrv_pad, fecini, tipinssrv
   into l_est_old, l_codinssrv_pad, l_fecini, l_tipinssrv
      from inssrv  where codinssrv  = a_codinssrv;
   if l_est_old <> l_est then
      -- Set FecIni
      if l_est = 1 and l_fecini is null then -- Fecini
         select min(fecini) into l_fectrs from insprd where
            codinssrv = a_codinssrv
            and estinsprd = 1
            and tipcon = 0
            and fecini is not null;
         update inssrv set
            estinssrv = l_est,
            fecini = l_fectrs
            where codinssrv  = a_codinssrv;
      -- Set Fecfin
      elsif l_est = 3 then
         select max(fecfin) into l_fectrs from insprd where
            codinssrv = a_codinssrv
            and fecfin is not null;
         update inssrv set
            estinssrv = l_est,
            fecfin = l_fectrs
            where codinssrv  = a_codinssrv;

--  Comentado por problemas de esta funcionalidad con el proceso de BRASIL
--          -- Al cancelarse la IS se cancela la asignacion de Numero Telefonico
--          if l_tipinssrv = 3 then
--             telefonia.P_DESASIGNACIONXINSSRV ( a_codinssrv, 0 );
--          end if;
      else
         update inssrv set estinssrv = l_est where codinssrv  = a_codinssrv;
      end if;
   end if;
--Registrar en motivo de la inssrv en el caso de suspension en los demas casos sera null.
   if l_est = 2 then
      update inssrv
       set codmotinssrv = a_codmotinssrv
     where codinssrv  = a_codinssrv;
   else
     update inssrv
       set codmotinssrv = null
     where codinssrv  = a_codinssrv;
   end if;
   select codsrv into l_codsrv from inssrv where codinssrv = a_codinssrv;
   for c in cur_ip loop
      if c.codsrv <> l_codsrv then
         select banwid into l_bw from tystabsrv where codsrv = c.codsrv;
         update inssrv set
            codsrv = c.codsrv,
            bw = l_bw
            where codinssrv  = a_codinssrv;
      end if;
      exit;
   end loop;
   if l_codinssrv_pad is not null then
      p_valida_est_inssrv_mst (l_codinssrv_pad, a_codmotinssrv);
   end if;
end;
procedure p_valida_est_inssrv_mst(
   a_codinssrv in inssrv.codinssrv%type, a_codmotinssrv in inssrv.codmotinssrv%type
) is
/**********************************************************************
Actualiza el estado de la IS Maestra, en base al de la IS hijas
No actualiza el servicio
**********************************************************************/
l_cont number;
l_act number;
l_sus number;
l_can number;
l_sin number;
l_est estinssrv.estinssrv%type;
l_est_old estinssrv.estinssrv%type;
cursor cur_ip is
   select codsrv from insprd
   where codinssrv = a_codinssrv
   and estinsprd not in (3,4)
   and tipcon = 0
   order by  FLGPRINC desc ,estinsprd asc;
l_codsrv inssrv.codsrv%type;
l_bw number;
begin
   select
      count(*),
      sum(decode(estinssrv, 1, 1, 0)),
      sum(decode(estinssrv, 2, 1, 0)),
      sum(decode(estinssrv, 3, 1, 0)),
      sum(decode(estinssrv, 4, 1, 0))
   into
      l_cont,
      l_act,
      l_sus,
      l_can,
      l_sin
   from inssrv where codinssrv_pad  = a_codinssrv;
   --1  Activo
   if    l_act > 0 then
      l_est := 1;
   --2  Suspendido
   elsif l_cont = (l_sus + l_can) and l_sus > 0 then
      l_est := 2;
   --3  Cancelado
   elsif l_cont = l_can then
      l_est := 3;
   --4  Sin Activar
   else
      l_est := 4;
   end if;
   select estinssrv into l_est_old from inssrv  where codinssrv  = a_codinssrv;
   if l_est_old <> l_est then
      update inssrv set estinssrv = l_est where codinssrv  = a_codinssrv;
   end if;
--Registrar en motivo de la inssrv en el caso de suspension en los demas casos sera null.
   if l_est = 2 then
      update inssrv
       set codmotinssrv = a_codmotinssrv
     where codinssrv  = a_codinssrv;
   else
     update inssrv
       set codmotinssrv = null
     where codinssrv  = a_codinssrv;
   end if;
end;
procedure p_crear_inssrv_manual(
   a_codcli in char,
   a_estinssrv in number,
   a_tipinssrv in number,
   a_codsrv in char,
   a_codsuc in char,
   a_descripcion in varchar2,
   a_direccion in varchar2,
   a_codubi in char,
   a_codpostal in varchar2,
   a_codinssrv_ori in number,
   a_codinssrv_des in number,
   a_codinssrv out number
)
/**********************************************************************
Crea una INSSRV manualmente, con los datos basicos
Usado para crear IS Internas
**********************************************************************/
is
r_suc vtasuccli%rowtype;
r_inssrv inssrv%rowtype;
r_i inssrv%rowtype;
r_ser tystabsrv%rowtype;
l_codinssrv inssrv.codinssrv%type;
r_pro producto%rowtype;
begin
   if a_codsrv is null then
      raise_application_error(-20500,'No se especifico el servicio.');
   end if;
   if a_codsuc is not null then
      select * into r_suc from vtasuccli where codsuc = a_codsuc;
      r_i.direccion := r_suc.dirsuc;
      r_i.codpostal := r_suc.codpos;
      r_i.codubi := r_suc.ubisuc;
      if a_descripcion is null then
         r_i.descripcion := r_suc.nomsuc;
      else
         r_i.descripcion := a_descripcion;
      end if;
   else
      r_i.descripcion := a_descripcion;
      r_i.direccion := a_direccion;
      r_i.codpostal := a_codpostal;
      r_i.codubi := a_codubi;
   end if;
   select * into r_ser from tystabsrv where codsrv = a_codsrv;
   select * into r_pro from producto where idproducto = r_ser.idproducto;
   if a_tipinssrv <> r_pro.IDTIPINSTSERV or r_pro.IDTIPINSTSERV is null then
      raise_application_error(-20500,'El servicio no coincide con el Tipo de Instancia de Servicio.');
   end if;
   r_inssrv.codcli :=  a_codcli;
   r_inssrv.estinssrv :=  a_estinssrv;
   r_inssrv.tipinssrv :=  a_tipinssrv;
   r_inssrv.codsuc :=  a_codsuc;
   r_inssrv.descripcion :=  r_i.descripcion;
   r_inssrv.direccion :=  r_i.direccion;
   r_inssrv.codubi :=  r_i.codubi;
   r_inssrv.codpostal :=  r_i.codpostal;
   r_inssrv.numero :=  null;
   r_inssrv.codsrv :=  a_codsrv;
   r_inssrv.bw :=  r_ser.banwid;
   r_inssrv.tipsrv :=  r_ser.tipsrv;
   --r_inssrv.numslc :=  r_det.numslc;
   --r_inssrv.numpto :=  r_det.numpto;
   r_inssrv.codinssrv_ori := a_codinssrv_ori;
   r_inssrv.codinssrv_des := a_codinssrv_des;
   p_insert_inssrv ( r_inssrv, l_codinssrv );
   a_codinssrv := l_codinssrv;
end;
procedure p_crear_inssrv_multi(
   a_codcli in char,
   a_estinssrv in number,
   a_tipinssrv in number,
   a_codsrv in char,
   a_codsuc in char,
   a_descripcion in varchar2,
   a_direccion in varchar2,
   a_codubi in char,
   a_codpostal in varchar2,
   a_codinssrv_ori in number,
   a_codinssrv_des in number,
   a_cantidad in number
)
/**********************************************************************
Crea varias INSSRV manualmente, con los datos basicos
Usado para crear IS Internas
**********************************************************************/
is
i number;
l_codinssrv inssrv.codinssrv%type;
begin
   if a_tipinssrv = 2 then
      raise_application_error(-20500,'No se puede crear varias instancias de servicio de tipo enlace.');
   end if;
   for i in 1..a_cantidad loop
      p_crear_inssrv_manual(
         a_codcli,
         a_estinssrv,
         a_tipinssrv,
         a_codsrv,
         a_codsuc,
         a_descripcion,
         a_direccion,
         a_codubi,
         a_codpostal,
         a_codinssrv_ori,
         a_codinssrv_des,
         l_codinssrv );
   end loop;
end;
procedure p_set_inssrv_pad(
   a_codinssrv  in inssrv.codinssrv%type,
   a_codinssrv_pad  in inssrv.codinssrv%type
) is
/**********************************************************************
Crea varias INSSRV manualmente, con los datos basicos
Usado para crear IS Internas
**********************************************************************/
begin
  update inssrv set codinssrv_pad = a_codinssrv_pad
    where codinssrv = a_codinssrv ;
end;
procedure p_replicar_inssrv_pad(
   a_codinssrv  in inssrv.codinssrv%type
) is
/**********************************************************************
Replica el Nro.Servicio a las IS Hijas
Solo aplica para IS. Principales y sobre IS.Hijas 1 y 2 no canceladas
**********************************************************************/
r_inssrv inssrv%rowtype;
begin
   select * into r_inssrv from inssrv where codinssrv = a_codinssrv ;
   if r_inssrv.tipinssrv <> 4  then
      raise_application_error(-20500,'Opcion no disponible para este tipo de IS');
   elsif r_inssrv.numero is null  then
      raise_application_error(-20500,'No se puede replicar un Nro.Servicio vacio');
   else
   --Ini 6.0
   --No se considera hacer excepcion por nueva idsolucion ya que descripcion del procedimiento es general
   --Fin 6.0
     update inssrv set  numero = r_inssrv.numero
         where codinssrv_pad = a_codinssrv
            and tipinssrv in (1,2)
            and estinssrv not in (3)
            and (numero <> r_inssrv.numero or numero is null );
   end if;
end;

--INICIO: Cambio 3.0: Cambios por Primesys
/**********************************************************************
Inserta un registro en INSSRVsla
**********************************************************************/
procedure p_insert_inssrvsla(
   an_inssrv  in inssrv.codinssrv%type,
   a_idinssla in number
)
is
l_idsla number;
l_reparacion number;
l_disponibilidad number;
l_cont number;
begin
   select count(*)  into l_cont
   from vtainssla where idinssla = a_idinssla;
   if l_cont = 1 then --Si tiene definido SLA
     select idsla,reparacion,disponibilidad
     into l_idsla,l_reparacion,l_disponibilidad
     from vtainssla
     where idinssla = a_idinssla;
     insert into inssrvsla (
        codinssrv,
        idsla,
        idinssla,
        reparacion,
        disponibilidad,
        valido)
       values (
       an_inssrv,
       l_idsla,
       a_idinssla,
       l_reparacion,
       l_disponibilidad,
       1
        );
   end if;

end;

/**********************************************************************
Inserta un registro en INSSRVsla
**********************************************************************/
procedure p_insert_insprdsla(
   an_pid  in insprd.pid%type,
   a_idinssla in number
)
is
l_idsla number;
l_reparacion number;
l_disponibilidad number;
l_cont number;
begin
   select count(*)  into l_cont
   from vtainssla where idinssla = a_idinssla;
   if l_cont = 1 then --Si tiene definido SLA
     select idsla,reparacion,disponibilidad
     into l_idsla,l_reparacion,l_disponibilidad
     from vtainssla
     where idinssla = a_idinssla;

      insert into insprdsla (
        pid,
        idsla,
        idinssla,
        reparacion,
        disponibilidad,
        valido)
       values (
       an_pid,
       l_idsla,
       a_idinssla,
       l_reparacion,
       l_disponibilidad,
       1 --cambio 5.0.
        );
   end if;

end;

/**********************************************************************
Inserta un registro en INSSRVsla
**********************************************************************/
procedure p_insert_inssrvsla(
   an_inssrv         in inssrv.codinssrv%type,
   a_idsla           in vtatabsla.idsla%type,
   a_reparacion      in vtatabsla.reparacion%type,
   a_disponibilidad  in vtatabsla.disponibilidad%type
)  is
begin

     insert into inssrvsla (
        codinssrv,
        idsla,
        idinssla,
        reparacion,
        disponibilidad,
        valido)
     values (
       an_inssrv,
       a_idsla,
       null,
       a_reparacion,
       a_disponibilidad,
       1
        );

end;

/**********************************************************************
Inserta un registro en INSPRDsla
**********************************************************************/
procedure p_insert_insprdsla(
   an_pid            in insprd.pid%type,
   a_idsla           in vtatabsla.idsla%type,
   a_reparacion      in vtatabsla.reparacion%type,
   a_disponibilidad  in vtatabsla.disponibilidad%type
)  is
begin

     insert into insprdsla (
        pid,
        idsla,
        idinssla,
        reparacion,
        disponibilidad,
        valido)
     values (
       an_pid,
       a_idsla,
       null,
       a_reparacion,
       a_disponibilidad,
       1
        );

end;

/**********************************************************************
Actualiza los SLA de un registro en INSSRVSLA
**********************************************************************/
procedure p_act_inssrvsla(
   an_inssrv  in inssrv.codinssrv%type,
   a_idsla in number
)  IS

ln_count number;
ln_IdInsSrvSla    InsSrvSla.Idinssrvsla%type;
l_reparacion      vtatabsla.reparacion%type;
l_disponibilidad  vtatabsla.disponibilidad%type;

BEGIN

   Select count(*)
     Into ln_count
     From InsSrvSla I
    Where I.codinssrv = an_inssrv
      And I.Valido    = 1;

   If ln_count = 1 Then

      Update InsSrvSla I
         Set I.Valido = 0
       Where I.codinssrv = an_inssrv
         And I.Valido    = 1;

   ElsIf ln_count > 1 Then
      RAISE_APPLICATION_ERROR(-20500,'Error en INSSRVSLA.');
   End If;

   --Cogemos los datos del VTATABSLA
   Select V.Reparacion, V.DISPONIBILIDAD
     Into l_reparacion, l_disponibilidad
     From VtaTabSla V
    Where V.IdSla = a_idsla;
   --Insertamos el nuevo registro
   p_insert_inssrvsla(an_inssrv, a_idsla, l_reparacion, l_disponibilidad);
END;

/**********************************************************************
Actualiza los SLA de un registro en INSPRDSLA
**********************************************************************/
procedure p_act_insprdsla(
   an_pid  in insprd.pid%type,
   a_idsla in number
)  IS

ln_count number;
ln_IdInsSrvSla    InsSrvSla.Idinssrvsla%type;
l_reparacion      vtatabsla.reparacion%type;
l_disponibilidad  vtatabsla.disponibilidad%type;

BEGIN

   Select count(*)
     Into ln_count
     From InsPrdSla I
    Where I.Pid    = an_pid
      And I.Valido = 1;

   If ln_count = 1 Then

      Update InsPrdSla I
         Set I.Valido = 0
       Where I.Pid    = an_pid
         And I.Valido = 1;

   ElsIf ln_count > 1 Then
      RAISE_APPLICATION_ERROR(-20500,'Error en INSPRDSLA.');
   End If;

   --Cogemos los datos del VTATABSLA
   Select V.Reparacion, V.DISPONIBILIDAD
     Into l_reparacion, l_disponibilidad
     From VtaTabSla V
    Where V.IdSla = a_idsla;
   --Insertamos el nuevo registro
   p_insert_insprdsla(an_pid, a_idsla, l_reparacion, l_disponibilidad);
END;
--FIN: Cambio 3.0: Cambios por Primesys

END PQ_INSSRV;
/
