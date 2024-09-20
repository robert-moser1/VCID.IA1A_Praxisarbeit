-- Datenbank erstellen, falls sie noch nicht existiert
CREATE DATABASE IF NOT EXISTS ps5_games;

-- Datenbank verwenden
USE ps5_games;

-- Tabelle für Benutzer erstellen, falls sie noch nicht existiert
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(150) NOT NULL
);

-- Tabelle für Spiele erstellen, falls sie noch nicht existiert
CREATE TABLE IF NOT EXISTS game (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    rating FLOAT DEFAULT NULL
);

-- Tabelle für Kommentare erstellen, falls sie noch nicht existiert
CREATE TABLE IF NOT EXISTS comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    text TEXT NOT NULL,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

-- Tabelle für Favoriten erstellen, falls sie noch nicht existiert
CREATE TABLE IF NOT EXISTS favorite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

-- Tabelle für Bewertungen erstellen, falls sie noch nicht existiert
CREATE TABLE IF NOT EXISTS rating (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    score INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game(id) ON DELETE CASCADE
);

-- Create a table to store user access tokens
CREATE TABLE IF NOT EXISTS access_token (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

-- Beispiel für das Hinzufügen von Indexen, um die Suche zu beschleunigen
CREATE INDEX IF NOT EXISTS idx_user_id_comment ON comment(user_id);
CREATE INDEX IF NOT EXISTS idx_game_id_comment ON comment(game_id);
CREATE INDEX IF NOT EXISTS idx_user_id_favorite ON favorite(user_id);
CREATE INDEX IF NOT EXISTS idx_game_id_favorite ON favorite(game_id);
CREATE INDEX IF NOT EXISTS idx_user_id_rating ON rating(user_id);
CREATE INDEX IF NOT EXISTS idx_game_id_rating ON rating(game_id);

INSERT INTO game (title, description, rating) VALUES
('The Last of Us Part II', 'Ein emotional intensives Abenteuer, das die Geschichte von Ellie weiterführt und die Spieler durch eine post-apokalyptische Welt voller Gefahren und moralischer Dilemmata führt. Dieses Spiel bietet nicht nur packende Action, sondern auch eine tiefgreifende Erzählung über Verlust, Rache und Vergebung. Die Beziehungen zwischen den Charakteren sind ebenso komplex wie berührend, und die dichte Atmosphäre lässt den Spieler tief in die bedrückende und zugleich wunderschöne Welt eintauchen. Mit seinen fortschrittlichen Animationen, der realistischen Darstellung von Emotionen und einer lebendigen Umgebung setzt „The Last of Us Part II“ neue Maßstäbe für das Storytelling in Videospielen.', 9.5),
('God of War Ragnarök', 'Die Fortsetzung des gefeierten „God of War“ aus dem Jahr 2018 nimmt Kratos und seinen Sohn Atreus auf eine noch epischere Reise durch die nordische Mythologie mit. Dieses Spiel verbindet meisterhaft actiongeladene Kämpfe mit einer berührenden Vater-Sohn-Beziehung und einem tieferen Einblick in das Schicksal, die Götter und die kommende Ragnarök. Die Spieler erkunden lebendige, detaillierte Welten voller Geheimnisse, lösen anspruchsvolle Rätsel und treffen auf beeindruckende Gegner. Das Gameplay ist dynamisch und herausfordernd, und die Erzählung bleibt durch ihre Themen von Identität, Familie und Schicksal bis zum Schluss fesselnd.', 9.7),
('Demon''s Souls', 'Dieses Remake des Kultklassikers von FromSoftware ist nicht nur eine visuelle Meisterleistung, sondern bleibt auch ein Paradebeispiel für herausforderndes Gameplay. Jeder Kampf ist eine Prüfung, die Geduld, Präzision und Strategie erfordert. Die dichte, düstere Atmosphäre, kombiniert mit einem unbarmherzigen Schwierigkeitsgrad, zieht die Spieler in eine mysteriöse Welt voller Schrecken und Rätsel. Durch die hervorragende technische Umsetzung auf der PS5 mit beeindruckenden Lichteffekten, detailreichen Umgebungen und flüssigen Animationen wird dieses Remake zu einem der beeindruckendsten Titel der neuen Konsolengeneration.', 9.3),
('Spider-Man: Miles Morales', 'Diese Fortsetzung zu „Marvel''s Spider-Man“ versetzt die Spieler in die Rolle von Miles Morales, einem jungen Helden mit seinen eigenen einzigartigen Kräften. Mit einer packenden Handlung, die Themen wie Verantwortung, Erbe und Selbstfindung erkundet, entfaltet sich die Geschichte in einer visuell beeindruckenden Open World. New York wird durch die fortschrittliche Grafik und die Nutzung der PS5-Hardware lebendig, und die nahtlosen Übergänge zwischen Zwischensequenzen und Gameplay sorgen für ein filmisches Erlebnis. Die agilen, spektakulären Kampftechniken von Miles sowie die neuen Fähigkeiten, wie die Unsichtbarkeit und bioelektrische Schläge, heben das Gameplay auf ein neues Level.', 9.2),
('Ratchet & Clank: Rift Apart', 'Ein actiongeladenes Abenteuer, das von den Möglichkeiten der PS5-Hardware profitiert und nahtlose Übergänge zwischen verschiedenen Dimensionen ermöglicht. Die Spieler erleben rasante Kämpfe, springen durch Risse zwischen verschiedenen Welten und nutzen ein riesiges Arsenal an verrückten Waffen. „Rift Apart“ beeindruckt mit seiner technischen Brillanz, den kreativen Level-Designs und der flüssigen Action. Gleichzeitig bleibt das Spiel seiner humorvollen und charmanten Erzählweise treu, während es neue Charaktere wie Rivet einführt und das Universum von Ratchet & Clank weiter ausbaut.', 9.1),
('Horizon Forbidden West', 'In dieser atemberaubenden Fortsetzung von „Horizon Zero Dawn“ nimmt Aloy ihre Reise in einer offenen, post-apokalyptischen Welt wieder auf, in der Maschinenwesen die Erde beherrschen. „Forbidden West“ erweitert das Gameplay mit neuen Mechaniken, darunter Unterwassererkundungen und erweiterte Kletterfähigkeiten. Die Geschichte bietet tiefe Einblicke in die Vergangenheit der Menschheit und die Ursprünge der Maschinenplage. Mit einer beeindruckenden Grafik, die sowohl die Umgebungen als auch die Charaktere detailliert darstellt, und einem abwechslungsreichen Kampfsystem, das Taktik und Geschick erfordert, bietet das Spiel ein packendes und immersives Erlebnis.', 9.4),
('Final Fantasy XVI', 'Das neueste Kapitel der berühmten „Final Fantasy“-Reihe entführt die Spieler in eine düstere, mittelalterliche Fantasy-Welt, die von politischen Intrigen, epischen Schlachten und mächtigen Beschwörungen geprägt ist. Mit seiner atemberaubenden Grafik und einem tiefgehenden, actionorientierten Kampfsystem setzt „Final Fantasy XVI“ auf dynamische Kämpfe, packende Bosskämpfe und ein immersives Storytelling. Die Welt von Valisthea, durchzogen von Konflikten und Magie, bietet eine epische Geschichte voller Verrat, Schicksal und dem Kampf um Freiheit.', 9.0),
('Returnal', 'Ein innovativer Roguelike-Shooter, der durch seine anspruchsvollen Mechaniken und eine dichte Atmosphäre hervorsticht. Die Spieler schlüpfen in die Rolle einer Astronautin, die auf einem fremden Planeten in einer Zeitschleife gefangen ist und sich mit jedem Tod neu beginnt. Die Kämpfe sind intensiv und fordern schnelle Reaktionen, während die prozedural generierten Level eine unvorhersehbare Herausforderung darstellen. Mit einer düsteren und geheimnisvollen Erzählung über Trauma und Wiedergeburt ist „Returnal“ sowohl narrativ als auch spielerisch einzigartig. Die dichte Soundkulisse und das ständige Gefühl der Isolation tragen zur packenden Atmosphäre bei.', 8.9),
('Deathloop', 'Ein revolutionärer Ego-Shooter, der die Spieler in eine Zeitschleife versetzt, in der sie acht Ziele innerhalb eines Tages eliminieren müssen. Mit jedem neuen Durchlauf lernen die Spieler mehr über ihre Feinde, die Umgebung und ihre eigenen Fähigkeiten. Die Kombination aus Stealth-Mechaniken, Action und den cleveren Zeitschleifen-Puzzles macht „Deathloop“ zu einem einzigartigen Erlebnis. Die düstere, stilisierte Welt und die ausgefallene Story, in der rivalisierende Attentäter sich gegenseitig jagen, schaffen ein intensives und originelles Spielerlebnis, das Strategie und Geschick erfordert.', 8.8),
('Kena: Bridge of Spirits', 'Ein charmantes Action-Adventure, das sowohl durch seine wunderschöne Grafik als auch durch seine emotionale Erzählung besticht. Die Spieler begleiten Kena, eine junge Geisterführerin, auf ihrer Reise, verlorene Seelen zu befreien und die Balance in einer von magischen Kräften durchzogenen Welt wiederherzustellen. Das Spiel kombiniert Rätsel, Plattforming und herausfordernde Kämpfe, während die atemberaubende, animierte Optik den Stil eines Pixar-Films widerspiegelt. Die kleinen, hilfsbereiten Wesen, die „Rots“, verleihen dem Spiel eine zusätzliche Ebene von Strategie und Charme, während sie den Spielern im Kampf und beim Erkunden der Welt helfen.', 8.7);
