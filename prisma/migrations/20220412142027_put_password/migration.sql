/*
  Warnings:

  - Added the required column `password` to the `Employee` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `Employer` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Employee" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "username" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "address" TEXT NOT NULL,
    "bio" TEXT NOT NULL
);
INSERT INTO "new_Employee" ("address", "avatar", "bio", "email", "full_name", "id", "phone", "username") SELECT "address", "avatar", "bio", "email", "full_name", "id", "phone", "username" FROM "Employee";
DROP TABLE "Employee";
ALTER TABLE "new_Employee" RENAME TO "Employee";
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");
CREATE TABLE "new_Employer" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "username" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "address" TEXT NOT NULL,
    "bio" TEXT NOT NULL
);
INSERT INTO "new_Employer" ("address", "avatar", "bio", "email", "full_name", "id", "phone", "username") SELECT "address", "avatar", "bio", "email", "full_name", "id", "phone", "username" FROM "Employer";
DROP TABLE "Employer";
ALTER TABLE "new_Employer" RENAME TO "Employer";
CREATE UNIQUE INDEX "Employer_email_key" ON "Employer"("email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
