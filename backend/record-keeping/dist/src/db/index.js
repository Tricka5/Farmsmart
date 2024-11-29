"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.db = void 0;
const dotenv_1 = require("dotenv");
const postgres_js_1 = require("drizzle-orm/postgres-js");
const postgres = require("postgres");
const schema_1 = require("./schema");
(0, dotenv_1.config)({ path: '.env' });
const client = postgres(process.env.DATABASE_URL);
exports.db = (0, postgres_js_1.drizzle)(client, {
    schema: {
        inboxTable: schema_1.inboxTable,
        inboxParticipantsTable: schema_1.inboxParticipantsTable,
        usersTable: schema_1.usersTable,
    },
});
//# sourceMappingURL=index.js.map