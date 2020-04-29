CREATE OR REPLACE PROCEDURE OPERACION.P_ASIGNAAUTO_IP(p_cid in number,p_codprd in number,p_codequipo in number,p_codpuerto in number,p_retorno out number) is
vn_idrango rangosip.idrango%type;
vv_nomcli  vtatabcli.nomcli%type;
vn_count   number;
CURSOR c1 IS
 select a.clasec,b.numero1,b.numero2,b.numero3,b.numero4
 from   clasec a,ipxclasec b
 where  a.clasec = b.clasec and
        a.codprd = p_codprd and
        a.codequipo = p_codequipo and
        b.tipo is null
        order by a.clasec,b.numero;
Begin
  select nomcli into vv_nomcli
  from   acceso a,vtatabcli b
  where   a.codcli = b.codcli and
          a.cid = p_cid;

  p_retorno := 0;

  select count(*) into vn_count  from t_temp_asigauto
  where codpuerto = p_codpuerto and cid = p_cid and estado = 1;

  if vn_count > 0 then
      p_retorno := 2;
  else
      insert into t_temp_asigauto(codpuerto,cid)
      values (p_codpuerto,p_cid);
  end if;

  FOR aip IN c1 LOOP
      if p_retorno = 0 then
          select max(idrango)+ 1 into vn_idrango from rangosip;
          insert into RANGOSIP(idrango,RANGO,tipo,CID,Ipwan,Ipwan_Mask,estado)
          values(vn_idrango,'CID'||p_cid||' '||vv_nomcli,'C',p_cid,aip.numero1||'.'||aip.numero2||'.'||aip.numero3||'.'||aip.numero4,'255.255.255.255',1);
          commit;
          UPDATE IPXCLASEC SET TIPO = 'W',IDRANGO = vn_idrango
          where numero1 = aip.numero1 and numero2 = aip.numero2 and numero3 = aip.numero3 and numero4 = aip.numero4;
          p_retorno := 1;
          exit;
       end if;
  END LOOP;
exception
when no_data_found then
  p_retorno := 0;
End;
/


