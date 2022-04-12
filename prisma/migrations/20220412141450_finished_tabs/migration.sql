-- CreateTable
CREATE TABLE "Employee" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "username" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "address" TEXT NOT NULL,
    "bio" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Employer" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "username" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "address" TEXT NOT NULL,
    "bio" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Category" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "category_name" TEXT NOT NULL,
    "category_logo" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Project" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "price" INTEGER NOT NULL,
    "deadline" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "overview" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" INTEGER NOT NULL,
    "employee_id" INTEGER,
    "employer_id" INTEGER NOT NULL,
    "category_id" INTEGER NOT NULL,
    CONSTRAINT "Project_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Project_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "Employer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Project_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "Category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Bids" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "project_id" INTEGER NOT NULL,
    "bids" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    CONSTRAINT "Bids_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Bids_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "Project" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Reviews" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "text" TEXT NOT NULL,
    "project_id" INTEGER NOT NULL,
    "employee_id" INTEGER NOT NULL,
    "dateCreated" TEXT NOT NULL,
    CONSTRAINT "Reviews_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Reviews_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "Project" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Conversations" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "employee_id" INTEGER NOT NULL,
    "employer_id" INTEGER NOT NULL,
    CONSTRAINT "Conversations_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "Employee" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Conversations_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "Employer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Chat" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "messageText" TEXT NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "sent_by_employer" BOOLEAN NOT NULL,
    CONSTRAINT "Chat_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Employer_email_key" ON "Employer"("email");
