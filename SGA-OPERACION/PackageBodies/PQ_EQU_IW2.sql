CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_EQU_IW2 IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_EQU_IW2
   PROPOSITO:    Paquete de objetos necesarios para la regularizacion de equipos - contratos  BSCS-SGA
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       12/07/2015  Edilberto Astulle SD-335259 - Paquete creado para regularizacion de contratos generados por contingencia.
    2.0       22/10/2019  Edilberto Astulle Descarga Materiales
    3.0       27/11/2019  Edilberto Astulle Descarga Materiales
  *******************************************************************************************************/

procedure p_carga_equ_iw(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number) is
n_err number;
n_id number;
v_err varchar2(300);
n_codsolot number;
v_nroserie varchar2(300);
n_cont_equ number;
v_obs varchar2(300);
n_costo tipequ.costo%type;
n_punto number;
n_punto_ori number;
n_punto_des number;
n_orden number;
n_tipequ number;
n_idagenda number;
n_val_ser_equ number;
n_val_serxmac number;
n_error number;
v_error varchar2(400);

cursor c_mta is
select replace(upper(mac_address),':','') mac_address,SERIAL_NUMBER from OPERACION.TAB_EQUIPOS_IW2 where id_ticket=n_id
and tipo_servicio ='INT' and codsolot=n_codsolot
union
select unit_address,serial_number from OPERACION.TAB_EQUIPOS_IW2 where id_ticket=n_id
and tipo_servicio ='CTV' and codsolot=n_codsolot;
cursor c_sot is
select codsolot from solot where codsolot=n_codsolot;

begin
  select codsolot into n_codsolot from wf where idwf=a_idwf;

  for s in c_sot loop
    n_codsolot :=s.codsolot;
    v_obs:='Carga Equipos desde IW.';
    operacion.pq_cont_regularizacion.P_CONSULTA_IW(n_codsolot,1,n_id,n_err,v_err);--1 customer_id
    commit;
    for c in c_mta loop
      operacion.P_GET_PUNTO_PRINC_SOLOT(n_codsolot,n_punto,n_punto_ori,n_punto_des);
      begin
        select IDAGENDA into n_idagenda from AGENDAMIENTO A, OPEDD B, TIPOPEDD C
        WHERE A.codsolot= n_codsolot AND A.tipo= B.codigoc AND
        B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='TIPOAGENDAEQUIPOS';
      exception
        when no_data_found then
          select max(idagenda) into n_idagenda
          from agendamiento where codsolot = n_codsolot;
      end;
      SELECT NVL(MAX(ORDEN), 0) + 1  INTO n_orden
      from solotptoequ
      where codsolot = n_codsolot and punto = n_punto and rownum=1;

      if c.SERIAL_NUMBER is not null then--Serie existe
        --Valida Serie de IW
        select count(1) into n_val_ser_equ from maestro_series_equ
        where nroserie=c.SERIAL_NUMBER;
        select count(1) into n_cont_equ--Validar si el equipo esta registrado en la SOT
        from solotptoequ a
        where trim(a.numserie) =  c.SERIAL_NUMBER and a.codsolot=n_codsolot;
        if n_val_ser_equ=1 then--Equipo existe en la BD
          select c.tipequ,b.preprm_usd,a.nroserie into n_tipequ,n_costo,v_nroserie
          from maestro_Series_Equ a, almtabmat b, tipequ c
          where nroserie =c.SERIAL_NUMBER and a.cod_sap=trim(b.cod_sap) and b.codmat=c.codtipequ;
        elsif n_val_ser_equ=0 then--No existe la Serie en la BD
          n_tipequ:=999;
          v_obs:=v_obs ||'Equipo no se identifica en la BD.';
          v_nroserie:=c.SERIAL_NUMBER;
        end if;
      else--si serie es null buscar por MAC
        select count(1) into n_val_serxmac from maestro_series_Equ where c.mac_address in (mac1,mac2,mac3);
        if n_val_serxmac=1 then --Serie identificada por MAC
          select c1.tipequ,b1.preprm_usd,a1.nroserie into n_tipequ,n_costo,v_nroserie
          from maestro_Series_Equ a1, almtabmat b1, tipequ c1
          where a1.cod_sap=trim(b1.cod_sap) and b1.codmat=c1.codtipequ and c.mac_address in (mac1,mac2,mac3);
          select count(1) into n_cont_equ--Validar si el equipo esta registrado en la SOT
          from solotptoequ a
          where trim(a.numserie) = v_nroserie and a.codsolot=n_codsolot;

        elsif n_val_serxmac=0 then--No existe la Serie en la BD
          null;
  --        n_tipequ:=999;
  --        v_obs:=v_obs ||'Equipo no se identifica en la BD.';
  --        v_nroserie:=c.mac_address;
        end if;
      end if;
      if n_cont_equ=0 and ((n_val_ser_equ<2 and c.SERIAL_NUMBER is not null )
          or (n_val_serxmac=1 and c.SERIAL_NUMBER is null and  c.mac_address is not null)) then
        insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
        COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
        instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)
        values(n_codsolot,n_punto,n_orden,n_tipequ,1,0,nvl(n_costo,0),
        v_nroserie,1,0,647,null,v_obs,Sysdate,1,n_idagenda,sysdate,3, c.mac_address,1,0);
        commit;
      end if;
    end loop;
  end loop;

exception
  when others then
    n_error := -1;
    v_error := 'Error Carga Equipos: ' || to_char(sqlerrm);
end;


procedure p_carga_equ_iwv2(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number) is
n_err number;
n_id number;
v_err varchar2(300);
n_codsolot number;
v_nroserie varchar2(300);
n_cont_equ number;
v_obs varchar2(300);
n_costo tipequ.costo%type;
n_punto number;
n_punto_ori number;
n_punto_des number;
n_orden number;
n_tipequ number;
n_idagenda number;
n_val_ser_equ number;
n_val_serxmac number;
n_error number;
v_error varchar2(400);

cursor c_mta is
select y.serial_number,
decode(y.tipo_servicio, 'CTV', y.unit_address, y.mac_address) mac_address,
y.origen
from OPERACION.TAB_EQUIPOS_IW2 y
where y.codsolot = n_codsolot
and y.serial_number is not null
and y.origen = 0
and not exists
(select 1
from OPERACION.TAB_EQUIPOS_IW2 x
where x.codsolot = n_codsolot
and x.serial_number is not null
and x.origen = 1
and x.serial_number = y.serial_number)
union
select y.serial_number,
decode(y.tipo_servicio, 'CTV', y.unit_address, y.mac_address) mac_address,
y.origen
from OPERACION.TAB_EQUIPOS_IW2 y
where y.codsolot = n_codsolot
and y.serial_number is not null
and y.origen = 1
and not exists
(select 1
from OPERACION.TAB_EQUIPOS_IW2 x
where x.codsolot = n_codsolot
and x.serial_number is not null
and x.origen = 0
and x.serial_number = y.serial_number);
n_origen number;
n_enacta number;
cursor c_sot is
select codsolot from solot where codsolot=n_codsolot;

begin
  begin
    select B.Codigon_Aux into n_origen from OPEDD B, TIPOPEDD C
    WHERE B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='EQUDESCIWDBLINK'
    and  b.codigon=a_tarea;
  exception
    when no_data_found then
      n_origen:=0;
  end;
  select codsolot into n_codsolot from wf where idwf=a_idwf;
  p_consulta_equ_iw(n_codsolot,n_id,n_err,v_err);
  if n_origen=1 then
    update OPERACION.TAB_EQUIPOS_IW2 set origen=n_origen where ID_TICKET=n_id;
  end if;


  for s in c_sot loop
    n_codsolot :=s.codsolot;
    v_obs:='Carga Equipos desde IW_.';
    commit;
    if n_origen=0 then
      for c in c_mta loop
        operacion.P_GET_PUNTO_PRINC_SOLOT(n_codsolot,n_punto,n_punto_ori,n_punto_des);
        begin
          select IDAGENDA into n_idagenda from AGENDAMIENTO A, OPEDD B, TIPOPEDD C
          WHERE A.codsolot= n_codsolot AND A.tipo= B.codigoc AND
          B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='TIPOAGENDAEQUIPOS';
        exception
          when no_data_found then
            select max(idagenda) into n_idagenda
            from agendamiento where codsolot = n_codsolot;
        end;
        SELECT NVL(MAX(ORDEN), 0) + 1  INTO n_orden
        from solotptoequ
        where codsolot = n_codsolot and punto = n_punto and rownum=1;

        if c.SERIAL_NUMBER is not null then--Serie existe
          --Valida Serie de IW
          select count(1) into n_val_ser_equ from maestro_series_equ
          where nroserie=c.SERIAL_NUMBER;
          select count(1) into n_cont_equ--Validar si el equipo esta registrado en la SOT
          from solotptoequ a
          where trim(a.numserie) =  c.SERIAL_NUMBER and a.codsolot=n_codsolot;
          if n_val_ser_equ=1 then--Equipo existe en la BD
            select c.tipequ,b.preprm_usd,a.nroserie into n_tipequ,n_costo,v_nroserie
            from maestro_Series_Equ a, almtabmat b, tipequ c
            where nroserie =c.SERIAL_NUMBER and a.cod_sap=trim(b.cod_sap) and b.codmat=c.codtipequ;
          elsif n_val_ser_equ=0 then--No existe la Serie en la BD
            n_tipequ:=999;
            v_obs:=v_obs ||'Equipo no se identifica en la BD.';
            v_nroserie:=c.SERIAL_NUMBER;
          end if;
        else--si serie es null buscar por MAC
          select count(1) into n_val_serxmac from maestro_series_Equ where c.mac_address in (mac1,mac2,mac3);
          if n_val_serxmac=1 then --Serie identificada por MAC
            select c1.tipequ,b1.preprm_usd,a1.nroserie into n_tipequ,n_costo,v_nroserie
            from maestro_Series_Equ a1, almtabmat b1, tipequ c1
            where a1.cod_sap=trim(b1.cod_sap) and b1.codmat=c1.codtipequ and c.mac_address in (mac1,mac2,mac3);
            select count(1) into n_cont_equ--Validar si el equipo esta registrado en la SOT
            from solotptoequ a
            where trim(a.numserie) = v_nroserie and a.codsolot=n_codsolot;

          elsif n_val_serxmac=0 then--No existe la Serie en la BD
            null;
    --        n_tipequ:=999;
    --        v_obs:=v_obs ||'Equipo no se identifica en la BD.';
    --        v_nroserie:=c.mac_address;
          end if;
        end if;
        if n_cont_equ=0 and ((n_val_ser_equ<2 and c.SERIAL_NUMBER is not null )
            or (n_val_serxmac=1 and c.SERIAL_NUMBER is null and  c.mac_address is not null)) then
          begin
            select B.Codigon_Aux into n_enacta from OPEDD B, TIPOPEDD C
            WHERE B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='EQUDESCENACTA'
            and  b.codigon=a_tarea;
          exception
            when no_data_found then
              n_enacta:=0;
          end;
          if n_enacta=2 then--Si es Mantenimiento tiene que respetar el origen
            n_enacta:=c.origen;
          end if;
          insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
          COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
          instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)
          values(n_codsolot,n_punto,n_orden,n_tipequ,1,0,nvl(n_costo,0),
          v_nroserie,1,0,647,null,v_obs,Sysdate,1,n_idagenda,sysdate,3, c.mac_address,1,
          n_enacta);
          commit;
        end if;
      end loop;
      end if;
    end loop;
exception
  when others then
    n_error := -1;
    v_error := 'Error Carga Equipos: ' || to_char(sqlerrm);

end;


PROCEDURE p_consulta_equ_iw(a_codsolot in solot.codsolot%type,
                          a_seq_equ_iw out number,
                          an_error   out integer,
                          av_error   out varchar2) IS
  n_iderr            number;
  v_mens           varchar2(400);
  v_contador       number;
  v_macadd         varchar2(400);
  v_modelmta       varchar2(400);
  v_profile        varchar2(400);
  v_hub            varchar2(400);
  v_nodo           varchar2(400);
  v_activationcode varchar2(400);
  v_cantpcs        number;
  v_servpackname   varchar2(400);
  v_serial         varchar2(400);
  v_unitd          varchar2(400);
  v_equp           varchar2(400);
  l_cod_id         number(8);
  l_customer_id    number(8);
  error_iw_getreport exception;
  error_general      EXCEPTION;
  v_serialnumber varchar2(200);
  lv_null  varchar2(100);
  v_idprodpadre number;
  cur_cm SYS_REFCURSOR;
  cur_mta SYS_REFCURSOR;
  cur_tv SYS_REFCURSOR;

  --2.0
  n_val_stb number;
  V_1 NUMBER;
  V_2 NUMBER;
  V_3 VARCHAR2(40);
  V_4 VARCHAR2(40);
  V_5 VARCHAR2(40);
  V_6 VARCHAR2(40);
  V_7 NUMBER;
  V_8 VARCHAR2(40);
  V_9 VARCHAR2(40);

  BEGIN
    select OPERACION.SQ_EQU_IW.NEXTVAL into a_seq_equ_iw from dual;
    select distinct nvl(b.customer_id,to_number(b.codcli)) into l_customer_id
    from solotpto a, solot  b,inssrv c, vtatabslcfac d
    where b.codsolot=a_codsolot and a.codsolot=b.codsolot
    and a.codinssrv=c.codinssrv and c.numslc=d.numslc;

    --INT Obtenemos datos de INC
      INTRAWAY.PQ_MIGRASAC.P_TRAE_DOCSISEQUIPO(l_customer_id,n_iderr,v_mens,cur_cm);
     LOOP
      FETCH cur_cm into v_hub,v_nodo,v_macadd,v_activationcode,v_cantpcs,v_servpackname,v_serialnumber;
        EXIT WHEN cur_cm%NOTFOUND;
        if v_macadd is null then
          av_error := substr(' INT: MAC_ADDRESS nulo o vacio ' || av_error,1,200);
        else
          insert into OPERACION.TAB_EQUIPOS_IW2(ID_TICKET,codsolot,customer_id,
          cod_id,tipo_servicio,interfase,MAC_ADDRESS,PROFILE_CRM,SERIAL_NUMBER)
          values(a_seq_equ_iw,a_codsolot,l_customer_id,l_cod_id,'INT','620',
          v_macadd,v_servpackname,v_serialnumber);
        end if;
      END LOOP;
      CLOSE cur_cm;

    --TLF Obtenemos datos de INC
      INTRAWAY.PQ_MIGRASAC.P_TRAE_VOICEBEQUIPO(l_customer_id,n_iderr,v_mens,cur_mta);
      LOOP
      FETCH cur_mta into v_idprodpadre,v_macadd,v_modelmta,v_profile;
        EXIT WHEN cur_mta%NOTFOUND;
        if v_macadd is null then
          av_error := substr(' TLF: MAC_ADDRESS nulo o vacio ' || av_error,1,200);
        else
          insert into OPERACION.TAB_EQUIPOS_IW2(id_ticket,codsolot,customer_id,cod_id,
          tipo_servicio,interfase,ID_PRODUCTO,MAC_ADDRESS,MODELO,PROFILE_CRM)
          values(a_seq_equ_iw,a_codsolot,l_customer_id,l_cod_id,
          'TLF','820',v_idprodpadre,v_macadd,v_modelmta,v_profile);
        end if;
      END LOOP;
      CLOSE cur_mta;

      --2.0
      select count(1) into n_val_stb from tipopedd where abrev='INCACTCARGASTBN';
      if n_val_stb=0 then
        SELECT count(1) into v_contador
        FROM OPERACION.TRS_INTERFACE_IW iw, solot s
        WHERE iw.id_interfase in (2020)
        and s.codsolot = iw.codsolot
        and s.CODSOLOT = a_codsolot;
        if v_contador > 0 then
          declare
            cursor equipos_ctv is
              SELECT s.customer_id,iw.ID_INTERFASE,iw.TIP_INTERFASE,iw.ID_PRODUCTO
              FROM OPERACION.TRS_INTERFACE_IW iw, solot s
              WHERE iw.id_interfase in (2020)
              and s.codsolot = iw.codsolot
              and s.CODSOLOT = a_codsolot;
          begin
            for c in equipos_ctv loop
                intraway.pq_migrasac.p_trae_dtv(c.customer_id,c.id_producto,n_iderr,v_mens,cur_tv);
                loop
                  fetch cur_tv into v_unitd,v_serial,lv_null,v_hub,lv_null,lv_null,v_equp;
                  exit when cur_tv%notfound;
                  insert into OPERACION.TAB_EQUIPOS_IW2(id_ticket,codsolot,customer_id,cod_id,ID_PRODUCTO,
                  tipo_servicio,interfase,SERIAL_NUMBER,UNIT_ADDRESS,STBTYPECRMID,PROFILE_CRM)
                  values(a_seq_equ_iw,a_codsolot,c.customer_id,l_cod_id,c.id_producto,'CTV','2020',v_serial,
                  v_unitd,v_equp,v_hub);
                end loop;
            end loop;
          end;
        end if;
      else
        INTRAWAY.PQ_MIGRASAC.P_TRAE_ALLDTV (l_customer_id,n_iderr,v_mens,cur_tv);
        loop
          fetch cur_tv into V_1, V_2, V_3, V_4, V_5, V_6, V_7, V_8,V_9;
          exit when cur_tv%notfound;
          insert into OPERACION.TAB_EQUIPOS_IW2(id_ticket,codsolot,customer_id,cod_id,ID_PRODUCTO,
          tipo_servicio,interfase,SERIAL_NUMBER,UNIT_ADDRESS,STBTYPECRMID,PROFILE_CRM)
          values(a_seq_equ_iw,a_codsolot,l_customer_id,l_cod_id,0,'CTV','2020',V_4,
          '',V_6,V_5);
        end loop;
      end if;


  EXCEPTION
    WHEN OTHERS THEN
      av_error := 'Error al obtener la informacion de IW  : ' || SQLERRM;
      an_Error := sqlcode;
      a_seq_equ_iw := -1;
  END;


procedure p_carga_equ_iwv3(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number) is
n_err number;
n_id number;
v_err varchar2(300);
n_codsolot number;
v_nroserie varchar2(300);
n_cont_equ number;
v_obs varchar2(300);
n_costo tipequ.costo%type;
n_punto number;
n_punto_ori number;
n_punto_des number;
n_orden number;
n_tipequ number;
n_idagenda number;
n_val_ser_equ number;
n_val_serxmac number;
n_error number;
v_error varchar2(400);

cursor c_mta is
select y.serial_number,
decode(y.tipo_servicio, 'CTV', y.unit_address, y.mac_address) mac_address,
y.origen
from OPERACION.TAB_EQUIPOS_IW2 y
where y.codsolot = n_codsolot
and y.serial_number is not null
and y.origen = 0
and not exists
(select 1
from OPERACION.TAB_EQUIPOS_IW2 x
where x.codsolot = n_codsolot
and x.serial_number is not null
and x.origen = 1
and x.serial_number = y.serial_number)
union
select y.serial_number,
decode(y.tipo_servicio, 'CTV', y.unit_address, y.mac_address) mac_address,
y.origen
from OPERACION.TAB_EQUIPOS_IW2 y
where y.codsolot = n_codsolot
and y.serial_number is not null
and y.origen = 1
and not exists
(select 1
from OPERACION.TAB_EQUIPOS_IW2 x
where x.codsolot = n_codsolot
and x.serial_number is not null
and x.origen = 0
and x.serial_number = y.serial_number);
n_origen number;
n_enacta number;
cursor c_sot is
select codsolot from solot where codsolot=n_codsolot;

begin
  begin
    select B.Codigon_Aux into n_origen from OPEDD B, TIPOPEDD C
    WHERE B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='EQUDESCIWDBLINK'
    and  b.codigon=a_tarea;
  exception
    when no_data_found then
      n_origen:=0;
  end;
  select codsolot into n_codsolot from wf where idwf=a_idwf;
  OPERACION.PQ_EQU_IW2.p_consulta_equ_iw(n_codsolot,n_id,n_err,v_err);
  if n_origen=1 then
    update OPERACION.TAB_EQUIPOS_IW2 set origen=n_origen where ID_TICKET=n_id;
  end if;


  for s in c_sot loop
    n_codsolot :=s.codsolot;
    v_obs:='Carga Equipos desde INCOGNITO.';
    commit;
    if n_origen=0 then
      for c in c_mta loop
        if c.SERIAL_NUMBER is not null then
          operacion.P_GET_PUNTO_PRINC_SOLOT(n_codsolot,n_punto,n_punto_ori,n_punto_des);
          begin
            select IDAGENDA into n_idagenda from AGENDAMIENTO A, OPEDD B, TIPOPEDD C
            WHERE A.codsolot= n_codsolot AND A.tipo= B.codigoc AND
            B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='TIPOAGENDAEQUIPOS';
          exception
            when no_data_found then
              select max(idagenda) into n_idagenda
              from agendamiento where codsolot = n_codsolot;
          end;
          SELECT NVL(MAX(ORDEN), 0) + 1  INTO n_orden
          from solotptoequ
          where codsolot = n_codsolot and punto = n_punto and rownum=1;

          select count(1) into n_val_ser_equ from maestro_series_equ
          where nroserie=c.SERIAL_NUMBER;
          if n_val_ser_equ=1 then--Equipo existe en la BD
            select c.tipequ,b.preprm_usd,a.nroserie into n_tipequ,n_costo,v_nroserie
            from maestro_Series_Equ a, almtabmat b, tipequ c
            where nroserie =c.SERIAL_NUMBER and a.cod_sap=b.cod_sap and b.codmat=c.codtipequ;
          elsif n_val_ser_equ=0 then--No existe la Serie en la BD o es una MAC, se busca en el campo MAC
            select count(1) into n_val_serxmac from maestro_series_Equ where replace(c.mac_address,':','') in (mac1,mac2);
            if n_val_serxmac =1 then
              select c.tipequ,b.preprm_usd,a.nroserie into n_tipequ,n_costo,v_nroserie
              from maestro_Series_Equ a, almtabmat b, tipequ c
              where replace(c.mac_address,':','') in (mac1,mac2) and a.cod_sap=b.cod_sap and b.codmat=c.codtipequ;
            elsif n_val_serxmac>1 then
              n_tipequ:=999;
              v_obs:=v_obs ||'Existe mas de un equipo para la MAC registrada.';
              v_nroserie:=c.SERIAL_NUMBER;
            elsif n_val_serxmac=0 then
              n_tipequ:=999;
              v_obs:=v_obs ||'No existe la serie descargada de Incognito en el maestro.';
              v_nroserie:=c.SERIAL_NUMBER;
            end if;
          elsif n_val_ser_equ>1 then--Existe mas de una serie igual
            n_tipequ:=999;
            v_obs:=v_obs ||'Existe mas de un equipo para la Serie descargada.';
            v_nroserie:=c.SERIAL_NUMBER;
          end if;
          select count(1) into n_cont_equ--Validar si la serie existe en la SOT
          from solotptoequ a
          where a.numserie = v_nroserie and a.codsolot=n_codsolot;
          if n_cont_equ=0 then
            begin
              select B.Codigon_Aux into n_enacta from OPEDD B, TIPOPEDD C
              WHERE B.TIPOPEDD =C.TIPOPEDD AND C.ABREV='EQUDESCENACTA'
              and  b.codigon=a_tarea;
            exception
              when no_data_found then
                n_enacta:=0;
            end;
            if n_enacta=2 then--Si es Mantenimiento tiene que respetar el origen
              n_enacta:=c.origen;
            end if;
            insert into solotptoequ(codsolot,punto,orden,tipequ,CANTIDAD,TIPPRP,
            COSTO,NUMSERIE,flgsol,flgreq,codeta,tran_solmat,observacion,fecfdis,
            instalado,idagenda,fecins,flg_ingreso,mac,ESTADOEQU,enacta)
            values(n_codsolot,n_punto,n_orden,n_tipequ,1,0,nvl(n_costo,0),
            v_nroserie,1,0,647,null,v_obs,Sysdate,1,n_idagenda,sysdate,3, c.mac_address,1,
            n_enacta);
            commit;
          end if;
        end if;
      end loop;
      end if;
    end loop;
exception
  when others then
    n_error := -1;
    v_error := 'Error Carga Equipos: ' || to_char(sqlerrm);
end;

--INI 3.0
procedure sp_consulta_equ_inc(a_idwf in number, a_idtareawf in number) is

  n_codsolot    solot.codsolot%type;
  a_seq_equ_iw  number;
  an_error      integer;
  av_error      varchar2(299);
  n_iderr       number;
  v_mens        varchar2(400);
  l_customer_id number(8);
  cur_tv        SYS_REFCURSOR;
  cur_cm        SYS_REFCURSOR;
  cur_mta       SYS_REFCURSOR;

  V_1   NUMBER;
  V_2   NUMBER;
  V_3   VARCHAR2(40);
  V_4   VARCHAR2(40);
  V_5   VARCHAR2(40);
  V_6   VARCHAR2(40);
  V_7   NUMBER;
  V_8   VARCHAR2(40);
  V_9   VARCHAR2(40);
  n_tel number;
  n_int number;
  n_cab number;

begin

  select codsolot into n_codsolot from wf where idwf = a_idwf;
  operacion.pq_sinergia.p_reg_log('consulta cable.',
                                  5000,
                                  'cable',
                                  null,
                                  n_codsolot,
                                  null,
                                  null,
                                  null);
  select OPERACION.SQ_EQU_IW.NEXTVAL into a_seq_equ_iw from dual;
  select distinct nvl(b.customer_id, to_number(b.codcli))
    into l_customer_id
    from solotpto a, solot b, inssrv c, vtatabslcfac d
   where b.codsolot = n_codsolot
     and a.codsolot = b.codsolot
     and a.codinssrv = c.codinssrv
     and c.numslc = d.numslc;
  select count(1)
    into n_tel
    from SOLOTPTO A, INSSRV B
   where A.CODINSSRV = B.CODINSSRV
     AND A.CODSOLOT = n_codsolot
     and b.tipsrv = '0004';
  select count(1)
    into n_int
    from SOLOTPTO A, INSSRV B
   where A.CODINSSRV = B.CODINSSRV
     AND A.CODSOLOT = n_codsolot
     and b.tipsrv = '0006';
  select count(1)
    into n_cab
    from SOLOTPTO A, INSSRV B
   where A.CODINSSRV = B.CODINSSRV
     AND A.CODSOLOT = n_codsolot
     and b.tipsrv = '0062';

  if n_int > 0 then
    operacion.pq_sinergia.p_reg_log('consulta internet.',
                                    5000,
                                    'internet',
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
    INTRAWAY.PQ_MIGRASAC.P_TRAE_DOCSISEQUIPO(l_customer_id,
                                             n_iderr,
                                             v_mens,
                                             cur_cm);
    LOOP
      FETCH cur_cm
        into V_3, V_4, V_5, V_6, V_1, V_8, V_9;
      EXIT WHEN cur_cm%NOTFOUND;
      insert into OPERACION.TAB_EQUIPOS_IW2
        (ID_TICKET,
         codsolot,
         customer_id,
         tipo_servicio,
         MAC_ADDRESS,
         SERIAL_NUMBER)
      values
        (a_seq_equ_iw, n_codsolot, l_customer_id, 'INT', V_5, V_9);
      commit;
    END LOOP;
    CLOSE cur_cm;
  end if;
  if n_cab > 0 then
    operacion.pq_sinergia.p_reg_log('consulta cable.',
                                    5000,
                                    'cable',
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
    INTRAWAY.PQ_MIGRASAC.P_TRAE_ALLDTV(l_customer_id,
                                       n_iderr,
                                       v_mens,
                                       cur_tv);
    loop
      fetch cur_tv
        into V_1, V_2, V_3, V_4, V_5, V_6, V_7, V_8, V_9;
      exit when cur_tv%notfound;
      insert into OPERACION.TAB_EQUIPOS_IW2
        (id_ticket, codsolot, customer_id, tipo_servicio, SERIAL_NUMBER)
      values
        (a_seq_equ_iw, n_codsolot, l_customer_id, 'CTV', V_4);
      commit;
    end loop;
    CLOSE cur_tv;
  end if;
EXCEPTION
  WHEN OTHERS THEN
    av_error     := 'Error al obtener la informacion de INCOGNITO  : ' ||
                    SQLERRM;
    an_Error     := sqlcode;
    a_seq_equ_iw := -1;
    operacion.pq_sinergia.p_reg_log('Descarga_Materiale_Alta.',
                                    3000,
                                    av_error,
                                    null,
                                    n_codsolot,
                                    null,
                                    null,
                                    null);
end;
--FIN 3.0

END PQ_EQU_IW2;
/