declare
l_codsrv  tystabsrv.codsrv%type;
l_tiptra tiptrabajo.tiptra%type;

begin
  --Obtenemos el Tipo Trabajo
  select t.tiptra
   into l_tiptra
   from tiptrabajo t
  where t.descripcion = 'INSTALACION TPE - HFC';  

  --Configuracion para TPE
  delete from operacion.opedd t
   where t.tipopedd in (select tipopedd
                          from operacion.tipopedd
                         where abrev in ('tpe', 'servicios_iw'));

  delete from operacion.tipopedd where abrev in ('tpe', 'servicios_iw');

  --Asignar WF automaticamente
  delete from opedd
   where tipopedd = 260
     and descripcion = 'HFC - TELEFONIA PUBLICA TPE'
     and codigon = 1209;

  --Constante - TPE  
  delete from constante
   where constante = 'TELEF_TPE' and valor = '0043';

  --Agendamiento
  delete from opedd t
   where descripcion = 'INSTALACION TPE - HFC'
     and codigoc = 'ALTA'
     and codigon = l_tiptra
     and tipopedd = (select tipopedd from tipopedd where abrev = 'PARAM_REG_AGE');
     
  --Estado Agenda   
  delete from secuencia_estados_agenda t where t.tiptra = l_tiptra;
  
  --Campanha
  delete from campanha
   where descripcion = 'TPE-HFC'
     and estado = 1;

  --Linea Paquete
  delete from linea_paquete t
   where t.iddet in (select d.iddet
                       from soluciones s, paquete_venta p, detalle_paquete d
                      where s.solucion = 'SOLUCIONES TPE-HFC'
                        and s.idsolucion = p.idsolucion
                        and p.idpaq = d.idpaq);
  
  --Detalle Paquete
  delete from detalle_paquete t
   where t.idpaq = (select p.idpaq
                      from soluciones s, paquete_venta p
                     where s.solucion = 'SOLUCIONES TPE-HFC'
                       and s.idsolucion = p.idsolucion);
  
  --Paquete Venta
  delete from paquete_venta t
   where t.idsolucion = (select s.idsolucion
                           from soluciones s
                          where s.solucion = 'SOLUCIONES TPE-HFC');
  
  --Soluciones
  delete from soluciones t where t.solucion = 'SOLUCIONES TPE-HFC';

  -- Intraway  
  select t.codsrv
    into l_codsrv
    from tystabsrv t
   where t.dscsrv = 'Line Reversal on Answer'
     and t.tipsrv = '0043';

   delete from intraway.configxservicio_itw
   where idconfigitw = 24 and codsrv = l_codsrv;

  --tystabsrv
  delete from tystabsrv t
   where t.codsrv = l_codsrv
     and t.dscsrv = 'Line Reversal on Answer'
     and t.tipsrv = '0043';

  select t.codsrv
    into l_codsrv
    from tystabsrv t
   where t.dscsrv = 'Llamada en espera'
     and t.tipsrv = '0043';  

   delete from intraway.configxservicio_itw
   where idconfigitw = 25 and codsrv = l_codsrv;

  --tystabsrv
  delete from tystabsrv t
   where t.codsrv = l_codsrv
     and t.dscsrv = 'Llamada en espera'
     and t.tipsrv = '0043'; 
     
  -- SgaCrm
  delete from sgacrm.ft_valor
   where idlista = 21 and valor = l_tiptra;

  --Tipo Trabajo
  delete from tiptrabajo
  where tiptra = l_tiptra;
  
  commit;
  
end;
/

drop package body operacion.pkg_tpe;
drop package operacion.pkg_tpe;
