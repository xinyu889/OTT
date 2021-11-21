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

 Date: 04/11/2021 22:50:01
*/


-- ----------------------------
-- Table structure for genre_infos
-- ----------------------------
DROP TABLE IF EXISTS "public"."genre_infos";
CREATE TABLE "public"."genre_infos" (
  "id" int8 NOT NULL DEFAULT nextval('genre_infos_id_seq'::regclass),
  "name" text COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6),
  "updated_at" timestamptz(6),
  "deleted_at" timestamptz(6)
)
;
ALTER TABLE "public"."genre_infos" OWNER TO "postgres";

-- ----------------------------
-- Indexes structure for table genre_infos
-- ----------------------------
CREATE INDEX "idx_genre_infos_deleted_at" ON "public"."genre_infos" USING btree (
  "deleted_at" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table genre_infos
-- ----------------------------
ALTER TABLE "public"."genre_infos" ADD CONSTRAINT "genre_infos_pkey" PRIMARY KEY ("id");
