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

 Date: 04/11/2021 22:51:41
*/


-- ----------------------------
-- Table structure for person_crews
-- ----------------------------
DROP TABLE IF EXISTS "public"."person_crews";
CREATE TABLE "public"."person_crews" (
  "person_id" int8,
  "movie_id" int8,
  "id" int8 NOT NULL DEFAULT nextval('person_crews_id_seq'::regclass),
  "credit_id" text COLLATE "pg_catalog"."default",
  "department" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."person_crews" OWNER TO "postgres";

-- ----------------------------
-- Primary Key structure for table person_crews
-- ----------------------------
ALTER TABLE "public"."person_crews" ADD CONSTRAINT "person_crews_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table person_crews
-- ----------------------------
ALTER TABLE "public"."person_crews" ADD CONSTRAINT "fk_person_crews_movie_info" FOREIGN KEY ("movie_id") REFERENCES "public"."movie_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."person_crews" ADD CONSTRAINT "fk_person_infos_person_crew" FOREIGN KEY ("person_id") REFERENCES "public"."person_infos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
