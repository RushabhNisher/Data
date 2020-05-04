-- VIEW v_dim_imdb_title_principals 

 --DROP VIEW IF EXISTS v_dim_imdb_title_principals;

CREATE VIEW v_dim_imdb_title_principals AS
SELECT title_principals_sk,title_sk,name_sk,title_ordering,job_category_sk,job_title,character_name
FROM dim_imdb_title_principals
WHERE job_category_sk=2 OR job_category_sk=4;

--SELECT COUNT(*) FROM dbo.v_dim_imdb_title_principals;


-- VIEW v_dim_imdb_name_basics

-- DROP VIEW IF EXISTS v_dim_imdb_name_basics;
CREATE VIEW v_dim_imdb_name_basics AS
SELECT nconst,primaryName,birthYear,deathYear,name_imdb_url,g.genre_source,genres,primaryTitle
FROM dim_imdb_name_basics nb
JOIN dim_imdb_name_basics_knownForTitles kft
ON kft.name_sk=nb.name_sk
JOIN dim_imdb_title_basics tb
ON tb.title_sk = kft.title_sk
JOIN dim_imdb_title_basics_genres bg
ON bg.title_sk=tb.title_sk
JOIN dim_imdb_genres g
ON g.genres_sk=bg.genres_sk
WHERE (primaryName='John Cusack' OR primaryName='Ana de Armas' OR primaryName='Rian Johnson' OR primaryName='Daisy Ridley' OR 
primaryName='Samuel L. Jackson' OR primaryName='J.J. Abrams' OR primaryName='Kathryn Bigelow' OR primaryName='Nicolas Cage' OR 
primaryName='Scarlett Johansson' OR primaryName='Dwayne Johnson' OR primaryName='Emilia Clarke' OR primaryName='Woody Harrelson' OR 
primaryName='Idris Elba' OR primaryName='Sean Connery' OR primaryName='Gal Gadot')
AND (birthYear IS NOT NULL);

--SELECT COUNT(*) FROM dbo.v_dim_imdb_name_basics;


-- VIEW v_dim_imdb_name_basics_knownForTitles 

-- DROP VIEW IF EXISTS v_dim_imdb_name_basics_knownForTitles;
CREATE VIEW v_dim_imdb_name_basics_knownForTitles AS
SELECT knownForTitles_sk,kft.name_sk,title_sk
FROM dim_imdb_name_basics_knownForTitles kft
JOIN dim_imdb_name_basics nb 
ON kft.name_sk=nb.name_sk
WHERE (primaryName='John Cusack' OR primaryName='Ana de Armas' OR primaryName='Rian Johnson' OR primaryName='Daisy Ridley' OR 
primaryName='Samuel L. Jackson' OR primaryName='J.J. Abrams' OR primaryName='Kathryn Bigelow' OR primaryName='Nicolas Cage' OR 
primaryName='Scarlett Johansson' OR primaryName='Dwayne Johnson' OR primaryName='Emilia Clarke' OR primaryName='Woody Harrelson' OR 
primaryName='Idris Elba' OR primaryName='Sean Connery' OR primaryName='Gal Gadot')
AND (birthYear IS NOT NULL);

--SELECT COUNT(*) FROM dbo.v_dim_imdb_name_basics_knownForTitles;


-- VIEW v_dim_imdb_name_basics_primaryProfession

-- DROP VIEW IF EXISTS v_dim_imdb_name_basics_primaryProfession;
CREATE VIEW v_dim_imdb_name_basics_primaryProfession AS
SELECT name_basics_primaryProfession_sk,pp.name_sk,primaryProfession_sk
FROM dim_imdb_name_basics_primaryProfession pp
JOIN dim_imdb_name_basics nb 
ON pp.name_sk=nb.name_sk
WHERE (primaryName='John Cusack' OR primaryName='Ana de Armas' OR primaryName='Rian Johnson' OR primaryName='Daisy Ridley' OR 
primaryName='Samuel L. Jackson' OR primaryName='J.J. Abrams' OR primaryName='Kathryn Bigelow' OR primaryName='Nicolas Cage' OR 
primaryName='Scarlett Johansson' OR primaryName='Dwayne Johnson' OR primaryName='Emilia Clarke' OR primaryName='Woody Harrelson' OR 
primaryName='Idris Elba' OR primaryName='Sean Connery' OR primaryName='Gal Gadot')
AND (birthYear IS NOT NULL);

--SELECT COUNT(*) FROM dbo.v_dim_imdb_name_basics_primaryProfession;


-- VIEW v_topMovies

-- DROP VIEW IF EXISTS v_topMovies;
CREATE VIEW v_topMovies AS
SELECT movies_box_office_worldwide_sk,bow.title_sk,BoxOffice_Rank,Worldwide_LifetimeGross,Domestic_LifetimeGross,Domestic_Pct,
Foreign_LifetimeGross,Foreign_Pct,Release_Year,tconst, titleType_sk,movieId,imdbId,tmdbId,primaryTitle,originalTitle,ml_title
,isAdult,startYear,endYear,runtimeMinutes,title_imdb_url,genres,g.genre_source
FROM fct_movies_box_office_worldwide bow
JOIN dim_imdb_title_basics tb
ON tb.title_sk =bow.title_sk
JOIN dim_imdb_title_basics_genres bg
ON bg.title_sk=tb.title_sk
JOIN dim_imdb_genres g
ON g.genres_sk=bg.genres_sk;

--SELECT COUNT(*) FROM dbo.v_topMovies;


-- VIEW v_topMoviesPeople

-- DROP VIEW IF EXISTS v_topMoviesPeople;
CREATE VIEW v_topMoviesPeople AS
SELECT movies_box_office_worldwide_sk,bow.title_sk,BoxOffice_Rank,Worldwide_LifetimeGross,Domestic_LifetimeGross,Domestic_Pct,
Foreign_LifetimeGross,Foreign_Pct,Release_Year,tconst,movieId,imdbId,tmdbId,primaryTitle,originalTitle,ml_title
,isAdult,startYear,endYear,runtimeMinutes,title_imdb_url,tp.title_principals_sk,tp.title_ordering,tp.job_title,
tp.character_name,jc.job_category,nb.name_sk,nb.nconst,nb.primaryName,nb.birthYear,nb.deathYear, prp.primaryProfession,genres,genre_source
FROM fct_movies_box_office_worldwide bow
JOIN dim_imdb_title_basics tb
ON tb.title_sk =bow.title_sk
JOIN dim_imdb_title_principals tp
ON tp.title_sk=tb.title_sk
JOIN dim_imdb_job_category jc
ON jc.job_category_sk = tp.job_category_sk
JOIN dim_imdb_name_basics nb
ON nb.name_sk=tp.name_sk
JOIN dim_imdb_name_basics_primaryProfession pp
ON pp.name_sk=nb.name_sk
JOIN dim_imdb_primaryProfession prp
ON prp.primaryProfession_sk=pp.primaryProfession_sk
JOIN dim_imdb_name_basics_knownForTitles kft
ON kft.name_sk=nb.name_sk
JOIN dim_imdb_title_basics_genres bg
ON bg.title_sk=tb.title_sk
JOIN dim_imdb_genres g
ON g.genres_sk=bg.genres_sk;

--SELECT COUNT(*) FROM dbo.v_topMoviesPeople;


-- VIEW v_topMoviesRatings_ML

-- DROP VIEW IF EXISTS v_topMoviesRatings_ML;
CREATE VIEW v_topMoviesRatings_ML AS
SELECT title_sk,AVG(rating) Ratings
  FROM [IMDB].[dbo].[fct_ml_ratings] 
  GROUP BY title_sk;

--SELECT COUNT(*) FROM dbo.v_topMoviesRatings_ML;



-- VIEW v_topMovieGenre

-- DROP VIEW IF EXISTS v_topMovieGenre;
CREATE VIEW v_topMovieGenre AS
SELECT titles_genres_sk,tbg.title_sk,genres,genre_source
  FROM [IMDB].[dbo].[dim_imdb_title_basics_genres] tbg
  JOIN fct_movies_box_office_worldwide bow
  ON tbg.title_sk=bow.title_sk
  JOIN dim_imdb_genres g
  ON g.genres_sk=tbg.genres_sk;

--SELECT COUNT(*) FROM dbo.v_topMovieGenre;


-- 1) VIEW v_Top100

-- DROP VIEW IF EXISTS v_Top100;
CREATE VIEW v_Top100 AS
SELECT	DISTINCT TOP 390 [BoxOffice_Rank],[Worldwide_LifetimeGross],[Domestic_LifetimeGross],[Domestic_Pct],[Foreign_LifetimeGross],[Foreign_Pct],[Release_Year],
			     tb.[title_sk],[primaryTitle],[isAdult],[startYear],[runtimeMinutes],[title_imdb_url],
			     [titleType],
			     [averageRating],[numVotes],
			     [genres],g.[genre_source]
FROM [IMDB].[dbo].[fct_movies_box_office_worldwide] bow
JOIN [IMDB].[dbo].[dim_imdb_title_basics] tb
ON bow.title_sk=tb.title_sk
JOIN [IMDB].[dbo].[dim_imdb_titleType] tt
ON tt.titleType_sk=tb.titleType_sk
JOIN [IMDB].[dbo].[fct_imdb_title_ratings] tr
ON tr.title_sk=tb.title_sk
JOIN [IMDB].[dbo].[dim_imdb_title_basics_genres] bg
ON bg.title_sk=tb.title_sk
JOIN [IMDB].[dbo].[dim_imdb_genres] g
ON g.genres_sk=bg.genres_sk
ORDER BY BoxOffice_Rank ASC;


-- 2) VIEW v_Top100_People
-- DROP VIEW IF EXISTS v_Top100_People;
CREATE VIEW v_Top100_People AS
SELECT DISTINCT	TOP 1004  [BoxOffice_Rank],[primaryTitle],
       			 [title_ordering],[job_title],
				 [job_category],
				 [primaryName],[birthYear],[deathYear],[name_imdb_url], tb.[title_sk]
FROM [IMDB].[dbo].[fct_movies_box_office_worldwide] bow
LEFT JOIN [IMDB].[dbo].[dim_imdb_title_basics] tb
ON bow.title_sk=tb.title_sk
LEFT JOIN [IMDB].[dbo].[dim_imdb_title_principals] tp
ON tp.title_sk=tb.title_sk
LEFT JOIN [IMDB].[dbo].[dim_imdb_job_category] jc
ON jc.job_category_sk=tp.job_category_sk
LEFT JOIN [IMDB].[dbo].[dim_imdb_name_basics] nb
ON nb.name_sk=tp.name_sk
ORDER BY BoxOffice_Rank,title_ordering ASC
;




-- 3) VIEW v_Top25
-- DROP VIEW IF EXISTS v_Top25;
CREATE VIEW v_Top25 AS
SELECT		   tb.[title_sk],[primaryTitle],[isAdult],
					   [titleType],
					   [averageRating],[numVotes]
FROM [IMDB].[dbo].[dim_imdb_title_basics] tb
JOIN [IMDB].[dbo].[dim_imdb_titleType] tt
ON tb.titleType_sk=tt.titleType_sk
JOIN [IMDB].[dbo].[fct_imdb_title_ratings] tr
ON tr.title_sk=tb.title_sk
;



-- 4) VIEW v_MovieLens_Ratings
-- DROP VIEW IF EXISTS v_MovieLens_Ratings;
CREATE VIEW v_MovieLens_Ratings AS
SELECT	TOP 1000000	tb.title_sk, tb.ml_title,
			AVG(rating) ML_Ratings, COUNT(userId) ML_Num_Votes,
			[genres],g.[genre_source],
			[averageRating] IMDB_Rating,[numVotes] IMDB_Num_Votes
FROM [IMDB].[dbo].[fct_ml_ratings] mlr
JOIN [IMDB].[dbo].[dim_imdb_title_basics] tb
ON tb.title_sk=mlr.title_sk
JOIN [IMDB].[dbo].[dim_imdb_title_basics_genres] bg
ON bg.title_sk=tb.title_sk
JOIN [IMDB].[dbo].[dim_imdb_genres] g
ON g.genres_sk=bg.genres_sk
JOIN [IMDB].[dbo].[fct_imdb_title_ratings] tr
ON tr.title_sk=tb.title_sk
WHERE g.genre_source = 'Movie Lens' 
GROUP BY tb.title_sk, [genres],g.[genre_source],tb.ml_title,[averageRating],[numVotes]
ORDER BY IMDB_Rating DESC;




--  5) VIEW v_SelectedPeople

-- DROP VIEW IF EXISTS v_SelectedPeople;
CREATE VIEW v_SelectedPeople AS
SELECT DISTINCT tb.[title_sk],[primaryTitle],[originalTitle],[isAdult],[startYear],[endYear],[runtimeMinutes],[title_imdb_url],
				[job_category],
				[primaryName],[birthYear],[deathYear],[name_imdb_url]
FROM [IMDB].[dbo].[dim_imdb_title_basics] tb
LEFT JOIN [IMDB].[dbo].[dim_imdb_title_principals] tp
ON tp.title_sk=tb.title_sk
LEFT JOIN [IMDB].[dbo].[dim_imdb_job_category] jc
ON jc.job_category_sk=tp.job_category_sk
LEFT JOIN [IMDB].[dbo].[dim_imdb_name_basics] nb
ON nb.name_sk=tp.name_sk
WHERE (primaryName='John Cusack' OR primaryName='Ana de Armas' OR primaryName='Rian Johnson' OR primaryName='Daisy Ridley' OR 
primaryName='Samuel L. Jackson' OR primaryName='J.J. Abrams' OR primaryName='Kathryn Bigelow' OR primaryName='Nicolas Cage' OR 
primaryName='Scarlett Johansson' OR primaryName='Dwayne Johnson' OR primaryName='Emilia Clarke' OR primaryName='Woody Harrelson' OR 
primaryName='Idris Elba' OR primaryName='Sean Connery' OR primaryName='Gal Gadot')
;





--  6) VIEW v_SelectedPeople

-- DROP VIEW IF EXISTS v_SelectedPeople;
CREATE VIEW v_SelectedPeople AS
SELECT DISTINCT
