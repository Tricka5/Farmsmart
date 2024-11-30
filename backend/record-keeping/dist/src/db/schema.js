"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.livestock_record = exports.crop_record = exports.livestock = exports.crop = exports.ledgerAccountEntry = exports.ledgerAccount = exports.cashBookTable = exports.inboxParticipantsTable = exports.messagesTable = exports.inboxTable = exports.usersTable = void 0;
require("dotenv/config");
const pg_core_1 = require("drizzle-orm/pg-core");
exports.usersTable = (0, pg_core_1.pgTable)('users', {
    userid: (0, pg_core_1.serial)('userid').primaryKey(),
    firstname: (0, pg_core_1.text)('firstname').notNull(),
    lastname: (0, pg_core_1.text)('lastname').notNull(),
    profilepicture: (0, pg_core_1.text)('profilepicture').notNull(),
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
    firstuserid: (0, pg_core_1.integer)('userid')
        .notNull()
        .references(() => exports.usersTable.userid, { onDelete: 'cascade' }),
    seconduserid: (0, pg_core_1.integer)('currentuser')
        .notNull()
        .references(() => exports.usersTable.userid, { onDelete: 'cascade' }),
    inboxid: (0, pg_core_1.integer)('inboxid')
        .notNull()
        .references(() => exports.inboxTable.inboxid, { onDelete: 'cascade' }),
}, (table) => {
    return {
        pk: (0, pg_core_1.primaryKey)({ columns: [table.firstuserid, table.seconduserid] }),
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
exports.crop = (0, pg_core_1.pgTable)('crop', {
    cropid: (0, pg_core_1.serial)('cropid').primaryKey(),
    name: (0, pg_core_1.text)('name').notNull(),
    quality: (0, pg_core_1.text)('quality').notNull(),
    status: (0, pg_core_1.text)('status').notNull(),
});
exports.livestock = (0, pg_core_1.pgTable)('livestock', {
    livestockid: (0, pg_core_1.serial)('livestockid').primaryKey(),
    breed: (0, pg_core_1.text)('breed').notNull(),
    age: (0, pg_core_1.integer)('age').notNull(),
    quantity: (0, pg_core_1.integer)('quantity').notNull(),
    healthy_status: (0, pg_core_1.text)('healthy_status').notNull(),
});
exports.crop_record = (0, pg_core_1.pgTable)('crop_record', {
    crop_record_id: (0, pg_core_1.serial)('crop_record_id').primaryKey(),
    data: (0, pg_core_1.text)('data'),
    activity: (0, pg_core_1.text)('activity'),
    notes: (0, pg_core_1.text)('notes'),
});
exports.livestock_record = (0, pg_core_1.pgTable)('livestock_record', {
    livestock_record_id: (0, pg_core_1.serial)('livestock_record_id').primaryKey(),
    data: (0, pg_core_1.text)('data'),
    activity: (0, pg_core_1.text)('activity'),
    notes: (0, pg_core_1.text)('notes'),
});
//# sourceMappingURL=schema.js.map