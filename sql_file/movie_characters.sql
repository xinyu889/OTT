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

 Date: 04/11/2021 22:51:19
*/


-- ----------------------------
-- Table structure for movie_characters
-- ----------------------------
DROP TABLE IF EXISTS "public"."movie_characters";
CREATE TABLE "public"."movie_characters" (
  "person_id" int8,
  "movie_id" int8,
  "id" int8 NOT NULL DEFAULT nextval('movie_characters_id_seq'::regclass),
  "character" text COLLATE "pg_catalog"."default",
  "credit_id" text COLLATE "pg_catalog"."default",
  "order" int8
)
;
ALTER TABLE "public"."movie_characters" OWNER TO "postgres";

-- ----------------------------
-- Primary Key structure for table movie_characters
-- ----------------------------
ALTER TABLE "public"."movie_characters" ADD CONSTRAINT "movie_characters_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table movie_characters
-- ----------------------------
ALTER TABLE "public"."movie_characters" ADD CONSTRAINT "fk_movie_characters_movie_info" FOREIGN KEY ("movie_id") REFERENCES "public"."movie_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."movie_characters" ADD CONSTRAINT "fk_person_infos_movie_character" FOREIGN KEY ("person_id") REFERENCES "public"."person_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
