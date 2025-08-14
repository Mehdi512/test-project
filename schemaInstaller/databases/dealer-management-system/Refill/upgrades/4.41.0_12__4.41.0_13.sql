INSERT INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
    ('?(Len)/?(*)/?(ElementChoiceList)/group(CompleteGroup)/w(Window)/langmap(StringResource)','creator_header=Invoice creators\r\nline_count=Lines\r\n',NOW(),'?(RefillAdmin)',NOW(),NOW(),NOW())

ON DUPLICATE KEY UPDATE `data` = CONCAT('creator_header=Invoice creators\r\n',data),  `last_modified` = NOW();