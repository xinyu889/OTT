/*
 Navicat Premium Data Transfer

 Source Server         : TMDB
 Source Server Type    : PostgreSQL
 Source Server Version : 140000
 Source Host           : localhost:5432
 Source Catalog        : movieDB
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 140000
 File Encoding         : 65001

 Date: 04/11/2021 22:51:04
*/


-- ----------------------------
-- Table structure for genres_movies
-- ----------------------------
DROP TABLE IF EXISTS "public"."genres_movies";
CREATE TABLE "public"."genres_movies" (
  "movie_info_id" int8 NOT NULL,
  "genre_info_id" int8 NOT NULL,
  "id" int8 NOT NULL DEFAULT nextval('genres_movies_id_seq'::regclass)
)
;
ALTER TABLE "public"."genres_movies" OWNER TO "postgres";

-- ----------------------------
-- Uniques structure for table genres_movies
-- ----------------------------
ALTER TABLE "public"."genres_movies" ADD CONSTRAINT "genres_movies_unique" UNIQUE ("genre_info_id", "movie_info_id");

-- ----------------------------
-- Primary Key structure for table genres_movies
-- ----------------------------
ALTER TABLE "public"."genres_movies" ADD CONSTRAINT "genres_movies_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table genres_movies
-- ----------------------------
ALTER TABLE "public"."genres_movies" ADD CONSTRAINT "fk_genres_movies_genre_info" FOREIGN KEY ("genre_info_id") REFERENCES "public"."genre_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."genres_movies" ADD CONSTRAINT "fk_genres_movies_movie_info" FOREIGN KEY ("movie_info_id") REFERENCES "public"."movie_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
