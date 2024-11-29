"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.InboxService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const db_1 = require("../db");
let InboxService = class InboxService {
    async createEntry(data) {
        try {
            const [inbox] = await db_1.db
                .insert(schema_1.inboxTable)
                .values(data)
                .returning();
            return inbox;
        }
        catch (error) {
            console.error('Error creating converstaion entry', error);
            throw new common_1.InternalServerErrorException('failed creating conversation entry');
        }
    }
};
exports.InboxService = InboxService;
exports.InboxService = InboxService = __decorate([
    (0, common_1.Injectable)()
], InboxService);
//# sourceMappingURL=inbox.service.js.map