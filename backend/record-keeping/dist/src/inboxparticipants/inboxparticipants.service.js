"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.InboxparticipantsService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const db_1 = require("../db");
const drizzle_orm_1 = require("drizzle-orm");
let InboxparticipantsService = class InboxparticipantsService {
    async addParticipant(data) {
        const [inboxParticipant] = await db_1.db
            .insert(schema_1.inboxParticipantsTable)
            .values(data)
            .returning();
        return inboxParticipant;
    }
    catch(error) {
        throw new common_1.InternalServerErrorException('failed creating inbox participants');
    }
    async getInboxParticipant(userId) {
        const [inboxparticipant] = await db_1.db
            .select()
            .from(schema_1.inboxParticipantsTable)
            .where((0, drizzle_orm_1.eq)(schema_1.inboxParticipantsTable.firstuserid, userId))
            .execute();
        return inboxparticipant || null;
    }
    async getAllinbox(ids) {
        try {
            const results = await db_1.db
                .select()
                .from(schema_1.inboxParticipantsTable)
                .where((0, drizzle_orm_1.sql) `${schema_1.inboxParticipantsTable.firstuserid} IN (${drizzle_orm_1.sql.join(ids, ',')})`)
                .execute();
            return results.length > 0 ? results : null;
        }
        catch (error) {
            throw new common_1.InternalServerErrorException(error);
            return null;
        }
    }
    async getUserFromUsersTable(userids) {
        try {
            const result = await db_1.db.query.usersTable.findMany({
                where: (inboxParticipantsTable, { or, eq, not }) => {
                    const conditions = userids
                        .map(id => eq(schema_1.usersTable.userid, id));
                    return or(...conditions);
                },
            });
            return result;
        }
        catch (error) {
            throw new common_1.InternalServerErrorException(error);
            return null;
        }
    }
    async getCurrentInbox(otheruser, currentuser) {
        try {
            const result = await db_1.db
                .select({ inboxid: schema_1.inboxParticipantsTable.inboxid })
                .from(schema_1.inboxParticipantsTable)
                .where((0, drizzle_orm_1.sql) `(${schema_1.inboxParticipantsTable.firstuserid} = ${currentuser} AND ${schema_1.inboxParticipantsTable.seconduserid} = ${otheruser})`
                .append((0, drizzle_orm_1.sql) ` OR (${schema_1.inboxParticipantsTable.firstuserid} = ${otheruser} AND ${schema_1.inboxParticipantsTable.seconduserid} = ${currentuser})`))
                .execute();
            if (result.length === 0) {
                throw new common_1.NotFoundException(`Inbox not found for users: ${otheruser}, ${currentuser}`);
            }
            return result[0];
        }
        catch (error) {
            throw new common_1.InternalServerErrorException('Failed to retrieve inbox');
        }
    }
    async getFriends(id) {
        const result = await db_1.db
            .select({ secondinboxid: schema_1.inboxParticipantsTable.seconduserid })
            .from(schema_1.inboxParticipantsTable)
            .where((0, drizzle_orm_1.eq)(schema_1.inboxParticipantsTable.firstuserid, id))
            .execute();
        return result;
    }
};
exports.InboxparticipantsService = InboxparticipantsService;
exports.InboxparticipantsService = InboxparticipantsService = __decorate([
    (0, common_1.Injectable)()
], InboxparticipantsService);
//# sourceMappingURL=inboxparticipants.service.js.map