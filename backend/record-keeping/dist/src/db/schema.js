"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ledgerAccountEntry = exports.ledgerAccount = exports.cashBookTable = exports.inboxParticipantsTable = exports.messagesTable = exports.inboxTable = exports.usersTable = void 0;
require("dotenv/config");
const pg_core_1 = require("drizzle-orm/pg-core");
exports.usersTable = (0, pg_core_1.pgTable)('users', {
    userid: (0, pg_core_1.serial)('userid').primaryKey(),
    firstname: (0, pg_core_1.text)('firstname').notNull(),
    lastname: (0, pg_core_1.text)('lastname').notNull(),
    profilepicture: (0, pg_core_1.text)('profilepicture'),
    email: (0, pg_core_1.text)('email').unique(),
    password: (0, pg_core_1.text)('password').notNull(),
    activationstatus: (0, pg_core_1.boolean)('activationstatus').notNull(),
});
exports.inboxTable = (0, pg_core_1.pgTable)('inbox', {
    inboxid: (0, pg_core_1.serial)('inboxid').primaryKey(),
    lastmessage: (0, pg_core_1.text)('lastmessage'),
});
exports.messagesTable = (0, pg_core_1.pgTable)('messages', {
    inboxid: (0, pg_core_1.integer)('inboxid')
        .notNull()
        .references(() => exports.inboxTable.inboxid, { onDelete: 'cascade' }),
    userid: (0, pg_core_1.integer)('userid')
        .notNull()
        .references(() => exports.usersTable.userid, { onDelete: 'cascade' }),
    message: (0, pg_core_1.text)('message'),
    createdat: (0, pg_core_1.timestamp)('createdat').defaultNow(),
});
exports.inboxParticipantsTable = (0, pg_core_1.pgTable)('inboxparticipants', {
    userid: (0, pg_core_1.integer)('userid')
        .notNull()
        .references(() => exports.usersTable.userid, { onDelete: 'cascade' }),
    inboxid: (0, pg_core_1.integer)('inboxid')
        .notNull()
        .references(() => exports.inboxTable.inboxid, { onDelete: 'cascade' }),
}, (table) => {
    return {
        pk: (0, pg_core_1.primaryKey)({ columns: [table.userid, table.inboxid] }),
    };
});
exports.cashBookTable = (0, pg_core_1.pgTable)('cash_book', {
    id: (0, pg_core_1.serial)('id').primaryKey(),
    dr_date_of_transaction: (0, pg_core_1.timestamp)('cr_date_of_transaction').defaultNow(),
    dr_product_name: (0, pg_core_1.text)('cr_product_name').notNull(),
    dr_contractor: (0, pg_core_1.text)('cr_contractor').notNull(),
    cr_date_of_transaction: (0, pg_core_1.timestamp)('cr_date_of_transaction').defaultNow(),
    cr_product_name: (0, pg_core_1.text)('cr_product_name').notNull(),
    cr_contractor: (0, pg_core_1.text)('cr_contractor').notNull(),
});
exports.ledgerAccount = (0, pg_core_1.pgTable)('legderAccount', {
    ledgerAccountid: (0, pg_core_1.serial)('ledgerAccountid').primaryKey(),
    itemname: (0, pg_core_1.text)('itemname').notNull(),
    transactor: (0, pg_core_1.text)('transactor').notNull(),
    type: (0, pg_core_1.text)('type').notNull(),
    date: (0, pg_core_1.timestamp)('date').defaultNow(),
});
exports.ledgerAccountEntry = (0, pg_core_1.pgTable)('legderAccountEntry', {
    id: (0, pg_core_1.serial)('id').primaryKey(),
    type: (0, pg_core_1.text)('type').notNull(),
    description: (0, pg_core_1.text)('description').notNull(),
    amount: (0, pg_core_1.integer)('amount').notNull(),
    date: (0, pg_core_1.timestamp)('date').defaultNow(),
    ledgerAccountid: (0, pg_core_1.integer)('ledgerAccountId')
        .notNull()
        .references(() => exports.ledgerAccount.ledgerAccountid, { onDelete: 'cascade' }),
});
//# sourceMappingURL=schema.js.map