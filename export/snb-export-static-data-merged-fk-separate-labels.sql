-- static-data-merged-fk-separate-labels
COPY (SELECT id, name, url, isLocatedIn_Place AS isLocatedIn_Country FROM Organisation WHERE type = 'Company')
  TO 'data/static-data-merged-fk-separate-labels/Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url, isLocatedIn_Place AS isLocatedIn_City FROM Organisation WHERE type = 'University')
  TO 'data/static-data-merged-fk-separate-labels/University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Place WHERE type = 'Continent')
  TO 'data/static-data-merged-fk-separate-labels/Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url, isPartOf_Place AS isPartOf_Continent FROM Place WHERE type = 'Country')
  TO 'data/static-data-merged-fk-separate-labels/Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url, isPartOf_Place AS isPartOf_Country FROM Place WHERE type = 'City')
  TO 'data/static-data-merged-fk-separate-labels/City.csv'
  WITH (HEADER, DELIMITER '|');
