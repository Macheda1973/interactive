# Descrizione tabelle DB Interaction
---

Nel seguito verrà data una breve descrizione delle tabelle che vanno a
formare il database Interaction. Delle tabelle verrà descritto il loro
scopo e i campi principali. Per il dettaglio di tutti i campi fare
riferimento dal file SLQ fornito per la creazione del database.

## Lista tabelle

[abi_banche](#abi_banche)

[assigned_bonus](#assigned_bonus)

[banche](#banche)

[banners](#banners)

[bonus_type](#bonus_type)

[bonus](#bonus)

[brands](#brands)

[campaign](#campaign)

[cash_flow](#cash_flow)

[categorie_ateco](#categorie_ateco)

[codici_ateco](#codici_ateco)

[comuni](#comuni)

[province](#province)

[regioni](#regioni)

[nations](#nations)

[world_cities](#world_cities)

[circuiti_cdc](#circuiti_cdc)

[cdc_members](#cdc_members)

[cdc_partners](#cdc_partners)

[cdc_utenti](#cdc_utenti)

[conti_correnti_members](#conti_correnti_members)

[conti_correnti_partners](#conti_correnti_partners)

[conti_correnti_utenti](#conti_correnti_utenti)

[costs_type](#costs_type)

[costs_casino](#costs_casino)

[currency](#currency)

[ruoli](#ruoli)

[ruoli_members](#ruoli_members)

[ruoli_partners](#ruoli_partners)

[ruoli_users](#ruoli_users)

[services](#services)

[products](#products)

[tipi_movimento](#tipi_movimento)

[users](#users)

[user_log](#user_log)

[dett_user_azienda](#dett_user_azienda)

[dett_user_privato](#dett_user_privato)

[user_documenti](#user_documenti)

[users_services](#users_services)

[user_service_products](#user_service_products)

[users_movments](#users_movments)

[users_members](#users_members)

[game_category](#game_category)

[game_inventory](#game_inventory)

[jackpots](#jackpots)

[jackpots_hist_logs](#jackpots_hist_logs)

[languages](#languages)

[log](#log)

[login_attempts](#login_attempts)

[mail_templates](#mail_templates)

[mails_tobe_sent](#mails_tobe_sent)

[members](#members)

[member_anagraphic](#member_anagraphic)

[member_payments](#member_payments)

[member_property](#member_property)

[member_specs](#member_specs)

[partners](#partners)

[partners_property](#partners_property)

[partner_specs](#partner_specs)

[players](#players)

[player_balance_history](#player_balance_history)

[player_bonus](#player_bonus)

[player_cashback](#player_cashback)

[player_cashback_history](#player_cashback_history)

[players_casino_movements](#players_casino_movements)

[players_data](#players_data)

[players_deposit_transaction](#players_deposit_transaction)

[provider_game_cost](#provider_game_cost)

[report_adjustment](#report_adjustment)

[report_bonus](#report_bonus)

[reward_plans](#reward_plans)

[visitors](#visitors)

[visitors_steps](#visitors_steps)

[historicalnotes](#historicalnotes)

### abi_banche

La tabella è formata da 2 campi:

- **nome_banca**

- **abi**

In questa tabella sono presenti tutte le banche che hanno diritto di
operare in Italia con il loro codice ABI

### assigned_bonus

La tabella è formata dai campi:

- **id** id automatico del record

- **at** *timestamp* dell'inserimento

- **id_user** utente che ha beneficiato del bonus

- **amount** l'importo del buono

- **amount_bet** è un campo del vecchio sistema di cui non mi è chiara
  l'utilità

- **amount_won** è un campo del vecchio sistema di cui non mi è chiara
  l'utilità

- **msg** campo delle note

Nota: Rispetto alla copia installata è' stata rimossa la colonna
**id_member** perché già presente in **bonus**.

### banche

La tabella consente di caricare i dati identificativi delle banche come
sede sociale, codice fiscale, ecc. ecc.

### banners

La tabella è formata dai campi:

- **id** id automatico del record

- **id_member** id del membro legato al membro

- **id_brand** id del brand (tabelle brands) associato al banner

- **width** dimensione della larghezza del banner

- **height** dimensione dell'altezza del banner

- **lang** linguaggio del banner

- **mediaurl** url del media associato banner

- **linkurl** url del banner

- **active** stato del banner

- **redirect** è un campo del vecchio sistema di cui non mi è chiara
  l'utilità

- **title** titolo del banner

### bonus_type

La tabella consente di indentificare le varie tipologie di bonus ed il
suo id è un vincolo di integrità per la tabella **bonus**

### bonus

La tabella consente di registrare tutti i bonus che si vuole attivare,
consentendo tra l'altro di impostare:

- il servizio **id_service** su cui è attivo il bonus

- l'evento a cui è associato (**id_event**)

- l'arco temporale **begins**, **stops** in cui è attivo

- ed il membro **id_member** che l'ha attivato.

### brands

La tabella consente di registrare i *brand* associati al servizio
registrandone il nome **brand_name** ed il path dell'immagine da
visualizzare **path_image**

### campaign

Lista delle campagne che il servizio vuole attivare, i dettagli sono
ancora da definire

### cash_flow

in questa tabella è stata ripresa dal vecchio DB e dovrebbe riportare
ogni operazione fatta a livello di servizio, occorre capire se nel nuovo
sistema, vista la presenza della **users_movements** se questa tabella
serve ancora

### categorie_ateco

La tabella contiene la lista delle categorie ATECCO, le righe che come
ID hanno una lettera, indicano i settori quelle con in numeri indicano
la categoria.

### codici_ateco

Nella tabella sono presenti tutti i codici ATECO attualmente attivi, la
colonna **categoria** è la foreing key che ci dice a quale categoria
appartiene il codice.

### comuni

Lista dei comuni italiani (tabella precaricata) con id e foreing key
verso la tabella province

### province

Lista delle provincie italiane (tabella precaricata) con id e foreing
key verso la tabella regioni

### regioni

Lista delle regioni italiane (tabella precaricata)

### nations

Lista delle nazioni attualmente presenti nel pianeta, e per ogni nazione
viene anche riportato il prefisso telefonico internazionale, le lingue
parlate, e sua capitale.

### world_cities

Lista delle principali città mondiali (tabella precaricata) con foreing
key verso la tabella **nations**

### circuiti_cdc

Lista dei circuiti delle carte di credito esistenti (la tabella non è
fra quelle precaricate)

### cdc_members

La lista delle carte di credito associate ai membri. come vedrai nella
tabella **membri**, i membri sono gli associati e gli agenti.

### cdc_partners

La lista delle carte di credito associate ai partners. come vedrai nella
tabella **partners**, i partners sono i fornitori di servizi e prodotti,
merchants, banche, games providers, ecc. ecc.

### cdc_utenti

La lista delle carte di credito associate agli utenti.

### conti_correnti_members

Lista dei conti correnti dei membri

### conti_correnti_partners

Lista dei conti correnti dei partners

### conti_correnti_utenti

Lista dei conti correnti degli utenti

### costs_type

Elenco dei tipi di costi che possono essere associati all'attività
casinò

### costs_casino

Qui vengono memorizzati i costi del casinò fra le altre cose la tabella
prevede il vincolo verso i **partner** (ossia un costo è associato ad un
partner) ed un vincolo verso la **costs_type**.

### currency

Lista delle principali valute utilizzate: €, \$, £, ¥ (tabella
precaricata)

### ruoli

Lista dei possibili ruoli che gli iscritti al sito possono avere

### ruoli_members

Lista dei ruoli associati ai membri

### ruoli_partners

lista dei ruoli associati ai partner

### ruoli_users

lista dei ruoli associati agli utenti finali

### services

Lista dei servizi offerti dalla piattaforma

### products

Lista dei prodotti (finanziari, no casinò) associati ad un servizio

### tipi_movimento

tipi di movimenti finanziari previsti dal sistema

### users

In questa tabella vengono memorizzati i dati deglli utenti iscritti al
portale. Dato che ci possono essere 2 tipologie di utenti: **privati**
ed **aziende**, in questa tabella vengono memorizzati solo i dati
indipendenti dalla tipologia dell'utente, come ad esempio: username,
email, password (o meglio hash della password), tipologia d'utente,
nazionalità, ed altri campi operativi come il **num_min_doc** che è il
numero minimo di documenti che l'utente deve fornire per iscriversi.

Tutte altre informazioni (specifiche della tipologia di utente vengono
memorizzate nelle tabelle di dettaglio: **dett_user_azienda**,
**dett_user_privato**.

### user_log

registrazione delle attività svolte dall'utente:

- id_user: id dell'utente

- action: azione eseguita

- date: data dellìoperazione al millisecondo

- ip: ip d provenienza dell'utente

### dett_user_azienda

In questa tabella sono memorizzati alcuni dei dati utente, ossia quei
dati specifici di un utente di tipo aziendale. Come ad esempio: nome
dell'azienda, sede legale, partita IVA, referente, indirizzo web
dell'azienda.

### dett_user_privato

In questa tabella sono memorizzati alcuni dei dati utente, ossia quei
dati specifici di un utente di tipo privato cittadino. Come ad esempio:
nome, cognome, codice fiscale, anno di nascita e genere sessuale.

### user_documenti

In questa tabella vengono salvate le immagini della scansione dei
documenti richiesti all'utente.

### users_services

Questa è una tabella associativa che mette in relazione gli utenti con i
servizi finanziari offerti dal sistema. Ogni volta che un utente si
regista ad un nuovo servizio l'operazione viene registrata qui.

### user_service_products

In questa tabella vengono registrati i prodotti (non casinò) del
servizio sottoscritto che l'utente ha attivato o sta usando.

### users_movments

Tutti i movimenti finanziari che l'utente fa nei prodotti sottoscritti
devono essere memorizzati in questa tabella.

### users_members

In questa tabella vengono associati gli id della tabella users_services
ai membri che li seguono, con relativa data di inizio e fine relazione,
se manca la data di fine relazione l'associazione viene considerata
attiva, altrimenti chiusa, come mostrato dalla colonna: **active**.

### game_category

In questa tabella devono essere registrate le varie tipologie di giochi
che il casino dell'azienda a disposizione per far giocare i propri
utenti.

### game_inventory

Questa è la lista completa dei gioci presenti nel casinò, con tutte le
caratteristiche che li contraddistinguono, per poter essere inserito in
una questa lista occorre che la categoria del gioco sia una di quelle
presenti in **game_category**.

### jackpots

In questa tabella sono memorizzati tutti i jackpot attivi nel casinò con
tutte le loro caratteristiche:

- **jp_type**. Tipo di jackpot (\'MINIMAL\',\'MEDIUM\',\'MAJOR\')

- **last_update**: ultimo aggiornamento effettuato

- **jp_actual_value**: valore attuale del jeckpot

- **jp_base_value**: valore di partenza del jeckpot

- **jp_max_value**: valore massimo a cui può arrivare

### jackpots_hist_logs

Ogni operazione che avviene sul jackpot viene storicizzata in questa
tabella

### languages

Nome esteso della lingua associata al codice ISO (sia di 2 che di 3
caratteri).

[Al momento non è previsto l'uso, quindi non è stata
precaricata]{.mark}.

### log

Tabella per la storicizzazione dei log operativi nel caso si decidesse
di memorizzarli sul DB.

### login_attempts

Logging degli accessi al sistema da parte degli utenti.

### mail_templates

In questa tabella vengono memorizzati i template delle mail che
l'azienda vuole mandare ai propri clienti e/partners. Le colonne
peculiari della tabella sono:

- template_name: nome del template

- lang: linguaggio usato

- country: la nazione con cui filtrare gli utenti a cui mandare la email

- mail_body: skeleton de corpo del messagio da inviare, da customizzare
  al momento dell'invio

- subject: skeleton del soggetto della mail

### mails_tobe_sent

[Tabella ereditata dal vecchio sistema su cui si deve ancora decidere
come utlizzare o trasformare, difatti fa riferimento solo ai membri
mentre tutte e 3 le tipologie di utente dovrebbero poter essere
contattate]{.mark}

### members

Lista dei membri con cui l'azienda collabora, possono essere sia
affiliati che agenti. Le colonne della tabella che necessitano di un
commetto sono le seguenti:

- [id_service: id del servizio a cui il membro è associato]{.mark}

- id_brand: id del brend a cui il membro è associato

- level: indicatore del livello d'importanza del membro

- memeber_type: \'affiliate\',\'agent\',\'portal\',\'internal\'

- email_convalid_code: codice di convalida x l'email

- reward_share: percentuale di guadagno

- afftag: link tracciato per associare la registrazione di un utente
  tramite banner

- minimum_fee_partner: Quota minima che il membro cede per il partner

- minimum_fee_merchantr: Quota minima che il membro cede per il
  merchantr

- jackpot_affilation: indica se il membro partecipa o meno al jackpot

- min_depot: deposito minimo consentito

- max_depot: deposito massimo consentito

- min_withdrawal: prelievo minimo consentito

- max_withdrawal: prelievo massimo consentito

### member_anagraphic

In questa tabella vengono salvati i dati anagrafici dei membri

### member_payments

In questa tabella vengono salvati tutti dati relativi alla
movimentazione dati relativi all'affiliato, è una tabella presa dal
vecchio sistema, [che deve ancora essere analizzata per capire come
integrarla nel nuovo sistema]{.mark}.

### member_property

In questa tabella vengono memorizzati eventuali sconti che in un
determinato periodo di tempo il membro ha diritto:

- bonus_deduction

- minimum_fee

- startdate

- deadline

### member_specs

Altra tabella con dati specifici dei membri:

- minimum_fee

- perc_deposit_cost

- fix_deposit_cost

- perc_withdraw_cost

- fix_withdraw_cost

- transfer_negative

- currency

### partners

Questa è la tabella in cui vengono salvate le informazioni dei parterner
(fornitori o merchant), essendo questi delle aziende, la lista delle
colonne rispecchia quelle della tabella **dett_user_azienda** con in più
le colonne:

- min_depot

- max_depot

- min_withdrawal

- max_withdrawal

### partners_property

Vale quanto detto per la tabella **member_property**

### partner_specs

Vale quanto detto per la tabella **member_specs**

### players

Quando un utente si iscrive al casinò il suo ID viene ricopiato qui e
tutti i dati dell'utente relativi al gioco fanno riferimento a questa
tabella, come appunto i vincoli relativi ai massimali o alle sospesioni:

- game_block_length: durata del blocco

- start_block_date: data di inzio del blocco

- max_daily_loss: entita massima di perdita **giornaliera** consentita

- max_weekly_loss: entita massima di perdita **settimanale** consentita

- max_monthly_loss: entita massima di perdita **mensile** consentita

### player_balance_history

In questa tabella vengono memorizzati tutti i movimenti contabili del
giocatore:

- at: data al millisecondo dell'operazione

- amount: quantità movimentata

- real_balance: bilancio del giocatore, senza bouns

- bonus_balance: entità del bonus

- cashback: cashback del giocatore

- loyalty: livello di fedeltà concesso

### player_bonus

In questa tabella vengono segnati tutti i bonus assegnati ad un utente,
di seguito la lista delle colonne:

- id_player: id del giocatore

- id_bonus: id del bonus

- bonus_balance: [Antonio qui?]{.mark}

- balance_was: valore percedente

- amount: ammontare del bonus

- balance_is: valore calcolato in automatico da sistema sommando
  **balance_was** con **amount**

- turnover: [Antonio qui?]{.mark}

- assigned: data di assegnamento del bonus

- deadline: data di scandenza de bonus

- initial_bonus_value: valore iniziale

- accepted: [Antonio qui?]{.mark}

### player_cashback

Qui vengono memorizzati i valori relativi al cashback

- id_player: id del giocatore

- deposit_amount: ammonare del deposito

- percentage: [di cosa? Del chashback?]{.mark}

- cashback: importo del cashback

- already_redeemed: [?????]{.mark}

- status: [?????]{.mark}

- 

### player_cashback_history

contiene i dati storici del cashback dell'utente

### players_casino_movements

In questa tabella viene memorizzata ogni singola giocata effettuata da
ogni singolo giocatore, lista delle colonne:

- id_player: id del giocatore

- id_game: id della macchina sui cui il gocatore sta giocando

- op_type: tipo di operazione
  \'BET\',\'WIN\',\'TRANFERT-IN\',\'TRANFERT-OUT\',\'ADJUSTMENT\',\'BONUS\'

- op_state: \'CONFIRMED\',\'ROLLEDBACK\',\'CANCELED\'

- at: data dell'operazione al millisecondo

- transaction_id: id della transazione economica

- round_id: [???]{.mark}

- balance_was: bilancio del giocatore prima della giocata

- amount: ammontare della giocata

- balance_is: valore attuale calcolato automaticamente del sistema

- currency: valuta della giocata

- msg: eventuale messaggio da associare al dato

### players_data

### players_deposit_transaction

### provider_game_cost

### report_adjustment

### report_bonus

### reward_plans

### visitors

### visitors_steps

### historicalnotes
