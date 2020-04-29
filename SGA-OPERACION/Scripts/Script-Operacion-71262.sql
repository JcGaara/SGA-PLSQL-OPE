declare
  l_tipopedd tipopedd.tipopedd%type;
  l_idpaq    paquete_venta.idpaq%type;
  l_tiptra   tiptrabajo.tiptra%type;
  
begin  
  --Tipo de Trabajo
  insert into tiptrabajo
    (tiptra,
     tiptrs,
     descripcion,
     flgcom,
     flgpryint,
     sotfacturable,
     agendable,
     corporativo,
     selpuntossot)
  values
    ((select max(tiptra) + 1 from tiptrabajo),
     1,
     'INSTALACION TPE - HFC',
     0,
     0,
     0,
     0,
     0,
     0)
   returning tiptra into l_tiptra;
  
  -- TPE
  insert into tipopedd
    (descripcion, abrev)
  values
    ('telefonia publica exteriores', 'tpe')
  returning tipopedd into l_tipopedd;
  

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('0043', null, 'servicio tpe', 'servicio_tpe', l_tipopedd, null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('24', null, 'codigos externos tpe', 'cod_externo_tpe', l_tipopedd, null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('25', null, 'codigos externos tpe', 'cod_externo_tpe', l_tipopedd, null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (null, l_tiptra, 'tipo trabajo tpe', 'tiptra_tpe', l_tipopedd, null);

  --servicio_telefonico
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('1102',
     null,
     'Servicio para Numero Telefonico',
     'servicio_telefonico',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('1979',
     null,
     'Servicio para Numero Telefonico',
     'servicio_cabina',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('1686',
     null,
     'Servicio para Numero Telefonico',
     'servicio_equipo',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('5054',
     null,
     'Servicio para Numero Telefonico',
     'servicio_comodato',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('AQHW',
     null,
     'Servicio para Numero Telefonico',
     'servicio_intraway1',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('AQHX',
     null,
     'Servicio para Numero Telefonico',
     'servicio_intraway2',
     l_tipopedd,
     null);

  --Id Producto
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('590',
     null,
     'Servicio para Numero Telefonico',
     'producto_telefonico',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('685',
     null,
     'Servicio para Numero Telefonico',
     'producto_cabina',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('591',
     null,
     'Servicio para Numero Telefonico',
     'producto_equipo',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('694',
     null,
     'Servicio para Numero Telefonico',
     'producto_comodato',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('590',
     null,
     'Servicio para Numero Telefonico',
     'producto_intraway1',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('590',
     null,
     'Servicio para Numero Telefonico',
     'producto_intraway2',
     l_tipopedd,
     null);

  --Id Precio
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('7386',
     null,
     'Servicio para Numero Telefonico',
     'precio_telefonico',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('17413',
     null,
     'Servicio para Numero Telefonico',
     'precio_cabina',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('17196',
     null,
     'Servicio para Numero Telefonico',
     'precio_equipo',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('20876',
     null,
     'Servicio para Numero Telefonico',
     'precio_comodato',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('17196',
     null,
     'Servicio para Numero Telefonico',
     'precio_intraway1',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('17196',
     null,
     'Servicio para Numero Telefonico',
     'precio_intraway2',
     l_tipopedd,
     null);
     
 select v.idpaq into l_idpaq from paquete_venta v where v.observacion like '%TELEFONÍA PUBLICA TPE-HFC%';
 
  --IdPaq
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_telefonico',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_cabina',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_equipo',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_comodato',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_intraway1',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (l_idpaq,
     null,
     'Servicio para Numero Telefonico',
     'idpaq_intraway2',
     l_tipopedd,
     null);

  -- Puertos
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('9824',
     null,
     'Servicio para Numero Telefonico',
     'equipo_puertos2',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('9608',
     null,
     'Servicio para Numero Telefonico',
     'equipo_puertos4',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('9194',
     null,
     'Servicio para Numero Telefonico',
     'equipo_puertos8',
     l_tipopedd,
     null);

  --Servicios IW
  insert into tipopedd
    (descripcion, abrev)
  values
    ('servicios para iw', 'servicios_iw')
  returning tipopedd into l_tipopedd;

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('0004', null, 'telefonia fija', 'servicios_iw', l_tipopedd, null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('0059',
     null,
     'telefonia publica interior',
     'servicios_iw',
     l_tipopedd,
     null);

  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    ('0043',
     null,
     'telefonia publica exterior',
     'servicios_iw',
     l_tipopedd,
     null);
   
  insert into opedd
    (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
  values
    (null, '1209', 'HFC - TELEFONIA PUBLICA TPE', null, 260, null);

  --Constante - TPE  
  insert into constante
    (constante, descripcion, tipo, valor)
  values
    ('TELEF_TPE', 'Codigo de familia de Telefonia TPE', 'C', '0043');

  --AGENDAMIENTO  
  insert into opedd
    (codigoc, codigon, descripcion, tipopedd)
  values
    ('ALTA',
     l_tiptra,
     'INSTALACION TPE - HFC',
     (select tipopedd from tipopedd where abrev = 'PARAM_REG_AGE'));

  --Estado Agenda
  insert into secuencia_estados_agenda
    (tiptra, aplica_contrata, aplica_pext, idseq, estagendaini, estagendafin)
  select l_tiptra,
         aplica_contrata,
         aplica_pext,
         idseq,
         estagendaini,
         estagendafin
    from secuencia_estados_agenda t
   where t.tiptra = 402;

  commit;
end;
/
