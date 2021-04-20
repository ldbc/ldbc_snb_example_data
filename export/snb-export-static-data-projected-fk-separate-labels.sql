-- static-data-projected-fk-separate-labels
COPY (SELECT id, name, url FROM Organisation WHERE type = 'Company')
  TO 'data/static-data-projected-fk-separate-labels/Company.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Organisation WHERE type = 'University')
  TO 'data/static-data-projected-fk-separate-labels/University.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_Country FROM Organisation WHERE type = 'Company')
  TO 'data/static-data-projected-fk-separate-labels/Company_isLocatedIn_Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isLocatedIn_Place AS isLocatedIn_City FROM Organisation WHERE type = 'University')
  TO 'data/static-data-projected-fk-separate-labels/University_isLocatedIn_City.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Place WHERE type = 'Continent')
  TO 'data/static-data-projected-fk-separate-labels/Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Place WHERE type = 'Country')
  TO 'data/static-data-projected-fk-separate-labels/Country.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, name, url FROM Place WHERE type = 'City')
  TO 'data/static-data-projected-fk-separate-labels/City.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place FROM Place WHERE type = 'Country')
  TO 'data/static-data-projected-fk-separate-labels/Country_isPartOf_Continent.csv'
  WITH (HEADER, DELIMITER '|');

COPY (SELECT id, isPartOf_Place FROM Place WHERE type = 'City')
  TO 'data/static-data-projected-fk-separate-labels/City_isPartOf_Country.csv'
  WITH (HEADER, DELIMITER '|');
