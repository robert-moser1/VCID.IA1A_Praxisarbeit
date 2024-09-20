USE ps5_games;
-- MariaDB dump 10.19  Distrib 10.11.4-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: ps5_games
-- ------------------------------------------------------
-- Server version	11.5.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_token`
--

DROP TABLE IF EXISTS `access_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `access_token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_token`
--

LOCK TABLES `access_token` WRITE;
/*!40000 ALTER TABLE `access_token` DISABLE KEYS */;
INSERT INTO `access_token` VALUES
(2,1,'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MjY0MzYyODYsImlhdCI6MTcyNjQzMjY4Nn0.08aVU4pffr-23PLU2X8CUPuyNcgsE7uud19cq8pKIYI','2024-09-15 20:38:06');
/*!40000 ALTER TABLE `access_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `user_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id_comment` (`user_id`),
  KEY `idx_game_id_comment` (`game_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favorite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id_favorite` (`user_id`),
  KEY `idx_game_id_favorite` (`game_id`),
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `rating` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` VALUES
(1,'The Last of Us Part II','Ein emotional intensives Abenteuer, das die Geschichte von Ellie weiterführt und die Spieler durch eine post-apokalyptische Welt voller Gefahren und moralischer Dilemmata führt. Dieses Spiel bietet nicht nur packende Action, sondern auch eine tiefgreifende Erzählung über Verlust, Rache und Vergebung. Die Beziehungen zwischen den Charakteren sind ebenso komplex wie berührend, und die dichte Atmosphäre lässt den Spieler tief in die bedrückende und zugleich wunderschöne Welt eintauchen. Mit seinen fortschrittlichen Animationen, der realistischen Darstellung von Emotionen und einer lebendigen Umgebung setzt „The Last of Us Part II“ neue Maßstäbe für das Storytelling in Videospielen.',9.5),
(2,'God of War Ragnarök','Die Fortsetzung des gefeierten „God of War“ aus dem Jahr 2018 nimmt Kratos und seinen Sohn Atreus auf eine noch epischere Reise durch die nordische Mythologie mit. Dieses Spiel verbindet meisterhaft actiongeladene Kämpfe mit einer berührenden Vater-Sohn-Beziehung und einem tieferen Einblick in das Schicksal, die Götter und die kommende Ragnarök. Die Spieler erkunden lebendige, detaillierte Welten voller Geheimnisse, lösen anspruchsvolle Rätsel und treffen auf beeindruckende Gegner. Das Gameplay ist dynamisch und herausfordernd, und die Erzählung bleibt durch ihre Themen von Identität, Familie und Schicksal bis zum Schluss fesselnd.',9.7),
(3,'Demon\'s Souls','Dieses Remake des Kultklassikers von FromSoftware ist nicht nur eine visuelle Meisterleistung, sondern bleibt auch ein Paradebeispiel für herausforderndes Gameplay. Jeder Kampf ist eine Prüfung, die Geduld, Präzision und Strategie erfordert. Die dichte, düstere Atmosphäre, kombiniert mit einem unbarmherzigen Schwierigkeitsgrad, zieht die Spieler in eine mysteriöse Welt voller Schrecken und Rätsel. Durch die hervorragende technische Umsetzung auf der PS5 mit beeindruckenden Lichteffekten, detailreichen Umgebungen und flüssigen Animationen wird dieses Remake zu einem der beeindruckendsten Titel der neuen Konsolengeneration.',9.3),
(4,'Spider-Man: Miles Morales','Diese Fortsetzung zu „Marvel\'s Spider-Man“ versetzt die Spieler in die Rolle von Miles Morales, einem jungen Helden mit seinen eigenen einzigartigen Kräften. Mit einer packenden Handlung, die Themen wie Verantwortung, Erbe und Selbstfindung erkundet, entfaltet sich die Geschichte in einer visuell beeindruckenden Open World. New York wird durch die fortschrittliche Grafik und die Nutzung der PS5-Hardware lebendig, und die nahtlosen Übergänge zwischen Zwischensequenzen und Gameplay sorgen für ein filmisches Erlebnis. Die agilen, spektakulären Kampftechniken von Miles sowie die neuen Fähigkeiten, wie die Unsichtbarkeit und bioelektrische Schläge, heben das Gameplay auf ein neues Level.',9.2),
(5,'Ratchet & Clank: Rift Apart','Ein actiongeladenes Abenteuer, das von den Möglichkeiten der PS5-Hardware profitiert und nahtlose Übergänge zwischen verschiedenen Dimensionen ermöglicht. Die Spieler erleben rasante Kämpfe, springen durch Risse zwischen verschiedenen Welten und nutzen ein riesiges Arsenal an verrückten Waffen. „Rift Apart“ beeindruckt mit seiner technischen Brillanz, den kreativen Level-Designs und der flüssigen Action. Gleichzeitig bleibt das Spiel seiner humorvollen und charmanten Erzählweise treu, während es neue Charaktere wie Rivet einführt und das Universum von Ratchet & Clank weiter ausbaut.',9.1),
(6,'Horizon Forbidden West','In dieser atemberaubenden Fortsetzung von „Horizon Zero Dawn“ nimmt Aloy ihre Reise in einer offenen, post-apokalyptischen Welt wieder auf, in der Maschinenwesen die Erde beherrschen. „Forbidden West“ erweitert das Gameplay mit neuen Mechaniken, darunter Unterwassererkundungen und erweiterte Kletterfähigkeiten. Die Geschichte bietet tiefe Einblicke in die Vergangenheit der Menschheit und die Ursprünge der Maschinenplage. Mit einer beeindruckenden Grafik, die sowohl die Umgebungen als auch die Charaktere detailliert darstellt, und einem abwechslungsreichen Kampfsystem, das Taktik und Geschick erfordert, bietet das Spiel ein packendes und immersives Erlebnis.',9.4),
(7,'Final Fantasy XVI','Das neueste Kapitel der berühmten „Final Fantasy“-Reihe entführt die Spieler in eine düstere, mittelalterliche Fantasy-Welt, die von politischen Intrigen, epischen Schlachten und mächtigen Beschwörungen geprägt ist. Mit seiner atemberaubenden Grafik und einem tiefgehenden, actionorientierten Kampfsystem setzt „Final Fantasy XVI“ auf dynamische Kämpfe, packende Bosskämpfe und ein immersives Storytelling. Die Welt von Valisthea, durchzogen von Konflikten und Magie, bietet eine epische Geschichte voller Verrat, Schicksal und dem Kampf um Freiheit.',9),
(8,'Returnal','Ein innovativer Roguelike-Shooter, der durch seine anspruchsvollen Mechaniken und eine dichte Atmosphäre hervorsticht. Die Spieler schlüpfen in die Rolle einer Astronautin, die auf einem fremden Planeten in einer Zeitschleife gefangen ist und sich mit jedem Tod neu beginnt. Die Kämpfe sind intensiv und fordern schnelle Reaktionen, während die prozedural generierten Level eine unvorhersehbare Herausforderung darstellen. Mit einer düsteren und geheimnisvollen Erzählung über Trauma und Wiedergeburt ist „Returnal“ sowohl narrativ als auch spielerisch einzigartig. Die dichte Soundkulisse und das ständige Gefühl der Isolation tragen zur packenden Atmosphäre bei.',8.9),
(9,'Deathloop','Ein revolutionärer Ego-Shooter, der die Spieler in eine Zeitschleife versetzt, in der sie acht Ziele innerhalb eines Tages eliminieren müssen. Mit jedem neuen Durchlauf lernen die Spieler mehr über ihre Feinde, die Umgebung und ihre eigenen Fähigkeiten. Die Kombination aus Stealth-Mechaniken, Action und den cleveren Zeitschleifen-Puzzles macht „Deathloop“ zu einem einzigartigen Erlebnis. Die düstere, stilisierte Welt und die ausgefallene Story, in der rivalisierende Attentäter sich gegenseitig jagen, schaffen ein intensives und originelles Spielerlebnis, das Strategie und Geschick erfordert.',8.8),
(10,'Kena: Bridge of Spirits','Ein charmantes Action-Adventure, das sowohl durch seine wunderschöne Grafik als auch durch seine emotionale Erzählung besticht. Die Spieler begleiten Kena, eine junge Geisterführerin, auf ihrer Reise, verlorene Seelen zu befreien und die Balance in einer von magischen Kräften durchzogenen Welt wiederherzustellen. Das Spiel kombiniert Rätsel, Plattforming und herausfordernde Kämpfe, während die atemberaubende, animierte Optik den Stil eines Pixar-Films widerspiegelt. Die kleinen, hilfsbereiten Wesen, die „Rots“, verleihen dem Spiel eine zusätzliche Ebene von Strategie und Charme, während sie den Spielern im Kampf und beim Erkunden der Welt helfen.',8.7);
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id_rating` (`user_id`),
  KEY `idx_game_id_rating` (`game_id`),
  CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1,'kemu','kemu@kemu.kemu','sha256$9He5dzwiJnVxx32H$9a323fb14f6aa62340127aa6f83bd91e81f8e407d5f58751a13dd725c5819642');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-15 18:05:07
