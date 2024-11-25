
import { table } from 'console';
import 'dotenv/config';
import { pgTable, serial, text, integer, timestamp, primaryKey, boolean } from 'drizzle-orm/pg-core';

// Define your tablesimport { pgTable, serial, text, boolean } from 'drizzle-orm/pg-core';

export const usersTable = pgTable('users', {
    userid: serial('userid').primaryKey(),
    firstname: text('firstname').notNull(),
    lastname: text('lastname').notNull(),
    profilepicture: text('profilepicture'),
    email: text('email').unique(),
    password: text('password').notNull(),
    activationstatus: boolean('activationstatus').notNull(),
  });
    

export const inboxTable = pgTable('inbox', {
    inboxid: serial('inboxid').primaryKey(),
    lastmessage: text('lastmessage'),
});

export const messagesTable = pgTable('messages', {
    inboxid: integer('inboxid')
        .notNull()
        .references(() => inboxTable.inboxid, { onDelete: 'cascade' }),
    userid: integer('userid')
        .notNull()
        .references(() => usersTable.userid, { onDelete: 'cascade' }),
    message: text('message'),
    createdat: timestamp('createdat').defaultNow(),
}
);


export const inboxParticipantsTable = pgTable('inboxparticipants', {
    userid: integer('userid')
        .notNull()
        .references(() => usersTable.userid, { onDelete: 'cascade' }),
    inboxid: integer('inboxid')
        .notNull()
        .references(() => inboxTable.inboxid, { onDelete: 'cascade' }),
},
(table)=>{
    return{
        pk: primaryKey({ columns: [table.userid, table.inboxid] }),
    }
});




export const cashBookTable=pgTable('cash_book',{
    id:serial('id').primaryKey(),
    dr_date_of_transaction:timestamp('cr_date_of_transaction').defaultNow(),
    dr_product_name:text('cr_product_name').notNull(),
    dr_contractor:text('cr_contractor').notNull(),


    cr_date_of_transaction:timestamp('cr_date_of_transaction').defaultNow(),
    cr_product_name:text('cr_product_name').notNull(),
    cr_contractor:text('cr_contractor').notNull(),
})

export const ledgerAccount = pgTable('legderAccount', {
    ledgerAccountid: serial('ledgerAccountid').primaryKey(),  // Example column
    itemname:text('itemname').notNull(),
    transactor:text('transactor').notNull(),
    type:text('type').notNull(),//expense ledger / income ledger
    date: timestamp('date').defaultNow(),
});
export const ledgerAccountEntry = pgTable('legderAccountEntry', {
    id: serial('id').primaryKey(),  // Example column
    type:text('type').notNull(),//dr /cr
    
    description: text('description').notNull(),  // Add any relevant columns
    amount: integer('amount').notNull(),
    date: timestamp('date').defaultNow(),
    ledgerAccountid: integer('ledgerAccountId')
        .notNull()
        .references(() => ledgerAccount.ledgerAccountid, { onDelete: 'cascade' }),
    
});
export type insertledgerAccount=typeof ledgerAccount.$inferInsert;
export type selectledgerAccount=typeof ledgerAccount.$inferSelect;


export type insertledgerAccountEntry=typeof ledgerAccountEntry.$inferInsert;
export type selectledgerAccountEntry=typeof ledgerAccountEntry.$inferSelect;

export type insertcashBookTable=typeof cashBookTable.$inferInsert;
export type selectcashBookTable=typeof cashBookTable.$inferSelect;


export type insertUsers=typeof usersTable.$inferInsert;
export type selectUsers=typeof usersTable.$inferSelect;

export type insertInbox=typeof inboxTable.$inferInsert;
export type selectInbox=typeof inboxTable.$inferSelect;

export type insertInboxParticipants=typeof inboxParticipantsTable.$inferInsert;
export type selectInboxParticpants=typeof inboxParticipantsTable.$inferSelect;

export type insertMessages=typeof messagesTable.$inferInsert;
export type selectMessages=typeof messagesTable.$inferSelect;

// Define the schema interface
export type selectUser=typeof usersTable.$inferSelect;
export type insertUser=typeof usersTable.$inferInsert;