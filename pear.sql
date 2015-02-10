-- phpMyAdmin SQL Dump
-- version 4.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 10, 2015 at 11:34 AM
-- Server version: 5.5.41-0+wheezy1
-- PHP Version: 5.4.36-0+deb7u3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `pear`
--
CREATE DATABASE IF NOT EXISTS `pear` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `pear`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`pear`@`localhost` PROCEDURE `FindLoop`(IN id_target_trader INT)
PROC:BEGIN
	
	
	declare the_rows int default 0;
	declare flag int default 0;
	declare trans_desc varchar(255);
	declare transactions_for_adjustment varchar(255);
	declare transaction_for_adjustment int;
	declare amount_of_money double;
	declare transaction_val double;
	declare remainder double;
	declare counter int; 
	declare counter2 int;
	declare nTraders int default 1;
  
	
	truncate paths;
  
	
	insert into `paths` 
	select null, `id_trader_from`,`id_trader_to`, sum(`amount`), sum(`amount`),
		concat(`id_trader_to`,",", `id_trader_from`), 
		group_concat(`id_transaction` separator '|'), 1
	from transactions t 
	where t.`id_trader_to` = id_target_trader
	and t.`amount` > 0
	group by `id_trader_to`, `id_trader_from`;
	
	
  
	
	while (flag < 1) do
  
		
		insert into `paths`
		select null, n.`id_trader_from`, n.`id_trader_to`, n.`amount`, n.`total_amount`,
			n.`path_description`, n.`transaction_description`, n.`n_trades`
		from nexttrades n
		left join paths p 
		on n.`id_trader_to` = p.`id_trader_to`
		and n.`id_trader_from` = p.`id_trader_from`
		where p.`id_trader_from` is null 
		and p.`id_trader_to` is null
		and (n.`id_trader_from` != id_target_trader or n.n_trades != 2);
		
		
		set the_rows = ROW_COUNT();
		if the_rows = 0 then leave PROC;
		end if;
	
		
		select count(*) from `paths` WHERE `id_trader_from`= id_target_trader into flag;
	
		
		set counter = counter + 1;
		if counter = nTraders then leave PROC;
		end if;
	end while;
  
	
	insert into loops 
	select null, id_target_trader, `amount`, `total_amount`, `path_description`, `transaction_description`, `n_trades`
	from paths 
	where `id_trader_from`= id_target_trader;

	
	select `transaction_description`, `amount` from loops 
		where `id_loop`= LAST_INSERT_ID() into trans_desc, amount_of_money;
		
	
	set counter = 1;
	select SPLIT_STR(trans_desc, ",", counter) into transactions_for_adjustment;
	
	
	
	
  
	
	outerloop: while (transactions_for_adjustment != "") do
	
		
		set counter2 = 1;
		select SPLIT_STR(transactions_for_adjustment, "|", counter2) into transaction_for_adjustment;

		
		set remainder = amount_of_money;
		
		
		innerloop: while (transaction_for_adjustment != "") do
		
			
			select `amount` into transaction_val from `transactions` 
				where `id_transaction` = transaction_for_adjustment;
		
			
			if transaction_val >= remainder then
			
				
				update transactions set `amount` = (`amount` - remainder)  
					where `id_transaction` = transaction_for_adjustment;
					
				
				insert into log values (transactions_for_adjustment, transaction_for_adjustment, 
					transaction_val, remainder, counter, counter2, 'tv>r');
				
				
				leave innerloop;	
			else
			
				
				update transactions set `amount` = 0 
					where `id_transaction` = transaction_for_adjustment;

				
				set remainder = remainder - transaction_val; 
				
				
				insert into log values (transactions_for_adjustment, transaction_for_adjustment, 
					transaction_val, remainder, counter, counter2, 'tv<r');
			end if;
			
			
			set counter2 = counter2 + 1;
			select SPLIT_STR(transactions_for_adjustment, "|", counter2) into transaction_for_adjustment;
			
		end while;
  	
		
  		set counter = counter + 1;
  		select SPLIT_STR(trans_desc, ",", counter) into transactions_for_adjustment;
	end while;
  
END$$

CREATE DEFINER=`pear`@`localhost` PROCEDURE `InsertTransaction`(IN barter_transaction_id INT)
BEGIN

	
	
	
	declare trader_to int;
	
	
	insert into `transactions`
	select 
		null,
		`tbl_transactions`.`trans_id` AS id_barter_transaction,
		`associations`.`trader_id` AS `id_trader_from`,
		t.`id_user` AS `id_trader_to`,
		`tbl_transactions`.`trans_price` AS `amount` 
	from `tbl_transactions` 
		join `associations` on `associations`.`employee_card_id` = `tbl_transactions`.`consumer_id`
		join `traders` t on `tbl_transactions`.`trader_id` = t.`id_card`
	where `tbl_transactions`.`trans_id` = barter_transaction_id
	union (
		select 
			null, 
			`tbl_transactions`.`trans_id` AS id_barter_transaction,
			tt.`id_user` as id_trader_from, 
			t.`id_user` as id_trader_to, 
			`tbl_transactions`.`trans_price` as amount
		from `tbl_transactions` 
			join `traders` t on `tbl_transactions`.`trader_id` = t.`id_card`
			join `traders` tt on `tbl_transactions`.`consumer_id` = tt.`id_card`
		where `tbl_transactions`.`trans_id` = barter_transaction_id
	);
	
	
	if ROW_COUNT() > 0 then
	
		
		select `id_trader_to` from `transactions` where `id_transaction` = LAST_INSERT_ID() into trader_to;
	
		
		call FindLoop(trader_to);
		
	end if;

END$$

CREATE DEFINER=`pear`@`localhost` PROCEDURE `ResetTransactions`()
BEGIN



truncate transactions;



INSERT INTO `transactions` (`id_transaction`, `id_trader_from`, `id_trader_to`, `amount`) VALUES

(1, 1, 2, 100),

(2, 2, 3, 70),

(3, 3, 6, 20),

(4, 3, 4, 40),

(5, 4, 8, 50),

(6, 4, 7, 10),

(7, 4, 5, 30),

(8, 5, 1, 20);



END$$

--
-- Functions
--
CREATE DEFINER=`pear`@`localhost` FUNCTION `SPLIT_STR`(x VARCHAR(255), delim VARCHAR(12), pos INT) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),delim, '')$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `associations`
--
CREATE TABLE IF NOT EXISTS `associations` (
`assoc_id` int(11)
,`employee_id` int(11)
,`employee_card_id` varchar(100)
,`trader_id` int(11)
,`trader_card_id` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `bankstatement`
--
CREATE TABLE IF NOT EXISTS `bankstatement` (
`id_trader` int(11)
,`incomings` double
,`outgoings` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `income`
--
CREATE TABLE IF NOT EXISTS `income` (
`id_trader` int(11)
,`incomings` double
);

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE IF NOT EXISTS `log` (
  `trades` int(11) NOT NULL,
  `trader` int(11) NOT NULL,
  `transaction_val` int(11) NOT NULL,
  `loop_val` int(11) NOT NULL,
  `c1` int(11) NOT NULL,
  `c2` int(11) NOT NULL,
  `note` varchar(4) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `loopanalysis`
--
CREATE TABLE IF NOT EXISTS `loopanalysis` (
`Trades Per Loop` int(11)
,`Occurrences` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `loops`
--

CREATE TABLE IF NOT EXISTS `loops` (
  `id_loop` int(11) NOT NULL,
  `id_looped_trader` int(11) NOT NULL,
  `amount` double NOT NULL,
  `total_amount` double NOT NULL,
  `path_description` varchar(255) NOT NULL,
  `transaction_description` varchar(255) NOT NULL,
  `n_trades` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `nexttrades`
--
CREATE TABLE IF NOT EXISTS `nexttrades` (
`id_trader_from` int(11)
,`id_trader_to` int(11)
,`amount` double
,`total_amount` double
,`n_trades` bigint(12)
,`path_description` varchar(267)
,`transaction_description` varchar(512)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `outgoings`
--
CREATE TABLE IF NOT EXISTS `outgoings` (
`id_trader` int(11)
,`outgoings` double
);

-- --------------------------------------------------------

--
-- Table structure for table `paths`
--

CREATE TABLE IF NOT EXISTS `paths` (
  `id_path` int(11) NOT NULL,
  `id_trader_from` int(11) NOT NULL,
  `id_trader_to` int(11) NOT NULL,
  `amount` double NOT NULL,
  `total_amount` double NOT NULL,
  `path_description` varchar(255) NOT NULL,
  `transaction_description` varchar(255) NOT NULL,
  `n_trades` int(11) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_associations`
--

CREATE TABLE IF NOT EXISTS `tbl_associations` (
  `assoc_id` int(11) NOT NULL,
  `trader_id` varchar(100) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `timestamp` varchar(255) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_barter_businesses`
--

CREATE TABLE IF NOT EXISTS `tbl_barter_businesses` (
  `b_id` int(11) NOT NULL,
  `b_name` varchar(255) NOT NULL,
  `b_type` enum('pub','design','food','organisation','florist','coffee') NOT NULL,
  `b_url` varchar(255) NOT NULL,
  `b_contact_number` varchar(255) NOT NULL,
  `b_contact_person` varchar(255) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customer_totals`
--

CREATE TABLE IF NOT EXISTS `tbl_customer_totals` (
  `total_id` int(11) NOT NULL,
  `trader_id` varchar(100) NOT NULL,
  `customer_id` varchar(100) NOT NULL,
  `customer_spend` float NOT NULL DEFAULT '0',
  `customer_points` int(11) NOT NULL DEFAULT '0',
  `customer_occurrences` int(11) NOT NULL DEFAULT '0',
  `updated_by` enum('web','mobile') NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM AUTO_INCREMENT=156 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_devices`
--

CREATE TABLE IF NOT EXISTS `tbl_devices` (
  `id` int(11) NOT NULL,
  `device_id` text NOT NULL,
  `user_rfid` varchar(255) NOT NULL,
  `sync_status` enum('IN_SYNC','OUT_OF_SYNC','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
  `last_login_timestamp` timestamp NULL DEFAULT NULL,
  `device_added_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_months`
--

CREATE TABLE IF NOT EXISTS `tbl_months` (
  `m_id` int(11) NOT NULL,
  `month_name` varchar(255) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_project_updates`
--

CREATE TABLE IF NOT EXISTS `tbl_project_updates` (
  `update_id` int(11) NOT NULL,
  `update_title` varchar(255) NOT NULL,
  `update_desc` varchar(255) NOT NULL,
  `update_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_redeems`
--

CREATE TABLE IF NOT EXISTS `tbl_redeems` (
  `redeem_id` int(11) NOT NULL,
  `trader_id` varchar(20) NOT NULL,
  `consumer_id` varchar(20) NOT NULL,
  `redeem_type` enum('mobile_nfc','mobile_qr','mobile_manual','web_manual') DEFAULT NULL,
  `consumer_points_deducted` int(11) NOT NULL,
  `redeem_timestamp` timestamp NULL DEFAULT NULL,
  `uploaded_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_trader_snapshots`
--

CREATE TABLE IF NOT EXISTS `tbl_trader_snapshots` (
  `p_id` int(11) NOT NULL,
  `trader_card_id` varchar(255) NOT NULL,
  `trader_local_spend` decimal(10,0) NOT NULL,
  `trader_non_local_spend` decimal(10,0) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions`
--

CREATE TABLE IF NOT EXISTS `tbl_transactions` (
  `trans_id` int(11) NOT NULL,
  `trader_id` varchar(20) DEFAULT NULL,
  `consumer_id` varchar(20) DEFAULT NULL,
  `consumer_type` enum('barter','local_non_barter','external') NOT NULL DEFAULT 'barter',
  `consumer_name` varchar(255) NOT NULL,
  `trans_lat` double DEFAULT NULL,
  `trans_lon` double DEFAULT NULL,
  `trans_type` enum('goods','services','both') DEFAULT NULL,
  `trans_origin` enum('mobile_nfc','mobile_qr','mobile_manual','web_manual') DEFAULT 'web_manual',
  `trans_price` double DEFAULT NULL,
  `trans_points` int(11) DEFAULT NULL,
  `trans_timestamp` timestamp NULL DEFAULT NULL COMMENT 'the transaction time',
  `upload_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions_backup`
--

CREATE TABLE IF NOT EXISTS `tbl_transactions_backup` (
  `trans_id` int(11) NOT NULL,
  `trader_id` varchar(20) DEFAULT NULL,
  `consumer_id` varchar(20) DEFAULT NULL,
  `consumer_type` enum('barter','local_non_barter','external') NOT NULL DEFAULT 'barter',
  `consumer_name` varchar(255) NOT NULL,
  `trans_lat` double DEFAULT NULL,
  `trans_lon` double DEFAULT NULL,
  `trans_type` enum('goods','services','both') DEFAULT NULL,
  `trans_origin` enum('mobile_nfc','mobile_qr','mobile_manual','web_manual') DEFAULT 'web_manual',
  `trans_price` double DEFAULT NULL,
  `trans_points` int(11) DEFAULT NULL,
  `trans_timestamp` timestamp NULL DEFAULT NULL COMMENT 'the transaction time',
  `upload_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE IF NOT EXISTS `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_card_id` varchar(20) NOT NULL,
  `user_gender` varchar(2) NOT NULL,
  `user_dob` year(4) NOT NULL,
  `user_postcode` varchar(10) NOT NULL,
  `user_ethical_pref` enum('environmental','social','economic','wellbeing') NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_type` enum('customer','business','organisation') NOT NULL,
  `user_character` varchar(255) NOT NULL,
  `user_employment_status` enum('unknown','employed','self_employed','student','unemployed') NOT NULL,
  `hear_about_us` varchar(255) NOT NULL,
  `business_name` varchar(255) NOT NULL,
  `business_postcode` varchar(10) NOT NULL,
  `is_trader` tinyint(1) NOT NULL,
  `is_manufacturer` tinyint(1) NOT NULL,
  `is_wholesaler` tinyint(1) NOT NULL,
  `is_retailer` tinyint(1) NOT NULL,
  `is_service` tinyint(1) NOT NULL,
  `is_fixed_trader` tinyint(1) NOT NULL,
  `is_non_fixed_trader` tinyint(1) NOT NULL,
  `user_business_lat` double NOT NULL,
  `user_business_lon` double NOT NULL,
  `goods_services` longtext NOT NULL,
  `statement` mediumtext NOT NULL,
  `imei` int(20) NOT NULL,
  `pass_key` varchar(100) NOT NULL,
  `user_pass` varchar(100) NOT NULL,
  `linkedin_token` varchar(255) NOT NULL,
  `linkedin_expires_in` int(11) NOT NULL,
  `linkedin_expires_at` int(11) NOT NULL,
  `linkedin_id` varchar(255) NOT NULL,
  `linkedin_headline` varchar(255) NOT NULL,
  `linkedin_industry` varchar(255) NOT NULL,
  `linkedin_img` varchar(255) NOT NULL,
  `linkedin_summary` text NOT NULL,
  `linkedin_profile_url` varchar(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_account_status` tinyint(1) NOT NULL DEFAULT '0',
  `last_updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_action` varchar(255) NOT NULL DEFAULT 'account_created',
  `logged_in` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_login` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=MyISAM AUTO_INCREMENT=579 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `traders`
--
CREATE TABLE IF NOT EXISTS `traders` (
`id_user` int(11)
,`id_card` varchar(20)
,`name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE IF NOT EXISTS `transactions` (
  `id_transaction` int(11) NOT NULL,
  `id_barter_transaction` int(11) NOT NULL,
  `id_trader_from` int(11) NOT NULL,
  `id_trader_to` int(11) NOT NULL,
  `amount` double NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure for view `associations`
--
DROP TABLE IF EXISTS `associations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `associations` AS (select `a`.`assoc_id` AS `assoc_id`,`u`.`user_id` AS `employee_id`,`a`.`user_id` AS `employee_card_id`,`uu`.`user_id` AS `trader_id`,`a`.`trader_id` AS `trader_card_id` from ((`tbl_associations` `a` join `tbl_users` `u` on((`u`.`user_card_id` = `a`.`user_id`))) join `tbl_users` `uu` on((`uu`.`user_card_id` = `a`.`trader_id`))) where (`u`.`user_id` <> `uu`.`user_id`));

-- --------------------------------------------------------

--
-- Structure for view `bankstatement`
--
DROP TABLE IF EXISTS `bankstatement`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `bankstatement` AS select `i`.`id_trader` AS `id_trader`,`i`.`incomings` AS `incomings`,`o`.`outgoings` AS `outgoings` from (`income` `i` join `outgoings` `o` on((`i`.`id_trader` = `o`.`id_trader`)));

-- --------------------------------------------------------

--
-- Structure for view `income`
--
DROP TABLE IF EXISTS `income`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `income` AS select `transactions`.`id_trader_to` AS `id_trader`,sum(`transactions`.`amount`) AS `incomings` from `transactions` group by `transactions`.`id_trader_to`;

-- --------------------------------------------------------

--
-- Structure for view `loopanalysis`
--
DROP TABLE IF EXISTS `loopanalysis`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `loopanalysis` AS select `loops`.`n_trades` AS `Trades Per Loop`,count(`loops`.`n_trades`) AS `Occurrences` from `loops` group by `loops`.`n_trades`;

-- --------------------------------------------------------

--
-- Structure for view `nexttrades`
--
DROP TABLE IF EXISTS `nexttrades`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `nexttrades` AS select `t`.`id_trader_from` AS `id_trader_from`,`t`.`id_trader_to` AS `id_trader_to`,least(sum(`t`.`amount`),`p`.`amount`) AS `amount`,(sum(`t`.`amount`) + `p`.`total_amount`) AS `total_amount`,(`p`.`n_trades` + 1) AS `n_trades`,concat(`p`.`path_description`,',',`t`.`id_trader_from`) AS `path_description`,concat(`p`.`transaction_description`,',',convert(group_concat(`t`.`id_transaction` separator '|') using utf8)) AS `transaction_description` from (`paths` `p` join `transactions` `t` on(((`p`.`id_trader_from` = `t`.`id_trader_to`) and (`t`.`amount` > 0)))) group by `t`.`id_trader_from`,`t`.`id_trader_to`;

-- --------------------------------------------------------

--
-- Structure for view `outgoings`
--
DROP TABLE IF EXISTS `outgoings`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `outgoings` AS select `transactions`.`id_trader_from` AS `id_trader`,sum(`transactions`.`amount`) AS `outgoings` from `transactions` group by `transactions`.`id_trader_from`;

-- --------------------------------------------------------

--
-- Structure for view `traders`
--
DROP TABLE IF EXISTS `traders`;

CREATE ALGORITHM=UNDEFINED DEFINER=`pear`@`localhost` SQL SECURITY DEFINER VIEW `traders` AS select `tbl_users`.`user_id` AS `id_user`,`tbl_users`.`user_card_id` AS `id_card`,`tbl_users`.`business_name` AS `name` from `tbl_users` where (`tbl_users`.`user_type` = 'business');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `loops`
--
ALTER TABLE `loops`
  ADD PRIMARY KEY (`id_loop`), ADD KEY `id_looped_trader` (`id_looped_trader`);

--
-- Indexes for table `paths`
--
ALTER TABLE `paths`
  ADD PRIMARY KEY (`id_path`), ADD KEY `id_trader_to` (`id_trader_to`), ADD KEY `id_trader_from` (`id_trader_from`);

--
-- Indexes for table `tbl_associations`
--
ALTER TABLE `tbl_associations`
  ADD PRIMARY KEY (`assoc_id`), ADD UNIQUE KEY `assoc` (`trader_id`,`user_id`);

--
-- Indexes for table `tbl_barter_businesses`
--
ALTER TABLE `tbl_barter_businesses`
  ADD PRIMARY KEY (`b_id`);

--
-- Indexes for table `tbl_customer_totals`
--
ALTER TABLE `tbl_customer_totals`
  ADD PRIMARY KEY (`total_id`), ADD UNIQUE KEY `customer_id` (`customer_id`);

--
-- Indexes for table `tbl_months`
--
ALTER TABLE `tbl_months`
  ADD PRIMARY KEY (`m_id`);

--
-- Indexes for table `tbl_project_updates`
--
ALTER TABLE `tbl_project_updates`
  ADD PRIMARY KEY (`update_id`);

--
-- Indexes for table `tbl_redeems`
--
ALTER TABLE `tbl_redeems`
  ADD PRIMARY KEY (`redeem_id`);

--
-- Indexes for table `tbl_trader_snapshots`
--
ALTER TABLE `tbl_trader_snapshots`
  ADD PRIMARY KEY (`p_id`);

--
-- Indexes for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD PRIMARY KEY (`trans_id`);

--
-- Indexes for table `tbl_transactions_backup`
--
ALTER TABLE `tbl_transactions_backup`
  ADD PRIMARY KEY (`trans_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id_transaction`), ADD KEY `id_trader_from` (`id_trader_from`), ADD KEY `id_trader_to` (`id_trader_to`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `loops`
--
ALTER TABLE `loops`
  MODIFY `id_loop` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `paths`
--
ALTER TABLE `paths`
  MODIFY `id_path` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `tbl_associations`
--
ALTER TABLE `tbl_associations`
  MODIFY `assoc_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `tbl_barter_businesses`
--
ALTER TABLE `tbl_barter_businesses`
  MODIFY `b_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `tbl_customer_totals`
--
ALTER TABLE `tbl_customer_totals`
  MODIFY `total_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=156;
--
-- AUTO_INCREMENT for table `tbl_months`
--
ALTER TABLE `tbl_months`
  MODIFY `m_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `tbl_project_updates`
--
ALTER TABLE `tbl_project_updates`
  MODIFY `update_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_redeems`
--
ALTER TABLE `tbl_redeems`
  MODIFY `redeem_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `tbl_trader_snapshots`
--
ALTER TABLE `tbl_trader_snapshots`
  MODIFY `p_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=37;
--
-- AUTO_INCREMENT for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  MODIFY `trans_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `tbl_transactions_backup`
--
ALTER TABLE `tbl_transactions_backup`
  MODIFY `trans_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=579;
--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id_transaction` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=55;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
