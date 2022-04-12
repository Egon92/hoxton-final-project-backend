/*
  Warnings:

  - You are about to drop the column `participantId` on the `Conversations` table. All the data in the column will be lost.
  - You are about to drop the column `conversations` on the `Chat` table. All the data in the column will be lost.
  - You are about to drop the column `employee_id` on the `Chat` table. All the data in the column will be lost.
  - You are about to drop the column `employer_id` on the `Chat` table. All the data in the column will be lost.
  - Added the required column `conversation_id` to the `Chat` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sent_by_employer` to the `Chat` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Conversations" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "employee_id" INTEGER NOT NULL,
    "employer_id" INTEGER NOT NULL,
    CONSTRAINT "Conversations_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Conversations_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "Employer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Conversations" ("employee_id", "employer_id", "id") SELECT "employee_id", "employer_id", "id" FROM "Conversations";
DROP TABLE "Conversations";
ALTER TABLE "new_Conversations" RENAME TO "Conversations";
CREATE TABLE "new_Chat" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "messageText" TEXT NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "sent_by_employer" BOOLEAN NOT NULL,
    CONSTRAINT "Chat_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Chat" ("id", "messageText") SELECT "id", "messageText" FROM "Chat";
DROP TABLE "Chat";
ALTER TABLE "new_Chat" RENAME TO "Chat";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
