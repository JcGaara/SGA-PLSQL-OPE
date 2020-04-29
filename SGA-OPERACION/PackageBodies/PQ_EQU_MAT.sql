CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_EQU_MAT AS
  /************************************************************
  NOMBRE:     PQ_EQU_MAT
  PROPOSITO:  Carga automatica de quipos y materiales
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor            Solicitado Por      Descripcion
  ---------  ----------  -----------------   ----------------    ------------------------
  1.0        02/12/2009  Marcos Echevarria                       REQ111186:Carga de Materiales en base a Formula
  2.0        22/12/2009  Marcos Echevarria                       REQ112471:ajuste a carga de equipos
  3.0        08/03/2010  Marcos Echevarria   Edilberto Astulle   REQ107706:mantenimiento 3play
  4.0        03/05/2010  Antonio Lagos       Juan Gallegos       REQ119999:carga automatica para masivo
  5.0        29/10/2010  Miguel Aroñe        Edilberto Astulle   REQ 147259:Problemas al reasignar la contrata
  6.0        05/01/2011  Tommy Arakaki       Cesar Rosciano      REQ 151284 - Inventario de Equipos TPI
  7.0        20/06/2011  Fernando Canaval    Edilberto Astulle   REQ-159925: Registra mas de un equipo con mismo numero de Serie a la SOT
  8.0        28/12/2011  Edilberto Astulle   PROY-1508 CIERRE MASIVO DE BAJAS DTH
  9.0        28/04/2012  Edilberto Astulle           PROY-2372_Gestion de Edificios
  10.0       28/06/2012  Edilberto Astulle           PROY-3884_Agendamiento PEXT
  11.0       28/08/2012  Edilberto Astulle           PROY-3433_AgendamientoenLineaOperaciones
  12.0       28/09/2012  Edilberto Astulle           PROY-4856_Atencion de generacion Cuentas en RTellin para CE en HFC
  13.0       28/03/2012  Edilberto Astulle           PROY-6254_Recojo de decodificador
  14.0       10/04/2013  Ricardo Crisostomo  Arturo Saavedra     Carga masiva de materiales y equipos - SGA
  15.0       31/05/2013  Arturo Saavedra     Arturo Saavedra     Incidencia Post Produccion Carga masiva de materiales y equipos - SGA
  16.0       14/03/2014  Edilberto Astulle   SD-973402
  17.0       19/05/2014  Miriam Mandujano    Edilberto Astulle    PROY:14369 Mejorar el proceso de carga masiva de actividades.
  18.0       18/08/2014                      Edilberto Astulle    SD-1173230 Problemas para cambio de fecha de compromiso
  19.0       27/09/2015                      Edilberto Astulle    SD-479472
  20.0       10/10/2019                      Edilberto Astulle Descarga de Materiales
  ***********************************************************/
PROCEDURE P_cargar_mat_formula(a_codsolot solot.codsolot%type,a_codmat almtabmat.codmat%type, a_idagenda in number,a_codfor in number default null,a_enacta in number default 0) IS--16.0

l_codfor number;
l_punto number;
l_punto_ori number;
l_punto_des number;
l_codcon number;
l_orden number;
l_cont_for number;

--Materiales identificados en base a la formula
cursor cur_mat is
  SELECT matetapaxfor.codmat,
        tipequ.tipequ, tipequ.estequ,
        matetapaxfor.cantidad,
        matetapaxfor.codeta, matetapaxfor.recuperable,
        almtabmat.Preprm_Usd ,
        almtabmat.desmat,
        almtabmat.moneda_id,
        almtabmat.codund ,
        almtabmat.cod_sap
     FROM almtabmat,
        matetapaxfor,
        tipequ
    WHERE  almtabmat.codmat = matetapaxfor.codmat and
        almtabmat.codmat = tipequ.codtipequ and
        matetapaxfor.codfor =  l_codfor and tipequ.estequ = 1 and trim(matetapaxfor.codmat) = a_codmat  ;
n_res_tiptra number;--20.0
n_res_tiptra_det number;--20.0
BEGIN
  --20.0
   select count(1) into n_res_tiptra from tipopedd where abrev='DESCARGATIPTRANOGEN';
   if n_res_tiptra=1 then
     select count(1) into n_res_tiptra_det from solot a, opedd b,tipopedd c
     where a.tiptra=b.codigon and b.tipopedd=c.tipopedd and c.abrev='DESCARGATIPTRANOGEN' and a.codsolot=a_codsolot;
     if n_res_tiptra_det=1 then
       RAISE_APPLICATION_ERROR(-20500,'El tipo de Trabajo esta restringido para registrar materiales.');
     end if;
   end if;
     
   --Se Valida que tenga Formula
   select count(1) into l_cont_for
   from TIPTRABAJOXFOR a, solot b
   where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv--13.0
   and codsolot = a_codsolot ;
   if l_cont_for = 0 then
     RAISE_APPLICATION_ERROR(-20500,'El tipo de Trabajo de la SOT no tiene asociado una formula.');
   end if;

   --Se identifica la formula
   select nvl(a_codfor,codfor) into l_codfor
   from TIPTRABAJOXFOR a, solot b --10.0
   where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv--13.0
   and codsolot = a_codsolot ;
   --Se identificar el punto principal
   operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,l_punto,l_punto_ori,l_punto_des);

  --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into l_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        l_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20001,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    --<3.0>
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into l_codcon from agendamiento where idagenda = a_idagenda;
    --</3.0>
    end if;

    if l_codcon = -1 then
      raise_application_error(-20001,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;


   --Cargar Materiales en SOLOTPTOEQU
   --<6.0>
   --Req 151284 se modifico el estado de ingreso de FLGINV a 0, estaba en 1.
   for c_m in cur_mat loop
      SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from solotptoequ
      where codsolot = a_codsolot and punto = l_punto;
      insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,COSTO,flgsol,
      codeta,observacion,fecfdis,INSTALADO,FLG_INGRESO,flginv,idagenda,fecins,recuperable,estado,enacta)--16.0
      values(a_codsolot,l_punto,l_orden,c_m.tipequ,c_m.cantidad,0,nvl(c_m.Preprm_Usd,0),1,
      c_m.codeta,'' ,sysdate,1,2,0,a_idagenda,sysdate,c_m.recuperable,4,a_enacta);--16.0
   end loop;
--</6.0>

END;


/*********************************************************************************************************************/
--Procedimiento que permite cargar la informacion de equipos a la Sot Basado en
--formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
--   REVISIONS:
--   Ver        Date        Author           Description
--   ---------  ----------  ---------------  ------------------------------------
--   1.0        22/01/2009  MECHEVARRIA    Req111186:Carga de Equipos en base a Formula
/*********************************************************************************************************************/
PROCEDURE P_cargar_equ_formula(a_codsolot solot.codsolot%type,  a_nroserie solotptoequ.numserie%type, a_cod_sap almtabmat.cod_sap%type, a_idagenda in number,a_enacta in number default 0) IS--16.0
l_punto number;
l_tipequ number;
v_nroserie varchar2(400);
v_cod_sap almtabmat.cod_sap%type;--19.0
l_cont number;
l_codeta number;
n_costo tipequ.costo%type;
l_orden number;
--l_cont2 number; --4.0, variable no utilizada
l_codcon number;--<9>
l_punto_ori number;
l_punto_des number;
v_cod_sap_a almtabmat.cod_sap%type;--19.0
v_codmat varchar2(30);
n_codfor number;
--ini 7.0
ln_cont_serie number;
--fin 7.0
l_cont_for number;--13.0
n_estadoequ number;--16.0
begin
   --Se Valida que tenga Formula
   select count(1) into l_cont_for
   from TIPTRABAJOXFOR a, solot b
   where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv--13.0
   and codsolot = a_codsolot ;
   if l_cont_for = 0 then
     RAISE_APPLICATION_ERROR(-20500,'El tipo de Trabajo de la SOT no tiene asociado una formula.');
   end if;

   --Se identifica la formula
   select min(codfor) into n_codfor
   from TIPTRABAJOXFOR a, solot b --10.0
   where a.tiptra = b.tiptra and nvl(a.tipsrv, b.tipsrv) = b.tipsrv--13.0
   and codsolot = a_codsolot ;

  --Se identificar el punto principal
  operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,l_punto,l_punto_ori,l_punto_des);
  v_cod_sap_a := a_cod_sap;
  if v_cod_sap_a is not null then --Codigo Sap diferente de nul
    select count(1) into l_cont from maestro_Series_equ --<3.0> l_cont por l_cont2
    where trim(nroserie) = trim(a_nroserie) and trim(cod_sap) = v_cod_sap_a;
    if l_cont = 0 then --<3.0> l_cont por l_cont2
      RAISE_APPLICATION_ERROR(-20500,'El Número de Serie : ' || a_nroserie || ' no existe en la BD.');
    elsif l_cont > 1 then --El numero de serie esta repetido
      RAISE_APPLICATION_ERROR(-20500,'El Numero de serie y el Codigo SAP se repite, depurar información de Números de Serie.');
    else
      select TRIM(a.nroserie),TRIM(a.cod_sap) ,c.tipequ,c.costo, TRIM(b.codmat)
      into v_nroserie,v_cod_sap ,l_tipequ,n_costo, v_codmat
      from maestro_Series_equ a, almtabmat b, tipequ  c
      where trim(nroserie) = trim(a_nroserie)
      and c.codtipequ = b.codmat
      and trim(a.cod_sap) = trim(b.cod_sap) and trim(a.cod_sap) = v_cod_sap_a; --<2.0>
    end if;
  else --Codigo Sap es nulo
    if a_nroserie is null then
        RAISE_APPLICATION_ERROR(-20500,'Ingrese un Número de Serie por favor.');
    else
      select count(1) into l_cont from maestro_Series_equ where
      trim(nroserie) = trim(a_nroserie);
      if l_cont = 0 then --No existe el Nro de serie en la BD
        RAISE_APPLICATION_ERROR(-20500,'El Número de Serie : ' || a_nroserie || ' no existe en la BD.');
      elsif l_cont > 1 then --El numero de serie esta repetido
        RAISE_APPLICATION_ERROR(-20500,'Registrar el Codigo SAP por favor, el Numero de serie esta asociado a mas de un Equipo SAP.');
      else--
        select TRIM(a.nroserie),TRIM(a.cod_sap) ,c.tipequ,c.costo, TRIM(b.codmat)
        into v_nroserie,v_cod_sap_a ,l_tipequ,n_costo, v_codmat
        from maestro_Series_equ a, almtabmat b, tipequ  c
        where trim(nroserie) = trim(a_nroserie)
        and c.codtipequ = b.codmat
        and trim(a.cod_sap) = trim(b.cod_sap);
      end if;
    end if;
  end if;

  --Seleccionar la Etapa respectiva en base a la configuracion, 197 : configuracion codigosap etapa
    begin
      select codeta into l_codeta from matetapaxfor where codfor = n_codfor
      and trim(codmat) = trim(v_codmat);
      exception
      when no_data_found then
        raise_application_error(-20001,'Falta configurar para el Equipo ' || v_cod_sap_a || ' la Etapa correcta. Revise la formular : '|| to_char(n_codfor) );
    end;

  --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into l_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        l_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20001,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    --<3.0>
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into l_codcon from agendamiento where idagenda = a_idagenda;
    --</3.0>
    end if;

    if l_codcon = -1 then
      raise_application_error(-20001,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;

    --ini 7.0
    select count(1)
      into ln_cont_serie
      from solotptoequ
     where codsolot = a_codsolot
       and trim(numserie) = v_nroserie;
    if ln_cont_serie > 0 then
      raise_application_error(-20001,'El Número de serie ya esta asignado, Ingrese otro número de serie.' );
    end if;
    --fin 7.0
    --Inicio 16.0
    begin
      select a.codigon_aux into n_estadoequ
      from opedd a, tipopedd b, solot c
      where a.tipopedd=b.tipopedd and c.codsolot=a_codsolot
      and b.abrev='ESTEQUTIPTRA' and a.codigon= c.tiptra
      and a.codigoc=a_enacta and rownum=1;
    exception
      when no_data_found then
      n_estadoequ:=1;
    end;
    --Fin 16.0

    SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from solotptoequ
    where codsolot = a_codsolot and punto = l_punto;
    insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,COSTO,NUMSERIE,flgsol,
    flgreq,codeta,tran_solmat,observacion,fecfdis,flg_ingreso,flginv,instalado,
    fecins,recuperable,estado,idagenda,enacta,estadoequ) --16.0
    values(a_codsolot,l_punto,l_orden,l_tipequ,1,0,nvl(n_costo,0),v_nroserie,1,
    0,l_codeta,null,'' ,sysdate,1,1,1,sysdate,1,4,a_idagenda,a_enacta,n_estadoequ);--16.0

END;

/*********************************************************************************************************************/
--Procedimiento que permite cargar la informacion de materiales a la Sot Basado en
--formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
--   REVISIONS:
--   Ver        Date        Author           Description
--   ---------  ----------  ---------------  ------------------------------------
--   1.0        22/01/2009  MECHEVARRIA      Req111186:Carga de Actividades en base a Formula
/*********************************************************************************************************************/
PROCEDURE p_cargar_act_formula(a_codsolot solot.codsolot%type , a_codact actividad.codact%type, a_idagenda in number,a_codfor in number default null) IS
l_codfor number;
l_punto number;
l_punto_ori number;
l_punto_des number;
l_codeta number;
l_codcon number;
l_orden number;
l_cont_for number;
l_cont_etapa number;
--Actividades Registros identificados en base a la formula
cursor cur_act is
select a.codact, a.cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from ACTETAPAXFOR a , actxpreciario b
where a.codfor = l_codfor
and a.codact = b.codact and b.activo = '1' and a.codact = a_codact;

BEGIN
  --Se Valida que tenga Formula
  select count(1) into l_cont_for
  from TIPTRABAJOXFOR a, solot b
  where a.tiptra = b.tiptra and codsolot = a_codsolot
  and nvl(a.tipsrv, b.tipsrv) = b.tipsrv; --13.0
  if l_cont_for = 0 then
    RAISE_APPLICATION_ERROR(-20500,'El tipo de Trabajo de la SOT no tiene asociado una formula.');
  end if;
  --Se identifica la formula
  select nvl(a_codfor,codfor) into l_codfor from TIPTRABAJOXFOR a, solot b --10.0
  where a.tiptra = b.tiptra and codsolot = a_codsolot
  and nvl(a.tipsrv, b.tipsrv) = b.tipsrv ;--13.0
  --Se identificar el punto principal
  operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,l_punto,l_punto_ori,l_punto_des);
  --Cargar Actividades a la SOT : SOLOTPTOETAACT y SOLOTPTOETA
  for c_a in cur_act loop
    --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into l_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        l_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20001,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    --<3.0>
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into l_codcon from agendamiento where idagenda = a_idagenda;
    --</3.0>
    end if;

    if l_codcon = -1 then
      raise_application_error(-20001,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;

    l_codeta := c_a.codeta;
    select count(1) into l_cont_etapa from solotptoeta
    where codsolot = a_codsolot and codeta = l_codeta and idagenda = a_idagenda;--9.0
    --and codcon =l_codcon; --<3.0> and codcon
    if l_cont_etapa = 1 then--Existe Etapa
       select orden,punto into l_orden,l_punto from solotptoeta where codsolot = a_codsolot and codeta = l_codeta
       and idagenda = a_idagenda;--9.0
       --and codcon =l_codcon; --<3.0> and codcon
    else        --Genera la etapa en estado 15 : Preliquidacion
      SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from SOLOTPTOETA
      where codsolot = a_codsolot and punto = l_punto;
      insert into solotptoeta(codsolot,punto,orden,codeta,porcontrata,esteta,obs,Fecdis,codcon,fecini,IDAGENDA)--5.0 Se agrego campo idagenda
      values(a_codsolot,l_punto,l_orden,c_a.codeta,1,15,'ACTMO',null,l_codcon,sysdate,a_idagenda);--5.0 Se agrego valor del campo idagenda
    end if;
    --Inserta la Actividad en la Etapa
    insert into solotptoetaact(codsolot,punto,orden,codact,canliq,cosliq,canins,candis,cosdis,
    Moneda_Id,observacion,codprecdis,codprecliq,flg_preliq,contrata)
    values(a_codsolot,l_punto,l_orden,c_a.codact,c_a.cantidad,c_a.costo,c_a.cantidad,c_a.cantidad,c_a.costo,
    c_a.moneda_id,'ITTELMEX-ACT-HFC',c_a.codprec,c_a.codprec,1,1);
  end loop;
END;

--<4.0
--Procedimiento que permite cargar en forma automatica la informacion de materiales a la Sot Basado en
--formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
--y el detalle de materiales se selecciona en base al paquete de venta
PROCEDURE p_cargar_mat_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2) IS

ln_codfor ope_formula_material_det.codfor%type;
ln_punto number;
ln_punto_ori number;
ln_punto_des number;
ln_codcon number;
ln_orden number;
ln_cont_for number;
ln_idpaq paquete_venta.idpaq%type;
ls_numslc vtatabslcfac.numslc%type;
ln_codsolot_ori solot.codsolot%type;

--Materiales identificados en base a la formula
cursor cur_mat is
  SELECT b.codmat,
        c.tipequ,
        c.estequ,
        b.cantidad,
        b.codeta,
        b.recuperable,
        a.Preprm_Usd ,
        a.desmat,
        a.moneda_id,
        a.codund ,
        a.cod_sap,
        b.tipsrv
     FROM almtabmat a,
        ope_formula_material_det b,
        tipequ c
    WHERE  a.codmat = b.codmat and
        a.codmat = c.codtipequ and
        b.codfor = ln_codfor and
        b.idpaq = ln_idpaq and
        c.estequ = 1 and
        b.tipo = 1; --materiales
begin
   --Se Valida que tenga Formula
   select count(1) into ln_cont_for
   from TIPTRABAJOXFOR a, solot b
   where a.tiptra = b.tiptra and codsolot = a_codsolot ;
   if ln_cont_for = 0 then
     RAISE_APPLICATION_ERROR(-20000,'El tipo de Trabajo de la SOT no tiene asociado una formula.');
   end if;

    --Se identifica la formula
    begin
     select codfor into ln_codfor from TIPTRABAJOXFOR a, solot b
     where a.tiptra = b.tiptra and codsolot = a_codsolot ;
    exception
     when no_data_found then
         raise_application_error(-20000,'No se encontró formula configurada.' );
       when too_many_rows then
         raise_application_error(-20000,'Se encontró mas de una formula configurada.' );
    end;
    --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into ln_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        ln_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20000,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into ln_codcon from agendamiento where idagenda = a_idagenda;
    end if;

    if ln_codcon = -1 then
      raise_application_error(-20000,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;

   --se selecciona el paquete
   select numslc into ls_numslc
   from solot where codsolot = a_codsolot;

   if ls_numslc is not null then
     ln_codsolot_ori := a_codsolot;
   else
     begin
       select distinct pq_cuspe_plataforma.F_GET_SOT_INS_SID(codinssrv)
       into ln_codsolot_ori
       from solotpto where codsolot = a_codsolot;
     exception
       when no_data_found then
         raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
       when too_many_rows then
         raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
     end;
   end if;

   begin
     select distinct idpaq into ln_idpaq
     from vtadetptoenl a, solot b
     where a.numslc = b.numslc
     and b.codsolot = ln_codsolot_ori;
   exception
     when no_data_found then
       raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
     when too_many_rows then
       raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
   end;

   --Cargar Materiales en SOLOTPTOEQU
   for c_m in cur_mat loop
      --Se identifica el punto principal
      operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,ln_punto,ln_punto_ori,ln_punto_des,c_m.tipsrv);

      SELECT NVL(MAX(ORDEN),0) + 1 INTO ln_orden from solotptoequ
      where codsolot = a_codsolot and punto = ln_punto;

      insert into solotptoequ(codsolot,
                              punto,
                              orden,
                              tipequ,
                              CANTIDAD,
                              TIPPRP,
                              COSTO,
                              flgsol,
                              codeta,
                              observacion,
                              fecfdis,
                              INSTALADO,
                              FLG_INGRESO,
                              flginv,
                              idagenda,
                              fecins,
                              recuperable,
                              estado)
                       values(a_codsolot,
                              ln_punto,
                              ln_orden,
                              c_m.tipequ,
                              c_m.cantidad,
                              0,
                              nvl(c_m.Preprm_Usd,0),
                              1,
                              c_m.codeta,
                              '' ,
                              sysdate,
                              1, --instalado
                              2,
                              1,
                              a_idagenda,
                              sysdate,
                              c_m.recuperable,
                              4);
   end loop;

exception
  when others then
    an_cod_error := sqlcode;
    if an_cod_error = -20000 then
      av_des_error := substr(sqlerrm,12);
    else
      av_des_error := substr(sqlerrm,12)|| ' ('||dbms_utility.format_error_backtrace||')';
    end if;
end;

--Procedimiento que permite cargar en forma automatica la informacion de equipos a la Sot Basado en
--formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
--y el detalle de equipos se selecciona en base al paquete de venta
PROCEDURE p_cargar_equ_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2) IS
ln_codfor ope_formula_material_det.codfor%type;
l_punto number;
n_costo tipequ.costo%type;
l_orden number;
l_codcon number;
l_punto_ori number;
l_punto_des number;
ln_idpaq paquete_venta.idpaq%type;
ls_numslc vtatabslcfac.numslc%type;
ln_codsolot_ori solot.codsolot%type;

--Materiales identificados en base a la formula
cursor cur_equ is
  SELECT b.codmat,
        c.tipequ,
        c.estequ,
        b.cantidad,
        b.codeta,
        b.recuperable,
        a.Preprm_Usd ,
        a.desmat,
        a.moneda_id,
        a.codund ,
        a.cod_sap,
        b.tipsrv
     FROM almtabmat a,
        ope_formula_material_det b,
        tipequ c
    WHERE  a.codmat = b.codmat and
        a.codmat = c.codtipequ and
        b.codfor = ln_codfor and
        b.idpaq = ln_idpaq and
        c.estequ = 1 and
        b.tipo = 2;-- equipos
begin
    --Se identifica la formula
    begin
      select codfor into ln_codfor from TIPTRABAJOXFOR
      where tiptra = (select tiptra from solot where codsolot = a_codsolot);
    exception
       when no_data_found then
           raise_application_error(-20000,'No se encontró formula configurada.' );
         when too_many_rows then
           raise_application_error(-20000,'Se encontró mas de una formula configurada.' );
    end;
    --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into l_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        l_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20001,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into l_codcon from agendamiento where idagenda = a_idagenda;
    end if;

    if l_codcon = -1 then
      raise_application_error(-20001,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;

    --se selecciona el paquete
    select numslc into ls_numslc
    from solot where codsolot = a_codsolot;

    if ls_numslc is not null then
      ln_codsolot_ori := a_codsolot;
    else
      begin
        select distinct pq_cuspe_plataforma.F_GET_SOT_INS_SID(codinssrv)
        into ln_codsolot_ori
        from solotpto where codsolot = a_codsolot;
      exception
        when no_data_found then
          raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
        when too_many_rows then
          raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
      end;
    end if;

    begin
      select distinct idpaq into ln_idpaq
      from vtadetptoenl a, solot b
      where a.numslc = b.numslc
      and b.codsolot = ln_codsolot_ori;
    exception
      when no_data_found then
        raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
      when too_many_rows then
        raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
    end;

    --Cargar equipos en SOLOTPTOEQU
    for c_e in cur_equ loop
      --Se identifica el punto principal
      operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,l_punto,l_punto_ori,l_punto_des,c_e.tipsrv);

      SELECT NVL(MAX(ORDEN),0) + 1 INTO l_orden from solotptoequ
      where codsolot = a_codsolot and punto = l_punto;

      insert into solotptoequ(codsolot,
                              punto,
                              orden,
                              tipequ,
                              CANTIDAD,
                              TIPPRP,
                              COSTO,
                              flgsol,
                              flgreq,
                              codeta,
                              tran_solmat,
                              observacion,
                              fecfdis,
                              flg_ingreso,
                              flginv,
                              instalado,
                              fecins,
                              recuperable,
                              estado,
                              idagenda) -- campo idagenda
                       values(a_codsolot,
                              l_punto,
                              l_orden,
                              c_e.tipequ,
                              1,
                              0,
                              nvl(n_costo,0),
                              1,
                              0,
                              c_e.codeta,
                              null,
                              '' ,
                              sysdate,
                              1,
                              1,
                              1, --instalado
                              sysdate,
                              1,
                              4,
                              a_idagenda);
    end loop;
exception
  when others then
    an_cod_error := sqlcode;
    if an_cod_error = -20000 then
      av_des_error := substr(sqlerrm,12);
    else
      av_des_error := substr(sqlerrm,12)|| ' ('||dbms_utility.format_error_backtrace||')';
    end if;
end;

--Procedimiento que permite cargar en forma automatica la informacion de actividades a la Sot Basado en
--formulas definidas, la formula se selecciona automatica en base al tipo de trabajo de la sot
--y el detalle de actividades se selecciona en base al paquete de venta
PROCEDURE p_cargar_act_formula_masivo(a_codsolot solot.codsolot%type,
                                      a_idagenda in number,
                                      an_cod_error in out number,
                                      av_des_error in out varchar2) IS
ln_codfor number;
ln_punto number;
ln_punto_ori number;
ln_punto_des number;
ln_codeta number;
ln_codcon number;
ln_orden number;
ln_cont_for number;
ln_cont_etapa number;
ln_idpaq paquete_venta.idpaq%type;
ls_numslc vtatabslcfac.numslc%type;
ln_codsolot_ori solot.codsolot%type;

--Actividades Registros identificados en base a la formula
cursor cur_act is
select a.codact, a.cantidad, a.codeta, b.costo,b.moneda_id,b.codprec
from ope_formula_actividad_det a , actxpreciario b
where a.codfor = ln_codfor
and a.codact = b.codact
and b.activo = '1'
and a.idpaq = ln_idpaq;

begin
  --Se Valida que tenga Formula
  select count(1) into ln_cont_for
  from TIPTRABAJOXFOR a, solot b
  where a.tiptra = b.tiptra and codsolot = a_codsolot ;
  if ln_cont_for = 0 then
    RAISE_APPLICATION_ERROR(-20500,'El tipo de Trabajo de la SOT no tiene asociado una formula.');
  end if;
  --Se identifica la formula
  begin
    select codfor into ln_codfor from TIPTRABAJOXFOR a, solot b
    where a.tiptra = b.tiptra and codsolot = a_codsolot ;
  exception
     when no_data_found then
         raise_application_error(-20000,'No se encontró formula configurada.' );
       when too_many_rows then
         raise_application_error(-20000,'Se encontró mas de una formula configurada.' );
  end;
  --se selecciona el paquete
   select numslc into ls_numslc
   from solot where codsolot = a_codsolot;

   if ls_numslc is not null then
     ln_codsolot_ori := a_codsolot;
   else
     begin
       select distinct pq_cuspe_plataforma.F_GET_SOT_INS_SID(codinssrv)
       into ln_codsolot_ori
       from solotpto where codsolot = a_codsolot;
     exception
       when no_data_found then
         raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
       when too_many_rows then
         raise_application_error(-20000,'No se pudo obtener la SOT de instalación.' );
     end;
   end if;

   begin
     select distinct idpaq into ln_idpaq
     from vtadetptoenl a, solot b
     where a.numslc = b.numslc
     and b.codsolot = ln_codsolot_ori;
   exception
     when no_data_found then
       raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
     when too_many_rows then
       raise_application_error(-20000,'No se pudo obtener el paquete de venta.' );
   end;

  --Se identificar el punto principal
  operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,ln_punto,ln_punto_ori,ln_punto_des);

  --Cargar Actividades a la SOT : SOLOTPTOETAACT y SOLOTPTOETA
  for c_a in cur_act loop
    --Asigna la contrata para que se pueda valorizar por contrata
    if a_idagenda = 0 then--Sin Nuevo Agendamiento
      begin
      select min(codcon) into ln_codcon from solotpto_id where codsolot = a_codsolot;
      exception
      when no_data_found then
        ln_codcon := -1;
      end;
    elsif a_idagenda is null then--No envian Id Agenda para Nuevo Agendamiento
      raise_application_error(-20001,'No tiene agenda, por favor genere la agenda.' || to_char(nvl(a_idagenda,'444')));
    else--Agenda Nueva idagenda>0
      select nvl(codcon,0) into ln_codcon from agendamiento where idagenda = a_idagenda;
    end if;

    if ln_codcon = -1 then
      raise_application_error(-20001,'La SOT no tiene asignada Contratista, Asigne en la Programación de Instalaciones.' );
    end if;

    ln_codeta := c_a.codeta;

    select count(1) into ln_cont_etapa from solotptoeta where codsolot = a_codsolot and codeta = ln_codeta and codcon =ln_codcon;

    if ln_cont_etapa = 1 then--Existe Etapa
       select orden,punto into ln_orden,ln_punto from solotptoeta where codsolot = a_codsolot and codeta = ln_codeta and codcon =ln_codcon;
    else        --Genera la etapa en estado 15 : Preliquidacion
      SELECT NVL(MAX(ORDEN),0) + 1 INTO ln_orden from SOLOTPTOETA
      where codsolot = a_codsolot and punto = ln_punto;

      insert into solotptoeta(codsolot,
                              punto,
                              orden,
                              codeta,
                              porcontrata,
                              esteta,
                              obs,
                              Fecdis,
                              codcon,
                              fecini)
                       values(a_codsolot,
                              ln_punto,
                              ln_orden,
                              c_a.codeta,
                              1,
                              15,
                              '',
                              null,
                              ln_codcon,
                              sysdate);
    end if;

    --Inserta la Actividad en la Etapa
    insert into solotptoetaact(codsolot,
                               punto,
                               orden,
                               codact,
                               canliq,
                               cosliq,
                               canins,
                               candis,
                               cosdis,
                               Moneda_Id,
                               observacion,
                               codprecdis,
                               codprecliq,
                               flg_preliq,
                               contrata)
                        values(a_codsolot,
                               ln_punto,
                               ln_orden,
                               c_a.codact,
                               c_a.cantidad,
                               c_a.costo,
                               c_a.cantidad,
                               c_a.cantidad,
                               c_a.costo,
                               c_a.moneda_id,
                               '',
                               c_a.codprec,
                               c_a.codprec,
                               1,
                               1);
  end loop;

exception
  when others then
    an_cod_error := sqlcode;
    if an_cod_error = -20000 then
      av_des_error := substr(sqlerrm,12);
    else
      av_des_error := substr(sqlerrm,12)|| ' ('||dbms_utility.format_error_backtrace||')';
    end if;
end;

  --Carga de equipos,materiales y actividades
  procedure p_pos_cargar_equ_mat_act(a_idtareawf in number, a_idwf in number,a_tarea in number,a_tareadef in number)
  is

  ln_codsolot solot.codsolot%type;
  lv_observacion varchar2(4000);
  ln_tiptrs tiptrs.tiptrs%type;
  ls_tipesttar esttarea.tipesttar%type;
  ln_cod_error number;
  ls_des_error varchar2(4000);
  ln_idagenda agendamiento.idagenda%type;
  exception_carga exception;
  ln_tipo_tarea tareawfcpy.tipo%type; --0:normal,1:opcional, 2:automatica
  ln_tipo_error number; --0:mensaje error, 1:cambia a estado "con errores"
  ln_num_error number;
  begin

    select codsolot into ln_codsolot
    from wf where idwf =  a_idwf;

    --se averigua tipo de transaccion
    select nvl(b.tiptrs,0) into ln_tiptrs
    from solot a,tiptrabajo b
    where a.tiptra = b.tiptra
    and codsolot = ln_codsolot;

    select max(idagenda) into ln_idagenda
    from agendamiento
    where codsolot = ln_codsolot;

    if ln_idagenda is not null then
      --se ejecuta la carga de materiales
      p_cargar_mat_formula_masivo(ln_codsolot,ln_idagenda,ln_cod_error,ls_des_error);
      if ln_cod_error is null then
        --se ejecuta la carga de equipos
        p_cargar_equ_formula_masivo(ln_codsolot,ln_idagenda,ln_cod_error,ls_des_error);
        if ln_cod_error is null then
          --se ejecuta la carga de actividades
          p_cargar_act_formula_masivo(ln_codsolot,ln_idagenda,ln_cod_error,ls_des_error);
          if ln_cod_error is not null then
            lv_observacion := ls_des_error;
            raise exception_carga;
          end if;
        else
          lv_observacion := ls_des_error;
          raise exception_carga;
        end if;
      else
        lv_observacion := ls_des_error;
        raise exception_carga;
      end if;

    else
      lv_observacion := 'No se encontró agendamiento asociado a la SOT.';
      raise exception_carga;
    end if;
  exception
    when exception_carga then
       --logica para gestion de errores
       select tipo into ln_tipo_tarea
       from tareawfcpy
       where idtareawf = a_idtareawf;

       if ln_tipo_tarea in (0,1) then --si es tarea normal u opcional
         ln_tipo_error := 0; --mensaje error
       else --tarea automatica
         select count(1) into ln_num_error --se cuenta si paso por estado "con errores"
         from tareawfchg
         where idtareawf = a_idtareawf
         and esttarea = cn_esttarea_error;

         if ln_num_error > 0 then --si estuvo en estado error
           ln_tipo_error := 0; --mensaje error
         else --si es primera vez que se genera ta tarea
           ln_tipo_error := 1; --cambia a estado "con errores"
         end if;
       end if;

       --si la tarea es nulo entonces proviene de un cambio de estado
       if ln_tipo_error = 1 then
            --se ingresa el error como anotacion
            insert into tareawfseg(idtareawf, observacion)
            values(a_idtareawf, lv_observacion);

            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_error;

            --se cambio a estado error
            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                             ls_tipesttar,
                                             cn_esttarea_error,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
         else
            RAISE_APPLICATION_ERROR(-20500, lv_observacion);
         end if;
         return;
  end;
--4.0>



/*********************************************************************************************************************/
--Procedimiento que permite cargar masivamente los equipos
--   Ver        Date        Author           Description
--   ---------  ----------  ---------------  ------------------------------------
--
/*********************************************************************************************************************/
procedure p_recupera_equ_mat(a_codsolot IN NUMBER , a_cod_sap in varchar2,a_Cantidad in number,a_serie in varchar2,a_recuperable in number,a_error out number)
is
n_existsot number;
n_existcodcon number;
n_existcodsap number;
n_tiptra number;
l_cont_for number;
n_tipequ number;
n_cont_equ number;
n_cont_tipequ number;
l_existequ number;
--Materiales identificados en base a la formula
cursor cur_mat is
  select a_codsolot sot_baja, a.codsolot sot, a.punto punto, a.orden orden
  from solotptoequ a, solot b, solotpto d, tipequ f, almtabmat g, tiptrabajo h , inssrv i
  where a.codsolot = b.codsolot
  and a.codsolot = d.codsolot
  and i.codinssrv = d.codinssrv
  and a.punto = d.punto
  and a.tipequ = f.tipequ
  and f.codtipequ = g.codmat
  and b.tiptra=h.tiptra
  and a.codsolot = (select max(a.codsolot) from solot a,solotpto b,tiptrabajo c
  where a.codsolot = b.codsolot and a.tiptra = c.tiptra
  and c.tiptrs = 1 and b.codinssrv in
  (select codinssrv from solotpto where codsolot = a_codsolot))
  and a.estado <> 10
  and TRIM(g.cod_sap) = a_cod_sap and   a.cantidad =a_Cantidad--9.0
  and nvl(a.numserie,'--') = nvl(a_serie,'--');--9.0
begin
  a_error := 0;
  --Valida si existe la SOT
  select count(1) into n_existsot from solot where codsolot = a_codsolot;
  if n_existsot = 0 then
    a_error := -1;
  end if;
  --Valida el codigo SAP
  select count(1) into n_existcodsap from almtabmat where TRIM(cod_sap) = a_cod_sap;
  if n_existcodsap = 0 then
    a_error := -3;
  end if;
  --Valida la cantidad
  if a_Cantidad = 0 or a_Cantidad is null then
    a_error := -4;
  end if;
  --Se Valida que tenga Formula
  select count(*)into l_cont_for from TIPTRABAJOXFOR a, solot b
  where a.tiptra = b.tiptra and codsolot = a_codsolot;
  if l_cont_for = 0 then
    a_error := -5;
  end if;
  --Se Valida que existe codigo de equipo de SGA
  select count(*)into n_cont_tipequ from tipequ a, almtabmat b
  where a.codtipequ= b.codmat and b.cod_Sap = a_cod_sap;
  if not l_cont_for = 1 then
    a_error := -6;
  end if;
/*  --No existe linea en control de Equipos
  select count(1) into n_cont_equ from solotptoequ
  where codsolot = a_codsolot and tipequ = n_tipequ
  and nvl(numserie,'') = nvl(a_serie,'') and cantidad = a_cantidad;
  if n_cont_equ = 0 then
    a_error := -7;
  end if;*/

   for c_m in cur_mat loop
      update solotptoequ set recuperable = a_recuperable
      where codsolot = c_m.sot and punto = c_m.punto and orden =c_m.orden;
   end loop;
   a_error:= 0;

end;

--Inicio 11.0
procedure p_carga_can_liq_equ(a_codsolot IN NUMBER , a_cod_sap in varchar2,a_Cantidad in number, a_serie in varchar2,a_error out number)
is
n_existcodsap number;
n_tipequ number;
n_existsot number;

begin
  a_error := 0;
  --Valida si existe la SOT
  select count(1) into n_existsot from solot where codsolot = a_codsolot;
  if n_existsot = 0 then
    a_error := -1;
  end if;
  --Valida el codigo SAP
  select count(1) into n_existcodsap from almtabmat where TRIM(cod_sap) = TRIM(a_cod_sap);--12.0
  if n_existcodsap = 0 then
    a_error := -3;
  end if;
  --Valida la cantidad
  if a_Cantidad = 0 or a_Cantidad is null then
    a_error := -4;
  end if;

  select a.tipequ into n_tipequ from tipequ a, almtabmat b, solotptoequ c
  where a.codtipequ = b.codmat and trim(cod_Sap)  = TRIM(a_cod_sap) and a.tipequ = c.tipequ and c.codsolot = a_codsolot; --12.0

  update solotptoequ set CANLIQ = a_Cantidad, NUMSERIE = nvl(a_serie,NUMSERIE)
  where codsolot = a_codsolot and tipequ = n_tipequ;
  a_error:= 0;

end;
--Fin 11.0

--Ini 14.0
procedure p_insert_ope_list_carg_masiva(
  an_ORDEN        in   OPERACION.CARGAR_EXCEL_TEMP.orden%type,
  an_PUNTO        in   OPERACION.CARGAR_EXCEL_TEMP.punto%type,
  an_CODETA       in   OPERACION.CARGAR_EXCEL_TEMP.CODETA%type,
  an_COD_SAP      in   OPERACION.CARGAR_EXCEL_TEMP.COD_SAP%type,
  an_CODTIPEQU    in   OPERACION.CARGAR_EXCEL_TEMP.CODTIPEQU%type,
  an_CANTIDAD     in   OPERACION.CARGAR_EXCEL_TEMP.CANTIDAD%type,
  an_TIPPRP       in   OPERACION.CARGAR_EXCEL_TEMP.TIPPRP%type,
  an_NUMSERIE     in   OPERACION.CARGAR_EXCEL_TEMP.NUMSERIE%type,
  an_FECINS       in   OPERACION.CARGAR_EXCEL_TEMP.FECINS%type,
  an_INSTALADO    in   OPERACION.CARGAR_EXCEL_TEMP.INSTALADO%type,
  an_ESTADO       in   OPERACION.CARGAR_EXCEL_TEMP.ESTADO%type,
  an_CODEQUCOM    in   OPERACION.CARGAR_EXCEL_TEMP.CODEQUCOM%type,
  an_TIPO         in   OPERACION.CARGAR_EXCEL_TEMP.TIPO%type,
  an_FLGINV       in   OPERACION.CARGAR_EXCEL_TEMP.FLGINV%type,
  an_FECINV       in   OPERACION.CARGAR_EXCEL_TEMP.FECINV%type,
  an_TIPCOMPRA    in   OPERACION.CARGAR_EXCEL_TEMP.TIPCOMPRA%type,
  an_OBSERVACION  in   OPERACION.CARGAR_EXCEL_TEMP.OBSERVACION%type,
  an_FLGSOL       in   OPERACION.CARGAR_EXCEL_TEMP.FLGSOL%type,
  an_FLGREQ       in   OPERACION.CARGAR_EXCEL_TEMP.FLGREQ%type,
  an_CODALMACEN   in   OPERACION.CARGAR_EXCEL_TEMP.CODALMACEN%type,
  an_FLG_VENTAS   in   OPERACION.CARGAR_EXCEL_TEMP.FLG_VENTAS%type,
  an_CODALMOF     in   OPERACION.CARGAR_EXCEL_TEMP.CODALMOF%type,
  an_FECFINS      in   OPERACION.CARGAR_EXCEL_TEMP.FECFINS%type,
  an_CODUSUDIS    in   OPERACION.CARGAR_EXCEL_TEMP.CODUSUDIS%type,
  an_CENTROSAP    in   OPERACION.CARGAR_EXCEL_TEMP.CENTROSAP%type,
  an_ALMACENSAP   in   OPERACION.CARGAR_EXCEL_TEMP.ALMACENSAP%type,
  an_CANLIQ       in   OPERACION.CARGAR_EXCEL_TEMP.CANLIQ%type,
  an_codsolot     in   number,
  an_nro_filas    in   number,
  an_id_rubro     in   number) is

  begin
    --INI 15.0
    BEGIN
       insert into operacion.CARGAR_EXCEL_TEMP
         (ORDEN,
          PUNTO,
          CODETA,
          COD_SAP,
          CODTIPEQU,
          CANTIDAD,
          TIPPRP,
          NUMSERIE,
          FECINS,
          INSTALADO,
          ESTADO,
          CODEQUCOM,
          TIPO,
          FLGINV,
          FECINV,
          TIPCOMPRA,
          OBSERVACION,
          FLGSOL,
          FLGREQ,
          CODALMACEN,
          FLG_VENTAS,
          CODALMOF,
          FECFINS,
          CODUSUDIS,
          CENTROSAP,
          ALMACENSAP,
          CANLIQ,
          codsolot,
         nro_filas,
          cod_rubro)

       values
         (an_ORDEN,
          an_PUNTO,
          an_CODETA,
          an_COD_SAP,
          an_CODTIPEQU,
          an_CANTIDAD,
          an_TIPPRP,
          an_NUMSERIE,
          to_date(an_FECIns),
          an_INSTALADO,
          an_ESTADO,
          an_CODEQUCOM,
          an_TIPO,
          an_FLGINV,
          to_date(an_FECINV),
          an_TIPCOMPRA,
          an_OBSERVACION,
          an_FLGSOL,
          an_FLGREQ,
          an_CODALMACEN,
          an_FLG_VENTAS,
          an_CODALMOF,
          to_date(an_FECFINS),
          an_CODUSUDIS,
          an_CENTROSAP,
          an_ALMACENSAP,
          an_CANLIQ,
          an_codsolot,
          an_nro_filas,
          an_id_rubro);
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,sqlerrm);
   END;
/*   BEGIN */
       p_validar_excl_carga_masiva( an_ORDEN  ,
                                    an_PUNTO   ,
                                    an_CODETA  ,
                                    an_COD_SAP,
                                    an_CODTIPEQU,
                                    an_CANTIDAD ,
                                    an_OBSERVACION ,
                                    an_CENTROSAP ,
                                    an_ALMACENSAP );
/*   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,'p_validar_excl_carga_masiva.' || chr(13) || sqlerrm);
   END;  */
   --FIN 15.0
  end ;

  procedure p_validar_excl_carga_masiva(
  an_ORDEN       in  operacion.CARGAR_EXCEL_TEMP.orden%type,
  an_PUNTO       in  operacion.CARGAR_EXCEL_TEMP.punto%type,
  an_CODETA      in  operacion.CARGAR_EXCEL_TEMP.CODETA%type,
  an_COD_SAP     in  operacion.CARGAR_EXCEL_TEMP.COD_SAP%type,
  an_CODTIPEQU   in  operacion.CARGAR_EXCEL_TEMP.CODTIPEQU%type,
  an_CANTIDAD    in  operacion.CARGAR_EXCEL_TEMP.CANTIDAD%type,
  an_OBSERVACION in  operacion.CARGAR_EXCEL_TEMP.OBSERVACION%type,
  an_CENTROSAP   in  operacion.CARGAR_EXCEL_TEMP.CENTROSAP%type,
  an_ALMACENSAP  in  operacion.CARGAR_EXCEL_TEMP.ALMACENSAP%type)

  is

   ln_codtipequ      number;
   ln_punto          CARGAR_EXCEL_TEMP.punto%type;
   ll_punto          number;
   ll_codeta         number;
   ln_punto_b        CARGAR_EXCEL_TEMP.punto%type;
   ll_punto_b        number;
   ll_codeta_b       number;
   ln_codeta_b       CARGAR_EXCEL_TEMP.CODETA%type;
   ll_codsap         number;
   ll_codet          number;
   ll_codtipequ      number;
   l_id_proy_control number;
   l_TIPPRP          number;
   l_estado          number;
   l_tipequ          TIPEQU.tipequ%Type;
   l_cantidad        solotptoequ.cantidad%type;
   l_Cnt             number;
   l_decimal         number;
  begin

  for reg in (select c.*   from operacion.CARGAR_EXCEL_TEMP  c
                where
                c.punto=an_PUNTO  or c.punto is null  and
                c.codeta=an_CODETA  or c.codeta is null      and
                c.codtipequ=an_CODTIPEQU or c.codtipequ is null    and
                c.cod_sap=an_COD_SAP or   c.cod_sap  is null     and
                c.cantidad=an_CANTIDAD or c.cantidad is null       and
                c.observacion=an_OBSERVACION or c.observacion is null      and
                c.centrosap=an_CENTROSAP or c.centrosap is null      and
                c.almacensap=an_ALMACENSAP or c.almacensap  is null  )

  loop

  if reg.punto is null then
    insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
    values (reg.nro_filas,'Punto','SOT:' || reg.codsolot || '. Debe ingresar el punto, Nro fila->' || reg.nro_filas);
  end if;

  if reg.codeta is null  then
    insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
    values (reg.nro_filas,'Etapa','SOT:' || reg.codsolot || '. Ingrese Etapa, Nro fila->' || reg.nro_filas);
  end if;

  if reg.codtipequ is null and reg.cod_sap is null  then
    insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
    values (reg.nro_filas,'Cod.SGA/Cod.Sap','SOT:' || reg.codsolot || '. Ingrese Codigo SGA o Codigo SAP, Nro fila->' || reg.nro_filas);
  end if;

  if reg.cantidad is null  then
      insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
      values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || '. Ingrese cantidad, Nro fila->' || reg.nro_filas);
  end if;

  if reg.cantidad = '0' then
      insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
      values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || '. La cantidad no puede ser cero, Nro fila->' || reg.nro_filas);
  end if;

  IF instr(reg.cantidad,',') > 0 THEN
     insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
     values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || ',La cantidad debe ser numerico (' || reg.cantidad ||'), Nro Fila->' || reg.nro_filas);
  ELSE
     IF instr(reg.cantidad,'.') > 0 THEN
        l_decimal := Length(Substr(reg.cantidad,instr(reg.cantidad,'.') + 1));
        IF l_decimal > 2 THEN
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || '. La cantidad decimales permitidos es de 2 digitos, Nro Fila->' || reg.nro_filas);
        ELSE
          BEGIN
                l_cantidad := to_number(reg.cantidad,'99999999.99');
           EXCEPTION
           WHEN OTHERS THEN
                insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || '. La cantidad debe ser numerico, Nro Fila->' || reg.nro_filas);
           END;
        END IF;
     ELSE
         BEGIN
              l_cantidad := to_number(reg.cantidad,'99999999.99');
         EXCEPTION
         WHEN OTHERS THEN
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cantidad','SOT:' || reg.codsolot || '. La cantidad debe ser numerico, Nro Fila->' || reg.nro_filas);
         END;
     END IF;
  END IF;
  IF reg.flginv is not null THEN
      BEGIN
          l_cantidad := to_number(reg.flginv);
          IF l_cantidad not in (0,1) THEN
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'Inv','SOT:' || reg.codsolot || '. La Inversion debe ser 0 o 1, Nro Fila->' || reg.nro_filas);
          END IF;
      EXCEPTION
      WHEN OTHERS THEN
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'Inv','SOT:' || reg.codsolot || '. La Inversion debe ser numerico, Nro Fila->' || reg.nro_filas);
      end;
  END IF;

  IF  reg.codalmacen is not null THEN
      BEGIN
          l_cantidad := to_number(reg.codalmacen);
      EXCEPTION
      WHEN OTHERS THEN
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'codalmacen','SOT:' || reg.codsolot || '. El codalmacen debe ser numerico, Nro Fila->' || reg.nro_filas);
      end;
  END IF;

  IF reg.flgsol is not null THEN
      BEGIN
          l_cantidad := to_number(reg.flgsol);
          IF l_cantidad not in (0,1) THEN
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'Sol','SOT:' || reg.codsolot || '. La Solic. debe ser 0 o 1, Nro Fila->' || reg.nro_filas);
          END IF;
      EXCEPTION
      WHEN OTHERS THEN
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'Sol','SOT:' || reg.codsolot || '. La Solic. debe ser numerico, Nro Fila->' || reg.nro_filas);
      end;
  END IF;

  IF reg.flgreq is not null THEN
      BEGIN
          l_cantidad := to_number(reg.flgreq);
          IF l_cantidad not in (0,1) THEN
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'Fin.Dis','SOT:' || reg.codsolot || '. La Solic. debe ser 0 o 1, Nro Fila->' || reg.nro_filas);
          END IF;
      EXCEPTION
      WHEN OTHERS THEN
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'Fin.Dis','SOT:' || reg.codsolot || '. La Solic. debe ser numerico, Nro Fila->' || reg.nro_filas);
      end;
  END IF;

  IF reg.instalado is Not null THEN
      BEGIN
          l_cantidad := to_number(reg.instalado);
          IF l_cantidad not in (0,1,2) THEN
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'I/R','SOT:' || reg.codsolot || '. I/R debe ser 0, 1 o 2, Nro Fila->' || reg.nro_filas);
          END IF;
      EXCEPTION
      WHEN OTHERS THEN
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'I/R','SOT:' || reg.codsolot || '. I/R debe ser numerico, Nro Fila->' || reg.nro_filas);
      end;
   END IF;

  if reg.observacion is null  then
     insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
     values (reg.nro_filas,'Observacion','SOT:' || reg.codsolot || '. Ingrese la Observacion, Nro fila->' || reg.nro_filas);
  end if;

  if reg.tipprp is null  then
     insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
     values (reg.nro_filas,'Propiedad','SOT:' || reg.codsolot || '. Ingrese el Tipo de Propiedad, Nro fila->' || reg.nro_filas);
  end if;

  if reg.centrosap is null  then
     insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
     values (reg.nro_filas,'Centro Sap','SOT:' || reg.codsolot || '. Ingrese Centro SAP, Nro fila->' || reg.nro_filas);
  end if;

  if reg.almacensap is null  then
     insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
     values (reg.nro_filas,'Almacen Sap','SOT:' || reg.codsolot || '. Ingrese Almacen SAP, Nro fila->' || reg.nro_filas);
  end if;
  --FIN 15.0
  IF trim(reg.TIPPRP ) is not NULL THEN
      SELECT count(*)
      into l_TIPPRP
      FROM TIPPROPIEDAD t
        where trim(t.DESCRIPCION) = trim(reg.TIPPRP ) ;

      if l_TIPPRP = 0 then
         insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
         values (reg.nro_filas,'Propiedad','SOT:' || reg.codsolot || '. El tipo de propiedad : ' || trim(reg.TIPPRP ) ||  ' no se encuentra en la Base de Datos, Nro fila->' || reg.nro_filas);
       end if;
  END IF;
  --INI 15.0
  IF trim(reg.estado) is not null THEN
      SELECT count(*)
      into l_estado
      FROM V_DD_ESTADO_SOLOTPTOEQU a
      where trim(DESCRIPCION) = trim(reg.estado);

      if l_estado = 0 then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Estado','SOT:' || reg.codsolot || '. El estado: ' || trim(reg.estado) ||  ' no se encuentra en la Base de Datos, Nro fila->' || reg.nro_filas);
      end if;
  END IF;
  --FIN 15.0
  ---validar punto si existe en base de datos
  ln_punto_b:=reg.punto;
  IF reg.punto is not null THEN
     SELECT count(*)
       into ll_punto
       FROM solotpto
      WHERE solotpto.codsolot = reg.codsolot
        and solotpto.punto || ' - ' || trim(solotpto.descripcion)   = trim(ln_punto_b); -- INI 15.0

     IF ll_punto = 0 THEN
         insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
         values (reg.nro_filas,'Punto','SOT:' || reg.codsolot || '. El Punto :' || trim(ln_punto_b) || ' ingresado no esta asociada a la SOT:' ||'-'||reg.codsolot || ', Nro fila->' || reg.nro_filas); --15.0
     ELSE
       IF ll_punto > 1 THEN
         insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
         values (reg.nro_filas,'Punto','SOT:' || reg.codsolot || '. La descripción :' || trim(ln_punto_b) || ' corresponde a mas de un punto en la Sot : ' || reg.codsolot || ', Nro fila->' || reg.nro_filas); -- 15.0
       END IF;
     END IF;
  END IF;
  IF  reg.codeta is not null THEN -- 15.0
    --VALIDAR CODETA
    ln_codeta_b:=reg.codeta;
       select count(*)
       into ll_codeta_b
       from etapa e
       where trim(e.descripcion) = trim(ln_codeta_b);
     if ll_codeta_b <= 0 then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Etapa','SOT:' || reg.codsolot || '. La descripcion de la Etapa ' || trim(reg.codeta) || ' no esta en BD del SGA, Nro Fila->' || reg.nro_filas);--15.0
     ELSE
        SELECT count(*)
        INTO ll_codeta_b
        FROM PREUSUFAS                             P,
               ETAPA                                 E,
               financial.z_ps_rubro_etapa            z,
               financial.cust_per_sgapc_tbl_tipoproy t
        WHERE P.CODETA = E.CODETA
           AND P.CODUSU = user
           and trim(e.descripcion) = trim(ln_codeta_b)
           and e.codeta = z.codeta
           and z.rubro = t.tipo_proy_sga
           and t.tipo_proy_sga = reg.cod_rubro
           and p.codfas = 2;
        if ll_codeta_b <=0 then
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Etapa','SOT:' || reg.codsolot || '. La Etapa: ' || trim(reg.codeta) || ', Rubro:' || reg.cod_rubro || ' no esta asociada al punto., Nro Fila ->' || reg.nro_filas);
        end if;
      END IF;
  END IF;
  --FIN 15.0
  --- Validacion de EF codtipequ Validar que el codigo tipo equipo es valido
  IF reg.CODTIPEQU IS NOT NULL THEN
    BEGIN
      select t.tipequ
      into l_tipequ
      from TIPEQU t
      where trim(codtipequ) = trim(reg.CODTIPEQU) and
            rownum = 1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
         values (reg.nro_filas,'Cod.SGA','SOT:' || reg.codsolot || ', No existe Cod.SGA ('|| reg.CODTIPEQU || ') en la Base de Datos, Nro Fila->' || reg.nro_filas);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500, 'Error Codtipequ (' || trim(reg.CODTIPEQU) || ')' || chr(13) || sqlerrm);
    END;
  END IF;

--  PQ_Z_PS_VALIDACIONES.P_CONTROLADO(reg.cod_rubro, l_id_proy_control) ;
  pq_z_ps_validaciones.p_controlar_solot_tot(reg.codsolot, l_id_proy_control);

  IF trim(ln_codeta_b) is not null THEN
    BEGIN
       select e.codeta
         into ll_codet
         from etapa e
        where trim(e.descripcion) = trim(ln_codeta_b);
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,sqlerrm);
    END;

     --15.0
    if l_id_proy_control = 1 and NVL(reg.instalado,5) <> 0 then
        IF reg.codtipequ is not null THEN
          select count(*)
            into ll_codtipequ
            from tipequ,
                 almtabmat,
                 financial.z_ps_rubro_etapa_comp,
                 z_ps_val_busqueda_det
           where (almtabmat.codmat(+) = tipequ.codtipequ)
             and (z_ps_val_busqueda_det.valor(+) = nvl(almtabmat.componente, '@'))
             and (z_ps_val_busqueda_det.codigo(+) = 'TIPO_COMP')
             and (tipequ.estequ = 1)
             and (almtabmat.componente = financial.z_ps_rubro_etapa_comp.componente)
             and (financial.z_ps_rubro_etapa_comp.codeta = ll_codet)
             and (financial.z_ps_rubro_etapa_comp.rubro = reg.cod_rubro)
             and trim(tipequ.codtipequ) = trim(reg.codtipequ);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.SGA','SOT:' || reg.codsolot || '. Codigo SGA ' || reg.codtipequ || ' no corresponde al Punto y Etapa, Nro Fila->' || reg.nro_filas ); -- 15.0
          end if ;
        ELSE
           select count(*)
           into ll_codtipequ
           from tipequ,
                 almtabmat,
                 financial.z_ps_rubro_etapa_comp,
                 z_ps_val_busqueda_det
           where (almtabmat.codmat(+) = tipequ.codtipequ)
             and (z_ps_val_busqueda_det.valor(+) = nvl(almtabmat.componente, '@'))
             and (z_ps_val_busqueda_det.codigo(+) = 'TIPO_COMP')
             and (tipequ.estequ = 1)
             and (almtabmat.componente = financial.z_ps_rubro_etapa_comp.componente)
             and (financial.z_ps_rubro_etapa_comp.codeta = ll_codet)
             and (financial.z_ps_rubro_etapa_comp.rubro = reg.cod_rubro)
             and trim(almtabmat.cod_sap) = trim(reg.cod_sap);

           if ll_codtipequ = 0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.Sap','SOT:' || reg.codsolot || '. El Codigo SAP ' || reg.cod_sap || ' no corresponde al Punto y Etapa, Nro Fila->' || reg.nro_filas); -- 15.0
           end if ;
        END IF;
    ELSE
         IF reg.codtipequ is not null THEN
          select count(*)
            into ll_codtipequ
            from tipequ
           where trim(tipequ.codtipequ) = trim(reg.codtipequ);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.SGA','SOT:' || reg.codsolot || '. El codigo SGA ' || reg.codtipequ || ' no existe en la Base de Datos del SGA,  Nro Fila->' || reg.nro_filas); --15.0
          else
              IF ll_codtipequ > 1 THEN
                 insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                 values (reg.nro_filas,'Cod.SGA','SOT:' || reg.codsolot || '. El codigo SGA :' || reg.codtipequ || ' tiene mas de 1 registro equivalente en TIPEQU en el SGA,  Nro Fila->' || reg.nro_filas); -- 15.0
              END IF;
         end if ;
        ELSE
          select count(*)
            into ll_codtipequ
            from tipequ,
                 almtabmat
           where (almtabmat.codmat(+) = tipequ.codtipequ)
            and trim(almtabmat.cod_sap) = trim(reg.cod_sap);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.Sap','SOT:' || reg.codsolot || '. El codigo SAP ' || reg.cod_sap || ' no existe en la Base de Datos SAP,  Nro Fila->' || reg.nro_filas); -- 15.0
          else
             IF ll_codtipequ > 1 THEN
                insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                values (reg.nro_filas,'Cod.Sap','SOT:' || reg.codsolot || '. El codigo sap :' || reg.cod_sap || ' tiene mas de un codigo de equipo,  Nro Fila->' || reg.nro_filas); -- 15.0
             END IF;
          end if ;
        END IF;
    END IF;
  END IF;

  IF reg.CODTIPEQU IS NULL and reg.cod_sap is NOT null THEN
    BEGIN
      select trim(a.codmat)
      into reg.CODTIPEQU
      from almtabmat a
      where trim(a.cod_sap) = trim(reg.cod_sap) and
            rownum = 1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
         values (reg.nro_filas,'Cod.Sap','SOT:' || reg.codsolot || ', No existe Codigo SAP (' || reg.cod_sap || ') en la Base de Datos SGA, Nro Fila->' || reg.nro_filas);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500, 'Error Codtipequ (' || trim(reg.CODTIPEQU) || ')' || chr(13) || sqlerrm);
    END;
  END IF;

  if reg.centrosap is not null  then
     select count(*)
     into l_Cnt
     from z_mm_configuracion
     where centro = reg.centrosap;

     IF l_Cnt = 0 THEN
       insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
       values (reg.nro_filas,'Centro Sap','SOT:' || reg.codsolot || '. Centro SAP (' || reg.centrosap || ') no existe en la Base de Datos del SGA, Nro fila->' || reg.nro_filas);
     END IF;
     if reg.almacensap is not null then
         select count(*)
         into l_Cnt
         FROM Z_MM_CONFIGURACION
         WHERE ALMACEN = reg.almacensap;

         IF l_Cnt = 0 THEN
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Almacen Sap','SOT:' || reg.codsolot || '. Almacen SAP (' || reg.almacensap || ') no existe en la Base de Datos del SGA, Nro fila->' || reg.nro_filas);
         ELSE
             select count(*)
             into l_Cnt
             FROM Z_MM_CONFIGURACION
             WHERE CENTRO = reg.centrosap and
                    ALMACEN = reg.almacensap;

             IF l_Cnt = 0 THEN
               insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
               values (reg.nro_filas,'Almacen Sap','SOT:' || reg.codsolot || '. Almacen SAP (' || reg.almacensap || ') no pertenece al centro SAP ' || reg.centrosap || ', Nro fila->' || reg.nro_filas);
             END IF;
         END IF;
     end if;
  end if;

end loop;
end ;

  procedure p_insertar_sololptoeq
  is

  I_VERY         INTEGER;
  ll_punto       number;
  ln_punto       operacion.CARGAR_EXCEL_TEMP.punto%type;
  ln_punto_a     CARGAR_EXCEL_TEMP.punto%type;
  ll_punto_b     number;
  ln_codeta      CARGAR_EXCEL_TEMP.CODETA%type;
  ll_codeta      number;
  l_tipequ       tipequ.tipequ%type;
  l_TIPPRP       TIPPROPIEDAD.TIPPRP%type;
  l_estado       V_DD_ESTADO_SOLOTPTOEQU.estado%type;
  ll_orden       operacion.solotptoequ.orden%type;
  l_costo        TIPEQU.costo%type;
  l_descripcion  TIPEQU.descripcion%Type;
  l_cantidad     solotptoequ.cantidad%type;
  begin

  for reg in (select a.* from OPERACION.CARGAR_EXCEL_TEMP a)
  loop

   ln_punto_a:=reg.punto;
   --INI 15.0
   BEGIN
     SELECT solotpto.punto
     into ll_punto_b
     FROM solotpto
     WHERE solotpto.codsolot = reg.codsolot
       and solotpto.punto || ' - ' || solotpto.descripcion = trim(ln_punto_a);
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,sqlerrm);
   END;
   --FIN 15.0
  ln_codeta:=reg.codeta;

  if ln_codeta is not null then
     BEGIN -- 15.0
       select distinct etapa.codeta
       into ll_codeta
       from etapa
       where etapa.descripcion = ln_codeta;
     --INI 15.0
     EXCEPTION
     WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500,sqlerrm);
     END;
     --FIN 15.0
  end if ;
  IF trim(reg.TIPPRP) is not null THEN
      BEGIN -- 15.0
        SELECT TIPPRP
        into l_TIPPRP
        FROM TIPPROPIEDAD t
        where trim(t.DESCRIPCION) = trim(reg.TIPPRP);
      --INI 15.0
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500,sqlerrm);
      END;
      --FIN 15.0
  END IF;
  IF trim(reg.estado) is not null THEN --15.0
      BEGIN  -- 15.0
          SELECT a.estado
            into l_estado
            FROM V_DD_ESTADO_SOLOTPTOEQU a
           where trim(DESCRIPCION) = trim(reg.estado);
      --INI 15.0
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500,sqlerrm);
      END;
      --FIN 15.0
  END IF;
  /*VERIFICA QUE CLAVES PRIMARIAS SE REPITEN*/
  SELECT count(*)
    INTO I_VERY
    FROM operacion.solotptoequ
   WHERE operacion.solotptoequ.CODSOLOT = REG.CODSOLOT
     AND operacion.solotptoequ.PUNTO = ll_punto_b
     AND operacion.solotptoequ.ORDEN = to_number(REG.ORDEN);

  /*SI SE REPITE, ENTONES ACTUALIZA,  DE LO CONTRARIO INSERTA*/
  /*ACTUALIZA*/

  if reg.codtipequ is not null then
     select tipequ, costo, descripcion
      into l_tipequ, l_costo, l_descripcion
      from tipequ
      where trim(codtipequ) =trim(reg.codtipequ)
         and rownum = 1;
  else
      BEGIN
         select tipequ, costo, descripcion
         into l_tipequ, l_costo, l_descripcion
         from tipequ,
              almtabmat
         where almtabmat.codmat = tipequ.codtipequ
           and trim(almtabmat.cod_sap) = trim(reg.cod_sap)
           and rownum = 1;
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500,sqlerrm);
      End;
  end if;

  BEGIN
      l_cantidad := to_number(reg.cantidad,'99999.9999');
  EXCEPTION
  WHEN OTHERS THEN
      l_cantidad := 0;
  END;

  IF I_VERY = 1 THEN
     update operacion.solotptoequ
       set tipequ      = l_tipequ,
           cantidad    = l_cantidad,
           tipprp      = l_tipprp,
           numserie    = reg.numserie,
           fecins      = reg.fecins,
           instalado   = to_number(reg.instalado),
           estado      = l_estado,
           tipo        = to_number(reg.tipo),
           flginv      = to_number(reg.flginv),
           fecinv      = reg.fecinv,
           tipcompra   = to_number(reg.tipcompra),
           observacion = reg.observacion,
           flgsol      = to_number(reg.flgsol),
           fecfdis     = DECODE(reg.flgreq, '1', SYSDATE, null),
           codeta      = ll_codeta,
           codalmacen  = to_number(reg.codalmacen),
           flg_ventas  = to_number(reg.flg_ventas),
           codalmof    = to_number(reg.codalmof),
           fecfins     = reg.fecfins,
           codusudis   = reg.centrosap,
           centrosap   = reg.centrosap,
           almacensap  = reg.almacensap,
           canliq      = to_number(reg.canliq),
           costo       = l_costo
     where operacion.solotptoequ.codsolot = reg.codsolot
       and operacion.solotptoequ.punto = ll_punto_b
       and operacion.solotptoequ.ORDEN = to_number(REG.ORDEN);

  ELSE
      Begin -- 15.0
         ln_punto := reg.punto;
         SELECT solotpto.punto
           into ll_punto
         FROM solotpto
         WHERE solotpto.codsolot = reg.codsolot
            and solotpto.punto || ' - ' || TRIM(solotpto.descripcion) = trim(ln_punto);
      --INI 15.0
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500,sqlerrm);
      End;
      --FIN 15.0
      Begin --INI 15.0
           select nvl(max(orden),0)
           into ll_orden
           from  operacion.solotptoequ
           where codsolot = reg.codsolot;
      --INI 15.0
      Exception
      when no_data_found then
           ll_orden := 0;
      End;
      --FIN 15.0
       ll_orden := ll_orden + 1;
       BEGIN
       insert into operacion.solotptoequ (
          CODSOLOT,
          PUNTO,
          ORDEN,
          TIPEQU,
          CANTIDAD,
          TIPPRP,
          NUMSERIE,
          FECINS,
          INSTALADO,
          ESTADO,
          TIPO,
          FLGINV,
          FECINV ,
          TIPCOMPRA ,
          OBSERVACION ,
          FLGSOL ,
          fecfdis ,
          CODETA ,
          CODALMACEN ,
          FLG_VENTAS ,
          CODALMOF ,
          FECFINS ,
          CODUSUDIS,
          CENTROSAP ,
          ALMACENSAP,
          CANLIQ,
          costo )
       values
          (reg.codsolot,
           ll_punto,
          ll_orden,
          l_tipequ,
          l_cantidad,
          l_TIPPRP,
          reg.NUMSERIE ,
          reg.fecins,
          to_number(reg.INSTALADO),
          l_ESTADO,
          to_number(reg.TIPO),
          to_number(reg.FLGINV),
          reg.FECINV,
          to_number(reg.TIPCOMPRA),
          reg.OBSERVACION,
          DECODE(reg.flgsol,null,0,reg.flgsol) ,
          DECODE(reg.FLGREQ,'1', sysdate, null) ,
          ll_codeta,
          to_number(reg.CODALMACEN),
          to_number(reg.FLG_VENTAS),
          to_number(reg.CODALMOF),
          reg.fecfins,
          reg.CODUSUDIS,
          reg.CENTROSAP,
          reg.ALMACENSAP,
          to_number(reg.canliq),
          l_costo);
    --INI 15.0
    EXCEPTION
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20500,sqlerrm);
    End;
    --FIN 15.0
  END IF;
end loop;

end;

procedure p_insert_list_excl_est(
an_ORDEN         in  OPERACION.CARG_EXCEL_EST_TMP.ORDEN%type,
an_PUNTO         in OPERACION.CARG_EXCEL_EST_TMP.punto%type,
an_CODETA        in  OPERACION.CARG_EXCEL_EST_TMP.CODETA%type,
an_COD_SAP       in OPERACION.CARG_EXCEL_EST_TMP.COD_SAP%type,
an_CODTIPEQU     in  OPERACION.CARG_EXCEL_EST_TMP.CODTIPEQU%type,
an_TIPPRP        in  OPERACION.CARG_EXCEL_EST_TMP.TIPPRP%type,
an_OBSERVCION    in  OPERACION.CARG_EXCEL_EST_TMP.OBSERVCION%type,
an_COSTEAR       in  OPERACION.CARG_EXCEL_EST_TMP.COSTEAR%type,
an_CANTIDAD      in  OPERACION.CARG_EXCEL_EST_TMP.CANTIDAD%type,
an_CODEQUCOM     in  OPERACION.CARG_EXCEL_EST_TMP.CODEQUCOM%type,
an_PROPIETARIO   in OPERACION.CARG_EXCEL_EST_TMP.PROPIETARIO%type,
an_numreg in number,
an_codef  in number,
an_cod_rubro  in number,
an_proy_control in number,
an_resp   out number  )  is

ln_punto CARG_EXCEL_EST_TMP.punto%type;

begin
   an_resp := 0;
   BEGIN
      insert into  OPERACION.CARG_EXCEL_EST_TMP
         (PUNTO,
          CODETA,
          ORDEN,
          CODTIPEQU,
          TIPPRP,
          OBSERVCION,
          COSTEAR,
          CANTIDAD,
          CODEQUCOM,
          COD_SAP,
          PROPIETARIO,
          nro_filas,
          codef,
          cod_rubro,
          ID_PROY_CONTROL)
          values
         (an_PUNTO  ,
          an_CODETA ,
          an_ORDEN ,
          an_CODTIPEQU ,
          an_TIPPRP ,
          an_OBSERVCION ,
          an_COSTEAR ,
          an_CANTIDAD ,
          an_CODEQUCOM ,
          an_COD_SAP ,
          an_PROPIETARIO,
          an_numreg,
          an_codef,
          an_cod_rubro,
          an_proy_control);
    EXCEPTION
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20500,sqlerrm);
    END;
    BEGIN
      p_validar_excl_carga_mas_esfc(
        an_ORDEN,
       an_PUNTO,
        an_CODETA,
        an_CODTIPEQU,
        an_CANTIDAD,
        an_OBSERVCION,
        an_tipprp,
        an_costear,
        an_propietario,
        an_resp );
    EXCEPTION
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20500,'' || sqlerrm);
    END;
End;

procedure p_validar_excl_carga_mas_esfc(
  an_ORDEN        in  operacion.CARG_EXCEL_EST_TMP.ORDEN%type,
  an_PUNTO        in  operacion.CARG_EXCEL_EST_TMP.punto%type,
  an_CODETA       in  operacion.CARG_EXCEL_EST_TMP.CODETA%type,
  an_CODTIPEQU    in  operacion.CARG_EXCEL_EST_TMP.CODTIPEQU%type,
  an_CANTIDAD     in  operacion.CARG_EXCEL_EST_TMP.CANTIDAD%type,
  an_OBSERVACION  in  operacion.CARG_EXCEL_EST_TMP.OBSERVCION%type,
  an_TIPPRP       in  operacion.CARG_EXCEL_EST_TMP.TIPPRP%type,
  an_COSTEAR      in  operacion.CARG_EXCEL_EST_TMP.COSTEAR%type,
  an_PROPIETARIO  in  operacion.CARG_EXCEL_EST_TMP.PROPIETARIO%type,
  a_error out number)  is

  ln_codtipequ         number;
  ln_punto             operacion.CARG_EXCEL_EST_TMP.punto%type;
  an_resp              number;
  ln_log               number;
  ln_punto_b           operacion.CARG_EXCEL_EST_TMP.punto%type;
  ll_punto_b           number;
  ln_codeta            operacion.CARG_EXCEL_EST_TMP.CODETA%type;
  ll_codeta            number;
  ll_codet             number;
  ln_codequcom         number;
  ln_tippr             operacion.CARG_EXCEL_EST_TMP.PROPIETARIO%type;
  ll_tippr             number;
  ll_codtipequ         number;
  l_tipequ             TIPEQU.tipequ%type;
  l_TIPPRP             number;
  l_cantidad           solotptoequ.cantidad%type;
  l_costear            number;
  il_controlado        number;
  l_decimal            number;
  begin
  a_error := 0;


  for reg in (select c.*
              from OPERACION.CARG_EXCEL_EST_TMP  c
              where
                c.punto=an_PUNTO  or c.punto is null  and
                c.codeta=an_CODETA  or c.codeta is null      and
                c.codtipequ=an_CODTIPEQU or c.codtipequ is null    and
                c.cantidad=an_CANTIDAD or c.cantidad is null       and
                c.OBSERVCION=an_OBSERVACION or c.OBSERVCION is null      and
                c.tipprp=an_tipprp  or  c.tipprp is null   and
                c.costear=an_costear  or  c.costear is null   and
                c.propietario=an_propietario or c.propietario is null)

  loop
    --INI 15.0
    --Valida campos nulos
    if reg.punto is null then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Punto','EF:' || reg.codef || ',Debe ingresar el punto, Nro Fila->' || reg.nro_filas);
    end if;

    if reg.codeta is null  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Etapa','EF:' || reg.codef || ',Ingrese la descripción de la Etapa, Nro Fila->' || reg.nro_filas);
    end if;

    if reg.cantidad is null  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Cantidad','EF:' || reg.codef || ',Ingrese cantidad, Nro Fila->' || reg.nro_filas);
    end if;

    if reg.cantidad = '0'  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Cantidad','EF:' || reg.codef || '. La cantidad no puede ser cero, Nro Fila->' || reg.nro_filas);
    end if;

    IF instr(reg.cantidad,',') > 0 THEN
       insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
       values (reg.nro_filas,'Cantidad','EF:' || reg.codef || '. La cantidad debe ser numerico (' || reg.cantidad ||'), Nro Fila->' || reg.nro_filas);
    ELSE
       IF instr(reg.cantidad,'.') > 0 THEN
          l_decimal := Length(Substr(reg.cantidad,instr(reg.cantidad,'.') + 1));
          IF l_decimal > 2 THEN
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'Cantidad','EF:' || reg.codef || '. La cantidad decimales permitidos es de 2 digitos, Nro Fila->' || reg.nro_filas);
          ELSE
            BEGIN
                  l_cantidad := to_number(reg.cantidad,'99999999.99');
             EXCEPTION
             WHEN OTHERS THEN
                  insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                  values (reg.nro_filas,'Cantidad','EF:' || reg.codef || '. La cantidad debe ser numerico, Nro Fila->' || reg.nro_filas);
             END;
          END IF;
       ELSE
           BEGIN
                l_cantidad := to_number(reg.cantidad,'99999999.99');
           EXCEPTION
           WHEN OTHERS THEN
                insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                values (reg.nro_filas,'Cantidad','EF:' || reg.codef || '. La cantidad debe ser numerico, Nro Fila->' || reg.nro_filas);
           END;
       END IF;
    END IF;

    if reg.costear is null  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Costear','EF:' || reg.codef || '. Ingrese Costear, Nro Fila->' || reg.nro_filas);
    else
         BEGIN
              l_cantidad := to_number(reg.costear);
              IF l_cantidad not in (0,1) THEN
                  insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                  values (reg.nro_filas,'Costear','EF:' || reg.codef || '. Costear debe ser 0 o 1, Nro Fila->' || reg.nro_filas);
              END IF;
          EXCEPTION
          WHEN OTHERS THEN
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Costear','EF:' || reg.codef || '. Costear debe ser numerico, Nro Fila->' || reg.nro_filas);
          end;
    END IF;
    if reg.OBSERVCION is null  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Observacion','EF:' || reg.codef || '. Ingrese observacion, Nro Fila->' || reg.nro_filas);
    end if;

    if reg.propietario is null  then
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Propiedad','EF:' || reg.codef || '. Ingrese Tipo Propiedad, Nro Fila->' || reg.nro_filas);
    end if;
    -- Valida campo Punto si existe en la tabla OPERACION.efpto
    ln_punto_b := reg.punto;
    if reg.punto is not null then
       SELECT count(*)
       into ll_punto_b
       FROM OPERACION.efpto
       WHERE efpto.codef = reg.codef
         and to_char(efpto.punto) || ' - ' || efpto.descripcion = trim(ln_punto_b);

      if ll_punto_b = 0 then
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'Punto','EF:' || reg.codef || '. Punto:' || trim(ln_punto_b) || ' no existe para el Estudio de Factibilidad, Nro Fila->' || reg.nro_filas);
      else
          if ll_punto_b > 1 then
             insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
             values (reg.nro_filas,'Punto','EF:' || reg.codef || '. La descripción : ' || trim(ln_punto_b) || ' se encuentra en mas de Punto en el Estudio de Factibilidad, Nro Fila->' || reg.nro_filas);
          end if;
      end if;
    END IF;
    -- Validar codeta existe en base de datos
    ln_codeta:=reg.codeta;

    if ln_codeta is not null then
        select count(*)
        into ll_codet
        from etapa
        where etapa.descripcion = trim(ln_codeta);

        IF ll_codet = 0 THEN
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Etapa','EF:' || reg.codef || '. La Descripcion de la etapa:' ||  trim(ln_codeta) || ', no existe en la Base de Datos del SGA, Nro Fila->' || reg.nro_filas);
        ELSE
           select count(*)
           into ll_codeta
           from etapa, etapaxarea, usuarioxareaope
           where etapa.codeta = etapaxarea.codeta
             and etapaxarea.area = usuarioxareaope.area
             and etapa.estado = 1
             and usuarioxareaope.usuario = user
             and etapaxarea.esnormal = 1
             and etapa.descripcion = trim(ln_codeta);

           IF ll_codeta > 0 THEN
              select etapa.codeta
              into ll_codet
              from etapa
              where etapa.descripcion = trim(ln_codeta);
           ELSE
              IF ll_codeta = 0 THEN
                 insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                 values (reg.nro_filas,'Etapa','EF:' || reg.codef || '. Etapa ' || ln_codeta || ' no esta parametrizada para el usuario:' || user || ', Nro Fila->' || reg.nro_filas);
              END IF;
           END IF;
        END IF;
    End If ;
     --- Validacion de EF codtipequ Validar que el codigo tipo equipo es valido
    IF reg.codtipequ is null and reg.cod_sap is null THEN
      insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
      values (reg.nro_filas,'Cod.SGA/Cod.Sap','EF:' || reg.codef || '. Tiene que ingresar cod.SGA o cod_sap, Nro Fila->' || reg.nro_filas);
    END IF;

    IF reg.CODTIPEQU IS NOT NULL THEN
      BEGIN
        select t.tipequ
        into l_tipequ
        from TIPEQU t
        where trim(codtipequ) = trim(reg.CODTIPEQU) and
              rownum = 1;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Cod.SGA','EF:' || reg.codef || '. No existe Cod.SGA('|| reg.CODTIPEQU || ') en la Base de Datos, Nro Fila->' || reg.nro_filas);
      WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500, 'Error Cod.SGA(' || trim(reg.CODTIPEQU) || ')' || chr(13) || sqlerrm);
      END;
    END IF;

    PQ_Z_PS_VALIDACIONES.P_CONTROLADO(reg.cod_rubro, il_controlado);

  IF trim(ln_codeta) is not null THEN
    BEGIN
       select e.codeta
         into ll_codet
         from etapa e
        where trim(e.descripcion) = trim(ln_codeta);
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500,sqlerrm);
    END;
    --15.0
    if il_controlado = 1 then
        IF reg.codtipequ is not null THEN
          select count(*)
            into ll_codtipequ
            from tipequ,
                 almtabmat,
                 financial.z_ps_rubro_etapa_comp,
                 z_ps_val_busqueda_det
           where (almtabmat.codmat(+) = tipequ.codtipequ)
             and (z_ps_val_busqueda_det.valor(+) = nvl(almtabmat.componente, '@'))
             and (z_ps_val_busqueda_det.codigo(+) = 'TIPO_COMP')
             and (tipequ.estequ = 1)
             and (almtabmat.componente = financial.z_ps_rubro_etapa_comp.componente)
             and (financial.z_ps_rubro_etapa_comp.codeta = ll_codet)
             and (financial.z_ps_rubro_etapa_comp.rubro = reg.cod_rubro)
             and trim(tipequ.codtipequ) = trim(reg.codtipequ);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.SGA','EF:' || reg.codef || '. Codigo SGA ' || reg.codtipequ || ' no corresponde al Punto y Etapa, Nro Fila->' || reg.nro_filas); -- 15.0
          end if ;
        ELSE
           select count(*)
           into ll_codtipequ
           from tipequ,
                 almtabmat,
                 financial.z_ps_rubro_etapa_comp,
                 z_ps_val_busqueda_det
           where (almtabmat.codmat(+) = tipequ.codtipequ)
             and (z_ps_val_busqueda_det.valor(+) = nvl(almtabmat.componente, '@'))
             and (z_ps_val_busqueda_det.codigo(+) = 'TIPO_COMP')
             and (tipequ.estequ = 1)
             and (almtabmat.componente = financial.z_ps_rubro_etapa_comp.componente)
             and (financial.z_ps_rubro_etapa_comp.codeta = ll_codet)
             and (financial.z_ps_rubro_etapa_comp.rubro = reg.cod_rubro)
             and trim(almtabmat.cod_sap) = trim(reg.cod_sap);

           if ll_codtipequ = 0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.Sap','EF:' || reg.codef || '. El Codigo SAP ' || reg.cod_sap || ' no corresponde al Punto y Etapa, Nro Fila->' || reg.nro_filas ); -- 15.0
           end if ;
        END IF;
    ELSE
         IF reg.codtipequ is not null THEN
          select count(*)
            into ll_codtipequ
            from tipequ
           where trim(tipequ.codtipequ) = trim(reg.codtipequ);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.SGA','EF:' || reg.codef || '. El codigo SGA ' || reg.codtipequ || ' no existe en la Base de Datos del SGA,  Nro Fila->' || reg.nro_filas); --15.0
          else
              IF ll_codtipequ > 1 THEN
                 insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                 values (reg.nro_filas,'Cod.SGA','EF:' || reg.codef || '. El codigo SGA :' || reg.codtipequ || ' tiene mas de 1 registro equivalente en TIPEQU en el SGA,  Nro Fila->' || reg.nro_filas); -- 15.0
              END IF;
         end if ;
        ELSE
          select count(*)
            into ll_codtipequ
            from tipequ,
                 almtabmat
           where (almtabmat.codmat(+) = tipequ.codtipequ)
            and trim(almtabmat.cod_sap) = trim(reg.cod_sap);

          if ll_codtipequ=0 then
              insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
              values (reg.nro_filas,'Cod.Sap','EF:' || reg.codef || '. El codigo SAP ' || reg.cod_sap || ' no existe en la Base de Datos SAP,  Nro Fila->' || reg.nro_filas); -- 15.0
          else
             IF ll_codtipequ > 1 THEN
                insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
                values (reg.nro_filas,'Cod.Sap','EF:' || reg.codef || '. El codigo sap :' || reg.cod_sap || ' tiene mas de un codigo de equipo,  Nro Fila->' || reg.nro_filas); -- 15.0
             END IF;
          end if ;
        END IF;
    END IF;
  END IF;

    IF reg.CODTIPEQU IS NULL and reg.cod_sap is NOT null THEN
      BEGIN
        select trim(a.codmat)
        into reg.CODTIPEQU
        from almtabmat a
        where trim(a.cod_sap) = trim(reg.cod_sap) and
              rownum = 1;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
           values (reg.nro_filas,'Cod.Sap','EF:' || reg.codef || '. No existe Codigo SAP (' || reg.cod_sap || ') en la Base de Datos SGA, Nro Fila->' || reg.nro_filas);
      WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500, 'Error Codtipequ (' || trim(reg.CODTIPEQU) || ')' || chr(13) || sqlerrm);
      END;
    END IF;

    -- Validar Propietario existe en base de datos

    ln_tippr:=reg.propietario;

    IF trim(ln_tippr) is not null THEN
        SELECT count(*)
          into ll_tippr
          FROM TIPPROPIEDAD a
         WHERE a.ESTADO = 1
           and a.DESCRIPCION = trim(ln_tippr);

        if ll_tippr=0 then
          insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
          values (reg.nro_filas,'Propietario','EF:' || reg.codef || '. Tipo Propiedad: ' || trim(ln_tippr) || ' no existe en base de datos, Nro Fila->' || reg.nro_filas);
        end if ;
    END IF;
    IF reg.codequcom is not null THEN
      select count(v.codequcom)
      into ln_codequcom
      from VTAEQUCOM  v
      where trim(v.dscequ) = trim(reg.codequcom);
      IF ln_codequcom = 0 THEN
        insert into OPERACION.CARGAR_EXCEL_LOG (linea,CAMPO,observacion)
        values (reg.nro_filas,'Equ.Com','EF:' || reg.codef || '. El codequcom:' || reg.codequcom || ' no exisste en la base de Datos del SGA, Nro Fila->' || reg.nro_filas);
      END IF;
    END IF;
  end loop;
  --FIN 15.0
end ;

procedure p_insertar_efptoequ is

  I_VERY           INTEGER;
  ll_punto         number;
  ln_punto         operacion.CARG_EXCEL_EST_TMP.punto%type;
  ln_punto_a       CARG_EXCEL_EST_TMP.punto%type;
  ll_punto_b       number;
  ln_codeta        CARG_EXCEL_EST_TMP.CODETA%type;
  ll_codeta        number;
  ln_tippr         CARG_EXCEL_EST_TMP.PROPIETARIO%type;
  ll_tippr         number;
  ln_codequcom     VTAEQUCOM.codequcom%type;
  l_tipequ         TIPEQU.tipequ%type;
  l_costo          TIPEQU.costo%type;
  l_descripcion    TIPEQU.descripcion%Type;
  l_cantidad       efptoequ.cantidad%type;
begin

for reg in (select a.* from OPERACION.CARG_EXCEL_EST_TMP a)
loop
    --INI 15.0
    ln_punto_a:=reg.punto;
    BEGIN
        SELECT efpto.punto
        into ll_punto_b
        FROM OPERACION.efpto
        WHERE efpto.codef = reg.codef and
              to_char(efpto.punto) || ' - ' || efpto.descripcion = trim(ln_punto_a);
    EXCEPTION
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20500,sqlerrm);
    END;
    ln_tippr:=reg.propietario;
    IF ln_tippr is not null THEN
       BEGIN
          select a.tipprp
            into ll_tippr
            from tippropiedad a
           where a.estado = 1
             and a.descripcion = trim(ln_tippr);
       EXCEPTION
       WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20500,sqlerrm);
       END;
    END IF;

    SELECT count(*)
    INTO I_VERY
    FROM operacion.EFPTOEQU
    WHERE operacion.EFPTOEQU.codef= REG.codef AND
          operacion.EFPTOEQU.PUNTO =ll_punto_b AND
          operacion.EFPTOEQU.ORDEN = to_number(REG.ORDEN);

    IF reg.codequcom is not null THEN
       BEGIN
          select v.codequcom
          into ln_codequcom
          from VTAEQUCOM  v
          where trim(v.dscequ) = trim(reg.codequcom) and
                rownum = 1;
       EXCEPTION
       WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20500,'Equ.Com:' || trim(reg.codequcom) || chr(13) || sqlerrm);
       END;
    ELSE
       ln_codequcom := null;
    END IF;

    IF reg.cod_sap is not null and  reg.CODTIPEQU is null THEN
      BEGIN
        select trim(a.codmat)
        into reg.CODTIPEQU
        from almtabmat a
        where trim(a.cod_sap) = trim(reg.cod_sap) and
              rownum = 1; -- Validar con el usuario.
      EXCEPTION
      WHEN OTHERS THEN
           reg.CODTIPEQU := null;
      END;
    END IF;

    IF reg.CODTIPEQU IS NOT NULL THEN
      BEGIN
        select t.tipequ, t.costo, t.descripcion
        into l_tipequ, l_costo, l_descripcion
        from TIPEQU t
        where trim(codtipequ) = trim(reg.CODTIPEQU) and
              rownum = 1;
      EXCEPTION
      WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500, 'Error Cod.SGA (' || trim(reg.CODTIPEQU) || ')' || chr(13) || sqlerrm);
      END;
    END IF;

    ln_codeta:=reg.codeta;
    if ln_codeta is not null then
       BEGIN
          select distinct etapa.codeta
          into ll_codeta
          from etapa
          where etapa.descripcion = ln_codeta;
       EXCEPTION
       WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20500,sqlerrm);
       END;
    end if ;

    BEGIN
        l_cantidad := to_number(reg.cantidad,'99999.9999');
    EXCEPTION
    WHEN OTHERS THEN
        l_cantidad := 0;
    END;
    IF I_VERY = 1 THEN
       BEGIN
           -- Actualizar.
           update operacion.efptoequ
             set codtipequ   = trim(reg.codtipequ),
                 observacion = trim(reg.observcion),
                 costear     = decode(reg.costear, null, 0, to_number(reg.costear)),
                 cantidad    = decode(reg.cantidad, null, 1, l_cantidad),
                 codequcom   = ln_codequcom,
                 costo       = l_costo
           where operacion.efptoequ.codef = reg.codef
             and operacion.efptoequ.punto = ll_punto_b
             and operacion.efptoequ.orden = to_number(reg.orden);
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500, sqlerrm);
      END;
    ELSE
      BEGIN
          -- INSERTAR
         insert into EFPTOEQU
           (CODEF,
            PUNTO,
            ORDEN,
            CODTIPEQU,
            TIPPRP,
            OBSERVACION,
            COSTEAR,
            CANTIDAD,
            CODEQUCOM,
            CODETA,
            tipequ,
            costo)
         values
           (reg.codef,
            ll_punto_b,
            (select nvl(max(orden), 0) + 1
               from operacion.EFPTOEQU
              where codef = reg.codef),
            trim(reg.codtipequ),
            ll_tippr,
            reg.observcion,
            decode(TO_NUMBER(reg.costear), null, 0, TO_NUMBER(reg.costear)),
            decode(reg.cantidad, null, 1, l_cantidad),
            ln_codequcom,
            decode(ll_codeta, null, 0, ll_codeta),
            l_tipequ,
            l_costo);
      EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20500, sqlerrm);
      END;
  END IF;
  end loop;
end;
--Fin 16.0

--Inicio 17.0
PROCEDURE p_cargar_act_formula_eta(a_codsolot solot.codsolot%type , a_codact actividad.codact%type, a_idetapa in number,a_codcon in number,a_cantidad in number, a_estado out varchar2,a_obs out varchar2) IS
l_punto      number;
l_punto_ori  number;
l_punto_des  number;
l_codeta     number;
l_codcon     number;
l_orden      number;
l_cont_etapa number;
l_agenda     number;
l_costo      number(10,2);
l_moneda     number;
l_codpred    number;
ll_contador  number;

BEGIN

  select b.costo,b.moneda_id,b.codprec
  into   l_costo, l_moneda, l_codpred
  from   OPERACION.actxpreciario b
  where  b.activo = '1'
  and    b.codact = a_codact;

    --Validación de la SOT
    select count(1)
    into   ll_contador
    from   operacion.solot
    where  codsolot = a_codsolot;

    if ll_contador = 0 then
      a_estado:='0';
      a_obs:='El Número de SOT no existe...';
      raise_application_error(-20001,'El Número de SOT no existe...' );
    end if;

    --Validación de la actividad
    select count(1)
    into   ll_contador
    from   operacion.actividad
    where  codact = a_codact;

    if ll_contador = 0 then
      a_estado:='0';
      a_obs:='El Código de actividad No existe...';
      raise_application_error(-20001,'El Código de actividad No existe...' );
    end if;

    --Validación de la contrata y agenda
    select count(1)
    into   ll_contador
    from   operacion.contrata
    where  codcon = a_codcon;

    if ll_contador = 0 then
      a_estado:='0';
      a_obs:='El código de Contrata No Existe.';
      raise_application_error(-20001,'El código de Contrata No Existe.' );
    end if;

    select max(idagenda)
    into   l_agenda
    from   operacion.agendamiento
    where  codsolot = a_codsolot;

    l_codcon := a_codcon;
    l_codeta := a_idetapa;

    select count(1)
    into   l_cont_etapa
    from   OPERACION.solotptoeta
    where  codsolot = a_codsolot
    and    codeta   = l_codeta
    and    codcon   = a_codcon and not esteta=5;

    if l_cont_etapa = 1 then--Existe Etapa
       select orden,punto
       into   l_orden,l_punto
       from   OPERACION.solotptoeta
       where  codsolot = a_codsolot
       and    codeta   = l_codeta
       and    codcon   = a_codcon and not esteta=5;

    else --Genera la etapa en estado 15 : Preliquidacion

      --Se identifica el punto principal
      operacion.P_GET_PUNTO_PRINC_SOLOT(a_codsolot,l_punto,l_punto_ori,l_punto_des);

      if nvl(l_punto,0) = 0 then
          a_estado:='0';
          a_obs:='No existe punto para el número de SOT.';
          raise_application_error(-20001,'No existe punto para el número de SOT.' );
      end if;

      SELECT NVL(MAX(ORDEN),0) + 1
      INTO   l_orden
      from   operacion.SOLOTPTOETA
      where  codsolot = a_codsolot
      and    punto    = l_punto;

      insert into operacion.solotptoeta(codsolot,punto,orden,codeta,porcontrata,esteta,obs,Fecdis,codcon,fecini,IDAGENDA)
      values(a_codsolot,l_punto,l_orden,l_codeta,1,15,'ACTMO',null,l_codcon,sysdate,l_agenda);
    end if;

    --Inserta la Actividad en la Etapa
    insert into operacion.solotptoetaact(codsolot,punto,orden,codact,canliq,cosliq,canins,candis,cosdis,
                               Moneda_Id,observacion,codprecdis,codprecliq,flg_preliq,contrata)
                        values(a_codsolot,l_punto,l_orden,a_codact,a_cantidad,l_costo,a_cantidad,a_cantidad,
                        l_costo,l_moneda,'ITTELMEX-ACT-HFC',l_codpred,l_codpred,1,1);

   a_estado:='1';
   a_obs:='Actualizo correctamente';

END;
--Fin 17.0
END PQ_EQU_MAT;
/
