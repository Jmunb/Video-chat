--
-- Structure table `peer_chat`
--

DROP TABLE IF EXISTS `peer_chat`;
CREATE TABLE IF NOT EXISTS `peer_chat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from` varchar(255) NOT NULL DEFAULT '',
  `to` varchar(255) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `sent` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `recd` int(10) unsigned NOT NULL DEFAULT '0',
  `sex` varchar(5) NOT NULL,
  `stratus` text NOT NULL,
  `action` int(11) NOT NULL DEFAULT '0',
  `online` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `from` (`from`),
  KEY `to` (`to`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure  table `peer_userstatus`
--

DROP TABLE IF EXISTS `peer_userstatus`;
CREATE TABLE IF NOT EXISTS `peer_userstatus` (
  `username` varchar(100) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;