ALTER TABLE operacion.sgat_df_transaccion_cab
    ADD CONSTRAINT fk_trsc_fluc FOREIGN KEY ( trscn_idflujo )
        REFERENCES operacion.sgat_df_flujo_cab ( flucn_idflujo );
