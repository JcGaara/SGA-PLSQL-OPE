CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CUSTOPER AS
/******************************************************************************
   NAME:       PQ_CUSTOPER
   PURPOSE:    Customizaciones Peru

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/10/2006  Luis Olarte           1. Created this package.
   3.0        02/07/2013  Edilberto Astulle     PROY-9381 IDEA-11686  Seleccion Multiple
   4.0        12/08/2013  Edilberto Astulle     PQT-166197-TSK-34400
******************************************************************************/




/******************************************************************************
Canela parcialmente los servicios en la tabla INSSRV para traslados de telefonia
*******************************************************************************/

  PROCEDURE p_cancservtrastel( a_idtareawf in number,
                                                        a_idwf in number,
                                                          a_tarea in number,
                                                          a_tareadef in number
                                                        )
  IS
  l_codsolot solot.codsolot%type;
  l_cont number;

  BEGIN

         select codsolot into l_codsolot from wf where idwf = a_idwf;

       select count(*)
       into l_cont
       from
       solotpto
       where
       codinssrv_tra is not null and
       codsolot = l_codsolot;

       if l_cont >= 1 then
       begin
         update inssrv set estinssrv = 3, descripcion = descripcion||'-'||numero/*, numero= null*/ where codinssrv in (
         select codinssrv_tra from solotpto where codsolot= l_codsolot);
       end;
       end if;

       commit;
  END;
/******************************************************************************
Actviva los servicios en la tabla INSSRV para traslados de telefonia, cancelados
parcialmente
*******************************************************************************/

  PROCEDURE p_actiservtrastel( a_idtareawf in number,
                                                      a_idwf in number,
                                                        a_tarea in number,
                                                        a_tareadef in number
                                                        )
  IS
  l_codsolot solot.codsolot%type;
  l_cont number;

  BEGIN

         select codsolot into l_codsolot from wf where idwf = a_idwf;

       select count(*)
       into l_cont
       from
       solotpto
       where
       codinssrv_tra is not null and
       codsolot = l_codsolot;

       if l_cont >= 1 then
       begin
         update inssrv set estinssrv = 1 where codinssrv in (
         select codinssrv_tra from solotpto where codsolot= l_codsolot);
       end;
       end if;

       commit;
  END;

  /******************************************************************************
Actviva los cid de la tabla acceso
*******************************************************************************/

  PROCEDURE p_verificacid
  IS

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CUSTOPER.P_VERIFICACID';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='285';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------

    cursor cur_pro is
  select a.cid,a.codprd,c.ide,pc.descripcion,p.codprd codprdpro
from acceso a, cidxide c, puertoxequipo p, productocorp pc
where a.cid = c.cid and
c.ide = p.ide and
p.codprd = pc.codprd and
pc.linea <> RTRIM('Productos Internos') and
a.codprd is null;

  BEGIN

  for r_pro in cur_pro loop
               begin
               update acceso set codprd = r_pro.codprdpro where acceso.cid =r_pro.cid;

               end;
               end loop;

  update acceso set estado = 1 where cid in (
select distinct a.cid---,a.estado,p.estado
from puertoxequipo p, acceso a, cidxide c
where
p.estado = 1 and
p.ide = c.ide and
a.cid = c.cid and
a.estado <> p.estado);

       commit;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/


  END;

  /******************************************************************************
Actviva los cid de la tabla acceso
*******************************************************************************/

PROCEDURE p_transfiereproyectosap(n_numslc number)
IS
v_numslc vtatabslcfac.numslc%type;
cursor cur_sots is
select s.codsolot
from solot s
where s.numslc = v_numslc;

v_pidp number;
v_pids number;
v_cont number;
v_contcont number;
v_contpep number;
v_fecfirmacontrato date;

BEGIN
v_cont := 0;

v_numslc := lpad(n_numslc,10,'0');

select nvl(count(*),0) into v_cont
from z_ps_proyectos where numslc = v_numslc;

if  v_cont = 0 then
    begin
          update vtatabslcfac set pcflg_transferencia = 0 where numslc = v_numslc;

          select count(*) into v_contcont
          from CONTRATO where numpsp in (select numpsp from VTATABPSPCLI where numslc = v_numslc);
          if v_contcont = 0 then
             v_fecfirmacontrato := trunc(sysdate);
          elsif v_contcont <> 0 then
            select trunc(max(C.Fec_Firmacontrato))
            into v_fecfirmacontrato
            from VTATABPSPCLI VP, CONTRATO C
            where VP.Numslc = v_numslc and
                VP.NUMPSP = C.NUMPSP;
          end if;
          financial.PQ_Z_PS_PROYECTOSSAP.p_screa_def_proy(v_numslc,'PER',v_fecfirmacontrato, v_pidp);
    end;
end if;

select nvl(count(*),0) into v_contpep
from z_ps_elementospep where codsolot in (
select codsolot from solot where numslc = v_numslc);

if (v_cont > 0)  then
begin
update vtatabslcfac set pcflg_transferencia = 1 where numslc = v_numslc;
end;
end if;

/*if (v_cont > 0) and (v_contpep > 0)  then
  begin
       raise_application_error(-20500,'Proyecto EXISTE en SAP, favor contactarse a Elliot Ochoa');
  end;
else
      begin  */
          for r_sots in cur_sots loop
                       begin
                       financial.PQ_Z_PS_PROYECTOSSAP.p_screa_def_pep_ef(v_numslc,r_sots.codsolot,'PER', v_pids);
                       end;
          end loop;
          commit;

/*    end;
end if;*/
--raise_application_error(-20500,'Se transfirio el proyecto con exito');
END;

/*Tranferencia a SAP con el Nro de Proyecto y el Codigo de la SOT*/

PROCEDURE p_transfieresotproyecto_sap(v_numslc varchar, v_codsolot varchar)
IS
pid number;
numslc varchar2(10);
BEGIN
    numslc := lpad(v_numslc,10,'0');
    financial.PQ_Z_PS_PROYECTOSSAP.p_screa_def_pep_ef( numslc ,to_number(v_codsolot) ,'PER', pid);

END;



--Inicio 3.0
procedure p_asocia_sot_pto(an_codsolot solot.codsolot%type,
an_codinssrv inssrv.codinssrv%type, an_cid acceso.cid%type,
  an_pid insprd.pid%type, an_tipo number) is

r_det inssrv%rowtype;
r_solotpto solotpto%rowtype;
vc_codcli varchar2(10);
ln_punto  number;
ln_estsol number;--4.0
cursor c_sid is --SIDs
    SELECT INSSRV.CODINSSRV,
    INSSRV.CODSRV,
    INSSRV.DESCRIPCION,
    INSSRV.DIRECCION,
    INSSRV.CID,
    INSSRV.CODUBI,   inssrv.pop, inssrv.bw,
    INSSRV.CODPOSTAL
    FROM INSSRV
    WHERE INSSRV.CODINSSRV = an_codinssrv;
cursor c_cid is --CIDs
  SELECT ACCESO.CID,
         ACCESO.ESTADO,  acceso.bw,
         ACCESO.DESCRIPCION,
         ACCESO.DIRECCION,
         ACCESO.CODCLI,
         ACCESO.CODINSSRV,
         ACCESO.CODUBI,
         EQUIPORED.CODUBIRED
    FROM ACCESO,
         PUERTOXEQUIPO,
         EQUIPORED
   WHERE acceso.cid = puertoxequipo.cid (+)  and
        puertoxequipo.codequipo = equipored.codequipo (+)  and
        acceso.CID = an_cid;
cursor c_pid is --PIDs
SELECT INSPRD.PID ,  inssrv.codinssrv sid, inssrv.cid cid,
  INSPRD.ESTINSPRD,
  INSPRD.CODSRV,   inssrv.descripcion,
  inssrv.numero, inssrv.direccion, inssrv.codubi,inssrv.codpostal,
  INSPRD.CODEQUCOM,
  INSPRD.CANTIDAD,
  INSPRD.FLGPRINC ,   inssrv.pop,
  INSPRD.CODINSSRV  , tystabsrv.banwid
FROM   INSPRD,   INSSRV  , tystabsrv
WHERE  insprd.codsrv = tystabsrv.codsrv (+) and
INSPRD.CODINSSRv=INSSRV.CODINSSRV AND insprd.pid=an_pid;

begin
  --Inicio 4.0
  select estsol into ln_estsol from solot where codsolot=an_codsolot;
  if ln_estsol not in(10,11) then
    raise_application_error(-20001,'No esta permitido ingresar Puntos en el estado de la SOT.');
  end if;
  --Fin 4.0
  if an_tipo=1 then--SID
    for r_s in c_sid  loop
       select F_GET_CLAVE_SOLOTPTO(an_codsolot) into ln_punto from dual;
       INSERT INTO SOLOTPTO ( CODSOLOT, PUNTO, CODSRVNUE, BWNUE, CODINSSRV,
       CID, DESCRIPCION, DIRECCION,  CODUBI, CODPOSTAL,tipo,estado,visible )--4.0
       VALUES ( an_codsolot, ln_punto, r_s.Codsrv, r_s.bw, r_s.codinssrv, r_s.cid,
       r_s.descripcion,r_s.direccion , r_s.codubi , r_s.codpostal ,2,1,1);--4.0
       P_ASIGNAR_CID_A_CODINSSRV(r_s.cid,r_s.codinssrv);
    end loop;
  end if;
  if an_tipo=2 then--CID
    for r_c in c_cid  loop
       select F_GET_CLAVE_SOLOTPTO(an_codsolot) into ln_punto from dual;
       INSERT INTO SOLOTPTO ( CODSOLOT, PUNTO, CODSRVNUE, BWNUE, CODINSSRV,
       CID, DESCRIPCION, DIRECCION,  CODUBI,tipo,estado,visible )--4.0
       VALUES ( an_codsolot, ln_punto, null, r_c.bw, r_c.codinssrv, r_c.cid,
       r_c.descripcion,r_c.direccion , r_c.codubi  ,3,1,1);--4.0
       P_ASIGNAR_CID_A_CODINSSRV(r_c.cid,r_c.codinssrv);
    end loop;
  end if;
  if an_tipo=3 then--PID
    for r_p in c_pid  loop
       select F_GET_CLAVE_SOLOTPTO(an_codsolot) into ln_punto from dual;
       INSERT INTO SOLOTPTO ( CODSOLOT, PUNTO, CODSRVNUE, BWNUE, CODINSSRV,
       CID, DESCRIPCION, DIRECCION,  CODUBI, pop ,tipo,estado,visible,pid )--4.0
       VALUES ( an_codsolot, ln_punto, r_p.codsrv , r_p.banwid, r_p.codinssrv, r_p.cid,
       r_p.descripcion,r_p.direccion , r_p.codubi ,null ,6,1,1, r_p.pid);--4.0
       P_ASIGNAR_CID_A_CODINSSRV(r_p.cid,r_p.codinssrv);
    end loop;
  end if;end;
--fin 3.0

END PQ_CUSTOPER;
/
