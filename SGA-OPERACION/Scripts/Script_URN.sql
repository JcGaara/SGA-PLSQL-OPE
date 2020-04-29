declare
  l_tipopedd tipopedd.tipopedd%type;

begin
  --Claro Play - Cabecera
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('CLARO PLAY', 'CPLAY')
  returning tipopedd into l_tipopedd;

  --Claro Play - Detalle
  --Fox Play (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:fp', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:fx', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:natgeo', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:foxlife', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:foxsports1', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:foxsports2', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:foxsports3', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:cinecanal', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:thefilmzone', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:mundofox', 'FOXPLAY_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', null, 'urn:tve:babytv', 'FOXPLAY_URN', l_tipopedd, null);

  --Fox Play + (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM2', null, 'urn:tve:mcp', 'FOXPLAY+_URN', l_tipopedd, null);

  --TURNER (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:space', 'TURNER_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:tnt', 'TURNER_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:tnts', 'TURNER_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:cn', 'TURNER_URN', l_tipopedd, null);

  --ESPN (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:espn', 'ESPN_URN', l_tipopedd, null);

  --HotGo (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo', 'HOTGO_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo_playboy', 'HOTGO_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo_venus', 'HOTGO_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo_sextreme', 'HOTGO_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo_penthouse', 'HOTGO_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM3', null, 'urn:tve:hotgo_private', 'HOTGO_URN', l_tipopedd, null);

  --ViaCom (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:nickelodeon', 'VIACOM_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:mtv', 'VIACOM_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:comedycentral', 'VIACOM_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:paramountchannel', 'VIACOM_URN', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('PM1', null, 'urn:tve:mynickjr', 'VIACOM_URN', l_tipopedd, null);

  --Discovery (URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    ('BS', null, 'urn:tve:discoverykids', 'DISCOV_URN', l_tipopedd, null);

  commit;

end;
/
