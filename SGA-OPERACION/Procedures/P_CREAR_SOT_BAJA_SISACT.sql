CREATE OR REPLACE PROCEDURE OPERACION.P_CREAR_SOT_BAJA_SISACT(a_tiptra number,a_motot number,a_obs varchar2,
  a_feccom date, a_numeroservicio varchar2,a_tipo_servicio varchar2, a_codsolot out number, a_error out varchar2 ) IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.P_CREAR_SOT_TPI_GSM_BAJA
   PROPOSITO:    SP para generar SOT de Baja TPI
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       17/11/2014  Edilberto Astulle                  PROY-15214 IDEA-16205 Procedimiento de baja del TPI GSM
    2.0       31/03/2015  Edilberto Astulle                  SGA_SD_252818 Solicitud de Incidencia - Lentitud en la atención de bajas HFC - SISACT
	3.0       02/06/2015  Edilberto Astulle                  SD-307352 Problema con el SGA
  *******************************************************************************************************/
n_cont number default 1;
e_err exception;
cursor c_tpi is
select a.codinssrv,a.codcli,a.codsrv,a.bw,a.cid,a.descripcion,a.direccion, a.tipsrv,a.codubi
from inssrv a
where a.numero= a_numeroservicio and estinssrv in (1,2)  and a.tipsrv='0059' and rownum=1;
BEGIN
  if a_tipo_servicio='TPI' then
    a_codsolot:=0;
    for c in c_tpi loop
      a_codsolot := F_GET_CLAVE_SOLOT();
      insert into solot(codsolot, codcli, estsol, tiptra, tipsrv, grado, codmotot, areasol,observacion,feccom)
      values(a_codsolot,c.codcli,11,a_tiptra,c.tipsrv,1,a_motot,100,a_obs,a_feccom);--2.0--3.0
      insert into solotpto(codsolot,punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,
      tipo,  estado,  visible,  codubi )
      values  (a_codsolot,n_cont,c.codsrv,c.bw,c.codinssrv,c.cid,c.descripcion, c.direccion,1, 1, 1,c.codubi);
    end loop;
    if a_codsolot=0 then
      a_error:='El Numero de servicio no existe o no esta activo.';
    end if;
  else
    a_codsolot:=-1;
    a_error:='No esta espificada la baja para este tipo de Servicio';
    raise e_err;
  end if;
exception
    when others then
      a_codsolot:=-1;
      a_error:= 'Error en la generación de SOT : '||sqlerrm;
END;
/