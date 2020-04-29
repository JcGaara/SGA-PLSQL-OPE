CREATE OR REPLACE PROCEDURE OPERACION.P_SEND_MAIL_ARIN (a_rango in number, a_envia in number ) is

ls_texto varchar2(4000);

l_iplan varchar2(20);
l_iplanf varchar2(20);
l_tipo char(1);
l_cid number;
l_codinssrv number;
l_cliente varchar2(400);
l_direccion varchar2(480);
l_titulo varchar2(100);
l_codpostal varchar(20);
l_codubi varchar(10);
l_distrito varchar(40);
l_iplan_mask varchar(20);
l_multiplo varchar(3);
/******************************************************************************
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/
BEGIN
   select IPLAN, IPLANFIN, tipo, cid , iplan_mask, codinssrv
   into l_iplan, l_iplanf, l_tipo, l_cid , l_iplan_mask, l_codinssrv
   from rangosip r where  r.idrango = a_rango;

   if l_iplan_mask = '255.255.255.255' then
      l_multiplo := '1';
   end if;
   if l_iplan_mask = '255.255.255.254' then
      l_multiplo := '2';
   end if;
   if l_iplan_mask = '255.255.255.252' then
      l_multiplo := '4';
   end if;
   if l_iplan_mask = '255.255.255.248' then
      l_multiplo := '8';
   end if;
   if l_iplan_mask = '255.255.255.240' then
      l_multiplo := '16';
   end if;
   if l_iplan_mask = '255.255.255.224' then
      l_multiplo := '32';
   end if;
   if l_iplan_mask = '255.255.255.192' then
      l_multiplo := '64';
   end if;
   if l_iplan_mask = '255.255.255.128' then
      l_multiplo := '128';
   end if;
   if l_iplan_mask = '255.255.255.0' then
      l_multiplo := '256';
   end if;

   if l_tipo = 'C' and l_cid is not null then
     select c.nomcli, a.direccion , c.codubi
      into l_cliente, l_direccion , l_codubi
      from acceso a, vtatabcli c where a.codcli = c.codcli and a.cid =  l_cid;
   elsif l_tipo = 'C' and l_codinssrv is not null then
     select c.nomcli, a.direccion , c.codubi
      into l_cliente, l_direccion , l_codubi
      from inssrv a, vtatabcli c where a.codcli = c.codcli and a.codinssrv =  l_codinssrv;
   else
     l_cliente := 'AT1 Peru';
      l_direccion := 'Av.Victor A.Belaunde 147.Centro Emp. Camino Real,Torre 6, Of.303';
   end if;

   select codpos, nomdst into l_codpostal, l_distrito
   from vtatabdst where codubi = l_codubi;

   l_iplan := l_iplan || '/'||l_multiplo;

   l_titulo := 'ATT-PE-'||replace(l_iplan, '.', '-');

   if a_envia = 1 then

      ls_texto := '
WDB_version: 1.4
---
(N)new (M)modify (D)delete:N
(A)allocate (S)assign:S
---

Registration Action: N
Network Name: '||l_titulo||'
IP Address and Prefix or Range: '||l_iplan||'
Customer Name: '||l_cliente||'
Customer Address: '||l_direccion||'
Customer Address: '||l_distrito||'
Customer City: Lima
Customer State/Province: Lima
Customer Postal Code: '||l_codpostal||'
Customer Country Code: Pe
Public Comments:

---
hname:
ipaddr:
---
hname:
ipaddr:
---
nichandl: CI62-ARIN
lname:
fname:
mname:
org: AT1 Peru S.A.
street:Av.Victor A.Belaunde 147.Centro Emp. Camino Real,Torre 6, Of.303
city: Lima
state:
zipcode:
cntry: pe
phne:511-610-5555 x.2861
mbox: isp.gestion <mailto:isp.gestion> --1.0
';
   else
      ls_texto := '
WDB_version: 1.4
---
(N)new (M)modify (D)delete:N
(A)allocate (S)assign:S
---

Registration Action:R
IP Address and Prefix or Range: '||l_iplan||'
Additional Information:
IN-ADDR Name Server: ns3.firstcom.com.pe
IN-ADDR Name Server: ns4.firstcom.com.pe
POC Type:T
POC Handle:CI62-ARIN
Public Comments:
---
hname:
ipaddr:
---
hname:
ipaddr:
---
nichandl: CI62-ARIN
lname:
fname:
mname:
org: AT1 Peru S.A.
street:Av.Victor A.Belaunde 147.Centro Emp. Camino Real,Torre 6, Of.303
city: Lima
state:
zipcode:
cntry: pe
phne:511-610-5555 x.2861
mbox: isp.gestion <mailto:isp.gestion> 1.00
';
   end if;
   null;
   P_ENVIA_CORREO_DE_TEXTO_ATT(l_titulo, 'isp.gestion', ls_texto, 'isp.gestion');--1.0
   P_ENVIA_CORREO_DE_TEXTO_ATT(l_titulo, 'carlos.corrales', ls_texto, 'isp.gestion');--1.0
END;
/


