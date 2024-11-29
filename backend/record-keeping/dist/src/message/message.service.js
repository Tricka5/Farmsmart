"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MessageService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const db_1 = require("../db");
const drizzle_orm_1 = require("drizzle-orm");
let MessageService = class MessageService {
    async addMessage(data) {
        const [message] = await db_1.db
            .insert(schema_1.messagesTable)
            .values(data)
            .returning();
        return message;
    }
    catch(error) {
        console.error('failed to send message', error);
        throw new common_1.InternalServerErrorException('failed to send message');
    }
    async getMessagesByInboxId(id) {
        return await db_1.db
            .select()
            .from(schema_1.messagesTable)
            .where((0, drizzle_orm_1.eq)(schema_1.messagesTable.inboxid, id))
            .execute();
    }
};
exports.MessageService = MessageService;
exports.MessageService = MessageService = __decorate([
    (0, common_1.Injectable)()
], MessageService);
//# sourceMappingURL=message.service.js.map