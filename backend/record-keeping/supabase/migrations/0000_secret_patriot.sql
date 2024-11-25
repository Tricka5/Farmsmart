CREATE TABLE IF NOT EXISTS "cash_book" (
	"id" serial PRIMARY KEY NOT NULL,
	"cr_date_of_transaction" timestamp DEFAULT now(),
	"cr_product_name" text NOT NULL,
	"cr_contractor" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "inboxparticipants" (
	"userid" integer NOT NULL,
	"inboxid" integer NOT NULL,
	CONSTRAINT "inboxparticipants_userid_inboxid_pk" PRIMARY KEY("userid","inboxid")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "inbox" (
	"inboxid" serial PRIMARY KEY NOT NULL,
	"lastmessage" text
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "legderAccount" (
	"ledgerAccountid" serial PRIMARY KEY NOT NULL,
	"itemname" text NOT NULL,
	"transactor" text NOT NULL,
	"type" text NOT NULL,
	"date" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "legderAccountEntry" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"description" text NOT NULL,
	"amount" integer NOT NULL,
	"date" timestamp DEFAULT now(),
	"ledgerAccountId" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "messages" (
	"inboxid" integer NOT NULL,
	"userid" integer NOT NULL,
	"message" text,
	"createdat" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "users" (
	"userid" serial PRIMARY KEY NOT NULL,
	"firstname" text NOT NULL,
	"lastname" text NOT NULL,
	"profilepicture" text,
	"email" text,
	"password" text,
	"activationstatus" boolean,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "inboxparticipants" ADD CONSTRAINT "inboxparticipants_userid_users_userid_fk" FOREIGN KEY ("userid") REFERENCES "public"."users"("userid") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "inboxparticipants" ADD CONSTRAINT "inboxparticipants_inboxid_inbox_inboxid_fk" FOREIGN KEY ("inboxid") REFERENCES "public"."inbox"("inboxid") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "legderAccountEntry" ADD CONSTRAINT "legderAccountEntry_ledgerAccountId_legderAccount_ledgerAccountid_fk" FOREIGN KEY ("ledgerAccountId") REFERENCES "public"."legderAccount"("ledgerAccountid") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_inboxid_inbox_inboxid_fk" FOREIGN KEY ("inboxid") REFERENCES "public"."inbox"("inboxid") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_userid_users_userid_fk" FOREIGN KEY ("userid") REFERENCES "public"."users"("userid") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
