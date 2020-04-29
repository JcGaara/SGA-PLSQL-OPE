declare
  l_tipopedd tipopedd.tipopedd%type;

begin
  --Claro Play - Cabecera
  insert into tipopedd
    (DESCRIPCION, ABREV)
  values
    ('CLARO PLAY BOUQUET DTHPREPAGO', 'CPLAY_DTH_PRE')
  returning tipopedd into l_tipopedd;

  --Claro Play - Detalle
  --Fox Play (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 114, 'urn:tve:fp', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:fx', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:natgeo', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:foxlife', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 110, 'urn:tve:foxsports1', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 154, 'urn:tve:foxsports2', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 146, 'urn:tve:foxsports3', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 117, 'urn:tve:cinecanal', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 122, 'urn:tve:thefilmzone', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:mundofox', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:babytv', 'FOXPLAY_BQ_PRE', l_tipopedd, null);

  --Fox Play + (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 107, 'urn:tve:mcp', 'FOXPLAY+_BQ_PRE', l_tipopedd, null);

  --TURNER (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:space', 'TURNER_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:tnt', 'TURNER_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:tnts', 'TURNER_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 141, 'urn:tve:cn', 'TURNER_BQ_PRE', l_tipopedd, null);

  --ESPN (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 115, 'urn:tve:espn', 'ESPN_BQ_PRE', l_tipopedd, null);

  --HotGo (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo', 'HOTGO_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo_playboy', 'HOTGO_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo_venus', 'HOTGO_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo_sextreme', 'HOTGO_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo_penthouse', 'HOTGO_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:hotgo_private', 'HOTGO_BQ_PRE', l_tipopedd, null);

  --ViaCom (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 114, 'urn:tve:nickelodeon', 'VIACOM_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 114, 'urn:tve:mtv', 'VIACOM_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:comedycentral', 'VIACOM_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:paramountchannel', 'VIACOM_BQ_PRE', l_tipopedd, null);

  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, null, 'urn:tve:mynickjr', 'VIACOM_BQ_PRE', l_tipopedd, null);

  --Discovery (Bouquet y URN)
  insert into opedd
    (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
  values
    (null, 129, 'urn:tve:discoverykids', 'DISCOV_BQ_PRE', l_tipopedd, null);

  commit;

end;
/
