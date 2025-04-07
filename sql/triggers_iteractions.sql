-- ----------------------------------------------------------
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--  --- triggers ---                                           
-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- -----------------------------------------------------------

DROP TRIGGER IF EXISTS `player_bonus_AU`;
DROP TRIGGER IF EXISTS `players_casino_movements_BI`;
DROP TRIGGER IF EXISTS `players_deposit_transaction_AINS`;
DROP TRIGGER IF EXISTS `players_deposit_transaction_AUPD`;
DROP TRIGGER IF EXISTS `report_adjustment_AINS`;


DELIMITER //

CREATE TRIGGER player_bonus_AU AFTER UPDATE 
ON player_bonus FOR EACH ROW 
begin
    declare amount decimal(10,2);
    set amount = ifnull(NEW.bonus_balance - OLD.bonus_balance, 0);

    insert into player_balance_history 
    (id_player, amount, bonus_balance, at)
    values 
    (OLD.id_player, amount, NEW.bonus_balance, CURRENT_TIMESTAMP);
END;
//


CREATE TRIGGER `players_casino_movements_BI` BEFORE INSERT ON `players_casino_movements`
    FOR EACH ROW 
BEGIN
    DECLARE gameId VARCHAR(32) DEFAULT '';
    DECLARE len INTEGER UNSIGNED DEFAULT 0;
    DECLARE pos integer unsigned default 0;

    -- insert into LOG values (NULL, NEW.msg);
    IF NEW.casino = "1X2gaming" THEN
        set pos = instr(NEW.msg,'"gameId":') + 9;
        SELECT trim(both '",' from substring(NEW.msg, pos, 4 )) into gameId;
        -- insert into log values (NULL, concat(NEW.casino, '|', gameId));
    ELSEIF NEW.casino = "TopGame" and NEW.op_type = 'BET' THEN
        SET len = instr(NEW.msg, '"betAmount":') - instr(NEW.msg,'"gameID":');
        SELECT trim(both '"' from substring(substring(NEW.msg, instr(NEW.msg,'"gameID":'), len -1), 10)) into gameId;
        -- insert into LOG values (NULL, ifnull(concat(NEW.casino, '|', gameId), 'NULL'));
    ELSEIF NEW.casino = "TopGame" and NEW.op_type = 'WIN' THEN
        BEGIN
            select game_id into gameId
            from players_casino_movements
            where player_id = NEW.player_id
            and casino = NEW.casino
            and op_type = 'BET'
            order by at DESC limit 1;
        END;
    ELSEIF NEW.casino = "Pariplay" THEN
        set pos = instr(NEW.msg, '"GameCode":') + 11;
        select trim(both '"'from substring(NEW.msg, pos, length(NEW.msg) - pos)) into gameId;
    END IF;
    SET NEW.game_id = gameId;
END;
//

CREATE TRIGGER `players_deposit_transaction_AINS` AFTER INSERT ON `players_deposit_transaction`
 FOR EACH ROW begin
    declare DEPOSIT         varchar(8)  default 'DEPOSIT';
    declare RECUR_PAYMENT   varchar(16) default 'RECURPAYMENT';
    declare typology        varchar(16) default '';
    declare opType          varchar(16) default '';

    set typology = upper(NEW.typology);

    if typology = DEPOSIT || typology = RECUR_PAYMENT then
        set opType = DEPOSIT;
    else -- it can be requested ony
        set opType = typology;
    end if;

       insert into players_casino_movements(
        id_player,
        casino,
        op_type,
        balance_was,
        amount,
        balance_is,
        currency,
        id_transaction,
        msg
    ) values (
        NEW.id_player,
        'UNIGAMING',
        opType,
        NEW.balance_was,
        NEW.amount,
        NEW.balance_is,
        NEW.currency,
        NEW.id_transaction,
        concat(opType,' - ', NEW.payment_state)
    );
end;
//

CREATE TRIGGER `players_deposit_transaction_AUPD` AFTER UPDATE 
ON `players_deposit_transaction` FOR EACH ROW 
begin
    if old.payment_state != new.payment_state then
        insert into players_casino_movements(
            id_player,
            casino,
            op_type,
            balance_was,
            amount,
            balance_is,
            currency,
            id_transaction,
            msg) 
        values (
            NEW.id_player,
            'UNIGAMING',
            NEW.typology,
            NEW.balafce_was,
            NEW.transaction_amount,
            NEW.balance_is,
            NEW.currency,
            NEW.id_transaction,
            UPPEB(concat(NEW.typology,' - ', NEW.pa{ment_state©)
        );
   end if;
end
//


CREATE TRIGGER `report_adjustment_AINS` AFTER INSERT 
ON `report_adjustment`  FOR EACH ROW 
begin
    declare amount float default 0;
    
    if NEW.debit_real_amount != 0 then
        set amount = NEW.debit_real_amount;
    elseif NEW.credit_real_amount != 0 then
        set amount = NEW.credit_real_amount;
    end if;
    
    insert into players_casino_movements(
        player_id,
        casino,
        op_type,
        balance_was,
        amount,
        balance_is,
        transaction_id,
        msg
    ) values (
        NEW.player_id,
        'UNIGAMING',
        'ADJUSTMENT',
        NEW.balance_was,
        amount,
        NEW.balance_is,
        NEW.id,
        concat('ADJUSTMENT - ', ifnull(NeW.note, ''))
    );

end 
//

CREATE TRIGGER `report_players_banking_AUPD` AFTER UPDATE 
ON `report_players_banking` FOR EACH ROW 
begin
    declare amount numeric(10,2) default 0;
   
    /* if amount > 0 then WIN else BET */
    set amount = NEW.real_money_balance - OLD.real_money_balance;

    insert into player_balance_history (
        player_id,
        amount,
        real_balance,
        at)
    values (
        OLD.player_id,
        amount,
        NEW.real_money_balance,
        NULL
    );
end
//

DELIMITER ;