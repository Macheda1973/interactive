use interactive;

-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS regioni (
    id          SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
    nome        VARCHAR(40) NOT NULL,
    sigla       CHAR(3) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS province (
    id          SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
    id_regione  SMALLINT UNSIGNED NOT NULL,
    nome         VARCHAR(40) NOT NULL,
    sigla       CHAR(2) NOT NULL,
        CONSTRAINT `fk_provincie_regioni` FOREIGN KEY (id_regione) REFERENCES regioni(id)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS comuni (
    id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(40) NOT NULL,
    istat_cod       CHAR(6) NOT NULL,
    id_provincia    SMALLINT UNSIGNED NOT NULL,
        CONSTRAINT `fk_comuni_provincie` FOREIGN KEY (id_provincia) REFERENCES province(id)
) ENGINE=InnoDB;
        
        
create or replace view COMUNI_PROV_REG as 
select c.id, c.istat_cod, c.nome comune, p.nome provincia, p.sigla, r.nome regione, r.sigla sigla_regione
from comuni c
join province p on p.id = c.id_provincia
join regioni r on r.id = p.id_regione
;

-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS nations (
    alpha3_cod          CHAR(3)  NOT NULL PRIMARY KEY,
    alpha2_cod          CHAR(2)  NOT NULL,
    name                VARCHAR(60) NOT NULL,
    tax_pct             DECIMAL(5,3),
    nat_phone_prefix    VARCHAR(18) NOT NULL,
    curr_code           CHAR(3),
    continent           CHAR(2) NOT NULL,
    languages           VARCHAR(100),
    capital             VARCHAR(40) 
) ENGINE=InnoDB;
    
    
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS world_cities (
  city VARCHAR(80),
  city_ascii VARCHAR(80),
  lat decimal(7,4),
  lng decimal(7,4),
  country VARCHAR(80),
  iso2 CHAR(2),
  iso3 CHAR(3),
  admin_name VARCHAR(200),
  capital VARCHAR(200),
  population INT,
  id INT
);

alter table world_cities add CONSTRAINT `fk_worldcities_nations` FOREIGN KEY (iso3) REFERENCES nations(alpha3_cod);

-- ------------------------------------------------------
create table IF NOT EXISTS languages (
    alpha3  CHAR(3) NOT NULL PRIMARY KEY, 
    alpha2  CHAR(2) NOT NULL, 
    name    VARCHAR(100)  NOT NULL,
    used    BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;
    

CREATE TABLE IF NOT EXISTS  currency (
    curr_code   CHAR(3) NOT NULL PRIMARY KEY, 
    curr_name   VARCHAR(30) NOT NULL,
    symbol      char(1) 
) ENGINE=InnoDB;

-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `services` (
    id        INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
   ,name      VARCHAR(80)   NOT NULL
   ,url       VARCHAR(50)   NOT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `products` (
    id              INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  id_service      INT UNSIGNED  NOT NULL
 ,  name            VARCHAR(80)   NOT NULL
 ,  prezzo_base     DECIMAL(7,2)  NOT NULL
 ,  descrizione     VARCHAR(1024) NOT NULL
 ,  taen            DECIMAL(4,2)  NOT NULL    
 ,  taeg            DECIMAL(4,2)  NOT NULL    
 ,  teg             DECIMAL(4,2)  NOT NULL    
 , `des`            VARCHAR(512)
 , `notes`          TEXT
-- ,  tassazione      DECIMAL(4,2)  
 ,      CONSTRAINT `fk_products_services` FOREIGN KEY (id_service) REFERENCES services(id)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `tipi_movimento`(
    id              TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
,   name            VARCHAR(30) NOT NULL
,   amm_role_req    BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `brands` (
  `id`          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `brand_name`  VARCHAR(255),
  `path_image`  VARCHAR(255)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `levels` (
    `level_cod`         CHAR(3) NOT NULL PRIMARY KEY
,   `level_name`        VARCHAR(30) not null
,   `des`               VARCHAR(255)
) ENGINE=InnoDB;


    
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  `id_brand`            SMALLINT UNSIGNED
 ,  `tipo_utente`         enum('P','A') comment 'La colonna accetta "P" per i privati e "A" per le aziende'
 ,  `level_cod`           CHAR(3)
 ,  `email`               VARCHAR(100) NOT NULL comment 'Nel caso di aziende italiana, l`applicativo deve verificare che l`email principale sia una pec'
 ,  `email_sec`           VARCHAR(100) NULL
 ,  `username`            VARCHAR(80) NOT NULL
 ,  `password`            VARCHAR(20) NOT NULL
 ,  `scadenza`            datetime
 ,  `id_comune`           SMALLINT UNSIGNED
 ,  `naz_cod`             CHAR(3)
 ,  `cap`                 VARCHAR(10) NOT NULL
 ,  `account_status`      enum('A', 'D', 'C', 'S', 'R') NOT NULL DEFAULT 'R' COMMENT 'A: Attivo, D: Dormiente, C: Chiuso, S: Scaduto, R registrato ma non ancora attivo'
 ,  `email_convalid_code` VARCHAR(10) COMMENT 'codice random di convalida per verificare la mail'
 ,  `tel_convalid_code`   VARCHAR(10) COMMENT 'codice random di convalida per verificare la telefono'
 ,  `domanda_sic`         VARCHAR(255)
 ,  `risposta_sic`        VARCHAR(255)
 ,  `referenza`           VARCHAR(100)
 ,  `min_depot`           decimal(10,2)
 ,  `max_depot`           decimal(10,2)
 ,  `min_withdrawal`      decimal(10,2)
 ,  `max_withdrawal`      decimal(10,2)
 ,  `num_min_doc`         tinyint not null default 2
 ,      UNIQUE KEY `uk_username` (`username`)
 ,      CONSTRAINT `fk_users_brands` FOREIGN KEY (id_brand) REFERENCES brands(id)
 ,      CONSTRAINT `fk_users_levels` FOREIGN KEY (level_cod) REFERENCES levels(level_cod)
) ENGINE=InnoDB;

    
-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_documenti` (
 -- Todo: gestione BLOB x FotoProfilo e FotoDocumento
    `id`                    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  `id_user`               INT UNSIGNED NOT NULL      
 ,  `tipo_documento`        CHAR(3) NOT NULL comment 'Es: CI: Carta identità - PA: Patente Auto - PP: Passaporto'
 ,  `stato_documento`       BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'FALSE=scaduto, TRUE=attivo'
 ,  `codice_documento`      VARCHAR(12) NOT NULL
 ,  `ente_emissione`        VARCHAR(255) NOT NULL
 ,  `data_emissione_doc`    DATE NOT NULL
 ,  `data_scadenza_doc`     DATE NOT NULL
 ,  `foto_fronte_doc`       BLOB
 ,  `foto_retro_doc`        BLOB
 ,      CONSTRAINT `fk_utedoc_users` FOREIGN KEY (id_user) REFERENCES users(id)
) ENGINE=InnoDB;


-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dett_user_privato` (
    `id_user`           INT UNSIGNED NOT NULL      
 ,  `first_name`        VARCHAR(100) NOT NULL
 ,  `last_name`         VARCHAR(100) NOT NULL
 ,  `telefono_1`        VARCHAR(20) NOT NULL
 ,  `telefono_2`        VARCHAR(20)
 ,  `cod_fiscale`       VARCHAR(16)
 ,  `gender`            CHAR(1) NOT NULL
 ,  `birth_day`         DATE NOT NULL
 ,  `dettagli`          JSON
 ,      CONSTRAINT `fk_usrpriv_users` FOREIGN KEY (id_user) REFERENCES users(id)
) ENGINE=InnoDB;


-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dett_user_azienda` (
    `id_user`           INT UNSIGNED NOT NULL      
 ,  `nome_azienda`      VARCHAR(80) NOT NULL
 ,  `sede_legale`       VARCHAR(100) NOT NULL
 ,  `piva`              VARCHAR(16) NOT NULL
 ,  `cod_fiscale`       VARCHAR(16)
 ,  `referente`         VARCHAR(120) NOT NULL
 ,  `ruolo`             VARCHAR(30) NOT NULL default 'Ammministratore' 
 ,  `sito`              VARCHAR(80)
 ,  `telefono_1`        VARCHAR(20) NOT NULL
 ,  `telefono_2`        VARCHAR(20) NULL
 ,  `dettagli`          JSON COMMENT 'in questo campo va inserito anche l`attributo codici_ateco di tipo lista'
 ,      CONSTRAINT `fk_usrazienda_users` FOREIGN KEY (id_user) REFERENCES users(id)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `user_log` (
 `id`           BIGINT UNSIGNED NOT NULL PRIMARY KEY,
 `id_user`      INT UNSIGNED NOT NULL,
 `action`       varchar(50) NOT NULL COMMENT 'the action of the player: login, logout, wrongaccess, changepass, changemail, changeanagraphic',
 `date`         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `ip`           varchar(50)
,     CONSTRAINT `fk_userlog_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS users_services (
    `id`                    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  `id_user`               INT UNSIGNED NOT NULL
 ,  `id_service`            INT UNSIGNED NOT NULL
 ,  `data_sottoscrizione`   DATE NOT NULL
 ,  `data_cancellazione`    DATE NULL
 ,  `active`                BOOLEAN GENERATED ALWAYS AS (`data_cancellazione` is null)
 ,      CONSTRAINT `fk_usersservices_users` FOREIGN KEY (id_user) REFERENCES users(id)
 ,      CONSTRAINT `fk_usersservices_services` FOREIGN KEY (id_service) REFERENCES services(id)
 ,      CONSTRAINT `uk_users_services` UNIQUE KEY (id_user,id_service)
) ENGINE=InnoDB;

-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_service_products` (
    `id`                    INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  `id_userserv`           INT UNSIGNED  NOT NULL
 ,  `id_product`            INT UNSIGNED  NOT NULL
 ,  `data_sottoscrizione`   DATE NOT NULL
 ,  `data_cancellazione`    DATE NULL
 ,  `active`                BOOLEAN GENERATED ALWAYS AS (`data_cancellazione` is null)
 ,      CONSTRAINT `fk_userservprod_userservices` FOREIGN KEY (id_userserv) REFERENCES users_services(id)
 ,      CONSTRAINT `fk_userservprod_products` FOREIGN KEY (id_product) REFERENCES products(id)
) ENGINE=InnoDB;


-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users_movements` (
    `id`                BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
,   `id_userservprod`   INT UNSIGNED  NOT NULL
,   `id_tipo_mov`       TINYINT UNSIGNED NOT NULL
,   `op_state`          enum('CONFIRMED','ROLLEDBACK','CANCELED')
,   `importo`           DECIMAL(10,2) NOT NULL
,   `currency`          CHAR(3) NOT NULL
,   `at`                TIMESTAMP NOT NULL DEFAULT current_timestamp
,   `transaction_id`    VARCHAR(64) NOT NULL
,   `note`              mediumtext
,      CONSTRAINT `fk_usermov_userservprod` FOREIGN KEY (id_userservprod) REFERENCES user_service_products(id)
,      CONSTRAINT `fk_usermov_uprod_tipimov` FOREIGN KEY (id_tipo_mov) REFERENCES tipi_movimento(id)
,      CONSTRAINT `fk_usermov_curr` FOREIGN KEY (`currency`) REFERENCES `currency` (`curr_code`)
) ENGINE=InnoDB;    


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS partners (
    `id`                  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,  `nome`                VARCHAR(80) NOT NULL
 ,  `type`                enum('provider','merchant') NOT NULL DEFAULT 'provider'
 ,  `piva`                VARCHAR(11) NOT NULL
 ,  `email`               VARCHAR(100) NOT NULL comment 'Nel caso di aziende italiana, l`applicativo deve verificare che l`email principale sia una pec'
 ,  `email_sec`           VARCHAR(100) NULL
 ,  `referente`           VARCHAR(80)  NULL
 ,  `sede_legale`         VARCHAR(255) NOT NULL
 ,  `telefono_1`          VARCHAR(20) NOT NULL
 ,  `telefono_2`          VARCHAR(20) NULL
 ,  `sito`                VARCHAR(80) NULL
 ,  `naz_cod`             CHAR(3) NOT NULL
 ,  `cap`                 VARCHAR(10) NOT NULL
 ,  `city`                VARCHAR(80) NULL
 ,  `username`            VARCHAR(25) NOT NULL
 ,  `password`            VARCHAR(16) NOT NULL
 ,  `min_depot`           decimal(10,2)
 ,  `max_depot`           decimal(10,2)
 ,  `min_withdrawal`      decimal(10,2)
 ,  `max_withdrawal`      decimal(10,2)
 ,  `descrizione`    VARCHAR(255)
 ,    CONSTRAINT `fk_partners_nazioni` FOREIGN KEY (naz_cod) REFERENCES nations(alpha3_cod)
) COMMENT "I fornitori di servizio"
ENGINE=InnoDB;
  

-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `members` (
  `id`                   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_service`           INT UNSIGNED NOT NULL,
  `id_brand`             SMALLINT UNSIGNED,
  `date_registration`    date NOT NULL default (current_date) COMMENT 'data di registrazione affiliato o agente',
  `username`             VARCHAR(30) NOT NULL,
  `email`                VARCHAR(80) NOT NULL,
  `password`             VARCHAR(80) NOT NULL,
  `salt`                 VARCHAR(80) NOT NULL,
  `level`                VARCHAR(10) NOT NULL DEFAULT '5',
  `activation`           BOOLEAN NOT NULL DEFAULT false COMMENT 'utente attivato true, non attivato false',
  `member_type`          ENUM('affiliate', 'agent', 'portal', 'internal') NOT NULL DEFAULT 'affiliate' COMMENT 'puo essere affiliate, agent, dipendente dell`azienda per definire l`utente',
  `email_convalid_code`  VARCHAR(10) COMMENT 'codice random di convalida per verificare la mail',
  `tel_convalid_code`    VARCHAR(10) COMMENT 'codice random di convalida per verificare la telefono',
  `validate`             BOOLEAN NOT NULL DEFAULT false COMMENT 'se false utente non convalidato, altrimenti si',
  `reward_share`         DECIMAL(4,2) COMMENT 'Percentuale di guadagno del member',
  `afftag`               VARCHAR(55),
  `affpercent`           SMALLINT NOT NULL DEFAULT 0 COMMENT 'Percentuale che l`affiliato DEVE destinare alla sua UPLINE'
,  `minimum_fee_partner`  decimal(6,2)
,  `minimum_fee_merchant` decimal(6,2)
,  `minimum_fee_jackpot`  decimal(6,2)
,  `jackpot_affilation`   BOOLEAN DEFAULT TRUE
,  `min_depot`           decimal(10,2)
,  `max_depot`           decimal(10,2)
,  `min_withdrawal`      decimal(10,2)
,  `max_withdrawal`      decimal(10,2)
,      UNIQUE KEY `uk_members_email` (`email`)
,      CONSTRAINT `fk_members_brands` FOREIGN KEY (id_brand) REFERENCES brands(id)
,      CONSTRAINT `fk_members_servizi` FOREIGN KEY (id_service) REFERENCES services(id)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `member_anagraphic` (
  `id_member`           SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
  `name`                varchar(80),
  `surname`             varchar(80),
  `group`               varchar(80) NOT NULL DEFAULT 'Agente autorizzato UNGM',
  `born_date`           date,
  `born_city`           varchar(120) ,
  `address`             varchar(100) ,
  `address_number`      varchar(10) ,
  `address_city`        varchar(120) ,
  `address_city_cap`    varchar(10) ,
  `naz_cod`             CHAR(3),
  `phone`               varchar(12) ,
  `mobile`              varchar(12) ,
  `website`             varchar(120) ,
  `lang`                CHAR(3),
  `state`               varchar(80) ,
  `skype_account`       varchar(255) ,
  `private_note`        text,
  `first_market`        varchar(4) ,
  `second_market`       varchar(4)
,     CONSTRAINT `fk_membanag_members` FOREIGN KEY (id_member) REFERENCES members(id)
,     CONSTRAINT `fk_membanag_lang` FOREIGN KEY (lang) REFERENCES languages(alpha3)
,     CONSTRAINT `fk_membanag_nazioni` FOREIGN KEY (naz_cod) REFERENCES nations(alpha3_cod)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `member_payments` (
  `id`                          BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_member`                   SMALLINT UNSIGNED,
--  `btag`                        varchar(255) NOT NULL,
  `reward_share`                DECIMAL(4,2) COMMENT 'Percentuale di riferimento del pagamento',
  `status`                      varchar(20) DEFAULT 'open' COMMENT 'Lo status di base è open, quindi sta controllando, dopo invio diventa closed',
  `stats_time_period`           date NOT NULL,
  `calculation_date`            date NOT NULL,
  `payment_done_in_data`        date COMMENT 'Data in cui l`ammontare è stato pagato',
  `payment_done_method`         varchar(50) COMMENT 'metodo utilizzato per il pagamento, può essere: bank, neteller, skrill o comunque quelli supportati',
  `affiliate_earned`            decimal(10,2) NOT NULL COMMENT 'ammontare da pagare per l`affiliato. Include gia eventuali Chargeback. NON include guadagni subaffiliazione.',
  `affiliate_deposits`          decimal(10,2) NOT NULL,
  `affiliate_bets`              decimal(10,2)NOT NULL,
  `affiliate_new_depositer`     SMALLINT NOT NULL,
  `affiliate_active_players`    SMALlINT NOT NULL,
  `affiliate_banner_impression` BIGINT NOT NULL,
  `affiliate_banner_click`      BIGINT NOT NULL,
  `affiliate_bonus`             decimal(10,2) NOT NULL,
  `affiliate_stakes`            decimal(10,2) NOT NULL,
  `affiliate_chargeback`        decimal(10,2) NOT NULL,
  `affiliate_revenue`           decimal(10,2) NOT NULL,
  `affiliate_ngr`               decimal(10,2) NOT NULL,
  `casino_earn`                 decimal(10,2) NOT NULL,
  `monthly_expensive`           decimal(10,2),
  `subaffiliation_amount`       decimal(10,2) COMMENT 'l`ammontare degli subaffiliati',
  `subaffiliation_data`         tinytext COMMENT 'i dati che fanno ottenere l`ammontare',
  `link_affiliate_rapport`      text,
  `request`                     BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'FALSE pagamento non richiesto, TRUE pagamento richiesto da parte di affiliato/agente',
  `id_transazione`              VARCHAR(40),
  `amount`                      decimal(10,2),
  `invoice`                     VARCHAR(20)
,      CONSTRAINT `fk_membpayment_members` FOREIGN KEY (id_member) REFERENCES members(id)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users_members` (
    `id`                INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
,   `id_user_serv`      INT UNSIGNED NOT NULL
,   `id_member`         SMALLINT UNSIGNED NOT NULL
,   `start_ass_data`    date NOT NULL
,   `end_ass_data`      date
,   `active`            BOOLEAN GENERATED ALWAYS AS (`end_ass_data` is null)
,      CONSTRAINT `fk_usersmembers_usersserv` FOREIGN KEY (`id_user_serv`) REFERENCES users_services(`id`)
,      CONSTRAINT `fk_usersmembers_members` FOREIGN KEY (`id_member`) REFERENCES members(`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `partners_property` (
  `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_partner`      SMALLINT UNSIGNED NOT NULL,
  `bonus_deduction` DECIMAL(4,2),
  `minimum_fee`     DECIMAL(10,2),
  `startdate`       date default (current_date),
  `deadline`        date,
  `notes`           text
,      CONSTRAINT `fk_partnerprop_partners` FOREIGN KEY (id_partner) REFERENCES partners(id)
)  ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `member_property` (
  `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_member`       SMALLINT UNSIGNED NOT NULL,
  `bonus_deduction` DECIMAL(4,2),
  `minimum_fee`     DECIMAL(10,2),
  `startdate`       date default (current_date),
  `deadline`        date,
  `notes`           text
,      CONSTRAINT `fk_memberprop_members` FOREIGN KEY (id_member) REFERENCES members(id)
)  ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `partner_specs` (
  `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
, `id_partner`          SMALLINT UNSIGNED NOT NULL
, `subsidier`           BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Se true è un sussidiario'
, `minimum_fee`         DECIMAL(10,2) COMMENT 'costo fisso mensile del merchant'
, `perc_deposit_cost`   DECIMAL(4,2)  COMMENT 'costo percentuale per ogni deposito'
, `fix_deposit_cost`    DECIMAL(10,2) COMMENT 'costo fisso per operazione'
, `perc_withdraw_cost`  DECIMAL(4,2)
, `fix_withdraw_cost`   DECIMAL(10,2)
, `transfer_negative`   DECIMAL(10,2)
, `currency`            CHAR(3)
,       CONSTRAINT `fk_partnersspecs_partners` FOREIGN KEY (id_partner) REFERENCES partners(id)
,       CONSTRAINT `fk_partnerspecs_curr` FOREIGN KEY (`currency`) REFERENCES `currency` (`curr_code`)
)  ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `member_specs` (
  `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
, `id_member`           SMALLINT UNSIGNED NOT NULL
, `minimum_fee`         DECIMAL(10,2) COMMENT 'costo fisso mensile del merchant'
, `perc_deposit_cost`   DECIMAL(4,2)  COMMENT 'costo percentuale per ogni deposito'
, `fix_deposit_cost`    DECIMAL(10,2) COMMENT 'costo fisso per operazione'
, `perc_withdraw_cost`  DECIMAL(4,2)
, `fix_withdraw_cost`   DECIMAL(10,2)
, `transfer_negative`   DECIMAL(10,2)
, `currency`            CHAR(3)
,   CONSTRAINT `fk_partnersspecs_members` FOREIGN KEY (id_member) REFERENCES members(id)
,   CONSTRAINT `fk_memberspecs_curr` FOREIGN KEY (`currency`) REFERENCES `currency` (`curr_code`)
)  ENGINE=InnoDB;

 
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ruoli` (
  `ruolo`       VARCHAR(255) NOT NULL PRIMARY KEY,
  `livello`     SMALLINT UNSIGNED NOT NULL,
  `commento`    VARCHAR(255) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `ruoli_partners` (
  `ruolo`       VARCHAR(255) NOT NULL,
  `id_partner` SMALLINT UNSIGNED NOT NULL,
      PRIMARY KEY (`ruolo`,`id_partner`),
      CONSTRAINT `fk_rp_ruoli` FOREIGN KEY (`ruolo`) REFERENCES `ruoli` (`ruolo`),
      CONSTRAINT `fk_rp_partners` FOREIGN KEY (`id_partner`) REFERENCES `partners` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `ruoli_members` (
  `ruolo`           VARCHAR(255) NOT NULL,
  `id_member`       SMALLINT UNSIGNED NOT NULL,
      PRIMARY KEY (`ruolo`,`id_member`),
      CONSTRAINT `fk_rm_ruoli` FOREIGN KEY (`ruolo`) REFERENCES `ruoli` (`ruolo`),
      CONSTRAINT `fk_rm_members` FOREIGN KEY (`id_member`) REFERENCES `members` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `ruoli_users` (
  `ruolo`           VARCHAR(255) NOT NULL,
  `id_user`         INT UNSIGNED NOT NULL,
      PRIMARY KEY (`ruolo`,`id_user`),
      CONSTRAINT `fk_ru_ruoli` FOREIGN KEY (`ruolo`) REFERENCES `ruoli` (`ruolo`),
      CONSTRAINT `fk_ru_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;


-- ------------------------------------------------------
CREATE TABLE IF NOT EXISTS banche (
    id                  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , cod_bi              SMALLINT UNSIGNED NOT NULL
  , cod_fiscale         VARCHAR(16) NOT NULL
  , denominazione       VARCHAR(80) NOT NULL
  , direzione_generale  VARCHAR(80) NOT NULL
  , sede_legale         VARCHAR(80) NOT NULL
  , naz_cod             CHAR(3)
  , tipo_intermediario  VARCHAR(32)
  , classificazione     VARCHAR(16)
  ,     CONSTRAINT `fk_banca_nazioni` FOREIGN KEY (naz_cod) REFERENCES nations(alpha3_cod)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS conti_correnti_partners (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_partner      SMALLINT UNSIGNED NOT NULL
  , id_banca        SMALLINT UNSIGNED NOT NULL
  , iban            VARCHAR(33) NOT NULL
  , swift           VARCHAR(11) NOT NULL
  , neteller_email  varchar(80)
  , skrill_email    varchar(80)
  ,     CONSTRAINT fk_ccp_partners  FOREIGN KEY (`id_partner`) REFERENCES `partners` (`id`)
  ,     CONSTRAINT fk_ccp_banche    FOREIGN KEY (`id_banca`) REFERENCES `banche` (`id`)
  ,     CONSTRAINT uk_ccp_iban      UNIQUE (iban)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS conti_correnti_members (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_member       SMALLINT UNSIGNED NOT NULL
  , id_banca        SMALLINT UNSIGNED NOT NULL
  , iban            VARCHAR(33) NOT NULL
  , swift           VARCHAR(11) NOT NULL
  , neteller_email  varchar(80)
  , skrill_email    varchar(80)
  ,     CONSTRAINT fk_ccm_members   FOREIGN KEY (`id_member`) REFERENCES `members` (`id`)
  ,     CONSTRAINT fk_ccm_banche    FOREIGN KEY (`id_banca`) REFERENCES `banche` (`id`)
  ,     CONSTRAINT uk_ccm_iban      UNIQUE (iban)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS conti_correnti_utenti (
    id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_user         INT UNSIGNED NOT NULL
  , id_banca        SMALLINT UNSIGNED NOT NULL
  , iban            VARCHAR(33) NOT NULL
  , swift           VARCHAR(11) NOT NULL
  , neteller_email varchar(80)
  , skrill_email   varchar(80)
  ,     CONSTRAINT fk_ccu_users     FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
  ,     CONSTRAINT fk_ccu_banche    FOREIGN KEY (`id_banca`) REFERENCES `banche` (`id`)
  ,     CONSTRAINT uk_ccu_iban      UNIQUE (iban)
) ENGINE=InnoDB;

-- ------------------------------------------
CREATE TABLE IF NOT EXISTS circuiti_cdc(
    id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
,   nome_circuito   VARCHAR(80) NOT NULL
);


CREATE TABLE IF NOT EXISTS cdc_partners (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_partner          SMALLINT UNSIGNED NOT NULL
  , id_circuito         SMALLINT UNSIGNED NOT NULL
  , tipo_carta          ENUM('CREDITO','DEBITO', 'RICARICABILE')
  , nation_code         CHAR(3) NOT NULL      
  , fisrt_4digit        TINYINT NOT NULL
  , last_4digit         TINYINT NOT NULL
  , data_scadenza       char(7) NOT NULL
  , nome_titolare       VARCHAR(80) NOT NULL
  , cognome_titolare    VARCHAR(80) NOT NULL
  , banca_emittente     VARCHAR(40) NOT NULL
  ,     CONSTRAINT fk_cdcp_nations   FOREIGN KEY (`nation_code`) REFERENCES `nations` (`alpha3_cod`)
  ,     CONSTRAINT fk_cdcp_partners  FOREIGN KEY (`id_partner`)  REFERENCES `partners` (`id`)
  ,     CONSTRAINT fk_cdcp_circuiti  FOREIGN KEY (`id_circuito`) REFERENCES `circuiti_cdc` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS cdc_members (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_member           SMALLINT UNSIGNED NOT NULL
  , id_circuito         SMALLINT UNSIGNED NOT NULL
  , nation_code         CHAR(3) NOT NULL      
  , fisrt_4digit        TINYINT NOT NULL
  , last_4digit         TINYINT NOT NULL
  , data_scadenza       char(7) NOT NULL
  , nome_titolare       VARCHAR(80) NOT NULL
  , cognome_titolare    VARCHAR(80) NOT NULL
  , banca_emittente     VARCHAR(40) NOT NULL
  ,     CONSTRAINT fk_cdcm_nations   FOREIGN KEY (`nation_code`) REFERENCES `nations` (`alpha3_cod`)
  ,     CONSTRAINT fk_cdcm_members   FOREIGN KEY (`id_member`) REFERENCES `members` (`id`)
  ,     CONSTRAINT fk_cdcm_circuiti  FOREIGN KEY (`id_circuito`) REFERENCES `circuiti_cdc` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS cdc_utenti (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
  , id_user             INT UNSIGNED NOT NULL
  , id_circuito         SMALLINT UNSIGNED NOT NULL
  , nation_code         CHAR(3) NOT NULL      
  , fisrt_4digit        TINYINT NOT NULL
  , last_4digit         TINYINT NOT NULL
  , data_scadenza       char(7) NOT NULL
  , nome_titolare       VARCHAR(80) NOT NULL
  , cognome_titolare    VARCHAR(80) NOT NULL
  , banca_emittente     VARCHAR(40) NOT NULL
  ,     CONSTRAINT fk_cdcu_nations   FOREIGN KEY (`nation_code`) REFERENCES `nations` (`alpha3_cod`)
  ,     CONSTRAINT fk_cdcu_users     FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
  ,     CONSTRAINT fk_cdcu_circuiti  FOREIGN KEY (`id_circuito`) REFERENCES `circuiti_cdc` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
/*
limiti di deposito:
Giornalieri - minimi e massimi per user/affiliato/casinò
settimanali - minimi e massimi per user/affiliato/casinò
mensili - minimi e massimi per user user/affiliato/casinò
*/
CREATE TABLE IF NOT EXISTS `depot_limits` (
    id              tinyint UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
  , `role`          enum('USER', 'PLAYER', 'MEMBER', 'PARTNER') NOT NULL DEFAULT 'USER'
  , `type_limit`    enum('DAY', 'WEEK', 'MONTH')
  , `min`           decimal(10,2) not null
  , `max`           decimal(10,2) not null
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `withdrawal_limits` (
    id              tinyint UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY
  , `role`          enum('USER', 'PLAYER', 'MEMBER', 'PARTNER') NOT NULL DEFAULT 'USER'
  , `type_limit`    enum('DAY', 'WEEK', 'MONTH')
  , `min`           decimal(10,2) not null
  , `max`           decimal(10,2) not null
) ENGINE=InnoDB;


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `banners` (
   `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 , `id_member`  SMALLINT UNSIGNED NOT NULL
 , `id_brand`   SMALLINT UNSIGNED
 , `width`      VARCHAR(4)
 , `height`     VARCHAR(3)
 , `lang`       VARCHAR(3)
 , `mediaurl`   VARCHAR(512)
 , `linkurl`    VARCHAR(512)
 , `active`     BOOLEAN
 , `redirect`   VARCHAR(255) COMMENT 'se presente redirige il banner ad un altro, utile se un banner si vuole modificare senza perdere il vecchio'
 , `title`      VARCHAR(255) COMMENT 'Titolo descrittivo per gestione'
 ,     CONSTRAINT `fk_banner_members` FOREIGN KEY (id_member) REFERENCES members(id)
 ,     CONSTRAINT `fk_banner_brands` FOREIGN KEY (id_brand) REFERENCES brands(id)
) ENGINE=InnoDB;


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `events` (
   `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
,  `event_date`         datetime NOT NULL
,  `event_title`        varchar(255) NOT NULL
,  `event_description`  mediumtext
,  `event_lang` varchar(5) NOT NULL DEFAULT 'it'
,  `event_type` varchar(50) DEFAULT NULL
,  `event_template_to_use` int(5) NOT NULL
,  `acrive` BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;

-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `bonus_type` (
  `id`      SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
, `name`    VARCHAR(32) NOT NULL
) ENGINE=InnoDB;


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `bonus` (
  `id`                   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_bonus_type`        SMALLINT UNSIGNED NOT NULL,
  `id_event`             INT UNSIGNED  NOT NULL,
  `id_service`           INT UNSIGNED  NOT NULL,
  `id_member`            SMALLINT UNSIGNED NULL,
  `bonus_name`           VARCHAR(255),
  `begins`               datetime NOT NULL,
  `stops`                datetime,
  `value_type`           enum('FIXED','PERCENTAGE') NOT NULL,
  `value`                decimal(10,2) COMMENT 'valore del bonus',
  `max_expenditure`      decimal(10,2) DEFAULT 0.00 COMMENT 'Tetto alla spesa',
  `wagering`             smallint unsigned,
  `over`                 enum('B','CB') NOT NULL COMMENT 'B: BONUS, CB: CAPITALE PIU` BONUS',
  `min_dep`              decimal(10,2) NOT NULL,
  `cap`                  decimal(10,2) NOT NULL,
  `use_first`            enum('CB','BC') NOT NULL COMMENT 'B: BONUS, CB: CAPITALE PIU` BONUS',
  `max_cashout`          decimal(10,2) NOT NULL,
  `creation_date`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `excluded_country`     VARCHAR(255),
  `initial_bonus_amount` decimal(10,2) NOT NULL DEFAULT 0.00
,     CONSTRAINT `fk_bonus_bonus_type` FOREIGN KEY (id_bonus_type) REFERENCES bonus_type (id)
,     CONSTRAINT `fk_bonus_events` FOREIGN KEY (id_event) REFERENCES events(id)
,     CONSTRAINT `fk_bonus_members` FOREIGN KEY (id_member) REFERENCES members(id)
,     CONSTRAINT `fk_bonus_services` FOREIGN KEY (id_service) REFERENCES services(id)
) ENGINE=InnoDB;


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `assigned_bonus` (
    `id`            BIGINT UNSIGNED NOT NULL
  , `at`            TIMESTAMP NOT NULL DEFAULT current_timestamp
  , `id_user`       INT UNSIGNED NOT NULL
  , `amount`        decimal(10,2) NOT NULL DEFAULT 0.00
  , `amount_bet`    decimal(10,2) NOT NULL DEFAULT 0.00
  , `amount_won`    decimal(10,2) NOT NULL DEFAULT 0.00
  , `msg`           text
  ,     CONSTRAINT `fk_assbonus_users`  FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `campaign` (
  `id_campaign`             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
 ,`id_member`               smallint UNSIGNED NOT NULL
 ,`campaign_code`           VARCHAR(40)
 ,`campaign_description`    VARCHAR(512)
 , start_date               date
 , end_date                 date
 , des                      VARCHAR(1024)
 , property                 JSON
 ,     CONSTRAINT `fk_campaign_member` FOREIGN KEY (`id_member`) REFERENCES `members`(`id`)
) ENGINE=InnoDB; 


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cash_flow` (
  `id_service`  INT UNSIGNED  NOT NULL,
  `cf_date`     date NOT NULL DEFAULT (CURRENT_DATE),
  `op_cost`     decimal(10,2),
  `deposit`     decimal(10,2),
  `withdraw`    decimal(10,2),
  `reserve`     decimal(4,2) COMMENT 'ROLLING RESERVE',
    PRIMARY KEY `pk_cash_flow` (`id_service`, `cf_date`),
    CONSTRAINT `fk_cashflow_services` FOREIGN KEY (`id_service`) REFERENCES services(`id`)
) ENGINE=InnoDB;


-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `players` (
    `id`                    INT UNSIGNED NOT NULL PRIMARY KEY comment ' non autoincrement perché deve essere uguale a quella di users'
,   `game_block_length`      enum('1w', '2w', '1m', '6m', '1y', 'ever')
,   `start_block_date`      date
,   `max_daily_loss`        DECIMAL(10,2)
,   `max_weekly_loss`       DECIMAL(10,2)
,   `max_monthly_loss`      DECIMAL(10,2)
,      CONSTRAINT `fk_players_usersserv` FOREIGN KEY (`id`) REFERENCES users_services(`id`)
);


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `costs_type` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name_cost`   VARCHAR(255) NOT NULL
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `costs_casino` (
  `id`                int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
--  `id_creator`      int UNSIGNED NOT NULL,
  `id_partner`        SMALLINT UNSIGNED,
  `id_cost_type`      int UNSIGNED NOT NULL,
  `amount`            decimal(10,2) NOT NULL,
  `date_creation`     date NOT NULL,
  `description`       text,
  `date_decorrenza`   date NOT NULL,
  `date_deadline`     date
  ,  CONSTRAINT `fk_costscasino_costtype` FOREIGN KEY (`id_cost_type`) REFERENCES `costs_type` (`id`)
  ,  CONSTRAINT `fk_costscasino_partners` FOREIGN KEY (`id_partner`) REFERENCES `partners` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `game_category` (
  `id`      SMALLINT unsigned NOT NULL PRIMARY KEY,
  `name`    VARCHAR(50) NOT NULL
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `provider_game_cost` (
  `id`              BIGINT unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_partener`     SMALLINT unsigned NOT NULL,
  `id_game_type`    SMALLINT unsigned NOT NULL,
  `game_cost`       decimal(10,2) NOT NULL
,   CONSTRAINT    `fk_providergamecost_partners` FOREIGN KEY (`id_partener`) REFERENCES `partners` (`id`)
,   CONSTRAINT    `fk_providergamecost_gamecategory` FOREIGN KEY (`id_game_type`) REFERENCES `game_category` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `game_inventory` (
  `id`              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_game_type`    SMALLINT UNSIGNED NOT NULL,
  `id_partner`      SMALLINT UNSIGNED NOT NULL,
  `game_id`         VARCHAR(64) NOT NULL,
  `game_name`       VARCHAR(64) NOT NULL,
  `game_rating`     smallint NOT NULL DEFAULT '2',
  `game_lines`      smallint,
  `wheels`          smallint,
  `payout`          decimal(4,2),
  `imagine_path`    VARCHAR(512),
  `game_url`        VARCHAR(512),
  `game_kind`       VARCHAR(25),
  `des`             VARCHAR(512),
  `notes`           text
,   CONSTRAINT `fk_gameinventory_partners`      FOREIGN KEY (`id_partner`) REFERENCES `partners` (`id`)
,   CONSTRAINT `fk_gameinventory_gamecategory`  FOREIGN KEY (`id_game_type`) REFERENCES `game_category` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `historicalnotes` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_user`     INT UNSIGNED NOT NULL,
  `id_member`   SMALLINT UNSIGNED NOT NULL,
  `date`        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `note`        text
,     CONSTRAINT `fk_hnotes_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
,     CONSTRAINT `fk_hnotes_members` FOREIGN KEY (`id_member`) REFERENCES `members` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `log` (
  `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `descr` VARCHAR(4000) NOT NULL
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `login_attempts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_user` INT UNSIGNED NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
,     CONSTRAINT `fk_loginattempts_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mail_templates` (
  `id`              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `template_name`   VARCHAR(255),
  `lang`            VARCHAR(3) NOT NULL,
  `country`         char(3) NOT NULL,
  `last_modify`     date,
  `last_modify_id`  INT UNSIGNED,
  `mail_body`       text,
  `status`          boolean NOT NULL DEFAULT false COMMENT 'false=disabled, true=active',
  `type`            tinyint NOT NULL DEFAULT 1 COMMENT 'type of users the template is for: 1=players 2=affiliates, 3=agents, 4=agents/affiliates',
  `subject`         VARCHAR(255)
,   CONSTRAINT fk_mailtemplates_nations FOREIGN KEY (country) REFERENCES nations(alpha3_cod)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mails_tobe_sent` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_member`           SMALLINT UNSIGNED NOT NULL,    
  `id_template`         SMALLINT UNSIGNED,
  `recipients_id`       VARCHAR(4000) NOT NULL,
  `requested_date`      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `subject_mail`        VARCHAR(255) NOT NULL,
  `bodymail`            text NOT NULL,
  `sent_date`           datetime,
  `status`              tinyint NOT NULL DEFAULT 0 COMMENT '0=in attesa approvazione, 1=approvato in attesa di invio, 2=invio negato, 3=inviato, 10=richiesta cancellata',
  `whynot`              mediumtext NOT NULL COMMENT 'Why not sent, or why cancelled, the reason for everything',
  `report`              text,
  `mails_recipient`     text
,     CONSTRAINT `fk_mailstobesent_mtemplates` FOREIGN KEY (`id_template`) REFERENCES `mail_templates` (`id`)
,     CONSTRAINT `fk_mailstobesent_members` FOREIGN KEY (id_member) REFERENCES members(id)
) ENGINE=InnoDB;


-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `players_casino_movements` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_player`       INT UNSIGNED NOT NULL,
  `id_game`         INT UNSIGNED,
  `op_type`         enum('BET','WIN','TRANFERT-IN','TRANFERT-OUT','ADJUSTMENT','BONUS'),
  `op_state`        enum('CONFIRMED','ROLLEDBACK','CANCELED'),
  `at`              timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id`  VARCHAR(64) NOT NULL,
  `round_id`        BIGINT UNSIGNED ,
  `balance_was`     decimal(10,2) NOT NULL,
  `amount`          decimal(10,2) NOT NULL default 0,
  `balance_is`      decimal(10,2)  GENERATED ALWAYS AS (balance_was + amount),
  `currency`        char(3) DEFAULT 'EUR',
  `msg`             text
,     CONSTRAINT `fk_plrcasinomov_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
,     CONSTRAINT `fk_plrcasinomov_games` FOREIGN KEY (`id_game`) REFERENCES `game_inventory` (`id`)
,     CONSTRAINT `fk_plrcasinomov_curr` FOREIGN KEY (`currency`) REFERENCES `currency` (`curr_code`)
) ENGINE=InnoDB;



CREATE TABLE IF NOT EXISTS `jackpots` (
  `id`              TINYINT UNSIGNED NOT NULL PRIMARY KEY
, `jp_type`         ENUM('MINIMAL', 'MEDIUM', 'MAJOR') NOT NULL
, `last_update`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
, `jp_actual_value` DECIMAL(11,2)
, `jp_base_value`   DECIMAL(10,2) NOT NULL
, `jp_max_value`    DECIMAL(11,2) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `jackpots_hist_logs` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
, `id_jackpot`        TINYINT UNSIGNED NOT NULL 
, `operation_date`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
, `operation_type`    ENUM('ADJUSTAMET', 'ASSIGNEMENT', 'INCREMENT')
, `value`             DECIMAL(10,2) NOT NULL
, `id_player`         INT UNSIGNED
, `id_member`         SMALLINT UNSIGNED
, `id_game_movement`  BIGINT UNSIGNED
,     CONSTRAINT `fk_jphistlogs_gamemov` FOREIGN KEY (`id_game_movement`) REFERENCES `players_casino_movements` (`id`)
,     CONSTRAINT `fk_jphistlogs_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
,     CONSTRAINT `fk_jphistlogs_members` FOREIGN KEY (`id_member`) REFERENCES members(`id`)
) ENGINE=InnoDB;


-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `players_deposit_transaction` (
  `id_transaction`          BIGINT unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_player`               INT UNSIGNED NOT NULL,
  `language`                CHAR(3) NOT NULL,
  `currency`                CHAR(3) NOT NULL,
  `balance_was`             decimal(10,2) NOT NULL,
  `amount`                  decimal(10,2) NOT NULL default 0,
  `balance_is`              decimal(10,2)  GENERATED ALWAYS AS (balance_was + amount),
  `date_transaction`        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payment_type`            varchar(255) NOT NULL,
  `payment_method`          varchar(40) NOT NULL,
  `payment_state`           varchar(40) NOT NULL,
  `financial_institution`   varchar(255) NOT NULL,
  `expiry`                  CHAR(7) NOT NULL,
  `card_holder`             varchar(255)  NOT NULL,
  `masked_card`             varchar(255)  NOT NULL,
  `order_number`            varchar(512) NOT NULL,
  `ip_adress_user`          varchar(255) NOT NULL,
  `typology`                enum('Deposit', 'Withdraw', 'recurPayment', 'ToGame', 'FromGame', 'Adjustment') NOT NULL DEFAULT 'Deposit',
  `date_creation`           datetime NOT NULL default current_timestamp,
  `requestfingerprint`      BOOLEAN NOT NULL DEFAULT FALSE,
  `order_reference`         text NOT NULL,
  `error_description`       text NOT NULL
,     CONSTRAINT `fk_playersdepttrans_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
,     CONSTRAINT `fk_playersdepttrans_languages` FOREIGN KEY (`language`) REFERENCES `languages` (`alpha3`)
,     CONSTRAINT `fk_playersdepttrans_currency` FOREIGN KEY (`currency`) REFERENCES `currency` (`curr_code`)
) ENGINE=InnoDB;

-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `player_balance_history` (
   `id_player`       INT UNSIGNED NOT NULL
,  `at`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
,  `amount`          decimal(10,2) NOT NULL
,  `real_balance`    decimal(10,2) NOT NULL
,  `bonus_balance`   decimal(10,2)
,  `cashback`        decimal(10,2)
,  `loyalty`         decimal(10,2)
,   PRIMARY KEY (`id_player`,`at`)
,   CONSTRAINT `fk_plrblnhist_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
) ENGINE=InnoDB; 



CREATE TABLE IF NOT EXISTS `player_bonus` (
  `id_player`           INT UNSIGNED NOT NULL,
  `id_bonus`            BIGINT UNSIGNED NOT NULL,
  `bonus_balance`       decimal(10,2),
  `balance_was`         decimal(10,2),
  `amount`              decimal(10,2) NOT NULL default 0 COMMENT 'Valorizzato al momento dell`assenazione con la percentuale o il valore fisso',
  `balance_is`          decimal(10,2)  GENERATED ALWAYS AS (balance_was + amount),
  `turnover`            decimal(10,2) COMMENT 'TURNOVER NECESSARIO',
  `assigned`            datetime NOT NULL,
  `deadline`            datetime NOT NULL,
  `initial_bonus_value` decimal(10,2) DEFAULT 0,
  `accepted`            smallint  unsigned NOT NULL DEFAULT 0
,       PRIMARY KEY (`id_player`, `id_bonus`)
,       CONSTRAINT `fk_playerbonus_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
,       CONSTRAINT `fk_playerbonus_bonus` FOREIGN KEY (`id_bonus`) REFERENCES `bonus` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `player_cashback` (
  `id_player`           INT UNSIGNED NOT NULL,
  `deposit_amount`      decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'the sum of the deposits that cumulate to gain cash-back. It has to be placed to zero when it is redeemed.',
  `percentage`          decimal(4,2)  NOT NULL DEFAULT 0.00 COMMENT 'The percentage of cash-back given on each bet. If this value is equal to zero the player does not gain any cash-back.',
  `cashback`            decimal(10,2) NOT NULL COMMENT 'The gained cash-back amount.',
  `already_redeemed`    decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'What a player has already redeemed.A player can redeem partially his/her cash back amount and it remains â€˜REDEEMABLEâ€™.',
  `status` enum('ACTIVE','REDEEMABLE','REDEEMED','LOST') NOT NULL
,     CONSTRAINT `fk_playercashback_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `player_cashback_history` (
  `id_player`   INT UNSIGNED NOT NULL,
  `claimed_on`  datetime NOT NULL COMMENT 'the date on which it has been claimed',
  `amount`      decimal(10,2) NOT NULL COMMENT 'the amount claimed',
  `percentage`  decimal(4,2) NOT NULL COMMENT 'the percentage applied'
,     CONSTRAINT `fk_playercashbackhist_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `report_adjustment` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_user`             INT UNSIGNED NOT NULL,
  `trans_id`            BIGINT,
  `adjustment_date`     timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `debit_real_amount`   varchar(25),
  `credit_real_amount`  varchar(25),
  `processed_by`        INT unsigned,
  `force_negative`      BOOLEAN NOT NULL DEFAULT FALSE,
  `publish_transaction` BOOLEAN NOT NULL DEFAULT FALSE,
  `balance_was`         decimal(10,2),
  `amount`              decimal(10,2) NOT NULL default 0,
  `balance_is`          decimal(10,2)  GENERATED ALWAYS AS (balance_was + amount),
  `note` mediumtext
,     CONSTRAINT `fk_reportadjustment_users` FOREIGN KEY (`id_user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `report_bonus` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_player`           INT UNSIGNED NOT NULL,
  `player_status`       varchar(25),
  `id_bonus`            BIGINT UNSIGNED NOT NULL,
  `bonus_status`        varchar(25),
  `bonus_currency`      CHAR(3),
  `bonus_amount`        DECIMAL(10,2),
  `bonus_created`       date,
  `bonus_issue_date`    date,
  `bonus_costs`         DECIMAL(10,2),
  `report_date`         timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reveiced_other_bonus`    varchar(255),
  `no_round_played`     INT,
  `payout_amount`       DECIMAL(10,2),
  `payout_date`         date,
  `wager_requirements`  INT UNSIGNED,
  `current_wager`       DECIMAL(5,2)
,     CONSTRAINT `fk_reportbonus_users` FOREIGN KEY (`id_player`) REFERENCES `users` (`id`)
,     CONSTRAINT `fk_reportbonus_bonus` FOREIGN KEY (`id_bonus`) REFERENCES `bonus` (`id`)
,     CONSTRAINT `fk_reportbonus_currency` FOREIGN KEY (`bonus_currency`) REFERENCES `currency` (`curr_code`)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `reward_plans` (
  `id`                              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_member`                       SMALLINT UNSIGNED NOT NULL,
  `activation`                      BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'piano attivo TRUE altrimenti FALSE',
  `name_plan`                       varchar(255) ,
  `id_plan_on_end_bonus`            varchar(5) ,
  `fixed_costs`                     decimal(10,2)  COMMENT 'costi fissi da sottrarre',
  `credit_card_transaction_cost`    decimal(10,2)  COMMENT 'Costo da sottrarre per la transizione con carta di credito. inserire il numero di percentuale da addebitare al membro',
  `skrill_transaction_cost`         decimal(10,2)  COMMENT 'Costo da sottrarre per la transizione con SKRILL. inserire il numero di percentuale da addebitare al membro',
  `neteller_transaction_cost`       decimal(10,2)  COMMENT 'Costo da sottrarre per la transizione con NETELLER. inserire il numero di percentuale da addebitare al membro',
  `amount_player_booster1`          decimal(10,2)  COMMENT 'Numero di nuovi depositanti nel mese per ottenere il bonus booster1',
  `amount_booster1`                 decimal(10,2)  COMMENT 'Numero percentuale da aggiungere alle commissioni',
  `amount_player_booster2`          decimal(10,2)  COMMENT 'Numero di nuovi depositanti nel mese per ottenere il bonus booster2',
  `amount_booster2`                 decimal(10,2)  COMMENT 'Numero percentuale da aggiungere alle commissioni',
  `percent_range_1`                 decimal(4,2)   COMMENT 'Percento di commissione per i range 1',
  `commission_range_1`              decimal(10,2)  COMMENT 'Il range 1 parte sempre da 0 e termina al valore impostato su commission_range_1',
  `percent_range_2`                 decimal(4,2)   COMMENT 'Percento di commissione per i range 2',
  `commission_range_2`              decimal(10,2)  COMMENT 'Parte da commission_range_1 + 1 e arriva al dato qui settato',
  `percent_range_3`                 decimal(4,2)   COMMENT 'Percento di commissione per i range 3',
  `commission_range_3`              decimal(10,2)  COMMENT 'Parte da commission range_2 + 1 ',
  `percent_range_4`                 decimal(4,2)   COMMENT 'Percento di commissione per i range 4',
  `commission_range_4`              decimal(10,2)  COMMENT 'Parte da commission range_3 + 1 ',
  `percent_range_5`                 decimal(4,2) ,
  `commission_range_5`              decimal(10,2) ,
  `percent_range_6`                 decimal(4,2) ,
  `commission_range_6`              decimal(10,2) ,
  `percent_over_last_range`         decimal(4,2) ,
  `bonus_commission`                decimal(4,2)    COMMENT 'Percento di bonus da aggiungere al piano. In percentuale',
  `date_start_bonus_commission`     date            COMMENT 'Data di inizio bonus aggiuntivo',
  `date_end_bonus_commission`       date            COMMENT 'Data di fine bonus aggiuntivo',
  `public`                          BOOLEAN NOT NULL DEFAULT FALSE,
  `note`                            mediumtext,
  `commission_sub`                  varchar(2) ,
  `added_costs`                     varchar(3) ,
  `fixed_commission`                varchar(3) ,
  `negative_carryover`              varchar(2) NOT NULL DEFAULT '1',
  `cost_carryover`                  BOOLEAN NOT NULL DEFAULT FALSE,
  `risk_percent`                    decimal(5,2) ,
  `sub_recursive_commission`        decimal(4,2) COMMENT 'percentuale da dare a livelli infiniti, esempio country manager con codice',
  `typo`                            varchar(15) NOT NULL DEFAULT 'affiliate' COMMENT 'tipologia piano, affiliato o agente, se agente in pratica si paga da solo tutti i costi esistenti escluso nessuno.'
,     CONSTRAINT `fk_rewardplans_members` FOREIGN KEY (`id_member`) REFERENCES `members` (`id`)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `visitors` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `ip`              varchar(20) NOT NULL,
  `naz_cod`         CHAR(3),
  `last_date`       datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `first_visit`     datetime NOT NULL
,      CONSTRAINT `fk_visitors_nazioni` FOREIGN KEY (naz_cod) REFERENCES nations(alpha3_cod)
) ENGINE=InnoDB;


-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `visitors_steps` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `ip`              varchar(20) NOT NULL,
  `page`            varchar(255) NOT NULL,
  `codice_funzione` varchar(30),
  `date`            datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creation_date`   datetime NOT NULL
) ENGINE=InnoDB;


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- !!! Serve ancora ????
CREATE TABLE IF NOT EXISTS `players_data` (
  `id`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `id_player`           INT UNSIGNED NOT NULL,
  `transaction_date`    date ,
  `chargeback`          decimal(10,2),
  `deposits`            decimal(10,2),
  `metodo_deposito`     varchar(20) NOT NULL DEFAULT 'CCVisa' COMMENT 'puo essere uno dei metodi di pagamento es: Neteller, Skrill; CCVisa, CCMaster, Ukash ecc...',
  `casino_bets`         INT,
  `casino_revenue`      decimal(10,2),
  `casino_bonuses`      decimal(10,2),
  `casino_stake`        decimal(10,2),
  `casino_ngr`          varchar(50)
,     CONSTRAINT `fk_playersdata_users` FOREIGN KEY (`id_player`) REFERENCES `players` (`id`)
) ENGINE=InnoDB;

