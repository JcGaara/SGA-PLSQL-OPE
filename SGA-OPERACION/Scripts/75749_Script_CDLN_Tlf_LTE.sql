-- Codigos de Larga Distancia Nacional
insert into operacion.tipopedd(descripcion,abrev) values('Cod. de Larga Distancia Nac.','CLDN');
-- Codigos de Larga Distancia Nacional
-- Lima
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('1',
                             1,
                             'Lima',
                             'CDLN_LIMA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Amazonas
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('41',
                             15,
                             'Amazonas',
                             'CDLN_AMAZONAS',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Ancash
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('43',
                             2,
                             'Ancash',
                             'CDLN_ANCASH',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Apurimac
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('83',
                             3,
                             'Apurimac',
                             'CDLN_APURIMAC',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Arequipa
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('54',
                             4,
                             'Arequipa',
                             'CDLN_AREQUIPA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Ayacucho
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('66',
                             5,
                             'Ayacucho',
                             'CDLN_AYACUCHO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Cajamarca
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('76',
                             6,
                             'Cajamarca',
                             'CDLN_CAJAMARCA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Cusco
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('84',
                             8,
                             'Cusco',
                             'CDLN_CUSCO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Huancavelica
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('67',
                             9,
                             'Huancavelica',
                             'CDLN_HUANCAVELICA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Huanuco
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('62',
                             10,
                             'Huanuco',
                             'CDLN_HUANUCO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Ica
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('56',
                             11,
                             'Ica',
                             'CDLN_ICA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Junin
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('64',
                             12,
                             'Junin',
                             'CDLN_JUNIN',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- La Libertad
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('44',
                             13,
                             'La Libertad',
                             'CDLN_LA_LIBERTAD',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Lambayeque
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('74',
                             14,
                             'Lambayeque',
                             'CDLN_LAMBAYEQUE',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Loreto
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('65',
                             16,
                             'Loreto',
                             'CDLN_LORETO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Madre de Dios
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('82',
                             17,
                             'Madre de Dios',
                             'CDLN_MADRE_DE_DIOS',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Moquegua
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('53',
                             18,
                             'Moquegua',
                             'CDLN_MOQUEGUA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Pasco
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('63',
                             19,
                             'Pasco',
                             'CDLN_PASCO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Piura
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('73',
                             20,
                             'Piura',
                             'CDLN_PIURA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Puno
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('51',
                             21,
                             'Puno',
                             'CDLN_PUNO',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- San Martin
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('42',
                             22,
                             'San Martin',
                             'CDLN_SAN_MARTIN',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Tacna
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('52',
                             23,
                             'Tacna',
                             'CDLN_TACNA',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Tumbes
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('72',
                             24,
                             'Tumbes',
                             'CDLN_TUMBES',
                             (select tipopedd from tipopedd where abrev='CLDN'));
-- Ucayali
insert into operacion.opedd(codigoc, -- CDLN
                            codigon, -- CODEST
                            descripcion, -- Departamento
                            abreviacion, -- CDLN ABREV
                            tipopedd) -- COD. TIPOPEDD
                            values 
                            ('61',
                             25,
                             'Ucayali',
                             'CDLN_UCAYALI',
                             (select tipopedd from tipopedd where abrev='CLDN'));
commit;