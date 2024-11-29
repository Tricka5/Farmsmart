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
        console.error('failed creating inbox participants', error);
        throw new common_1.InternalServerErrorException('failed creating inbox participants');
    }
    async getInboxParticipant(userId) {
        const [inboxparticipant] = await db_1.db
            .select()
            .from(schema_1.inboxParticipantsTable)
            .where((0, drizzle_orm_1.eq)(schema_1.inboxParticipantsTable.userid, userId))
            .execute();
        return inboxparticipant || null;
    }
    async getAllinbox(ids) {
        try {
            const results = await db_1.db
                .select()
                .from(schema_1.inboxParticipantsTable)
                .where((0, drizzle_orm_1.sql) `${schema_1.inboxParticipantsTable.userid} IN (${drizzle_orm_1.sql.join(ids, ',')})`)
                .execute();
            return results.length > 0 ? results : null;
        }
        catch (error) {
            console.error('Error fetching inbox participants:', error);
            return null;
        }
    }
    async getUsers(ids) {
        console.log('I am in service', ids);
        if (ids.length === 0) {
            return null;
        }
        try {
            const result = await db_1.db.query.inboxParticipantsTable.findMany({
                where: (inboxParticipantsTable, { or, eq }) => {
                    const conditions = ids.map(id => eq(inboxParticipantsTable.inboxid, id));
                    return or(...conditions);
                },
            });
            console.log('Fetched result:', result);
            return result;
        }
        catch (error) {
            console.error('Error fetching users:', error);
            return null;
        }
    }
    async getUserFromUsersTable(userids, userIdCurrent) {
        try {
            const result = await db_1.db.query.usersTable.findMany({
                where: (inboxParticipantsTable, { or, eq, not }) => {
                    const conditions = userids
                        .filter(id => id !== userIdCurrent)
                        .map(id => eq(schema_1.usersTable.userid, id));
                    return or(...conditions);
                },
            });
            console.log('Fetched users for:', result);
            return result;
        }
        catch (error) {
            console.error('Error fetching users:', error);
            return null;
        }
    }
    async getCurrentInbox(otheruser, currentuser) {
        const users = [otheruser, currentuser];
        try {
            const result = await db_1.db
                .select({ inboxid: schema_1.inboxParticipantsTable.inboxid })
                .from(schema_1.inboxParticipantsTable)
                .where((0, drizzle_orm_1.inArray)(schema_1.inboxParticipantsTable.userid, users))
                .groupBy(schema_1.inboxParticipantsTable.inboxid)
                .having((0, drizzle_orm_1.sql) `${(0, drizzle_orm_1.countDistinct)(schema_1.inboxParticipantsTable.userid)} = ${users.length}`)
                .execute();
            if (result.length === 0) {
                throw new common_1.NotFoundException(`Inbox not found for users: ${otheruser}, ${currentuser}`);
            }
            return result;
        }
        catch (error) {
            console.error('Error fetching inbox for users:', otheruser, currentuser, error);
            throw new common_1.InternalServerErrorException('Failed to retrieve inbox');
        }
    }
};
exports.InboxparticipantsService = InboxparticipantsService;
exports.InboxparticipantsService = InboxparticipantsService = __decorate([
    (0, common_1.Injectable)()
], InboxparticipantsService);
//# sourceMappingURL=inboxparticipants.service.js.map