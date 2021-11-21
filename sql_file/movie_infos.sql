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

 Date: 04/11/2021 22:51:31
*/


-- ----------------------------
-- Table structure for movie_infos
-- ----------------------------
DROP TABLE IF EXISTS "public"."movie_infos";
CREATE TABLE "public"."movie_infos" (
  "adult" bool,
  "backdrop_path" text COLLATE "pg_catalog"."default",
  "id" int8 NOT NULL DEFAULT nextval('movie_infos_id_seq'::regclass),
  "original_language" text COLLATE "pg_catalog"."default",
  "original_title" text COLLATE "pg_catalog"."default",
  "overview" text COLLATE "pg_catalog"."default",
  "popularity" numeric,
  "poster_path" text COLLATE "pg_catalog"."default",
  "release_date" text COLLATE "pg_catalog"."default",
  "title" text COLLATE "pg_catalog"."default",
  "run_time" int8,
  "video" bool,
  "vote_average" numeric,
  "vote_count" int8
)
;
ALTER TABLE "public"."movie_infos" OWNER TO "postgres";

-- ----------------------------
-- Primary Key structure for table movie_infos
-- ----------------------------
ALTER TABLE "public"."movie_infos" ADD CONSTRAINT "movie_infos_pkey" PRIMARY KEY ("id");
