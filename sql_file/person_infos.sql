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

 Date: 04/11/2021 22:51:51
*/


-- ----------------------------
-- Table structure for person_infos
-- ----------------------------
DROP TABLE IF EXISTS "public"."person_infos";
CREATE TABLE "public"."person_infos" (
  "adult" bool,
  "gender" int8,
  "id" int8 NOT NULL DEFAULT nextval('person_infos_id_seq'::regclass),
  "department" text COLLATE "pg_catalog"."default",
  "name" text COLLATE "pg_catalog"."default",
  "popularity" numeric,
  "profile_path" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."person_infos" OWNER TO "postgres";

-- ----------------------------
-- Primary Key structure for table person_infos
-- ----------------------------
ALTER TABLE "public"."person_infos" ADD CONSTRAINT "person_infos_pkey" PRIMARY KEY ("id");
